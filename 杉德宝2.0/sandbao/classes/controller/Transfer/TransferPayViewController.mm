//
//  Transfer BeginViewController.m
//  sandbao
//
//  Created by tianNanYiHao on 2017/3/23.
//  Copyright © 2017年 sand. All rights reserved.
//

#import "TransferPayViewController.h"


#import "SDLog.h"
#import "CommParameter.h"
#import "SDCircleView.h"
#import "PayNucHelper.h"
#import "TransferTableViewCell.h"
#import "SDPayView.h"
#import "TransferSucceedViewController.h"
#import "VerificationModeViewController.h"

#define navbarColor RGBA(242, 242, 242, 1.0)

#define navViewColor RGBA(255, 125, 50, 1.0)

#define lineViewColor RGBA(237, 237, 237, 1.0)

#define titleColor RGBA(174, 174, 174, 1.0)

#define textFiledColor RGBA(83, 83, 83, 1.0)

#define textFiledColordarkBlue RGBA(43, 56, 87, 1.0)

#define textFiledColorBlue  RGBA(65, 131, 215, 1.0)

#define textFiledColorlightGray RGBA(191, 195, 204, 1.0)

#define viewColor RGBA(255, 255, 255, 1.0)

typedef void(^TransferPayStateBlock)(NSArray *paramArr);
@interface TransferPayViewController ()<UITextFieldDelegate,SDPayViewDelegate>
{
     NavCoverView *navCoverView;
     CGSize viewSize;
     CGFloat titleTextSize;
     CGFloat labelTextSize;
     CGFloat lineViewHeight;
     CGFloat leftRightSpace;
     SDCircleView *circleView;
    
    
    UIScrollView *scrollView;
    NSArray *authToolsArray;
    
    CGFloat textFieldTextSize;
    CGFloat textSize;
    
    NSMutableDictionary *workDicGet;

    UIButton *nextBtn;

    UITextField *cashTextfield;
    UITextField *massageTextField;
    
    
    NSString *inPayToolstr;
    UILabel *tipLab;
}
@property (nonatomic,strong) SDPayView *payView;
@property (nonatomic,assign) NSInteger feeFloat;
@property (nonatomic,assign) float limitFloat;
@property (nonatomic, strong) SDMBProgressView *HUD;

@end


@implementation TransferPayViewController
@synthesize HUD;
@synthesize payView;



- (void)viewDidLoad {
    [super viewDidLoad];

    //转账step1
    [self.view setBackgroundColor:RGBA(248, 248, 248, 1.0)];
    viewSize = self.view.bounds.size;
    leftRightSpace = 15;
    lineViewHeight = 1;
    workDicGet = [NSMutableDictionary dictionaryWithCapacity:0];
    
    
    

    
    self.navigationController.navigationBarHidden = YES;
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
    navCoverView = [NavCoverView shareNavCoverView:CGRectMake(0, 0, viewSize.width, controllerTop) title:@"输入金额"];
    [self.view addSubview:navCoverView];
    
    // 2.设置左边的返回item
    UIImage *leftImage = [UIImage imageNamed:@"back"];
    UIButton *leftBarBtn = [[UIButton alloc] init];
    leftBarBtn.frame = CGRectMake(0, 20 + (40 - leftImage.size.height) / 2, leftImage.size.width, leftImage.size.height);
    leftBarBtn.tag = 101;
    [leftBarBtn setImage:[UIImage imageNamed:@"back"] forState:UIControlStateNormal];
    [leftBarBtn setImage:[UIImage imageNamed:@"back"] forState:UIControlStateHighlighted];
    leftBarBtn.contentMode = UIViewContentModeScaleAspectFit;
    [leftBarBtn addTarget:self action:@selector(buttonActionToDoSomething:) forControlEvents:UIControlEventTouchUpInside];
    [navCoverView addSubview:leftBarBtn];
    
    
    // 3.设置右边的返回item
    UIImage *rightImage = [UIImage imageNamed:@"record"];
    UIButton *rightBarBtn = [[UIButton alloc] init];
    [rightBarBtn setImage:[UIImage imageNamed:@"record"] forState:UIControlStateNormal];
    [rightBarBtn setImage:[UIImage imageNamed:@"record"] forState:UIControlStateHighlighted];
    rightBarBtn.frame = CGRectMake(viewSize.width - 10 - rightImage.size.width, 20 + (40 - rightImage.size.height) / 2, rightImage.size.width, rightImage.size.height);
    rightBarBtn.tag = 102;
    rightBarBtn.contentMode = UIViewContentModeScaleAspectFit;
    [rightBarBtn addTarget:self action:@selector(buttonActionToDoSomething:) forControlEvents:UIControlEventTouchUpInside];
    [navCoverView addSubview:rightBarBtn];
}



                   
#pragma mark - 创建组件
/**
 *@brief 创建组件
 *@param view UIView 参数：组件
 *@return
 */
-(void)addView:(UIView *)view
{

        textFieldTextSize = 24;
        textSize = 14;
        titleTextSize = 14;


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
    [scrollView setBackgroundColor:navbarColor];
    [view addSubview:scrollView];
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    //viewtip
    UIView *tipView = [[UIView alloc] init];
    tipView.backgroundColor = [UIColor whiteColor];
    [scrollView addSubview:tipView];
    
    
    
    tipLab = [[UILabel alloc] init];
    tipLab.textColor = titleColor;
    tipLab.font = [UIFont systemFontOfSize:titleTextSize];
    _limitFloat = [[PayNucHelper sharedInstance] limitInfo:[_outPayToolDic objectForKey:@"limit"]]/100;
    tipLab.text = [NSString stringWithFormat:@"转账金额(最多可转入:%.2f元)",_limitFloat];
    [tipView addSubview:tipLab];
    
    
    
    UIView *textBgview = [[UIView alloc] init];
    textBgview.backgroundColor = [UIColor whiteColor];
    [scrollView addSubview:textBgview];

    UILabel *rmbLab = [[UILabel alloc] init];
    rmbLab.text = @"¥";
    rmbLab.font = [UIFont systemFontOfSize:textFieldTextSize];
    rmbLab.textColor = titleColor;
    [textBgview addSubview:rmbLab];
    

    cashTextfield = [[UITextField alloc] init];
    cashTextfield.placeholder = @"0.00";
    cashTextfield.font = [UIFont systemFontOfSize:textFieldTextSize];
    cashTextfield.textColor = textFiledColor;
    cashTextfield.tag = 1;
    cashTextfield.keyboardType = UIKeyboardTypeDecimalPad;
    [cashTextfield setMinLenght:@"0"];
    [cashTextfield setMaxLenght:@"11"];
    cashTextfield.clearButtonMode = UITextFieldViewModeWhileEditing;
    cashTextfield.tintColor = RGBA(199, 199, 199, 1.0);
    [textBgview addSubview:cashTextfield];
    
    
    
    UIView *lineView = [[UIView alloc] init];
    lineView.backgroundColor = RGBA(229, 229, 229, 1.0f);;
    [scrollView addSubview:lineView];
    
    
    UIView *massageView = [[UIView alloc] init];
    massageView.backgroundColor = [UIColor whiteColor];
    [scrollView addSubview:massageView];
    
    
    massageTextField = [[UITextField alloc] init];
    massageTextField.placeholder = @"添加备注(10个字以内)";
    massageTextField.font = [UIFont systemFontOfSize:textSize];
    massageTextField.textColor = textFiledColor;
    massageTextField.tag = 2;
    [massageTextField setMinLenght:@"0"];
    [massageTextField setMaxLenght:@"10"];
    massageTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    massageTextField.tintColor = RGBA(199, 199, 199, 1.0);
    [massageView addSubview:massageTextField];

    
    
    //1.2 nextBtn
    nextBtn = [[UIButton alloc] init];
    [nextBtn setTag:302];
    [nextBtn setTitle:@"下一步" forState: UIControlStateNormal];
    [nextBtn setTitleColor:RGBA(255, 255, 255, 1.0) forState:UIControlStateNormal];
    nextBtn.titleLabel.font = [UIFont systemFontOfSize:textSize];
    nextBtn.userInteractionEnabled = NO;
    [nextBtn setBackgroundColor:RGBA(206, 209, 216, 1.0)];
    [nextBtn.layer setMasksToBounds:YES];
    nextBtn.layer.cornerRadius = 5.0;
    [nextBtn addTarget:self action:@selector(buttonActionToDoSomething:) forControlEvents:UIControlEventTouchUpInside];
    [scrollView addSubview:nextBtn];
    
    
    //bottomTip
    UILabel *bottomTip = [[UILabel alloc] init];
    bottomTip.text = @"实时转入对方账户,无法退款";
    bottomTip.textColor = textFiledColor;
    bottomTip.font = [UIFont systemFontOfSize:titleTextSize];
    bottomTip.textAlignment = NSTextAlignmentCenter;
    [scrollView addSubview:bottomTip];
    
    
    //设置控件的位置和大小
    CGFloat space = 10.0;
    CGFloat commWidth = viewSize.width - 2 * leftRightSpace;
    CGSize tipSize = [TransferPayViewController labelAutoCalculateRectWith:tipLab.text Font:[UIFont systemFontOfSize:titleTextSize] MaxSize:CGSizeMake(CGFLOAT_MAX, CGFLOAT_MAX)];
    CGSize rmbSize = [TransferPayViewController labelAutoCalculateRectWith:rmbLab.text Font:[UIFont systemFontOfSize:textFieldTextSize] MaxSize:CGSizeMake(CGFLOAT_MAX, CGFLOAT_MAX)];
    
    CGSize nextBtnTitleSize = [TransferPayViewController labelAutoCalculateRectWith:nextBtn.titleLabel.text Font:[UIFont systemFontOfSize:textSize] MaxSize:CGSizeMake(MAXFLOAT, MAXFLOAT)];
    CGFloat newxtBtnH = nextBtnTitleSize.height + 2*leftRightSpace;
    
    CGFloat tipH = tipSize.height + 2*space;
    
    CGFloat cashTextfiledW = commWidth - rmbSize.width - space;
    
    
    
    [scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(view).offset(controllerTop);
        make.left.equalTo(view).offset(0);
        make.size.mas_equalTo(CGSizeMake(viewSize.width, viewSize.height-controllerTop));
    }];

    
    [tipView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(scrollView).offset(0);
        make.left.equalTo(scrollView).offset(0);
        make.size.mas_equalTo(CGSizeMake(viewSize.width, tipH));
        
    }];
    
    [tipLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(tipView.mas_centerY).offset(0);
        make.left.equalTo(tipView.mas_left).offset(leftRightSpace);
        make.size.mas_equalTo(tipSize);
    }];


    [textBgview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(tipView.mas_bottom).offset(0);
        make.left.equalTo(scrollView).offset(0);
        make.size.mas_equalTo(CGSizeMake(viewSize.width, rmbSize.height + 2 * leftRightSpace));
    }];
    
    [rmbLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(textBgview.mas_centerY).offset(0);
        make.left.equalTo(textBgview).offset(leftRightSpace);
        make.size.mas_equalTo(rmbSize);
    }];
    
    [cashTextfield mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(textBgview.mas_centerY).offset(0);
        make.left.equalTo(rmbLab.mas_right).offset(space);
        make.size.mas_equalTo(CGSizeMake(cashTextfiledW, rmbSize.height));
    }];
    
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(textBgview.mas_bottom).offset(0);
        make.left.equalTo(scrollView).offset(leftRightSpace);
        make.size.mas_equalTo(CGSizeMake(viewSize.width-leftRightSpace, 1));
    }];
    
    
    [massageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(lineView.mas_bottom).offset(0);
        make.left.equalTo(scrollView).offset(0);
        make.size.mas_equalTo(CGSizeMake(viewSize.width,  rmbSize.height + 2 * leftRightSpace));
    }];
    
    [massageTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(massageView.mas_centerY).offset(0);
        make.left.equalTo(massageView).offset(leftRightSpace);
        make.size.mas_equalTo(CGSizeMake(viewSize.width-leftRightSpace, rmbSize.height + 2 * leftRightSpace));
    }];
    
    [nextBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(massageView.mas_bottom).offset(50);
        make.left.equalTo(scrollView).offset(leftRightSpace);
        make.size.mas_equalTo(CGSizeMake(commWidth, newxtBtnH));
    }];
    
    [bottomTip mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(nextBtn.mas_bottom).offset(leftRightSpace);
        make.centerX.equalTo(scrollView.mas_centerX).offset(0);
        make.size.mas_equalTo(CGSizeMake(viewSize.width, 2*leftRightSpace));
    }];
    
    
    [self setInputResponderChain];
    [self listenNotifier];
    
    
    payView = [SDPayView getPayView];
    payView.style = SDPayViewOnlyPwd;
    payView.delegate = self;
    [self.view addSubview:payView];
    
    [payView setPayInfo:@[_outPayToolDic] moneyStr:nil orderTypeStr:nil];
    
}
/**
 *@brief 为所有的输入框设置键盘类型
 */
- (void)setInputResponderChain {
    
    NSArray *textFields = [self allInputFields];
    for (UIResponder *responder in textFields) {
        if ([responder isKindOfClass:[UITextField class]]) {
            UITextField *textField = (UITextField *)responder;
            textField.returnKeyType = UIReturnKeyDone;
            textField.autocorrectionType = UITextAutocorrectionTypeNo;
            textField.delegate = self;
        }
    }
}
#pragma mark - 把所有的输入框放到数组中


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
 *@brief 把所有的输入框放到数组中
 *@return NSArray
 */
- (NSArray *)allInputFields {
    return @[cashTextfield,massageTextField];
}
#pragma mark - 监听通知
- (void)listenNotifier
{
    if (cashTextfield) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFiledEditChanged:) name:UITextFieldTextDidChangeNotification object:cashTextfield];
    }
    if (massageTextField) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFiledEditChanged:) name:UITextFieldTextDidChangeNotification object:massageTextField];
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
    if (cashTextfield) {
        if ([@"" isEqualToString:cashTextfield.text] || cashTextfield.text == nil) {
            return [self changeBtnBackGround:nil index:2];
        }else {
            [self changeBtnBackGround:@"yes" index:1];
            
        }
    }
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
- (void)changeBtnBackGround:(NSString *)param index:(int)index
{
    if (index == 1) {
        if (![@"" isEqualToString:param] && param != nil) {
            [nextBtn setTitleColor:RGBA(255, 255, 255, 1.0) forState:UIControlStateNormal];
            nextBtn.userInteractionEnabled = YES;
            [nextBtn setBackgroundColor:RGBA(65, 131, 215, 1.0)];
            nextBtn.userInteractionEnabled = YES;
        }
    }else{
        [nextBtn setTitleColor:RGBA(255, 255, 255, 1.0) forState:UIControlStateNormal];
        [nextBtn setBackgroundColor:RGBA(206, 209, 216, 1.0)];
        nextBtn.userInteractionEnabled = NO;
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

#pragma mark fee手续费
-(void)getFee{
    
    //work
    HUD = [SDMBProgressView showSDMBProgressOnlyLoadingINViewImg:self.view];
    [SDRequestHelp shareSDRequest].HUD = HUD;
    [SDRequestHelp shareSDRequest].controller = self;
    [[SDRequestHelp shareSDRequest] dispatchGlobalQuque:^{
        __block BOOL error = NO;
        //1.费率
        //work
        NSMutableDictionary *workDic = [[NSMutableDictionary alloc] initWithCapacity:0];
        [workDic setObject:@"transfer" forKey:@"type"];
        NSInteger cashFen = [cashTextfield.text floatValue]*100;
        [workDic setObject:[NSString stringWithFormat:@"%ld",(long)cashFen] forKey:@"transAmt"];  //转一元
        NSString *workStr = [[PayNucHelper sharedInstance] dictionaryToJson:workDic];
        paynuc.set("work", [workStr UTF8String]);
        
        //inpayTool
        inPayToolstr = [[PayNucHelper sharedInstance] dictionaryToJson:_inPayToolDic];
        paynuc.set("inPayTool", [inPayToolstr UTF8String]);
        
        //outpayTool
        NSString *outPayToolStr = [[PayNucHelper sharedInstance] dictionaryToJson:_outPayToolDic];
        paynuc.set("outPayTool", [outPayToolStr UTF8String]);
        [[SDRequestHelp shareSDRequest] requestWihtFuncName:@"business/fee/v1" errorBlock:^(SDRequestErrorType type) {
            error = YES;
        } successBlock:^{
            [[SDRequestHelp shareSDRequest] dispatchToMainQueue:^{
                [HUD hidden];
                
                //接受手续费
                NSString *workStr = [NSString stringWithUTF8String:paynuc.get("work").c_str()];
                NSDictionary *workDictI = [[PayNucHelper sharedInstance] jsonStringToDictionary:workStr];
                workDicGet = [[NSMutableDictionary alloc] initWithDictionary:workDictI];
                [self payPwd];

            }];
        }];
        if (error) return ;
    }];
}

//输入支付密码进行支付
-(void)payPwd{
    
    [payView showPayTool];
}

#pragma mark - SDPayViewDelegate
- (void)payViewPwd:(NSString *)pwdStr paySuccessView:(SDPaySuccessAnimationView *)successView{
    
    //支付动画开始
    [successView animationStart];

    [self pay:pwdStr transferPaySuccessBlock:^(NSArray *paramArr){
        //支付成功
        [successView animationSuccess];
        dispatch_time_t delayTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5f * NSEC_PER_SEC));
        dispatch_after(delayTime, dispatch_get_main_queue(), ^{
            //log //跳转
            TransferSucceedViewController *vc = [[TransferSucceedViewController alloc] init];
            vc.otherPayInfoName = [_inPayToolDic objectForKey:@"title"];
            vc.otherPayDescribeNum = [[_inPayToolDic objectForKey:@"account"] objectForKey:@"accNo"];
            //内扣
            if ([[workDicGet objectForKey:@"feeType"] isEqualToString:@"in"]) {
                vc.moneyStr = [NSString stringWithFormat:@"%.2f",(float)([paramArr[0] integerValue] - _feeFloat)/100];
            }else{
                vc.moneyStr = [NSString stringWithFormat:@"%.2f", (float)[paramArr[0] integerValue]/100];
            }
            vc.payDescribeStr =[NSString stringWithFormat:@"转账前余额:%.2f",[[[_outPayToolDic objectForKey:@"account"] objectForKey:@"balance"] floatValue]/100];
            [self.navigationController pushViewController:vc animated:YES];
        });
    } transferPayErrorBlock:^(NSArray *paramArr){
        //支付失败
        [successView animationStopClean];
//        [payView hidPayTool];
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




-(void)pay:(NSString *)param transferPaySuccessBlock:(TransferPayStateBlock)successblock transferPayErrorBlock:(TransferPayStateBlock)errorblock{
    
    HUD = [SDMBProgressView showSDMBProgressOnlyLoadingINViewImg:self.view];
    [HUD hidden];
    [SDRequestHelp shareSDRequest].HUD = HUD;
    [SDRequestHelp shareSDRequest].controller = self;
    [[SDRequestHelp shareSDRequest] dispatchGlobalQuque:^{
        __block BOOL error = NO;
        //2.支付
        //////acc2acc
        //work
        //本地计算fee
        NSString *feerate =  [workDicGet objectForKey:@"feeRate"];
        NSInteger feerateValue = [feerate integerValue];
        CGFloat   feerateFloat =  feerateValue/100;
        NSInteger cashFen = [cashTextfield.text floatValue]*100;
        _feeFloat =  cashFen * feerateFloat;
        NSString *feeLocalStr = [NSString stringWithFormat:@"%ld",_feeFloat];
        [workDicGet removeObjectForKey:@"fee"];
        [workDicGet setObject:feeLocalStr forKey:@"fee"];
        [workDicGet setObject:@"transfer" forKey:@"type"];
        
        [workDicGet setObject:[NSString stringWithFormat:@"%ld",(long)cashFen] forKey:@"transAmt"];  //转一元
        NSString *workStrGet = [[PayNucHelper sharedInstance] dictionaryToJson:workDicGet];
        paynuc.set("work", [workStrGet UTF8String]);
        paynuc.set("inPayTool", [inPayToolstr UTF8String]);
        
        
        //获取对应呕吐PayTool的authTools 填充密码
        NSArray *authTools = [_outPayToolDic objectForKey:@"authTools"];
        NSDictionary *authToolsDic = authTools[0];
        NSDictionary *passDic = [authToolsDic objectForKey:@"pass"];
        NSMutableDictionary *authToolDicM = [[NSMutableDictionary alloc] initWithDictionary:authToolsDic];
        [authToolDicM removeObjectForKey:@"pass"];
        NSMutableDictionary *passDicM = [[NSMutableDictionary alloc] initWithDictionary:passDic];
        [passDicM removeObjectForKey:@"password"];
        [passDicM removeObjectForKey:@"encryptType"];
        [passDicM setObject:@"sand" forKey:@"encryptType"];
        if ([[authToolsDic objectForKey:@"type"] isEqualToString:@"paypass"]){
            [passDicM setValue:[[PayNucHelper sharedInstance] pinenc:param type:@"paypass"] forKey:@"password"];
        }
        else if([[authToolsDic objectForKey:@"type"] isEqualToString:@"accpass"]){
            [passDicM setValue:[[PayNucHelper sharedInstance] pinenc:param type:@"accpass"] forKey:@"password"];
        }
        [authToolDicM setObject:passDicM forKey:@"pass"];
        NSMutableArray *atuhToolsM = [[NSMutableArray alloc] initWithArray:authTools];
        [atuhToolsM removeObjectAtIndex:0];
        [atuhToolsM addObject:authToolDicM];
        
        NSMutableDictionary *outPayToolM = [[NSMutableDictionary alloc] initWithDictionary:_outPayToolDic];
        [outPayToolM removeObjectForKey:@"authTools"];
        [outPayToolM setObject:atuhToolsM forKey:@"authTools"];
        NSString *outPayToolStrAcc2Acc = [[PayNucHelper sharedInstance] dictionaryToJson:outPayToolM];
        paynuc.set("outPayTool", [outPayToolStrAcc2Acc UTF8String]);
        [[SDRequestHelp shareSDRequest] requestWihtFuncName:@"business/acc2acc/v1" errorBlock:^(SDRequestErrorType type) {
            error = YES;
            [[SDRequestHelp shareSDRequest] dispatchToMainQueue:^{
                errorblock(nil);
                if (type == respCodeErrorType) {
                    UIViewController *transferBeginVc = self.navigationController.viewControllers[1];
                    [self.navigationController popToViewController:transferBeginVc animated:YES];
                }
            }];
        } successBlock:^{
            [[SDRequestHelp shareSDRequest] dispatchToMainQueue:^{
                [HUD hidden];
                successblock(@[@(cashFen)]);
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
    if (cashTextfield.text.length >8 || cashTextfield.text.length<0) {
        return [Tool showDialog:@"输入金额位数不正确,请重新输入"];
    }
    if (_limitFloat < [cashTextfield.text floatValue]) {
        [Tool showDialog:@"输入金额超过可用额度"];
        [self changeBtnBackGround:nil index:1];
        cashTextfield.text = @"";
        return;
    }
    
    
    if ([cashTextfield.text doubleValue]<0.01) {
        [self changeBtnBackGround:nil index:1];
        cashTextfield.text = @"";
        cashTextfield.placeholder = @"金额不能为零";
        return;
    }
    
    [self getFee];
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
        case 302:
        {
            [self dismissKeyboard];
            [self verificationInput];
        }
            break;
        default:
            break;
    }
}




+ (CGSize)labelAutoCalculateRectWith:(NSString*)text Font:(UIFont*)font MaxSize:(CGSize)maxSize
{
    NSMutableParagraphStyle* paragraphStyle = [[NSMutableParagraphStyle alloc]init];
    paragraphStyle.lineBreakMode=NSLineBreakByWordWrapping;
    NSDictionary* attributes = @{NSFontAttributeName:font,NSParagraphStyleAttributeName:paragraphStyle.copy};
    CGSize labelSize = [text boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading|NSStringDrawingTruncatesLastVisibleLine attributes:attributes context: nil ].size;
    labelSize.height=ceil(labelSize.height);
    labelSize.width=ceil(labelSize.width);
    return  labelSize;
}


@end
