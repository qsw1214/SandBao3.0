//
//  LoginViewController.m
//  sandbao
//
//  Created by tianNanYiHao on 2017/1/13.
//  Copyright © 2017年 sand. All rights reserved.
//

#import "LoginViewController.h"
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
#import "AppDelegate.h"
#import "AddauthToolViewController.h"
#import "Base64Util.h"


#define WEIBO @"weibo"


#define lineViewColor RGBA(237, 237, 237, 1.0)
#define textFiledColor RGBA(200, 199, 204, 1.0)
#define btnColor RGBA(255, 97, 51, 1.0)
#define titleColor RGBA(20, 20, 20, 1.0)
#define viewColor RGBA(255, 255, 255, 1.0)

@interface LoginViewController ()<UITextFieldDelegate, DropDownListViewDelegate,SDWeiBoDelegate>
{
    CGFloat littleBtnSize;
    CGFloat popPhoneNumY;
    UIButton *phoneNumBtn;
    AppDelegate *appDelegate;
    UIImage *headImage;
    UIImageView *headImageView;
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
@property (nonatomic, strong) NSMutableArray *authToolsArray;
@property (nonatomic, strong) NSArray *regAuthToolsArray;


@property (nonatomic, strong) NSString *phoneNum;
@property (nonatomic, strong) NSString *loginPwd;


@property (nonatomic, strong) UIView *phoneNumView;
@property (nonatomic, strong) NSMutableArray *userArray;
@property (nonatomic, strong) DropDownListView *dropDownListView;
@property (nonatomic, strong) UIView *inputView;
@property (nonatomic, strong) NSMutableArray *authToolsArray1;

@end

@implementation LoginViewController

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
@synthesize authToolsArray;
@synthesize regAuthToolsArray;
@synthesize questionTitleLabel;
@synthesize questionBtn;
@synthesize questionlabel;


@synthesize phoneNum;
@synthesize loginPwd;


@synthesize phoneNumView;
@synthesize userArray;
@synthesize dropDownListView;
@synthesize inputView;



-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self load];
    self.navigationController.navigationBarHidden = YES;
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault animated:NO];
}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:NO];
    [self.view.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.view setBackgroundColor:RGBA(255, 255, 255, 1.0)];
    viewSize = self.view.bounds.size;
    leftRightSpace = 15;
    timeOut = 90;

    phoneNum = SHOWTOTEST(@"15151474888") ;
    loginPwd = SHOWTOTEST(@"qqqqqq111");
    authToolsArray = [[NSMutableArray alloc] init];
    
    
    
    

    
//    [self settingNavigationBar];
//    [self addView:self.view];
    
    appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    
    [self dropDownListData];
    
    //登出情况下,第三方应用调用杉德宝启动SPS支付
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(openSPSPay:) name:OPENSPSPAYNOTICELOGOUT object:nil];
    
}


-(void)openSPSPay:(NSNotification*)noti{
    //未登录但AppState状态为 active时, 拦截loginviewcontreller跳转SPS支付
    _isOtherAPPSPS = YES;
    _otherAPPSPSurl = noti.object;

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
    NavCoverView *navCoverView = [NavCoverView shareNavCoverView:CGRectMake(0, 0, viewSize.width, controllerTop) title:@"登陆"];
    [self.view addSubview:navCoverView];
    
    // 2.设置左边的返回item
    UIImage *leftImage = [UIImage imageNamed:@"back"];
    UIButton *leftBarBtn = [[UIButton alloc] init];
    leftBarBtn.frame = CGRectMake(0, 20 + (40 - leftImage.size.height) / 2, leftImage.size.width, leftImage.size.height);
    leftBarBtn.tag = 101;
    [leftBarBtn setImage:[UIImage imageNamed:@"back"] forState:UIControlStateNormal];
    [leftBarBtn setImage:[UIImage imageNamed:@"back"] forState:UIControlStateHighlighted];
    [leftBarBtn addTarget:self action:@selector(buttonActionToDoSomething:) forControlEvents:UIControlEventTouchUpInside];
//    [navCoverView addSubview:leftBarBtn];
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
        littleBtnSize = 11;


    //创建UIScrollView
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
    
    //刷新头像
    headImage = [Tool headAvatarDataGetWithSQLUid:[CommParameter sharedInstance].userId];
    headImage = [UIImage imageNamed:@"banaba_cot"];
    
    headImageView = [[UIImageView alloc] init];
    headImageView.image = headImage;
    headImageView.layer.cornerRadius = [UIImage imageNamed:@"banaba_cot"].size.width / 2;
    headImageView.layer.masksToBounds = YES;
    headImageView.contentMode = UIViewContentModeScaleAspectFit;
    headImageView.layer.borderColor = RGBA(51, 165, 218, 1.0f).CGColor;
    headImageView.layer.borderWidth = 1.0f;
    [scrollView addSubview:headImageView];

    //input
    inputView = [[UIView alloc] init];
    inputView.backgroundColor = [UIColor clearColor];
    [scrollView addSubview:inputView];
    
    UIView *topLineView = [[UIView alloc] init];
    topLineView.backgroundColor = lineViewColor;
    topLineView.hidden = YES;
    [inputView addSubview:topLineView];
    
 
    
    //手机号
    phoneNumView = [[UIView alloc] init];
    phoneNumView.backgroundColor = viewColor;
    [inputView addSubview:phoneNumView];
    
    //账号Lab
    UILabel *accuntLab = [[UILabel alloc] init];
    accuntLab.text = @"账号";
    accuntLab.textColor = titleColor;
    accuntLab.font = [UIFont systemFontOfSize:textFieldTextSize];
    [phoneNumView addSubview:accuntLab];
    
    phoneNumTextField = [[UITextField alloc] init];
    phoneNumTextField.tag = textFieldTag;
    phoneNumTextField.placeholder = @"请输入手机号";
    phoneNumTextField.text = phoneNum;
    [phoneNumTextField setMinLenght:@"0"];
    [phoneNumTextField setMaxLenght:@"11"];
    phoneNumTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    phoneNumTextField.tintColor = RGBA(199, 199, 199, 1.0);
    phoneNumTextField.textColor = RGBA(83, 83, 83, 1.0);
    phoneNumTextField.font = [UIFont systemFontOfSize:textFieldTextSize];
    [phoneNumView addSubview:phoneNumTextField];
    
    UIImage *phoneNumBtnImage = [UIImage imageNamed:@"list_combo_default.png"];
    phoneNumBtn = [[UIButton alloc] init];
    phoneNumBtn.tag = 1;
    [phoneNumBtn setImage:phoneNumBtnImage forState:UIControlStateNormal];
    phoneNumBtn.selected = NO;
    [phoneNumBtn addTarget:self action:@selector(buttonActionToDoSomething:) forControlEvents:UIControlEventTouchDown];
    phoneNumBtn.contentMode = UIViewContentModeScaleAspectFit;
    [phoneNumView addSubview:phoneNumBtn];
    
    UIView *lineView = [[UIView alloc] init];
    lineView.backgroundColor = lineViewColor;
    [inputView addSubview:lineView];
    
    //鉴权区
    UIView *authToolsView = [[UIView alloc] init];
    authToolsView.backgroundColor = viewColor;
    [inputView addSubview:authToolsView];
    
    CGFloat authToolsViewH = [self addAuthToolsView:authToolsView];
    
    UIView *bootomLineView = [[UIView alloc] init];
    bootomLineView.backgroundColor = lineViewColor;
    [inputView addSubview:bootomLineView];
    
    
    //登录按钮
    loginBtn = [[UIButton alloc] init];
    [loginBtn setTag:2];
    [loginBtn setTitle:@"登录" forState: UIControlStateNormal];
    [loginBtn setTitleColor:RGBA(255, 255, 255, 1.0) forState:UIControlStateNormal];
    loginBtn.titleLabel.font = [UIFont systemFontOfSize:btnTextSize];
    [loginBtn.layer setMasksToBounds:YES];
    loginBtn.layer.cornerRadius = 5.0;
    [loginBtn addTarget:self action:@selector(buttonActionToDoSomething:) forControlEvents:UIControlEventTouchUpInside];
    [inputView addSubview:loginBtn];
    
    
    //bottomBtn
    UIView *bottomBtnView = [[UIView alloc] init];
    bottomBtnView.backgroundColor = [UIColor clearColor];
    [inputView addSubview:bottomBtnView];
    
    //找回密码
    UIButton *findBtn = [[UIButton alloc] init];
    [findBtn setTag:3];
    [findBtn setTitle:@"找回密码" forState: UIControlStateNormal];
    [findBtn setTitleColor:RGBA(65, 131, 215, 1.0) forState:UIControlStateNormal];
    findBtn.titleLabel.font = [UIFont systemFontOfSize:littleBtnSize];
    [findBtn.layer setMasksToBounds:YES];
    findBtn.layer.cornerRadius = 5.0;
    [findBtn addTarget:self action:@selector(buttonActionToDoSomething:) forControlEvents:UIControlEventTouchUpInside];
    [bottomBtnView addSubview:findBtn];
    
    //快速注册
    UIButton *registerBtn = [[UIButton alloc] init];
    [registerBtn setTag:4];
    [registerBtn setTitle:@"快速注册" forState: UIControlStateNormal];
    [registerBtn setTitleColor:RGBA(65, 131, 215, 1.0) forState:UIControlStateNormal];
    registerBtn.titleLabel.font = [UIFont systemFontOfSize:littleBtnSize];
    [registerBtn.layer setMasksToBounds:YES];
    registerBtn.layer.cornerRadius = 5.0;
    [registerBtn addTarget:self action:@selector(buttonActionToDoSomething:) forControlEvents:UIControlEventTouchUpInside];
    [bottomBtnView addSubview:registerBtn];
    
    
    
    
    //微信微博登陆
    UIView *otherLoginView = [[UIView alloc] init];
    otherLoginView.backgroundColor = [UIColor whiteColor];
    [inputView addSubview:otherLoginView];
    
    UIImage *weboImage = [UIImage imageNamed:@"icon_share_weibo"];
    UIButton *weboImageBtn = [[UIButton alloc] init];
    [weboImageBtn setTag:5];
    [weboImageBtn setBackgroundImage:weboImage forState:UIControlStateNormal];
    [weboImageBtn.layer setMasksToBounds:YES];
    weboImageBtn.layer.cornerRadius = otherLoginView.frame.size.height/2;
    [weboImageBtn addTarget:self action:@selector(buttonActionToDoSomething:) forControlEvents:UIControlEventTouchUpInside];
    [otherLoginView addSubview:weboImageBtn];
    
    UIImage *weixinImage = [UIImage imageNamed:@"icon_share_weixin"];
    UIButton *weixinImageBtn = [[UIButton alloc] init];
    [weixinImageBtn setTag:6];
    [weixinImageBtn setBackgroundImage:weixinImage forState:UIControlStateNormal];
    [weixinImageBtn.layer setMasksToBounds:YES];
    weixinImageBtn.layer.cornerRadius = otherLoginView.frame.size.height/2;
    [weixinImageBtn addTarget:self action:@selector(buttonActionToDoSomething:) forControlEvents:UIControlEventTouchUpInside];
    [otherLoginView addSubview:weixinImageBtn];
    
    
    
    
    
    //设置控件的位置和大小
    CGFloat headImageViewTop = 20;
    CGFloat headImageViewBottom = 60;
    CGFloat btnAddWith = 10; //按钮扩充点击范围
    CGFloat space = 10.0;
    CGFloat lineViewHeight = 1;
    CGFloat commWidth = viewSize.width - 2 * leftRightSpace;
    CGFloat scrollViewH = viewSize.height - controllerTop;
    CGSize accountSize = [accuntLab.text sizeWithNSStringFont:accuntLab.font];
    CGFloat phoneNumTextFieldW = commWidth - phoneNumBtnImage.size.width - space - accountSize.width - btnAddWith;
    CGSize  phoneNumTextFieldSize = [phoneNumTextField sizeThatFits:CGSizeMake(phoneNumTextFieldW, MAXFLOAT)];
    CGFloat phoneNumViewH = accountSize.height + 2 * leftRightSpace;
    popPhoneNumY =  controllerTop + headImageViewTop * 2 + 105;
    CGFloat inputViewH = scrollViewH;
    CGSize phoneNumBtnSize = CGSizeMake(phoneNumBtnImage.size.width + btnAddWith, phoneNumBtnImage.size.height + btnAddWith);
    CGSize loginBtnSize = [loginBtn.titleLabel sizeThatFits:CGSizeMake(commWidth, MAXFLOAT)];
    CGFloat loginBtnHeight = loginBtnSize.height + 2 * leftRightSpace;
    CGSize findBtnSize = [findBtn.titleLabel.text sizeWithNSStringFont:findBtn.titleLabel.font];
    CGFloat accuntTop = (phoneNumViewH - accountSize.height)/2;
    CGFloat bottomBtnViewH = findBtnSize.height;

    CGFloat otherLoginViewH = weboImage.size.height + 2*space;
    CGFloat weboImageBtnOx = (commWidth - weixinImage.size.width - weixinImage.size.width - leftRightSpace)/2;
    
    
   
    btnW = commWidth;
    btnH = loginBtnHeight;
    
    viewHeight = phoneNumViewH;
    moveTop = headImageViewTop + headImage.size.height + headImageViewBottom;
    
    [self textFiledEditChanged];
    
    
    [scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(view).offset(controllerTop);
        make.centerX.equalTo(self.view);
        make.size.mas_equalTo(CGSizeMake(viewSize.width, scrollViewH));
    }];
    
    [headImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(scrollView).offset(headImageViewTop);
        make.centerX.equalTo(scrollView);
        make.size.mas_equalTo([UIImage imageNamed:@"banaba_cot"].size);
    }];

    [inputView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(headImageView.mas_bottom).offset(headImageViewBottom);
        make.centerX.equalTo(scrollView);
        make.size.mas_equalTo(CGSizeMake(viewSize.width, inputViewH));
    }];
    
    [topLineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(inputView).offset(0);
        make.centerX.equalTo(inputView);
        make.size.mas_equalTo(CGSizeMake(viewSize.width, lineViewHeight));
    }];
    
    [accuntLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(topLineView.mas_bottom).offset(accuntTop);
        make.left.equalTo(inputView).offset(leftRightSpace);
        make.size.mas_equalTo(accountSize);
    }];
    
    [phoneNumView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(topLineView.mas_bottom).offset(0);
        make.left.equalTo(inputView).offset(leftRightSpace);
        make.size.mas_equalTo(CGSizeMake(commWidth, phoneNumViewH));
    }];

    [phoneNumTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(accuntLab.mas_right).offset(space);
        make.centerY.equalTo(phoneNumView);
        make.size.mas_equalTo(CGSizeMake(phoneNumTextFieldW, phoneNumTextFieldSize.height + 2*leftRightSpace));
    }];

    [phoneNumBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(phoneNumTextField.mas_right).offset(0);
        make.centerY.equalTo(phoneNumView);
        make.size.mas_equalTo(phoneNumBtnSize);
    }];
    
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(phoneNumView.mas_bottom).offset(0);
        make.left.equalTo(inputView).offset(leftRightSpace);
        make.size.mas_equalTo(CGSizeMake(viewSize.width - leftRightSpace, lineViewHeight));
    }];
    
    [authToolsView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(lineView.mas_bottom).offset(0);
        make.centerX.equalTo(inputView);
        make.size.mas_equalTo(CGSizeMake(viewSize.width, authToolsViewH));
    }];
    
    [bootomLineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(authToolsView.mas_bottom).offset(0);
        make.left.equalTo(inputView).offset(leftRightSpace);
        make.size.mas_equalTo(CGSizeMake(viewSize.width-leftRightSpace, lineViewHeight));
    }];
    
    [loginBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(bootomLineView.mas_bottom).offset(60.55);
        make.centerX.equalTo(inputView);
        make.size.mas_equalTo(CGSizeMake(btnW, btnH));
    }];
    
    [bottomBtnView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(loginBtn.mas_bottom).offset(leftRightSpace);
        make.centerX.equalTo(inputView);
        make.size.mas_equalTo(CGSizeMake(commWidth, bottomBtnViewH));
    }];

    [findBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(bottomBtnView).offset(0);
        make.centerY.equalTo(bottomBtnView);
    }];
    
    [registerBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(bottomBtnView.mas_right).offset(0);
        make.centerY.equalTo(bottomBtnView);
    }];
    
    [otherLoginView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(bottomBtnView.mas_bottom).offset(leftRightSpace);
        make.centerX.equalTo(scrollView.mas_centerX).offset(0);
        make.size.mas_equalTo(CGSizeMake(commWidth, otherLoginViewH));
    }];
    
    [weboImageBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(otherLoginView.mas_centerY).offset(0);
        make.left.equalTo(otherLoginView.mas_left).offset(weboImageBtnOx);
    }];
    [weixinImageBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(otherLoginView.mas_centerY).offset(0);
        make.left.equalTo(weboImageBtn.mas_right).offset(leftRightSpace);
    }];

    
    [self setInputResponderChain];
    [self listenNotifier];
}

/**
 *@brief 用户下拉列表数据源
 *@return
 */
- (void)dropDownListData
{

    
    //1.获取数据库数据
    userArray = [NSMutableArray array];
    NSArray *tempArray = [SDSqlite selectData:[SqliteHelper shareSqliteHelper].sandBaoDB tableName:@"usersconfig" columnArray:USERSCONFIG_ARR];
    
    
    if (tempArray.count>10) {
        //2. 根据要求 仅显示10条数据
        tempArray = [tempArray subarrayWithRange:NSMakeRange(0, 10)];
    }
    
    //3. 把获取的数据倒叙排列,UI上显示最新登陆过的账户
    tempArray = [[tempArray reverseObjectEnumerator] allObjects];
    
    //4. 配置数据数组
    NSInteger tempArrayCount = [tempArray count];
    for (int i = 0;  i <tempArrayCount ; i++) {
        NSDictionary *dic = tempArray[i];
        NSString *active = [dic objectForKey:@"active"];
        //过滤带*字段号码(数据库中存在,但UI上不显示)
        if ([[dic objectForKey:@"userName"] rangeOfString:@"****"].location == NSNotFound) {
            if ([@"0" isEqualToString:active]) {
                phoneNumTextField.text = [dic objectForKey:@"userName"];
            }            
            [userArray addObject:[dic objectForKey:@"userName"]];
        }
        
    
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
    if(btn.tag == 2) {
        [[self class] cancelPreviousPerformRequestsWithTarget:self selector:@selector(buttonActionToDoSomething:) object:sender];
        [self performSelector:@selector(buttonActionToDoSomething:) withObject:sender afterDelay:1];
    } else if(btn.tag == 3) {
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
- (void)buttonActionToDoSomething:(UIButton*)sender
{
    UIButton *btn = (UIButton *)sender;
    switch (btn.tag) {
        case 1:
        {
            [self dismissKeyboard];
            loginPwdTextField.text = @"";
            [self changeBtnShowState:2];
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
            
        }
            break;
        case 202:
        {
            [self changeBtnShowState:1];
        }
            break;
        case 3:
        {
            CheckUserViewController *mCheckUserViewController = [[CheckUserViewController alloc] init];
            [self.navigationController pushViewController:mCheckUserViewController animated:YES];
        }
            break;
        case 4:
        {
            RegisterViewController *mRegisterViewController = [[RegisterViewController alloc] init];
            mRegisterViewController.tokenType = @"01000101";
            mRegisterViewController.isOtherAPPSPS = _isOtherAPPSPS;
            mRegisterViewController.otherAPPSPSurl = _otherAPPSPSurl;
            [self.navigationController pushViewController:mRegisterViewController animated:YES];
        }
            break;
        case 5:
        {
            //1.检测是否安装微博App
            //微博登陆
            [self ssoButtonPressed];
       
        }
            break;
        case 6:
        {
            //1.检测是否安装微博App
            //微信登陆
            [Tool showDialog:@"努力开发中..."];
            
            
        }
            break;
        case 101:
        {
            [self.navigationController popViewControllerAnimated:YES];
        }
            break;
            
        default:
            break;
    }
}


#pragma mark - 请求微博认证 SSO授权
- (void)ssoButtonPressed
{
    appDelegate.delegate = self;
    WBAuthorizeRequest *request = [WBAuthorizeRequest request];
    request.redirectURI = WB_App_Oauth2url;
    request.scope = @"all";
    request.userInfo = @{@"ssoFrom":@"LoginViewController"};
    [WeiboSDK sendRequest:request];
}


#pragma mark - SDWeiBodelegate 微博登陆的回调
-(void)weiboLoginByResponse:(WBBaseResponse *)response{
    [SDLog logTest:[NSString stringWithFormat:@"%@",response.userInfo]];
    
    NSString *access_token = [response.userInfo objectForKey:@"access_token"];
    NSString *uid = [response.userInfo objectForKey:@"uid"];
    
    //从微薄请求用户信息 https://api.weibo.com/2/users/show.json?access_token=2.00A8keACtQ76gB8797432bd70b45et&uid=1841977282
    NSString *urlStr = [NSString stringWithFormat:@"https://api.weibo.com/2/users/show.json?access_token=%@&uid=%@",access_token,uid];
    NSURL *url= [NSURL URLWithString:urlStr];
    NSURLRequest *req = [NSURLRequest requestWithURL:url];
    
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:req completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
       
        if (error == nil) {
            //解析数据
            NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
            NSString *nick = [dict objectForKey:@"name"];
            NSString *avatar = [dict objectForKey:@"profile_image_url"];
            NSString *avaratBase = [Base64Util base64StringFromText:avatar];
            dispatch_async(dispatch_get_main_queue(), ^{
            //    第三方平台明登陆->微博
                if (uid.length == 0) {
                    [Tool showDialog:@"您未授权,微博登陆须您授权"];
                }else{
                    [self webologin:uid name:nick avatar:avaratBase];
                }
            });
        }
        
    }];
    [dataTask resume];
}

#pragma mark - 第三方平台登陆
-(void)webologin:(NSString*)uid name:(NSString*)nick avatar:(NSString*)avatar{
    HUD = [SDMBProgressView showSDMBProgressOnlyLoadingINViewImg:self.view];
    [SDRequestHelp shareSDRequest].HUD = HUD;
    [SDRequestHelp shareSDRequest].controller = self;
    [[SDRequestHelp shareSDRequest] dispatchGlobalQuque:^{
        __block BOOL error = NO;
        
        paynuc.set("tTokenType", "01002201");
        [[SDRequestHelp shareSDRequest] requestWihtFuncName:@"token/getTtoken/v1" errorBlock:^(SDRequestErrorType type) {
            error = YES;
        } successBlock:^{
            
        }];
        if (error) return;
        
        //login
        NSMutableDictionary *userInfoDickies= [NSMutableDictionary dictionaryWithCapacity:0];
        NSMutableDictionary *authCodeDic = [NSMutableDictionary dictionaryWithCapacity:0];
        [authCodeDic setValue:WEIBO forKey:@"firm"];
        [authCodeDic setValue:uid forKey:@"userUnionid"];
        [userInfoDickies setValue:authCodeDic forKey:@"authCode"];
        
        NSString *userinfo = [[PayNucHelper sharedInstance] dictionaryToJson:userInfoDickies];
        
        paynuc.set("authTools","[]");
        paynuc.set("userInfo", [userinfo UTF8String]);
        [[SDRequestHelp shareSDRequest] requestWihtFuncName:@"user/login/v1" errorBlock:^(SDRequestErrorType type) {
            error = YES;
            if (type == respCodeErrorType) {
                NSString *respCode = [NSString stringWithUTF8String:paynuc.get("respCode").c_str()];
                if ([@"030012" isEqualToString:respCode]) {
                    [[SDRequestHelp shareSDRequest] dispatchToMainQueue:^{
                        RegisterViewController *mRegisterViewController = [[RegisterViewController alloc] init];
                        mRegisterViewController.tokenType = @"01002101";
                        mRegisterViewController.thirdRegistFlag = YES;
                        mRegisterViewController.nick = nick;
                        mRegisterViewController.avatar = avatar;
                        mRegisterViewController.userUnionid = uid;
                        mRegisterViewController.firm = WEIBO;
                        [self.navigationController pushViewController:mRegisterViewController animated:YES];
                    }];
                }
            }
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
        //1.激活用户状态
          result = [SDSqlite updateData:[SqliteHelper shareSqliteHelper].sandBaoDB sql:[NSString stringWithFormat:@"update usersconfig set active = '%@', sToken = '%@', userName = '%@' ,credit_fp = '%@'  where uid = '%@'", @"0", [CommParameter sharedInstance].sToken, [CommParameter sharedInstance].userName, creditFp, [CommParameter sharedInstance].userId]];
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
        
        result = [SDSqlite insertData:[SqliteHelper shareSqliteHelper].sandBaoDB sql:[NSString stringWithFormat:@"insert into usersconfig (uid, userName, active, sToken, credit_fp, lets) values ('%@', '%@', '%@', '%@', '%@', '%@')", [CommParameter sharedInstance].userId, [CommParameter sharedInstance].userName, @"0", [CommParameter sharedInstance].sToken, creditFp, letsJson]];
    }
    
    if (result == YES) {
        [self ownPayTools];
    } else {
        //数据写入失败->返回直接登陆
        [Tool showDialog:@"用户数据存储失败,请重新登陆" defulBlock:^{
            phoneNumTextField.text = @"";
            payPwdTextField.text = @"";
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
        if (error) return;
        
        
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
                
                MainViewController *mMainViewController = [[MainViewController alloc] init];
                [self presentViewController:mMainViewController animated:YES completion:nil];

            }];
        }];
        if (error) return;
    }];
}

#pragma mark - 改变按钮显示的状态
/**
 *@brief  改变按钮显示的状态
 *@param index int 参数：索引
 */
- (void)changeBtnShowState:(int)index
{
    
    if (index == 1) {
        if (showPwdFlag == NO) {
            [loginPwdBtn setImage:[UIImage imageNamed:@"list_eyes_on"] forState:UIControlStateNormal];
            showPwdFlag = YES;
            loginPwdTextField.secureTextEntry = NO;
        } else {
            [loginPwdBtn setImage:[UIImage imageNamed:@"list_eyes_off"] forState:UIControlStateNormal];
            showPwdFlag = NO;
            loginPwdTextField.secureTextEntry = YES;
        }
    } else {
        if (dropDownFlag == NO) {
            [phoneNumBtn setImage:[UIImage imageNamed:@"list_combo_highlight.png"] forState:UIControlStateNormal];
            dropDownFlag = YES;
            
            dropDownListView = [[DropDownListView alloc] initWithShowDropDown:phoneNumView :userArray];
            
            dropDownListView.delegate = self;
            
            [inputView addSubview:dropDownListView];
        } else {
            [phoneNumBtn setImage:[UIImage imageNamed:@"list_combo_default.png"] forState:UIControlStateNormal];
            dropDownFlag = NO;
            [dropDownListView hideDropDown];
        }
    }
}

#pragma mark - 把所有的输入框放到数组中
/**
 *@brief 把所有的输入框放到数组中
 *@return NSArray
 */
- (NSArray *)allInputFields {
    return @[phoneNumTextField, loginPwdTextField];
}

#pragma mark - UITextFieldDelegate



-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    //监控账号输入框,实现点击则变为默认头像
    if ([textField.placeholder rangeOfString:@"手机号"].location != NSNotFound) {
        if (textField.text.length > 0) {
              headImage = [UIImage imageNamed:@"banaba_cot"];
              headImageView.image = headImage;
        }
    }
    
    
    CGFloat allHeight = viewHeight * (textField.tag + 1) + moveTop;
    
    CGFloat offset = allHeight -(self.view.frame.size.height-252.0 - 64);//键盘高度216
    

    if (offset > 0) {
        [scrollView setContentOffset:CGPointMake(0.0f, offset) animated:YES] ;
    }
}

-(void)textFieldDidEndEditing:(UITextField *)textField{
    if ([textField.placeholder rangeOfString:@"手机号"].location != NSNotFound) {
        //头像修改
        NSString *userId = [SDSqlite selectStringData:[SqliteHelper shareSqliteHelper].sandBaoDB sql:[NSString stringWithFormat:@"select uid from usersconfig where userName = '%@'",textField.text]];
        headImage = [Tool headAvatarDataGetWithSQLUid:userId];
        headImageView.image = headImage;
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
    if (textField.returnKeyType == UIReturnKeyNext) {
        if (dropDownFlag == YES) {
            [self changeBtnShowState:2];
        }
        
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
    loginPwdTextField.returnKeyType = UIReturnKeyDone;
}

/**
 *@brief 隐藏键盘
 */
- (void)dismissKeyboard {
    //将视图的Y坐标向上移动offset个单位，以使下面腾出地方用于软键盘的显示
    [scrollView setContentOffset:CGPointMake(0.0f, 0.0f) animated:YES] ;
    [self.view endEditing:YES];
}

#pragma mark - DropDownListViewDelegate

- (void)selectRowContent:(NSString *)param
{   //账号(目前默认等于userId)
    phoneNumTextField.text = param;
    [self textFiledEditChanged];
    
    //头像修改
    NSString *userId = [SDSqlite selectStringData:[SqliteHelper shareSqliteHelper].sandBaoDB sql:[NSString stringWithFormat:@"select uid from usersconfig where userName = '%@'",param]];
    headImage = [Tool headAvatarDataGetWithSQLUid:userId];
    headImageView.image = headImage;
}

- (void)deleteRowContent:(NSInteger)param
{
    [SDLog logTest:[NSString stringWithFormat:@"你选择删除的索引：%li", (long)param]];
    NSString *userNameStr = userArray[param];
    BOOL result = [SDSqlite deleteData:[SqliteHelper shareSqliteHelper].sandBaoDB sql:[NSString stringWithFormat:@"delete from usersconfig where userName = '%@'", userNameStr]];
    if (result>0) {
        [userArray removeObjectAtIndex:param];
        [dropDownListView deleteRow:param];
    }else{
        [Tool showDialog:@"删除失败"];
    }
    
    
}


#pragma mark - 业务逻辑

/**
 *@brief 获取鉴权工具
 *@return NSArray
 */
- (void)load
{
    HUD = [SDMBProgressView showSDMBProgressOnlyLoadingINViewImg:self.view];
    [SDRequestHelp shareSDRequest].HUD = HUD;
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
                [HUD hidden];
                NSString *tempAuthTools = [NSString stringWithUTF8String:paynuc.get("authTools").c_str()];
                NSArray *tempAuthToolsArray = [[PayNucHelper sharedInstance] jsonStringToArray:tempAuthTools];
                
                //清空
                if (authToolsArray.count>0) {
                    [authToolsArray removeAllObjects];
                }
                for (int i = 0; i < tempAuthToolsArray.count; i++) {
                    [authToolsArray addObject:tempAuthToolsArray[i]];
                }
                
                if ([authToolsArray count] <= 0) {
                    [Tool showDialog:@"获取失败"];
                } else {
                    [self addView:self.view];
                }
            }];
        }];
        if (error) return;
        
    }];
}

/**
 *@brief 添加鉴权工具view
 *@param view UIView 参数：组件
 *@return CGFloat
 */
- (CGFloat)addAuthToolsView:(UIView *)view
{
    textFieldTag = 0;
    CGFloat lineViewHeight = 1;
    CGFloat tempHeight = 0;
    CGFloat allHeight = 0;
    CGFloat groupViewHight = 0;
    
    NSInteger authToolsArrayCount = [authToolsArray count];
    for (int i = 0; i < authToolsArrayCount; i++) {
        NSMutableDictionary *dic = authToolsArray[i];
        NSString *type = [dic objectForKey:@"type"];
        
        GroupView *groupView = [[GroupView alloc] initWithFrame:self.view.frame];
        groupView.groupViewStyle = GroupViewStyleYes;
        tempHeight = tempHeight + groupViewHight;
        textFieldTag = textFieldTag + 1;
        
        if ([@"sms" isEqualToString:type]) {
            
            groupViewHight = [groupView shortMsgVerification];
            allHeight = allHeight + groupViewHight;
            shortMsgBtn = groupView.shortMsgVerificationBtn;
            shortMsgTextField = groupView.shortMsgVerificationTextField;
            
            shortMsgBtn.tag = 201;
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
            loginPwdTextField.text = loginPwd;
            
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
            return [self changeBtnBackGround:nil index:2];
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
    
    [self changeBtnBackGround:@"yes" index:2];
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
 *@brief 输入数据验证
 */
- (void)verificationInput
{
//    //密码正则校验
//    BOOL a =  [UITextField  regularPassWd:loginPwdTextField.text regular:@"^((13[0-9])|(15[^4,\\D])|(18[0,0-9]))\\d{8}$"];
//    if (a==NO) {
//        [Tool showDialog:@"密码过于简单,请重新输入" defulBlock:^{
//            loginPwdTextField.text = @"";
//        }];
//        return ;
//    }
    if (phoneNumTextField.text.length != [phoneNumTextField.maxLenght intValue] || ![NSRegularExpression validateMobile:phoneNumTextField.text] ) {
        return [Tool showDialog:@"输入的手机号码格式不正确，请重新输入。"];
    }
    
    if ([loginPwdTextField.text rangeOfString:@" "].location != NSNotFound) {
        return [Tool showDialog:@"不能包含空格，请重新输入。"];
    }
    
    if (loginPwdTextField.text.length < [loginPwdTextField.minLenght intValue] || loginPwdTextField.text.length > [loginPwdTextField.maxLenght intValue] ) {
        [self changeBtnBackGround:nil index:1];
        return [Tool showDialog:@"输入的密码格式不正确，请重新输入。"];
    }
    if (![NSRegularExpression validatePasswordNumAndLetter:loginPwdTextField.text]) {
        loginPwdTextField.text = nil;
        [self changeBtnBackGround:nil index:1];
        return [Tool showDialog:@"请输入字母数字组合的密码"];
        
    }
    phoneNum = phoneNumTextField.text;
    loginPwd = loginPwdTextField.text;
    
    [self loginUser];
}


#pragma mark - 用户登陆
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
        _authToolsArray1 = [[NSMutableArray alloc] init];
        
        NSMutableDictionary *authToolsDic1 = [[NSMutableDictionary alloc] init];
        [authToolsDic1 setValue:@"loginpass" forKey:@"type"];
        NSMutableDictionary *passDic = [[NSMutableDictionary alloc] init];
        [passDic setValue:@"sand" forKey:@"encryptType"];
        [passDic setValue:[NSString stringWithUTF8String:paynuc.lgnenc([loginPwdTextField.text UTF8String]).c_str()] forKey:@"password"];
        [authToolsDic1 setObject:passDic forKey:@"pass"];
        [_authToolsArray1 addObject:authToolsDic1];
        NSString *authTools = [[PayNucHelper sharedInstance] arrayToJSON:_authToolsArray1];
        [SDLog logTest:authTools];
        
        
        NSMutableDictionary *userInfoDic = [[NSMutableDictionary alloc] init];
        [userInfoDic setValue:phoneNumTextField.text forKey:@"userName"];
        
        NSString *userInfo = [[PayNucHelper sharedInstance] dictionaryToJson:userInfoDic];
        
        [SDLog logTest:userInfo];
        
        
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
                        NSMutableArray *addauthTools = [NSMutableArray arrayWithCapacity:0];
                        for (int i = 0; i < tempAuthToolsArray.count; i++) {
                            [addauthTools addObject:tempAuthToolsArray[i]];
                        }
                        //跳转去新页面验证
                        AddauthToolViewController *addauthToolVC = [[AddauthToolViewController alloc] init];
                        addauthToolVC.addauthToolsArray = addauthTools;
                        addauthToolVC.authToolsArray1 = _authToolsArray1;
                        addauthToolVC.userInfo = userInfo;
                        addauthToolVC.isStokenOver = _isStokenOver;
                        addauthToolVC.phoneNumberStr = phoneNumTextField.text;
                        addauthToolVC.isOtherAPPSPS = _isOtherAPPSPS;
                        addauthToolVC.otherAPPSPSurl = _otherAPPSPSurl;
                        [self.navigationController pushViewController:addauthToolVC animated:YES];
                       
                    }
                }];
            }
        } successBlock:^{
            [[SDRequestHelp shareSDRequest] dispatchToMainQueue:^{
                [HUD hidden];
                //do nothing
            }];
        }];
        if (error) return;
    }];
}

- (void)dealloc
{
    if (phoneNumTextField) {
        [[NSNotificationCenter defaultCenter] removeObserver:self name:UITextFieldTextDidChangeNotification object:phoneNumTextField];
    }
    
    if (shortMsgTextField) {
        [[NSNotificationCenter defaultCenter] removeObserver:self name:UITextFieldTextDidChangeNotification object:shortMsgTextField];
    }
    
    if (loginPwdTextField) {
        [[NSNotificationCenter defaultCenter] removeObserver:self name:UITextFieldTextDidChangeNotification object:loginPwdTextField];
    }
    
    if (IDCardTextField) {
        [[NSNotificationCenter defaultCenter] removeObserver:self name:UITextFieldTextDidChangeNotification object:IDCardTextField];
    }
    
    if (pictureNumTextField) {
        [[NSNotificationCenter defaultCenter] removeObserver:self name:UITextFieldTextDidChangeNotification object:pictureNumTextField];
    }
    
    if (questionTextField) {
        [[NSNotificationCenter defaultCenter] removeObserver:self name:UITextFieldTextDidChangeNotification object:questionTextField];
    }
    
    if (bankCardTextField) {
        [[NSNotificationCenter defaultCenter] removeObserver:self name:UITextFieldTextDidChangeNotification object:bankCardTextField];
    }
    
    if (payPwdTextField) {
        [[NSNotificationCenter defaultCenter] removeObserver:self name:UITextFieldTextDidChangeNotification object:payPwdTextField];
    }
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
}

#pragma mark - ==== 暂存备用代码 ==== 以下代码暂不启用 ====




@end
