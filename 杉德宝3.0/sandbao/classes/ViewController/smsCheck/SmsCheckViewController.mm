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
#pragma - mark 重写父类-baseScrollView设置
- (void)setBaseScrollview{
    [super setBaseScrollview];
    
}
#pragma - mark 重写父类-导航设置方法
- (void)setNavCoverView{
    [super setNavCoverView];
    
    self.navCoverView.rightImgStr = nil;
    self.navCoverView.midTitleStr = nil;
    __block UIViewController *weakself = self;
    self.navCoverView.leftBlock = ^{
        [weakself.navigationController popViewControllerAnimated:YES];
    };
}
#pragma - mark 重写父类-点击方法集合
- (void)buttonClick:(UIButton *)btn{
    
    
    
}

#pragma - mark  UI绘制
- (void)createUI{
    
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
    __block SixCodeAuthToolView *selfSmsCodeauthToolView = smsCodeAuthToolView;
    __block SmsCheckViewController *selfBlock = self;
    smsCodeAuthToolView.successBlock = ^{
        
        if (self.smsCheckType == SMS_CHECKTYPE_REGIST) {
            //输入短信成功后, 进入 设置登录密码
            selfBlock.smsCodeString = selfSmsCodeauthToolView.noCopyTextfield.text;
            LogpwdViewController *setLogpwdVC = [[LogpwdViewController alloc] init];
            setLogpwdVC.phoneNoStr = selfBlock.phoneNoStr;
            setLogpwdVC.smsCodeString = selfBlock.smsCodeString;
            [selfBlock.navigationController pushViewController:setLogpwdVC animated:YES];
            
        }
        if (self.smsCheckType == SMS_CHECKTYPE_REALNAME) {
            //输入短信成功后,进行实名认证
            selfBlock.smsCodeString = selfSmsCodeauthToolView.noCopyTextfield.text;
            [selfBlock authentication];
        }
        if (self.smsCheckType == SMS_CHECKTYPE_LOGINT) {
            //输入短信成功后,进入 登录 流程
            selfBlock.smsCodeString = selfSmsCodeauthToolView.noCopyTextfield.text;
            [selfBlock loginUser];
            
        }

    };
    smsCodeAuthToolView.successRequestBlock = ^{
        //触发 - 获取短信码请求
        [selfBlock shortMsg];
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



#pragma mark -=-=-=-=-=-=  公共业务逻辑   -=-=-=-=-=-=-
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
        
        [SDLog logTest:authTool];
        
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


#pragma mark -  -=-=-=-=-=-=  用户登录模式  -=-=-=-=-=-=-

#pragma mark - 用户登录
- (void)loginUser
{
    self.HUD = [SDMBProgressView showSDMBProgressOnlyLoadingINViewImg:self.view];
    [SDRequestHelp shareSDRequest].HUD = self.HUD;
    [SDRequestHelp shareSDRequest].controller = self;
    [[SDRequestHelp shareSDRequest] dispatchGlobalQuque:^{
        __block BOOL error = NO;
        //校验手机验证码
        NSMutableDictionary *authToolsDic2 = [[NSMutableDictionary alloc] init];
        [authToolsDic2 setValue:@"sms" forKey:@"type"];
        NSMutableDictionary *smsDic = [[NSMutableDictionary alloc] init];
        [smsDic setValue:self.phoneNoStr forKey:@"phoneNo"];
        [smsDic setValue:self.smsCodeString forKey:@"code"];
        [authToolsDic2 setObject:smsDic forKey:@"sms"];
        [self.authToolArray addObject:authToolsDic2];
        
        
        NSString *authTools = [[PayNucHelper sharedInstance] arrayToJSON:self.authToolArray];
        NSString *userinfo = self.userInfo;
        paynuc.set("authTools", [authTools UTF8String]);
        paynuc.set("userInfo", [userinfo UTF8String]);
        
        [[SDRequestHelp shareSDRequest] requestWihtFuncName:@"user/login/v1" errorBlock:^(SDRequestErrorType type) {
            error = YES;
        } successBlock:^{
            [[SDRequestHelp shareSDRequest] dispatchToMainQueue:^{
                [self.HUD hidden];
                [CommParameter sharedInstance].userInfo = [NSString stringWithUTF8String:paynuc.get("userInfo").c_str()];
                NSDictionary *userInfoDic = [[PayNucHelper sharedInstance] jsonStringToDictionary:[CommParameter sharedInstance].userInfo];
                [CommParameter sharedInstance].avatar = [userInfoDic objectForKey:@"avatar"];
                [CommParameter sharedInstance].realNameFlag = [[userInfoDic objectForKey:@"realNameFlag"] boolValue];
                [CommParameter sharedInstance].userRealName = [userInfoDic objectForKey:@"userRealName"];
                [CommParameter sharedInstance].userName = [userInfoDic objectForKey:@"userName"];
                [CommParameter sharedInstance].phoneNo = [userInfoDic objectForKey:@"phoneNo"];
                [CommParameter sharedInstance].userId = [userInfoDic objectForKey:@"userId"];
                [CommParameter sharedInstance].safeQuestionFlag = [[userInfoDic objectForKey:@"safeQuestionFlag"] boolValue];
                [CommParameter sharedInstance].nick = [userInfoDic objectForKey:@"nick"];
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
        [self ownPayTools];
    } else {
        //数据写入失败->返回直接登陆
        [Tool showDialog:@"用户数据存储失败,请返回重新登陆" defulBlock:^{
            [self.navigationController popToRootViewControllerAnimated:YES];
        }];
    }
}

/**
 *@brief 查询信息
 */
- (void)ownPayTools
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
                [self dismissViewControllerAnimated:YES completion:nil];
                
            }];
        }];
        if (error) return ;
        
    }];
}



#pragma mark -=-=-=-=-=-=  用户实名模式   -=-=-=-=-=-=-
#pragma mark - 用户实名
/**
 *@brief 实名
 */
- (void)authentication
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
        NSMutableDictionary *payToolDic_accountDic = [NSMutableDictionary dictionaryWithDictionary:[self.payToolDic objectForKey:@"account"]];
        NSMutableDictionary *payToolDic_authToolDic = [[NSMutableDictionary alloc] init];
        NSMutableDictionary *payToolDic_authToolDic_creditCardDic = [[NSMutableDictionary alloc] init];
        
        [payToolDic_accountDic setValue:self.bankCardNoStr forKey:@"accNo"];
        
        [payToolDic_authToolDic setValue:@"creditCard" forKey:@"type"];
        [payToolDic_authToolDic_creditCardDic setValue:self.cvnStr forKey:@"cvn"];
        [payToolDic_authToolDic_creditCardDic setValue:self.expiryStr forKey:@"expiry"];
        [payToolDic_authToolDic setObject:payToolDic_authToolDic_creditCardDic forKey:@"creditCard"];
        
        [payToolDic setObject:payToolDic_accountDic forKey:@"account"];
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
                        NSString *respMsg = [NSString stringWithUTF8String:paynuc.get("respMsg").c_str()];
                        [Tool showDialog:respMsg defulBlock:^{
                            
                        }];
                    }else{
                        [self.navigationController popViewControllerAnimated:YES];
                    }
                }
            }];
        } successBlock:^{
            [[SDRequestHelp shareSDRequest] dispatchToMainQueue:^{
                [self.HUD hidden];
                PayPwdViewController *payPwdVC = [[PayPwdViewController alloc] init];
                [self.navigationController pushViewController:payPwdVC animated:YES];
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
