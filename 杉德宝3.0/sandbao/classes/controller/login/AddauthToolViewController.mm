//
//  AddauthViewController.m
//  sandbao
//
//  Created by tianNanYiHao on 2017/4/17.
//  Copyright © 2017年 sand. All rights reserved.
//

#import "AddauthToolViewController.h"
#import "GroupView.h"


#import "SDLog.h"
#import "PayNucHelper.h"
#include "RegisterViewController.h"
#import "MainViewController.h"
#import "CheckUserViewController.h"
#import "CommParameter.h"
#import "DropDownListView.h"
#import "SqliteHelper.h"
#import "SDSqlite.h"
#import "SpsPayViewController.h"


#define lineViewColor RGBA(237, 237, 237, 1.0)
#define textFiledColor RGBA(200, 199, 204, 1.0)
#define btnColor RGBA(255, 97, 51, 1.0)
#define titleColor RGBA(20, 20, 20, 1.0)
#define viewColor RGBA(255, 255, 255, 1.0)
@interface AddauthToolViewController ()<UITextFieldDelegate>
{
    NavCoverView *navCoverView;
}
@property (nonatomic, assign) CGSize viewSize;
@property (nonatomic, assign) CGFloat viewHeight;
@property (nonatomic, assign) CGFloat moveTop;
@property (nonatomic, assign) CGFloat leftRightSpace;
@property (nonatomic, assign) CGFloat textFieldTextSize;
@property (nonatomic, assign) CGFloat btnTextSize;
@property (nonatomic, assign) CGFloat btnW;
@property (nonatomic, assign) CGFloat btnH;

@property (nonatomic, strong) SDMBProgressView *HUD;


@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UIButton *loginBtn;

@property (nonatomic, assign) CGFloat shortMsgBtnW;
@property (nonatomic, assign) CGFloat shortMsgBtnH;
@property (nonatomic, assign) int timeOut;
@property (nonatomic, assign) int timeCount;
@property (nonatomic, assign) BOOL dropDownFlag;
@property (nonatomic, assign) BOOL showPwdFlag;
@property (nonatomic, assign) CGFloat textFieldTag;

@property (nonatomic, strong) NSTimer *timer;
@property (nonatomic, strong) UITextField *phoneNumTextField;
@property (nonatomic, strong) UITextField *shortMsgTextField;
@property (nonatomic, strong) UITextField *loginPwdTextField;
@property (nonatomic, strong) UITextField *payPwdTextField;
@property (nonatomic, strong) UITextField *IDCardTextField;
@property (nonatomic, strong) UITextField *pictureNumTextField;
@property (nonatomic, strong) UITextField *bankCardTextField;
@property (nonatomic, strong) UITextField *questionTextField;
@property (nonatomic, strong) UIButton *shortMsgBtn;
@property (nonatomic, strong) UIButton *loginPwdBtn;
@property (nonatomic, strong) UIButton *pictureBtn;
@property (nonatomic, strong) UILabel *questionTitleLabel;
@property (nonatomic, strong) UIButton *questionBtn;
@property (nonatomic, strong) UILabel *questionlabel;

@property (nonatomic, strong) NSArray *regAuthToolsArray;

@property (nonatomic, strong) NSMutableArray *userArray;
@property (nonatomic, strong) UIView *inputView;
@end

@implementation AddauthToolViewController

@synthesize viewSize;
@synthesize viewHeight;
@synthesize moveTop;
@synthesize leftRightSpace;
@synthesize textFieldTextSize;
@synthesize btnTextSize;
@synthesize btnW;
@synthesize btnH;
@synthesize loginBtn;


@synthesize HUD;


@synthesize scrollView;



@synthesize shortMsgBtnW;
@synthesize shortMsgBtnH;
@synthesize timeOut;
@synthesize timeCount;
@synthesize dropDownFlag;
@synthesize showPwdFlag;
@synthesize textFieldTag;


@synthesize timer;
@synthesize phoneNumTextField;
@synthesize shortMsgTextField;
@synthesize loginPwdTextField;
@synthesize payPwdTextField;
@synthesize IDCardTextField;
@synthesize pictureNumTextField;
@synthesize bankCardTextField;
@synthesize questionTextField;
@synthesize shortMsgBtn;
@synthesize loginPwdBtn;
@synthesize pictureBtn;
@synthesize regAuthToolsArray;
@synthesize questionTitleLabel;
@synthesize questionBtn;
@synthesize questionlabel;


@synthesize userArray;
@synthesize inputView;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self.view setBackgroundColor:RGBA(255, 255, 255, 1.0)];
    viewSize = self.view.bounds.size;
    leftRightSpace = 15;
    timeOut = 90;
    textFieldTag = 0;
    
    
    
    
    [self settingNavigationBar];
    [self addView:self.view];

}



#pragma mark - 点击空白处隐藏键盘
/**
 点击空白处隐藏键盘
 @param touches
 @param event
 */
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self dismissKeyboard];
}
#pragma mark - 设置导航栏
/**
 *@brief 设置导航栏
 *@return
 */
- (void)settingNavigationBar
{
    //导航渐变条
    navCoverView = [NavCoverView shareNavCoverView:CGRectMake(0, 0, viewSize.width, controllerTop) title:@"加强鉴权"];
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
    
}

#pragma mark - 创建组件
/**
 *@brief 创建组件
 *@param view UIView 参数：组件
 *@return
 */
-(void)addView:(UIView *)view
{
    

        textFieldTextSize = 13;
        btnTextSize = 15;

    
    //创建UIScrollView
    scrollView = [[UIScrollView alloc] init];
    scrollView.userInteractionEnabled = YES;
    scrollView.scrollEnabled = YES;
    scrollView.contentSize = CGSizeMake(viewSize.width, viewSize.height - 64);
    scrollView.directionalLockEnabled = YES; //只能一个方向滑动
    scrollView.pagingEnabled = NO; //是否翻页
    scrollView.showsVerticalScrollIndicator =YES; //垂直方向的滚动指示
    scrollView.indicatorStyle = UIScrollViewIndicatorStyleWhite;//滚动指示的风格
    scrollView.showsHorizontalScrollIndicator = NO;//水平方向的滚动指示
    [scrollView setBackgroundColor:RGBA(255, 255, 255, 1.0)];
    [view addSubview:scrollView];
    self.automaticallyAdjustsScrollViewInsets = NO;
    

    
    //鉴权区
    UIView *authToolsView = [[UIView alloc] init];
    authToolsView.backgroundColor = viewColor;
    [scrollView addSubview:authToolsView];
    
    CGFloat authToolsViewH = [self addAuthToolsView:authToolsView];

    
    //登录按钮
    loginBtn = [[UIButton alloc] init];
    [loginBtn setTag:2];
    [loginBtn setTitle:@"登录" forState: UIControlStateNormal];
    [loginBtn setTitleColor:RGBA(255, 255, 255, 1.0) forState:UIControlStateNormal];
    loginBtn.titleLabel.font = [UIFont systemFontOfSize:btnTextSize];
    [loginBtn.layer setMasksToBounds:YES];
    loginBtn.layer.cornerRadius = 5.0;
    [loginBtn addTarget:self action:@selector(buttonActionToDoSomething:) forControlEvents:UIControlEventTouchUpInside];
    [scrollView addSubview:loginBtn];
    

    
    
    //设置控件的位置和大小
    CGFloat commWidth = viewSize.width - 2 * leftRightSpace;
    CGFloat scrollViewH = viewSize.height - controllerTop;
    CGSize loginBtnSize = [loginBtn.titleLabel sizeThatFits:CGSizeMake(commWidth, MAXFLOAT)];
    CGFloat loginBtnHeight = loginBtnSize.height + 2 * leftRightSpace;

    
    
    btnW = commWidth;
    btnH = loginBtnHeight;
    [self textFiledEditChanged];
    
    
    [scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(view).offset(controllerTop);
        make.centerX.equalTo(self.view);
        make.size.mas_equalTo(CGSizeMake(viewSize.width, scrollViewH));
    }];
    
    
    [authToolsView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(scrollView).offset(0);
        make.centerX.equalTo(scrollView);
        make.size.mas_equalTo(CGSizeMake(viewSize.width, authToolsViewH));
    }];
    
    [loginBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(authToolsView.mas_bottom).offset(60.55);
        make.centerX.equalTo(scrollView);
        make.size.mas_equalTo(CGSizeMake(btnW, btnH));
    }];
    
       
    [self setInputResponderChain];
    [self listenNotifier];

}

/**
 *@brief 添加鉴权工具view
 *@param view UIView 参数：组件
 *@return CGFloat
 */
- (CGFloat)addAuthToolsView:(UIView *)view
{
    CGFloat lineViewHeight = 1;
    CGFloat tempHeight = 0;
    CGFloat allHeight = 0;
    CGFloat groupViewHight = 0;
    
    NSInteger authToolsArrayCount = [_addauthToolsArray count];
    for (int i = 0; i < authToolsArrayCount; i++) {
        NSMutableDictionary *dic = _addauthToolsArray[i];
        NSString *type = [dic objectForKey:@"type"];
        
        GroupView *groupView = [[GroupView alloc] initWithFrame:self.view.frame];
        groupView.groupViewStyle = GroupViewStyleYes;
        tempHeight = tempHeight + groupViewHight;
        textFieldTag = textFieldTag + 1;
        
        if ([@"sms" isEqualToString:type]) {

            groupViewHight = [groupView shortMsgAndPhoneNumVerification];
            allHeight = allHeight + groupViewHight;
            phoneNumTextField = groupView.phoneNumVerificationTextField;
            shortMsgBtn = groupView.shortMsgVerificationBtn;
            shortMsgTextField = groupView.shortMsgVerificationTextField;
            
            shortMsgBtn.tag = 201;
            phoneNumTextField.tag = textFieldTag;
            [phoneNumTextField setMinLenght:@"0"];
            [phoneNumTextField setMaxLenght:@"11"];
            phoneNumTextField.userInteractionEnabled = NO;
            phoneNumTextField.text = [[dic objectForKey:type] objectForKey:@"phoneNo"];
            textFieldTag = textFieldTag + 1;
            shortMsgTextField.tag = textFieldTag;
            [shortMsgTextField setMinLenght:@"0"];
            [shortMsgTextField setMaxLenght:@"6"];
            
            [shortMsgBtn addTarget:self action:@selector(buttonActionToDoSomething:) forControlEvents:UIControlEventTouchUpInside];
            
            CGSize shortMsgBtnSize = shortMsgBtn.frame.size;
            shortMsgBtnW = shortMsgBtnSize.width;
            shortMsgBtnH = shortMsgBtnSize.height;
        }
        
        if ([@"loginpass" isEqualToString:type]) {
            
            groupViewHight = [groupView loginPwdVerification];
            allHeight = allHeight + groupViewHight;
            loginPwdBtn = groupView.loginPwdVerificationBtn;
            loginPwdTextField = groupView.loginPwdVerificationTextField;
            loginPwdTextField.text = @"";
            
            loginPwdTextField.tag = textFieldTag;
            loginPwdBtn.tag = 202;
            [loginPwdTextField setMinLenght:@"8"];;
            [loginPwdTextField setMaxLenght:@"20"];
            
            [loginPwdBtn addTarget:self action:@selector(buttonActionToDoSomething:) forControlEvents:UIControlEventTouchUpInside];
        }
        
        if ([@"paypass" isEqualToString:type]) {
            
            groupViewHight = [groupView loginPwdVerification];
            allHeight = allHeight + groupViewHight;
            //            payPwdTextField = groupView.loginPwdVerificationTextField;
        }
        
        if ([@"gesture" isEqualToString:type]) {
            
            groupViewHight = [groupView shortMsgAndPhoneNumVerification];
            allHeight = allHeight + groupViewHight;
            
        }
        
        if ([@"question" isEqualToString:type]) {
            
            groupViewHight = [groupView miBaoQuestionVerification];
            allHeight = allHeight + groupViewHight;
            questionTextField = groupView.miBaoAnswerVerificationTextField;
            questionTitleLabel = groupView.miBaoTitleLabel;
            questionlabel = groupView.miBaoTQuestionLabel;
            questionBtn = groupView.miBaobtn;
        }
        
        if ([@"identity" isEqualToString:type]) {
            
            groupViewHight = [groupView IDCardVerification];
            allHeight = allHeight + groupViewHight;
            IDCardTextField = groupView.IDCardVerificationTextField;
            IDCardTextField.tag = textFieldTag;
        }
        
        if ([@"img" isEqualToString:type]) {
            
            groupViewHight = [groupView pictureVerification];
            allHeight = allHeight + groupViewHight;
            pictureBtn = groupView.pictureVerificationBtn;
            pictureBtn.tag = 203;
            pictureNumTextField = groupView.pictureVerificationTextField;
            pictureNumTextField.tag = textFieldTag;
        }
        
        if ([@"bankcard" isEqualToString:type]) {
            
            groupViewHight = [groupView bankCardVerification];
            allHeight = allHeight + groupViewHight;
            bankCardTextField = groupView.bankCardVerificationTextField;
            bankCardTextField.tag = textFieldTag;
        }
        
        if (i == 0) {
            groupView.frame = CGRectMake(0, 0, viewSize.width, groupViewHight);
        } else {
            if (i > 0 && i < authToolsArrayCount) {
                UIView *lineView = [[UIView alloc] init];
                lineView.frame = CGRectMake(leftRightSpace, tempHeight, viewSize.width - leftRightSpace, lineViewHeight);
                lineView.backgroundColor = lineViewColor;
                [view addSubview:lineView];
            }
            tempHeight = tempHeight + lineViewHeight;
            groupView.frame = CGRectMake(0, tempHeight, viewSize.width, groupViewHight);
        }
        
        
        [view addSubview:groupView];
    }
    
    return allHeight;
}
/**
 *@brief 输入数据验证
 */
- (void)verificationInput
{
    if (shortMsgTextField.text.length != [shortMsgTextField.maxLenght intValue] ) {
        return [Tool showDialog:@"请输入6位正确短信验证码，请重新输入。"];
    }
    
    [self loginUser];
}

/**
 *@brief 用户登录
 */
- (void)loginUser
{
    HUD = [SDMBProgressView showSDMBProgressOnlyLoadingINViewImg:self.view];
    [SDRequestHelp shareSDRequest].HUD = HUD;
    [SDRequestHelp shareSDRequest].controller = self;
    [[SDRequestHelp shareSDRequest] dispatchGlobalQuque:^{
        __block BOOL error = NO;
        //校验手机验证码
        NSMutableDictionary *authToolsDic2 = [[NSMutableDictionary alloc] init];
        [authToolsDic2 setValue:@"sms" forKey:@"type"];
        NSMutableDictionary *smsDic = [[NSMutableDictionary alloc] init];
        [smsDic setValue:phoneNumTextField.text forKey:@"phoneNo"];
        [smsDic setValue:shortMsgTextField.text forKey:@"code"];
        [authToolsDic2 setObject:smsDic forKey:@"sms"];
        [_authToolsArray1 addObject:authToolsDic2];
        
        
        NSString *authTools = [[PayNucHelper sharedInstance] arrayToJSON:_authToolsArray1];
        NSString *userinfo = _userInfo;
        paynuc.set("authTools", [authTools UTF8String]);
        paynuc.set("userInfo", [userinfo UTF8String]);
        
        [[SDRequestHelp shareSDRequest] requestWihtFuncName:@"user/login/v1" errorBlock:^(SDRequestErrorType type) {
            error = YES;
        } successBlock:^{
            [[SDRequestHelp shareSDRequest] dispatchToMainQueue:^{
                [HUD hidden];
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
        result = [SDSqlite updateData:[SqliteHelper shareSqliteHelper].sandBaoDB sql:[NSString stringWithFormat:@"update usersconfig set active = '%@', sToken = '%@', userName = '%@' ,credit_fp = '%@'  where uid = '%@'", @"0", [CommParameter sharedInstance].sToken, _phoneNumberStr, creditFp, [CommParameter sharedInstance].userId]];
        
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
        
        result = [SDSqlite insertData:[SqliteHelper shareSqliteHelper].sandBaoDB sql:[NSString stringWithFormat:@"insert into usersconfig (uid, userName, active, sToken, credit_fp, lets) values ('%@', '%@', '%@', '%@', '%@', '%@')", [CommParameter sharedInstance].userId, _phoneNumberStr, @"0", [CommParameter sharedInstance].sToken, creditFp, letsJson]];
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
    HUD = [SDMBProgressView showSDMBProgressOnlyLoadingINViewImg:self.view];
    [SDRequestHelp shareSDRequest].HUD = HUD;
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
                [HUD hidden];
                
                NSArray *payToolsArray = [[PayNucHelper sharedInstance] jsonStringToArray:[NSString stringWithUTF8String:paynuc.get("payTools").c_str()]];
                //根据order 字段排序
                payToolsArray = [Tool orderForPayTools:payToolsArray];
                [CommParameter sharedInstance].ownPayToolsArray = payToolsArray;
                
                //明登陆情况下启动SPS(不进入主页面)
                if (_isOtherAPPSPS) {
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
                    //正常明登陆(进入主页面)
                    if (_isStokenOver == YES) {
                        [[NSNotificationCenter defaultCenter] postNotificationName:LOGOUTNOTICEBARITEM object:nil];
                        [[NSNotificationCenter defaultCenter] postNotificationName:LOGOUTNOTICEMQTT object:nil];
                        [self dismissViewControllerAnimated:YES completion:nil];
                    }else{
                        MainViewController *mMainViewController = [[MainViewController alloc] init];
                        [self presentViewController:mMainViewController animated:YES completion:nil];
                    }
                }
            }];
        }];
        if (error) return ;

    }];
}

/**
 *@brief 短信码倒计时
 */
- (void)shortMsgCodeCountDown
{
    timer = [NSTimer timerWithTimeInterval:1 target:self selector:@selector(refreshTime) userInfo:nil repeats:YES];
    
    [[NSRunLoop mainRunLoop] addTimer:timer forMode:NSRunLoopCommonModes];
}

/**
 *@brief 短信码倒计时
 */
- (void)refreshTime
{
    timeCount--;
    if (timeCount < 0) {
        [timer invalidate];
        timer = nil;
        [shortMsgBtn setUserInteractionEnabled:YES];
        [shortMsgBtn setTitle:@"重发一次" forState: UIControlStateNormal];
        [shortMsgBtn setTitle:@"重发一次" forState:UIControlStateHighlighted];
    } else {
        NSString *time = [NSString stringWithFormat:@"%d秒", timeCount];
        [shortMsgBtn setUserInteractionEnabled:NO];
        [shortMsgBtn setTitle:time forState: UIControlStateNormal];
    }
}

/**
 *@brief 获取短信验证码
 */
- (void)shortMsg
{
    HUD = [SDMBProgressView showSDMBProgressOnlyLoadingINViewImg:self.view];
    [SDRequestHelp shareSDRequest].HUD = HUD;
    [SDRequestHelp shareSDRequest].controller = self;
    [[SDRequestHelp shareSDRequest] dispatchGlobalQuque:^{
        __block BOOL error = NO;
        
        NSMutableDictionary *authToolDic = [[NSMutableDictionary alloc] init];
        [authToolDic setValue:@"sms" forKey:@"type"];
        NSMutableDictionary *smsDic = [[NSMutableDictionary alloc] init];
        [smsDic setValue:phoneNumTextField.text forKey:@"phoneNo"];
        [smsDic setValue:shortMsgTextField.text forKey:@"code"];
        [authToolDic setObject:smsDic forKey:@"sms"];
        
        NSString *authTool = [[PayNucHelper sharedInstance] dictionaryToJson:authToolDic];
        
        [SDLog logTest:authTool];
        
        paynuc.set("authTool", [authTool UTF8String]);

        [[SDRequestHelp shareSDRequest] requestWihtFuncName:@"authTool/pushAuthToolData/v1" errorBlock:^(SDRequestErrorType type) {
            error = YES;
        } successBlock:^{
            [[SDRequestHelp shareSDRequest] dispatchToMainQueue:^{
                [HUD hidden];
                [self shortMsgCodeCountDown];
            }];
        }];
        if (error) return ;
    }];
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
        case 101:
        {
            [self.navigationController popViewControllerAnimated:YES];
        }
            break;
        case 102:
        {
            
        }
            break;
        case 2:
        {
            [self dismissKeyboard];
            [self verificationInput];
        }
            break;
        case 201:
        {
            [self dismissKeyboard];
            timeCount = timeOut;
            shortMsgTextField.text = SHOWTOTEST(@"111111");
            [self shortMsg];
        }
            break;

        default:
            break;
    }
}

#pragma mark - 把所有的输入框放到数组中
/**
 *@brief 把所有的输入框放到数组中
 *@return NSArray
 */
- (NSArray *)allInputFields {
    return @[shortMsgTextField];
}

/**
 *@brief 为所有的输入框设置键盘类型
 */
- (void)setInputResponderChain {
    
    NSArray *textFields = [self allInputFields];
    for (UIResponder *responder in textFields) {
        if ([responder isKindOfClass:[UITextField class]]) {
            UITextField *textField = (UITextField *)responder;
            textField.returnKeyType = UIReturnKeyNext;
            textField.autocorrectionType = UITextAutocorrectionTypeNo;
            textField.delegate = self;
        }
    }
    shortMsgTextField.keyboardType = UIKeyboardTypeNumberPad;
    shortMsgTextField.returnKeyType = UIReturnKeyDone;
}
#pragma mark - UITextFieldDelegate

-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    CGFloat allHeight = viewHeight * (textField.tag + 1) + moveTop;
    
    CGFloat offset = allHeight -(self.view.frame.size.height-252.0 - 64);//键盘高度216
    
    
    if (offset > 0) {
        [scrollView setContentOffset:CGPointMake(0.0f, offset) animated:YES] ;
    }
}

/**
 *当用户按下return键或者按回车键，我们注销KeyBoard响应，它会自动调用textFieldDidEndEditing函数
 */
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (textField.returnKeyType == UIReturnKeyDone) {
        [self dismissKeyboard];
    }
    
    return [self setNextResponder:textField] ? NO : YES;
}
/**
 *@brief 设置输入框响应
 *@param UITextField textField 参数：输入框
 *@return Bool
 */
- (BOOL)setNextResponder:(UITextField *)textField {
    
    NSArray *textFields = [self allInputFields];
    NSInteger indexOfInput = [textFields indexOfObject:textField];
    if (indexOfInput != NSNotFound && indexOfInput < textFields.count - 1) {
        UIResponder *next = [textFields objectAtIndex:(NSUInteger)(indexOfInput + 1)];
        if ([next canBecomeFirstResponder]) {
            [next becomeFirstResponder];
            return YES;
        }
    }
    return NO;
}
#pragma mark - 限制键盘输入某些字符
-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    
    if ([textField.placeholder rangeOfString:@"手机号"].location !=NSNotFound) {
        return [self restrictionwithTypeStr:OnlyNumberVerifi string:string];
    }
    if ([textField.placeholder rangeOfString:@"密码"].location !=NSNotFound) {
        return [self restrictionwithTypeStr:OnlyNum_letterVerifi string:string];
    }
    if ([textField.placeholder rangeOfString:@"数字验证码"].location !=NSNotFound) {
        return [self restrictionwithTypeStr:OnlyNumberVerifi string:string];
    }
    return YES;
    
}
-(BOOL)restrictionwithTypeStr:(NSString*)typeStr string:(NSString*)string{
    NSCharacterSet *cs = [[NSCharacterSet characterSetWithCharactersInString:typeStr] invertedSet];
    NSString *filtered = [[string componentsSeparatedByCharactersInSet:cs] componentsJoinedByString:@""];
    if ([string isEqualToString:@""]) { //不过滤回退键
        return YES;
    }
    if ([string isEqualToString:filtered]) {
        return YES;
    }else{
        return NO;  //过滤
    }
}
#pragma mark - 监听通知
- (void)listenNotifier
{
    if (phoneNumTextField) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFiledEditChanged:) name:UITextFieldTextDidChangeNotification object:phoneNumTextField];
    }
    
    if (shortMsgTextField) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFiledEditChanged:) name:UITextFieldTextDidChangeNotification object:shortMsgTextField];
    }
    
    if (loginPwdTextField) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFiledEditChanged:) name:UITextFieldTextDidChangeNotification object:loginPwdTextField];
    }
    
    if (IDCardTextField) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFiledEditChanged:) name:UITextFieldTextDidChangeNotification object:IDCardTextField];
    }
    
    if (pictureNumTextField) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFiledEditChanged:) name:UITextFieldTextDidChangeNotification object:pictureNumTextField];
    }
    
    if (questionTextField) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFiledEditChanged:) name:UITextFieldTextDidChangeNotification object:questionTextField];
    }
    
    if (bankCardTextField) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFiledEditChanged:) name:UITextFieldTextDidChangeNotification object:bankCardTextField];
    }
    
    if (payPwdTextField) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFiledEditChanged:) name:UITextFieldTextDidChangeNotification object:payPwdTextField];
    }
}

- (void)textFiledEditChanged:(NSNotification *)obj
{
    UITextField *textField = (UITextField *)obj.object;
    NSString *content = textField.text;
    
    int maxLenght = [textField.maxLenght intValue];
    NSInteger lenght = content.length;
    
    if(maxLenght > 0) {
        // 键盘输入模式
        NSArray *currentar = [UITextInputMode activeInputModes];
        UITextInputMode *current = [currentar firstObject];
        NSString *lang = [current primaryLanguage];
        // 简体中文输入，包括简体拼音，健体五笔，简体手写
        if ([lang isEqualToString:@"zh-Hans"]) {
            UITextRange *selectedRange = [textField markedTextRange];
            //获取高亮部分
            UITextPosition *position = [textField positionFromPosition:selectedRange.start offset:0];
            // 没有高亮选择的字，则对已输入的文字进行字数统计和限制
            if (!position) {
                if (lenght > maxLenght) {
                    textField.text = [content substringToIndex:maxLenght];
                }
            }
            // 有高亮选择的字符串，则暂不对文字进行统计和限制
        } else {
            if (lenght > maxLenght) {
                textField.text = [content substringToIndex:maxLenght];
            }
        }
        
        if ([NSRegularExpression validateSpecialBlankChar:[content substringWithRange:NSMakeRange(lenght - 1, 1)]]) {
            [self dismissKeyboard];
            //[Tool showDialog:@"不能输入空格符"];
            textField.text = [content substringWithRange:NSMakeRange(0, lenght - 1)];
            return;
        }
    }
    [self textFiledEditChanged];
    
}


- (void)textFiledEditChanged
{
    if (phoneNumTextField) {
        if ([@"" isEqualToString:phoneNumTextField.text] || phoneNumTextField.text == nil) {
            return [self changeBtnBackGround:nil index:1];
        }else {
            [self changeBtnBackGround:@"yes" index:3];
        }
    }
    
    if (shortMsgTextField) {
        if ([@"" isEqualToString:shortMsgTextField.text] || shortMsgTextField.text == nil) {
            return [self changeBtnBackGround:nil index:2];
        }
    }
    
    if (loginPwdTextField) {
        if ([@"" isEqualToString:loginPwdTextField.text] || loginPwdTextField.text == nil) {
            return [self changeBtnBackGround:nil index:2];
        }
    }
    
    if (payPwdTextField) {
        if ([@"" isEqualToString:payPwdTextField.text] || payPwdTextField.text == nil) {
            return [self changeBtnBackGround:nil index:2];
        }
    }
    
    if (IDCardTextField) {
        if ([@"" isEqualToString:IDCardTextField.text] || IDCardTextField.text == nil) {
            return [self changeBtnBackGround:nil index:2];
        }
    }
    
    if (pictureNumTextField) {
        if ([@"" isEqualToString:pictureNumTextField.text] || pictureNumTextField.text == nil) {
            return [self changeBtnBackGround:nil index:2];
        }
    }
    
    if (bankCardTextField) {
        if ([@"" isEqualToString:bankCardTextField.text] || bankCardTextField.text == nil) {
            return [self changeBtnBackGround:nil index:2];
        }
    }
    
    if (questionTextField) {
        if ([@"" isEqualToString:shortMsgTextField.text] || shortMsgTextField.text == nil) {
            return [self changeBtnBackGround:nil index:2];
        }
    }
    return [self changeBtnBackGround:@"yes" index:1];
}
#pragma mark - 改变按钮背景图片
/**
 *@brief  改变按钮背景图片
 *@param param NSString 参数：字符串
 *@return
 */
- (void)changeBtnBackGround:(NSString *)param index:(int)index
{
    if (index == 1) {
        if (![@"" isEqualToString:param] && param != nil) {
            [shortMsgBtn setTitleColor:RGBA(65, 131, 215, 1.0) forState:UIControlStateNormal];
            shortMsgBtn.userInteractionEnabled = YES;
            
            [loginBtn setBackgroundImage:[UIImage imageWithColor:RGBA(65, 131, 215, 1.0) size:CGSizeMake(btnW, btnH)] forState:UIControlStateNormal];
            
            [loginBtn setBackgroundImage:[UIImage imageWithColor:RGBA(65, 131, 215, 1.0) size:CGSizeMake(btnW, btnH)] forState:UIControlStateHighlighted];
            
            loginBtn.userInteractionEnabled = YES;
        } else {
            [shortMsgBtn setTitleColor:RGBA(200, 199, 204, 1.0) forState:UIControlStateNormal];
            shortMsgBtn.userInteractionEnabled = NO;
            
            
            [loginBtn setBackgroundImage:[UIImage imageWithColor:RGBA(200, 200, 200, 1.0) size:CGSizeMake(btnW, btnH)] forState:UIControlStateNormal];
            
            [loginBtn setBackgroundImage:[UIImage imageWithColor:RGBA(200, 200, 200, 1.0) size:CGSizeMake(btnW, btnH)] forState:UIControlStateHighlighted];
            
            loginBtn.userInteractionEnabled = NO;
        }
    } else if (index == 2) {
        if (![@"" isEqualToString:param] && param != nil) {
            [loginBtn setBackgroundImage:[UIImage imageWithColor:RGBA(65, 131, 215, 1.0) size:CGSizeMake(btnW, btnH)] forState:UIControlStateNormal];
            
            [loginBtn setBackgroundImage:[UIImage imageWithColor:RGBA(65, 131, 215, 1.0) size:CGSizeMake(btnW, btnH)] forState:UIControlStateHighlighted];
            
            loginBtn.userInteractionEnabled = YES;
        } else {
            [loginBtn setBackgroundImage:[UIImage imageWithColor:RGBA(200, 200, 200, 1.0) size:CGSizeMake(btnW, btnH)] forState:UIControlStateNormal];
            
            [loginBtn setBackgroundImage:[UIImage imageWithColor:RGBA(200, 200, 200, 1.0) size:CGSizeMake(btnW, btnH)] forState:UIControlStateHighlighted];
            
            loginBtn.userInteractionEnabled = NO;
        }
    } else {
        if (![@"" isEqualToString:param] && param != nil) {
            [shortMsgBtn setTitleColor:RGBA(65, 131, 215, 1.0) forState:UIControlStateNormal];
            
            shortMsgBtn.userInteractionEnabled = YES;
        } else {
            [shortMsgBtn setTitleColor:RGBA(200, 199, 204, 1.0) forState:UIControlStateNormal];
            
            shortMsgBtn.userInteractionEnabled = NO;
        }
    }
}


/**
 *@brief 隐藏键盘
 */
- (void)dismissKeyboard {
    //将视图的Y坐标向上移动offset个单位，以使下面腾出地方用于软键盘的显示
    [scrollView setContentOffset:CGPointMake(0.0f, 0.0f) animated:YES] ;
    [self.view endEditing:YES];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
