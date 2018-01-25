//
//  LoginViewController.m
//  sandbao
//
//  Created by tianNanYiHao on 2017/10/13.
//  Copyright © 2017年 sand. All rights reserved.
//

#import "LoginViewController.h"
#import "PayNucHelper.h"

#import "ForgetLoginPwdViewController.h"
#import "RegistViewController.h"
#import "SmsCheckViewController.h"
#import "SDMQTTManager.h"



@interface LoginViewController ()
{
    SDBarButton *barButton;
}
@property (nonatomic, strong) NSString * phoneNum;
@property (nonatomic, strong) NSString * loginPwd;
@property (nonatomic, strong) NSMutableArray *authToolsArray;
@end


@implementation LoginViewController



-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    //进入登录页面 - 强制关闭MQTT
    [[SDMQTTManager shareMQttManager] closeMQTT];
    
    [self load];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    //UI创建
    [self createUI];
    
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
        //@"点击了忘记密码"
        ForgetLoginPwdViewController *forgetVC = [[ForgetLoginPwdViewController alloc] init];
        [self.navigationController pushViewController:forgetVC animated:YES];
    }
    if (btn.tag == BTN_TAG_LOGIN) {
        //@"登录"
        if (self.phoneNum.length>0 && self.loginPwd.length>0) {
            [self loginUser];
            //友盟自定义时间统计 - 计数事件
            [MobClick event:UM_Login];
        }else{
            [Tool showDialog:@"请输入正确的登陆账号及密码"];
        }
    }
    if (btn.tag == BTN_TAG_REGIST) {
        //@"注册"
        RegistViewController *regVc = [[RegistViewController alloc] init];
        [self.navigationController pushViewController:regVc animated:YES];
    }
    
}

#pragma mark  - UI绘制
- (void)createUI{
    __weak typeof(self) weakself = self;
    //titleLab1
    UILabel *titleLab = [Tool createLable:@"欢迎回来" attributeStr:nil font:FONT_28_Medium textColor:COLOR_343339 alignment:NSTextAlignmentLeft];
    [self.baseScrollView addSubview:titleLab];
    
    
    //titleLab2
    UILabel *titleDesLab = [Tool createLable:@"继续登录" attributeStr:nil font:FONT_16_Regular textColor:COLOR_343339_7 alignment:NSTextAlignmentLeft];
    [self.baseScrollView addSubview:titleDesLab];
    
    //PhoneAuthToolView
    PhoneAuthToolView *phoneAuthToolView = [PhoneAuthToolView createAuthToolViewOY:0];
    phoneAuthToolView.tip.text = @"请输入能登陆的手机号";
    phoneAuthToolView.textfiled.text = SHOWTOTEST(@"15151474188");
    self.phoneNum = SHOWTOTEST(@"15151474188");;
    phoneAuthToolView.successBlock = ^(NSString *textfieldText) {
        weakself.phoneNum = textfieldText;
    };
    
    [self.baseScrollView addSubview:phoneAuthToolView];
    
    //PwdAuthToolView
    PwdAuthToolView *pwdAuthToolView = [PwdAuthToolView createAuthToolViewOY:0];
    pwdAuthToolView.tip.text = @"密码必须包含8-20位的字母数字组合";
    pwdAuthToolView.textfiled.text = SHOWTOTEST(@"qqqqqq111");
    self.loginPwd = SHOWTOTEST(@"qqqqqq111");
    pwdAuthToolView.successBlock = ^(NSString *textfieldText) {
        weakself.loginPwd = textfieldText;
    };
    [self.baseScrollView addSubview:pwdAuthToolView];
    
    //forgetPwd
    UIButton *forgetBtn = [Tool createButton:@"忘记密码?" attributeStr:nil font:FONT_14_Regular textColor:COLOR_343339_7];
    forgetBtn.tag = BTN_TAG_FORGETPWD;
    [forgetBtn addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.baseScrollView addSubview:forgetBtn];
    
    //logintBtn
    barButton = [[SDBarButton alloc] init];
    UIView *loginBarbtn = [barButton createBarButton:@"登录" font:FONT_15_Regular titleColor:COLOR_FFFFFF backGroundColor:COLOR_58A5F6 leftSpace:LEFTRIGHTSPACE_40];
    barButton.btn.tag = BTN_TAG_LOGIN;
    [barButton.btn addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
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
        make.top.equalTo(pwdAuthToolView.mas_bottom).offset(UPDOWNSPACE_0);
        make.right.equalTo(pwdAuthToolView.mas_right).offset(-LEFTRIGHTSPACE_40);
        make.size.mas_equalTo(forgetBtn.size);
    }];
    
    [loginBarbtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(forgetBtn.mas_bottom).offset(UPDOWNSPACE_20);
        make.centerX.equalTo(self.baseScrollView.mas_centerX);
        make.size.mas_equalTo(loginBarbtn.size);
    }];
    
    [registbtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(loginBarbtn.mas_bottom).offset(UPDOWNSPACE_28);
        make.centerX.equalTo(self.baseScrollView.mas_centerX);
        make.size.mas_equalTo(registbtn.size);
    }];
    
    
    
    //装载所有的textfiled
    self.textfiledArr = [NSMutableArray arrayWithArray:@[phoneAuthToolView.textfiled,pwdAuthToolView.textfiled]];
    for (int i = 0 ; i<self.textfiledArr.count; i++) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFieldChange:) name:UITextFieldTextDidEndEditingNotification object:self.textfiledArr[i]];
    }
}

- (void)textFieldChange:(NSNotification*)noti{
    
    //按钮置灰不可点击
    UITextField *currentTextField = (UITextField*)noti.object;
    if (currentTextField.text.length == 0) {
        [barButton changeState:NO];
    }
    
    //按钮高亮可点击
    NSMutableArray *tempArr = [NSMutableArray arrayWithCapacity:0];
    for (UITextField *t in self.textfiledArr) {
        if ([t.text length]>0) {
            [tempArr addObject:t];
        }
        if (tempArr.count == self.textfiledArr.count) {
            [barButton changeState:YES];
        }
    }
}




#pragma mark - 业务逻辑
#pragma mark 获取登陆鉴权工具

/**
 *@brief 获取鉴权工具
 *@return NSArray
 */
- (void)load
{
    self.authToolsArray = [[NSMutableArray alloc] init];
    
    self.HUD = [SDMBProgressView showSDMBProgressOnlyLoadingINViewImg:self.view];
    [SDRequestHelp shareSDRequest].HUD = self.HUD;
    [SDRequestHelp shareSDRequest].controller = self;
    [[SDRequestHelp shareSDRequest] dispatchGlobalQuque:^{
        __block BOOL error = NO;
        
        //获取未登录钱sToken(虚拟)
        paynuc.set("creditFp", "684599B093B8F673A9BE6A7F2AC4E45E");
        [[SDRequestHelp shareSDRequest] closedRespCpdeErrorAutomatic];
        [[SDRequestHelp shareSDRequest] requestWihtFuncName:@"token/getStoken/v1" errorBlock:^(SDRequestErrorType type) {
            error = YES;
            [[SDRequestHelp shareSDRequest] dispatchToMainQueue:^{
                [[SDRequestHelp shareSDRequest] openRespCpdeErrorAutomatic];
                if (type == frErrorType) {
                    [Tool showDialog:@"网络连接超时,请退出重试" defulBlock:^{
                        //退出处理
                        [Tool exitApplication:self];
                    }];
                }
                if (type == respCodeErrorType) {
                    [Tool showDialog:@"网络连接失败,点击重连" defulBlock:^{
                        //重新申请sToken
                        [self load];
                    }];
                }
            }];
        } successBlock:^{
            [[SDRequestHelp shareSDRequest] dispatchToMainQueue:^{
               [[SDRequestHelp shareSDRequest] openRespCpdeErrorAutomatic];
            }];
        }];
        if (error) return;
        
        paynuc.set("tTokenType", "01000201");
        paynuc.set("cfg_termFp", [[Tool setCfgTempFpStaticDataFlag:NO DynamicDataFlag:YES] UTF8String]);
        [[SDRequestHelp shareSDRequest] closedRespCpdeErrorAutomatic];
        [[SDRequestHelp shareSDRequest] requestWihtFuncName:@("token/getTtoken/v1") errorBlock:^(SDRequestErrorType type) {
            error = YES;
            [[SDRequestHelp shareSDRequest] dispatchToMainQueue:^{
                [[SDRequestHelp shareSDRequest] openRespCpdeErrorAutomatic];
                if (type == frErrorType) {
                    [Tool showDialog:@"网络连接超时,请退出重试" defulBlock:^{
                        [Tool exitApplication:self];
                    }];
                }
                if (type == respCodeErrorType) {
                    [Tool showDialog:@"网络连接失败,点击重连" defulBlock:^{
                        //重新申请tTtoken
                        [self load];
                    }];
                }
            }];
        } successBlock:^{
            [[SDRequestHelp shareSDRequest] dispatchToMainQueue:^{
                [[SDRequestHelp shareSDRequest] openRespCpdeErrorAutomatic];
            }];
        }];
        if (error) return;
        
        [[SDRequestHelp shareSDRequest] closedRespCpdeErrorAutomatic];
        [[SDRequestHelp shareSDRequest] requestWihtFuncName:@"authTool/getAuthTools/v1" errorBlock:^(SDRequestErrorType type) {
            error = YES;
            [[SDRequestHelp shareSDRequest] dispatchToMainQueue:^{
                [[SDRequestHelp shareSDRequest] openRespCpdeErrorAutomatic];
                if (type == frErrorType) {
                    [Tool showDialog:@"网络连接超时,请退出重试" defulBlock:^{
                        [Tool exitApplication:self];
                    }];
                }
                if (type == respCodeErrorType) {
                    [Tool showDialog:@"网络连接失败,点击重连" defulBlock:^{
                        //重新申请鉴权工具
                        [self load];
                    }];
                }
            }];
        } successBlock:^{
            [[SDRequestHelp shareSDRequest] dispatchToMainQueue:^{
                [[SDRequestHelp shareSDRequest] openRespCpdeErrorAutomatic];
                [self.HUD hidden];
                NSString *AuthToolstr = [NSString stringWithUTF8String:paynuc.get("authTools").c_str()];
                NSArray *authToolsArr = [[PayNucHelper sharedInstance] jsonStringToArray:AuthToolstr];
                
                if (authToolsArr.count>0) {
                    for (int i = 0; i < authToolsArr.count; i++) {
                        [self.authToolsArray addObject:authToolsArr[i]];
                    }
                }else{
                    [Tool showDialog:@"无鉴权工具下发" defulBlock:^{
                        [Tool exitApplication:self];
                    }];
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
        [passDic setValue:[NSString stringWithUTF8String:paynuc.lgnenc([self.loginPwd UTF8String]).c_str()] forKey:@"password"];
        [authToolsDic1 setObject:passDic forKey:@"pass"];
        [authToolSArr addObject:authToolsDic1];
        NSString *authTools = [[PayNucHelper sharedInstance] arrayToJSON:authToolSArr];
        
        NSMutableDictionary *userInfoDic = [[NSMutableDictionary alloc] init];
        [userInfoDic setValue:self.phoneNum forKey:@"userName"];
        NSString *userInfo = [[PayNucHelper sharedInstance] dictionaryToJson:userInfoDic];

        paynuc.set("authTools", [authTools UTF8String]);
        paynuc.set("userInfo", [userInfo UTF8String]);
        [[SDRequestHelp shareSDRequest] requestWihtFuncName:@"user/login/v1" errorBlock:^(SDRequestErrorType type) {
            error = YES;
            [[SDRequestHelp shareSDRequest] dispatchToMainQueue:^{
                if (type == respCodeErrorType) {
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
                                    smsCheckVC.phoneNoStr = self.phoneNum;
                                    smsCheckVC.smsCheckType = SMS_CHECKTYPE_LOGINT;
                                    smsCheckVC.userInfo = userInfo;
                                    smsCheckVC.loginAuthToolArray = authToolSArr;
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
                }
            }];
        } successBlock:^{
            [[SDRequestHelp shareSDRequest] dispatchToMainQueue:^{
                [self.HUD hidden];
                
                //正常状态下不走,为了审核通过,允许在不加强鉴权时,直接明登陆通过
                //更新用户数据信息
                [Tool refreshUserInfo:[NSString stringWithUTF8String:paynuc.get("userInfo").c_str()]];
                //更新用户数据库
                [self updateUserData];
            }];
        }];
        if (error) return;
    }];
}

/**
*@brief 更新用户数据
*/
- (void)updateUserData
{
    NSString *creditFp = [NSString stringWithUTF8String:paynuc.get("creditFp").c_str()];
    [CommParameter sharedInstance].sToken = [NSString stringWithUTF8String:paynuc.get("sToken").c_str()];
    
    //查询minlets数据库最新子件
    NSMutableArray *minletsArray = [SDSqlite selectData:[SqliteHelper shareSqliteHelper].sandBaoDB tableName:@"minlets" columnArray:MINLETS_ARR ];
    //查询登陆用户数据
    long count = [SDSqlite getCount:[SqliteHelper shareSqliteHelper].sandBaoDB sql:[NSString stringWithFormat:@"select count(*) from usersconfig where uid = '%@'", [CommParameter sharedInstance].userId]];
    
    BOOL result;
    if (count > 0) {
        //1.激活登陆用户
        result = [SDSqlite updateData:[SqliteHelper shareSqliteHelper].sandBaoDB sql:[NSString stringWithFormat:@"update usersconfig set active = '%@', sToken = '%@', userName = '%@' ,credit_fp = '%@'  where uid = '%@'", @"0", [CommParameter sharedInstance].sToken, self.phoneNum, creditFp, [CommParameter sharedInstance].userId]];
        
        //2.更新该用户下lets信息
        //查询此用户对应的lets信息
        NSString *letsStr = [SDSqlite selectStringData:[SqliteHelper shareSqliteHelper].sandBaoDB tableName:@"usersconfig" columnName:@"lets" whereColumnString:@"uid" whereParamString:[CommParameter sharedInstance].userId];
        //如果该用户lets信息在minlets库中不存在则删除之
        NSArray *lensArr = [[PayNucHelper sharedInstance] jsonStringToArray:letsStr];
        NSMutableArray *lensArrM = [NSMutableArray arrayWithCapacity:0];
        //取交集
        for (int i = 0; i<lensArr.count; i++) {
            for (int ii = 0; ii<minletsArray.count; ii++) {
                if ([[lensArr[i] objectForKey:@"letId"] isEqualToString:[minletsArray[ii] objectForKey:@"id"]]) {
                    [lensArrM addObject:lensArr[i]];
                }
            }
        }
        //更新该用户lets信息
        NSString *letsStrNew = [[PayNucHelper sharedInstance] arrayToJSON:lensArrM];
        [SDSqlite updateData:[SqliteHelper shareSqliteHelper].sandBaoDB  tableName:@"usersconfig" columnArray:(NSMutableArray*)@[@"lets"] paramArray:(NSMutableArray *)@[letsStrNew] whereColumnString:@"uid" whereParamString:[CommParameter sharedInstance].userId];
    } else {
        NSInteger minletsArrayCount = [minletsArray count];
        NSMutableArray *letsDicArray = [[NSMutableArray alloc] init];
        if (minletsArrayCount > 8) {
            for (int i = 0; i < 7; i++) {
                NSMutableDictionary *letsDic = [[NSMutableDictionary alloc] init];
                NSMutableDictionary *minletsDic = minletsArray[i];
                [letsDic setValue:[minletsDic objectForKey:@"id"] forKey:@"letId"];
                [letsDicArray addObject:letsDic];
            }
        } else {
            for (int i = 0; i < minletsArrayCount; i++) {
                NSMutableDictionary *letsDic = [[NSMutableDictionary alloc] init];
                NSMutableDictionary *minletsDic = minletsArray[i];
                [letsDic setValue:[minletsDic objectForKey:@"id"] forKey:@"letId"];
                [letsDicArray addObject:letsDic];
            }
        }
        
        NSError *error;
        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:letsDicArray options:NSJSONWritingPrettyPrinted error:&error];
        NSString *letsJson = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
        letsJson = [[letsJson stringByReplacingOccurrencesOfString:@"\n" withString:@""] stringByReplacingOccurrencesOfString:@" " withString:@""];
        
        result = [SDSqlite insertData:[SqliteHelper shareSqliteHelper].sandBaoDB sql:[NSString stringWithFormat:@"insert into usersconfig (uid, userName, active, sToken, credit_fp, lets) values ('%@', '%@', '%@', '%@', '%@', '%@')", [CommParameter sharedInstance].userId, self.phoneNum, @"0", [CommParameter sharedInstance].sToken, creditFp, letsJson]];
    }
    
    
    if (result == YES) {
        [[SDMQTTManager shareMQttManager] loginMQTT:[CommParameter sharedInstance].sToken];
        [self ownPayTools_login];
    } else {
        //数据写入失败->返回直接登陆
        [Tool showDialog:@"用户数据存储失败,请返回重新登陆" defulBlock:^{
            [self.navigationController popToRootViewControllerAnimated:YES];
        }];
    }
}


/**
 更新我方支付工具_登陆模式下
 */
- (void)ownPayTools_login
{
    self.HUD = [SDMBProgressView showSDMBProgressOnlyLoadingINViewImg:self.view];
    [SDRequestHelp shareSDRequest].self.HUD = self.HUD;
    [SDRequestHelp shareSDRequest].controller = self;
    [[SDRequestHelp shareSDRequest] dispatchGlobalQuque:^{
        __block BOOL error = NO;
        
        paynuc.set("tTokenType", "01001501");
        paynuc.set("cfg_termFp", [[Tool setCfgTempFpStaticDataFlag:NO DynamicDataFlag:YES] UTF8String]);
        [[SDRequestHelp shareSDRequest] requestWihtFuncName:@"token/getTtoken/v1" errorBlock:^(SDRequestErrorType type) {
            error = YES;
        } successBlock:^{
            
        }];
        if (error) return ;
        
        
        paynuc.set("payToolKinds", "[]");
        [[SDRequestHelp shareSDRequest] requestWihtFuncName:@"payTool/getOwnPayTools/v1" errorBlock:^(SDRequestErrorType type) {
            error = YES;
        } successBlock:^{
            [[SDRequestHelp shareSDRequest] dispatchToMainQueue:^{
                [self.HUD hidden];
                
                NSArray *payToolsArray = [[PayNucHelper sharedInstance] jsonStringToArray:[NSString stringWithUTF8String:paynuc.get("payTools").c_str()]];
                //根据order 字段排序
                payToolsArray = [Tool orderForPayTools:payToolsArray];
                [CommParameter sharedInstance].ownPayToolsArray = payToolsArray;
                
                //归位Home或SpsLunch
                [Tool setContentViewControllerWithHomeOrSpsLunchFromSideMenuViewController:self.sideMenuViewController];
                //友盟埋点 - 账号统计 - 开始
                [MobClick profileSignInWithPUID:[CommParameter sharedInstance].userId provider:@"sand"];
                //友盟埋点 - 账号统计 - 结束
                [MobClick profileSignOff];
            }];
        }];
        if (error) return ;
        
    }];
}


- (void)dealloc{
    //清除通知
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
