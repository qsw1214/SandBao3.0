//
//  AccountManageViewController.m
//  sandbao
//
//  Created by tianNanYiHao on 2017/4/14.
//  Copyright © 2017年 sand. All rights reserved.
//

#import "AccountManageViewController.h"
#import "MiBaoSetViewController.h"
#import "LoginViewController.h"
#import "PayNucHelper.h"
#import "SDLog.h"
#import "CommParameter.h"
#import "VerifiNewPhoneViewController.h"
#import "SDSqlite.h"
#import "SqliteHelper.h"



#define navbarColor RGBA(255, 255, 255, 1.0)

#define navViewColor RGBA(249, 249, 249, 1.0)

#define lineViewColor RGBA(237, 237, 237, 1.0)

#define titleColor RGBA(174, 174, 174, 1.0)

#define textFiledColor RGBA(83, 83, 83, 1.0)

#define btnColor RGBA(255, 97, 51, 1.0)

#define viewColor RGBA(255, 255, 255, 1.0)

@interface AccountManageViewController ()<UITextFieldDelegate>
{
     NavCoverView *navCoverView;
    
}
@property (nonatomic, assign) CGSize viewSize;
@property (nonatomic, assign) CGFloat viewTop;
@property (nonatomic, assign) CGFloat textSize;
@property (nonatomic, assign) CGFloat tableViewTop;
@property (nonatomic, assign) CGFloat leftRightSpace;
@property (nonatomic, assign) CGFloat header;
@property (nonatomic, assign) CGFloat footer;
@property (nonatomic, assign) CGFloat titleLabSize;

@property (nonatomic, assign) CGFloat cellHeight;
@property (nonatomic, assign) CGFloat tableViewHeight;
@property (nonatomic, assign) BOOL changeBtnImageFlag;

@property (nonatomic, strong) SDMBProgressView *HUD;

@property (nonatomic, strong) NSMutableArray *payInorderArray;
@property (nonatomic, strong) UITableView *payInOrderTableview;
@property (nonatomic, strong) UIButton *gesturePwdBtn;

@property (nonatomic, strong) UISwitch *switchView;
@property (nonatomic, strong) UIView *headerView;
@property (nonatomic, strong) UILabel *tipLab;
@property (nonatomic, strong) UITextField *nameTextfiled;

@end

@implementation AccountManageViewController
@synthesize viewSize;
@synthesize viewTop;
@synthesize textSize;
@synthesize titleLabSize;
@synthesize tableViewTop;
@synthesize leftRightSpace;
@synthesize header;
@synthesize footer;
@synthesize cellHeight;
@synthesize tableViewHeight;
@synthesize changeBtnImageFlag;
@synthesize headerView;
@synthesize HUD;

@synthesize tipLab;

@synthesize payInOrderTableview;
@synthesize gesturePwdBtn;


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    viewSize = self.view.bounds.size;
    leftRightSpace = 15;
    
    [self.view setBackgroundColor:RGBA(242, 242, 242, 1.0)];
    
    

    
    
    _payInorderArray = [NSMutableArray arrayWithCapacity:0];
    
    [self settingNavigationBar];
    [self addView:self.view];

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
    navCoverView = [NavCoverView shareNavCoverView:CGRectMake(0, 0, viewSize.width, controllerTop) title:@"账户管理"];
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

-(void)addView:(UIView *)view
{
    viewTop = 64;
    tableViewTop = 0;
    header = 10;
    footer = 0.1;
    

        cellHeight = 58;
        textSize = 13;
        titleLabSize = 14;

    
    //switchView
    UIView *nameBgview = [[UIView alloc] init];
    [view addSubview:nameBgview];
    nameBgview.backgroundColor = [UIColor whiteColor];
    
    UILabel *nameLab = [[UILabel alloc] init];
    nameLab.text = @"昵称";
    nameLab.textColor = textFiledColor;
    nameLab.textAlignment = NSTextAlignmentLeft;
    nameLab.font = [UIFont systemFontOfSize:titleLabSize];
    [nameBgview addSubview:nameLab];
    
    
    _nameTextfiled = [[UITextField alloc] init];
    _nameTextfiled.text = [CommParameter sharedInstance].nick;
    _nameTextfiled.font = [UIFont systemFontOfSize:titleLabSize];
    _nameTextfiled.placeholder = @"赶快为您设置一个响亮的昵称吧";
    _nameTextfiled.userInteractionEnabled = NO;
    _nameTextfiled.delegate = self;
    [_nameTextfiled setMinLenght:@"2"];
    [_nameTextfiled setMaxLenght:@"10"];
    [nameBgview addSubview:_nameTextfiled];
    
    
    
    UIImage *nameImage = [UIImage imageNamed:@"edit"];
    UIImage *nameImageSelect = [UIImage imageNamed:@"management_ok"];
    UIButton *nameBtn = [[UIButton alloc] init];
    nameBtn.frame = CGRectZero;
    nameBtn.tag = 301;
    [nameBtn setImage:nameImage forState:UIControlStateNormal];
    [nameBtn setImage:nameImageSelect forState:UIControlStateSelected];
    [nameBtn addTarget:self action:@selector(buttonActionToDoSomething:) forControlEvents:UIControlEventTouchUpInside];
    [nameBgview addSubview:nameBtn];
    
    
    
    
    
    
    //设置控件的位置和大小
    CGSize nameLabSize = [nameLab.text sizeWithNSStringFont:[UIFont systemFontOfSize:titleLabSize]];
    CGFloat nameBgViewH = nameLabSize.height + 2*leftRightSpace;
    CGFloat nameTextfileW = viewSize.width - 10 - nameImage.size.width - 2*leftRightSpace - nameLabSize.width;
    
    
    [nameBgview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(view).offset(viewTop);
        make.centerX.equalTo(view).offset(0);
        make.size.mas_equalTo(CGSizeMake(viewSize.width, nameBgViewH));
    }];
    [nameLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(nameBgview).offset(leftRightSpace);
        make.centerY.equalTo(nameBgview.mas_centerY).offset(0);
        make.size.mas_equalTo(nameLabSize);
    }];
    
    [_nameTextfiled mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(nameLab.mas_right).offset(10);
        make.centerY.equalTo(nameBgview).offset(0);
        make.size.mas_equalTo(CGSizeMake(nameTextfileW, nameLabSize.height+2*leftRightSpace));
    }];

    [nameBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_nameTextfiled.mas_right).offset(0);
        make.centerY.equalTo(nameBgview).offset(0);
        make.size.mas_equalTo(CGSizeMake(nameImage.size.width, nameImage.size.height));
    }];
    
    [self setInputResponderChain];
    [self listenNotifier];
}

-(void)load{
    HUD = [SDMBProgressView showSDMBProgressOnlyLoadingINViewImg:self.view];
    [SDRequestHelp shareSDRequest].HUD = HUD;
    [SDRequestHelp shareSDRequest].controller = self;
    [[SDRequestHelp shareSDRequest] dispatchGlobalQuque:^{
        __block BOOL error = NO;
        paynuc.set("tTokenType", "01001401");
        [[SDRequestHelp shareSDRequest] requestWihtFuncName:@"token/getTtoken/v1" errorBlock:^(SDRequestErrorType type) {
            error = YES;
        } successBlock:^{
            
        }];
        if (error) return ;
        
        [[SDRequestHelp shareSDRequest] requestWihtFuncName:@"user/queryInfo/v1" errorBlock:^(SDRequestErrorType type) {
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
                
                //nick昵称
                _nameTextfiled.text = [CommParameter sharedInstance].nick;
 
            }];
        }];
        if (error) return ;
    
    }];
}


#pragma mark - 把所有的输入框放到数组中
/**
 *@brief 把所有的输入框放到数组中
 *@return NSArray
 */
- (NSArray *)allInputFields {
    return @[_nameTextfiled];
}


#pragma mark - UITextFieldDelegate

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
    
    _nameTextfiled.returnKeyType = UIReturnKeyDone;
    
    
}

/**
 *当用户按下return键或者按回车键，我们注销KeyBoard响应，它会自动调用textFieldDidEndEditing函数
 */
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (textField.returnKeyType == UIReturnKeyDone) {
        [self dismissKeyboard];
    }
    
    return YES;
}

#pragma mark - 监听通知
- (void)listenNotifier
{
    if (_nameTextfiled) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFiledEditChanged:) name:UITextFieldTextDidChangeNotification object:_nameTextfiled];
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
            textField.text = [content substringWithRange:NSMakeRange(0, lenght - 1)];
            return;
        }
    }
    
    
    
}
#pragma mark - 限制键盘输入某些字符
-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    
    if ([textField.placeholder rangeOfString:@"昵称"].location !=NSNotFound) {
        return [self restrictionwithChineseCharTypeStr:OnlyChineseCharacterVerifi string:string];
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


/**
 *@brief 隐藏键盘
 */
- (void)dismissKeyboard {
    
    [self.view endEditing:YES];
}

-(void)startChange:(UISwitch*)sender{
    
    if (sender.on) {
        headerView.hidden = YES;
        payInOrderTableview.hidden = YES;
        tipLab.hidden = YES;
    }else{
        headerView.hidden = NO;
        payInOrderTableview.hidden = NO;
        tipLab.hidden = NO;
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
        case 101:
        {
            [self.navigationController popViewControllerAnimated:YES];
        }
            break;
        case 201:
        {
            
        }
            break;
        case 301:
        {
            if (btn.selected) {
                [self verificationInput];
                btn.selected = NO;
                _nameTextfiled.userInteractionEnabled = NO;
            }else{
                _nameTextfiled.userInteractionEnabled = YES;
                [_nameTextfiled becomeFirstResponder]; //键盘弹起
                btn.selected = YES;
                
            }
        }
            break;
        default:
            break;
    }
}

/**
 *@brief 输入数据验证
 */
- (void)verificationInput
{

    if (_nameTextfiled.text.length > [_nameTextfiled.maxLenght intValue] || _nameTextfiled.text.length == 0) {
        return [Tool showDialog:@"昵称输入不正确,请重新输入"];
    }
    
    [self resetUserBaseInfo];
}


/**
 修改用户信息
 */
-(void)resetUserBaseInfo{
    
    //
    HUD = [SDMBProgressView showSDMBProgressOnlyLoadingINViewImg:self.view];
    [SDRequestHelp shareSDRequest].HUD = HUD;
    [SDRequestHelp shareSDRequest].controller = self;
    [[SDRequestHelp shareSDRequest] dispatchGlobalQuque:^{
        __block BOOL error = NO;
        paynuc.set("tTokenType", "01002001");
        [[SDRequestHelp shareSDRequest] requestWihtFuncName:@"token/getTtoken/v1" errorBlock:^(SDRequestErrorType type) {
            error = YES;
        } successBlock:^{
            
        }];
        if (error) return ;
        
        
        NSMutableDictionary *userInfo = [NSMutableDictionary dictionaryWithCapacity:0];
        [userInfo setValue:_nameTextfiled.text forKey:@"nick"];
        [userInfo setValue:@"" forKey:@"avatar"];
        [userInfo setValue:@"" forKey:@"remainState"];
        NSString *userInfostr = [[PayNucHelper sharedInstance] dictionaryToJson:userInfo];
        paynuc.set("userInfo", [userInfostr UTF8String]);
        [[SDRequestHelp shareSDRequest] requestWihtFuncName:@"user/resetUserBaseInfo/v1" errorBlock:^(SDRequestErrorType type) {
            error = YES;
        } successBlock:^{
            [[SDRequestHelp shareSDRequest] dispatchToMainQueue:^{
                [HUD hidden];
                
                [CommParameter sharedInstance].nick = _nameTextfiled.text;
                [Tool showDialog:@"昵称修改成功"];
            }];
        }];
        if (error) return ;
    }];

}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
