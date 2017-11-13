//
//  ForgetLoginPwdViewController.m
//  sandbao
//
//  Created by tianNanYiHao on 2017/11/10.
//  Copyright © 2017年 sand. All rights reserved.
//

#import "ForgetLoginPwdViewController.h"
#import "PayNucHelper.h"

#import "VerifyTypeViewController.h"

@interface ForgetLoginPwdViewController ()
{
    
}
@property (nonatomic, strong) NSString * phoneNum;
@end

@implementation ForgetLoginPwdViewController
@synthesize phoneNum;

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    //申请虚拟sToken/tToken/获取鉴权
    [self getStokenAndtTokenAndgetAuthTools];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self createUI];
}

#pragma mark - 重写父类-baseScrollView设置
- (void)setBaseScrollview{
    [super setBaseScrollview];
    self.baseScrollView.scrollEnabled = YES;
}

#pragma mark - 重写父类-导航设置方法
- (void)setNavCoverView{
    [super setNavCoverView];
    self.navCoverView.style = NavCoverStyleWhite;
    self.navCoverView.letfImgStr = @"general_icon_back";

    __block ForgetLoginPwdViewController *weakSelf = self;
    self.navCoverView.leftBlock = ^{
        [weakSelf.navigationController popViewControllerAnimated:YES];
    };
    
    
}
#pragma mark - 重写父类-点击方法集合
- (void)buttonClick:(UIButton *)btn{
    if (btn.tag == BTN_TAG_NEXT) {
        if (phoneNum.length>0) {
            //@"忘记登录密码"
            //上送鉴权工具 + 校验用户
            [self setAuthToolsAndCheckUser];
        }
    }
}

#pragma mark  - UI绘制
- (void)createUI{
    
    //titleLab1
    UILabel *titleLab = [Tool createLable:@"输入要找回密码的账号" attributeStr:nil font:FONT_28_Medium textColor:COLOR_343339 alignment:NSTextAlignmentCenter];
    [self.baseScrollView addSubview:titleLab];
    
    //PhoneAuthToolView
    PhoneAuthToolView *phoneAuthToolView = [PhoneAuthToolView createAuthToolViewOY:0];
    phoneAuthToolView.titleLab.text = @"你的手机号";
    phoneAuthToolView.tip.text = @"请输入格式正确的手机号";
    phoneAuthToolView.textfiled.text = SHOWTOTEST(@"15151474188");
    phoneNum = SHOWTOTEST(@"15151474188");;
    phoneAuthToolView.successBlock = ^(NSString *textfieldText) {
        phoneNum = textfieldText;
    };
    [self.baseScrollView addSubview:phoneAuthToolView];
    
    //nextBtn
    UIButton *nextBarbtn = [Tool createBarButton:@"继续" font:FONT_15_Regular titleColor:COLOR_FFFFFF backGroundColor:COLOR_58A5F6 leftSpace:LEFTRIGHTSPACE_40];
    nextBarbtn.tag = BTN_TAG_NEXT;
    [nextBarbtn addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.baseScrollView addSubview:nextBarbtn];
    
    //frame
    [titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.baseScrollView.mas_top).offset(UPDOWNSPACE_69);
        make.centerX.equalTo(self.baseScrollView);
        make.size.mas_equalTo(titleLab.size);
    }];
    
    [phoneAuthToolView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(titleLab.mas_bottom).offset(UPDOWNSPACE_89);
        make.centerX.equalTo(self.baseScrollView.mas_centerX);
        make.size.mas_equalTo(phoneAuthToolView.size);
    }];
    
    [nextBarbtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(phoneAuthToolView.mas_bottom).offset(UPDOWNSPACE_69);
        make.centerX.equalTo(self.baseScrollView.mas_centerX);
        make.size.mas_equalTo(nextBarbtn.size);
    }];
}

#pragma mark - 业务逻辑
#pragma mark 申请虚拟sToken / tToken /获取鉴权
- (void)getStokenAndtTokenAndgetAuthTools{
    
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
        
        paynuc.set("tTokenType", "01000401");
        [[SDRequestHelp shareSDRequest] requestWihtFuncName:@"token/getTtoken/v1" errorBlock:^(SDRequestErrorType type) {
            error = YES;
        } successBlock:^{
            
        }];
        if (error) return;
        
        [[SDRequestHelp shareSDRequest] requestWihtFuncName:@"authTool/getAuthTools/v1" errorBlock:^(SDRequestErrorType type) {
            error = YES;
        } successBlock:^{
            [[SDRequestHelp shareSDRequest] dispatchToMainQueue:^{
                [self.HUD hidden];
            }];
        }];

    }];
}
#pragma mark 上送鉴权工具 + 校验用户
- (void)setAuthToolsAndCheckUser{
    self.HUD = [SDMBProgressView showSDMBProgressOnlyLoadingINViewImg:self.view];
    [SDRequestHelp shareSDRequest].HUD = self.HUD;
    [SDRequestHelp shareSDRequest].controller = self;
    [[SDRequestHelp shareSDRequest] dispatchGlobalQuque:^{
        __block BOOL error = NO;
        
        paynuc.set("authTools", "[]");
        [[SDRequestHelp shareSDRequest] requestWihtFuncName:@"authTool/setAuthTools/v1" errorBlock:^(SDRequestErrorType type) {
            error = YES;
        } successBlock:^{
            
        }];
        if (error) return ;
        
        
        //验证用户数否存在
        NSMutableDictionary *userInfoDic = [[NSMutableDictionary alloc] init];
        [userInfoDic setValue:phoneNum forKey:@"userName"];
        NSString *userInfo = [[PayNucHelper sharedInstance] dictionaryToJson:userInfoDic];
        [SDLog logTest:userInfo];
        
        paynuc.set("userInfo", [userInfo UTF8String]);
        [[SDRequestHelp shareSDRequest] requestWihtFuncName:@"user/checkUser/v1" errorBlock:^(SDRequestErrorType type) {
            error = YES;
        } successBlock:^{
            [[SDRequestHelp shareSDRequest] dispatchToMainQueue:^{
                [self.HUD hidden];
                
                //跳转校验类型页面
                VerifyTypeViewController *verifyTypeVC = [[VerifyTypeViewController alloc] init];
                verifyTypeVC.verifyType = VERIFY_TYPE_FORGETLOGPWD;
                [self.navigationController pushViewController:verifyTypeVC animated:YES];
            }];
        }];
        if (error) return ;
    }];
}




- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
