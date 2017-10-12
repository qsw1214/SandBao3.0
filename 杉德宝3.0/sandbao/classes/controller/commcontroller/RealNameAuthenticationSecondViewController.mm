//
//  RealNameAuthenticationSecondViewController.m
//  sandbao
//
//  Created by tianNanYiHao on 2017/2/8.
//  Copyright © 2017年 sand. All rights reserved.
//

#import "RealNameAuthenticationSecondViewController.h"


#import "SDLog.h"
#import "PayNucHelper.h"
#import "GroupView.h"
#import "CommParameter.h"
#import "FAQwebViewController.h"
#import "RealNameAuthenticationrResultViewController.h"

#define navbarColor RGBA(255, 255, 255, 1.0)

#define navViewColor RGBA(249, 249, 249, 1.0)

#define lineViewColor RGBA(237, 237, 237, 1.0)

#define titleColor RGBA(174, 174, 174, 1.0)

#define textFiledColor RGBA(83, 83, 83, 1.0)

#define btnColor RGBA(255, 97, 51, 1.0)

#define viewColor RGBA(255, 255, 255, 1.0)

@interface RealNameAuthenticationSecondViewController ()<UITextFieldDelegate>
{
    NavCoverView *navCoverView;
    UIImageView *shortcutImageView;
}

@property (nonatomic, assign) CGSize viewSize;
@property (nonatomic, assign) CGFloat viewHeight;
@property (nonatomic, assign) CGFloat moveTop;
@property (nonatomic, assign) CGFloat leftRightSpace;
@property (nonatomic, assign) CGFloat lineViewHeight;
@property (nonatomic, assign) CGFloat textFieldTextSize;
@property (nonatomic, assign) CGFloat btnTextSize;
@property (nonatomic, assign) CGFloat btnW;
@property (nonatomic, assign) CGFloat btnH;
@property (nonatomic, assign) CGFloat shortMsgBtnW;
@property (nonatomic, assign) CGFloat shortMsgBtnH;
@property (nonatomic, assign) int timeOut;
@property (nonatomic, assign) int timeCount;


@property (nonatomic, strong) SDMBProgressView *HUD;


@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UITextField *bankNameTextField;
@property (nonatomic, strong) UITextField *nameTextField;
@property (nonatomic, strong) UITextField *IDNumTextField;
@property (nonatomic, strong) UITextField *expiryTextField;
@property (nonatomic, strong) UITextField *CVNTextField;
@property (nonatomic, strong) UIButton *authenticationBtn;
@property (nonatomic, strong) NSMutableArray *authToolsArray;
@property (nonatomic, strong) UITextField *phoneNumTextField;
@property (nonatomic, strong) NSTimer *timer;
@property (nonatomic, strong) NSDictionary *passPayToolDic;
@property (nonatomic, strong) NSDictionary *passUserInfoDic;
@property (nonatomic, strong) NSMutableArray *textFieldArray;



@property (nonatomic, assign) CGFloat textFieldTag;
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

@end

@implementation RealNameAuthenticationSecondViewController

@synthesize viewSize;
@synthesize viewHeight;
@synthesize moveTop;
@synthesize leftRightSpace;
@synthesize lineViewHeight;
@synthesize textFieldTextSize;
@synthesize btnTextSize;
@synthesize btnW;
@synthesize btnH;
@synthesize shortMsgBtnW;
@synthesize shortMsgBtnH;
@synthesize timeOut;
@synthesize timeCount;


@synthesize HUD;


@synthesize scrollView;
@synthesize bankNameTextField;
@synthesize nameTextField;
@synthesize IDNumTextField;
@synthesize expiryTextField;
@synthesize CVNTextField;
@synthesize authenticationBtn;
@synthesize authToolsArray;
@synthesize phoneNumTextField;
@synthesize timer;
@synthesize passPayToolDic;
@synthesize passUserInfoDic;
@synthesize textFieldArray;

@synthesize textFieldTag;
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

@synthesize passDic;

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view setBackgroundColor:RGBA(242, 242, 242, 1.0)];
    viewSize = self.view.bounds.size;
    leftRightSpace = 15;
    lineViewHeight = 1;
    timeOut = 90;
    
    
    authToolsArray = [[NSMutableArray alloc] init];
    textFieldArray = [[NSMutableArray alloc] init];
    
    passPayToolDic = [passDic objectForKey:@"payTool"];
    passUserInfoDic = [passDic objectForKey:@"userInfo"];
    
    
    

    
    
    [self settingNavigationBar];
    
    
    NSArray *authToolArray = [passPayToolDic objectForKey:@"authTools"];
    
    for (int i = 0; i < authToolArray.count; i++) {
        [authToolsArray addObject:authToolArray[i]];
    }
    
    [self load];
    //[self addView:self.view];
    
    //[self listenNotifier];
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
    navCoverView = [NavCoverView shareNavCoverView:CGRectMake(0, 0, viewSize.width, controllerTop) title:@"实名认证"];
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
    CGFloat titleSize = 0;
    
        titleSize = 14;
        textFieldTextSize = 16;
        btnTextSize = 14;

    
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
    [scrollView setBackgroundColor:RGBA(242, 242, 242, 1.0)];
    [view addSubview:scrollView];
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    
    UIView *bankTitleView = [[UIView alloc] init];
    bankTitleView.backgroundColor = RGBA(242, 242, 242, 1.0);
    [scrollView addSubview:bankTitleView];
    
    UILabel *bankTitleLabel = [[UILabel alloc] init];
    bankTitleLabel.text = @"信息加密处理，仅用于银行验证";
    bankTitleLabel.textColor = RGBA(255, 102, 57, 1.0);
    bankTitleLabel.font = [UIFont systemFontOfSize:titleSize];
    [bankTitleView addSubview:bankTitleLabel];

    
    UIView *inputView = [[UIView alloc] init];
    inputView.backgroundColor = viewColor;
    [scrollView addSubview:inputView];
    
    UIView *bankView = [[UIView alloc] init];
    bankView.backgroundColor = viewColor;
    [inputView addSubview:bankView];
    
    UILabel *bankLabel = [[UILabel alloc] init];
    bankLabel.text = @"卡类型";
    bankLabel.textColor = titleColor;
    bankLabel.font = [UIFont systemFontOfSize:titleSize];
    [bankView addSubview:bankLabel];
    
    UILabel *bankContentLabel = [[UILabel alloc] init];
    bankContentLabel.text = [passPayToolDic objectForKey:@"title"];
    bankContentLabel.textColor = textFiledColor;
    bankContentLabel.font = [UIFont systemFontOfSize:titleSize];
    [bankView addSubview:bankContentLabel];
    
    
    
    
    //银行区
    UIView *bankAreaView = [[UIView alloc] init];
    bankAreaView.backgroundColor = RGBA(242, 242, 242, 1.0);
    [scrollView addSubview:bankAreaView];
    
    
    UIView *bankInfoView = [[UIView alloc] init];
    bankInfoView.backgroundColor = viewColor;
    [bankAreaView addSubview:bankInfoView];
    
    UIView *nameView = [[UIView alloc] init];
    nameView.backgroundColor = viewColor;
    [bankInfoView addSubview:nameView];
    
    UILabel *nameLabel = [[UILabel alloc] init];
    nameLabel.text = @"姓名";
    nameLabel.textColor = titleColor;
    nameLabel.font = [UIFont systemFontOfSize:titleSize];
    [nameView addSubview:nameLabel];
    
    nameTextField = [[UITextField alloc] init];
    nameTextField.tag = 1;
    nameTextField.placeholder = @"持卡人姓名";
    nameTextField.text = SHOWTOTEST(@"刘斐斐");
    nameTextField.textColor = textFiledColor;
    [nameTextField setMinLenght:@"2"];
    [nameTextField setMaxLenght:@"6"];
    nameTextField.font = [UIFont systemFontOfSize:titleSize];
    [nameView addSubview:nameTextField];
    
    [textFieldArray addObject:nameTextField];
    
    UIView *nameLineView = [[UIView alloc] init];
    nameLineView.backgroundColor = lineViewColor;
    [bankInfoView addSubview:nameLineView];
    
    UIView *IDNumView = [[UIView alloc] init];
    IDNumView.backgroundColor = viewColor;
    [bankInfoView addSubview:IDNumView];
    
    UILabel *IDNumLabel = [[UILabel alloc] init];
    IDNumLabel.text = @"证件号";
    IDNumLabel.textColor = titleColor;
    IDNumLabel.font = [UIFont systemFontOfSize:titleSize];
    [IDNumView addSubview:IDNumLabel];
    
    IDNumTextField = [[UITextField alloc] init];
    IDNumTextField.tag = 2;
    IDNumTextField.placeholder = @"请输入与卡片信息一致的证件号码";
    IDNumTextField.text = SHOWTOTEST(@"320981199001053212");
    IDNumTextField.textColor = textFiledColor;
    [IDNumTextField setMinLenght:@"15"];
    [IDNumTextField setMaxLenght:@"18"];
    IDNumTextField.font = [UIFont systemFontOfSize:titleSize];
    [IDNumView addSubview:IDNumTextField];
    
    [textFieldArray addObject:IDNumTextField];
    
    UIView *IDNumLineView = [[UIView alloc] init];
    IDNumLineView.backgroundColor = lineViewColor;
    [bankInfoView addSubview:IDNumLineView];
    
    //鉴权区
    UIView *authToolsView = [[UIView alloc] init];
    authToolsView.backgroundColor = viewColor;
    [scrollView addSubview:authToolsView];
    
    CGFloat authToolsViewH = [self addAuthToolsView:authToolsView];

    
    //协议
    UIView *agreementAreaView = [[UIView alloc] init];
    agreementAreaView.backgroundColor = RGBA(242, 242, 242, 1.0);
    [scrollView addSubview:agreementAreaView];
    
    UILabel *agreeLabel = [[UILabel alloc] init];
    agreeLabel.text = @"我已阅读并同意";
    agreeLabel.textColor = textFiledColor;
    agreeLabel.textAlignment = NSTextAlignmentCenter;
    agreeLabel.font = [UIFont systemFontOfSize:titleSize];
    [agreementAreaView addSubview:agreeLabel];
    
    UILabel *lookAgreeOnLabel = [[UILabel alloc] init];
    lookAgreeOnLabel.textColor = RGBA(65, 131, 215, 1.0);
    lookAgreeOnLabel.font = [UIFont systemFontOfSize:titleSize];
    lookAgreeOnLabel.userInteractionEnabled = YES;
    lookAgreeOnLabel.text = @"《服务协议》";
    lookAgreeOnLabel.textAlignment = NSTextAlignmentCenter;
    UITapGestureRecognizer *labelTapGestureRecognizer = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(labelTouchUpInside:)];
    [lookAgreeOnLabel addGestureRecognizer:labelTapGestureRecognizer];
    [agreementAreaView addSubview:lookAgreeOnLabel];
    
    
    //开通快捷
    UIView *shortcutBgView = [[UIView alloc] init];
    shortcutBgView.backgroundColor = RGBA(242, 242, 242, 1.0);
    [scrollView addSubview:shortcutBgView];
    
    UIImage *shortcutImage = [UIImage imageNamed:@"icon_quick_payment"];
    shortcutImageView = [[UIImageView alloc] init];
    shortcutImageView.image = shortcutImage;
    shortcutImageView.hidden = YES;
    shortcutImageView.contentMode = UIViewContentModeScaleAspectFit;
    [shortcutBgView addSubview:shortcutImageView];
    
    UILabel *shortcutLabel = [[UILabel alloc] init];
    shortcutLabel.text = @"该卡可开通快捷支付";
    shortcutLabel.textColor = [UIColor clearColor];
    shortcutLabel.font = [UIFont systemFontOfSize:titleSize];
    [shortcutBgView addSubview:shortcutLabel];
    //开通快捷成功
    if (_fastPayFlag) {
        shortcutImageView.hidden = NO;
        shortcutLabel.textColor = RGBA(36, 179, 63, 1.0);
    }
    


    // 立即认证按钮
    authenticationBtn = [[UIButton alloc] init];
    [authenticationBtn setTag:2];
    [authenticationBtn setTitle:@"立即认证" forState: UIControlStateNormal];
    [authenticationBtn setTitleColor:RGBA(255, 255, 255, 1.0) forState:UIControlStateNormal];
    authenticationBtn.titleLabel.font = [UIFont systemFontOfSize:btnTextSize];
    [authenticationBtn.layer setMasksToBounds:YES];
    authenticationBtn.layer.cornerRadius = 5.0;
    [authenticationBtn addTarget:self action:@selector(buttonActionToDoSomething:) forControlEvents:UIControlEventTouchUpInside];
    [scrollView addSubview:authenticationBtn];
    
    //设置控件的位置和大小
    CGFloat sapce = 10;
    CGFloat authenticationBtnTop = 30;
    CGFloat commWidth = viewSize.width - 2 * leftRightSpace;
    CGFloat commLineWidth = viewSize.width - leftRightSpace;
    

    
    
    CGSize bankLabelSize = [bankLabel.text sizeWithNSStringFont:bankLabel.font];
    CGFloat bankViewHeight = bankLabelSize.height + 2 * 10;
    CGFloat inputViewHeight = bankViewHeight;
    
    CGFloat bankContentLabelWidth = commWidth - bankLabelSize.width - leftRightSpace;
    CGSize bankContentLabelSize = [bankContentLabel sizeThatFits:CGSizeMake(bankContentLabelWidth, MAXFLOAT)];
    
    CGSize bankTitleLabelSize = [bankTitleLabel sizeThatFits:CGSizeMake(commWidth, MAXFLOAT)];
    CGFloat bankTitleViewHeight = bankTitleLabelSize.height + 2 * sapce;
    
    CGSize nameLabelSize = [nameLabel.text sizeWithNSStringFont:nameLabel.font];
    CGFloat nameTextFieldWidth = commWidth - nameLabelSize.width - sapce;
    CGSize nameTextFieldSize = [nameTextField sizeThatFits:CGSizeMake(nameTextFieldWidth, MAXFLOAT)];
    CGFloat commViewHeight = nameTextFieldSize.height + 2 * leftRightSpace;
    
    CGSize IDNumLabelSize = [IDNumLabel.text sizeWithNSStringFont:IDNumLabel.font];
    CGFloat IDNumTextFieldWidth = commWidth - IDNumLabelSize.width - sapce;
    CGSize IDNumTextFieldSize = [IDNumTextField sizeThatFits:CGSizeMake(IDNumTextFieldWidth, MAXFLOAT)];

    CGFloat bankInfoViewHeight = commViewHeight * 2 + lineViewHeight;
    
    CGFloat bankAreaViewHeight = bankInfoViewHeight;
    
    CGSize agreeLabelSize = [agreeLabel.text sizeWithNSStringFont:[UIFont systemFontOfSize:titleSize]];
    CGFloat agreementAreaViewHeight = agreeLabelSize.height*2 + 2*leftRightSpace;
    
    CGSize authenticationBtnSize = [authenticationBtn.titleLabel sizeThatFits:CGSizeMake(commWidth, MAXFLOAT)];
    CGFloat authenticationBtnHeight = authenticationBtnSize.height + 2 * leftRightSpace;
    btnW = commWidth;
    btnH = authenticationBtnHeight;
    
    moveTop = controllerTop + inputViewHeight + bankTitleViewHeight;
    viewHeight = commViewHeight;
    
    [self textFiledEditChanged];
    
    [self listenNotifier];
    
  

    
    [scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(navCoverView.mas_bottom).offset(0);
        make.centerX.equalTo(view);
        make.size.mas_equalTo(CGSizeMake(viewSize.width, viewSize.height - controllerTop));
    }];
    [bankTitleView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(scrollView).offset(0);
        make.left.equalTo(scrollView).offset(0);
        make.size.mas_equalTo(CGSizeMake(commWidth, bankTitleViewHeight));
    }];
    
    [bankTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(scrollView).offset(leftRightSpace);
        make.centerY.equalTo(bankTitleView);
        make.size.mas_equalTo(CGSizeMake(commWidth, bankTitleLabelSize.height));
    }];
    
    
    [inputView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(bankTitleView.mas_bottom).offset(0);
        make.left.equalTo(scrollView).offset(0);
        make.size.mas_equalTo(CGSizeMake(viewSize.width, inputViewHeight));
    }];
    
    [bankView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(inputView);
        make.size.mas_equalTo(CGSizeMake(commWidth, bankViewHeight));
    }];
    
    [bankLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(bankView).offset(0);
        make.centerY.equalTo(bankView);
        make.size.mas_equalTo(CGSizeMake(bankLabelSize.width, bankLabelSize.height));
    }];
    
    [bankContentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(bankLabel.mas_right).offset(leftRightSpace);
        make.centerY.equalTo(bankView);
        make.size.mas_equalTo(CGSizeMake(bankContentLabelWidth, bankContentLabelSize.height));
    }];
    
    [bankAreaView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(inputView.mas_bottom).offset(sapce);
        make.left.equalTo(scrollView).offset(0);
        make.size.mas_equalTo(CGSizeMake(viewSize.width, bankAreaViewHeight));
    }];
    
    [bankInfoView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(bankAreaView).offset(0);
        make.centerX.equalTo(bankAreaView);
        make.size.mas_equalTo(CGSizeMake(viewSize.width, bankInfoViewHeight));
    }];
    
    [nameView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(bankInfoView).offset(0);
        make.centerX.equalTo(bankInfoView);
        make.size.mas_equalTo(CGSizeMake(commWidth, commViewHeight));
    }];
    
    [nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(nameView).offset(0);
        make.centerY.equalTo(nameView);
        make.size.mas_equalTo(CGSizeMake(nameLabelSize.width, nameLabelSize.height));
    }];
    
    [nameTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(nameLabel.mas_right).offset(sapce);
        make.centerY.equalTo(nameView);
        make.size.mas_equalTo(CGSizeMake(nameTextFieldWidth, nameTextFieldSize.height));
    }];
    
    [nameLineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(nameView.mas_bottom).offset(0);
        make.left.equalTo(bankInfoView).offset(leftRightSpace);
        make.size.mas_equalTo(CGSizeMake(commLineWidth, lineViewHeight));
    }];
    
    [IDNumView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(nameLineView.mas_bottom).offset(0);
        make.centerX.equalTo(bankInfoView);
        make.size.mas_equalTo(CGSizeMake(commWidth, commViewHeight));
    }];
    
    [IDNumLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(IDNumView).offset(0);
        make.centerY.equalTo(IDNumView);
        make.size.mas_equalTo(CGSizeMake(IDNumLabelSize.width, IDNumLabelSize.height));
    }];
    
    [IDNumTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(IDNumLabel.mas_right).offset(sapce);
        make.centerY.equalTo(IDNumView);
        make.size.mas_equalTo(CGSizeMake(IDNumTextFieldWidth, IDNumTextFieldSize.height));
    }];
    
    [IDNumLineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(IDNumView.mas_bottom).offset(0);
        make.left.equalTo(bankInfoView).offset(leftRightSpace);
        make.size.mas_equalTo(CGSizeMake(commLineWidth, lineViewHeight));
    }];
    
    [authToolsView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(IDNumLineView.mas_bottom).offset(sapce);
        make.left.equalTo(scrollView).offset(0);
        make.size.mas_equalTo(CGSizeMake(viewSize.width, authToolsViewH));
    }];
    
    [shortcutBgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(authToolsView.mas_bottom).offset(10);
        make.centerX.equalTo(scrollView);
        make.size.mas_equalTo(CGSizeMake(commWidth,shortcutImage.size.height));
    }];
    [shortcutImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(shortcutBgView.mas_left).offset(leftRightSpace);
        make.centerY.equalTo(shortcutBgView);
    }];
    [shortcutLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(shortcutImageView.mas_right).offset(10);
        make.centerY.equalTo(shortcutBgView);
    }];
    
    
    
    
    [authenticationBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(authToolsView.mas_bottom).offset(authenticationBtnTop*2); //
        make.centerX.equalTo(scrollView);
    }];
    
    [agreementAreaView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(authenticationBtn.mas_bottom).offset(leftRightSpace);
        make.centerX.equalTo(scrollView);
        make.size.mas_equalTo(CGSizeMake(viewSize.width, agreementAreaViewHeight));
    }];
    
    [agreeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(agreementAreaView).offset(leftRightSpace);
        make.centerX.equalTo(agreementAreaView);
        make.size.mas_equalTo(agreeLabelSize);
    }];
    
    [lookAgreeOnLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(agreeLabel.mas_bottom).offset(0);
        make.centerX.equalTo(agreementAreaView);
        make.size.mas_equalTo(agreeLabelSize);
    }];
    scrollView.contentSize = CGSizeMake(viewSize.width,bankAreaViewHeight + authToolsViewH + agreementAreaViewHeight + authenticationBtnTop + authenticationBtnHeight + 100);
    
    [self setInputResponderChain];
}

#pragma mark - 添加label添加事件
/**
 *@brief 添加label添加事件
 *@return
 */
-(void) labelTouchUpInside:(UITapGestureRecognizer *)recognizer{
    FAQwebViewController *vc = [[FAQwebViewController alloc] init];
    vc.titleName = @"服务协议";
    vc.urlstr = [NSString stringWithFormat:@"%@%@",AddressHTTP,ot_index];
    [self.navigationController pushViewController:vc animated:YES];
    
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
            [self dismissKeyboard];
            shortMsgTextField.text = @"";
            timeCount = timeOut;
            [self shortMsg];
        }
            break;
        case 2:
        {
            [self dismissKeyboard];
            [self verificationInput];
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
    if (IDNumTextField) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFiledEditChanged:) name:UITextFieldTextDidChangeNotification object:IDNumTextField];
    }
    if (nameTextField) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFiledEditChanged:) name:UITextFieldTextDidChangeNotification object:nameTextField];
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
    
    if (CVNTextField) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFiledEditChanged:) name:UITextFieldTextDidChangeNotification object:CVNTextField];
    }
    
    if (expiryTextField) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFiledEditChanged:) name:UITextFieldTextDidChangeNotification object:expiryTextField];
    }
}

- (void)textFiledEditChanged:(NSNotification *)obj
{
    UITextField *textField = (UITextField *)obj.object;
    NSString *content = textField.text;
    
    int maxLenght = [textField.maxLenght intValue];
    NSInteger lenght = content.length;
    
    NSLog(@"键盘输出: ---> %@",content);
    
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
        }
        
    }
    
    [self textFiledEditChanged];
    
}
#pragma mark - 限制键盘输入某些字符
-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    if ([textField.placeholder rangeOfString:@"姓名"].location !=NSNotFound) {
        return [self restrictionwithChineseCharTypeStr:OnlyChineseCharacterVerifi string:string];
    }
    if ([textField.placeholder rangeOfString:@"证件号"].location !=NSNotFound) {
      return [self restrictionwithTypeStr:IDCardVerifi string:string];
    }
    if ([textField.placeholder rangeOfString:@"三位数字"].location !=NSNotFound) {
      return [self restrictionwithTypeStr:OnlyNumberVerifi string:string];
    }
    if ([textField.placeholder rangeOfString:@"有效期"].location !=NSNotFound) {
        return [self restrictionwithTypeStr:OnlyNumberVerifi string:string];
    }
    if ([textField.placeholder rangeOfString:@"预留手机号"].location !=NSNotFound) {
        return [self restrictionwithTypeStr:OnlyNumberVerifi string:string];
    }
    if ([textField.placeholder rangeOfString:@"数字验证码"].location !=NSNotFound) { 
        return [self restrictionwithTypeStr:OnlyNumberVerifi string:string];
    }
    return YES;

}
-(BOOL)restrictionwithChineseCharTypeStr:(NSString*)typeStr string:(NSString*)string{
    NSCharacterSet *cs = [[NSCharacterSet characterSetWithCharactersInString:typeStr] invertedSet];
    NSString *filtered = [[string componentsSeparatedByCharactersInSet:cs] componentsJoinedByString:@""];
    if ([string isEqualToString:@""]) { //不过滤回退键
        return YES;
    }
    if ([string isEqualToString:filtered]) {
        return NO; //过滤
    }else{
        return YES;
    }
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
    
    if (CVNTextField) {
        if ([@"" isEqualToString:CVNTextField.text] || CVNTextField.text == nil) {
            return [self changeBtnBackGround:nil index:2];
        }
    }
    
    if (expiryTextField) {
        if ([@"" isEqualToString:expiryTextField.text] || expiryTextField.text == nil) {
            return [self changeBtnBackGround:nil index:2];
        }
    }
    
//    if (checkBox.checked == NO) {
//        return [self changeBtnBackGround:nil index:2];
//    }
    
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
            
            [authenticationBtn setBackgroundImage:[UIImage imageWithColor:RGBA(65, 131, 215, 1.0) size:CGSizeMake(btnW, btnH)] forState:UIControlStateNormal];
            
            [authenticationBtn setBackgroundImage:[UIImage imageWithColor:RGBA(65, 131, 215, 1.0) size:CGSizeMake(btnW, btnH)] forState:UIControlStateHighlighted];
            
            authenticationBtn.userInteractionEnabled = YES;
        } else {
            [shortMsgBtn setTitleColor:RGBA(200, 199, 204, 1.0) forState:UIControlStateNormal];
            shortMsgBtn.userInteractionEnabled = NO;
            
            [authenticationBtn setBackgroundImage:[UIImage imageWithColor:RGBA(200, 200, 200, 1.0) size:CGSizeMake(btnW, btnH)] forState:UIControlStateNormal];
            
            [authenticationBtn setBackgroundImage:[UIImage imageWithColor:RGBA(200, 200, 200, 1.0) size:CGSizeMake(btnW, btnH)] forState:UIControlStateHighlighted];
            
            authenticationBtn.userInteractionEnabled = NO;
        }
    } else if (index == 2) {
        if (![@"" isEqualToString:param] && param != nil) {
            [authenticationBtn setBackgroundImage:[UIImage imageWithColor:RGBA(65, 131, 215, 1.0) size:CGSizeMake(btnW, btnH)] forState:UIControlStateNormal];
            
            [authenticationBtn setBackgroundImage:[UIImage imageWithColor:RGBA(65, 131, 215, 1.0) size:CGSizeMake(btnW, btnH)] forState:UIControlStateHighlighted];
            
            authenticationBtn.userInteractionEnabled = YES;
        } else {
            [authenticationBtn setBackgroundImage:[UIImage imageWithColor:RGBA(200, 200, 200, 1.0) size:CGSizeMake(btnW, btnH)] forState:UIControlStateNormal];
            
            [authenticationBtn setBackgroundImage:[UIImage imageWithColor:RGBA(200, 200, 200, 1.0) size:CGSizeMake(btnW, btnH)] forState:UIControlStateHighlighted];
            
            authenticationBtn.userInteractionEnabled = NO;
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

#pragma mark - 把所有的输入框放到数组中
/**
 *@brief 把所有的输入框放到数组中
 *@return NSArray
 */
- (NSArray *)allInputFields {
    return textFieldArray;
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
    phoneNumTextField.keyboardType = UIKeyboardTypeNumberPad;
    CVNTextField.keyboardType = UIKeyboardTypeNumberPad;
    shortMsgTextField.keyboardType = UIKeyboardTypeNumberPad;
    expiryTextField.keyboardType = UIKeyboardTypeNumberPad;
    UITextField *textField = textFieldArray.lastObject;
    textField.returnKeyType = UIReturnKeyDone;
}

/**
 *@brief 隐藏键盘
 */
- (void)dismissKeyboard {
    //将视图的Y坐标向上移动offset个单位，以使下面腾出地方用于软键盘的显示
    [scrollView setContentOffset:CGPointMake(0.0f, 0.0f) animated:YES] ;
    [self.view endEditing:YES];
}

#pragma mark - 业务逻辑

/**
 *@brief 获取鉴权工具
 */
- (void)load
{
    HUD = [SDMBProgressView showSDMBProgressOnlyLoadingINViewImg:self.view];
    [SDRequestHelp shareSDRequest].HUD = HUD;
    [SDRequestHelp shareSDRequest].controller = self;
    [[SDRequestHelp shareSDRequest] dispatchGlobalQuque:^{
        __block BOOL error = NO;
        [[SDRequestHelp shareSDRequest] requestWihtFuncName:@"authTool/getAuthTools/v1" errorBlock:^(SDRequestErrorType type) {
            error = YES;
        } successBlock:^{
            [[SDRequestHelp shareSDRequest] dispatchToMainQueue:^{
                [HUD hidden];
                
                NSString *tempAuthTools = [NSString stringWithUTF8String:paynuc.get("authTools").c_str()];
                NSArray *tempAuthToolsArray = [[PayNucHelper sharedInstance] jsonStringToArray:tempAuthTools];
                
                //1.取有效的鉴权工具 (贷记卡时,下发的payTools自带一个空鉴权,导致循环添加鉴权工具时,下移个groupViewHight)
                for (int i = 0; i<authToolsArray.count; i++) {
                    if (!([[authToolsArray[i] objectForKey:@"type"] length]>0)) {
                        [authToolsArray removeObjectAtIndex:i];
                    }
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
        if (error) return ;
        
    }];
    
}

/**
 *@brief 添加鉴权工具view
 *@param view UIView 参数：组件
 *@return CGFloat
 */
- (CGFloat)addAuthToolsView:(UIView *)view
{
    //CGFloat lineViewHeight = 1;
    CGFloat tempHeight = 0;
    CGFloat allHeight = 0;
    CGFloat groupViewHight = 0;
    
    textFieldTag = 2;
    
    NSInteger authToolsArrayCount = [authToolsArray count];
    for (int i = 0; i < authToolsArrayCount; i++) {
        NSMutableDictionary *dic = authToolsArray[i];
        NSString *type = [dic objectForKey:@"type"];
        
        GroupView *groupView = [[GroupView alloc] initWithFrame:self.view.frame];
        
        textFieldTag = textFieldTag + 1;
        
        if ([@"sms" isEqualToString:type]) {
            
//            UIView *shortMsgView = [[UIView alloc] init];
//            shortMsgView.backgroundColor = RGBA(242, 242, 242, 1.0);
//            [view addSubview:shortMsgView];
            
//            CGFloat shortMsgViewW = viewSize.width;
//            CGFloat shortMsgViewH = 10;
//            CGFloat shortMsgViewOX = 0;
//            CGFloat shortMsgViewOY = allHeight;
            
//            shortMsgView.frame = CGRectMake(shortMsgViewOX, shortMsgViewOY, shortMsgViewW, shortMsgViewH);
            
//            tempHeight = tempHeight + shortMsgViewH;
            
            groupView.groupViewStyle = GroupViewStyleYes;
            groupViewHight = [groupView shortMsgAndPhoneNumVerification];
            allHeight = allHeight + groupViewHight ;
            phoneNumTextField = groupView.phoneNumVerificationTextField;
            shortMsgBtn = groupView.shortMsgVerificationBtn;
            shortMsgTextField = groupView.shortMsgVerificationTextField;
            
            shortMsgBtn.tag = 1;
            phoneNumTextField.placeholder = @"银行预留手机号";
            phoneNumTextField.text = SHOWTOTEST(@"15901918148");
            [phoneNumTextField setMinLenght:@"0"];
            [phoneNumTextField setMaxLenght:@"11"];
            phoneNumTextField.tag = textFieldTag;
            [textFieldArray addObject:phoneNumTextField];
            
            [shortMsgTextField setMinLenght:@"0"];
            [shortMsgTextField setMaxLenght:@"6"];
            shortMsgTextField.text = SHOWTOTEST(@"111111");
            textFieldTag = textFieldTag + 1;
            shortMsgTextField.tag = textFieldTag;
            [textFieldArray addObject:shortMsgTextField];
            
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
            
            loginPwdTextField.tag = textFieldTag;
            loginPwdBtn.tag = 2;
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
            
            groupViewHight = [groupView shortMsgAndPhoneNumVerification];
            allHeight = allHeight + groupViewHight;
            questionTextField = groupView.loginPwdVerificationTextField;
        }
        
        if ([@"identity" isEqualToString:type]) {
            
            groupViewHight = [groupView IDCardVerification];
            allHeight = allHeight + groupViewHight;
            IDCardTextField = groupView.IDCardVerificationTextField;
            IDCardTextField.tag = 2;
        }
        
        if ([@"img" isEqualToString:type]) {
            
            groupViewHight = [groupView pictureVerification];
            allHeight = allHeight + groupViewHight;
            pictureBtn = groupView.pictureVerificationBtn;
            pictureNumTextField = groupView.pictureVerificationTextField;
        }
        
        if ([@"bankcard" isEqualToString:type]) {
            
            groupViewHight = [groupView creditCardVerification];
            allHeight = allHeight + groupViewHight;
            bankCardTextField = groupView.bankCardVerificationTextField;
        }
        
        if ([@"creditCard" isEqualToString:type]) {
            UIView *shortMsgView = [[UIView alloc] init];
            shortMsgView.backgroundColor = RGBA(242, 242, 242, 1.0);
            [view addSubview:shortMsgView];
            
            CGFloat shortMsgViewW = viewSize.width;
            CGFloat shortMsgViewH = 10;
            CGFloat shortMsgViewOX = 0;
            CGFloat shortMsgViewOY = allHeight;
            

            groupView.groupViewStyle = GroupViewStyleYes;
            groupViewHight = [groupView creditCardVerification];
            allHeight = allHeight + groupViewHight;
            CVNTextField = groupView.cvnVerificationTextField;
            expiryTextField = groupView.expiryVerificationTextField;
            
            CVNTextField.text = SHOWTOTEST(@"888");
            [CVNTextField setMinLenght:@"3"];
            [CVNTextField setMaxLenght:@"3"];
            CVNTextField.tag = textFieldTag;
            [textFieldArray addObject:CVNTextField];
            
            expiryTextField.text = SHOWTOTEST(@"0518");
            [expiryTextField setMinLenght:@"4"];
            [expiryTextField setMaxLenght:@"4"];
            textFieldTag = textFieldTag + 1;
            expiryTextField.tag = textFieldTag;
            [textFieldArray addObject:expiryTextField];
            shortMsgView.frame = CGRectMake(shortMsgViewOX, shortMsgViewOY+groupViewHight, shortMsgViewW, shortMsgViewH);
        }
        
        if (i == 0) {
            groupView.frame = CGRectMake(0, 0, viewSize.width, groupViewHight);
        } else {
            tempHeight = tempHeight + groupViewHight;
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
    if (phoneNumTextField.text.length != [phoneNumTextField.maxLenght intValue] || ![NSRegularExpression validateMobile:phoneNumTextField.text] ) {
        return [Tool showDialog:@"输入的手机号码格式不正确，请重新输入。"];
    }
    
    HUD = [SDMBProgressView showSDMBProgressOnlyLoadingINViewImg:self.view];
    [SDRequestHelp shareSDRequest].HUD = HUD;
    [SDRequestHelp shareSDRequest].controller = self;
    [[SDRequestHelp shareSDRequest] dispatchGlobalQuque:^{
        __block BOOL error = NO;
        NSMutableDictionary *authToolDic = [[NSMutableDictionary alloc] init];
        [authToolDic setValue:@"sms" forKey:@"type"];
        NSMutableDictionary *smsDic = [[NSMutableDictionary alloc] init];
        [smsDic setValue:phoneNumTextField.text forKey:@"phoneNo"];
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

/**
 *@brief 输入数据验证
 */
- (void)verificationInput
{
    if (nameTextField.text.length > [nameTextField.maxLenght intValue] ) {
        return [Tool showDialog:@"输入的姓名格式不正确，请重新输入。"];
    }
    
    if (IDNumTextField.text.length < [IDNumTextField.minLenght intValue] || IDNumTextField.text.length > [IDNumTextField.maxLenght intValue] ) {
        return [Tool showDialog:@"输入的证件号格式不正确，请重新输入。"];
    }
    
    if (CVNTextField) {
        if (CVNTextField.text.length != [CVNTextField.maxLenght intValue] ) {
            return [Tool showDialog:@"输入的CVN格式不正确，请重新输入。"];
        }
    }
    
    if (expiryTextField) {
        if (expiryTextField.text.length != [expiryTextField.maxLenght intValue] ) {
            return [Tool showDialog:@"输入的有效期格式不正确，请重新输入。"];
        }
    }
    
    if (phoneNumTextField.text.length != [phoneNumTextField.maxLenght intValue] || ![NSRegularExpression validateMobile:phoneNumTextField.text] ) {
        return [Tool showDialog:@"输入的手机号格式不正确，请重新输入。"];
    }
    
    if (shortMsgTextField.text.length != [shortMsgTextField.maxLenght intValue] ) {
        return [Tool showDialog:@"输入的短信码格式不正确，请重新输入。"];
    }
    
    [self authentication];
}

/**
 *@brief 实名
 */
- (void)authentication
{
    HUD = [SDMBProgressView showSDMBProgressOnlyLoadingINViewImg:self.view];
    [SDRequestHelp shareSDRequest].HUD = HUD;
    [SDRequestHelp shareSDRequest].controller = self;
    [[SDRequestHelp shareSDRequest] dispatchGlobalQuque:^{
        __block BOOL error = NO;
        
        //短信
        NSMutableArray *authToolsArray1 = [[NSMutableArray alloc] init];
        NSMutableDictionary *authToolDic1 = [[NSMutableDictionary alloc] init];
        [authToolDic1 setValue:@"sms" forKey:@"type"];
        NSMutableDictionary *smsDic = [[NSMutableDictionary alloc] init];
        [smsDic setValue:phoneNumTextField.text forKey:@"phoneNo"];
        [smsDic setValue:shortMsgTextField.text forKey:@"code"];
        [authToolDic1 setObject:smsDic forKey:@"sms"];
        [authToolsArray1 addObject:authToolDic1];
        
        NSString *authTools = [[PayNucHelper sharedInstance] arrayToJSON:authToolsArray1];
        
        [SDLog logTest:authTools];
        
        NSString *expiry = @"";
        if (expiryTextField) {
            expiry = expiryTextField.text;
        }
        
        NSString *cvn = @"";
        if (CVNTextField) {
            cvn = CVNTextField.text;
        }
        
        NSDictionary *passAccountDic = [passPayToolDic objectForKey:@"account"];
        
        //账户
        NSMutableDictionary *payToolDic = [[NSMutableDictionary alloc] init];
        NSMutableDictionary *accountDic = [[NSMutableDictionary alloc] init];
        [accountDic setValue:[passAccountDic objectForKey:@"accAlias"] forKey:@"accAlias"];
        [accountDic setValue:[passAccountDic objectForKey:@"accNo"] forKey:@"accNo"];
        [accountDic setValue:[passAccountDic objectForKey:@"balance"] forKey:@"balance"];
        [accountDic setValue:[passAccountDic objectForKey:@"walletBalance"] forKey:@"walletBalance"];
        //        [accountDic setValue:cvn forKey:@"cvn"];
        [accountDic setValue:expiry forKey:@"expiry"];
        [accountDic setValue:[passAccountDic objectForKey:@"freezedBalance"] forKey:@"freezedBalance"];
        [accountDic setValue:[passAccountDic objectForKey:@"kind"] forKey:@"kind"];
        [accountDic setValue:[passAccountDic objectForKey:@"useableBalance"] forKey:@"useableBalance"];
        [payToolDic setValue:[passPayToolDic objectForKey:@"id"] forKey:@"id"];
        [payToolDic setValue:[passPayToolDic objectForKey:@"title"] forKey:@"title"];
        [payToolDic setValue:[passPayToolDic objectForKey:@"type"] forKey:@"type"];
        [payToolDic setValue:[passPayToolDic objectForKey:@"available"] forKey:@"available"];
        [payToolDic setValue:[passPayToolDic objectForKey:@"isDefault"] forKey:@"isDefault"];
        [payToolDic setValue:[passPayToolDic objectForKey:@"img"] forKey:@"img"];
        [payToolDic setValue:[passPayToolDic objectForKey:@"description"] forKey:@"description"];
        [payToolDic setValue:[passPayToolDic objectForKey:@"payMode"] forKey:@"payMode"];
        
        NSMutableArray *authToolsArray2 = [[NSMutableArray alloc] init];
        NSMutableDictionary *authToolDic2 = [[NSMutableDictionary alloc] init];
        [authToolDic2 setValue:@"creditCard" forKey:@"type"];
        NSMutableDictionary *creditCardDic = [[NSMutableDictionary alloc] init];
        [creditCardDic setValue:CVNTextField.text forKey:@"cvn"];
        [creditCardDic setValue:expiryTextField.text forKey:@"expiry"];
        [authToolDic2 setObject:creditCardDic forKey:@"creditCard"];
        [authToolsArray2 addObject:authToolDic2];
        
        [payToolDic setObject:authToolsArray2 forKey:@"authTools"];
        
        
        
        [payToolDic setValue:[passPayToolDic objectForKey:@"limit"] forKey:@"limit"];
        [payToolDic setValue:[passPayToolDic objectForKey:@"period"] forKey:@"period"];
        [payToolDic setValue:[passPayToolDic objectForKey:@"bindedFlag"] forKey:@"bindedFlag"];
        [payToolDic setValue:[passPayToolDic objectForKey:@"fastPayFlag"] forKey:@"fastPayFlag"];
        [payToolDic setObject:accountDic forKey:@"account"];
        
        NSString *payTool = [[PayNucHelper sharedInstance] dictionaryToJson:payToolDic];
        
        [SDLog logTest:payTool];
        
        
        NSDictionary *passUserKeyDic = [passUserInfoDic objectForKey:@"userKey"];
        //用户
        NSMutableDictionary *userInfoDic = [[NSMutableDictionary alloc] init];
        NSMutableDictionary *identityDic = [[NSMutableDictionary alloc] init];
        [identityDic setValue:IDNumTextField.text forKey:@"identityNo"];
        [identityDic setValue:@"01" forKey:@"type"];
        NSMutableDictionary *lastLoginDic = [[NSMutableDictionary alloc] init];
        [lastLoginDic setValue:[NSDate currentTime] forKey:@"time"];
        [lastLoginDic setValue:@"登录地点" forKey:@"location"];
        NSMutableDictionary *userKeyDic = [[NSMutableDictionary alloc] init];
        [userKeyDic setValue:[passUserKeyDic objectForKey:@"index"] forKey:@"index"];
        [userKeyDic setValue:[passUserKeyDic objectForKey:@"key"] forKey:@"key"];
        [userInfoDic setValue:[passUserKeyDic objectForKey:@"avatar"] forKey:@"avatar"];
        [userInfoDic setValue:[passUserKeyDic objectForKey:@"email"] forKey:@"email"];
        [userInfoDic setValue:[passUserKeyDic objectForKey:@"nick"] forKey:@"nick"];
        [userInfoDic setValue:[passUserKeyDic objectForKey:@"phoneNo"] forKey:@"phoneNo"];
        [identityDic setValue:[passUserKeyDic objectForKey:@"realNameFlag"] forKey:@"realNameFlag"];
        [identityDic setValue:[passUserKeyDic objectForKey:@"remainState"] forKey:@"remainState"];
        [identityDic setValue:[passUserKeyDic objectForKey:@"safeQuestionFlag"] forKey:@"safeQuestionFlag"];
        [identityDic setValue:[passUserKeyDic objectForKey:@"userId"] forKey:@"userId"];
        [userInfoDic setValue:[passUserKeyDic objectForKey:@"userName"] forKey:@"userName"];
        [userInfoDic setValue:nameTextField.text forKey:@"userRealName"];
        [userInfoDic setObject:lastLoginDic forKey:@"lastLogin"];
        [userInfoDic setObject:userKeyDic forKey:@"userKey"];
        [userInfoDic setObject:identityDic forKey:@"identity"];
        
        NSString *userInfo = [[PayNucHelper sharedInstance] dictionaryToJson:userInfoDic];
        
        [SDLog logTest:userInfo];
        
        
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
                            [self realNameSuccess];
                        }];
                    }else{
                        [self.navigationController popViewControllerAnimated:YES];
                    }
                }
            }];
        } successBlock:^{
            [[SDRequestHelp shareSDRequest] dispatchToMainQueue:^{
                [HUD hidden];
                [self realNameSuccess];
            }];
        }];
        if (error) return ;
    }];
    
}

/**
 认证成功跳转
 */
- (void)realNameSuccess{
    //实名认证成功,实名认证标志改变
    [CommParameter sharedInstance].realNameFlag = YES;
    //实名认证成功,实名赋值
    [CommParameter sharedInstance].userRealName = nameTextField.text;
    
    RealNameAuthenticationrResultViewController *mRealNameAuthenticationrResultViewController = [[RealNameAuthenticationrResultViewController alloc] init];
    mRealNameAuthenticationrResultViewController.isFromSPSrealName = _isFromSPSrealName;
    [self.navigationController pushViewController:mRealNameAuthenticationrResultViewController animated:YES];

}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UITextFieldTextDidChangeNotification object:bankNameTextField];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UITextFieldTextDidChangeNotification object:IDNumTextField];
    
    if (phoneNumTextField) {
        [[NSNotificationCenter defaultCenter] removeObserver:self name:UITextFieldTextDidChangeNotification object:expiryTextField];
    }
    
    if (phoneNumTextField) {
        [[NSNotificationCenter defaultCenter] removeObserver:self name:UITextFieldTextDidChangeNotification object:CVNTextField];
    }
    
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
    
    if (expiryTextField) {
        [[NSNotificationCenter defaultCenter] removeObserver:self name:UITextFieldTextDidChangeNotification object:expiryTextField];
    }
    
    if (CVNTextField) {
        [[NSNotificationCenter defaultCenter] removeObserver:self name:UITextFieldTextDidChangeNotification object:CVNTextField];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
