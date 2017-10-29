//
//  LogpwdViewController.m
//  sandbao
//
//  Created by tianNanYiHao on 2017/10/19.
//  Copyright © 2017年 sand. All rights reserved.
//

#import "LogpwdViewController.h"
#import "PayNucHelper.h"

#import "RealNameViewController.h"

@interface LogpwdViewController ()


@property (nonatomic, strong) NSString *loginPwdStr; //登陆密码字符串


@end
@implementation LogpwdViewController
@synthesize loginPwdStr;


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
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
    __block UIViewController *weakself = self;
    self.navCoverView.leftBlock = ^{
        // 返回 RegistViewController
        [weakself.navigationController popToViewController:[weakself.navigationController.viewControllers objectAtIndex:1] animated:YES];
    };
}
#pragma mark - 重写父类-点击方法集合
- (void)buttonClick:(UIButton *)btn{
    
    if (btn.tag == BTN_TAG_NEXT) {
        //下一步
        if (loginPwdStr.length > 0 ) {
            [self registerUser];
        }
    }
    
}
#pragma mark  - UI绘制
- (void)createUI{

    //titleLab1
    UILabel *titleLab = [Tool createLable:@"设置登录密码" attributeStr:nil font:FONT_28_Medium textColor:COLOR_343339 alignment:NSTextAlignmentCenter];
    [self.baseScrollView addSubview:titleLab];

    //titleLab2
    UILabel *titleDesLab = [Tool createLable:@"设置的密码至少包含8-20位字母加数字" attributeStr:nil font:FONT_16_Regular textColor:COLOR_343339_7 alignment:NSTextAlignmentCenter];
    [self.baseScrollView addSubview:titleDesLab];
    
    //pwdAuthToolView
    PwdAuthToolView *pwdAuthToolView = [PwdAuthToolView createAuthToolViewOY:0];
    pwdAuthToolView.titleLab.text = @"登陆密码";
    pwdAuthToolView.textfiled.text = SHOWTOTEST(@"qqqqqq111");
    pwdAuthToolView.tip.text = @"密码必须包含8-20位的字母数字组合";
    pwdAuthToolView.successBlock = ^(NSString *textfieldText) {
        loginPwdStr = textfieldText;
    };
    [self.baseScrollView addSubview:pwdAuthToolView];
    
    //newtBtn
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
    
    [pwdAuthToolView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(titleDesLab.mas_bottom).offset(UPDOWNSPACE_58);
        make.centerX.equalTo(self.baseScrollView.mas_centerX);
        make.size.mas_equalTo(pwdAuthToolView.size);
    }];
    
    [nextBarbtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(pwdAuthToolView.mas_bottom).offset(UPDOWNSPACE_69);
        make.centerX.equalTo(self.baseScrollView.mas_centerX);
        make.size.mas_equalTo(nextBarbtn.size);
    }];
    
}

#pragma mark - 业务逻辑
#pragma mark 注册
/**
 *@brief 注册
 */
- (void)registerUser
{
    self.HUD = [SDMBProgressView showSDMBProgressOnlyLoadingINViewImg:self.view];
    [SDRequestHelp shareSDRequest].HUD = self.HUD;
    [SDRequestHelp shareSDRequest].controller = self;
    [[SDRequestHelp shareSDRequest] dispatchGlobalQuque:^{
        __block BOOL error = NO;
        
        //注册 - userInfo
        NSMutableDictionary *userInfoDic1 = [[NSMutableDictionary alloc] init];
        [userInfoDic1 setValue:self.phoneNoStr forKey:@"userName"];
        [userInfoDic1 setValue:self.phoneNoStr forKey:@"phoneNo"];
        NSString *userInfo1 = [[PayNucHelper sharedInstance] dictionaryToJson:userInfoDic1];
        
        //注册 - regAuthTools
        NSMutableArray *regAuthToolsArray = [[NSMutableArray alloc] init];
        NSMutableDictionary *loginpassDic = [[NSMutableDictionary alloc] init];
        [loginpassDic setValue:@"loginpass" forKey:@"type"];
        NSMutableDictionary *passDic1 = [[NSMutableDictionary alloc] init];
        [passDic1 setValue:@"sand" forKey:@"encryptType"];
        [passDic1 setValue:[NSString stringWithUTF8String:paynuc.lgnenc([loginPwdStr UTF8String]).c_str()] forKey:@"password"];
        [loginpassDic setObject:passDic1 forKey:@"pass"];
        [regAuthToolsArray addObject:loginpassDic];
        NSString *regAuthTools = [[PayNucHelper sharedInstance] arrayToJSON:regAuthToolsArray];
        
        
        //register
        paynuc.set("userInfo", [userInfo1 UTF8String]);
        paynuc.set("regAuthTools", [regAuthTools UTF8String]);
        [[SDRequestHelp shareSDRequest] requestWihtFuncName:@"user/register/v1" errorBlock:^(SDRequestErrorType type) {
            error = YES;
            [[SDRequestHelp shareSDRequest] dispatchToMainQueue:^{
                // 返回 RegistViewController
                [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:1] animated:YES];
            }];
        } successBlock:^{
            [[SDRequestHelp shareSDRequest] dispatchToMainQueue:^{
                [self.HUD hidden];
                
                NSDictionary *userInfoDic = [[PayNucHelper sharedInstance] jsonStringToDictionary:[NSString stringWithUTF8String:paynuc.get("userInfo").c_str()]];
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
    NSString *sToken = [NSString stringWithUTF8String:paynuc.get("sToken").c_str()];
    
    long count = [SDSqlite getCount:[SqliteHelper shareSqliteHelper].sandBaoDB sql:[NSString stringWithFormat:@"select count(*) from usersconfig where uid = '%@'", [CommParameter sharedInstance].userId]];
    
    BOOL result;
    if (count > 0) {  //新注册用户 - > count永远不会大于0
        //激活用户状态
        result = [SDSqlite updateData:[SqliteHelper shareSqliteHelper].sandBaoDB sql:[NSString stringWithFormat:@"update usersconfig set active = '%@', sToken = '%@', credit_fp = '%@'  where uid = '%@'", @"0", sToken, creditFp, [CommParameter sharedInstance].userId]];
    } else {
        NSMutableArray *minletsArray = [SDSqlite selectData:[SqliteHelper shareSqliteHelper].sandBaoDB tableName:@"minlets" columnArray:MINLETS_ARR ];
        
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
        
        result = [SDSqlite insertData:[SqliteHelper shareSqliteHelper].sandBaoDB sql:[NSString stringWithFormat:@"insert into usersconfig (uid, userName, active, sToken, credit_fp, lets) values ('%@', '%@', '%@', '%@', '%@', '%@')", [CommParameter sharedInstance].userId, self.phoneNoStr, @"0", sToken, creditFp, letsJson]];
    }
    //注册成功->跳转实名
    if (result == YES) {
        //实名
        RealNameViewController *realNameVC = [[RealNameViewController alloc] init];
        [self.navigationController pushViewController:realNameVC animated:YES];
    }
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
