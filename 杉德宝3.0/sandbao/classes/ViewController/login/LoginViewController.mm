//
//  LoginViewController.m
//  sandbao
//
//  Created by tianNanYiHao on 2017/10/13.
//  Copyright © 2017年 sand. All rights reserved.
//

#import "LoginViewController.h"
#import "PayNucHelper.h"

#import "RegistViewController.h"
#import "SmsCheckViewController.h"


@interface LoginViewController ()
{
    
}
@property (nonatomic, strong) NSString * phoneNum;
@property (nonatomic, strong) NSString * loginPwd;
@property (nonatomic, strong) NSMutableArray *authToolsArray;
@end


@implementation LoginViewController
@synthesize phoneNum;
@synthesize loginPwd;
@synthesize authToolsArray;


-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self load];
}

- (void)viewDidLoad {
    [super viewDidLoad];

    
    [self clearSmsTimeOut];
    
    [self createUI];
    
}
- (void)clearSmsTimeOut{
    //清空上一次用户误操作留下的timeOut
    [SixCodeAuthToolView cleanCurrentTimeOut];
}
#pragma mark - 重写父类-baseScrollView设置
- (void)setBaseScrollview{
    [super setBaseScrollview];
    self.baseScrollView.scrollEnabled = YES;
    self.baseScrollView.frame = CGRectMake(0, UPDOWNSPACE_20, SCREEN_WIDTH, SCREEN_HEIGHT-UPDOWNSPACE_20);
}

#pragma mark - 重写父类-导航设置方法
- (void)setNavCoverView{
    [super setNavCoverView];
    self.navCoverView.hidden = YES;
}
#pragma mark - 重写父类-点击方法集合
- (void)buttonClick:(UIButton *)btn{
    
    if (btn.tag == BTN_TAG_FORGETPWD) {
        //忘记密码
        NSLog(@"点击了忘记密码");
    }
    if (btn.tag == BTN_TAG_LOGIN) {
        //登录
        if (phoneNum.length>0 && loginPwd.length>0) {
            [self loginUser];
        }else{
            [Tool showDialog:@"请输入正确的登陆账号及密码"];
        }
    }
    if (btn.tag == BTN_TAG_REGIST) {
        //注册
        RegistViewController *regVc = [[RegistViewController alloc] init];
        [self.navigationController pushViewController:regVc animated:YES];
    }
    
}

#pragma mark  - UI绘制
- (void)createUI{
    
    //titleLab1
    UILabel *titleLab = [Tool createLable:@"欢迎回来" attributeStr:nil font:FONT_28_Medium textColor:COLOR_343339 alignment:NSTextAlignmentLeft];
    [self.baseScrollView addSubview:titleLab];
    
    
    //titleLab2
    UILabel *titleDesLab = [Tool createLable:@"继续登录" attributeStr:nil font:FONT_16_Regular textColor:COLOR_343339_7 alignment:NSTextAlignmentLeft];
    [self.baseScrollView addSubview:titleDesLab];
    
    //PhoneAuthToolView
    PhoneAuthToolView *phoneAuthToolView = [PhoneAuthToolView createAuthToolViewOY:0];
    phoneAuthToolView.tip.text = @"请输入能登陆的手机号";
    phoneAuthToolView.textfiled.text = SHOWTOTEST(@"15151474688");
    phoneNum = SHOWTOTEST(@"15151474688");;
    phoneAuthToolView.successBlock = ^(NSString *textfieldText) {
        phoneNum = textfieldText;
    };
    [self.baseScrollView addSubview:phoneAuthToolView];
    
    //PwdAuthToolView
    PwdAuthToolView *pwdAuthToolView = [PwdAuthToolView createAuthToolViewOY:0];
    pwdAuthToolView.tip.text = @"密码必须包含8-20位的字母数字组合";
    pwdAuthToolView.textfiled.text = SHOWTOTEST(@"qqqqqq111");
    loginPwd = SHOWTOTEST(@"qqqqqq111");
    pwdAuthToolView.successBlock = ^(NSString *textfieldText) {
        loginPwd = textfieldText;
    };
    [self.baseScrollView addSubview:pwdAuthToolView];
    
    //forgetPwd
    UIButton *forgetBtn = [Tool createButton:@"忘记密码?" attributeStr:nil font:FONT_14_Regular textColor:COLOR_343339_7];
    forgetBtn.tag = BTN_TAG_FORGETPWD;
    [forgetBtn addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.baseScrollView addSubview:forgetBtn];
    
    //logintBtn
    UIButton *loginBarbtn = [Tool createBarButton:@"登录" font:FONT_15_Regular titleColor:COLOR_FFFFFF backGroundColor:COLOR_58A5F6 leftSpace:LEFTRIGHTSPACE_40];
    loginBarbtn.tag = BTN_TAG_LOGIN;
    [loginBarbtn addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.baseScrollView addSubview:loginBarbtn];
    
    //registBtn
    NSMutableAttributedString *registAttributeStr = [[NSMutableAttributedString alloc] initWithString:@"新用户? 注册"];
    [registAttributeStr addAttributes:@{
                                        NSFontAttributeName:FONT_14_Regular,
                                        NSForegroundColorAttributeName:COLOR_358BEF
                                       } range:NSMakeRange(5, 2)];
    UIButton *registbtn = [Tool createButton:@"" attributeStr:registAttributeStr font:FONT_14_Regular textColor:COLOR_343339_7];
    [registbtn addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    registbtn.tag = BTN_TAG_REGIST;
    [self.baseScrollView addSubview:registbtn];
    
    
    //frame
    [titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.baseScrollView.mas_top).offset(UPDOWNSPACE_112);
        make.left.equalTo(self.baseScrollView.mas_left).offset(LEFTRIGHTSPACE_35);
        make.size.mas_equalTo(titleLab.size);
    }];
    
    [titleDesLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(titleLab.mas_bottom).offset(UPDOWNSPACE_15);
        make.left.equalTo(titleLab);
        make.size.mas_equalTo(titleDesLab.size);
    }];
    
    [phoneAuthToolView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(titleDesLab.mas_bottom).offset(UPDOWNSPACE_58);
        make.centerX.equalTo(self.baseScrollView.mas_centerX);
        make.size.mas_equalTo(phoneAuthToolView.size);
    }];
    
    [pwdAuthToolView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(phoneAuthToolView.mas_bottom).offset(UPDOWNSPACE_0);
        make.centerX.equalTo(self.baseScrollView.mas_centerX);
        make.size.mas_equalTo(pwdAuthToolView.size);
    }];
    
    [forgetBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(pwdAuthToolView.mas_bottom).offset(UPDOWNSPACE_25);
        make.right.equalTo(pwdAuthToolView.mas_right).offset(-LEFTRIGHTSPACE_40);
        make.size.mas_equalTo(forgetBtn.size);
    }];
    
    [loginBarbtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(forgetBtn.mas_bottom).offset(UPDOWNSPACE_28);
        make.centerX.equalTo(self.baseScrollView.mas_centerX);
        make.size.mas_equalTo(loginBarbtn.size);
    }];
    
    [registbtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(loginBarbtn.mas_bottom).offset(UPDOWNSPACE_28);
        make.centerX.equalTo(self.baseScrollView.mas_centerX);
        make.size.mas_equalTo(registbtn.size);
    }];
    
}

#pragma mark - 业务逻辑
#pragma mark 获取登陆鉴权工具

/**
 *@brief 获取鉴权工具
 *@return NSArray
 */
- (void)load
{
    authToolsArray = [[NSMutableArray alloc] init];
    
    self.HUD = [SDMBProgressView showSDMBProgressOnlyLoadingINViewImg:self.view];
    [SDRequestHelp shareSDRequest].HUD = self.HUD;
    [SDRequestHelp shareSDRequest].controller = self;
    [[SDRequestHelp shareSDRequest] dispatchGlobalQuque:^{
        __block BOOL error = NO;
        
        //获取未登录钱sToken(虚拟)
        paynuc.set("creditFp", "684599B093B8F673A9BE6A7F2AC4E45E");
        [[SDRequestHelp shareSDRequest] requestWihtFuncName:@"token/getStoken/v1" errorBlock:^(SDRequestErrorType type) {
            error = YES;
            [[SDRequestHelp shareSDRequest] dispatchToMainQueue:^{
                if (type == respCodeErrorType) {
                    NSString *respMsg = [NSString stringWithUTF8String:paynuc.get("respMsg").c_str()];
                    [Tool showDialog:respMsg defulBlock:^{
                        //退出处理
                        [self exitApplication];
                    }];
                }
                else{
                    [Tool showDialog:@"网络请求失败,请退出重试" defulBlock:^{
                        //退出处理
                        [self exitApplication];
                    }];
                }
            }];
        } successBlock:^{
            
        }];
        if (error) return;
        
        paynuc.set("tTokenType", "01000201");
        [[SDRequestHelp shareSDRequest] requestWihtFuncName:@("token/getTtoken/v1") errorBlock:^(SDRequestErrorType type) {
            error = YES;
            [[SDRequestHelp shareSDRequest] dispatchToMainQueue:^{
                if (type == respCodeErrorType) {
                    NSString *respMsg = [NSString stringWithUTF8String:paynuc.get("respMsg").c_str()];
                    [Tool showDialog:respMsg defulBlock:^{
                        [self exitApplication];
                    }];
                }
                else{
                    [Tool showDialog:@"网络请求失败,请退出重试" defulBlock:^{
                        [self exitApplication];
                    }];
                }
            }];
        } successBlock:^{
            
        }];
        if (error) return;
        
        
        [[SDRequestHelp shareSDRequest] requestWihtFuncName:@"authTool/getAuthTools/v1" errorBlock:^(SDRequestErrorType type) {
            error = YES;
            [[SDRequestHelp shareSDRequest] dispatchToMainQueue:^{
                if (type == respCodeErrorType) {
                    NSString *respMsg = [NSString stringWithUTF8String:paynuc.get("respMsg").c_str()];
                    [Tool showDialog:respMsg defulBlock:^{
                        [self exitApplication];
                    }];
                }
                else{
                    [Tool showDialog:@"网络请求失败,请退出重试" defulBlock:^{
                        [self exitApplication];
                    }];
                }
            }];
        } successBlock:^{
            [[SDRequestHelp shareSDRequest] dispatchToMainQueue:^{
                [self.HUD hidden];
                NSString *AuthToolstr = [NSString stringWithUTF8String:paynuc.get("authTools").c_str()];
                NSArray *authToolsArr = [[PayNucHelper sharedInstance] jsonStringToArray:AuthToolstr];
                
                if (authToolsArr.count>0) {
                    for (int i = 0; i < authToolsArr.count; i++) {
                        [authToolsArray addObject:authToolsArr[i]];
                    }
                }else{
                     [Tool showDialog:@"无鉴权工具下发"];
                }
                
            }];
        }];
        if (error) return;
        
    }];
}


#pragma mark 用户登陆
/**
 *@brief 用户登录
 */
- (void)loginUser
{
    self.HUD = [SDMBProgressView showSDMBProgressOnlyLoadingINViewImg:self.view];
    [SDRequestHelp shareSDRequest].HUD = self.HUD;
    [SDRequestHelp shareSDRequest].controller = self;
    [[SDRequestHelp shareSDRequest] dispatchGlobalQuque:^{
        __block BOOL error = NO;
        //校验手机验证码
        NSMutableArray * authToolSArr = [[NSMutableArray alloc] init];
        NSMutableDictionary *authToolsDic1 = [[NSMutableDictionary alloc] init];
        [authToolsDic1 setValue:@"loginpass" forKey:@"type"];
        NSMutableDictionary *passDic = [[NSMutableDictionary alloc] init];
        [passDic setValue:@"sand" forKey:@"encryptType"];
        [passDic setValue:[NSString stringWithUTF8String:paynuc.lgnenc([loginPwd UTF8String]).c_str()] forKey:@"password"];
        [authToolsDic1 setObject:passDic forKey:@"pass"];
        [authToolSArr addObject:authToolsDic1];
        NSString *authTools = [[PayNucHelper sharedInstance] arrayToJSON:authToolSArr];
        
        NSMutableDictionary *userInfoDic = [[NSMutableDictionary alloc] init];
        [userInfoDic setValue:phoneNum forKey:@"userName"];
        NSString *userInfo = [[PayNucHelper sharedInstance] dictionaryToJson:userInfoDic];

        paynuc.set("authTools", [authTools UTF8String]);
        paynuc.set("userInfo", [userInfo UTF8String]);
        [[SDRequestHelp shareSDRequest] requestWihtFuncName:@"user/login/v1" errorBlock:^(SDRequestErrorType type) {
            error = YES;
            if (type == respCodeErrorType) {
                [[SDRequestHelp shareSDRequest] dispatchToMainQueue:^{
                    NSString *respCode = [NSString stringWithUTF8String:paynuc.get("respCode").c_str()];
                    if ([@"030005" isEqualToString:respCode]){
                        NSString *tempAuthTools = [NSString stringWithUTF8String:paynuc.get("authTools").c_str()];
                        NSArray *tempAuthToolsArray = [[PayNucHelper sharedInstance] jsonStringToArray:tempAuthTools];                        
                        if (tempAuthToolsArray.count>0) {
                            for (int i = 0; i<tempAuthToolsArray.count; i++) {
                                NSDictionary *authToolDic = tempAuthToolsArray[i];
                                if ([[authToolDic objectForKey:@"type"] isEqualToString:@"sms"]) {
                                    //跳转去加强鉴权页面验证
                                    SmsCheckViewController *smsCheckVC = [[SmsCheckViewController alloc] init];
                                    smsCheckVC.phoneNoStr = phoneNum;
                                    smsCheckVC.smsCheckType = SMS_CHECKTYPE_LOGINT;
                                    smsCheckVC.userInfo = userInfo;
                                    smsCheckVC.authToolArray = authToolSArr;
                                    [self.navigationController pushViewController:smsCheckVC animated:YES];
                                }else{
                                    [Tool showDialog:@"下发鉴权工具有误"];
                                }
                            }
                        }else{
                            [Tool showDialog:@"下发鉴权工具为空"];
                        }
                    }else{
                         [self load];
                    }
                }];
            }
        } successBlock:^{
            [[SDRequestHelp shareSDRequest] dispatchToMainQueue:^{
                [self.HUD hidden];
                //do nothing
            }];
        }];
        if (error) return;
    }];
}






- (void)exitApplication {
    //来 加个动画，给用户一个友好的退出界面
    
    [UIView animateWithDuration:0.4 animations:^{
        self.view.window.alpha = 0;
    } completion:^(BOOL finished) {
        exit(0);
    }];
    
}






- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
