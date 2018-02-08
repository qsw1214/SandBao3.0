//
//  PayView.m
//  sandbao
//
//  Created by tianNanYiHao on 2017/2/23.
//  Copyright © 2017年 sand. All rights reserved.
//

#import "PayView.h"
#import "PayNucHelper.h"


#define ColorHUI RGBA(225, 225, 225, 1.0)
#define ColorPwdBorder RGBA(64,101,180,1.0)
#define ColorClosedBtn RGBA(140,144,157,1.0)
#define pwdTextFieldTextSize [UIFont systemFontOfSize:14.0f]
#define pwdTextFieldTextColor [UIColor blackColor]
#define titleColor RGBA(174, 174, 174, 1.0)
#define textFiledColor RGBA(83, 83, 83, 1.0)

#define animationDuration 0.25f

//键盘属性
#define keyBordCellBoardLine 0.3f
#define keyBordCellWidth  ([UIScreen mainScreen].bounds.size.width - 2*keyBordCellBoardLine)/3
#define keyBordCellHeight keyBordCellWidth*0.54f
#define keyBordViewHeight 4*keyBordCellHeight







@interface PayView()<UITextFieldDelegate>
{
    //记录选择的支付列表支付工具下标
    NSInteger payListSelectedIndex;
}
@property(nonatomic,assign)BOOL runFlag;
@property(nonatomic,assign)PayViewStyle payViewStyle;
@property(nonatomic,assign)CGSize viewsize;

@property(nonatomic,strong)UIView * backGroundView;
@property(nonatomic,strong)UIView * commView;
@property(nonatomic,assign)CGFloat commViewHeight;

@property (strong, nonatomic) UITextField *pwdTextFieldOne, *pwdTextFieldTwo, *pwdTextFieldThree, *pwdTextFieldFour, *pwdTextFieldFive, *pwdTextFieldSix;
@property(nonatomic,strong)UIView * keyBordView;
@property(nonatomic,strong)NSMutableArray * tempArray;
@property (strong, nonatomic) NSString *payPwd;

@property(nonatomic,strong)NSDictionary * defaultPay;
@property(nonatomic,strong)NSMutableArray * payListArray;

@property(nonatomic,strong)NSDictionary * payDetailsDic;
@property(nonatomic,strong)UITextField *accpwdTextfiled;

@property(nonatomic,assign)CGFloat commViewOX;
@property(nonatomic,assign)CGFloat commViewOY;

@property(nonatomic,strong)NSMutableArray * viewArray;
@property(nonatomic,strong)UILabel *payModeLabel;
@property(nonatomic,strong)UITapGestureRecognizer *gestureRecognzier;
@end

@implementation PayView


@synthesize runFlag;

@synthesize viewsize;

@synthesize backGroundView;
@synthesize commView;
@synthesize commViewHeight;

@synthesize pwdTextFieldOne, pwdTextFieldTwo, pwdTextFieldThree, pwdTextFieldFour, pwdTextFieldFive, pwdTextFieldSix;
@synthesize keyBordView;
@synthesize tempArray;
@synthesize payPwd;

@synthesize accpwdTextfiled;
@synthesize defaultPay;
@synthesize payListArray;

@synthesize payDetailsDic;


@synthesize commViewOX;
@synthesize commViewOY;

@synthesize viewArray;

@synthesize payModeLabel;
@synthesize gestureRecognzier;

#pragma - mark 类初始化
+ (instancetype)getPayView{
    PayView *pay = [[PayView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    pay.hidden = YES;
    return pay;
}
#pragma - mark ---------------外部调用方法------------------
/**
 *显示控件（支付密码类型）
 *
 */
- (void)showPaypassPwdView
{
    viewsize = self.frame.size;
    
    self.hidden = NO;
    
    [self initView:PayViewStylePaypass];
    
    [self startPayPassword];
}

/**
 显示控件 (账户密码类型)
 */
- (void)showAccpassPwdView{
    
    viewsize = self.frame.size;
    
    self.hidden = NO;
    
    [self initView:PayViewStyleAccpass];
    
    [self startAccPassword];
}

/**
 *@brief  支付列表
 *@param param NSString 参数：默认支付
 *@param payArray NSMutableArray 参数：支付列表
 *
 */
- (void)showRechargeModeView:(NSDictionary *)payModeDic paramArray:(NSMutableArray *)paramArray
{
    viewsize = self.frame.size;
    
    self.hidden = NO;
    
    defaultPay = payModeDic;
    payListArray = paramArray;
    
    [self initView:PayViewStylePayList];
    
    [self start];
}

/**
 *@brief  付款详情
 *@param orderDic NSDictionary 参数：订单信息
 *@param paramDic NSDictionary 参数：默认支付方式
 *@param btnBlock block 参数：按钮索引
 *
 */
- (void)showPayDetailsView:(NSDictionary *)orderDic paramDic:(NSDictionary *)paramDic
{
    viewsize = self.frame.size;
    
    self.hidden = NO;
    
    payDetailsDic = orderDic;
    defaultPay = paramDic;
    
    
    [self initView:PayViewStylePayDetails];
    
    [self start];
}


#pragma - mark --------------内部调用方法----------------------

#pragma - mark UI创建
- (void)initView:(PayViewStyle)style
{
    self.payViewStyle = style;
    
    if (runFlag == NO) {
        viewArray = [[NSMutableArray alloc] init];
        
        backGroundView=[[UIView alloc] initWithFrame:CGRectMake(0, 0, viewsize.width, viewsize.height)];
        backGroundView.backgroundColor=[UIColor blackColor];
        backGroundView.alpha = 0.f;
        [self addSubview:backGroundView];
        [self viewMaskViewAnimtion:backGroundView runFlag:runFlag];
    }
    
    //1.支付(paypass)密码控件
    if (style == PayViewStylePaypass) {
        commViewOX = 0;
        commViewHeight = viewsize.height * 0.5;
        commViewOY = viewsize.height;
        [self initPayPasswordView];
    }
    //2.卡账户(Accpass)密码控件
    else if (style == PayViewStyleAccpass) {
        commViewOX = 0;
        commViewHeight = viewsize.height * 0.3;
        commViewOY = - commViewHeight;
        [self initAccpassWordView];
    }
    //3.支付工具列表
    else if (style == PayViewStylePayList) {
        commViewOX = 0;
        commViewHeight = viewsize.height * 0.7;
        commViewOY = viewsize.height;
        [self initRechargeModeView];
    }
    //4.付款详情控件(暂未使用)
    else if (style == PayViewStylePayDetails) {
        commViewOX = 0;
        commViewHeight = viewsize.height * 0.5;
        commViewOY = viewsize.height;
        [self initPayDetailsView];
    }
    
}

#pragma  - mark 支付(paypass)密码控件
- (void)initPayPasswordView
{
    commView = [[UIView alloc] init];
    commView.backgroundColor = [UIColor whiteColor];
    [self addSubview:commView];
    
    [viewArray addObject:commView];
    
    CGFloat commViewWidth = viewsize.width;
    
    commView.frame = CGRectMake(commViewOX, commViewOY, commViewWidth, commViewHeight);
    
    CGFloat PayPwdViewOX = 0;
    CGFloat PayPwdViewOY = 0;
    CGFloat leftSpace    = 15.f;
    CGFloat PayPwdViewWidth = viewsize.width;
    
    
    CGFloat pwdTextFieldBorderWidth = 0.8f;
    CGFloat allPwdTextFieldBorderWidth = pwdTextFieldBorderWidth * 5;
    
    CGFloat pwdTextFieldWidth = (PayPwdViewWidth - 2*leftSpace - allPwdTextFieldBorderWidth)/6;
    CGFloat pwdTextFieldHeight = pwdTextFieldWidth;
    
    CGFloat allPwdTextFieldWidth = pwdTextFieldWidth * 6;
    
    
    UIView *PayPwdView=[[UIView alloc] init];
    PayPwdView.backgroundColor=[UIColor whiteColor];
    [commView addSubview:PayPwdView];
    
    
    //  关闭
    UIButton *closeBtn = [[UIButton alloc] init];
    closeBtn.titleLabel.font = [UIFont systemFontOfSize:17];
    [closeBtn setTitleColor:ColorClosedBtn forState:UIControlStateNormal];
    [closeBtn addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
    [PayPwdView addSubview:closeBtn];
    
    NSInteger viewArrayCount = [viewArray count];
    if (viewArrayCount > 1){
        [closeBtn setTag:30000102];
        [closeBtn setTitle:@"<" forState: UIControlStateNormal];
    } else {
        [closeBtn setTag:TAG_BTN_CLOSED];
        [closeBtn setTitle:@"关闭" forState: UIControlStateNormal];
    }
    
    CGFloat closeBtnWidth = 50;
    CGFloat closeBtnOX = 0;
    CGFloat closeBtnOY = 0;
    CGFloat closeBtnHeight = 50;
    
    closeBtn.frame = CGRectMake(closeBtnOX, closeBtnOY, closeBtnWidth, closeBtnHeight);
    //    [closeBtn setTitleEdgeInsets:UIEdgeInsetsMake(-10.0, -10.0, 10.0, 10.0)];
    
    //  title
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.text = @"输入支付密码";
    titleLabel.textColor = [UIColor blackColor];
    titleLabel.font = [UIFont systemFontOfSize:17];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    [PayPwdView addSubview:titleLabel];
    
    CGFloat titleLabelWidth = viewsize.width-closeBtnWidth*2;
    CGSize titleLabelSize = [titleLabel sizeThatFits:CGSizeMake(titleLabelWidth, MAXFLOAT)];
    CGFloat titleLabelOX = closeBtnWidth;
    CGFloat titleLabelOY = (closeBtnHeight - titleLabelSize.height) / 2;
    
    titleLabel.frame = CGRectMake(titleLabelOX, titleLabelOY, titleLabelWidth, titleLabelSize.height);
    
    //线
    CGFloat lineViewOX = 0;
    CGFloat lineViewOY = closeBtnOY + closeBtnHeight;
    CGFloat lineViewWidth = PayPwdViewWidth;
    CGFloat lineViewHeight = 1;
    
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(lineViewOX, lineViewOY, lineViewWidth, lineViewHeight)];
    [lineView setBackgroundColor:ColorHUI];
    [PayPwdView addSubview:lineView];
    
    //  密码输入框
    CGFloat pwdTextFieldOY = lineViewOY + lineViewHeight + 30;
    //背景框
    UIView *pwdTextFieldBackgroundView = [[UIView alloc] initWithFrame:CGRectMake(leftSpace, pwdTextFieldOY, allPwdTextFieldWidth+allPwdTextFieldBorderWidth, pwdTextFieldWidth)];
    pwdTextFieldBackgroundView.backgroundColor = ColorHUI;
    pwdTextFieldBackgroundView.layer.borderColor = ColorPwdBorder.CGColor;
    pwdTextFieldBackgroundView.layer.borderWidth = 0.7f;
    pwdTextFieldBackgroundView.layer.cornerRadius = 5.f;
    pwdTextFieldBackgroundView.layer.shadowColor = [UIColor lightGrayColor].CGColor;
    pwdTextFieldBackgroundView.layer.shadowOffset = CGSizeMake(0, 0);
    pwdTextFieldBackgroundView.layer.shadowRadius = 4.f;
    pwdTextFieldBackgroundView.layer.shadowOpacity = 1.f;
    //        pwdTextFieldBackgroundView.layer.masksToBounds = YES;
    [PayPwdView addSubview:pwdTextFieldBackgroundView];
    
    
    pwdTextFieldOne = [[UITextField alloc] initWithFrame:CGRectMake(0, 0, pwdTextFieldWidth, pwdTextFieldHeight)];
    pwdTextFieldOne.textAlignment= NSTextAlignmentCenter;
    pwdTextFieldOne.textColor= pwdTextFieldTextColor;
    [pwdTextFieldOne setSecureTextEntry:YES];
    pwdTextFieldOne.font= pwdTextFieldTextSize;
    pwdTextFieldOne.layer.borderWidth= pwdTextFieldBorderWidth;
    [pwdTextFieldOne setEnabled:NO];
    pwdTextFieldOne.backgroundColor = [UIColor whiteColor];
    pwdTextFieldOne.layer.borderColor = [UIColor whiteColor].CGColor;
    pwdTextFieldOne.layer.cornerRadius = 5.f;
    [pwdTextFieldBackgroundView addSubview:pwdTextFieldOne];
    
    pwdTextFieldTwo = [[UITextField alloc] initWithFrame:CGRectMake(pwdTextFieldWidth + pwdTextFieldBorderWidth, 0, pwdTextFieldWidth, pwdTextFieldHeight)];
    pwdTextFieldTwo.textAlignment= NSTextAlignmentCenter;
    pwdTextFieldTwo.textColor= pwdTextFieldTextColor;
    [pwdTextFieldTwo setSecureTextEntry:YES];
    pwdTextFieldTwo.font= pwdTextFieldTextSize;
    pwdTextFieldTwo.layer.borderWidth= pwdTextFieldBorderWidth;
    [pwdTextFieldTwo setEnabled:NO];
    pwdTextFieldTwo.backgroundColor = [UIColor whiteColor];
    pwdTextFieldTwo.layer.borderColor = [UIColor whiteColor].CGColor;
    [pwdTextFieldBackgroundView addSubview:pwdTextFieldTwo];
    
    
    pwdTextFieldThree = [[UITextField alloc] initWithFrame:CGRectMake(pwdTextFieldWidth * 2 + pwdTextFieldBorderWidth * 2, 0, pwdTextFieldWidth, pwdTextFieldHeight)];
    pwdTextFieldThree.textAlignment= NSTextAlignmentCenter;
    pwdTextFieldThree.textColor= pwdTextFieldTextColor;
    [pwdTextFieldThree setSecureTextEntry:YES];
    pwdTextFieldThree.font= pwdTextFieldTextSize;
    pwdTextFieldThree.layer.borderWidth=pwdTextFieldBorderWidth;
    [pwdTextFieldThree setEnabled:NO];
    pwdTextFieldThree.backgroundColor = [UIColor whiteColor];
    pwdTextFieldThree.layer.borderColor = [UIColor whiteColor].CGColor;
    [pwdTextFieldBackgroundView addSubview:pwdTextFieldThree];
    
    pwdTextFieldFour = [[UITextField alloc] initWithFrame:CGRectMake(pwdTextFieldWidth * 3 + pwdTextFieldBorderWidth * 3, 0, pwdTextFieldWidth, pwdTextFieldHeight)];
    pwdTextFieldFour.textAlignment= NSTextAlignmentCenter;
    pwdTextFieldFour.textColor= pwdTextFieldTextColor;
    [pwdTextFieldFour setSecureTextEntry:YES];
    pwdTextFieldFour.font= pwdTextFieldTextSize;
    pwdTextFieldFour.layer.borderWidth=pwdTextFieldBorderWidth;
    pwdTextFieldFour.backgroundColor = [UIColor whiteColor];
    pwdTextFieldFour.layer.borderColor = [UIColor whiteColor].CGColor;
    [pwdTextFieldFour setEnabled:NO];
    [pwdTextFieldBackgroundView addSubview:pwdTextFieldFour];
    
    pwdTextFieldFive = [[UITextField alloc] initWithFrame:CGRectMake(pwdTextFieldWidth * 4 + pwdTextFieldBorderWidth * 4, 0, pwdTextFieldWidth, pwdTextFieldHeight)];
    pwdTextFieldFive.textAlignment= NSTextAlignmentCenter;
    pwdTextFieldFive.textColor= pwdTextFieldTextColor;
    [pwdTextFieldFive setSecureTextEntry:YES];
    pwdTextFieldFive.font= pwdTextFieldTextSize;
    pwdTextFieldFive.layer.borderWidth=pwdTextFieldBorderWidth;
    pwdTextFieldFive.backgroundColor = [UIColor whiteColor];
    pwdTextFieldFive.layer.borderColor = [UIColor whiteColor].CGColor;
    [pwdTextFieldFive setEnabled:NO];
    [pwdTextFieldBackgroundView addSubview:pwdTextFieldFive];
    
    pwdTextFieldSix = [[UITextField alloc] initWithFrame:CGRectMake(pwdTextFieldWidth * 5 + pwdTextFieldBorderWidth * 5, 0, pwdTextFieldWidth, pwdTextFieldHeight)];
    pwdTextFieldSix.textAlignment= NSTextAlignmentCenter;
    pwdTextFieldSix.textColor= pwdTextFieldTextColor;
    [pwdTextFieldSix setSecureTextEntry:YES];
    pwdTextFieldSix.font= pwdTextFieldTextSize;
    pwdTextFieldSix.layer.borderWidth=pwdTextFieldBorderWidth;
    pwdTextFieldSix.backgroundColor = [UIColor whiteColor];
    pwdTextFieldSix.layer.borderColor = [UIColor whiteColor].CGColor;
    [pwdTextFieldSix setEnabled:NO];
    pwdTextFieldSix.layer.cornerRadius = 5.f;
    [pwdTextFieldBackgroundView addSubview:pwdTextFieldSix];
    
    //  忘记密码
    UIButton *forgetPayPwdBtn = [[UIButton alloc] init];
    [forgetPayPwdBtn setTag:PAYPASS_BTN_FORGETPWD];
    [forgetPayPwdBtn setTitle:@"忘记密码？" forState: UIControlStateNormal];
    forgetPayPwdBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    [forgetPayPwdBtn setTitleColor:RGBA(34, 123, 207, 1.0) forState:UIControlStateNormal];
    [forgetPayPwdBtn addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
    [PayPwdView addSubview:forgetPayPwdBtn];
    
    CGSize forgetPayPwdBtnSize = [forgetPayPwdBtn.titleLabel.text sizeWithNSStringFont:forgetPayPwdBtn.titleLabel.font];
    CGFloat forgetPayPwdBtnWidth = forgetPayPwdBtnSize.width;
    CGFloat forgetPayPwdBtnOX = PayPwdViewWidth - forgetPayPwdBtnWidth - leftSpace *2;
    CGFloat forgetPayPwdBtnOY = pwdTextFieldOY + pwdTextFieldHeight + leftSpace;
    CGFloat forgetPayPwdBtnHeight = forgetPayPwdBtnSize.height;
    
    forgetPayPwdBtn.frame = CGRectMake(forgetPayPwdBtnOX, forgetPayPwdBtnOY, forgetPayPwdBtnWidth, forgetPayPwdBtnHeight);
    
    
    CGFloat payPwdViewHeight = titleLabelOY + forgetPayPwdBtnOY + forgetPayPwdBtnHeight;
    PayPwdView.frame = CGRectMake(PayPwdViewOX, PayPwdViewOY, PayPwdViewWidth, payPwdViewHeight);
    
    //刷新commViewHeight
    commViewHeight = leftSpace + payPwdViewHeight + keyBordViewHeight;
    //重置commView的frame信息
    commView.frame = CGRectMake(commViewOX, commViewOY, commViewWidth, commViewHeight);
}
#pragma mark - 卡账户(Accpass)密码控件
- (void)initAccpassWordView{
    
    commView = [[UIView alloc] init];
    commView.backgroundColor = [UIColor whiteColor];
    [self addSubview:commView];
    
    [viewArray addObject:commView];
    
    CGFloat commViewWidth = viewsize.width;
    
    commView.frame = CGRectMake(commViewOX, commViewOY, commViewWidth, commViewHeight);
    
    UIView *accpassview = [[UIView alloc] init];
    accpassview.backgroundColor=[UIColor whiteColor];
    [commView addSubview:accpassview];
    
    accpassview.frame = CGRectMake(0, 0, commViewWidth, commViewHeight);
    
    //  关闭
    UIButton *button = [[UIButton alloc] init];
    [button setTitle:@"关闭" forState: UIControlStateNormal];
    button.titleLabel.font = [UIFont systemFontOfSize:17];
    [button setTitleColor:ColorClosedBtn forState:UIControlStateNormal];
    [button addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
    [accpassview addSubview:button];
    
    NSInteger viewArrayCount = [viewArray count];
    if (viewArrayCount > 1){
        [button setTag:20000102];
        [button setTitle:@"<" forState: UIControlStateNormal];
    } else {
        [button setTag:TAG_BTN_CLOSED];
        [button setTitle:@"关闭" forState: UIControlStateNormal];
    }
    
    CGFloat buttonWidth = 50;
    CGFloat buttonOX = 0;
    CGFloat buttonOY = 0;
    CGFloat buttonHeight = 50;
    
    button.frame = CGRectMake(buttonOX, buttonOY, buttonWidth, buttonHeight);
    
    //  title
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.text = @"输入该卡密码";
    titleLabel.textColor = [UIColor blackColor];
    titleLabel.font = [UIFont systemFontOfSize:17];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    [accpassview addSubview:titleLabel];
    
    CGFloat titleLabelWidth = viewsize.width -buttonWidth*2;
    CGSize titleLabelSize = [titleLabel sizeThatFits:CGSizeMake(titleLabelWidth, MAXFLOAT)];
    CGFloat titleLabelOX = buttonWidth;
    CGFloat titleLabelOY = (buttonHeight - titleLabelSize.height) / 2;
    
    titleLabel.frame = CGRectMake(titleLabelOX, titleLabelOY, titleLabelWidth, titleLabelSize.height);
    
    //线
    CGFloat lineViewOX = 0;
    CGFloat lineViewOY = buttonOY + buttonHeight;
    CGFloat lineViewWidth = viewsize.width;
    CGFloat lineViewHeight = 1;
    
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(lineViewOX, lineViewOY, lineViewWidth, lineViewHeight)];
    [lineView setBackgroundColor:ColorHUI];
    [accpassview addSubview:lineView];
    
    
    //设置控件的位置和大小
    CGFloat leftRightSpace = 15;
    CGFloat space = 10.0;
    
    //密码提示:
    UILabel *accleftLab = [[UILabel alloc] init];
    accleftLab.textColor = [UIColor darkTextColor];
    accleftLab.text = @"密码:";
    CGSize accleftLabsize = [accleftLab.text sizeWithNSStringFont:[UIFont systemFontOfSize:15]];
    accleftLab.frame = CGRectMake(leftRightSpace, CGRectGetMaxY(lineView.frame)+2*space, accleftLabsize.width, accleftLabsize.height*2);
    [accpassview addSubview:accleftLab];
    
    
    //密码输入框
    accpwdTextfiled = [[UITextField alloc] init];
    accpwdTextfiled.placeholder  = @"请输入您的卡账户密码";
    accpwdTextfiled.font = [UIFont systemFontOfSize:14];
    accpwdTextfiled.textColor = [UIColor darkTextColor];
    accpwdTextfiled.layer.cornerRadius = 5.0f;
    accpwdTextfiled.textAlignment = NSTextAlignmentCenter;
    accpwdTextfiled.layer.borderColor = [UIColor lightGrayColor].CGColor;
    accpwdTextfiled.layer.masksToBounds = YES;
    accpwdTextfiled.layer.borderWidth = 1.0f;
    accpwdTextfiled.delegate = self;
    accpwdTextfiled.keyboardType = UIKeyboardTypeNumberPad;
    accpwdTextfiled.secureTextEntry = YES;
    accpwdTextfiled.userInteractionEnabled = NO;
    accpwdTextfiled.maxLenght = @"6";
    accpwdTextfiled.minLenght = @"1";
    
    //  忘记密码
    UIButton *forgetPayPwdBtn = [[UIButton alloc] init];
    [forgetPayPwdBtn setTag:ACCPASS_BTN_FORGETPWD];
    [forgetPayPwdBtn setTitle:@"忘记密码?" forState: UIControlStateNormal];
    forgetPayPwdBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    [forgetPayPwdBtn setTitleColor:RGBA(34, 123, 207, 1.0) forState:UIControlStateNormal];
    [forgetPayPwdBtn addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
    [accpassview addSubview:forgetPayPwdBtn];
    
    //添加键盘监听
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFiledEditChanged:) name:UITextFieldTextDidChangeNotification object:accpwdTextfiled];
    accpwdTextfiled.frame = CGRectMake(leftRightSpace+accleftLabsize.width+space, CGRectGetMaxY(lineView.frame)+2*space, viewsize.width*0.7f-2*leftRightSpace-accleftLabsize.width, accleftLabsize.height*2);
    [accpassview addSubview:accpwdTextfiled];
    
    CGFloat forgetPayPwdBtnX = CGRectGetMaxX(accpwdTextfiled.frame) + space;
    CGFloat forgetPayPwdBtnW = viewsize.width - forgetPayPwdBtnX - space/2;
    
    forgetPayPwdBtn.frame = CGRectMake(forgetPayPwdBtnX, CGRectGetMaxY(lineView.frame)+2*space, forgetPayPwdBtnW, accleftLabsize.height*2);
    
    //刷新commViewHeight
    commViewHeight = CGRectGetMaxY(accpwdTextfiled.frame)+2*space;
    //重置 commView  和 accpassview 的frame
    commView.frame = CGRectMake(commViewOX, commViewOY, commViewWidth, commViewHeight);
    accpassview.frame = CGRectMake(0, 0, commViewWidth, commViewHeight);
    
}

#pragma  - mark 支付(PayList)工具列表
- (void)initRechargeModeView
{
    commView = [[UIView alloc] init];
    commView.backgroundColor = [UIColor whiteColor];
    [self addSubview:commView];
    
    [viewArray addObject:commView];
    
    CGFloat commViewWidth = viewsize.width;
    
    commView.frame = CGRectMake(commViewOX, commViewOY, commViewWidth, commViewHeight);
    
    UIView *rechargeView=[[UIView alloc] init];
    rechargeView.backgroundColor=[UIColor whiteColor];
    [commView addSubview:rechargeView];
    
    rechargeView.frame = CGRectMake(0, 0, commViewWidth, commViewHeight);
    
    //  关闭
    UIButton *button = [[UIButton alloc] init];
    [button setTitle:@"关闭" forState: UIControlStateNormal];
    button.titleLabel.font = [UIFont systemFontOfSize:17];
    [button setTitleColor:ColorClosedBtn forState:UIControlStateNormal];
    [button addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
    [rechargeView addSubview:button];
    
    NSInteger viewArrayCount = [viewArray count];
    if (viewArrayCount > 1){
        [button setTag:20000102];
        [button setTitle:@"<" forState: UIControlStateNormal];
    } else {
        [button setTag:TAG_BTN_CLOSED];
        [button setTitle:@"关闭" forState: UIControlStateNormal];
    }
    
    CGFloat buttonWidth = 50;
    CGFloat buttonOX = 0;
    CGFloat buttonOY = 0;
    CGFloat buttonHeight = 50;
    
    button.frame = CGRectMake(buttonOX, buttonOY, buttonWidth, buttonHeight);
    
    //  title
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.text = _payListTitle.length > 0 ? _payListTitle : @"选择充值方式";
    titleLabel.textColor = [UIColor blackColor];
    titleLabel.font = [UIFont systemFontOfSize:17];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    [rechargeView addSubview:titleLabel];
    
    CGFloat titleLabelWidth = viewsize.width - buttonWidth*2;
    CGSize titleLabelSize = [titleLabel sizeThatFits:CGSizeMake(titleLabelWidth, MAXFLOAT)];
    CGFloat titleLabelOX = buttonWidth;
    CGFloat titleLabelOY = (buttonHeight - titleLabelSize.height) / 2;
    
    titleLabel.frame = CGRectMake(titleLabelOX, titleLabelOY, titleLabelWidth, titleLabelSize.height);
    
    //线
    CGFloat lineViewOX = 0;
    CGFloat lineViewOY = buttonOY + buttonHeight;
    CGFloat lineViewWidth = viewsize.width;
    CGFloat lineViewHeight = 1;
    
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(lineViewOX, lineViewOY, lineViewWidth, lineViewHeight)];
    [lineView setBackgroundColor:ColorHUI];
    [rechargeView addSubview:lineView];
    
    //创建UIScrollView
    UIScrollView *scrollView = [[UIScrollView alloc] init];
    scrollView.userInteractionEnabled = YES;
    scrollView.scrollEnabled = YES;
    scrollView.directionalLockEnabled = YES; //只能一个方向滑动
    scrollView.pagingEnabled = NO; //是否翻页
    scrollView.showsVerticalScrollIndicator =YES; //垂直方向的滚动指示
    scrollView.indicatorStyle = UIScrollViewIndicatorStyleWhite;//滚动指示的风格
    scrollView.showsHorizontalScrollIndicator = NO;//水平方向的滚动指示
    [scrollView setBackgroundColor:[UIColor whiteColor]];
    [rechargeView addSubview:scrollView];
    
    CGFloat scrollViewOX = 0;
    CGFloat scrollViewOY = lineViewOY + lineViewHeight;
    CGFloat scrollViewWidth = viewsize.width;
    CGFloat scrollViewHeight = commViewHeight - scrollViewOY;
    
    scrollView.frame = CGRectMake(scrollViewOX, scrollViewOY, scrollViewWidth, scrollViewHeight);
    
    CGFloat itemBtnHeight = 0;
    
    //1.  可用支付工具部分
    NSInteger payListArrayCount = [payListArray count];
    for (int i = 0; i < payListArrayCount; i++) {
        NSDictionary *dic = payListArray[i];
        CGFloat limitFloat = 0;
        CGFloat userBalanceFloat = 0;
        
        NSString *type = [dic objectForKey:@"type"];
        NSString *title = [dic objectForKey:@"title"];
        
        //获取limit
        if (![type isEqualToString:@"PAYLIST_BTN_ADDCARD"]) {
            limitFloat = [[PayNucHelper sharedInstance] limitInfo:[dic objectForKey:@"limit"]]/100;
            userBalanceFloat = [[[dic objectForKey:@"account"] objectForKey:@"useableBalance"] floatValue]/100;
        }
        //0.父控件btn
        UIButton *itemBtn = [[UIButton alloc] init];
        itemBtn.tag = PAYLIST_BTN_CELLCLICK + i;
        [itemBtn addTarget:self action:@selector(payListButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        [scrollView addSubview:itemBtn];
        
        //1.icon图标
        UIImage *iconImage;
        //固定size
        CGSize iconImageSize = [UIImage imageNamed:@"qvip_pay_imageholder"].size;
        UIImageView *iconImageView = [[UIImageView alloc] init];
        iconImageView.image = iconImage;
        iconImageView.contentMode = UIViewContentModeScaleAspectFit;
        //网络加载图片造成UI卡顿,
        NSString *imgURLStr = [[payListArray[i] objectForKey:@"img"] length]>0 ? [payListArray[i] objectForKey:@"img"]:@"qvip_pay_imageholder";
        imgURLStr = [Tool getIconImageName:type title:title imaUrl:imgURLStr];
        iconImageView.image = [UIImage imageNamed:imgURLStr];
        //[iconImageView sd_setImageWithURL:[NSURL URLWithString:imgURLStr] placeholderImage:[UIImage imageNamed:imgURLStr]];
        [itemBtn addSubview:iconImageView];
        
        //2. nameLab
        UILabel *bankNameLabel = [[UILabel alloc] init];
        NSString *accNo  = [[dic objectForKey:@"account"] objectForKey:@"accNo"];
        NSString *lastfournumber = accNo.length>=4?lastfournumber = [accNo substringFromIndex:accNo.length-4]:lastfournumber = @"暂无显示";
        bankNameLabel.text = [NSString stringWithFormat:@"%@(%@)",title,lastfournumber];
        bankNameLabel.textColor = [UIColor blackColor];
        bankNameLabel.font = [UIFont systemFontOfSize:15];
        [itemBtn addSubview:bankNameLabel];
        
        //3.limitLab
        UILabel *bankLimitLabel = [[UILabel alloc] init];
        bankLimitLabel.text = [Tool getbankLimitLabelText:type userblance:userBalanceFloat];
        bankLimitLabel.textColor = [UIColor lightGrayColor];
        bankLimitLabel.font = [UIFont systemFontOfSize:12];
        [itemBtn addSubview:bankLimitLabel];
        
        //4.状态img
        UIImage *stateImage = [UIImage imageNamed:@"payListSelectedState"];
        UIImageView *stateImageView = [[UIImageView alloc] init];
        if (i == payListSelectedIndex) {
            stateImageView.image = stateImage;
            stateImageView.contentMode = UIViewContentModeScaleAspectFit;
            [itemBtn addSubview:stateImageView];
        }
        
        
        
        //(setFrame)设置控件的位置和大小
        CGFloat leftRightSpace = 15;
        CGFloat upDownSpace = 10;
        CGFloat space = 10.0;
        CGFloat labelWidth = viewsize.width - 2 * leftRightSpace - iconImageSize.width - leftRightSpace - stateImage.size.width - 10;
        CGSize bankNameLabelSize = [bankNameLabel sizeThatFits:CGSizeMake(labelWidth, MAXFLOAT)];
        CGFloat bankNameLabelHeight = bankNameLabelSize.height;
        CGSize bankLimitLabelSize = [bankLimitLabel sizeThatFits:CGSizeMake(labelWidth, MAXFLOAT)];
        CGFloat bankLimitLabelHeight = bankLimitLabelSize.height;
        itemBtnHeight = bankNameLabelHeight + space + bankLimitLabelHeight + 2 * upDownSpace;
        NSLog(@"%f",itemBtnHeight);
        //iconImage
        CGFloat iconImageViewOX = leftRightSpace;
        CGFloat iconImageViewHeight = iconImageSize.height;
        CGFloat iconImageViewOY = (itemBtnHeight - iconImageViewHeight) / 2;
        CGFloat iconImageViewWidth = iconImageSize.width;
        iconImageView.frame = CGRectMake(iconImageViewOX, iconImageViewOY, iconImageViewWidth, iconImageViewHeight);
        
        //lable1
        CGFloat bankNameLabelOX = iconImageViewOX + iconImageViewWidth + leftRightSpace;
        CGFloat bankNameLabelOY = upDownSpace;
        CGFloat bankNameLabelWidth = labelWidth;
        bankNameLabel.frame = CGRectMake(bankNameLabelOX, bankNameLabelOY, bankNameLabelWidth, bankNameLabelHeight);
        
        //lable2
        CGFloat bankLimitLabelOX = iconImageViewOX + iconImageViewWidth + leftRightSpace;
        CGFloat bankLimitLabelOY = bankNameLabelOY + bankNameLabelHeight + space;
        CGFloat bankLimitLabelWidth = labelWidth;
        bankLimitLabel.frame = CGRectMake(bankLimitLabelOX, bankLimitLabelOY, bankLimitLabelWidth, bankLimitLabelHeight);
        
        //stateImage
        CGFloat stateImageViewOX = bankLimitLabelOX + bankLimitLabelWidth + leftRightSpace;
        CGFloat stateImageViewHeight = stateImage.size.height;
        CGFloat stateImageViewOY = (itemBtnHeight - stateImageViewHeight) / 2;
        CGFloat stateImageViewWidth = stateImage.size.width;
        stateImageView.frame = CGRectMake(stateImageViewOX, stateImageViewOY, stateImageViewWidth, stateImageViewHeight);
        
        //2.添加新卡部分
        if ([@"PAYLIST_BTN_ADDCARD" isEqualToString:type]) {
            itemBtn.tag = PAYLIST_BTN_ADDCARD;
            bankNameLabel.text = [NSString stringWithFormat:@"%@",title];
            [itemBtn setBackgroundImage:[UIImage imageWithColor:[UIColor whiteColor]] forState:UIControlStateNormal];
            [itemBtn setBackgroundImage:[UIImage imageWithColor:[UIColor whiteColor]] forState:UIControlStateHighlighted];
            
            CGFloat labelWidth = viewsize.width - 2 * leftRightSpace - stateImage.size.width - 10;
            
            CGSize bankNameLabelSize = [bankNameLabel sizeThatFits:CGSizeMake(labelWidth, MAXFLOAT)];
            CGFloat bankNameLabelHeight = bankNameLabelSize.height;
            
            CGFloat bankNameLabelOX = leftRightSpace + iconImageViewWidth + leftRightSpace;
            CGFloat bankNameLabelOY = (itemBtnHeight - bankNameLabelHeight) / 2;
            CGFloat bankNameLabelWidth = labelWidth - leftRightSpace;
            bankNameLabel.frame = CGRectMake(bankNameLabelOX, bankNameLabelOY, bankNameLabelWidth, bankNameLabelHeight);
            
            CGFloat stateImageViewOX = bankNameLabelOX + bankNameLabelWidth + leftRightSpace;
            CGFloat stateImageViewHeight = stateImage.size.height;
            CGFloat stateImageViewOY = (itemBtnHeight - stateImageViewHeight) / 2;
            CGFloat stateImageViewWidth = stateImage.size.width;
            stateImageView.frame = CGRectMake(stateImageViewOX, stateImageViewOY, stateImageViewWidth, stateImageViewHeight);
            
        } else {
            //3.不可用支付工具部分
            if ([[dic objectForKey:@"available"] boolValue] == NO|| [@"0" isEqualToString:[NSString stringWithFormat:@"%@",[[dic objectForKey:@"account"] objectForKey:@"useableBalance"]]]) {
                itemBtn.userInteractionEnabled = NO;
                
                if ([[dic objectForKey:@"available"] boolValue] == NO) {
                    bankLimitLabel.text = @"暂不支持当前交易";
                }else if([@"0" isEqualToString:[[dic objectForKey:@"account"] objectForKey:@"useableBalance"]]){
                    bankLimitLabel.text = [NSString stringWithFormat:@"可用余额%.2f元 (暂不支持当前交易)",userBalanceFloat];;
                }
                bankNameLabel.textColor = [UIColor lightGrayColor];
            } else {
                [itemBtn setBackgroundImage:[UIImage imageWithColor:[UIColor whiteColor]] forState:UIControlStateNormal];
                [itemBtn setBackgroundImage:[UIImage imageWithColor:[UIColor whiteColor]] forState:UIControlStateHighlighted];
            }
            
            
            
        }
        
        CGFloat itemBtnOX = 0;
        CGFloat itemBtnOY = i * (itemBtnHeight + lineViewHeight);
        CGFloat itemBtnWidth = viewsize.width;
        itemBtn.frame = CGRectMake(itemBtnOX, itemBtnOY, itemBtnWidth, itemBtnHeight);
        
        if (i != 0) {
            UIView *bankLineView = [[UIView alloc] initWithFrame:CGRectMake(lineViewOX, lineViewOY, lineViewWidth, lineViewHeight)];
            [bankLineView setBackgroundColor:ColorHUI];
            [scrollView addSubview:bankLineView];
            
            CGFloat bankLineViewOX = leftRightSpace;
            CGFloat bankLineViewOY = i * (itemBtnHeight + lineViewHeight);
            CGFloat bankLineViewWidth = viewsize.width - 2 * leftRightSpace;
            
            bankLineView.frame = CGRectMake(bankLineViewOX, bankLineViewOY, bankLineViewWidth, lineViewHeight);
        }
    }
    
    
    
    //实际总高度
    CGFloat realAllHeight = lineViewOY + (itemBtnHeight + lineViewHeight) * payListArrayCount;
    //重置滚动区间
    scrollView.contentSize = CGSizeMake(viewsize.width, (itemBtnHeight + lineViewHeight) * payListArrayCount);
    
    //刷新commViewHeight
    if (realAllHeight < commViewHeight) {
        commViewHeight = realAllHeight;
    }
    //重置commView的frame信息
    commView.frame = CGRectMake(commViewOX, commViewOY, commViewWidth, commViewHeight);
    rechargeView.frame = CGRectMake(0, 0, commViewWidth, commViewHeight);
    scrollViewHeight = commViewHeight - scrollViewOY;
    scrollView.frame = CGRectMake(scrollViewOX, scrollViewOY, scrollViewWidth, scrollViewHeight);
}


#pragma  - mark 付款详情控件(暂未使用)
- (void)initPayDetailsView
{
    commView = [[UIView alloc] init];
    commView.backgroundColor = [UIColor whiteColor];
    [self addSubview:commView];
    
    [viewArray addObject:commView];
    
    CGFloat commViewWidth = viewsize.width;
    
    commView.frame = CGRectMake(commViewOX, commViewOY, commViewWidth, commViewHeight);
    
    UIView *payDetailView=[[UIView alloc] init];
    payDetailView.backgroundColor=[UIColor whiteColor];
    [commView addSubview:payDetailView];
    
    payDetailView.frame = CGRectMake(0, 0, commViewWidth, commViewHeight);
    
    //  关闭
    UIButton *button = [[UIButton alloc] init];
    [button setTag:TAG_BTN_CLOSED];
    [button setTitle:@"关闭" forState: UIControlStateNormal];
    button.titleLabel.font = [UIFont systemFontOfSize:17];
    [button setTitleColor:ColorClosedBtn forState:UIControlStateNormal];
    [button addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
    [payDetailView addSubview:button];
    
    CGFloat buttonWidth = 50;
    CGFloat buttonOX = 0;
    CGFloat buttonOY = 0;
    CGFloat buttonHeight = 50;
    
    button.frame = CGRectMake(buttonOX, buttonOY, buttonWidth, buttonHeight);
    
    //  帮助
    UIButton *helpBtn = [[UIButton alloc] init];
    [helpBtn setTag:PAYDETAIL_BTN_HELP];
    [helpBtn setTitle:@"?" forState: UIControlStateNormal];
    helpBtn.titleLabel.font = [UIFont systemFontOfSize:17];
    [helpBtn setTitleColor:ColorHUI forState:UIControlStateNormal];
    [helpBtn addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
    [payDetailView addSubview:helpBtn];
    
    CGFloat helpBtnWidth = 50;
    CGFloat helpBtnOX = viewsize.width - helpBtnWidth;
    CGFloat helpBtnOY = 0;
    CGFloat helpBtnHeight = 50;
    
    helpBtn.frame = CGRectMake(helpBtnOX, helpBtnOY, helpBtnWidth, helpBtnHeight);
    
    //  title
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.text = @"付款详情";
    titleLabel.textColor = [UIColor blackColor];
    titleLabel.font = [UIFont systemFontOfSize:17];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    [payDetailView addSubview:titleLabel];
    
    CGFloat titleLabelWidth = viewsize.width -buttonWidth*2;
    CGSize titleLabelSize = [titleLabel sizeThatFits:CGSizeMake(titleLabelWidth, MAXFLOAT)];
    CGFloat titleLabelOX = buttonWidth;
    CGFloat titleLabelOY = (buttonHeight - titleLabelSize.height) / 2;
    
    titleLabel.frame = CGRectMake(titleLabelOX, titleLabelOY, titleLabelWidth, titleLabelSize.height);
    
    //线
    CGFloat lineViewOX = 0;
    CGFloat lineViewOY = buttonOY + buttonHeight;
    CGFloat lineViewWidth = viewsize.width;
    CGFloat lineViewHeight = 1;
    
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(lineViewOX, lineViewOY, lineViewWidth, lineViewHeight)];
    [lineView setBackgroundColor:ColorHUI];
    [payDetailView addSubview:lineView];
    
    //创建UIScrollView
    UIScrollView *scrollView = [[UIScrollView alloc] init];
    scrollView.userInteractionEnabled = YES;
    scrollView.scrollEnabled = YES;
    scrollView.directionalLockEnabled = YES; //只能一个方向滑动
    scrollView.pagingEnabled = NO; //是否翻页
    scrollView.showsVerticalScrollIndicator =YES; //垂直方向的滚动指示
    scrollView.indicatorStyle = UIScrollViewIndicatorStyleWhite;//滚动指示的风格
    scrollView.showsHorizontalScrollIndicator = NO;//水平方向的滚动指示
    [scrollView setBackgroundColor:[UIColor whiteColor]];
    [payDetailView addSubview:scrollView];
    
    CGFloat scrollViewOX = 0;
    CGFloat scrollViewOY = lineViewOY + lineViewHeight;
    CGFloat scrollViewWidth = viewsize.width;
    CGFloat scrollViewHeight = commViewHeight - scrollViewOY;
    
    scrollView.frame = CGRectMake(scrollViewOX, scrollViewOY, scrollViewWidth, scrollViewHeight);
    
    //订单
    UIView *orderView = [[UIView alloc] init];
    orderView.backgroundColor = [UIColor clearColor];
    [scrollView addSubview:orderView];
    
    UILabel *orderTitleLabel = [[UILabel alloc] init];
    orderTitleLabel.text = @"订单信息";
    orderTitleLabel.textColor = titleColor;
    orderTitleLabel.font = [UIFont systemFontOfSize:15];
    [orderView addSubview:orderTitleLabel];
    
    UILabel *orderLabel = [[UILabel alloc] init];
    orderLabel.text = [payDetailsDic objectForKey:@"digest"];
    orderLabel.textColor = textFiledColor;
    orderLabel.font = [UIFont systemFontOfSize:15];
    [orderView addSubview:orderLabel];
    
    UIView *orderLineView = [[UIView alloc] init];
    orderLineView.backgroundColor = ColorHUI;
    [scrollView addSubview:orderLineView];
    
    //付款方式
    UIView *payModeView = [[UIView alloc] init];
    payModeView.backgroundColor = [UIColor clearColor];
    [scrollView addSubview:payModeView];
    
    UILabel *payModeTitleLabel = [[UILabel alloc] init];
    payModeTitleLabel.text = @"付款方式";
    payModeTitleLabel.textColor = titleColor;
    payModeTitleLabel.font = [UIFont systemFontOfSize:15];
    [payModeView addSubview:payModeTitleLabel];
    
    UIButton *payModeBtn = [[UIButton alloc] init];
    payModeBtn.tag = PAYDETAIL_BTN_PAYMODE;
    [payModeBtn addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
    [payModeView addSubview:payModeBtn];
    
    payModeLabel = [[UILabel alloc] init];
    payModeLabel.text = @"交通银行信用卡（5157）";
    payModeLabel.textColor = textFiledColor;
    payModeLabel.textAlignment = NSTextAlignmentRight;
    payModeLabel.font = [UIFont systemFontOfSize:15];
    [payModeBtn addSubview:payModeLabel];
    
    UIImage *arrowImage = [UIImage imageNamed:@"list_forward.png"];
    UIImageView *arrowImageView = [[UIImageView alloc] init];
    arrowImageView.image = arrowImage;
    arrowImageView.contentMode = UIViewContentModeScaleAspectFit;
    [payModeBtn addSubview:arrowImageView];
    
    UIView *payModeLineView = [[UIView alloc] init];
    payModeLineView.backgroundColor = ColorHUI;
    [scrollView addSubview:payModeLineView];
    
    //付款金额
    UIView *payMoneyView = [[UIView alloc] init];
    payMoneyView.backgroundColor = [UIColor clearColor];
    [scrollView addSubview:payMoneyView];
    
    UILabel *payMoneyTitleLabel = [[UILabel alloc] init];
    payMoneyTitleLabel.text = @"需付款";
    payMoneyTitleLabel.textColor = textFiledColor;
    payMoneyTitleLabel.font = [UIFont systemFontOfSize:15];
    [payModeLineView addSubview:payMoneyTitleLabel];
    
    UILabel *payMoneyLabel = [[UILabel alloc] init];
    payMoneyLabel.text =[NSString stringWithFormat:@"%@元", [NSString formatMoney:[payDetailsDic objectForKey:@"amount"]]];
    payMoneyLabel.textColor = textFiledColor;
    payMoneyLabel.textAlignment = NSTextAlignmentRight;
    payMoneyLabel.font = [UIFont systemFontOfSize:20];
    [payModeLineView addSubview:payMoneyLabel];
    
    //  付款按钮
    UIButton *payBtn = [[UIButton alloc] init];
    [payBtn setTag:PAYDETAIL_BTN_PAY];
    [payBtn setTitle:@"付款" forState: UIControlStateNormal];
    payBtn.titleLabel.font = [UIFont systemFontOfSize:17];
    [payBtn setBackgroundImage:[UIImage imageWithColor:[UIColor blueColor]] forState:UIControlStateNormal];
    [payBtn.layer setMasksToBounds:YES];
    payBtn.layer.cornerRadius = 5.0;
    [payBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [payBtn addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
    [payDetailView addSubview:payBtn];
    
    
    
    //设置控件的位置和大小
    CGFloat leftRightSpace = 15;
    CGFloat upDownSpace = 15;
    CGFloat commLineViewHeight = 1;
    CGFloat commLineViewWidth = viewsize.width - 2 * leftRightSpace;
    
    CGSize orderTitleLabelSize = [orderTitleLabel.text sizeWithNSStringFont:orderTitleLabel.font];
    CGFloat orderLabelWidth = viewsize.width - 2 * leftRightSpace - orderTitleLabelSize.width - leftRightSpace;
    CGSize orderLabelSize = [orderLabel sizeThatFits:CGSizeMake(orderLabelWidth, MAXFLOAT)];
    
    CGFloat commPayDetailsViewHeight = orderTitleLabelSize.height + upDownSpace * 2;
    
    CGSize payModeTitleLabelSize = [payModeTitleLabel.text sizeWithNSStringFont:payModeTitleLabel.font];
    CGFloat payModeBtnWidth = viewsize.width - 2 * leftRightSpace - payModeTitleLabelSize.width -  leftRightSpace;
    CGFloat payModeLabelWidth = payModeBtnWidth - arrowImage.size.width - leftRightSpace;
    CGSize payModeLabelSize = [payModeLabel sizeThatFits:CGSizeMake(payModeLabelWidth, MAXFLOAT)];
    CGFloat payModeBtnHeight = commPayDetailsViewHeight;
    
    CGSize payMoneyTitleLabelSize = [payMoneyTitleLabel.text sizeWithNSStringFont:payMoneyTitleLabel.font];
    CGFloat payMoneyLabelWidth = viewsize.width - 2 * leftRightSpace - payMoneyTitleLabelSize.width - leftRightSpace;
    CGSize payMoneyLabelSize = [payMoneyLabel sizeThatFits:CGSizeMake(payMoneyLabelWidth, MAXFLOAT)];
    
    CGFloat payBtnWidth = viewsize.width - 2 * leftRightSpace;
    CGSize payBtnSize = [payBtn.titleLabel sizeThatFits:CGSizeMake(payBtnWidth, MAXFLOAT)];
    CGFloat payBtnHeight = payBtnSize.height + 2 * upDownSpace;
    
    CGFloat orderTitleLabelOX = leftRightSpace;
    CGFloat orderTitleLabelOY = upDownSpace;
    CGFloat orderTitleLabelWidth = orderTitleLabelSize.width;
    CGFloat orderTitleLabelHeight = orderTitleLabelSize.height;
    
    orderTitleLabel.frame = CGRectMake(orderTitleLabelOX, orderTitleLabelOY, orderTitleLabelWidth, orderTitleLabelHeight);
    
    CGFloat orderLabelOX = orderTitleLabelOX + orderTitleLabelWidth + leftRightSpace;
    CGFloat orderLabelOY = upDownSpace;
    CGFloat orderLabelHeight = orderLabelSize.height;
    
    orderLabel.frame = CGRectMake(orderLabelOX, orderLabelOY, orderLabelWidth, orderLabelHeight);
    
    CGFloat orderViewOX = 0;
    CGFloat orderViewOY = 0;
    CGFloat orderViewWidth = viewsize.width;
    
    orderView.frame = CGRectMake(orderViewOX, orderViewOY, orderViewWidth, commPayDetailsViewHeight);
    
    CGFloat orderLineViewOX = leftRightSpace;
    CGFloat orderLineViewOY = orderViewOY + commPayDetailsViewHeight;
    
    orderLineView.frame = CGRectMake(orderLineViewOX, orderLineViewOY, commLineViewWidth, commLineViewHeight);
    
    CGFloat payModeTitleLabelOX = leftRightSpace;
    CGFloat payModeTitleLabelOY = upDownSpace;
    CGFloat payModeTitleLabelWidth = payModeTitleLabelSize.width;
    CGFloat payModeTitleLabelHeight = payModeTitleLabelSize.height;
    
    payModeTitleLabel.frame = CGRectMake(payModeTitleLabelOX, payModeTitleLabelOY, payModeTitleLabelWidth, payModeTitleLabelHeight);
    
    CGFloat payModeBtnOX = payModeTitleLabelOX + payModeTitleLabelWidth + leftRightSpace;
    CGFloat payModeBtnOY = 0;
    
    payModeBtn.frame = CGRectMake(payModeBtnOX, payModeBtnOY, payModeBtnWidth, payModeBtnHeight);
    
    CGFloat payModeLabelOX = 0;
    CGFloat payModeLabelOY = upDownSpace;
    CGFloat payModeLabelHeight = payModeLabelSize.height;
    
    payModeLabel.frame = CGRectMake(payModeLabelOX, payModeLabelOY, payModeLabelWidth, payModeLabelHeight);
    
    CGFloat arrowImageViewOX = payModeLabelOX + payModeLabelWidth + leftRightSpace;
    CGFloat arrowImageViewHeight = arrowImage.size.height;
    CGFloat arrowImageViewOY = (commPayDetailsViewHeight - arrowImageViewHeight) / 2;
    CGFloat arrowImageViewWidth = arrowImage.size.width;
    
    arrowImageView.frame = CGRectMake(arrowImageViewOX, arrowImageViewOY, arrowImageViewWidth, arrowImageViewHeight);
    
    CGFloat payModeViewOX = 0;
    CGFloat payModeViewOY = orderLineViewOY + commLineViewHeight;
    CGFloat payModeViewWidth = viewsize.width;
    
    payModeView.frame = CGRectMake(payModeViewOX, payModeViewOY, payModeViewWidth, commPayDetailsViewHeight);
    
    CGFloat payModeLineViewOX = leftRightSpace;
    CGFloat payModeLineViewOY = payModeViewOY + commPayDetailsViewHeight;
    
    payModeLineView.frame = CGRectMake(payModeLineViewOX, payModeLineViewOY, commLineViewWidth, commLineViewHeight);
    
    CGFloat payMoneyTitleLabelOX = 0;
    CGFloat payMoneyTitleLabelOY = upDownSpace;
    CGFloat payMoneyTitleLabelWidth = payMoneyTitleLabelSize.width;
    CGFloat payMoneyTitleLabelHeight = payMoneyTitleLabelSize.height;
    
    payMoneyTitleLabel.frame = CGRectMake(payMoneyTitleLabelOX, payMoneyTitleLabelOY, payMoneyTitleLabelWidth, payMoneyTitleLabelHeight);
    
    CGFloat payMoneyLabelOX = payMoneyTitleLabelOX + payMoneyTitleLabelWidth + leftRightSpace;
    CGFloat payMoneyLabelHeight = payMoneyLabelSize.height;
    CGFloat payMoneyLabelOY = (commPayDetailsViewHeight - payMoneyLabelHeight) / 2;
    
    payMoneyLabel.frame = CGRectMake(payMoneyLabelOX, payMoneyLabelOY, payMoneyLabelWidth, payMoneyLabelHeight);
    
    CGFloat payMoneyViewOX = 0;
    CGFloat payMoneyViewOY = payModeLineViewOY + commLineViewHeight;
    CGFloat payMoneyViewWidth = viewsize.width;
    
    payMoneyView.frame = CGRectMake(payMoneyViewOX, payMoneyViewOY, payMoneyViewWidth, commPayDetailsViewHeight);
    
    CGFloat payBtnOX = leftRightSpace;
    CGFloat payBtnOY = commViewHeight - payBtnHeight - 2 * 10;
    
    payBtn.frame = CGRectMake(payBtnOX, payBtnOY, payBtnWidth, payBtnHeight);
}



#pragma - mark =============控件弹出动画集===============

#pragma - mark 弹出paypass密码框及键盘
-(void)startPayPassword
{
    //弹出密码框-位于底部
    [self viewTransitionAnimation:commView rect:CGRectMake(0, viewsize.height - commViewHeight ,viewsize.width, commViewHeight)];
    //弹出加密键盘
    [self startKeyboard];
    
}
#pragma - mark 弹出accpass密码框及键盘
-(void)startAccPassword
{
    //弹出密码框-位于顶部
    [self viewTransitionAnimation:commView rect:CGRectMake(0, 0,viewsize.width, commViewHeight)];
    //弹出加密键盘
    [self startKeyboard];
}

#pragma - mark 弹出支付工具列表/支付详情页
-(void)start
{
    //弹出支付工具列表/支付详情页
    [self viewTransitionAnimation:commView rect:CGRectMake(0, viewsize.height - commViewHeight ,viewsize.width, commViewHeight)];
}

#pragma - mark 弹出加密键盘
-(void)startKeyboard
{
    pwdTextFieldOne.text = @"";
    pwdTextFieldTwo.text = @"";
    pwdTextFieldThree.text = @"";
    pwdTextFieldFour.text = @"";
    pwdTextFieldFive.text = @"";
    pwdTextFieldSix.text = @"";
    payPwd = @"";
    
    [keyBordView removeFromSuperview];
    
    keyBordView=[[UIView alloc] initWithFrame:CGRectMake(0, viewsize.height, viewsize.width,keyBordViewHeight)];
    keyBordView.backgroundColor=[UIColor whiteColor];
    [self addSubview:keyBordView];
    [self addKeyBoardBtn];
    
    [self viewTransitionAnimation:keyBordView rect:CGRectMake(0,viewsize.height-keyBordViewHeight,viewsize.width,keyBordViewHeight)];
    
}
#pragma - mark  隐藏所有控件(支付工具列表&键盘)
-(void)hiddenPayViewAll
{
    
    CGRect commviewRect;
    //1.支付(paypass)密码控件
    if (self.payViewStyle == PayViewStylePaypass) {
        commviewRect = CGRectMake(0, viewsize.height, viewsize.width, commViewHeight);
    }
    //2.卡账户(Accpass)密码控件
    if (self.payViewStyle == PayViewStyleAccpass) {
        commviewRect = CGRectMake(0, -commViewHeight, viewsize.width, commViewHeight);
    }
    //3.支付工具列表
    if (self.payViewStyle == PayViewStylePayList) {
        commviewRect = CGRectMake(0, viewsize.height, viewsize.width, commViewHeight);
    }
    //4.付款详情控件(暂未使用)
    if (self.payViewStyle == PayViewStylePayDetails) {
        commviewRect = CGRectMake(0, viewsize.height, viewsize.width, commViewHeight);
    }
    
    
    //commview 隐藏动画
    [self viewTransitionAnimation:commView rect:commviewRect];
    
    
    //自定义键盘 隐藏动画
    CGRect keyBordViewRect = CGRectMake(0, viewsize.height, viewsize.width, keyBordViewHeight);
    [self viewTransitionAnimation:keyBordView rect:keyBordViewRect];
    
    
    NSInteger viewArrayCount = [viewArray count];
    if (viewArrayCount == 1) {
        //背景隐藏动画
        [self viewMaskViewAnimtion:backGroundView runFlag:runFlag];
    } else {
        UIView *view = viewArray[viewArrayCount - 1];
        [view removeFromSuperview];
        [viewArray removeObjectAtIndex:viewArrayCount - 1];
    }
    
    
}




/**
 公共动画方法
 仅提供view的fram动画变换
 @param view 动画对象
 @param rect 动画frame信息
 */
- (void)viewTransitionAnimation:(UIView*)view rect:(CGRect)rect{
    
    [UIView animateWithDuration:animationDuration animations:^{
        [view setFrame:rect];
    } completion:^(BOOL finished) {
        
    }];
}

/**
 灰度半透明背景动画
 
 @param backgroundMaskView 背景maskview
 @param runFlag 标识
 */
- (void)viewMaskViewAnimtion:(UIView*)backgroundMaskView runFlag:(BOOL)runflag{
    
    if (!runflag) {
        [UIView animateWithDuration:animationDuration animations:^{
            backgroundMaskView.alpha=0.5f;
        } completion:^(BOOL finished) {
            runFlag = YES;
            gestureRecognzier = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hiddenPayview:)];
            [backgroundMaskView addGestureRecognizer:gestureRecognzier];
        }];
    }else{
        [UIView animateWithDuration:animationDuration animations:^{
            backgroundMaskView.alpha=0;
            [viewArray removeAllObjects]; //(此数组用于扩展支付控件时记录commview用, 暂时数组内容仅有一个commview,且需要立即执行,故执行删除时放置于此)
        } completion:^(BOOL finished) {
            //删除所有子视图
            [self.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
            //隐藏
            self.hidden = YES;
            runFlag = NO;
            [backgroundMaskView removeGestureRecognizer:gestureRecognzier];
        }];
    }
    
    
}

/**
 灰度遮罩View手势
 
 @param gesture 手势
 */
- (void)hiddenPayview:(UIGestureRecognizer*)gesture{
    [self hiddenPayViewAll];
}


 #pragma - mark  仅仅隐藏密码键盘
 -(void)hiddenKeyBordView
 {
     [self viewTransitionAnimation:keyBordView rect:CGRectMake(0, viewsize.height, viewsize.width, keyBordViewHeight)];
     
 }

 



#pragma - mark =============事件监听及代理回调===============

#pragma  - mark 支付列表cell监听 并 -----执行代理-----
- (void)payListButtonAction:(id)sender
{
    UIButton *btn = (UIButton *)sender;
    //添加新卡付款
    if (btn.tag == PAYLIST_BTN_ADDCARD) {
        payListSelectedIndex = 0;
        [self.delegate btnAction:PAYLIST_BTN_ADDCARD];
    }
    //支付列表付款
    else{
        payListSelectedIndex = btn.tag - PAYLIST_BTN_CELLCLICK;
        
        defaultPay = payListArray[payListSelectedIndex];
        
        [self hiddenPayViewAll];
        
        if (viewArray.count > 0) {
            payModeLabel.text = [defaultPay objectForKey:@"title"];
        } else {
            [self.delegate defaultPay:defaultPay];
        }
    }
    
}
#pragma  - mark 按钮监听事件 并 -----执行代理-----
- (void)buttonAction:(id)sender
{
    UIButton *btn = (UIButton *)sender;
    NSInteger tag = btn.tag;
    switch (tag) {
            //关闭(共用)
        case TAG_BTN_CLOSED:
        {
            
            [self hiddenPayViewAll];
        }
            break;
            //忘记密码按钮
        case PAYPASS_BTN_FORGETPWD:
        {
            
            [self.delegate btnAction:PAYPASS_BTN_FORGETPWD];
            [self hiddenPayViewAll];
        }
            break;
            //忘记密码按钮
        case ACCPASS_BTN_FORGETPWD:
        {
            
            [self.delegate btnAction:ACCPASS_BTN_FORGETPWD];
            [self hiddenPayViewAll];
        }
            break;
            //付款方式
        case PAYDETAIL_BTN_PAYMODE:
        {
            //付款方式按钮
            [self.delegate btnAction:PAYDETAIL_BTN_PAYMODE];
        }
            break;
            //付款
        case PAYDETAIL_BTN_PAY:
        {
            //付款按钮
            [self.delegate btnAction:PAYDETAIL_BTN_PAY];
        }
            break;
            //付款帮助
        case PAYDETAIL_BTN_HELP:
        {
            [self.delegate btnAction:PAYDETAIL_BTN_HELP];
        }
            break;
            
        default:
            break;
    }
}


#pragma  - mark ===========================自定义键盘事件处理=====================
#pragma - mark 键盘输入6位密码事件
-(void)KeyBoradClass:(UIButton *)btn
{
    //paypass支付密码处理
    if (self.payViewStyle == PayViewStylePaypass) {
        if (pwdTextFieldOne.text.length<1) {
            
            if (pwdTextFieldOne.text.length==0) {
                pwdTextFieldOne.text=[tempArray objectAtIndex:btn.tag];
            }
            
        }
        else if (pwdTextFieldTwo.text.length<1 && pwdTextFieldOne.text.length==1) {
            
            if (pwdTextFieldTwo.text.length==0) {
                pwdTextFieldTwo.text=[tempArray objectAtIndex:btn.tag];
            }
            
        }
        else if (pwdTextFieldThree.text.length<1 && pwdTextFieldTwo.text.length==1) {
            
            if (pwdTextFieldThree.text.length==0) {
                pwdTextFieldThree.text=[tempArray objectAtIndex:btn.tag];
            }
            
        }
        else if (pwdTextFieldFour.text.length<1 && pwdTextFieldThree.text.length==1) {
            
            if (pwdTextFieldFour.text.length==0) {
                pwdTextFieldFour.text=[tempArray objectAtIndex:btn.tag];
            }
            
        }
        else if (pwdTextFieldFive.text.length<1 && pwdTextFieldFour.text.length==1) {
            
            if (pwdTextFieldFive.text.length==0) {
                pwdTextFieldFive.text=[tempArray objectAtIndex:btn.tag];
            }
            
        }
        
        else if (pwdTextFieldSix.text.length<1 && pwdTextFieldFive.text.length==1) {
            
            if (pwdTextFieldSix.text.length==0) {
                pwdTextFieldSix.text=[tempArray objectAtIndex:btn.tag];
            }
            
        }
        //密码输入己有6位
        payPwd = [NSString stringWithFormat:@"%@%@%@%@%@%@",pwdTextFieldOne.text,pwdTextFieldTwo.text,pwdTextFieldThree.text,pwdTextFieldFour.text,pwdTextFieldFive.text,pwdTextFieldSix.text];
        if(payPwd.length==6){
            [self.delegate payPwd:payPwd];
            [self hiddenPayViewAll];
            /*
            [self hiddenKeyBordView];
            //弹出转圈动画view
            //block回调执行 [self hiddenPayViewAll];
             */
        }
    }
    
    //accpass卡密码处理
    if (self.payViewStyle == PayViewStyleAccpass) {
        NSString *tempPwd = btn.currentTitle;
        accpwdTextfiled.text = [accpwdTextfiled.text stringByAppendingString:tempPwd];
        
        if(accpwdTextfiled.text.length==6){
            [self.delegate payPwd:accpwdTextfiled.text];
            [self hiddenPayViewAll];
        }
    }
    
    
}


#pragma - mark 键盘←按钮退格事件
-(void)KeyBoradRemove:(UIButton *)btn
{
    
    if (self.payViewStyle == PayViewStylePaypass) {
        if(payPwd.length==0)
        {
            pwdTextFieldOne.text=@"";
            pwdTextFieldTwo.text=@"";
            pwdTextFieldThree.text=@"";
            pwdTextFieldFour.text=@"";
            pwdTextFieldFive.text=@"";
            pwdTextFieldSix.text=@"";
            return;
        }
        
        
        NSString *str=[payPwd substringToIndex:payPwd.length-1];
        
        if(str.length==6)
        {
            
        }
        else if (str.length==5)
        {
            pwdTextFieldSix.text=@"";
            
        }
        else if(str.length==4)
        {
            pwdTextFieldFive.text=@"";
            pwdTextFieldSix.text=@"";
            
        }
        else if (str.length==3)
        {
            pwdTextFieldFour.text=@"";
            pwdTextFieldFive.text=@"";
            pwdTextFieldSix.text=@"";
        }
        else if(str.length==2)
        {
            pwdTextFieldThree.text=@"";
            pwdTextFieldFour.text=@"";
            pwdTextFieldFive.text=@"";
            pwdTextFieldSix.text=@"";
            
        }
        else if(str.length==1)
        {
            pwdTextFieldTwo.text=@"";
            pwdTextFieldThree.text=@"";
            pwdTextFieldFour.text=@"";
            pwdTextFieldFive.text=@"";
            pwdTextFieldSix.text=@"";
        }
        else
        {
            pwdTextFieldOne.text=@"";
            pwdTextFieldTwo.text=@"";
            pwdTextFieldThree.text=@"";
            pwdTextFieldFour.text=@"";
            pwdTextFieldFive.text=@"";
            pwdTextFieldSix.text=@"";
            
        }
        
        payPwd = str;
        
    }
    
    if (self.payViewStyle == PayViewStyleAccpass) {
        accpwdTextfiled.text = @"";
    }
    
    
    
    
}

#pragma - mark 键盘清空按钮事件
-(void)KeyBoradClear:(UIButton *)btn{
    
    if (self.payViewStyle == PayViewStylePaypass) {
        pwdTextFieldOne.text=@"";
        pwdTextFieldTwo.text=@"";
        pwdTextFieldThree.text=@"";
        pwdTextFieldFour.text=@"";
        pwdTextFieldFive.text=@"";
        pwdTextFieldSix.text=@"";
    }
    if (self.payViewStyle == PayViewStyleAccpass) {
        accpwdTextfiled.text = @"";
    }
    
    
    
}
#pragma - mark  打乱顺序
- (NSMutableArray *)derangementArray
{
    NSArray * ary =[[NSArray alloc] initWithObjects:@"1",@"2",@"3",@"4",@"5",@"6",@"7",@"8",@"9",@"0", nil];
    
    ary = [ary sortedArrayUsingComparator:^NSComparisonResult(NSString *str1, NSString *str2){
        int seed = arc4random_uniform(2);
        
        if (seed) {
            return [str1 compare:str2];
        } else {
            return [str2 compare:str1];
        }
    }];
    NSMutableArray *newArray = [NSMutableArray arrayWithArray:ary];
    [newArray addObject:@"清除"];
    [newArray addObject:@"←"];
    
    return newArray;
}

#pragma - mark 添加键盘按钮
- (void)addKeyBoardBtn
{
    tempArray = [self derangementArray];
    
    for(int i=0;i<tempArray.count;i++)
    {
        NSInteger index = i%3;
        NSInteger page = i/3;
        
        UIButton * btn =[UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake(index * (viewsize.width/3), page  * keyBordCellHeight-keyBordCellBoardLine, viewsize.width/3,keyBordCellHeight);
        btn.tag=i;
        [btn setTitle:[tempArray objectAtIndex:i] forState:normal];
        [btn setTitleColor:[UIColor blackColor] forState:normal];
        if ([btn.currentTitle isEqualToString:@"清除"]) {
            btn.titleLabel.font = [UIFont systemFontOfSize:18.f];
        }else{
            NSMutableAttributedString *titleNomal = [[NSMutableAttributedString alloc] initWithString:[tempArray objectAtIndex:i]];
            NSMutableAttributedString *titleHeighted = [[NSMutableAttributedString alloc]initWithString:[tempArray objectAtIndex:i]];
            [titleNomal addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:27.f] range:NSMakeRange(0, titleNomal.length)];
            [titleHeighted addAttributes:@{
                                           NSFontAttributeName:[UIFont systemFontOfSize:38.f],
                                           } range:NSMakeRange(0, titleHeighted.length)];
            [btn setAttributedTitle:titleNomal forState:UIControlStateNormal];
            [btn setAttributedTitle:titleHeighted forState:UIControlStateHighlighted];
        }
        btn.layer.borderColor=[titleColor CGColor];
        btn.layer.borderWidth=keyBordCellBoardLine;
        
        if (i == 9 || i == 11) {
            btn.backgroundColor = RGBA(195, 199, 207, 0.8f);
        }
        
        if(i<=9)
        {
            
            [btn addTarget:self action:@selector(KeyBoradClass:) forControlEvents:UIControlEventTouchUpInside];
        }
        if(i==10)
        {
            [btn addTarget:self action:@selector(KeyBoradClear:) forControlEvents:UIControlEventTouchUpInside];
            
        }
        if(i==11)
        {
            [btn addTarget:self action:@selector(KeyBoradRemove:) forControlEvents:UIControlEventTouchUpInside];
            
        }
        
        [keyBordView addSubview:btn];
    }
}


#pragma - mark textfileDelegate
- (void)textFiledEditChanged:(NSNotification *)obj
{
    UITextField *textField = (UITextField *)obj.object;
    NSString *content = textField.text;
    
    int maxLenght = [textField.maxLenght intValue];
    NSInteger lenght = content.length;
    
    if (content.length == 6) {
        if ([_delegate respondsToSelector:@selector(payPwd:)]) {
            [_delegate payPwd:content];
        }
    }
    
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
    }
    
    
}



#pragma - mark  ==============================工具方法集==============================

@end
