//
//  CashRechargeViewController.m
//  sandbao
//
//  Created by tianNanYiHao on 2017/3/9.
//  Copyright © 2017年 sand. All rights reserved.
//

#import "CashRechargeViewController.h"


#import "GroupView.h"

#import "SDLog.h"
#import "RechargeResultViewController.h"
#import "PayNucHelper.h"
#import "BindingBankViewController.h"
#import "VerificationModeViewController.h"
#import "SandPwdViewController.h"


#define navbarColor RGBA(255, 255, 255, 1.0)

#define navViewColor RGBA(249, 249, 249, 1.0)

#define lineViewColor RGBA(237, 237, 237, 1.0)

#define titleColor RGBA(174, 174, 174, 1.0)

#define textFiledColor RGBA(83, 83, 83, 1.0)

#define btnColor RGBA(255, 97, 51, 1.0)

#define viewColor RGBA(255, 255, 255, 1.0)

typedef void(^CashRechargeStateBlock)(NSArray *paramArr);
@interface CashRechargeViewController ()<UITextFieldDelegate>
{
    NavCoverView *navCoverView;
    NSMutableArray *payToolsArrayUsableM;  //可用支付工具
    NSMutableArray *payToolsArrayUnusableM; //不可用支付工具
}

@property (nonatomic, assign) CGSize viewSize;
@property (nonatomic, assign) CGFloat viewHeight;
@property (nonatomic, assign) CGFloat moveTop;
@property (nonatomic, assign) CGFloat leftRightSpace;
@property (nonatomic, assign) CGFloat lineViewHeight;
@property (nonatomic, assign) CGFloat labelTextSize;
@property (nonatomic, assign) CGFloat textFieldTextSize;
@property (nonatomic, assign) CGFloat btnTextSize;
@property (nonatomic, assign) CGFloat btnW;
@property (nonatomic, assign) CGFloat btnH;


@property (nonatomic, strong) SDMBProgressView *HUD;


@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UITextField *moneyTextField;
@property (nonatomic, strong) UILabel *bankNametLabel;
@property (nonatomic, strong) UILabel *limitLabel;
@property (nonatomic, strong) UIButton *button;
@property (nonatomic, strong) UIImageView *iconImageView;
@property (nonatomic, strong) SDPayView *payView;

@property (nonatomic, strong) NSMutableArray *payModeArray;
@property (nonatomic, strong) NSMutableDictionary *outPayToolDic;
@property (nonatomic, strong) NSDictionary *tempWorkDic;

@end

@implementation CashRechargeViewController

@synthesize viewSize;
@synthesize viewHeight;
@synthesize moveTop;
@synthesize leftRightSpace;
@synthesize lineViewHeight;
@synthesize labelTextSize;
@synthesize textFieldTextSize;
@synthesize btnTextSize;
@synthesize btnW;
@synthesize btnH;


@synthesize HUD;


@synthesize scrollView;
@synthesize iconImageView;
@synthesize limitLabel;
@synthesize moneyTextField;
@synthesize bankNametLabel;
@synthesize button;
@synthesize payView;

@synthesize payModeArray;
@synthesize outPayToolDic;
@synthesize tempWorkDic;


@synthesize tTokenType;
@synthesize cashPayToolDic;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.view setBackgroundColor:RGBA(247, 245, 244, 1.0)];
    viewSize = self.view.bounds.size;
    leftRightSpace = 15;
    
    payModeArray = [[NSMutableArray alloc] init];
    
    
    

    
    
    [self settingNavigationBar];
    [self load];
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
    navCoverView = [NavCoverView shareNavCoverView:CGRectMake(0, 0, viewSize.width, controllerTop) title:@"充值"];
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
    CGFloat balaceLabSize = 0;

        balaceLabSize = 10;
        labelTextSize = 12;
        textFieldTextSize = 14;
        btnTextSize = 16;

    
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
    [scrollView setBackgroundColor:RGBA(239, 239, 244, 1.0)];
    [view addSubview:scrollView];
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    UIButton *payModeBtn = [[UIButton alloc] init];
    payModeBtn.tag = 1;
    payModeBtn.backgroundColor = viewColor;
    [payModeBtn addTarget:self action:@selector(buttonActionToDoSomething:) forControlEvents:UIControlEventTouchUpInside];
    [scrollView addSubview:payModeBtn];
    
    UIImage *iconImage = [UIImage imageNamed:@"banklist_pbc"];
    CGSize iconImageSize = iconImage.size;
    iconImageView = [[UIImageView alloc] init];
    iconImageView.image = iconImage;
    iconImageView.contentMode = UIViewContentModeScaleAspectFit;
    [payModeBtn addSubview:iconImageView];
    
    bankNametLabel = [[UILabel alloc] init];
    bankNametLabel.text = @"账号";
    bankNametLabel.textColor = textFiledColor;
    bankNametLabel.font = [UIFont systemFontOfSize:textFieldTextSize];
    [payModeBtn addSubview:bankNametLabel];
    
    UIImage *arrowImage = [UIImage imageNamed:@"list_forward.png"];
    UIImageView* arrowImageView = [[UIImageView alloc] init];
    arrowImageView.image = arrowImage;
    arrowImageView.contentMode = UIViewContentModeScaleAspectFit;
    [payModeBtn addSubview:arrowImageView];
    
    
    UIView *moreRechargeMoneyView = [[UIView alloc] init];
    moreRechargeMoneyView.backgroundColor = [UIColor clearColor];
    [scrollView addSubview:moreRechargeMoneyView];
    
    limitLabel = [[UILabel alloc] init];
    limitLabel.text = @"请输入充值金额";
    limitLabel.textColor = titleColor;
    limitLabel.font = [UIFont systemFontOfSize:labelTextSize];
    [moreRechargeMoneyView addSubview:limitLabel];
    
    
    UIView *moneyView = [[UIView alloc] init];
    moneyView.backgroundColor = viewColor;
    [scrollView addSubview:moneyView];
    
    UILabel *moneyTitleLabel = [[UILabel alloc] init];
    moneyTitleLabel.text = @"金额";
    moneyTitleLabel.textColor = textFiledColor;
    moneyTitleLabel.font = [UIFont systemFontOfSize:textFieldTextSize];
    [moneyView addSubview:moneyTitleLabel];
    
    moneyTextField = [[UITextField alloc] init];
    moneyTextField.tag = 1;
    moneyTextField.placeholder = @"¥ 0.0";
    moneyTextField.keyboardType = UIKeyboardTypeDecimalPad;
    [moneyTextField setMinLenght:@"0"];
    [moneyTextField setMaxLenght:@"11"];
    [moneyView addSubview:moneyTextField];
    
    // 完成按钮
    button = [[UIButton alloc] init];
    [button setTag:2];
    [button setTitle:@"确认" forState: UIControlStateNormal];
    [button setTitleColor:RGBA(255, 255, 255, 1.0) forState:UIControlStateNormal];
    button.titleLabel.font = [UIFont systemFontOfSize:btnTextSize];
    [button.layer setMasksToBounds:YES];
    button.layer.cornerRadius = 5.0;
    [button addTarget:self action:@selector(buttonActionToDoSomething:) forControlEvents:UIControlEventTouchUpInside];
    [scrollView addSubview:button];
    
    //设置控件大小和位置
    CGFloat commWidth = viewSize.width - 2 * leftRightSpace;
    CGFloat space = 10;
    CGFloat scrollViewH = viewSize.height - controllerTop;
    
    CGFloat bankNametLabelWidth = commWidth - iconImageSize.width - space - arrowImage.size.width - space;
    CGSize bankNametLabelSize = [bankNametLabel sizeThatFits:CGSizeMake(bankNametLabelWidth, MAXFLOAT)];
    
    CGFloat payModeBtnHeight = iconImageSize.height + 2 * leftRightSpace;
    
    CGSize limitLabelSize = [limitLabel sizeThatFits:CGSizeMake(commWidth, MAXFLOAT)];
    CGFloat moreRechargeMoneyViewHeight = limitLabelSize.height + 2 * 10;
    
    CGSize moneyTitleLabelSize = [moneyTitleLabel.text sizeWithNSStringFont:moneyTitleLabel.font];
    CGFloat moneyTextFieldWidth = commWidth - moneyTitleLabelSize.width - space;
    CGSize moneyTextFieldSize = [moneyTextField sizeThatFits:CGSizeMake(moneyTextFieldWidth, MAXFLOAT)];
    CGFloat moneyViewHeight = moneyTextFieldSize.height + 2 * leftRightSpace;
    
    
    CGSize buttonSize = [button.titleLabel sizeThatFits:CGSizeMake(commWidth, MAXFLOAT)];
    CGFloat buttonHeight = buttonSize.height + 2 * leftRightSpace;
    btnW = commWidth;
    btnH = buttonHeight;
    
    [self textFiledEditChanged];
    
    
    [scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(view).offset(controllerTop);
        make.centerX.equalTo(view);
        make.size.mas_equalTo(CGSizeMake(viewSize.width, scrollViewH));
    }];
    
    [payModeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(scrollView).offset(10);
        make.left.equalTo(scrollView).offset(0);
        make.size.mas_equalTo(CGSizeMake(viewSize.width, payModeBtnHeight));
    }];
    
    [iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(payModeBtn).offset(leftRightSpace);
        make.centerY.equalTo(payModeBtn);
        make.size.mas_equalTo(iconImageSize);
    }];
    
    [bankNametLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(iconImageView.mas_right).offset(space);
        make.centerY.equalTo(payModeBtn);
        make.size.mas_equalTo(CGSizeMake(bankNametLabelWidth, bankNametLabelSize.height));
    }];
    
    [arrowImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(payModeBtn.mas_right).offset(-leftRightSpace);
        make.centerY.equalTo(payModeBtn);
    }];
    
    [moreRechargeMoneyView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(payModeBtn.mas_bottom).offset(0);
        make.left.equalTo(scrollView).offset(0);
        make.size.mas_equalTo(CGSizeMake(viewSize.width, moreRechargeMoneyViewHeight));
    }];
    
    [limitLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(moreRechargeMoneyView).offset(leftRightSpace);
        make.centerY.equalTo(moreRechargeMoneyView);
        make.size.mas_equalTo(CGSizeMake(commWidth, limitLabelSize.height));
    }];
    
    [moneyView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(moreRechargeMoneyView.mas_bottom).offset(0);
        make.left.equalTo(scrollView).offset(0);
        make.size.mas_equalTo(CGSizeMake(viewSize.width, moneyViewHeight));
    }];
    
    [moneyTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(moneyView).offset(leftRightSpace);
        make.centerY.equalTo(moneyView);
        make.size.mas_equalTo(CGSizeMake(moneyTitleLabelSize.width, moneyTitleLabelSize.height));
    }];
    
    [moneyTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(moneyTitleLabel.mas_right).offset(space);
        make.centerY.equalTo(moneyView);
        make.size.mas_equalTo(CGSizeMake(moneyTextFieldWidth, moneyTextFieldSize.height));
    }];
    
    [button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(moneyView.mas_bottom).offset(20);
        make.centerX.equalTo(scrollView);
        make.size.mas_equalTo(CGSizeMake(btnW, btnH));
    }];
    
    [self listenNotifier];
    [self setInputResponderChain];
    
    payView = [SDPayView getPayView];
    payView.delegate = self;
    [self.view addSubview:payView];
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

/**
 *@brief 输入数据验证
 */
- (void)verificationInput
{
    if (moneyTextField.text.length >8 || moneyTextField.text<0) {
        return [Tool showDialog:@"输入金额位数不正确,请重新输入"];
    }
    if ([moneyTextField.text doubleValue]<0.01) {
        moneyTextField.text = @"";
        moneyTextField.placeholder = @"金额不能为零";
        [self changeBtnBackGround:nil];
        return;
    }
    
    [payView setPayInfo:(NSArray*)payModeArray moneyStr:[NSString stringWithFormat:@"¥%@",moneyTextField.text] orderTypeStr:@"现金账户充值"];
    [self fee];
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
            [self verificationInput];
            [self dismissKeyboard];
           
        }
            break;
        case 201:
        {
            [self dismissKeyboard];
        }
            break;
        case 202:
        {
            [self dismissKeyboard];
        }
            break;
        case 203:
        {
            [self dismissKeyboard];
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



#pragma mark - 把所有的输入框放到数组中
/**
 *@brief 把所有的输入框放到数组中
 *@return NSArray
 */
- (NSArray *)allInputFields {
    return @[moneyTextField];
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
    moneyTextField.returnKeyType = UIReturnKeyDone;
}

/**
 *@brief 隐藏键盘
 */
- (void)dismissKeyboard {
    //将视图的Y坐标向上移动offset个单位，以使下面腾出地方用于软键盘的显示
    [scrollView setContentOffset:CGPointMake(0.0f, 0.0f) animated:YES] ;
    [self.view endEditing:YES];
}

#pragma mark - 监听通知
- (void)listenNotifier
{
    if (moneyTextField) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFiledEditChanged:) name:UITextFieldTextDidChangeNotification object:moneyTextField];
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
        }
        if (textField.tag == 1) {
            textField.placeholder = @"0.0";
            //金额输入控制
            //输入"." 变"0."
            if ([content length]>0&&[[content substringToIndex:1] isEqualToString:@"."]) {
                textField.text = @"0.";
            }
            //两个".." 变"."
            if ([content componentsSeparatedByString:@"."].count>2) {
                textField.text = [content substringToIndex:content.length - 1];
            }
            //两个"0"  变"0."
            if ([content isEqualToString:@"00"]) {
                textField.text = @"0.";
            }
            //输入"0X" 变"0."
            if ([content floatValue]>1 && [[content substringToIndex:1] isEqualToString:@"0"]) {
                textField.text = @"0.";
            }
        }
    }
    
    [self textFiledEditChanged];
    
}

- (void)textFiledEditChanged
{
    if (moneyTextField) {
        if ([@"" isEqualToString:moneyTextField.text] || moneyTextField.text == nil) {
            return [self changeBtnBackGround:nil];
        }
    }
    
    return [self changeBtnBackGround:@"yes"];
}
#pragma mark - 限制键盘输入某些字符
-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    
    if ([textField.placeholder rangeOfString:@"0.0"].location !=NSNotFound) {
        return [self limitPayMoneyDot:textField shouldChangeCharactersInRange:range replacementString:string dotPreBits:8 dotAfterBits:2];
    }
    
    return YES;
    
}
/**
 *  付款金额限制代码
 *
 *  @param textField    当前textField
 *  @param range        range
 *  @param string       string
 *  @param dotPreBits   小数点前整数位数
 *  @param dotAfterBits 小数点后位数
 *
 *  @return shouldChangeCharactersInRange 代理方法中 可以限制金额格式
 */
#define myDotNumbers     @"0123456789.\n"
#define myNumbers          @"0123456789\n"
- (BOOL) limitPayMoneyDot:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string dotPreBits:(int)dotPreBits dotAfterBits:(int)dotAfterBits

{
    if ([string isEqualToString:@"\n"]||[string isEqualToString:@""])
    { //按下return
        return YES;
    }
    
    
    NSCharacterSet *cs;
    NSUInteger nDotLoc = [textField.text rangeOfString:@"."].location;
    if (NSNotFound == nDotLoc && 0 != range.location) {
        cs = [[NSCharacterSet characterSetWithCharactersInString:myNumbers]invertedSet];
        if ([string isEqualToString:@"."]) {
            return YES;
        }
        if (textField.text.length>=dotPreBits) {  //小数点前面6位
            return NO;
        }
    }
    else {
        cs = [[NSCharacterSet characterSetWithCharactersInString:myDotNumbers] invertedSet];
        if (textField.text.length>=9) {
            return  NO;
        }
    }
    NSString *filtered = [[string componentsSeparatedByCharactersInSet:cs] componentsJoinedByString:@""];
    BOOL basicTest = [string isEqualToString:filtered];
    if (!basicTest) {
        return NO;
    }
    if (NSNotFound != nDotLoc && range.location > nDotLoc +dotAfterBits) {//小数点后面两位
        return NO;
    }
    return YES;
}
#pragma mark - 改变按钮背景图片
/**
 *@brief  改变按钮背景图片
 *@param param NSString 参数：字符串
 *@return
 */
- (void)changeBtnBackGround:(NSString *)param
{
    if (![@"" isEqualToString:param] && param != nil) {
        [button setBackgroundImage:[UIImage imageWithColor:RGBA(65, 131, 215, 1.0) size:CGSizeMake(btnW, btnH)] forState:UIControlStateNormal];
        
        [button setBackgroundImage:[UIImage imageWithColor:RGBA(65, 131, 215, 1.0) size:CGSizeMake(btnW, btnH)] forState:UIControlStateHighlighted];
        
        button.userInteractionEnabled = YES;
    } else {
        [button setBackgroundImage:[UIImage imageWithColor:RGBA(200, 200, 200, 1.0) size:CGSizeMake(btnW, btnH)] forState:UIControlStateNormal];
        
        [button setBackgroundImage:[UIImage imageWithColor:RGBA(200, 200, 200, 1.0) size:CGSizeMake(btnW, btnH)] forState:UIControlStateHighlighted];
        
        button.userInteractionEnabled = NO;
    }
}



#pragma mark - SDPayViewDelegate
- (void)payViewSelectPayToolDic:(NSMutableDictionary *)selectPayToolDict{
    outPayToolDic = selectPayToolDict;
    
    NSString *accNo  = [[outPayToolDic objectForKey:@"account"] objectForKey:@"accNo"];
    NSString *title = [outPayToolDic objectForKey:@"title"];
    NSString *lastfournumber = accNo.length>=4?lastfournumber = [accNo substringFromIndex:accNo.length-4]:lastfournumber = @"暂无显示";
    bankNametLabel.text = [NSString stringWithFormat:@"%@(%@)",title,lastfournumber];
    NSString *imgName = [Tool getIconImageName:[selectPayToolDict objectForKey:@"type"]title:title imaUrl:@""];
    iconImageView.image = [UIImage imageNamed:imgName];
    
}

- (void)payViewPwd:(NSString *)pwdStr paySuccessView:(SDPaySuccessAnimationView *)successView{
    //支付动画开始
    [successView animationStart];
    
    [self recharge:pwdStr paramDic:tempWorkDic rechargeSuccessBlock:^(NSArray *paramArr){
        //支付成功
        [successView animationSuccess];
        dispatch_time_t delayTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5f * NSEC_PER_SEC));
        dispatch_after(delayTime, dispatch_get_main_queue(), ^{
            RechargeResultViewController *mRechargeResultViewController = [[RechargeResultViewController alloc] init];
            mRechargeResultViewController.viewControllerIndex = _controllerIndex;
            mRechargeResultViewController.workDic = paramArr[0];
            mRechargeResultViewController.payToolDic = paramArr[1];
            [self.navigationController pushViewController:mRechargeResultViewController animated:YES];
        });
    } rechagreErrorBlock:^(NSArray *paramArr){
        //支付失败
        [successView animationStopClean];
        [payView hidPayTool];
        [self resetBankNameLabelAndIconImageView];
    }];
}

- (void)payViewForgetPwd:(NSString *)type{
    
    if ([type isEqualToString:PAYTOOL_PAYPASS]) {
        //修改支付密码
        VerificationModeViewController *mVerificationModeViewController = [[VerificationModeViewController alloc] init];
        mVerificationModeViewController.tokenType = @"01000601";
        [self.navigationController pushViewController:mVerificationModeViewController animated:YES];
    }
    
}

- (void)payViewAddPayToolCard:(NSString *)type{
    
    if ([type isEqualToString:PAYTOOL_PAYPASS]) {
        BindingBankViewController *mBindingBankViewController = [[BindingBankViewController alloc] init];
        [self.navigationController pushViewController:mBindingBankViewController animated:YES];
        return;
    }
    if ([type isEqualToString:PAYTOOL_ACCPASS]) {
        
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
        
        paynuc.set("tTokenType", [tTokenType UTF8String]);
        [[SDRequestHelp shareSDRequest] requestWihtFuncName:@"token/getTtoken/v1" errorBlock:^(SDRequestErrorType type) {
            error = YES;
        } successBlock:^{
            
        }];
        if (error) return ;

        
        NSString *payTool = [[PayNucHelper sharedInstance] dictionaryToJson:cashPayToolDic];
        [SDLog logDebug:payTool];
        
        paynuc.set("payTool", [payTool UTF8String]);
        [[SDRequestHelp shareSDRequest] requestWihtFuncName:@"payTool/getPayTools/v1" errorBlock:^(SDRequestErrorType type) {
            error = YES;
        } successBlock:^{
            [[SDRequestHelp shareSDRequest] dispatchToMainQueue:^{
                [HUD hidden];
                
                NSString *outpayTools = [NSString stringWithUTF8String:paynuc.get("payTools").c_str()];
                NSArray *outpayToolsArray = [[PayNucHelper sharedInstance] jsonStringToArray:outpayTools];
                
                //0.排序
                outpayToolsArray = [Tool orderForPayTools:outpayToolsArray];
                
                if ([outpayToolsArray count] <= 0) {
                    [Tool showDialog:@"无可用方式,请绑卡重试" defulBlock:^{
                        BindingBankViewController *mBindingBankViewController = [[BindingBankViewController alloc] init];
                        [self.navigationController pushViewController:mBindingBankViewController animated:YES];
                    }];
                } else {
                    
                    //1.过滤用支付工具
                    payToolsArrayUsableM = [NSMutableArray arrayWithCapacity:0];
                    payToolsArrayUnusableM = [NSMutableArray arrayWithCapacity:0];
                    for (int i = 0; i<outpayToolsArray.count; i++) {
                        if ([@"0" isEqualToString:[NSString stringWithFormat:@"%@",[[outpayToolsArray[i] objectForKey:@"account"] objectForKey:@"useableBalance"]]] || [[outpayToolsArray[i] objectForKey:@"available"] boolValue]== NO) {
                            //不可用支付工具集
                            [payToolsArrayUnusableM addObject:outpayToolsArray[i]];
                        }else{
                            //可用支付工具集
                            [payToolsArrayUsableM addObject:outpayToolsArray[i]];
                        }
                    }
                    
                    [self addView:self.view];
                    //2.设置VC默认显示的支付
                    outPayToolDic = [NSMutableDictionary dictionaryWithDictionary:payToolsArrayUsableM[0]];
                    [self resetBankNameLabelAndIconImageView];
                    
                    //3.设置支付方式列表
                    [self initPayMode:outpayToolsArray];
                }
            }];
        }];
        if (error) return ;
    }];

}


/**
 重置文字和icon图片
 */
- (void)resetBankNameLabelAndIconImageView{
    NSString *accNo  = [[payToolsArrayUsableM[0] objectForKey:@"account"] objectForKey:@"accNo"];
    NSString *title = [payToolsArrayUsableM[0] objectForKey:@"title"];
    NSString *lastfournumber = accNo.length>=4?lastfournumber = [accNo substringFromIndex:accNo.length-4]:lastfournumber = @"暂无显示";
    bankNametLabel.text = [NSString stringWithFormat:@"%@(%@)",title,lastfournumber];
    NSString *imgName = [Tool getIconImageName:[payToolsArrayUsableM[0] objectForKey:@"type"] title:title imaUrl:nil];
    iconImageView.image = [UIImage imageNamed:imgName];
}

/**
 *@brief 初始化支付方式
 */
- (void)initPayMode:(NSArray *)paramArray
{
    
    NSMutableDictionary *bankDic = [[NSMutableDictionary alloc] init];
    [bankDic setValue:@"PAYLTOOL_LIST_PAYPASS" forKey:@"type"];
    [bankDic setValue:@"添加银行卡充值" forKey:@"title"];
    [bankDic setValue:@"list_yinlian_AddCard" forKey:@"img"];
    [bankDic setValue:@"" forKey:@"limit"];
    [bankDic setValue:@"2" forKey:@"state"];
    [bankDic setValue:@"true" forKey:@"available"];
    [payToolsArrayUsableM addObject:bankDic];
    
    NSInteger unavailableArrayCount = [payToolsArrayUnusableM count];
    for (int i = 0; i < unavailableArrayCount; i++) {
        [payToolsArrayUsableM addObject:payToolsArrayUnusableM[i]];
    }
    payModeArray = payToolsArrayUsableM;

}

/**
 *@brief 手续费
 *@return
 */
- (void)fee
{
    HUD = [SDMBProgressView showSDMBProgressOnlyLoadingINViewImg:self.view];
    [SDRequestHelp shareSDRequest].HUD = HUD;
    [SDRequestHelp shareSDRequest].controller = self;
    [[SDRequestHelp shareSDRequest] dispatchGlobalQuque:^{
        __block BOOL error = NO;
        NSString *transAmt = [NSString stringWithFormat:@"%.0f", [moneyTextField.text floatValue] * 100];
        
        NSMutableDictionary *workDic = [[NSMutableDictionary alloc] init];
        [workDic setValue:@"recharge" forKey:@"type"];
        [workDic setValue:@"" forKey:@"merOrderId"];
        [workDic setValue:@"" forKey:@"sandTN"];
        [workDic setValue:@"" forKey:@"thirdParty"];
        [workDic setValue:transAmt forKey:@"transAmt"];
        [workDic setValue:@"" forKey:@"remark"];
        [workDic setValue:@"" forKey:@"feeType"];
        [workDic setValue:@"" forKey:@"fee"];
        [workDic setValue:@"" forKey:@"feeRate"];
        
        NSString *work = [[PayNucHelper sharedInstance] dictionaryToJson:workDic];
        [SDLog logDebug:work];
        
        NSString *inPayTool = [[PayNucHelper sharedInstance] dictionaryToJson:cashPayToolDic];
        [SDLog logDebug:inPayTool];
        
        NSString *outPayTool = [[PayNucHelper sharedInstance] dictionaryToJson:outPayToolDic];
        [SDLog logDebug:outPayTool];
        
        paynuc.set("work", [work UTF8String]);
        paynuc.set("inPayTool", [inPayTool UTF8String]);
        paynuc.set("outPayTool", [outPayTool UTF8String]);
        paynuc.set("authTools", [@"[]" UTF8String]);
        [[SDRequestHelp shareSDRequest] requestWihtFuncName:@"business/fee/v1" errorBlock:^(SDRequestErrorType type) {
            error = YES;
        } successBlock:^{
            [[SDRequestHelp shareSDRequest] dispatchToMainQueue:^{
                [HUD hidden];
                
                NSString *work = [NSString stringWithUTF8String:paynuc.get("work").c_str()];
                tempWorkDic = [[PayNucHelper sharedInstance] jsonStringToDictionary:work];
                
                NSString *fee = [tempWorkDic objectForKey:@"fee"];
                NSString *feeAmt = [NSString stringWithFormat:@"%.2f", [transAmt floatValue] * [fee floatValue]];
                [SDLog logDebug:[NSString stringWithFormat:@"手续费:%@", feeAmt]];
                
                //弹出支付工具
                [payView showPayTool];
            }];
        }];
        if (error) return ;
    }];
}

/**
 *@brief 充值
 *@return
 */
- (void)recharge:(NSString *)param paramDic:(NSDictionary *)paramDic rechargeSuccessBlock:(CashRechargeStateBlock)successBlock rechagreErrorBlock:(CashRechargeStateBlock)errorBlock
{
    
    HUD = [SDMBProgressView showSDMBProgressOnlyLoadingINViewImg:self.view];
    [HUD hidden];
    [SDRequestHelp shareSDRequest].HUD = HUD;
    [SDRequestHelp shareSDRequest].controller = self;
    [[SDRequestHelp shareSDRequest] dispatchGlobalQuque:^{
        __block BOOL error = NO;
        NSString *transAmt = [NSString stringWithFormat:@"%.0f", [moneyTextField.text floatValue] * 100];
        
        NSMutableDictionary *workDic = [[NSMutableDictionary alloc] init];
        [workDic setValue:@"recharge" forKey:@"type"];
        [workDic setValue:@"" forKey:@"merOrderId"];
        [workDic setValue:@"" forKey:@"sandTN"];
        [workDic setValue:@"" forKey:@"thirdParty"];
        [workDic setValue:transAmt forKey:@"transAmt"];
        [workDic setValue:@"" forKey:@"remark"];
        [workDic setValue:[paramDic objectForKey:@"feeType"] forKey:@"feeType"];
        [workDic setValue:@"" forKey:@"fee"];
        [workDic setValue:[paramDic objectForKey:@"feeRate"] forKey:@"feeRate"];
        
        NSString *work = [[PayNucHelper sharedInstance] dictionaryToJson:workDic];
        [SDLog logDebug:work];
        
        NSString *inPayTool = [[PayNucHelper sharedInstance] dictionaryToJson:cashPayToolDic];
        [SDLog logDebug:inPayTool];
        
        NSArray *authToolsArray = [outPayToolDic objectForKey:@"authTools"];
        
        NSMutableArray *tempAuthToolsArray = [[NSMutableArray alloc] init];
        
        
        NSMutableDictionary *dic = authToolsArray[0];
        NSMutableDictionary *authToolsDic = [NSMutableDictionary dictionaryWithDictionary:dic];
        [authToolsDic removeObjectForKey:@"pass"];
        NSMutableDictionary *passDic = [[NSMutableDictionary alloc] init];
        if ([[authToolsDic objectForKey:@"type"] isEqualToString:@"paypass"]){
            [passDic setValue:[[PayNucHelper sharedInstance] pinenc:param type:@"paypass"] forKey:@"password"];
        }
        else if([[authToolsDic objectForKey:@"type"] isEqualToString:@"accpass"]){
            [passDic setValue:[[PayNucHelper sharedInstance] pinenc:param type:@"accpass"] forKey:@"password"];
        }
        [passDic setValue:@"" forKey:@"description"];
        [passDic setValue:@"" forKey:@"encryptType"];
        [passDic setValue:@"" forKey:@"regular"];
        [authToolsDic setObject:passDic forKey:@"pass"];
        [tempAuthToolsArray addObject:authToolsDic];
        [outPayToolDic setObject:tempAuthToolsArray forKey:@"authTools"];
        
        NSString *outPayTool = [[PayNucHelper sharedInstance] dictionaryToJson:outPayToolDic];
        [SDLog logDebug:outPayTool];
        
        paynuc.set("work", [work UTF8String]);
        paynuc.set("inPayTool", [inPayTool UTF8String]);
        paynuc.set("outPayTool", [outPayTool UTF8String]);
        [[SDRequestHelp shareSDRequest] requestWihtFuncName:@"business/acc2acc/v1" errorBlock:^(SDRequestErrorType type) {
            error = YES;
            [[SDRequestHelp shareSDRequest] dispatchToMainQueue:^{
                errorBlock(nil);
            }];
        } successBlock:^{
            [[SDRequestHelp shareSDRequest] dispatchToMainQueue:^{
                [HUD hidden];
                successBlock(@[workDic,outPayToolDic]);
            }];
        }];
        if (error) return ;
    }];

}

- (void)dealloc
{
    if (moneyTextField) {
        [[NSNotificationCenter defaultCenter] removeObserver:self name:UITextFieldTextDidChangeNotification object:moneyTextField];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
