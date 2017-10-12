//
//  RealNameAuthenticationViewController.m
//  sandbao
//
//  Created by tianNanYiHao on 2017/2/8.
//  Copyright © 2017年 sand. All rights reserved.
//

#import "RealNameAuthenticationViewController.h"


#import "RealNameAuthenticationSecondViewController.h"
#import "SDLog.h"
#import "PayNucHelper.h"


#define navbarColor RGBA(255, 255, 255, 1.0)

#define navViewColor RGBA(249, 249, 249, 1.0)

#define titleColor RGBA(174, 174, 174, 1.0)

#define textFiledColor RGBA(83, 83, 83, 1.0)

#define btnColor RGBA(255, 97, 51, 1.0)

#define viewColor RGBA(255, 255, 255, 1.0)

@interface RealNameAuthenticationViewController ()<UITextFieldDelegate>
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
@property (nonatomic, strong) UITextField *bankNumTextField;
@property (nonatomic, strong) UIButton *nextBtn;

@end

@implementation RealNameAuthenticationViewController

@synthesize viewSize;
@synthesize viewHeight;
@synthesize moveTop;
@synthesize leftRightSpace;
@synthesize textFieldTextSize;
@synthesize btnTextSize;
@synthesize btnW;
@synthesize btnH;


@synthesize HUD;


@synthesize scrollView;
@synthesize bankNumTextField;
@synthesize nextBtn;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.view setBackgroundColor:RGBA(242, 242, 242, 1.0)];
    viewSize = self.view.bounds.size;
    leftRightSpace = 15;
    
    
    
    

    
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

        titleSize = 12;
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
    [scrollView setBackgroundColor:RGBA(242, 242, 242, 1.0)];
    [view addSubview:scrollView];
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    
    UIView *bankCardView = [[UIView alloc] init];
    bankCardView.backgroundColor = [UIColor clearColor];
    [scrollView addSubview:bankCardView];
    
    UILabel *bankCardLabel = [[UILabel alloc] init];
    bankCardLabel.text = @"银行卡信息";
    bankCardLabel.textColor = titleColor;
    bankCardLabel.font = [UIFont systemFontOfSize:titleSize];
    [bankCardView addSubview:bankCardLabel];
    
    UIView *inputView = [[UIView alloc] init];
    inputView.backgroundColor = viewColor;
    [scrollView addSubview:inputView];
    
    UIView *bankNumView = [[UIView alloc] init];
    bankNumView.backgroundColor = [UIColor clearColor];
    [inputView addSubview:bankNumView];
    
    UILabel *bankNumLabel = [[UILabel alloc] init];
    bankNumLabel.text = @"卡号";
    bankNumLabel.textColor = textFiledColor;
    bankNumLabel.font = [UIFont systemFontOfSize:titleSize];
    [bankNumView addSubview:bankNumLabel];
    
    bankNumTextField = [[UITextField alloc] init];
    bankNumTextField.placeholder = @"输入银行卡卡号";
    bankNumTextField.text = SHOWTOTEST(@"5187107509731177"); //信用
    bankNumTextField.text = SHOWTOTEST(@"6217001210072891245"); //信用
    bankNumTextField.textColor = textFiledColor;
    bankNumTextField.tag = 1;
    [bankNumTextField setMinLenght:@"16"];
    [bankNumTextField setMaxLenght:@"19"];
    bankNumTextField.font = [UIFont systemFontOfSize:titleSize];
    [bankNumView addSubview:bankNumTextField];
    
    // 下一步按钮
    nextBtn = [[UIButton alloc] init];
    [nextBtn setTag:1];
    [nextBtn setTitle:@"下一步" forState: UIControlStateNormal];
    [nextBtn setTitleColor:RGBA(255, 255, 255, 1.0) forState:UIControlStateNormal];
    nextBtn.titleLabel.font = [UIFont systemFontOfSize:btnTextSize];
    [nextBtn.layer setMasksToBounds:YES];
    nextBtn.layer.cornerRadius = 5.0;
    [nextBtn addTarget:self action:@selector(buttonActionToDoSomething:) forControlEvents:UIControlEventTouchUpInside];
    [scrollView addSubview:nextBtn];
    
    //设置控件的位置和大小
    CGFloat commWidth = viewSize.width - 2 * leftRightSpace;
    CGSize bankCardLabelSize = [bankCardLabel sizeThatFits:CGSizeMake(commWidth, MAXFLOAT)];
    CGFloat bankCardViewHeight = bankCardLabelSize.height + 2 * 10;

    CGSize bankNumLabelSize = [bankNumLabel.text sizeWithNSStringFont:bankNumLabel.font];
    CGFloat bankNumViewHeight = bankNumLabelSize.height + 2 * 10;
    CGFloat inputViewHeight = bankNumViewHeight;
    
    CGFloat bankNumTextFieldWidth = commWidth - bankNumLabelSize.width - leftRightSpace;
    CGSize bankNumTextFieldSize = [bankNumTextField sizeThatFits:CGSizeMake(bankNumTextFieldWidth, MAXFLOAT)];
    
    CGSize nextBtnSize = [nextBtn.titleLabel sizeThatFits:CGSizeMake(commWidth, MAXFLOAT)];
    CGFloat nextBtnHeight = nextBtnSize.height + 2 * leftRightSpace;
    btnW = commWidth;
    btnH = nextBtnHeight;
    
    moveTop = controllerTop;
    
    [self textFiledEditChanged];
    
    
    [scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(navCoverView.mas_bottom).offset(0);
        make.centerX.equalTo(view);
        make.size.mas_equalTo(CGSizeMake(viewSize.width, viewSize.height - controllerTop));
    }];
    
    
    [bankCardView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(scrollView).offset(0);
        make.centerX.equalTo(scrollView);
        make.size.mas_equalTo(CGSizeMake(commWidth, bankCardViewHeight));
    }];
    
    [bankCardLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(bankCardView).offset(0);
        make.centerY.equalTo(bankCardView);
        make.size.mas_equalTo(CGSizeMake(viewSize.width, bankCardLabelSize.height));
    }];
    
    [inputView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(bankCardView.mas_bottom).offset(0);
        make.left.equalTo(scrollView).offset(0);
        make.size.mas_equalTo(CGSizeMake(viewSize.width, inputViewHeight));
    }];
    
    [bankNumView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(inputView);
        make.size.mas_equalTo(CGSizeMake(viewSize.width, bankNumViewHeight));
    }];
    
    [bankNumLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(bankNumView).offset(leftRightSpace);
        make.centerY.equalTo(bankNumView);
        make.size.mas_equalTo(CGSizeMake(bankNumLabelSize.width, bankNumLabelSize.height));
    }];
    
    [bankNumTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(bankNumLabel.mas_right).offset(leftRightSpace);
        make.centerY.equalTo(bankNumView);
        make.size.mas_equalTo(CGSizeMake(bankNumTextFieldWidth, bankNumTextFieldSize.height));
    }];
    
    [nextBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(inputView.mas_bottom).offset(30);
        make.centerX.equalTo(scrollView);
    }];
    
    [self listenNotifier];
    [self setInputResponderChain];
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
    return @[bankNumTextField];
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
    bankNumTextField.keyboardType = UIKeyboardTypeNumberPad;
    bankNumTextField.returnKeyType = UIReturnKeyDone;
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
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFiledEditChanged:) name:UITextFieldTextDidChangeNotification object:bankNumTextField];
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
            if (![NSRegularExpression validatePureNum:[content substringWithRange:NSMakeRange(lenght-1, 1)]]) {
                [self dismissKeyboard];
                [Tool showDialog:@"请输入0-9的数字"];
                textField.text = nil;
            }
        }
    }
    
    [self textFiledEditChanged];
    
}

- (void)textFiledEditChanged
{
    if ([@"" isEqualToString:bankNumTextField.text] || bankNumTextField.text == nil) {
        return [self changeBtnBackGround:nil];
    }
    
    [self changeBtnBackGround:@"yes"];
}
#pragma mark - 限制键盘输入某些字符
-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{

    if ([textField.placeholder rangeOfString:@"卡号"].location !=NSNotFound) {
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
- (void)changeBtnBackGround:(NSString *)param
{
    if (![@"" isEqualToString:param] && param != nil) {
        [nextBtn setBackgroundImage:[UIImage imageWithColor:RGBA(65, 131, 215, 1.0) size:CGSizeMake(btnW, btnH)] forState:UIControlStateNormal];
        
        [nextBtn setBackgroundImage:[UIImage imageWithColor:RGBA(65, 131, 215, 1.0) size:CGSizeMake(btnW, btnH)] forState:UIControlStateHighlighted];
        
        nextBtn.userInteractionEnabled = YES;
    } else {
        [nextBtn setBackgroundImage:[UIImage imageWithColor:RGBA(200, 200, 200, 1.0) size:CGSizeMake(btnW, btnH)] forState:UIControlStateNormal];
        
        [nextBtn setBackgroundImage:[UIImage imageWithColor:RGBA(200, 200, 200, 1.0) size:CGSizeMake(btnW, btnH)] forState:UIControlStateHighlighted];
        
        nextBtn.userInteractionEnabled = NO;
    }
}

#pragma mark - 业务逻辑

/**
 *@brief 输入数据验证
 */
- (void)verificationInput
{
    if (bankNumTextField.text.length > [bankNumTextField.maxLenght intValue] ||  bankNumTextField.text.length < [bankNumTextField.minLenght intValue]) {
        return [Tool showDialog:@"输入的银行卡号格式不正确，请重新输入。"];
    }

    [self load];
}

/**
 *@brief 查询银行信息
 */
- (void)load
{
    HUD = [SDMBProgressView showSDMBProgressOnlyLoadingINViewImg:self.view];
    [SDRequestHelp shareSDRequest].HUD = HUD;
    [SDRequestHelp shareSDRequest].controller = self;
    [[SDRequestHelp shareSDRequest] dispatchGlobalQuque:^{
        __block BOOL error = NO;
        paynuc.set("tTokenType", "01001101");
        [[SDRequestHelp shareSDRequest] requestWihtFuncName:@"token/getTtoken/v1" errorBlock:^(SDRequestErrorType type) {
            error = YES;
        } successBlock:^{
            
        }];
        if (error) return ;
        
        NSMutableDictionary *accountDic = [[NSMutableDictionary alloc] init];
        [accountDic setValue:@"03" forKey:@"kind"];
        [accountDic setValue:[NSString stringWithFormat:@"%@", bankNumTextField.text] forKey:@"accNo"];
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
            [[SDRequestHelp shareSDRequest] dispatchToMainQueue:^{
                [HUD hidden];
                
                
                NSString *payTool = [NSString stringWithUTF8String:paynuc.get("payTool").c_str()];
                NSDictionary *payToolDic = [[PayNucHelper sharedInstance] jsonStringToDictionary:payTool];
                BOOL fastPayFlag = [[payToolDic objectForKey:@"fastPayFlag"] boolValue];
                
                NSString *userInfo = [NSString stringWithUTF8String:paynuc.get("userInfo").c_str()];
                NSDictionary *userInfoDic = [[PayNucHelper sharedInstance] jsonStringToDictionary:userInfo];
                
                NSMutableDictionary *passDic = [[NSMutableDictionary alloc] init];
                [passDic setObject:userInfoDic forKey:@"userInfo"];
                [passDic setValue:payToolDic forKey:@"payTool"];
                
                
                RealNameAuthenticationSecondViewController *mRealNameAuthenticationSecondViewController = [[RealNameAuthenticationSecondViewController alloc] init];
                mRealNameAuthenticationSecondViewController.passDic = passDic;
                mRealNameAuthenticationSecondViewController.fastPayFlag = fastPayFlag;
                mRealNameAuthenticationSecondViewController.isFromSPSrealName = _isFromSPSrealName;
                [self.navigationController pushViewController:mRealNameAuthenticationSecondViewController animated:YES];

            }];
        }];
        if (error) return ;
    }];
    
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UITextFieldTextDidChangeNotification object:bankNumTextField];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
