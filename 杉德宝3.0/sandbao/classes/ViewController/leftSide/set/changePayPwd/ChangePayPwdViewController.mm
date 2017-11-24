//
//  ChangePayPwdViewController.m
//  sandbao
//
//  Created by tianNanYiHao on 2017/11/6.
//  Copyright © 2017年 sand. All rights reserved.
//

#import "ChangePayPwdViewController.h"
#import "PayNucHelper.h"


#define SIX_CODE_STATE_INPUT_FIRST 80001
#define SIX_CODE_STATE_INPUT_AGAIN 80002
#define SIX_CODE_STATE_CHECK_OK    80003

@interface ChangePayPwdViewController ()
{
    // reg鉴权工具集组
    NSArray *regAuthToolsArr;
    
}
@property (nonatomic, strong) NSString *sixCodeStr; // 6位密码
@property (nonatomic, assign) NSInteger SIX_CODE_STATE;
@end

@implementation ChangePayPwdViewController



- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
    self.SIX_CODE_STATE = SIX_CODE_STATE_INPUT_FIRST;
    
    [self createUI];
    
    //查询待注册鉴权工具
    [self getRegAuthTools];
}


#pragma mark - 重写父类-baseScrollView设置
- (void)setBaseScrollview{
    [super setBaseScrollview];
    
}
#pragma mark - 重写父类-导航设置方法
- (void)setNavCoverView{
    [super setNavCoverView];
    self.navCoverView.letfImgStr = @"login_icon_back";
    
    __weak ChangePayPwdViewController *weakSelf = self;
    self.navCoverView.leftBlock = ^{
        [weakSelf.navigationController popViewControllerAnimated:YES];
    };
    
}
#pragma mark - 重写父类-点击方法集合
- (void)buttonClick:(UIButton *)btn{
    
    if (btn.tag == BTN_TAG_NEXT) {
        
        if (self.SIX_CODE_STATE == SIX_CODE_STATE_CHECK_OK) {
            //验证支付密码不重复,查询带注册鉴权
            [self setRegAuthTools];
            
        }
        if (self.SIX_CODE_STATE == SIX_CODE_STATE_INPUT_AGAIN || self.SIX_CODE_STATE == SIX_CODE_STATE_INPUT_FIRST) {
            [self.baseScrollView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
            [self createUI];
        }
        
        
        
    }
    
}



#pragma mark  - UI绘制
- (void)createUI{
    
    __weak typeof(self) weakself = self;
    //titleLab1
    UILabel *titleLab = [Tool createLable:@"修改支付密码" attributeStr:nil font:FONT_28_Medium textColor:COLOR_343339 alignment:NSTextAlignmentCenter];
    [self.baseScrollView addSubview:titleLab];
    
    //titleLab2
    UILabel *titleDesLab;
    if (self.SIX_CODE_STATE == SIX_CODE_STATE_INPUT_FIRST) {
        NSString *titleDesStr = [NSString stringWithFormat:@"请为%@设置一个新的支付密码",[CommParameter sharedInstance].userName];
        titleDesLab = [Tool createLable:titleDesStr attributeStr:nil font:FONT_16_Regular textColor:COLOR_343339_7 alignment:NSTextAlignmentCenter];
    }
    if (self.SIX_CODE_STATE == SIX_CODE_STATE_INPUT_AGAIN) {
        titleDesLab = [Tool createLable:@"再次输入6位数字支付密码" attributeStr:nil font:FONT_16_Regular textColor:COLOR_343339_7 alignment:NSTextAlignmentCenter];
    }
    [self.baseScrollView addSubview:titleDesLab];
    
    //payCodeAuthTool:sixCodeAuthToolView
    SixCodeAuthToolView *payCodeAuthTool = [SixCodeAuthToolView createAuthToolViewOY:0];
    payCodeAuthTool.style = PayCodeAuthTool;
    payCodeAuthTool.successBlock = ^(NSString *textfieldText) {
        
        if (weakself.sixCodeStr.length == 0) {
            weakself.sixCodeStr = textfieldText;
            weakself.SIX_CODE_STATE = SIX_CODE_STATE_INPUT_AGAIN;
        }
        else if (weakself.sixCodeStr.length > 0) {
            if ([weakself.sixCodeStr isEqualToString:textfieldText]) {
                weakself.SIX_CODE_STATE = SIX_CODE_STATE_CHECK_OK;
            }else{
                weakself.SIX_CODE_STATE = SIX_CODE_STATE_INPUT_FIRST;
                weakself.sixCodeStr = nil;
            }
        }
    };
    [self.baseScrollView addSubview:payCodeAuthTool];
    
    
    //nextBtn
    UIButton *nextBarbtn = [Tool createBarButton:@"继续" font:FONT_15_Regular titleColor:COLOR_FFFFFF backGroundColor:COLOR_58A5F6 leftSpace:LEFTRIGHTSPACE_40];
    nextBarbtn.tag = BTN_TAG_NEXT;
    [nextBarbtn addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.baseScrollView addSubview:nextBarbtn];
    
    [titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.baseScrollView.mas_top).offset(UPDOWNSPACE_64);
        make.centerX.equalTo(self.baseScrollView.mas_centerX);
        make.size.mas_equalTo(titleLab.size);
    }];
    
    [titleDesLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(titleLab.mas_bottom).offset(UPDOWNSPACE_14);
        make.centerX.equalTo(self.baseScrollView.mas_centerX);
        make.size.mas_equalTo(titleDesLab.size);
    }];
    
    [payCodeAuthTool mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(titleDesLab.mas_bottom).offset(UPDOWNSPACE_58);
        make.centerX.equalTo(self.baseScrollView.mas_centerX);
        make.size.mas_equalTo(payCodeAuthTool.size);
    }];
    
    [nextBarbtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(payCodeAuthTool.mas_bottom).offset(UPDOWNSPACE_40);
        make.centerX.equalTo(self.baseScrollView.mas_centerX);
        make.size.mas_equalTo(nextBarbtn.size);
    }];
}


#pragma mark - 业务逻辑
#pragma mark 查询设置支付密码-鉴权工具
- (void)getRegAuthTools{
    self.HUD = [SDMBProgressView showSDMBProgressOnlyLoadingINViewImg:self.view];
    [SDRequestHelp shareSDRequest].HUD = self.HUD;
    [SDRequestHelp shareSDRequest].controller = self;
    [[SDRequestHelp shareSDRequest] dispatchGlobalQuque:^{
        __block BOOL error = NO;
        [[SDRequestHelp shareSDRequest] requestWihtFuncName:@"authTool/getRegAuthTools/v1" errorBlock:^(SDRequestErrorType type) {
            error = YES;
            [[SDRequestHelp shareSDRequest] dispatchToMainQueue:^{
                //返回
                [self.navigationController popViewControllerAnimated:YES];
            }];
        } successBlock:^{
            [[SDRequestHelp shareSDRequest] dispatchToMainQueue:^{
                [self.HUD hidden];
                
                NSString *regAuthTools = [NSString stringWithUTF8String:paynuc.get("regAuthTools").c_str()];
                regAuthToolsArr = [[PayNucHelper sharedInstance] jsonStringToArray:regAuthTools];
                if (![[[regAuthToolsArr firstObject] objectForKey:@"type"] isEqualToString:@"paypass"]) {
                    [Tool showDialog:@"下发鉴权工具有误"];
                }
                
                
                
            }];
        }];
        if (error) return ;
    }];
    
}


#pragma mark 提交设置支付密码-鉴权工具
- (void)setRegAuthTools{
    
    self.HUD = [SDMBProgressView showSDMBProgressOnlyLoadingINViewImg:self.view];
    [SDRequestHelp shareSDRequest].HUD = self.HUD;
    [SDRequestHelp shareSDRequest].controller = self;
    [[SDRequestHelp shareSDRequest] dispatchGlobalQuque:^{
        __block BOOL error = NO;
        
        NSMutableArray *tempArray = [[NSMutableArray alloc] init];
        
        NSMutableDictionary *authToolDict = regAuthToolsArr[0];
        NSMutableDictionary *authToolsDic = [NSMutableDictionary dictionaryWithDictionary:authToolDict];
        //[authToolsDic removeObjectForKey:@"pass"];
        NSMutableDictionary *passDic = [[NSMutableDictionary alloc] init];
        [passDic setValue:[[PayNucHelper sharedInstance] pinenc:self.sixCodeStr type:@"paypass"] forKey:@"password"];
        [passDic setValue:@"sand" forKey:@"encryptType"];
        [authToolsDic setObject:passDic forKey:@"pass"];
        [tempArray addObject:authToolsDic];
        NSString *regAuthTools = [[PayNucHelper sharedInstance] arrayToJSON:tempArray];
        
        paynuc.set("regAuthTools", [regAuthTools UTF8String]);
        [[SDRequestHelp shareSDRequest] requestWihtFuncName:@"authTool/setRegAuthTools/v1" errorBlock:^(SDRequestErrorType type) {
            error = YES;
            [[SDRequestHelp shareSDRequest] dispatchToMainQueue:^{
                //返回
                [self.navigationController popViewControllerAnimated:YES];
            }];
        } successBlock:^{
            [[SDRequestHelp shareSDRequest] dispatchToMainQueue:^{
                [self.HUD hidden];
                [Tool showDialog:@"支付密码修改成功" defulBlock:^{
                    [CommParameter sharedInstance].payPassFlag = YES;
                    //pop返回主页
                    [self.navigationController popToRootViewControllerAnimated:YES];
                }];
                
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
