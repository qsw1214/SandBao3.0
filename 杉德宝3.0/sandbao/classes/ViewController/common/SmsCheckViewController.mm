//
//  SmsCheckViewController.m
//  sandbao
//
//  Created by tianNanYiHao on 2017/10/18.
//  Copyright © 2017年 sand. All rights reserved.
//

#import "SmsCheckViewController.h"
#import "PayNucHelper.h"

#import "LogpwdViewController.h"
#import "PayPwdViewController.h"
#import "VerifyViewController.h"


@interface SmsCheckViewController ()
{
    SixCodeAuthToolView *smsCodeAuthToolView;
}

@end

@implementation SmsCheckViewController



- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self createUI];
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
    //如果倒计时已经为零,则允许自动触发短信发送
    if ( [SixCodeAuthToolView getCurrentTimeOut] == 0) {
        //获取短信验证码
        [self shortMsg];
        //短信开始倒计时
        [smsCodeAuthToolView startTimeOut];
    }
}
#pragma mark - 重写父类-baseScrollView设置
- (void)setBaseScrollview{
    [super setBaseScrollview];
    
}
#pragma mark - 重写父类-导航设置方法
- (void)setNavCoverView{
    [super setNavCoverView];
    self.navCoverView.letfImgStr = @"login_icon_back";

    __weak SmsCheckViewController *weakSelf = self;
    self.navCoverView.leftBlock = ^{
        [weakSelf.navigationController popViewControllerAnimated:YES];
    };
}
#pragma mark - 重写父类-点击方法集合
- (void)buttonClick:(UIButton *)btn{
    
    
    
}

#pragma mark  - UI绘制
- (void)createUI{
    __weak typeof(self) weakself = self;
    //titleLab1
    UILabel *titleLab = [Tool createLable:@"验证手机" attributeStr:nil font:FONT_28_Medium textColor:COLOR_358BEF alignment:NSTextAlignmentCenter];
    [self.baseScrollView addSubview:titleLab];
    
    //titleLab2
    UILabel *titleDesLab = [Tool createLable:@"短信验证码将会发送到" attributeStr:nil font:FONT_16_Regular textColor:COLOR_343339_7 alignment:NSTextAlignmentCenter];
    [self.baseScrollView addSubview:titleDesLab];

    //titleLab3
    UILabel *titlePhoneNoLab = [Tool createLable:self.phoneNoStr attributeStr:nil font:FONT_20_Medium textColor:COLOR_666666 alignment:NSTextAlignmentCenter];
    [self.baseScrollView addSubview:titlePhoneNoLab];
    
    
    //smsCodeAuth:sixCodeAuth
    smsCodeAuthToolView = [SixCodeAuthToolView createAuthToolViewOY:0];
    smsCodeAuthToolView.style = SmsCodeAuthTool;
    smsCodeAuthToolView.successBlock = ^(NSString *textfieldText) {
        
        switch (weakself.smsCheckType) {
            case SMS_CHECKTYPE_LOGINT:
            {
                //输入短信成功后,进入登录流程
                weakself.smsCodeString = textfieldText;
                [weakself loginUser];
                
            }
                break;
            case SMS_CHECKTYPE_REGIST:
            {
                //输入短信成功后, checkUser检测用户
                weakself.smsCodeString = textfieldText;
                [weakself checkUser];
            }
                break;
            case SMS_CHECKTYPE_REALNAME:
            {
                //输入短信成功后,进行实名认证
                weakself.smsCodeString = textfieldText;
                [weakself realUserName];
            }
                break;
            case SMS_CHECKTYPE_ADDBANKCARD:
            {
                //输入短信成功后,addBankCard绑卡流程
                weakself.smsCodeString = textfieldText;
                [weakself addBankCard];
            }
                break;
            case SMS_CHECKTYPE_VERIFYTYPE:
            {
                //输入短信成功后,跳转verifyVC进行进一步鉴权工具填写
                weakself.smsCodeString = textfieldText;
                [weakself pushToVerifyViewController];
                
            }
                break;
            default:
                break;
        }
        
    };
    smsCodeAuthToolView.successRequestBlock = ^(NSString *textfieldText) {
        //触发 - 获取短信码请求
        [weakself shortMsg];
    };
    [self.baseScrollView addSubview:smsCodeAuthToolView];
    
    
    
    //frame
    [titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.baseScrollView.mas_top).offset(UPDOWNSPACE_64);
        make.centerX.equalTo(self.baseScrollView.mas_centerX);
        make.size.mas_equalTo(titleLab.size);
    }];
    
    [titleDesLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(titleLab.mas_bottom).offset(UPDOWNSPACE_16);
        make.centerX.equalTo(self.baseScrollView.mas_centerX);
        make.size.mas_equalTo(titleDesLab.size);
    }];
    
    [titlePhoneNoLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(titleDesLab.mas_bottom).offset(UPDOWNSPACE_11);
        make.centerX.equalTo(self.baseScrollView.mas_centerX);
        make.size.mas_equalTo(titlePhoneNoLab.size);
    }];
    
    [smsCodeAuthToolView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(titlePhoneNoLab.mas_bottom).offset(UPDOWNSPACE_43);
        make.centerX.equalTo(self.baseScrollView.mas_centerX);
        make.size.mas_equalTo(smsCodeAuthToolView.size);
    }];

    
}



#pragma mark - =-=-=-=-=-=  公共业务逻辑   =-=-=-=-=-=
#pragma mark  获取短信验证码

- (void)shortMsg
{
    self.HUD = [SDMBProgressView showSDMBProgressOnlyLoadingINViewImg:self.view];
    [SDRequestHelp shareSDRequest].HUD = self.HUD;
    [SDRequestHelp shareSDRequest].controller = self;
    [[SDRequestHelp shareSDRequest] dispatchGlobalQuque:^{
        __block BOOL error = NO;
        
        NSMutableDictionary *authToolDic = [[NSMutableDictionary alloc] init];
        [authToolDic setValue:@"sms" forKey:@"type"];
        NSMutableDictionary *smsDic = [[NSMutableDictionary alloc] init];
        [smsDic setValue:self.phoneNoStr forKey:@"phoneNo"];
        [smsDic setValue:@"" forKey:@"code"];
        [authToolDic setObject:smsDic forKey:@"sms"];
        
        NSString *authTool = [[PayNucHelper sharedInstance] dictionaryToJson:authToolDic];
        
        paynuc.set("authTool", [authTool UTF8String]);
        
        [[SDRequestHelp shareSDRequest] requestWihtFuncName:@"authTool/pushAuthToolData/v1" errorBlock:^(SDRequestErrorType type) {
            error = YES;
        } successBlock:^{
            [[SDRequestHelp shareSDRequest] dispatchToMainQueue:^{
                [self.HUD hidden];
                
                //短信发送成功,允许控件进行输入及编辑
                smsCodeAuthToolView.noCopyTextfield.userInteractionEnabled = YES;
                //短息发送成功,自动弹出键盘
                [smsCodeAuthToolView.noCopyTextfield becomeFirstResponder];
            }];
        }];
        if (error) return ;
    }];
}


#pragma mark - =-=-=-=-=-=  用户登录模式  =-=-=-=-=-=

#pragma mark 用户登录
- (void)loginUser
{
    self.HUD = [SDMBProgressView showSDMBProgressOnlyLoadingINViewImg:self.view];
    [SDRequestHelp shareSDRequest].HUD = self.HUD;
    [SDRequestHelp shareSDRequest].controller = self;
    [[SDRequestHelp shareSDRequest] dispatchGlobalQuque:^{
        __block BOOL error = NO;
        //校验手机验证码
        NSMutableArray *authToolArr = [NSMutableArray arrayWithArray:self.loginAuthToolArray];
        NSMutableDictionary *authToolsDic2 = [[NSMutableDictionary alloc] init];
        [authToolsDic2 setValue:@"sms" forKey:@"type"];
        NSMutableDictionary *smsDic = [[NSMutableDictionary alloc] init];
        [smsDic setValue:self.phoneNoStr forKey:@"phoneNo"];
        [smsDic setValue:self.smsCodeString forKey:@"code"];
        [authToolsDic2 setObject:smsDic forKey:@"sms"];
        [authToolArr addObject:authToolsDic2];
        
        
        NSString *authTools = [[PayNucHelper sharedInstance] arrayToJSON:authToolArr];
        NSString *userinfo = self.userInfo;
        paynuc.set("authTools", [authTools UTF8String]);
        paynuc.set("userInfo", [userinfo UTF8String]);
        
        [[SDRequestHelp shareSDRequest] requestWihtFuncName:@"user/login/v1" errorBlock:^(SDRequestErrorType type) {
            error = YES;
            [[SDRequestHelp shareSDRequest] dispatchToMainQueue:^{
                [self.navigationController popViewControllerAnimated:YES];
            }];
        } successBlock:^{
            [[SDRequestHelp shareSDRequest] dispatchToMainQueue:^{
                [self.HUD hidden];
                
                //短息验证成功 - 停止计时器
                [smsCodeAuthToolView stopTimer];
                
                //更新用户数据信息
                [Tool refreshUserInfo:[NSString stringWithUTF8String:paynuc.get("userInfo").c_str()]];
                //更新用户数据库
                [self updateUserData];
                
            }];
        }];
        if (error) return ;
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
        result = [SDSqlite updateData:[SqliteHelper shareSqliteHelper].sandBaoDB sql:[NSString stringWithFormat:@"update usersconfig set active = '%@', sToken = '%@', userName = '%@' ,credit_fp = '%@'  where uid = '%@'", @"0", [CommParameter sharedInstance].sToken, self.phoneNoStr, creditFp, [CommParameter sharedInstance].userId]];
        
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
        
        result = [SDSqlite insertData:[SqliteHelper shareSqliteHelper].sandBaoDB sql:[NSString stringWithFormat:@"insert into usersconfig (uid, userName, active, sToken, credit_fp, lets) values ('%@', '%@', '%@', '%@', '%@', '%@')", [CommParameter sharedInstance].userId, self.phoneNoStr, @"0", [CommParameter sharedInstance].sToken, creditFp, letsJson]];
    }
    
    
    if (result == YES) {
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
                
                //登陆成功:
                [self setModalTransitionStyle:UIModalTransitionStyleFlipHorizontal];
                [self dismissViewControllerAnimated:YES completion:nil];
                
            }];
        }];
        if (error) return ;
        
    }];
}


#pragma mark - =-=-=-=-=-=  用户注册模式   =-=-=-=-=-=
#pragma mark 校验用户
- (void)checkUser{
    
    self.HUD = [SDMBProgressView showSDMBProgressOnlyLoadingINViewImg:self.view];
    [SDRequestHelp shareSDRequest].HUD = self.HUD;
    [SDRequestHelp shareSDRequest].controller = self;
    [[SDRequestHelp shareSDRequest] dispatchGlobalQuque:^{
        __block BOOL error = NO;
        
        //setAuthTools
        NSMutableArray *authToolsArray1 = [[NSMutableArray alloc] init];
        NSMutableDictionary *authToolsDic = [[NSMutableDictionary alloc] init];
        [authToolsDic setValue:@"sms" forKey:@"type"];
        NSMutableDictionary *smsDic = [[NSMutableDictionary alloc] init];
        [smsDic setValue:self.phoneNoStr forKey:@"phoneNo"];
        [smsDic setValue:self.smsCodeString forKey:@"code"];
        [authToolsDic setObject:smsDic forKey:@"sms"];
        [authToolsArray1 addObject:authToolsDic];
        NSString *authTools = [[PayNucHelper sharedInstance] arrayToJSON:authToolsArray1];
        
        paynuc.set("authTools", [authTools UTF8String]);
        [[SDRequestHelp shareSDRequest] requestWihtFuncName:@"authTool/setAuthTools/v1" errorBlock:^(SDRequestErrorType type) {
            error = YES;
        } successBlock:^{
            
        }];
        if (error) return ;
        
        
        
        //checkUser
        NSMutableDictionary *userInfoDic = [[NSMutableDictionary alloc] init];
        [userInfoDic setValue:self.phoneNoStr forKey:@"userName"];
        NSString *userInfo = [[PayNucHelper sharedInstance] dictionaryToJson:userInfoDic];
        
        paynuc.set("userInfo", [userInfo UTF8String]);
        [[SDRequestHelp shareSDRequest] requestWihtFuncName:@"user/checkUser/v1" errorBlock:^(SDRequestErrorType type) {
            error = YES;
        } successBlock:^{
            [[SDRequestHelp shareSDRequest] dispatchToMainQueue:^{
                [self.HUD hidden];
                
                //短息验证成功 - 停止计时器
                [smsCodeAuthToolView stopTimer];
                
                //跳转设置登陆密码
                LogpwdViewController *setLogpwdVC = [[LogpwdViewController alloc] init];
                setLogpwdVC.phoneNoStr = self.phoneNoStr;
                setLogpwdVC.smsCodeString = self.smsCodeString;
                [self.navigationController pushViewController:setLogpwdVC animated:YES];
                
            }];
        }];
        if (error) return ;

        
    }];

}


#pragma mark - =-=-=-=-=-=  用户实名模式   =-=-=-=-=-=-
#pragma mark 用户实名
/**
 *@brief 实名
 */
- (void)realUserName
{
    self.HUD = [SDMBProgressView showSDMBProgressOnlyLoadingINViewImg:self.view];
    [SDRequestHelp shareSDRequest].HUD = self.HUD;
    [SDRequestHelp shareSDRequest].controller = self;
    [[SDRequestHelp shareSDRequest] dispatchGlobalQuque:^{
        __block BOOL error = NO;
        
        //authTools
        NSMutableArray *authToolsArray1 = [[NSMutableArray alloc] init];
        NSMutableDictionary *authToolDic1 = [[NSMutableDictionary alloc] init];
        [authToolDic1 setValue:@"sms" forKey:@"type"];
        NSMutableDictionary *smsDic = [[NSMutableDictionary alloc] init];
        [smsDic setValue:self.phoneNoStr forKey:@"phoneNo"];
        [smsDic setValue:self.smsCodeString forKey:@"code"];
        [authToolDic1 setObject:smsDic forKey:@"sms"];
        [authToolsArray1 addObject:authToolDic1];
        NSString *authTools = [[PayNucHelper sharedInstance] arrayToJSON:authToolsArray1];
        
        
        //payTool
        NSMutableDictionary *payToolDic = [NSMutableDictionary dictionaryWithDictionary:self.payToolDic];
        NSMutableDictionary *payToolDic_authToolDic = [[NSMutableDictionary alloc] init];
        NSMutableDictionary *payToolDic_authToolDic_creditCardDic = [[NSMutableDictionary alloc] init];
    
        [payToolDic_authToolDic setValue:@"creditCard" forKey:@"type"];
        [payToolDic_authToolDic_creditCardDic setValue:self.cvnStr forKey:@"cvn"];
        [payToolDic_authToolDic_creditCardDic setValue:self.expiryStr forKey:@"expiry"];
        [payToolDic_authToolDic setObject:payToolDic_authToolDic_creditCardDic forKey:@"creditCard"];
        
        [payToolDic setObject:@[payToolDic_authToolDic] forKey:@"authTools"];
        NSString *payTool = [[PayNucHelper sharedInstance] dictionaryToJson:payToolDic];
        

        //userinfo
        NSMutableDictionary *userinfoDic = [NSMutableDictionary dictionaryWithDictionary:self.userInfoDic];
        NSMutableDictionary *userinfoDic_userinfoDic = [[NSMutableDictionary alloc] init];
        
        [userinfoDic_userinfoDic setValue:self.identityNoStr forKey:@"identityNo"];
        [userinfoDic_userinfoDic setValue:@"01" forKey:@"type"]; //01 身份证 02 军官证 03护照
        
        [userinfoDic setValue:userinfoDic_userinfoDic forKey:@"identity"];
        [userinfoDic setValue:self.realNameStr forKey:@"userRealName"];
        [userinfoDic setValue:self.phoneNoStr forKey:@"phoneNo"];
        NSString *userInfo = [[PayNucHelper sharedInstance] dictionaryToJson:userinfoDic];

        
        paynuc.set("authTools", [authTools UTF8String]);
        paynuc.set("payTool", [payTool UTF8String]);
        paynuc.set("userInfo", [userInfo UTF8String]);
        [[SDRequestHelp shareSDRequest] requestWihtFuncName:@"user/setRealName/v1" errorBlock:^(SDRequestErrorType type) {
            error = YES;
            [[SDRequestHelp shareSDRequest] dispatchToMainQueue:^{
                if (type == respCodeErrorType) {
                    NSString *respCode = [NSString stringWithUTF8String:paynuc.get("respCode").c_str()];
                    //实名成功,开通快捷失败(后端默认实名成功)
                    if ([@"050004" isEqualToString:respCode]) {
                        //短息验证成功 - 停止计时器
                        [smsCodeAuthToolView stopTimer];
                        [CommParameter sharedInstance].realNameFlag = YES;
                        NSString *respMsg = [NSString stringWithUTF8String:paynuc.get("respMsg").c_str()];
                        [Tool showDialog:respMsg defulBlock:^{
                            PayPwdViewController *payPwdVC = [[PayPwdViewController alloc] init];
                            [self.navigationController pushViewController:payPwdVC animated:YES];
                        }];
                    }
                }
            }];
        } successBlock:^{
            [[SDRequestHelp shareSDRequest] dispatchToMainQueue:^{
                [self.HUD hidden];
                //短息验证成功 - 停止计时器
                [smsCodeAuthToolView stopTimer];
                [CommParameter sharedInstance].realNameFlag = YES;
                PayPwdViewController *payPwdVC = [[PayPwdViewController alloc] init];
                [self.navigationController pushViewController:payPwdVC animated:YES];
            }];
        }];
        if (error) return ;
    }];
    
}

#pragma mark - =-=-=-=-=-=  用户绑银行卡  =-=-=-=-=-=-
#pragma mark 用户绑银行卡

- (void)addBankCard{
    
    self.HUD = [SDMBProgressView showSDMBProgressOnlyLoadingINViewImg:self.view];
    [SDRequestHelp shareSDRequest].HUD = self.HUD;
    [SDRequestHelp shareSDRequest].controller = self;
    [[SDRequestHelp shareSDRequest] dispatchGlobalQuque:^{
        __block BOOL error = NO;
        
        //authTools
        NSMutableArray *authToolsArray1 = [[NSMutableArray alloc] init];
        NSMutableDictionary *authToolDic1 = [[NSMutableDictionary alloc] init];
        [authToolDic1 setValue:@"sms" forKey:@"type"];
        NSMutableDictionary *smsDic = [[NSMutableDictionary alloc] init];
        [smsDic setValue:self.phoneNoStr forKey:@"phoneNo"];
        [smsDic setValue:self.smsCodeString forKey:@"code"];
        [authToolDic1 setObject:smsDic forKey:@"sms"];
        [authToolsArray1 addObject:authToolDic1];
        NSString *authTools = [[PayNucHelper sharedInstance] arrayToJSON:authToolsArray1];
        
        
        //payTool
        NSMutableDictionary *payToolDic = [NSMutableDictionary dictionaryWithDictionary:self.payToolDic];
        NSMutableDictionary *payToolDic_authToolDic = [[NSMutableDictionary alloc] init];
        NSMutableDictionary *payToolDic_authToolDic_creditCardDic = [[NSMutableDictionary alloc] init];
        
        [payToolDic_authToolDic setValue:@"creditCard" forKey:@"type"];
        [payToolDic_authToolDic_creditCardDic setValue:self.cvnStr forKey:@"cvn"];
        [payToolDic_authToolDic_creditCardDic setValue:self.expiryStr forKey:@"expiry"];
        [payToolDic_authToolDic setObject:payToolDic_authToolDic_creditCardDic forKey:@"creditCard"];
        
        [payToolDic setObject:@[payToolDic_authToolDic] forKey:@"authTools"];
        NSString *payTool = [[PayNucHelper sharedInstance] dictionaryToJson:payToolDic];
        
        
        //userinfo
        NSMutableDictionary *userinfoDic = [NSMutableDictionary dictionaryWithDictionary:self.userInfoDic];
        NSMutableDictionary *userinfoDic_userinfoDic = [[NSMutableDictionary alloc] init];
        
        [userinfoDic_userinfoDic setValue:self.identityNoStr forKey:@"identityNo"];
        [userinfoDic_userinfoDic setValue:@"01" forKey:@"type"]; //01 身份证 02 军官证 03护照
        
        [userinfoDic setValue:userinfoDic_userinfoDic forKey:@"identity"];
        [userinfoDic setValue:self.realNameStr forKey:@"userRealName"];
        [userinfoDic setValue:self.phoneNoStr forKey:@"phoneNo"];
        NSString *userInfo = [[PayNucHelper sharedInstance] dictionaryToJson:userinfoDic];
        
        
        paynuc.set("authTools", [authTools UTF8String]);
        paynuc.set("payTool", [payTool UTF8String]);
        paynuc.set("userInfo", [userInfo UTF8String]);
        [[SDRequestHelp shareSDRequest] requestWihtFuncName:@"card/bandCard/v1" errorBlock:^(SDRequestErrorType type) {
            error = YES;
            [[SDRequestHelp shareSDRequest] dispatchToMainQueue:^{
                if (type == respCodeErrorType) {
                    //短息验证成功 - 停止计时器
                    [smsCodeAuthToolView stopTimer];
                    NSString *respCode = [NSString stringWithUTF8String:paynuc.get("respCode").c_str()];
                    NSString *respMsg = [NSString stringWithUTF8String:paynuc.get("respMsg").c_str()];
                    //绑卡成功,开通快捷失败(后端默认绑卡成功)
                    if ([@"050005" isEqualToString:respCode]) {
                        [Tool showDialog:respMsg defulBlock:^{
                            [self ownPayTools_addBakcCard];
                        }];
                    }
                }
            }];
        } successBlock:^{
            [[SDRequestHelp shareSDRequest] dispatchToMainQueue:^{
                [self.HUD hidden];
                //短息验证成功 - 停止计时器
                [smsCodeAuthToolView stopTimer];
                [Tool showDialog:@"绑卡成功" defulBlock:^{
                    [self ownPayTools_addBakcCard];
                }];
            }];
        }];
        if (error) return ;
    }];
    
}
/**
 更新我方支付工具_绑卡
 */
- (void)ownPayTools_addBakcCard
{
    self.HUD = [SDMBProgressView showSDMBProgressOnlyLoadingINViewImg:self.view];
    [SDRequestHelp shareSDRequest].self.HUD = self.HUD;
    [SDRequestHelp shareSDRequest].controller = self;
    [[SDRequestHelp shareSDRequest] dispatchGlobalQuque:^{
        __block BOOL error = NO;
        
        paynuc.set("tTokenType", "01001501");
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
                
                [self.navigationController popToRootViewControllerAnimated:YES];
                
            }];
        }];
        if (error) return ;
        
    }];
}

#pragma mark - =-=-=-=-=-=  修改支付/登陆密码  =-=-=-=-=-=-
- (void)pushToVerifyViewController{
    
    //组装sms
    NSMutableArray *authToolsArr;
    for (int i = 0; i<self.verifyAuthToolsArr.count; i++) {
        if ([@"sms" isEqualToString:[self.verifyAuthToolsArr[i] objectForKey:@"type"]]) {
            
            NSMutableDictionary *authToolDic = [NSMutableDictionary dictionaryWithDictionary: self.verifyAuthToolsArr[i]];
            NSMutableDictionary *smsDic = [NSMutableDictionary dictionaryWithDictionary:[authToolDic objectForKey:@"sms"]];
            [smsDic setValue:self.smsCodeString forKey:@"code"];
            [authToolDic setValue:smsDic forKey:@"sms"];
            
            authToolsArr = [NSMutableArray arrayWithArray:self.verifyAuthToolsArr];
            [authToolsArr removeObjectAtIndex:i];
            [authToolsArr insertObject:authToolDic atIndex:i];
        }
    }
    
    VerifyViewController *verifyVC = [[VerifyViewController alloc] init];
    verifyVC.authToolArr = authToolsArr;
    verifyVC.smsCodeAuthToolView = smsCodeAuthToolView;
    verifyVC.verifyType = self.verifyType;
    [self.navigationController pushViewController:verifyVC animated:YES];
    
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
