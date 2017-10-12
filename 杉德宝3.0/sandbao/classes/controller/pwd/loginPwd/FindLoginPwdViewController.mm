//
//  FindLoginPwdViewController.m
//  sandbao
//
//  Created by tianNanYiHao on 2017/1/19.
//  Copyright © 2017年 sand. All rights reserved.
//

#import "FindLoginPwdViewController.h"


#import "GroupView.h"
#import "SDLog.h"
#import "PayNucHelper.h"
#import "LoginViewController.h"


#define navbarColor RGBA(255, 255, 255, 1.0)

#define navViewColor RGBA(249, 249, 249, 1.0)

#define lineViewColor RGBA(237, 237, 237, 1.0)

#define titleColor RGBA(174, 174, 174, 1.0)

#define textFiledColor RGBA(83, 83, 83, 1.0)

#define btnColor RGBA(255, 97, 51, 1.0)

#define viewColor RGBA(255, 255, 255, 1.0)



@interface FindLoginPwdViewController ()<UITextFieldDelegate>
{
    NavCoverView *navCoverView;
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


@property (nonatomic, strong) SDMBProgressView *HUD;


@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UIButton *button;


@property (nonatomic, assign) CGFloat shortMsgBtnW;
@property (nonatomic, assign) CGFloat shortMsgBtnH;
@property (nonatomic, assign) int timeOut;
@property (nonatomic, assign) int timeCount;
@property (nonatomic, assign) BOOL showPwdFlag;
@property (nonatomic, assign) CGFloat textFieldTag;

@property (nonatomic, strong) NSMutableArray *authToolsArray;
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

@end

@implementation FindLoginPwdViewController

@synthesize viewSize;
@synthesize viewHeight;
@synthesize moveTop;
@synthesize leftRightSpace;
@synthesize lineViewHeight;
@synthesize textFieldTextSize;
@synthesize btnTextSize;
@synthesize btnW;
@synthesize btnH;


@synthesize HUD;


@synthesize scrollView;
@synthesize button;

@synthesize shortMsgBtnW;
@synthesize shortMsgBtnH;
@synthesize timeOut;
@synthesize timeCount;
@synthesize showPwdFlag;
@synthesize textFieldTag;

@synthesize authToolsArray;
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
@synthesize questionTitleLabel;
@synthesize questionBtn;
@synthesize questionlabel;

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    //
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.view setBackgroundColor:RGBA(247, 245, 244, 1.0)];
    viewSize = self.view.bounds.size;
    leftRightSpace = 15;
    
    authToolsArray = [[NSMutableArray alloc] init];
    textFieldTag = 0;
    
    
    
    


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
    navCoverView = [NavCoverView shareNavCoverView:CGRectMake(0, 0, viewSize.width, controllerTop) title:@"找回登陆密码"];
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

        textFieldTextSize = 14;
        btnTextSize = 16;

    
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
    [scrollView setBackgroundColor:RGBA(239, 239, 244, 1.0)];
    [view addSubview:scrollView];
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    //鉴权区
    UIView *authToolsView = [[UIView alloc] init];
    authToolsView.backgroundColor = viewColor;
    [scrollView addSubview:authToolsView];
    
    CGFloat authToolsViewH = [self addAuthToolsView:authToolsView];
    
    // 完成按钮
    button = [[UIButton alloc] init];
    [button setTag:1];
    [button setTitle:@"完成" forState: UIControlStateNormal];
    [button setTitleColor:RGBA(255, 255, 255, 1.0) forState:UIControlStateNormal];
    button.titleLabel.font = [UIFont systemFontOfSize:btnTextSize];
    [button.layer setMasksToBounds:YES];
    button.layer.cornerRadius = 5.0;
    [button addTarget:self action:@selector(buttonActionToDoSomething:) forControlEvents:UIControlEventTouchUpInside];
    [scrollView addSubview:button];
    
    
    //设置控件的位置和大小
    CGFloat authToolsViewTop = 10;
    CGFloat commWidth = viewSize.width - 2 * leftRightSpace;
    
 
    CGFloat scrollViewH = viewSize.height - controllerTop;
    
    CGSize buttonSize = [button.titleLabel sizeThatFits:CGSizeMake(commWidth, MAXFLOAT)];
    CGFloat buttonHeight = buttonSize.height + 2 * 15;
    btnW = commWidth;
    btnH = buttonHeight;
    
    moveTop = controllerTop + authToolsViewTop;
    
    [self textFiledEditChanged];
    
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
    
    [authToolsView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(scrollView).offset(authToolsViewTop);
        make.centerX.equalTo(scrollView);
        make.size.mas_equalTo(CGSizeMake(viewSize.width, authToolsViewH));
    }];
    
    [button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(authToolsView.mas_bottom).offset(60.55);
        make.centerX.equalTo(scrollView);
        make.size.mas_equalTo(CGSizeMake(commWidth, buttonHeight));
    }];
    
    [self setInputResponderChain];
    [self listenNotifier];
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
            //退回到设置页面
            UIViewController *setViewController = self.navigationController.viewControllers[1];
            [self.navigationController popToViewController:setViewController animated:YES];

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
    return @[loginPwdTextField];
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
    questionTextField.returnKeyType = UIReturnKeyDone;
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
            [shortMsgBtn setTitleColor:RGBA(255, 255, 255, 1.0) forState:UIControlStateNormal];
            
            [shortMsgBtn setBackgroundImage:[UIImage imageWithColor:RGBA(65, 131, 215, 1.0) size:CGSizeMake(shortMsgBtnW, shortMsgBtnH)] forState:UIControlStateNormal];
            
            [shortMsgBtn setBackgroundImage:[UIImage imageWithColor:RGBA(65, 131, 215, 1.0) size:CGSizeMake(shortMsgBtnW, shortMsgBtnH)] forState:UIControlStateHighlighted];
            
            shortMsgBtn.userInteractionEnabled = YES;
            
            
            [button setBackgroundImage:[UIImage imageWithColor:RGBA(65, 131, 215, 1.0)size:CGSizeMake(btnW, btnH)] forState:UIControlStateNormal];
            
            [button setBackgroundImage:[UIImage imageWithColor:RGBA(65, 131, 215, 1.0) size:CGSizeMake(btnW, btnH)] forState:UIControlStateHighlighted];
            
            button.userInteractionEnabled = YES;
        } else {
            [shortMsgBtn setTitleColor:RGBA(153, 153, 153, 1.0) forState:UIControlStateNormal];
            
            [shortMsgBtn setBackgroundImage:[UIImage imageWithColor:RGBA(200, 200, 200, 1.0) size:CGSizeMake(shortMsgBtnW, shortMsgBtnH)] forState:UIControlStateNormal];
            
            [shortMsgBtn setBackgroundImage:[UIImage imageWithColor:RGBA(200, 200, 200, 1.0) size:CGSizeMake(shortMsgBtnW, shortMsgBtnH)] forState:UIControlStateHighlighted];
            
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
            [shortMsgBtn setTitleColor:RGBA(255, 255, 255, 1.0) forState:UIControlStateNormal];
            
            [shortMsgBtn setBackgroundImage:[UIImage imageWithColor:RGBA(65, 131, 215, 1.0) size:CGSizeMake(shortMsgBtnW, shortMsgBtnH)] forState:UIControlStateNormal];
            
            [shortMsgBtn setBackgroundImage:[UIImage imageWithColor:RGBA(65, 131, 215, 1.0) size:CGSizeMake(shortMsgBtnW, shortMsgBtnH)] forState:UIControlStateHighlighted];
            
            shortMsgBtn.userInteractionEnabled = YES;
        } else {
            [shortMsgBtn setTitleColor:RGBA(153, 153, 153, 1.0) forState:UIControlStateNormal];
            
            [shortMsgBtn setBackgroundImage:[UIImage imageWithColor:RGBA(200, 200, 200, 1.0) size:CGSizeMake(shortMsgBtnW, shortMsgBtnH)] forState:UIControlStateNormal];
            
            [shortMsgBtn setBackgroundImage:[UIImage imageWithColor:RGBA(200, 200, 200, 1.0) size:CGSizeMake(shortMsgBtnW, shortMsgBtnH)] forState:UIControlStateHighlighted];
            
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
        } else {
            [loginPwdBtn setImage:[UIImage imageNamed:@"list_eyes_off"] forState:UIControlStateNormal];
            showPwdFlag = NO;
            loginPwdTextField.secureTextEntry = YES;
        }
    } else {
        
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
        [[SDRequestHelp shareSDRequest] requestWihtFuncName:@"authTool/getRegAuthTools/v1" errorBlock:^(SDRequestErrorType type) {
            error = YES;
        } successBlock:^{
            [[SDRequestHelp shareSDRequest] dispatchToMainQueue:^{
                [HUD hidden];
                
                NSString *tempAuthTools = [NSString stringWithUTF8String:paynuc.get("regAuthTools").c_str()];
                NSArray *tempAuthToolsArray = [[PayNucHelper sharedInstance] jsonStringToArray:tempAuthTools];
                
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
    lineViewHeight = 1;
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
        }
        
        if ([@"loginpass" isEqualToString:type]) {
            
            groupViewHight = [groupView loginPwdVerification];
            allHeight = allHeight + groupViewHight;
            loginPwdBtn = groupView.loginPwdVerificationBtn;
            loginPwdTextField = groupView.loginPwdVerificationTextField;
            
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
    
    [self pushRegAuthTools];
}

/**
 *@brief 重置登录密码
 */
- (void)pushRegAuthTools
{
    HUD = [SDMBProgressView showSDMBProgressOnlyLoadingINViewImg:self.view];
    [SDRequestHelp shareSDRequest].HUD = HUD;
    [SDRequestHelp shareSDRequest].controller = self;
    [[SDRequestHelp shareSDRequest] dispatchGlobalQuque:^{
        __block BOOL error = NO;
        NSMutableArray *regAuthToolsArray = [[NSMutableArray alloc] init];
        
        NSMutableDictionary *dic = authToolsArray[0];
        NSMutableDictionary *authToolsDic = [NSMutableDictionary dictionaryWithDictionary:dic];
        [authToolsDic removeObjectForKey:@"pass"];
        NSMutableDictionary *passDic = [[NSMutableDictionary alloc] init];
        [passDic setValue:[NSString stringWithUTF8String:paynuc.lgnenc([loginPwdTextField.text UTF8String]).c_str()] forKey:@"password"];
        [passDic setValue:@"" forKey:@"description"];
        [passDic setValue:@"" forKey:@"encryptType"];
        [passDic setValue:@"" forKey:@"regular"];
        [authToolsDic setObject:passDic forKey:@"pass"];
        [regAuthToolsArray addObject:authToolsDic];
        NSString *regAuthTools = [[PayNucHelper sharedInstance] arrayToJSON:regAuthToolsArray];
        paynuc.set("regAuthTools", [regAuthTools UTF8String]);
        [[SDRequestHelp shareSDRequest] requestWihtFuncName:@"authTool/setRegAuthTools/v1" errorBlock:^(SDRequestErrorType type) {
            error = YES;
        } successBlock:^{
            [[SDRequestHelp shareSDRequest] dispatchToMainQueue:^{
                [HUD hidden];
                
                [Tool showDialog:@"密码修改成功,请返回重新登录" defulBlock:^{
                    [self.navigationController popToRootViewControllerAnimated:YES];
                }];

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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
