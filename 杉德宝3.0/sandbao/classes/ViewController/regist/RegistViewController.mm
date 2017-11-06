//
//  RegistViewController.m
//  sandbao
//
//  Created by tianNanYiHao on 2017/10/17.
//  Copyright © 2017年 sand. All rights reserved.
//

#import "RegistViewController.h"
#import "PayNucHelper.h"

#import "SmsCheckViewController.h"
@interface RegistViewController ()
{
    
}
@property (nonatomic, strong) NSString *phoneNoStr; //手机号
@property (nonatomic, strong) NSArray *authToolsArray;  //鉴权工具组
@property (nonatomic, strong) NSArray *regAuthToolsArray; //待更新鉴权工具组
@end

@implementation RegistViewController
@synthesize phoneNoStr;
@synthesize authToolsArray;
@synthesize regAuthToolsArray;


- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
    //流程每次进入均刷新
    //注册流程开始
    authToolsArray = nil;
    regAuthToolsArray = nil;
    [self getAuthToolsRegAuthTools];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self createUI];
    
    
    
}
#pragma mark - 重写父类-baseScrollView设置
- (void)setBaseScrollview{
    [super setBaseScrollview];
    
}
#pragma mark - 重写父类-导航设置方法
- (void)setNavCoverView{
    [super setNavCoverView];
    self.navCoverView.letfImgStr = @"login_icon_back";

    __block RegistViewController *weakSelf = self;
    self.navCoverView.leftBlock = ^{
        [weakSelf.navigationController popViewControllerAnimated:YES];
    };
}
#pragma mark - 重写父类-点击方法集合
- (void)buttonClick:(UIButton *)btn{
    
    if (btn.tag == BTN_TAG_NEXT) {
        //下一步
        if (phoneNoStr.length > 0) {
            if (authToolsArray.count>0) {
                for (int i = 0; i<authToolsArray.count; i++) {
                    NSDictionary *authToolDic = authToolsArray[i];
                    if ([[authToolDic objectForKey:@"type"] isEqualToString:@"sms"]) {
                        SmsCheckViewController *smsVC = [[SmsCheckViewController alloc] init];
                        smsVC.phoneNoStr = phoneNoStr;
                        smsVC.smsCheckType = SMS_CHECKTYPE_REGIST;
                        [self.navigationController pushViewController:smsVC animated:YES];
                    }else{
                        [Tool showDialog:@"下发鉴权工具有误"];
                    }
                }
            }else{
                [Tool showDialog:@"下发鉴权工具为空"];
            }
        }else{
            [Tool showDialog:@"请输入正确的登陆账号及密码"];
        }
    }
    if (btn.tag == BTN_TAG_LOGIN) {
        //返回- 登录页
        [self.navigationController popViewControllerAnimated:YES];
    }
    
}

#pragma mark  - UI绘制
- (void)createUI{
    
    //titleLab1
    UILabel *titleLab = [Tool createLable:@"输入你的手机号" attributeStr:nil font:FONT_28_Medium textColor:COLOR_343339 alignment:NSTextAlignmentCenter];
    [self.baseScrollView addSubview:titleLab];
    
    
    //PhoneAuthToolView
    PhoneAuthToolView *phoneAuthToolView = [PhoneAuthToolView createAuthToolViewOY:0];
    phoneAuthToolView.titleLab.text = @"你的手机号";
    phoneAuthToolView.textfiled.text = SHOWTOTEST(@"15151474888");
    phoneAuthToolView.textfiled.placeholder = @"输入手机号";
    phoneAuthToolView.tip.text = @"请输入正确手机号";
    phoneAuthToolView.successBlock = ^(NSString *textfieldText) {
        phoneNoStr = textfieldText;
    };
    [self.baseScrollView addSubview:phoneAuthToolView];
    
    
    //nextBtn
    UIButton *nextBarbtn = [Tool createBarButton:@"继续" font:FONT_15_Regular titleColor:COLOR_FFFFFF backGroundColor:COLOR_58A5F6 leftSpace:LEFTRIGHTSPACE_40];
    nextBarbtn.tag = BTN_TAG_NEXT;
    [nextBarbtn addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.baseScrollView addSubview:nextBarbtn];
    
    //comeBackLogBtn
    NSMutableAttributedString *registAttributeStr = [[NSMutableAttributedString alloc] initWithString:@"已有账号, 立即登陆"];
    [registAttributeStr addAttributes:@{
                                        NSFontAttributeName:FONT_14_Regular,
                                        NSForegroundColorAttributeName:COLOR_358BEF
                                        } range:NSMakeRange(6, 4)];
    UIButton *comeBackLogBtn = [Tool createButton:@"" attributeStr:registAttributeStr font:FONT_14_Regular textColor:COLOR_343339_7];
    [comeBackLogBtn addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    comeBackLogBtn.tag = BTN_TAG_LOGIN;
    [self.baseScrollView addSubview:comeBackLogBtn];
    
    
    //frame
    [titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.baseScrollView.mas_top).offset(UPDOWNSPACE_64);
        make.centerX.equalTo(self.baseScrollView.mas_centerX);
        make.size.mas_equalTo(titleLab.size);
    }];
    
    
    [phoneAuthToolView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.baseScrollView.mas_centerX);
        make.top.equalTo(titleLab.mas_bottom).offset(UPDOWNSPACE_89);
        make.size.mas_equalTo(phoneAuthToolView.size);
    }];
    
    
    [nextBarbtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(phoneAuthToolView.mas_bottom).offset(UPDOWNSPACE_40);
        make.centerX.equalTo(self.baseScrollView.mas_centerX);
        make.size.mas_equalTo(nextBarbtn.size);
    }];
    
    [comeBackLogBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(nextBarbtn.mas_bottom).offset(UPDOWNSPACE_47);
        make.centerX.equalTo(self.baseScrollView.mas_centerX);
        make.size.mas_equalTo(comeBackLogBtn.size);
    }];
    
}


#pragma mark - 业务逻辑
#pragma mark 获取鉴权工具(authTools)/待注册鉴权工具(regAuthTools)
- (void)getAuthToolsRegAuthTools
{
    self.HUD = [SDMBProgressView showSDMBProgressOnlyLoadingINViewImg:self.view];
    [SDRequestHelp shareSDRequest].HUD = self.HUD;
    [SDRequestHelp shareSDRequest].controller = self;
    [[SDRequestHelp shareSDRequest] dispatchGlobalQuque:^{
        __block BOOL error = NO;
        
        [[SDRequestHelp shareSDRequest] requestWihtFuncName:@"token/getStoken/v1" errorBlock:^(SDRequestErrorType type) {
            error = YES;
        } successBlock:^{
            
        }];
        if (error) return ;
        
        
        
        paynuc.set("tTokenType", "01000101");
        [[SDRequestHelp shareSDRequest] requestWihtFuncName:@"token/getTtoken/v1" errorBlock:^(SDRequestErrorType type) {
            error = YES;
        } successBlock:^{
            
        }];
        if (error) return ;
        
        
        [[SDRequestHelp shareSDRequest] requestWihtFuncName:@"authTool/getAuthTools/v1" errorBlock:^(SDRequestErrorType type) {
            error = YES;
        } successBlock:^{
            NSString *authTools = [NSString stringWithUTF8String:paynuc.get("authTools").c_str()];
            //获取鉴权工具集组
            authToolsArray = [[PayNucHelper sharedInstance] jsonStringToArray:authTools];
        }];
        if (error) return ;
        
        
        
        [[SDRequestHelp shareSDRequest] requestWihtFuncName:@"authTool/getRegAuthTools/v1" errorBlock:^(SDRequestErrorType type) {
            error = YES;
        } successBlock:^{
            [[SDRequestHelp shareSDRequest] dispatchToMainQueue:^{
                [self.HUD hidden];
                
                NSString *regAuthTools = [NSString stringWithUTF8String:paynuc.get("regAuthTools").c_str()];
                //获取待更新鉴权工具集组
                regAuthToolsArray = [[PayNucHelper sharedInstance] jsonStringToArray:regAuthTools];
                
                
            }];
        }];
        if (error) return ;
    }];
    
}




- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
