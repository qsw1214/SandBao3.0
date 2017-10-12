//
//  SandPwdViewController.m
//  sandbao
//
//  Created by tianNanYiHao on 2017/3/21.
//  Copyright © 2017年 sand. All rights reserved.
//

#import "SandPwdViewController.h"
#import "GroupView.h"

#import "PayNucHelper.h"
#import "SDLog.h"

#import "SandPwdSecondViewController.h"

#define navViewColor RGBA(249, 249, 249, 1.0)

#define lineViewColor RGBA(237, 237, 237, 1.0)
#define textFiledColor RGBA(83, 83, 83, 1.0)
#define btnColor RGBA(255, 97, 51, 1.0)

@interface SandPwdViewController ()<UITextFieldDelegate>
{
    NavCoverView *navCoverView;
}

@property (nonatomic, assign) CGSize viewSize;
@property (nonatomic, assign) CGFloat viewHeight;
@property (nonatomic, assign) CGFloat moveTop;
@property (nonatomic, assign) CGFloat leftRightSpace;
@property (nonatomic, assign) CGFloat textFieldTextSize;
@property (nonatomic, assign) CGFloat btnTextSize;
@property (nonatomic, assign) CGFloat shortMsgBtnW;
@property (nonatomic, assign) CGFloat shortMsgBtnH;
@property (nonatomic, assign) CGFloat btnW;
@property (nonatomic, assign) CGFloat btnH;
@property (nonatomic, assign) BOOL showPwdFlag;
@property (nonatomic, assign) int timeOut;
@property (nonatomic, assign) int timeCount;

@property (nonatomic, strong) SDMBProgressView *HUD;

@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UIButton *loginPwdBtn;
@property (nonatomic, strong) UIButton *button;

@property (nonatomic, strong) NSTimer *timer;

@property (nonatomic, strong) UITextField *phoneNumTextField;
@property (nonatomic, strong) UITextField *shortMsgTextField;
@property (nonatomic, strong) UITextField *loginPwdTextField;
@property (nonatomic, strong) UITextField *payPwdTextField;
@property (nonatomic, strong) UITextField *accPwdTextField;
@property (nonatomic, strong) UITextField *IDCardTextField;
@property (nonatomic, strong) UITextField *pictureNumTextField;
@property (nonatomic, strong) UITextField *bankCardTextField;
@property (nonatomic, strong) UITextField *questionTextField;

@property (nonatomic, strong) UIButton *shortMsgBtn;
@property (nonatomic, strong) UIButton *pictureBtn;
@property (nonatomic, strong) NSMutableArray *authToolsArray;
@property (nonatomic, strong) NSArray *regAuthToolsArray;
@property (nonatomic, assign) CGFloat textFieldTag;
@property (nonatomic, strong) NSMutableArray *textFieldArray;


@end

@implementation SandPwdViewController

@synthesize viewSize;
@synthesize viewHeight;
@synthesize moveTop;
@synthesize leftRightSpace;
@synthesize textFieldTextSize;
@synthesize btnTextSize;
@synthesize shortMsgBtnW;
@synthesize shortMsgBtnH;
@synthesize btnW;
@synthesize btnH;
@synthesize showPwdFlag;
@synthesize timeOut;
@synthesize timeCount;


@synthesize HUD;

@synthesize scrollView;
@synthesize loginPwdBtn;
@synthesize button;

@synthesize timer;

@synthesize phoneNumTextField;
@synthesize shortMsgTextField;
@synthesize loginPwdTextField;
@synthesize payPwdTextField;
@synthesize accPwdTextField;
@synthesize IDCardTextField;
@synthesize pictureNumTextField;
@synthesize bankCardTextField;
@synthesize questionTextField;

@synthesize shortMsgBtn;
@synthesize pictureBtn;
@synthesize authToolsArray;
@synthesize regAuthToolsArray;
@synthesize textFieldTag;
@synthesize textFieldArray;

@synthesize accountDic;

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view setBackgroundColor:RGBA(255, 255, 255, 1.0)];
    viewSize = self.view.bounds.size;
    leftRightSpace = 15;
    timeOut = 90;
    
    textFieldArray = [[NSMutableArray alloc] init];
    authToolsArray = [[NSMutableArray alloc] init];
    
    
    

    
    
    
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
    navCoverView = [NavCoverView shareNavCoverView:CGRectMake(0, 0, viewSize.width, controllerTop) title:@"修改杉德卡密码"];
    [self.view addSubview:navCoverView];
    
    // 2.设置左边的返回item
    UIImage *leftImage = [UIImage imageNamed:@"back"];
    UIButton *leftBarBtn = [[UIButton alloc] init];
    leftBarBtn.frame = CGRectMake(0, 20 + (40 - leftImage.size.height) / 2, leftImage.size.width, leftImage.size.height);
    leftBarBtn.tag = 101;
    [leftBarBtn setImage:[UIImage imageNamed:@"back"] forState:UIControlStateNormal];
    [leftBarBtn setImage:[UIImage imageNamed:@"back"] forState:UIControlStateHighlighted];
    [leftBarBtn addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
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
    [scrollView setBackgroundColor:RGBA(255, 255, 255, 1.0)];
    [view addSubview:scrollView];
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    //input
    UIView *inputView = [[UIView alloc] init];
    inputView.backgroundColor = RGBA(255, 255, 255, 1.0);
    [scrollView addSubview:inputView];
    
    UIView *authToolsView = [[UIView alloc] init];
    [authToolsView setBackgroundColor:[UIColor clearColor]];
    CGFloat authToolsViewHeight = [self addAuthToolsView:authToolsView];
    [inputView addSubview:authToolsView];
    
    //按钮
    button = [[UIButton alloc] init];
    [button setTag:1];
    [button setTitle:@"确定" forState: UIControlStateNormal];
    [button setTitleColor:RGBA(255, 255, 255, 1.0) forState:UIControlStateNormal];
    button.titleLabel.font = [UIFont systemFontOfSize:btnTextSize];
    [button.layer setMasksToBounds:YES];
    button.layer.cornerRadius = 5.0;
    [button addTarget:self action:@selector(buttonActionToDoSomething:) forControlEvents:UIControlEventTouchUpInside];
    [scrollView addSubview:button];
    
    //设置控件的位置和大小

    CGFloat upDownSpace = 15;
    CGFloat scrollViewTop = 10;
    CGFloat commWidth = viewSize.width - 2 * leftRightSpace;
    CGFloat scrollViewH = viewSize.height - controllerTop;
    CGFloat inputViewH = authToolsViewHeight;
    
    CGSize shortMsgBtnSize = shortMsgBtn.frame.size;
    shortMsgBtnW = shortMsgBtnSize.width;
    shortMsgBtnH = shortMsgBtnSize.height;
    
    CGSize buttonSize = [button.titleLabel sizeThatFits:CGSizeMake(commWidth, MAXFLOAT)];
    CGFloat buttonHeight = buttonSize.height + 2 * upDownSpace;
    btnW = commWidth;
    btnH = buttonHeight;
    
    [self listenNotifier];
    [self textFiledEditChanged];
    [self setInputResponderChain];
    
    [scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(view).offset(controllerTop);
        make.centerX.equalTo(view);
        make.size.mas_equalTo(CGSizeMake(viewSize.width, scrollViewH));
    }];
    
    
    [inputView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(scrollView).offset(scrollViewTop);
        make.centerX.equalTo(scrollView);
        make.size.mas_equalTo(CGSizeMake(viewSize.width, inputViewH));
    }];
    
    [authToolsView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(inputView).offset(0);
        make.centerX.equalTo(inputView);
        make.size.mas_equalTo(CGSizeMake(viewSize.width, authToolsViewHeight));
    }];
    
    [button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(inputView.mas_bottom).offset(60);
        make.centerX.equalTo(scrollView);
        make.size.mas_equalTo(CGSizeMake(commWidth, buttonHeight));
    }];
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
            [self dismissKeyboard];
            [self verificationInput];

        }
            break;
        case 2:
        {
            //            [self dismissKeyboard];
            //            shortMsgTextField.text = @"";
            //            timeCount = timeOut;
            //            [self shortMsg];
            
        }
            break;
        case 3:
        {
//            [self textFiledEditChanged];
        }
            break;
        case 4:
        {
//            [self dismissKeyboard];
//            [self verificationInput];
        }
            break;
        case 101:
        {
            
            UIViewController *vc = self.navigationController.viewControllers[1];
            [self.navigationController popToViewController:vc animated:YES];
            
        }
            break;
        case 404:
        {
            [self dismissKeyboard];
            [self changePwdShowState:1];
        }
            break;
        default:
            break;
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
    
    if (accPwdTextField) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFiledEditChanged:) name:UITextFieldTextDidChangeNotification object:accPwdTextField];
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
        if (textField.tag == 1 || textField.tag == 2) {
            if (![NSRegularExpression validatePureNum:[content substringWithRange:NSMakeRange(lenght-1, 1)]]) {
                [self dismissKeyboard];
                [Tool showDialog:@"请输入0-9的数字"];
                textField.text = nil;
            }
        }
        if (textField.tag == 3) {
            
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
    
    if (accPwdTextField) {
        if ([@"" isEqualToString:accPwdTextField.text] || accPwdTextField.text == nil) {
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
            
            
            [button setBackgroundImage:[UIImage imageWithColor: RGBA(65, 131, 215, 1.0) size:CGSizeMake(btnW, btnH)] forState:UIControlStateNormal];
            
            [button setBackgroundImage:[UIImage imageWithColor: RGBA(65, 131, 215, 1.0) size:CGSizeMake(btnW, btnH)] forState:UIControlStateHighlighted];
            
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
            [button setBackgroundImage:[UIImage imageWithColor: RGBA(65, 131, 215, 1.0) size:CGSizeMake(btnW, btnH)] forState:UIControlStateNormal];
            
            [button setBackgroundImage:[UIImage imageWithColor: RGBA(65, 131, 215, 1.0) size:CGSizeMake(btnW, btnH)] forState:UIControlStateHighlighted];
            
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
    accPwdTextField.keyboardType = UIKeyboardTypeNumberPad;
    shortMsgTextField.keyboardType = UIKeyboardTypeNumberPad;
    UITextField *textField = [textFieldArray lastObject];
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
 *@return NSArray
 */
- (void)load
{
    HUD = [SDMBProgressView showSDMBProgressOnlyLoadingINViewImg:self.view];
    [SDRequestHelp shareSDRequest].HUD = HUD;
    [SDRequestHelp shareSDRequest].controller = self;
    [[SDRequestHelp shareSDRequest] dispatchGlobalQuque:^{
        __block BOOL error = NO;
        paynuc.set("tTokenType", "01001901");
        [[SDRequestHelp shareSDRequest] requestWihtFuncName:@"token/getTtoken/v1" errorBlock:^(SDRequestErrorType type) {
            error = YES;
        } successBlock:^{
            
        }];
        if (error) return ;


        
        
        
        
        NSString *account = [[PayNucHelper sharedInstance] dictionaryToJson:accountDic];
        [SDLog logTest:account];
        paynuc.set("account", [account UTF8String]);
        [[SDRequestHelp shareSDRequest] requestWihtFuncName:@"card/queryCardDetail/v1" errorBlock:^(SDRequestErrorType type) {
            error = YES;
            [[SDRequestHelp shareSDRequest] dispatchToMainQueue:^{
                if (type == respCodeErrorType) {
                    [self.navigationController popViewControllerAnimated:YES];
                }
            }];
        } successBlock:^{
            
        }];
        if (error) return ;
        

        
        [[SDRequestHelp shareSDRequest] requestWihtFuncName:@"authTool/getAuthTools/v1" errorBlock:^(SDRequestErrorType type) {
            error = YES;
        } successBlock:^{
            [[SDRequestHelp shareSDRequest] dispatchToMainQueue:^{
                [HUD hidden];
                
                NSString *tempAuthTools = [NSString stringWithUTF8String:paynuc.get("authTools").c_str()];
                NSArray *tempAuthToolsArray = [[PayNucHelper sharedInstance] jsonStringToArray:tempAuthTools];
                
                for (int i = 0; i < tempAuthToolsArray.count; i++) {
                    [authToolsArray addObject:tempAuthToolsArray[i]];
                }
                
                [self addView:self.view];

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
    CGFloat lineViewHeight = 1;
    CGFloat tempHeight = 0;
    CGFloat allHeight = 0;
    CGFloat groupViewHight = 0;
    
    NSInteger authToolsArrayCount = [authToolsArray count];
    for (int i = 0; i < authToolsArrayCount; i++) {
        NSMutableDictionary *dic = authToolsArray[i];
        NSString *type = [dic objectForKey:@"type"];
        
        textFieldTag = textFieldTag + 1;
        
        GroupView *groupView = [[GroupView alloc] initWithFrame:self.view.frame];
        groupView.groupViewStyle = GroupViewStyleYes;
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
            
            textFieldTag = textFieldTag + 1;
            shortMsgTextField.tag = textFieldTag;
            [shortMsgTextField setMinLenght:@"0"];
            [shortMsgTextField setMaxLenght:@"6"];
            
            [shortMsgBtn addTarget:self action:@selector(buttonActionToDoSomething:) forControlEvents:UIControlEventTouchUpInside];
            
            [textFieldArray addObject:phoneNumTextField];
            [textFieldArray addObject:shortMsgTextField];
        }
        
        if ([@"loginpass" isEqualToString:type]) {
            
            groupViewHight = [groupView loginPwdVerification];
            allHeight = allHeight + groupViewHight;
            loginPwdBtn = groupView.loginPwdVerificationBtn;
            loginPwdTextField = groupView.loginPwdVerificationTextField;
            loginPwdTextField.tag = textFieldTag;
            
            [textFieldArray addObject:loginPwdTextField];
        }
        
        if ([@"paypass" isEqualToString:type]) {
            
            groupViewHight = [groupView loginPwdVerification];
            allHeight = allHeight + groupViewHight;
            payPwdTextField = groupView.loginPwdVerificationTextField;
            payPwdTextField.tag = textFieldTag;
            
            [textFieldArray addObject:payPwdTextField];
        }
        
        if ([@"accpass" isEqualToString:type]) {
            
            groupViewHight = [groupView loginPwdVerification];
            allHeight = allHeight + groupViewHight;
            loginPwdBtn = groupView.loginPwdVerificationBtn;
            accPwdTextField = groupView.loginPwdVerificationTextField;
            accPwdTextField.placeholder = @"请输入0-9的数字密码";
            accPwdTextField.tag = textFieldTag;
            loginPwdBtn.tag = 404;
            [accPwdTextField setMinLenght:@"6"];
            [accPwdTextField setMaxLenght:@"6"];
             [loginPwdBtn addTarget:self action:@selector(buttonActionToDoSomething:) forControlEvents:UIControlEventTouchUpInside];
            [textFieldArray addObject:accPwdTextField];
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
        }
        
        if ([@"img" isEqualToString:type]) {
            
            groupViewHight = [groupView pictureVerification];
            allHeight = allHeight + groupViewHight;
            pictureBtn = groupView.pictureVerificationBtn;
            pictureNumTextField = groupView.pictureVerificationTextField;
        }
        
        if ([@"bankcard" isEqualToString:type]) {
            
            groupViewHight = [groupView bankCardVerification];
            allHeight = allHeight + groupViewHight;
            bankCardTextField = groupView.bankCardVerificationTextField;
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
    if (phoneNumTextField) {
        if (phoneNumTextField.text.length != [phoneNumTextField.maxLenght intValue] || ![NSRegularExpression validateMobile:phoneNumTextField.text] ) {
            return [Tool showDialog:@"输入的手机号码格式不正确，请重新输入。"];
        }
    }
    
    if (shortMsgTextField) {
        if (shortMsgTextField.text.length != [shortMsgTextField.maxLenght intValue] ) {
            return [Tool showDialog:@"请输入6位正确短信验证码，请重新输入。"];
        }
    }
    
    if (loginPwdTextField) {
        
        if ([loginPwdTextField.text rangeOfString:@" "].location != NSNotFound) {
            return [Tool showDialog:@"不能包含空格，请重新输入。"];
        }
        
        if (loginPwdTextField.text.length <= [loginPwdTextField.minLenght intValue] && loginPwdTextField.text.length >= [loginPwdTextField.maxLenght intValue] ) {
            return [Tool showDialog:@"输入的密码格式不正确，请重新输入。"];
        }
        
        if (![NSRegularExpression validatePasswordNumAndLetter:loginPwdTextField.text]) {
            loginPwdTextField.text = nil;
            return [Tool showDialog:@"请输入字母数字组合的密码"];
            
        }
    }
    
    if (accPwdTextField) {
        if (accPwdTextField.text.length < [accPwdTextField.minLenght intValue] ||accPwdTextField.text.length > [accPwdTextField.maxLenght intValue] ) {
            return [Tool showDialog:@"输入的密码格式不正确，请重新输入。"];
        }
    }
    

    
    [self submit];
}

/**
 *@brief 提交
 */
- (void)submit
{
    HUD = [SDMBProgressView showSDMBProgressOnlyLoadingINViewImg:self.view];
    [SDRequestHelp shareSDRequest].HUD = HUD;
    [SDRequestHelp shareSDRequest].controller = self;
    [[SDRequestHelp shareSDRequest] dispatchGlobalQuque:^{
        __block BOOL error = NO;
        
        //校验手机验证码
        NSMutableArray *authToolsArray1 = [[NSMutableArray alloc] init];
        
        NSMutableDictionary *authToolsDic = [[NSMutableDictionary alloc] init];
        [authToolsDic setValue:@"accpass" forKey:@"type"];
        NSMutableDictionary *passDic = [[NSMutableDictionary alloc] init];
        if ([[authToolsDic objectForKey:@"type"] isEqualToString:@"paypass"]){
            [passDic setValue:[[PayNucHelper sharedInstance] pinenc:accPwdTextField.text type:@"paypass"] forKey:@"password"];
        }
        else if([[authToolsDic objectForKey:@"type"] isEqualToString:@"accpass"]){
            [passDic setValue:[[PayNucHelper sharedInstance] pinenc:accPwdTextField.text type:@"accpass"] forKey:@"password"];
        }
        [passDic setValue:@"" forKey:@"description"];
        [passDic setValue:@"" forKey:@"encryptType"];
        [passDic setValue:@"" forKey:@"regular"];
        [authToolsDic setObject:passDic forKey:@"pass"];
        [authToolsArray1 addObject:authToolsDic];
        
        NSString *authTools = [[PayNucHelper sharedInstance] arrayToJSON:authToolsArray1];
        [SDLog logTest:authTools];
        paynuc.set("authTools", [authTools UTF8String]);
        [[SDRequestHelp shareSDRequest] requestWihtFuncName:@"authTool/setAuthTools/v1" errorBlock:^(SDRequestErrorType type) {
            error = YES;
        } successBlock:^{
            
        }];
        if (error) return ;
        
        
        
        [[SDRequestHelp shareSDRequest] requestWihtFuncName:@"authTool/getRegAuthTools/v1" errorBlock:^(SDRequestErrorType type) {
            error = YES;
        } successBlock:^{
            [[SDRequestHelp shareSDRequest] dispatchToMainQueue:^{
                [HUD hidden];
                
                NSString *regAuthTools = [NSString stringWithUTF8String:paynuc.get("regAuthTools").c_str()];
                regAuthToolsArray = [[PayNucHelper sharedInstance] jsonStringToArray:regAuthTools];
                
                SandPwdSecondViewController *mSandPwdSecondViewController = [[SandPwdSecondViewController alloc] init];
                mSandPwdSecondViewController.regAuthToolsArray = regAuthToolsArray;
                [self.navigationController pushViewController:mSandPwdSecondViewController animated:YES];

            }];
        }];
        if (error) return ;
        
    }];
}

#pragma mark - 限制键盘输入某些字符
-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{

    if ([textField.placeholder rangeOfString:@"身份证"].location !=NSNotFound) {
        return [self restrictionwithTypeStr:IDCardVerifi string:string];
    }
    if ([textField.placeholder rangeOfString:@"数字"].location !=NSNotFound) {
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

-(void)dealloc
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
    
    if (accPwdTextField) {
        [[NSNotificationCenter defaultCenter] removeObserver:self name:UITextFieldTextDidChangeNotification object:accPwdTextField];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}



@end
