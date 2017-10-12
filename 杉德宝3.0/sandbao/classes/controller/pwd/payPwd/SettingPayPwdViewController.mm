//
//  SettingPayPwdViewController.m
//  sandbao
//
//  Created by tianNanYiHao on 2017/1/18.
//  Copyright © 2017年 sand. All rights reserved.
//

#import "SettingPayPwdViewController.h"
#import "LoginViewController.h"

#import "GroupView.h"
#import "SDLog.h"
#import "PayNucHelper.h"
#import "CommParameter.h"

#import "MainViewController.h"

#import "SqliteHelper.h"
#import "SDSqlite.h"
#import "SetViewController.h"
#import "SpsPayViewController.h"



#define navViewColor RGBA(249, 249, 249, 1.0)

@interface SettingPayPwdViewController ()<GroupViewDelegate>
{
    NavCoverView *navCoverView;
}
@property (nonatomic, assign) CGSize viewSize;
@property (nonatomic, strong) SDMBProgressView *HUD;
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) GroupView *payPwdView;
@property (nonatomic, strong) NSString *payPwd;
@end

@implementation SettingPayPwdViewController

@synthesize viewSize;
@synthesize HUD;
@synthesize scrollView;
@synthesize payPwdView;
@synthesize payPwd;
@synthesize regAuthToolsArray;
@synthesize loginPwd;
@synthesize registerFlag;


- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.view setBackgroundColor:RGBA(247, 245, 244, 1.0)];
    viewSize = self.view.bounds.size;
    payPwd = @"";
    
    [self settingNavigationBar];
    [self addView:self.view];
}

#pragma mark - 设置导航栏
/**
 *@brief 设置导航栏
 *@return
 */
- (void)settingNavigationBar
{
    //导航渐变条
    navCoverView = [NavCoverView shareNavCoverView:CGRectMake(0, 0, viewSize.width, controllerTop) title:@""];
    [self.view addSubview:navCoverView];
    
    // 2.设置左边的返回item
    UIImage *leftImage = [UIImage imageNamed:@"back"];
    UIButton *leftBarBtn = [[UIButton alloc] init];
    leftBarBtn.frame = CGRectMake(0, 20 + (40 - leftImage.size.height) / 2, leftImage.size.width, leftImage.size.height);
    leftBarBtn.tag = 101;
    [leftBarBtn setImage:[UIImage imageNamed:@"back"] forState:UIControlStateNormal];
    [leftBarBtn setImage:[UIImage imageNamed:@"back"] forState:UIControlStateHighlighted];
    [leftBarBtn addTarget:self action:@selector(buttonActionToDoSomething:) forControlEvents:UIControlEventTouchUpInside];
    [navCoverView addSubview:leftBarBtn];

    
    // 3.设置右边的返回item
    UIImage *rightImage = [UIImage imageNamed:@""];
    UIButton *rightBarBtn = [[UIButton alloc] init];
    [rightBarBtn setImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
    [rightBarBtn setImage:[UIImage imageNamed:@""] forState:UIControlStateHighlighted];
    rightBarBtn.frame = CGRectMake(viewSize.width - 10 - rightImage.size.width, 20 + (40 - rightImage.size.height) / 2, rightImage.size.width, rightImage.size.height);
    rightBarBtn.tag = 102;
    rightBarBtn.contentMode = UIViewContentModeScaleAspectFit;
    UIBarButtonItem *rightButtonItem = [[UIBarButtonItem alloc] initWithCustomView:rightBarBtn];
    self.navigationItem.rightBarButtonItem = rightButtonItem;
}

#pragma mark - 创建组件
/**
 *@brief 创建组件
 *@param view UIView 参数：组件
 *@return
 */
-(void)addView:(UIView *)view
{
//    UIView *navView = [[UIView alloc] init];
//    navView.backgroundColor = navViewColor;
//    [view addSubview:navView];
    
    //创建UIScrollView
    scrollView = [[UIScrollView alloc] init];
    scrollView.userInteractionEnabled = YES;
    scrollView.scrollEnabled = YES;
    scrollView.contentSize = CGSizeMake(viewSize.width, viewSize.height - controllerTop);
    scrollView.directionalLockEnabled = YES; //只能一个方向滑动
    scrollView.pagingEnabled = NO; //是否翻页
    scrollView.showsVerticalScrollIndicator =YES; //垂直方向的滚动指示
    scrollView.indicatorStyle = UIScrollViewIndicatorStyleWhite;//滚动指示的风格
    scrollView.showsHorizontalScrollIndicator = NO;//水平方向的滚动指示
    [scrollView setBackgroundColor:RGBA(247, 245, 244, 1.0)];
    [view addSubview:scrollView];
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    //设置控件的位置和大小
//    CGFloat navViewTop = 20;
//    CGFloat navViewH = 44;
    
    
    CGFloat scrollViewH = viewSize.height - controllerTop;
    
//    [navView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(view).offset(navViewTop);
//        make.centerX.equalTo(view);
//        make.size.mas_equalTo(CGSizeMake(viewSize.width, navViewH));
//    }];
    
    [scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(navCoverView.mas_bottom).offset(0);
        make.centerX.equalTo(view);
        make.size.mas_equalTo(CGSizeMake(viewSize.width, scrollViewH));
    }];
    
    [self addRegAuthToolsView:scrollView];
    
//    //支付密码区
//    payPwdView = [[GroupView alloc] initWithFrame:CGRectMake(0, 0, viewSize.width, viewSize.height - controllerTop)];
//    payPwdView.delegate = self;
//    CGFloat payPwdViewH = [payPwdView payPwdVerification];
//    [view addSubview:payPwdView];
//    
//    [payPwdView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.center.equalTo(scrollView);
//        make.size.mas_equalTo(CGSizeMake(viewSize.width, payPwdViewH));
//    }];
}

#pragma mark - GroupViewDelegate

- (void)payPwd:(NSString *)param
{
    BOOL payPassRegular = [UITextField payPassWdTooSimple:param];
    if (payPassRegular == NO) {
        [Tool showDialog:@"密码过于简单" defulBlock:^{
            [payPwdView clearPayPwd]; 
        }];
        return;
    }
    if ([@"" isEqualToString:payPwd]) {
        payPwd = param;
        [payPwdView clearPayPwd];
        payPwdView.inputTitleLabel.text = @"再次输入支付密码";
        return;
    }
    
    if (![param isEqualToString:payPwd]) {
        payPwd = @"";
        [payPwdView clearPayPwd];
        payPwdView.inputTitleLabel.text = @"请输入支付密码";
        return;
    }
    
    payPwd = param;
    
    if (registerFlag == YES) {
        [[self class] cancelPreviousPerformRequestsWithTarget:self selector:@selector(registerUser) object:nil];
        [self performSelector:@selector(registerUser) withObject:nil afterDelay:1];
    } else {
        [[self class] cancelPreviousPerformRequestsWithTarget:self selector:@selector(pushRegAuthTools) object:nil];
        [self performSelector:@selector(pushRegAuthTools) withObject:nil afterDelay:1];
    }
    
}

#pragma mark - 添加按钮添加事件
/**
 *@brief 添加按钮添加事件
 *@return
 */
- (void)buttonAction:(id)sender
{
    UIButton *btn = (UIButton *)sender;
    if(btn.tag == 1) {
        [[self class] cancelPreviousPerformRequestsWithTarget:self selector:@selector(buttonActionToDoSomething:) object:sender];
        [self performSelector:@selector(buttonActionToDoSomething:) withObject:sender afterDelay:1];
    } else if(btn.tag == 4) {
        [[self class] cancelPreviousPerformRequestsWithTarget:self selector:@selector(buttonActionToDoSomething:) object:sender];
        [self performSelector:@selector(buttonActionToDoSomething:) withObject:sender afterDelay:1];
    } else {
        [[self class] cancelPreviousPerformRequestsWithTarget:self selector:@selector(buttonActionToDoSomething:) object:sender];
        [self performSelector:@selector(buttonActionToDoSomething:) withObject:sender afterDelay:0];
    }
}

#pragma mark - 按钮事件处理事情
/**
 *@brief 添加按钮添加事件
 *@return
 */
- (void)buttonActionToDoSomething:(id)sender
{
    UIButton *btn = (UIButton *)sender;
    switch (btn.tag) {
        case 1:
        {
            
        }
            break;
        case 2:
        {
            
        }
            break;
        case 3:
        {
            
        }
            break;
        case 4:
        {
            
        }
            break;
        case 101:
        {
            //退回到设置页面
            UIViewController *setViewController = self.navigationController.viewControllers[1];
            [self.navigationController popToViewController:setViewController animated:YES];

        }
            break;
            
        default:
            break;
    }
}



#pragma mark - 业务逻辑

/**
 *@brief 添加注册鉴权工具view
 *@param view UIView 参数：组件
 *@return CGFloat
 */
- (CGFloat)addRegAuthToolsView:(UIView *)view
{
    CGFloat tempHeight = 0;
    
    NSInteger regAuthToolsArrayCount = [regAuthToolsArray count];
    for (int i = 0; i < regAuthToolsArrayCount; i++) {
        NSMutableDictionary *dic = regAuthToolsArray[i];
        NSString *type = [dic objectForKey:@"type"];
        if ([@"paypass" isEqualToString:type]) {
            
            //支付密码区
            payPwdView = [[GroupView alloc] initWithFrame:CGRectMake(0, 0, viewSize.width, viewSize.height - controllerTop)];
            payPwdView.delegate = self;
            CGFloat payPwdViewH = [payPwdView payPwdVerification];
            [view addSubview:payPwdView];
            
            [payPwdView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.center.equalTo(view);
                make.size.mas_equalTo(CGSizeMake(viewSize.width, payPwdViewH));
            }];
            
            tempHeight = payPwdViewH;
            
        }
    }
    
    return tempHeight;
}


/**
 *@brief 注册
 */
- (void)registerUser
{
    HUD = [SDMBProgressView showSDMBProgressOnlyLoadingINViewImg:self.view];
    [SDRequestHelp shareSDRequest].HUD = HUD;
    [SDRequestHelp shareSDRequest].controller = self;
    [[SDRequestHelp shareSDRequest] dispatchGlobalQuque:^{
        __block BOOL error = NO;
        //注册
        NSMutableDictionary *userInfoDic1 = [[NSMutableDictionary alloc] init];
        if (_thirdRegistFlag == YES) {
            [userInfoDic1 setValue:[CommParameter sharedInstance].phoneNo forKey:@"userName"];
            [userInfoDic1 setValue:[CommParameter sharedInstance].phoneNo forKey:@"phoneNo"];
            [userInfoDic1 setValue:_nick forKey:@"nick"];
            [userInfoDic1 setValue:_avatar forKey:@"avatar"];
            NSMutableDictionary *authCodeDic = [NSMutableDictionary dictionaryWithCapacity:0];
            [authCodeDic setValue:_firm forKey:@"firm"];
            [authCodeDic setValue:_userUnionid forKey:@"userUnionid"];
            [userInfoDic1 setValue:authCodeDic forKey:@"authCode"];
        }else{
            [userInfoDic1 setValue:[CommParameter sharedInstance].phoneNo forKey:@"userName"];
            [userInfoDic1 setValue:[CommParameter sharedInstance].phoneNo forKey:@"phoneNo"];
        }
        NSString *userInfo1 = [[PayNucHelper sharedInstance] dictionaryToJson:userInfoDic1];
        [SDLog logTest:userInfo1];
        
        
        
        NSMutableArray *regAuthToolsArray1 = [[NSMutableArray alloc] init];
        //是微博等第三方注册过来->设置支付密码
        if (_thirdRegistFlag == YES) {
            NSMutableDictionary *paypassDic = [[NSMutableDictionary alloc] init];
            [paypassDic setValue:@"paypass" forKey:@"type"];
            NSMutableDictionary *passDic2 = [[NSMutableDictionary alloc] init];
            [passDic2 setValue:@"sand" forKey:@"encryptType"];
            [passDic2 setValue:[[PayNucHelper sharedInstance] pinenc:payPwd type:@"paypass"] forKey:@"password"];
            [paypassDic setObject:passDic2 forKey:@"pass"];
            [regAuthToolsArray1 addObject:paypassDic];
            
        }else{
            //通过杉德宝注册的->设置支付密码
            NSMutableDictionary *loginpassDic = [[NSMutableDictionary alloc] init];
            [loginpassDic setValue:@"loginpass" forKey:@"type"];
            NSMutableDictionary *passDic1 = [[NSMutableDictionary alloc] init];
            [passDic1 setValue:@"sand" forKey:@"encryptType"];
            [passDic1 setValue:[NSString stringWithUTF8String:paynuc.lgnenc([loginPwd UTF8String]).c_str()] forKey:@"password"];
            [loginpassDic setObject:passDic1 forKey:@"pass"];
            [regAuthToolsArray1 addObject:loginpassDic];
            
            NSMutableDictionary *paypassDic = [[NSMutableDictionary alloc] init];
            [paypassDic setValue:@"paypass" forKey:@"type"];
            NSMutableDictionary *passDic2 = [[NSMutableDictionary alloc] init];
            [passDic2 setValue:@"sand" forKey:@"encryptType"];
            [passDic2 setValue:[[PayNucHelper sharedInstance] pinenc:payPwd type:@"paypass"] forKey:@"password"];
            [paypassDic setObject:passDic2 forKey:@"pass"];
            [regAuthToolsArray1 addObject:paypassDic];
            
        }
        NSString *regAuthTools = [[PayNucHelper sharedInstance] arrayToJSON:regAuthToolsArray1];
        [SDLog logTest:regAuthTools];
        
        paynuc.set("userInfo", [userInfo1 UTF8String]);
        paynuc.set("regAuthTools", [regAuthTools UTF8String]);
        [[SDRequestHelp shareSDRequest] requestWihtFuncName:@"user/register/v1" errorBlock:^(SDRequestErrorType type) {
            error = YES;
        } successBlock:^{
            [[SDRequestHelp shareSDRequest] dispatchToMainQueue:^{
                [HUD hidden];
                
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
        
        result = [SDSqlite insertData:[SqliteHelper shareSqliteHelper].sandBaoDB sql:[NSString stringWithFormat:@"insert into usersconfig (uid, userName, active, sToken, credit_fp, lets) values ('%@', '%@', '%@', '%@', '%@', '%@')", [CommParameter sharedInstance].userId, _phoneNumStr, @"0", sToken, creditFp, letsJson]];
    }
    //注册成功->跳转
    if (result == YES) {
        if (_isOtherAPPSPS) {
            //第三方app跳转杉德宝进行注册-支付流程
            SpsPayViewController *mSpsPayViewController = [[SpsPayViewController alloc] init];
            mSpsPayViewController.controllerIndex = SDQRPAY; //设置支付类型为扫码支付
            NSArray *urlArr = [_otherAPPSPSurl componentsSeparatedByString:@"TN:"];
            urlArr = [[urlArr lastObject] componentsSeparatedByString:@"?"];
            NSString *tn = [urlArr firstObject];
            mSpsPayViewController.TN = tn;
            mSpsPayViewController.otherAPPSPSurl = _otherAPPSPSurl;
            //Sps模态切换,因此为其创建一个导航,(sps结束后模态切换即可销毁)
            UINavigationController *navSps = [[UINavigationController alloc] initWithRootViewController:mSpsPayViewController];
            [self presentViewController:navSps animated:YES completion:nil];
            _isOtherAPPSPS = NO;
        }else{
            //杉德宝自有注册流程
            MainViewController *mMainViewController = [[MainViewController alloc] init];
            [self presentViewController:mMainViewController animated:NO completion:nil];
        }
    } else {
    //数据写入失败->返回直接登陆
        [Tool showDialog:@"用户数据存储失败,请返回直接登陆" defulBlock:^{
            [self.navigationController popToRootViewControllerAnimated:YES];
        }];
    }
}

/**
 *@brief 重置支付密码
 */
- (void)pushRegAuthTools
{
    HUD = [SDMBProgressView showSDMBProgressOnlyLoadingINViewImg:self.view];
    [SDRequestHelp shareSDRequest].HUD = HUD;
    [SDRequestHelp shareSDRequest].controller = self;
    [[SDRequestHelp shareSDRequest] dispatchGlobalQuque:^{
        __block BOOL error = NO;
        NSMutableArray *tempArray = [[NSMutableArray alloc] init];
        NSInteger index = 0;
        for (int i = 0; i<regAuthToolsArray.count; i++) {
            NSString *type = @"paypass";
            NSString *typeGet = [regAuthToolsArray[i] objectForKey:@"type"];
            if ([type isEqualToString:typeGet]) {
                index = i;
            }
        }
        
        NSMutableDictionary *dic = regAuthToolsArray[index];
        NSMutableDictionary *authToolsDic = [NSMutableDictionary dictionaryWithDictionary:dic];
        [authToolsDic removeObjectForKey:@"pass"];
        NSMutableDictionary *passDic = [[NSMutableDictionary alloc] init];
        [passDic setValue:[[PayNucHelper sharedInstance] pinenc:payPwd type:@"paypass"] forKey:@"password"];
        [passDic setValue:@"" forKey:@"description"];
        [passDic setValue:@"sand" forKey:@"encryptType"];
        [passDic setValue:@"" forKey:@"regular"];
        [authToolsDic setObject:passDic forKey:@"pass"];
        [tempArray addObject:authToolsDic];
        NSString *regAuthTools = [[PayNucHelper sharedInstance] arrayToJSON:tempArray];
        
        [SDLog logTest:regAuthTools];
        paynuc.set("regAuthTools", [regAuthTools UTF8String]);
        [[SDRequestHelp shareSDRequest] requestWihtFuncName:@"authTool/setRegAuthTools/v1" errorBlock:^(SDRequestErrorType type) {
            error = YES;
        } successBlock:^{
            [[SDRequestHelp shareSDRequest] dispatchToMainQueue:^{
                [HUD hidden];
                
                [Tool showDialog:@"支付密码修改成功" defulBlock:^{
                    [self.navigationController popToRootViewControllerAnimated:YES];
                }];

            }];
        }];
        if (error) return ;
    }];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

@end
