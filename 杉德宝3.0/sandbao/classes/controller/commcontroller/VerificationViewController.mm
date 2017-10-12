//
//  VerificationViewController.m
//  sandbao
//
//  Created by tianNanYiHao on 2017/1/19.
//  Copyright © 2017年 sand. All rights reserved.
//

#import "VerificationViewController.h"


#import "SDLog.h"
#import "PayNucHelper.h"
#import "GroupView.h"
#import "MiBaoSetViewController.h"
#import "FindLoginPwdViewController.h"
#import "SettingPayPwdViewController.h"
#import "VerificationModeViewController.h"

#define navbarColor RGBA(255, 255, 255, 1.0)

#define navViewColor RGBA(249, 249, 249, 1.0)

#define lineViewColor RGBA(237, 237, 237, 1.0)

#define titleColor RGBA(174, 174, 174, 1.0)

#define textFiledColor RGBA(83, 83, 83, 1.0)

#define btnColor RGBA(255, 97, 51, 1.0)

#define viewColor RGBA(255, 255, 255, 1.0)
typedef void(^VerificationStateBlock)(NSArray *paramArr);
@interface VerificationViewController ()<UITextFieldDelegate>
{
    NavCoverView *navCoverView;
}

@property (nonatomic, assign) CGSize viewSize;
@property (nonatomic, assign) CGFloat viewTop;
@property (nonatomic, assign) CGFloat viewHeight;
@property (nonatomic, assign) CGFloat moveTop;
@property (nonatomic, assign) CGFloat leftRightSpace;
@property (nonatomic, assign) CGFloat lineViewHeight;
@property (nonatomic, assign) CGFloat titleSize;
@property (nonatomic, assign) CGFloat textFieldTextSize;
@property (nonatomic, assign) CGFloat btnTextSize;
@property (nonatomic, assign) CGFloat btnW;
@property (nonatomic, assign) CGFloat btnH;



@property (nonatomic, strong) SDMBProgressView *HUD;


@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UIButton *button;
@property (nonatomic, strong) NSMutableArray *textFieldArray;



@property (nonatomic, assign) CGFloat shortMsgBtnW;
@property (nonatomic, assign) CGFloat shortMsgBtnH;
@property (nonatomic, assign) int timeOut;
@property (nonatomic, assign) int timeCount;
@property (nonatomic, assign) BOOL showPwdFlag;
@property (nonatomic, assign) CGFloat textFieldTag;
@property (nonatomic, assign) BOOL payPassTag;

@property (nonatomic,strong)  NSString *payPassCodeStr;

@property (nonatomic, strong) NSMutableArray *authToolsArray;
@property (nonatomic, strong) NSMutableArray *regAuthToolsArray;
@property (nonatomic, strong) NSTimer *timer;
@property (nonatomic, strong) SDPayView *payView;
@property (nonatomic, strong) UITextField *phoneNumTextField;
@property (nonatomic, strong) UITextField *shortMsgTextField;
@property (nonatomic, strong) UITextField *loginPwdTextField;
@property (nonatomic, strong) UITextField *payPwdTextField;
@property (nonatomic, strong) UITextField *IDCardTextField;
@property (nonatomic, strong) UITextField *pictureNumTextField;
@property (nonatomic, strong) UITextField *realNameTextField;
@property (nonatomic, strong) UILabel *bankNameLabel;
@property (nonatomic, strong) UITextField *bankCardTextField;
@property (nonatomic, strong) UITextField *questionTextField;
@property (nonatomic, strong) UITextField *accPwdTextField;
@property (nonatomic, strong) UIButton *shortMsgBtn;
@property (nonatomic, strong) UIButton *loginPwdBtn;
@property (nonatomic, strong) UIButton *pictureBtn;
@property (nonatomic, strong) UILabel *questionTitleLabel;
@property (nonatomic, strong) UIButton *questionBtn;
@property (nonatomic, strong) UILabel *questionlabel;
@property (nonatomic, strong) UITextField *cvnTextField;
@property (nonatomic, strong) UITextField *expiryTextField;

@end

@implementation VerificationViewController

@synthesize viewSize;
@synthesize viewHeight;
@synthesize moveTop;
@synthesize leftRightSpace;
@synthesize lineViewHeight;
@synthesize titleSize;
@synthesize textFieldTextSize;
@synthesize btnTextSize;
@synthesize btnW;
@synthesize btnH;



@synthesize HUD;


@synthesize scrollView;
@synthesize button;

@synthesize tokenType;
@synthesize authGroupDic;


@synthesize shortMsgBtnW;
@synthesize shortMsgBtnH;
@synthesize timeOut;
@synthesize timeCount;
@synthesize showPwdFlag;
@synthesize textFieldTag;
@synthesize textFieldArray;
@synthesize payPassTag;

@synthesize authToolsArray;
@synthesize timer;
@synthesize payView;
@synthesize phoneNumTextField;
@synthesize shortMsgTextField;
@synthesize loginPwdTextField;
@synthesize payPwdTextField;
@synthesize IDCardTextField;
@synthesize pictureNumTextField;
@synthesize realNameTextField;
@synthesize bankNameLabel;
@synthesize bankCardTextField;
@synthesize questionTextField;
@synthesize accPwdTextField;
@synthesize shortMsgBtn;
@synthesize loginPwdBtn;
@synthesize pictureBtn;
@synthesize questionTitleLabel;
@synthesize questionBtn;
@synthesize questionlabel;
@synthesize cvnTextField;
@synthesize expiryTextField;

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    //
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view setBackgroundColor:RGBA(247, 245, 244, 1.0)];
    viewSize = self.view.bounds.size;
    leftRightSpace = 15;
    
    timeOut = 90;
    authToolsArray = [[NSMutableArray alloc] init];
    _regAuthToolsArray = [[NSMutableArray alloc] init];
    textFieldArray = [[NSMutableArray alloc] init];
    textFieldTag = 0;
    payPassTag = NO;
    
    
    
    

    
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
    navCoverView = [NavCoverView shareNavCoverView:CGRectMake(0, 0, viewSize.width, controllerTop) title:@"验证"];
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

        titleSize = 12;
        textFieldTextSize = 14;
        btnTextSize = 16;

    

//    
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
    [scrollView setBackgroundColor:RGBA(242, 242, 242, 1.0)];
    [view addSubview:scrollView];
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    
    UIView *authToolsView = [[UIView alloc] init];
    authToolsView.backgroundColor = viewColor;
    [scrollView addSubview:authToolsView];
    
    CGFloat authToolsViewH = [self addAuthToolsView:authToolsView];
    
    
    // 校验按钮
    button = [[UIButton alloc] init];
    [button setTag:1];
    [button setTitle:@"校验" forState: UIControlStateNormal];
    [button setTitleColor:RGBA(255, 255, 255, 1.0) forState:UIControlStateNormal];
    button.titleLabel.font = [UIFont systemFontOfSize:btnTextSize];
    [button.layer setMasksToBounds:YES];
    button.layer.cornerRadius = 5.0;
    [button addTarget:self action:@selector(buttonActionToDoSomething:) forControlEvents:UIControlEventTouchUpInside];
    [scrollView addSubview:button];
    
    //设置控件的大小和位置
    CGFloat btnTop = 60.55;
    CGFloat authToolsViewTop = 10;
    CGFloat commWidth = viewSize.width - 2 * leftRightSpace;
    
    
    CGSize buttonSize = [button.titleLabel sizeThatFits:CGSizeMake(commWidth, MAXFLOAT)];
    CGFloat buttonHeight = buttonSize.height + 2 * 15;
    btnW = commWidth;
    btnH = buttonHeight;
    
    moveTop = controllerTop;
    
    
//    [navBarView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(view).offset(0);
//        make.centerX.equalTo(view);
//        make.size.mas_equalTo(CGSizeMake(viewSize.width, navBarViewHeight));
//    }];
//    
//    [navView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(navBarView.mas_bottom).offset(0);
//        make.centerX.equalTo(view);
//        make.size.mas_equalTo(CGSizeMake(viewSize.width, navViewHeight));
//    }];
    
    [scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(navCoverView.mas_bottom).offset(0);
        make.centerX.equalTo(view);
        make.size.mas_equalTo(CGSizeMake(viewSize.width, viewSize.height - controllerTop));
    }];
    
    [authToolsView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(scrollView).offset(authToolsViewTop);
        make.left.equalTo(scrollView).offset(0);
        make.size.mas_equalTo(CGSizeMake(viewSize.width, authToolsViewH));
    }];
    
    [button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(authToolsView.mas_bottom).offset(btnTop);
        make.centerX.equalTo(scrollView);
        make.size.mas_equalTo(CGSizeMake(btnW, btnH));
    }];
    
    scrollView.contentSize = CGSizeMake(viewSize.width, authToolsViewH + btnTop + btnH);
    
    [self listenNotifier];
    
    [self textFiledEditChanged];
    
    [self setInputResponderChain];
    
    payView = [SDPayView getPayView];
    payView.style = SDPayViewOnlyPwd;
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
            [self verificationInput];
        }
            break;
        case 201:
        {
            [self dismissKeyboard];
            shortMsgTextField.text = @"";
            timeCount = timeOut;
            [self shortMsg];
        }
            break;
        case 202:
        {
            [self dismissKeyboard];
            //            [self verificationInput];
            [self changePwdShowState:1];
        }
            
            break;
        case 404:
        {
            [self dismissKeyboard];
            //            [self verificationInput];
            [self changePwdShowState:1];
        }
            
            break;
        case 203:
        {
            [self dismissKeyboard];
            //            [self verificationInput];
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
    return textFieldArray;
}

#pragma mark - UITextFieldDelegate

-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    CGFloat allHeight = viewHeight * textField.tag + moveTop;
    
    CGFloat offset = allHeight -(self.view.frame.size.height-216.0 - 30);//键盘高度216
    
    
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
    shortMsgTextField.keyboardType = UIKeyboardTypeNumberPad;
    bankCardTextField.keyboardType = UIKeyboardTypeNumberPad;
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
    
    if (accPwdTextField) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFiledEditChanged:) name:UITextFieldTextDidChangeNotification object:accPwdTextField];
    }
    if (bankCardTextField) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFiledEditChanged:) name:UITextFieldTextDidChangeNotification object:bankCardTextField];

    }
    if (realNameTextField) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFiledEditChanged:) name:UITextFieldTextDidChangeNotification object:realNameTextField];
    }
    
    if (IDCardTextField) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFiledEditChanged:) name:UITextFieldTextDidChangeNotification object:IDCardTextField];
    }
    
    if (pictureNumTextField) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFiledEditChanged:) name:UITextFieldTextDidChangeNotification object:pictureNumTextField];
    }

    for (int i = 0; i < textFieldArray.count; i++) {
        questionTextField = textFieldArray[i];
        
        if (questionTextField) {
             [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFiledEditChanged:) name:UITextFieldTextDidChangeNotification object:questionTextField];
        }
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
    
    if (accPwdTextField) {
        if ([@"" isEqualToString:accPwdTextField.text] || accPwdTextField.text == nil) {
            return [self changeBtnBackGround:nil index:2];
        }
    }
    
    if (payPwdTextField) {
        if ([@"" isEqualToString:payPwdTextField.text] || payPwdTextField.text == nil) {
            return [self changeBtnBackGround:nil index:2];
        }
    }
    
    if(realNameTextField) {
        if ([@"" isEqualToString:realNameTextField.text] || realNameTextField.text == nil) {
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
        if ([@"" isEqualToString:questionTextField.text] || questionTextField.text == nil) {
            return [self changeBtnBackGround:nil index:2];
        }
    }
    
    if (cvnTextField) {
        if ([@"" isEqualToString:cvnTextField.text] || cvnTextField.text == nil) {
            return [self changeBtnBackGround:nil index:2];
        }
    }
    
    if (expiryTextField) {
        if ([@"" isEqualToString:expiryTextField.text] || expiryTextField.text == nil) {
            return [self changeBtnBackGround:nil index:2];
        }
    }
    
    return [self changeBtnBackGround:@"yes" index:1];
}
#pragma mark - 限制键盘输入某些字符
-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    
    if ([textField.placeholder rangeOfString:@"手机号"].location !=NSNotFound) {
        return [self restrictionwithTypeStr:OnlyNumberVerifi string:string];
    }
    if ([textField.placeholder rangeOfString:@"数字验证码"].location !=NSNotFound) {
        return [self restrictionwithTypeStr:OnlyNumberVerifi string:string];
    }
    if ([textField.placeholder rangeOfString:@"密码"].location !=NSNotFound) {
        return [self restrictionwithTypeStr:OnlyNum_letterVerifi string:string];
    }
    if ([textField.placeholder rangeOfString:@"真实姓名"].location !=NSNotFound) {
        return [self restrictionwithChineseCharTypeStr:OnlyChineseCharacterVerifi string:string];
    }
    if ([textField.placeholder rangeOfString:@"身份证"].location !=NSNotFound) {
        return [self restrictionwithTypeStr:IDCardVerifi string:string];
    }
    if ([textField.placeholder rangeOfString:@"银行卡"].location !=NSNotFound) { //卡号
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
            
            
            [button setBackgroundImage:[UIImage imageWithColor:RGBA(65, 131, 215, 1.0) size:CGSizeMake(btnW, btnH)] forState:UIControlStateNormal];
            
            [button setBackgroundImage:[UIImage imageWithColor:RGBA(65, 131, 215, 1.0) size:CGSizeMake(btnW, btnH)] forState:UIControlStateHighlighted];
            
            button.userInteractionEnabled = YES;
        } else {
            [shortMsgBtn setTitleColor:RGBA(200, 199, 204, 1.0) forState:UIControlStateNormal];
            shortMsgBtn.userInteractionEnabled = NO;
            
            
            [button setBackgroundImage:[UIImage imageWithColor:RGBA(200, 200, 200, 1.0) size:CGSizeMake(btnW, btnH)] forState:UIControlStateNormal];
            
            [button setBackgroundImage:[UIImage imageWithColor:RGBA(200, 200, 200, 1.0) size:CGSizeMake(btnW, btnH)] forState:UIControlStateHighlighted];
            
            button.userInteractionEnabled = NO;
        }
    } else if (index == 2) {
        if (![@"" isEqualToString:param] && param != nil) {
            [button setBackgroundImage:[UIImage imageWithColor:RGBA(65, 131, 215, 1.0) size:CGSizeMake(btnW, btnH)] forState:UIControlStateNormal];
            
            [button setBackgroundImage:[UIImage imageWithColor:RGBA(65, 131, 215, 1.0) size:CGSizeMake(btnW, btnH)] forState:UIControlStateHighlighted];
            
            button.userInteractionEnabled = YES;
        } else {
            [button setBackgroundImage:[UIImage imageWithColor:RGBA(200, 200, 200, 1.0) size:CGSizeMake(btnW, btnH)] forState:UIControlStateNormal];
            
            [button setBackgroundImage:[UIImage imageWithColor:RGBA(200, 200, 200, 1.0) size:CGSizeMake(btnW, btnH)] forState:UIControlStateHighlighted];
            
            button.userInteractionEnabled = NO;
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

#pragma mark - 改变密码显示的状态
/**
 *@brief  改变密码显示的状态
 *@param index int 参数：索引
 */
- (void)changePwdShowState:(int)index
{
    
    if (index == 1) {
        if (showPwdFlag == NO) {
            [loginPwdBtn setImage:[UIImage imageNamed:@"list_eyes_on"] forState:UIControlStateNormal];
            showPwdFlag = YES;
            loginPwdTextField.secureTextEntry = NO;
            accPwdTextField.secureTextEntry = NO;
        } else {
            [loginPwdBtn setImage:[UIImage imageNamed:@"list_eyes_off"] forState:UIControlStateNormal];
            showPwdFlag = NO;
            loginPwdTextField.secureTextEntry = YES;
            accPwdTextField.secureTextEntry = YES;
        }
    } else {
        
    }
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
        
        NSString *authGroup = [[PayNucHelper sharedInstance] dictionaryToJson:authGroupDic];
        [SDLog logTest:authGroup];
        paynuc.set("authGroup",[authGroup UTF8String]);
        [[SDRequestHelp shareSDRequest] requestWihtFuncName:@"authTool/getAuthToolsForAuthGroup/v1" errorBlock:^(SDRequestErrorType type) {
            error = YES;
        } successBlock:^{
            [[SDRequestHelp shareSDRequest] dispatchToMainQueue:^{
                [HUD hidden];
                
                NSString *tempAuthTools = [NSString stringWithUTF8String:paynuc.get("authTools").c_str()];
                NSArray *tempAuthToolsArray = [[PayNucHelper sharedInstance] jsonStringToArray:tempAuthTools];
                
                for (int i = 0; i < tempAuthToolsArray.count; i++) {
                    [authToolsArray addObject:tempAuthToolsArray[i]];
                }
                
                if ([authToolsArray count] <= 0) {
                    [Tool showDialog:@"暂不支持此方式"];
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
    lineViewHeight = 1;
    CGFloat tempHeight = 0;
    CGFloat allHeight = 0;
    CGFloat groupViewHight = 0;
    CGFloat tempLineViewHeight = 0;
    BOOL questionFlag = NO;
    
    
    NSInteger authToolsArrayCount = [authToolsArray count];
    for (int i = 0; i < authToolsArrayCount; i++) {
        NSMutableDictionary *dic = authToolsArray[i];
        NSString *type = [dic objectForKey:@"type"];
        
        GroupView *groupView = [[GroupView alloc] initWithFrame:self.view.frame];
        groupView.groupViewStyle = GroupViewStyleYes;
        tempHeight = tempHeight + groupViewHight;
        textFieldTag = textFieldTag + 1;
        
        if ([@"loginpass" isEqualToString:type]) {
            UIView *loginpassView = [[UIView alloc] init];
            loginpassView.backgroundColor = RGBA(242, 242, 242, 1.0);
            [view addSubview:loginpassView];
            
            NSMutableAttributedString *loginpassTitleInfo = [[NSMutableAttributedString alloc] initWithString:@"输入原登陆密码完成身份验证"];
            [loginpassTitleInfo addAttribute:NSForegroundColorAttributeName value:titleColor range:NSMakeRange(0 , 2)];
            [loginpassTitleInfo addAttribute:NSForegroundColorAttributeName value:RGBA(230, 2, 2, 1.0) range:NSMakeRange(2, 5)];
            [loginpassTitleInfo addAttribute:NSForegroundColorAttributeName value:titleColor range:NSMakeRange(7, 6)];
            
            UILabel *loginpassTitleLable = [[UILabel alloc] init];
            loginpassTitleLable.attributedText = loginpassTitleInfo;
            loginpassTitleLable.font = [UIFont systemFontOfSize:titleSize];
            [loginpassView addSubview:loginpassTitleLable];
            
            CGFloat loginpassTitleLableWidth = viewSize.width - 2 * 10;
            CGSize loginpassTitleLableSize = [loginpassTitleLable sizeThatFits:CGSizeMake(loginpassTitleLableWidth, MAXFLOAT)];
            
            CGFloat loginpassViewW = viewSize.width;
            CGFloat loginpassViewH = loginpassTitleLableSize.height + 2 * 10;
            CGFloat loginpassViewOX = 0;
            CGFloat loginpassViewOY = allHeight;
            
            loginpassView.frame = CGRectMake(loginpassViewOX, loginpassViewOY, loginpassViewW, loginpassViewH);
            
            CGFloat loginpassTitleLableHeight = loginpassTitleLableSize.height;
            CGFloat loginpassTitleLableOX = 10;
            CGFloat loginpassTitleLableOY = 10;
            
            loginpassTitleLable.frame = CGRectMake(loginpassTitleLableOX, loginpassTitleLableOY, loginpassTitleLableWidth, loginpassTitleLableHeight);
            
            tempHeight = tempHeight + loginpassViewH;
            
            groupViewHight = [groupView loginPwdVerification];
            allHeight = allHeight + groupViewHight + loginpassViewH;
            loginPwdBtn = groupView.loginPwdVerificationBtn;
            loginPwdTextField = groupView.loginPwdVerificationTextField;
            
            loginPwdTextField.tag = textFieldTag;
            loginPwdBtn.tag = 202;
            [loginPwdTextField setMinLenght:@"8"];;
            [loginPwdTextField setMaxLenght:@"20"];
            
            [loginPwdBtn addTarget:self action:@selector(buttonActionToDoSomething:) forControlEvents:UIControlEventTouchUpInside];
            
            [textFieldArray addObject:loginPwdTextField];
        }
        
        if ([@"paypass" isEqualToString:type]) {
            payPassTag = YES;
        }
        
        if ([@"gesture" isEqualToString:type]) {
            
        }
        
        if ([@"accpass" isEqualToString:type]) {
            
            UIView *accpassView = [[UIView alloc] init];
            accpassView.backgroundColor = RGBA(242, 242, 242, 1.0);
            [view addSubview:accpassView];
            
            NSMutableAttributedString *accpassInfo = [[NSMutableAttributedString alloc] initWithString:@"输入原登陆密码完成身份验证"];
            [accpassInfo addAttribute:NSForegroundColorAttributeName value:titleColor range:NSMakeRange(0 , 2)];
            [accpassInfo addAttribute:NSForegroundColorAttributeName value:RGBA(230, 2, 2, 1.0) range:NSMakeRange(2, 5)];
            [accpassInfo addAttribute:NSForegroundColorAttributeName value:titleColor range:NSMakeRange(7, 6)];
            
            UILabel *accpassTitleLable = [[UILabel alloc] init];
            accpassTitleLable.attributedText = accpassInfo;
            accpassTitleLable.font = [UIFont systemFontOfSize:titleSize];
            [accpassView addSubview:accpassTitleLable];
            
            CGFloat accpassTitleLableWidth = viewSize.width - 2 * 10;
            CGSize accpassTitleLableSize = [accpassTitleLable sizeThatFits:CGSizeMake(accpassTitleLableWidth, MAXFLOAT)];
            
            CGFloat accpassViewW = viewSize.width;
            CGFloat accpassViewH = accpassTitleLableSize.height + 2 * 10;
            CGFloat accpassViewOX = 0;
            CGFloat accpassViewOY = allHeight;
            
            accpassView.frame = CGRectMake(accpassViewOX, accpassViewOY, accpassViewW, accpassViewH);
            
            CGFloat accpassTitleLableHeight = accpassTitleLableSize.height;
            CGFloat accpassTitleLableOX = 10;
            CGFloat accpassTitleLableOY = 10;
            
            accpassTitleLable.frame = CGRectMake(accpassTitleLableOX, accpassTitleLableOY, accpassTitleLableWidth, accpassTitleLableHeight);
            
            tempHeight = tempHeight + accpassViewH;
            
            groupViewHight = [groupView loginPwdVerification];
            allHeight = allHeight + groupViewHight + groupViewHight;
            loginPwdBtn = groupView.loginPwdVerificationBtn;
            accPwdTextField = groupView.loginPwdVerificationTextField;
            accPwdTextField.tag = textFieldTag;
            [accPwdTextField setMinLenght:@"6"];
            [accPwdTextField setMaxLenght:@"12"];
            loginPwdBtn.tag = 404; //杉德卡账号密码的眼镜按钮
            [textFieldArray addObject:accPwdTextField];
            [loginPwdBtn addTarget:self action:@selector(buttonActionToDoSomething:) forControlEvents:UIControlEventTouchUpInside];
            
        }
        
        if ([@"sms" isEqualToString:type]) {
            NSDictionary *smsDic = [dic objectForKey:@"sms"];
            
            groupViewHight = [groupView shortMsgAndPhoneNumVerification];
            allHeight = allHeight + groupViewHight;
            phoneNumTextField = groupView.phoneNumVerificationTextField;
            shortMsgBtn = groupView.shortMsgVerificationBtn;
            shortMsgTextField = groupView.shortMsgVerificationTextField;
            
            shortMsgBtn.tag = 201;
            phoneNumTextField.tag = textFieldTag;
            [phoneNumTextField setMinLenght:@"0"];
            [phoneNumTextField setMaxLenght:@"11"];
            phoneNumTextField.text = [smsDic objectForKey:@"phoneNo"];
            textFieldTag = textFieldTag + 1;
            shortMsgTextField.tag = textFieldTag;
            [shortMsgTextField setMinLenght:@"0"];
            [shortMsgTextField setMaxLenght:@"6"];
            
            [shortMsgBtn addTarget:self action:@selector(buttonActionToDoSomething:) forControlEvents:UIControlEventTouchUpInside];
            
            CGSize shortMsgBtnSize = shortMsgBtn.frame.size;
            shortMsgBtnW = shortMsgBtnSize.width;
            shortMsgBtnH = shortMsgBtnSize.height;
            
            [textFieldArray addObject:phoneNumTextField];
            [textFieldArray addObject:shortMsgTextField];
        }
        
        if ([@"img" isEqualToString:type]) {
            groupViewHight = [groupView pictureVerification];
            allHeight = allHeight + groupViewHight;
            pictureBtn = groupView.pictureVerificationBtn;
            pictureBtn.tag = 203;
            pictureNumTextField = groupView.pictureVerificationTextField;
            pictureNumTextField.tag = textFieldTag;
            
            [textFieldArray addObject:pictureNumTextField];
        }
        
        if ([@"bankCard" isEqualToString:type]) {
            NSDictionary *bankCardDic = [dic objectForKey:@"bankCard"];
            
            UIView *bankView = [[UIView alloc] init];
            bankView.backgroundColor = RGBA(242, 242, 242, 1.0);
            [view addSubview:bankView];
            
            
            NSMutableAttributedString *bankTitleInfo = [[NSMutableAttributedString alloc] initWithString:@"请输入与已绑定银行卡信息"];
            [bankTitleInfo addAttribute:NSForegroundColorAttributeName value:titleColor range:NSMakeRange(0 , 4)];
            [bankTitleInfo addAttribute:NSForegroundColorAttributeName value:RGBA(230, 2, 2, 1.0) range:NSMakeRange(4, 6)];
            [bankTitleInfo addAttribute:NSForegroundColorAttributeName value:titleColor range:NSMakeRange(10, 2)];
            
            UILabel *bankTitleLable = [[UILabel alloc] init];
            bankTitleLable.attributedText = bankTitleInfo;
            bankTitleLable.font = [UIFont systemFontOfSize:titleSize];
            [bankView addSubview:bankTitleLable];
            
            CGFloat bankTitleLableWidth = viewSize.width - 2 * 10;
            CGSize bankTitleLableSize = [bankTitleLable sizeThatFits:CGSizeMake(bankTitleLableWidth, MAXFLOAT)];
            
            CGFloat bankViewW = viewSize.width;
            CGFloat bankViewH = bankTitleLableSize.height + 2 * 10;
            CGFloat bankViewOX = 0;
            CGFloat bankViewOY = allHeight;
            
            bankView.frame = CGRectMake(bankViewOX, bankViewOY, bankViewW, bankViewH);
            
            CGFloat bankTitleLableHeight = bankTitleLableSize.height;
            CGFloat bankTitleLableOX = 10;
            CGFloat bankTitleLableOY = 10;
            
            bankTitleLable.frame = CGRectMake(bankTitleLableOX, bankTitleLableOY, bankTitleLableWidth, bankTitleLableHeight);
            
            tempHeight = tempHeight + bankViewH;
            
            groupViewHight = [groupView bankCardVerification];
            allHeight = allHeight + groupViewHight + bankViewH;
            bankNameLabel = groupView.bankNameContentVerificationLabel;
            bankNameLabel.text = [bankCardDic objectForKey:@"openAccountBank"];
            bankCardTextField = groupView.bankCardVerificationTextField;
            [bankCardTextField setMinLenght:@"16"];
            [bankCardTextField setMaxLenght:@"19"];
            bankCardTextField.tag = textFieldTag;
            
            [textFieldArray addObject:bankCardTextField];
        }
        
        if ([@"question" isEqualToString:type]) {
            questionFlag = YES;
            NSArray *questionArray = [dic objectForKey:@"question"];
            NSInteger questionArrayCount = [questionArray count];
            
            for (int j = 0; j < questionArrayCount; j++) {
                
                NSDictionary *questionDic = questionArray[j];
                
                GroupView *groupView = [[GroupView alloc] initWithFrame:self.view.frame];
                
                textFieldTag = textFieldTag + 1;
                groupViewHight = [groupView miBaoQuestionVerification];
                allHeight = allHeight + groupViewHight;
                questionTextField = groupView.miBaoAnswerVerificationTextField;
                questionTextField.tag = textFieldTag;
                questionTitleLabel = groupView.miBaoTitleLabel;
                questionlabel = groupView.miBaoTQuestionLabel;
                questionBtn = groupView.miBaobtn;
                questionBtn.tag = 301 + j;
                questionTitleLabel.text = [NSString stringWithFormat:@"密保问题%@", [questionDic objectForKey:@"questionNo"]];
                questionlabel.text = [NSString stringWithFormat:@"%@", [questionDic objectForKey:@"question"]];
                
                
                viewHeight = groupViewHight;
                
                if (j == 0) {
                    tempHeight = tempHeight;
                } else {
                    tempHeight = tempHeight + groupViewHight;
                }
                groupView.frame = CGRectMake(0, tempHeight, viewSize.width, groupViewHight);
                
                [view addSubview:groupView];
                
                [textFieldArray addObject:questionTextField];
            }
            
            return allHeight;
        }
        
        if ([@"identity" isEqualToString:type]) {
            UIView *identityView = [[UIView alloc] init];
            identityView.backgroundColor = RGBA(242, 242, 242, 1.0);
            [view addSubview:identityView];
            
            
            NSMutableAttributedString *identityTitleInfo = [[NSMutableAttributedString alloc] initWithString:@"请输入与注册信息一致的证件号码"];
            [identityTitleInfo addAttribute:NSForegroundColorAttributeName value:titleColor range:NSMakeRange(0 , 4)];
            [identityTitleInfo addAttribute:NSForegroundColorAttributeName value:RGBA(230, 2, 2, 1.0) range:NSMakeRange(4, 6)];
            [identityTitleInfo addAttribute:NSForegroundColorAttributeName value:titleColor range:NSMakeRange(10, 5)];
            
            UILabel *identityTitleLable = [[UILabel alloc] init];
            identityTitleLable.attributedText = identityTitleInfo;
            identityTitleLable.font = [UIFont systemFontOfSize:titleSize];
            [identityView addSubview:identityTitleLable];
            
            CGFloat identityTitleLableWidth = viewSize.width - 2 * 10;
            CGSize identityTitleLableSize = [identityTitleLable sizeThatFits:CGSizeMake(identityTitleLableWidth, MAXFLOAT)];
            
            CGFloat identityViewW = viewSize.width;
            CGFloat identityViewH = identityTitleLableSize.height + 2 * 10;
            CGFloat identityViewOX = 0;
            CGFloat identityViewOY = allHeight;
            
            identityView.frame = CGRectMake(identityViewOX, identityViewOY, identityViewW, identityViewH);
            
            CGFloat identityTitleLableHeight = identityTitleLableSize.height;
            CGFloat identityTitleLableOX = 10;
            CGFloat identityTitleLableOY = 10;
            
            identityTitleLable.frame = CGRectMake(identityTitleLableOX, identityTitleLableOY, identityTitleLableWidth, identityTitleLableHeight);
            
            tempHeight = tempHeight + identityViewH;
            
            groupViewHight = [groupView realNameAndIDCardVerification];
            allHeight = allHeight + groupViewHight + identityViewH;
            realNameTextField = groupView.realNameVerificationTextField;
            realNameTextField.tag = textFieldTag;
            textFieldTag = textFieldTag + 1;
            IDCardTextField = groupView.IDCardVerificationTextField;
            IDCardTextField.tag = textFieldTag;
            [realNameTextField setMinLenght:@"4"];
            [realNameTextField setMaxLenght:@"12"];
            
            [IDCardTextField setMinLenght:@"18"];
            [IDCardTextField setMaxLenght:@"18"];
            [textFieldArray addObject:realNameTextField];
            [textFieldArray addObject:IDCardTextField];
        }
        
        if ([@"cardCheckCode" isEqualToString:type]) {
            
        }
        
        if ([@"creditCard" isEqualToString:type]) {
            
        }
        
        if (i == 0 && questionFlag == NO) {
            groupView.frame = CGRectMake(0, 0, viewSize.width, groupViewHight);
        } else {
            if (i > 0 && i < authToolsArrayCount) {
                UIView *lineView = [[UIView alloc] init];
                lineView.frame = CGRectMake(leftRightSpace, tempHeight, viewSize.width - leftRightSpace, lineViewHeight);
                lineView.backgroundColor = lineViewColor;
                [view addSubview:lineView];
                tempHeight = tempHeight + lineViewHeight;
                tempLineViewHeight =  tempLineViewHeight + lineViewHeight;
            }
            
            groupView.frame = CGRectMake(0, tempHeight, viewSize.width, groupViewHight);
        }
        
        
        [view addSubview:groupView];
        
        
        
        
        
        
//        if ([@"paypass" isEqualToString:type]) {
//            
//            groupViewHight = [groupView loginPwdVerification];
//            allHeight = allHeight + groupViewHight;
//            //            payPwdTextField = groupView.loginPwdVerificationTextField;
//        }
//        
//        if ([@"gesture" isEqualToString:type]) {
//            
//            groupViewHight = [groupView shortMsgAndPhoneNumVerification];
//            allHeight = allHeight + groupViewHight;
//            
//        }
        
        
    }
    
    return allHeight + tempLineViewHeight;
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
    if (phoneNumTextField.text.length != [phoneNumTextField.maxLenght intValue]) {
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
    if (phoneNumTextField.text.length != [phoneNumTextField.maxLenght intValue]) {
        return [Tool showDialog:@"输入的手机号码格式不正确，请重新输入。"];
    }
    
    if (shortMsgTextField) {
        if (shortMsgTextField.text.length != [shortMsgTextField.maxLenght intValue] ) {
            return [Tool showDialog:@"请输入6位正确短信验证码，请重新输入。"];
        }
    }
    
    if (loginPwdTextField) {
        if (loginPwdTextField.text.length < [loginPwdTextField.minLenght intValue] || loginPwdTextField.text.length > [loginPwdTextField.maxLenght intValue] ) {
            [self changeBtnBackGround:nil index:1];
            return [Tool showDialog:@"输入的密码格式不正确，请重新输入。"];
        }
        
        if (![NSRegularExpression validatePasswordNumAndLetter:loginPwdTextField.text]) {
            [self changeBtnBackGround:nil index:1];
            return [Tool showDialog:@"请输入字母数字组合的密码"];
            
        }
    }
    
    if (payPwdTextField) {
        
    }
    
    if (IDCardTextField) {
        
    }
    
    if (pictureNumTextField) {
        
    }
    
    if (realNameTextField) {
        
    }
    
    if (bankCardTextField) {
        
    }
    
    if (questionTextField) {
        if (questionTextField.text.length <= 0) {
            return [Tool showDialog:@"请输入问题答案格式不正确，请重新输入。"];
        }
    }
    
    if (cvnTextField) {
        
    }
    
    if (expiryTextField) {
        
    }
    
    
    
    
    
    
    
    
    
    
    
//    if ([loginPwdTextField.text rangeOfString:@" "].location != NSNotFound) {
//        return [Tool showDialog:@"不能包含空格，请重新输入。"];
//    }
//    

    
    if (payPassTag == YES) {
        [payView showPayTool];
    } else {
        [self vericationSuccessBlock:^(NSArray *paramArr){
            
        } errorBlock:^(NSArray *paramArr){
            
        }];
    }
}

#pragma mark - SDPayViewDelegate
- (void)payViewPwd:(NSString *)pwdStr paySuccessView:(SDPaySuccessAnimationView *)successView{
    
    //动画开始
    [successView animationStart];
    
    _payPassCodeStr = pwdStr;
    [self vericationSuccessBlock:^(NSArray *paramArr){
        //修改成功
        [successView animationSuccess];
        dispatch_time_t delayTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5f * NSEC_PER_SEC));
        dispatch_after(delayTime, dispatch_get_main_queue(), ^{
            if ([@"01000701" isEqualToString:tokenType] || [@"01000801" isEqualToString:tokenType]) {
                MiBaoSetViewController *mMiBaoSetViewController = [[MiBaoSetViewController alloc] init];
                [self.navigationController pushViewController:mMiBaoSetViewController animated:YES];
            } else if ([@"01000501" isEqualToString:tokenType] || [@"01000401" isEqualToString:tokenType]) {
                
                FindLoginPwdViewController *mFindLoginPwdViewController = [[FindLoginPwdViewController alloc] init];
                [self.navigationController pushViewController:mFindLoginPwdViewController animated:YES];
            } else if ([@"01000601" isEqualToString:tokenType]) {
                [self getRegAuthTools];
            }
        });
    } errorBlock:^(NSArray *paramArr){
        //修改失败
        [successView animationStopClean];
        //[payView hidPayTool];
    }];
    
    
}
- (void)payViewForgetPwd:(NSString *)type{
    
    if ([type isEqualToString:PAYTOOL_PAYPASS]) {
        //修改支付密码
        VerificationModeViewController *mVerificationModeViewController = [[VerificationModeViewController alloc] init];
        mVerificationModeViewController.tokenType = @"01000601";
        [self.navigationController pushViewController:mVerificationModeViewController animated:YES];
    }
    if ([type isEqualToString:PAYTOOL_ACCPASS]) {
        //修改杉德卡密码
    }
}


- (void)payPwd:(NSString *)param
{
  
}

/**
 *@brief 验证
 */
- (void)vericationSuccessBlock:(VerificationStateBlock)successBlock errorBlock:(VerificationStateBlock)errorBlock
{
    HUD = [SDMBProgressView showSDMBProgressOnlyLoadingINViewImg:self.view];
    [HUD hidden];
    [SDRequestHelp shareSDRequest].HUD = HUD;
    [SDRequestHelp shareSDRequest].controller = self;
    [[SDRequestHelp shareSDRequest] dispatchGlobalQuque:^{
        __block BOOL error = NO;
        
        NSString *vericationId = [NSString stringWithFormat:@"%@", [authGroupDic objectForKey:@"id"]];
        
        NSString *authTools;
        
        if ([@"0" isEqualToString:vericationId]) {
            
        } else {
            authTools = [self assembleRequestString:authToolsArray];
        }
        
        [SDLog logTest:authTools];
        paynuc.set("authTools", [authTools UTF8String]);
        [[SDRequestHelp shareSDRequest] requestWihtFuncName:@"authTool/setAuthTools/v1" errorBlock:^(SDRequestErrorType type) {
            error = YES;
            [[SDRequestHelp shareSDRequest] dispatchToMainQueue:^{
                errorBlock(nil);
                if (type == respCodeErrorType) {
                    [self.navigationController popViewControllerAnimated:YES];
                }
            }];
        } successBlock:^{
            [[SDRequestHelp shareSDRequest] dispatchToMainQueue:^{
                [HUD hidden];
                successBlock(nil);
            }];
        }];
        if (error) return ;
    }];
}

/**
 *@brief 配置数据
 *@param arrayParam NSMutableArray 参数：request数组
 *@return NSString
 */
- (NSString *)assembleRequestString:(NSMutableArray *)arrayParam
{
    NSMutableArray *authToolsArray1 = [[NSMutableArray alloc] init];
    
    NSInteger count = [arrayParam count];
    for (int i = 0; i < count; i++) {
        NSMutableDictionary *dic = arrayParam[i];
        NSMutableDictionary *authToolsDic = [NSMutableDictionary dictionaryWithDictionary:dic];
        NSString *type = [dic objectForKey:@"type"];
        
        if ([@"sms" isEqualToString:type]) {
            [authToolsDic removeObjectForKey:@"sms"];
            NSMutableDictionary *smsDic = [[NSMutableDictionary alloc] init];
            [smsDic setValue:shortMsgTextField.text forKey:@"code"];
            [smsDic setValue:phoneNumTextField.text forKey:@"phoneNo"];
            [authToolsDic setObject:smsDic forKey:@"sms"];
            
            [authToolsArray1 addObject:authToolsDic];
        } else if ([@"loginpass" isEqualToString:type]) {
            [authToolsDic removeObjectForKey:@"pass"];
            NSMutableDictionary *loginpassDic = [[NSMutableDictionary alloc] init];
            [loginpassDic setValue:[NSString stringWithUTF8String:paynuc.lgnenc([loginPwdTextField.text UTF8String]).c_str()] forKey:@"password"];
            [loginpassDic setValue:@"" forKey:@"description"];
            [loginpassDic setValue:@"" forKey:@"encryptType"];
            [loginpassDic setValue:@"" forKey:@"regular"];
            [authToolsDic setObject:loginpassDic forKey:@"pass"];
        
            [authToolsArray1 addObject:authToolsDic];
        } else if ([@"paypass" isEqualToString:type]) {
            [authToolsDic removeObjectForKey:@"pass"];
            NSMutableDictionary *paypassDic = [[NSMutableDictionary alloc] init];
            [paypassDic setValue:[[PayNucHelper sharedInstance] pinenc:_payPassCodeStr type:@"paypass"]  forKey:@"password"];
            [paypassDic setValue:@"" forKey:@"description"];
            [paypassDic setValue:@"" forKey:@"encryptType"];
            [paypassDic setValue:@"" forKey:@"regular"];
            [authToolsDic setObject:paypassDic forKey:@"pass"];
            
            [authToolsArray1 addObject:authToolsDic];
        } else if ([@"gesture" isEqualToString:type]) {
            
        } else if ([@"question" isEqualToString:type]) {
            NSArray *dataArray = [dic objectForKey:@"question"];
            [authToolsDic removeObjectForKey:@"question"];
            NSInteger dataArrayCount = [dataArray count];
            
            NSMutableArray *questionArray = [[NSMutableArray alloc] init];
            
            //用于过滤其他鉴权textfiled
            NSMutableArray *questionTextArr = [NSMutableArray arrayWithCapacity:0];
            for (int i = 0; i<textFieldArray.count; i++) {
                if ([[textFieldArray[i] placeholder] rangeOfString:@"答案"].location !=NSNotFound) {
                    [questionTextArr addObject:textFieldArray[i]];
                }
            }
            //设置报文
            for (int j = 0; j < dataArrayCount; j++) {
                    NSDictionary *dataDic = dataArray[j];
                    questionTextField = questionTextArr[j];
                    
                    NSMutableDictionary *questionDic = [[NSMutableDictionary alloc] init];
                    [questionDic setValue:[dataDic objectForKey:@"question"] forKey:@"question"];
                    [questionDic setValue:[dataDic objectForKey:@"questionNo"] forKey:@"questionNo"];
                    [questionDic setValue:questionTextField.text forKey:@"answer"];
                    [questionArray addObject:questionDic];
            }
            
            [authToolsDic setObject:questionArray forKey:@"question"];
            
            [authToolsArray1 addObject:authToolsDic];
            
        } else if ([@"identity" isEqualToString:type]) {
            [authToolsDic removeObjectForKey:@"identity"];
            NSMutableDictionary *identityDic = [[NSMutableDictionary alloc] init];
            [identityDic setValue:IDCardTextField.text  forKey:@"identityNo"];
            [identityDic setValue:@"01" forKey:@"type"];
            [authToolsDic setObject:identityDic forKey:@"identity"];
            
            [authToolsArray1 addObject:authToolsDic];
        } else if ([@"img" isEqualToString:type]) {
            
        } else if ([@"bankCard" isEqualToString:type]) {
            [authToolsDic removeObjectForKey:@"bankCard"];
            NSMutableDictionary *bankCardDic = [[NSMutableDictionary alloc] init];
            [bankCardDic setValue:bankCardTextField.text  forKey:@"bankCardNo"];
            [bankCardDic setValue:bankNameLabel.text forKey:@"openAccountBank"];
            [authToolsDic setObject:bankCardDic forKey:@"bankCard"];
            
            [authToolsArray1 addObject:authToolsDic];
        }else {
            
        }
    }
    
    return [[PayNucHelper sharedInstance] arrayToJSON:authToolsArray1];
}

/**
 *@brief 获取鉴权工具
 *@return NSArray
 */
- (void)getRegAuthTools
{
    HUD = [SDMBProgressView showSDMBProgressOnlyLoadingINViewImg:self.view];
    [SDRequestHelp shareSDRequest].HUD = HUD;
    [SDRequestHelp shareSDRequest].controller = self;
    [[SDRequestHelp shareSDRequest] dispatchGlobalQuque:^{
        __block BOOL error = NO;

        [[SDRequestHelp shareSDRequest] requestWihtFuncName:@"authTool/getRegAuthTools/v1" errorBlock:^(SDRequestErrorType type) {
            error = YES;
        } successBlock:^{
            [[SDRequestHelp shareSDRequest] dispatchToMainQueue:^{
                [HUD hidden];
                
                NSString *tempAuthTools = [NSString stringWithUTF8String:paynuc.get("regAuthTools").c_str()];
                NSArray *tempAuthToolsArray = [[PayNucHelper sharedInstance] jsonStringToArray:tempAuthTools];
                
                for (int i = 0; i < tempAuthToolsArray.count; i++) {
                    [_regAuthToolsArray addObject:tempAuthToolsArray[i]];
                }
                
                if ([_regAuthToolsArray count] <= 0) {
                    [Tool showDialog:@"获取失败"];
                } else {
                    SettingPayPwdViewController *mSettingPayPwdViewController = [[SettingPayPwdViewController alloc] init];
                    mSettingPayPwdViewController.regAuthToolsArray = _regAuthToolsArray;
                    mSettingPayPwdViewController.registerFlag = NO;
                    [self.navigationController pushViewController:mSettingPayPwdViewController animated:YES];
                }

            }];
        }];
        if (error) return ;
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
    
    if (accPwdTextField) {
        [[NSNotificationCenter defaultCenter] removeObserver:self name:UITextFieldTextDidChangeNotification object:accPwdTextField];
    }
    
    if(IDCardTextField) {
        [[NSNotificationCenter defaultCenter] removeObserver:self name:UITextFieldTextDidChangeNotification object:IDCardTextField];
    }
    
    if (realNameTextField) {
        [[NSNotificationCenter defaultCenter] removeObserver:self name:UITextFieldTextDidChangeNotification object:realNameTextField];
    }
    
    if (pictureNumTextField) {
        [[NSNotificationCenter defaultCenter] removeObserver:self name:UITextFieldTextDidChangeNotification object:pictureNumTextField];
    }
    
    for (int i = 0; i < textFieldArray.count; i++) {
        
        questionTextField = textFieldArray[i];
        
        if (questionTextField) {
            [[NSNotificationCenter defaultCenter] removeObserver:self name:UITextFieldTextDidChangeNotification object:questionTextField];
        }
    }
    
    if (bankCardTextField) {
        [[NSNotificationCenter defaultCenter] removeObserver:self name:UITextFieldTextDidChangeNotification object:bankCardTextField];
    }
    
    if (payPwdTextField) {
        [[NSNotificationCenter defaultCenter] removeObserver:self name:UITextFieldTextDidChangeNotification object:payPwdTextField];
    }
    
    if (cvnTextField) {
        [[NSNotificationCenter defaultCenter] removeObserver:self name:UITextFieldTextDidChangeNotification object:cvnTextField];
    }
    
    if (expiryTextField) {
        [[NSNotificationCenter defaultCenter] removeObserver:self name:UITextFieldTextDidChangeNotification object:expiryTextField];
    }
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
