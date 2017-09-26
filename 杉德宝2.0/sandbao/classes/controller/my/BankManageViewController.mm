//
//  BankManageViewController.m
//  sandbao
//
//  Created by tianNanYiHao on 2017/2/20.
//  Copyright © 2017年 sand. All rights reserved.
//

#import "BankManageViewController.h"


#import "SDLog.h"
#import "PayNucHelper.h"

#import "BankListViewController.h"
#import "VerificationModeViewController.h"
#import "SDPayView.h"


#define navbarColor RGBA(255, 255, 255, 1.0)

#define navViewColor RGBA(249, 249, 249, 1.0)

#define lineViewColor RGBA(237, 237, 237, 1.0)

#define titleColor RGBA(174, 174, 174, 1.0)

#define textFiledColor RGBA(83, 83, 83, 1.0)

#define btnColor RGBA(255, 97, 51, 1.0)

#define viewColor RGBA(255, 255, 255, 1.0)
typedef void(^BankManageDeletCardStateBlock)(NSArray *paramArr);
@interface BankManageViewController ()<SDPayViewDelegate>
{
    NavCoverView *navCoverView;
    NSString *authTools;
    
}

@property (nonatomic, assign) CGSize viewSize;
@property (nonatomic, assign) CGFloat viewTop;
@property (nonatomic, assign) CGFloat viewHeight;
@property (nonatomic, assign) CGFloat moveTop;
@property (nonatomic, assign) CGFloat leftRightSpace;
@property (nonatomic, assign) CGFloat lineViewHeight;
@property (nonatomic, assign) CGFloat textFieldTextSize;
@property (nonatomic, assign) CGFloat btnTextSize;
@property (nonatomic, assign) CGFloat btnW;
@property (nonatomic, assign) CGFloat btnH;
@property (nonatomic, assign) BOOL fastPayFlag;

@property (nonatomic, strong) SDMBProgressView *HUD;
@property (nonatomic, strong) SDPayView *payView;


@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UIButton *button;
@property (nonatomic, strong) NSString *payPassword;

@property (nonatomic, strong) NSMutableArray *authToolsArray;


@end

@implementation BankManageViewController

@synthesize viewSize;
@synthesize viewHeight;
@synthesize moveTop;
@synthesize leftRightSpace;
@synthesize lineViewHeight;
@synthesize textFieldTextSize;
@synthesize btnTextSize;
@synthesize btnW;
@synthesize btnH;
@synthesize fastPayFlag;


@synthesize HUD;
@synthesize payView;

@synthesize scrollView;
@synthesize button;
@synthesize payPassword;


@synthesize authToolsArray;

@synthesize payToolDic;

- (void)viewDidLoad {
    [super viewDidLoad];
    viewSize = self.view.bounds.size;
    leftRightSpace = 15;
    authToolsArray = [[NSMutableArray alloc] init];
    
    

    [self.view setBackgroundColor:RGBA(242, 242, 242, 1.0)];
    
    [self settingNavigationBar];
    
    [self addView:self.view];
}

/**
 开通卡快捷
 */
-(void)openFastPay{
    
    HUD = [SDMBProgressView showSDMBProgressOnlyLoadingINViewImg:self.view];
    [SDRequestHelp shareSDRequest].HUD = HUD;
    [SDRequestHelp shareSDRequest].controller = self;
    [[SDRequestHelp shareSDRequest] dispatchGlobalQuque:^{
        __block BOOL error = NO;
        paynuc.set("tTokenType", "01001601");
        [[SDRequestHelp shareSDRequest] requestWihtFuncName:@"token/getTtoken/v1" errorBlock:^(SDRequestErrorType type) {
            error = YES;
        } successBlock:^{
            
        }];
        if (error) return ;
        

        [[SDRequestHelp shareSDRequest] requestWihtFuncName:@"authTool/getAuthTools/v1" errorBlock:^(SDRequestErrorType type) {
            error = YES;
        } successBlock:^{
            [[SDRequestHelp shareSDRequest] dispatchToMainQueue:^{
                [HUD hidden];
                
                NSString *authToolStr = [NSString stringWithUTF8String:paynuc.get("authTools").c_str()];
                authTools = authToolStr;
                [self openFastPayTWO];

            }];
        }];
        if (error) return ;

    }];

}

-(void)openFastPayTWO{
    
    HUD = [SDMBProgressView showSDMBProgressOnlyLoadingINViewImg:self.view];
    [SDRequestHelp shareSDRequest].HUD = HUD;
    [SDRequestHelp shareSDRequest].controller = self;
    [[SDRequestHelp shareSDRequest] dispatchGlobalQuque:^{
        __block BOOL error = NO;

        NSArray *authToolsArr = [[PayNucHelper sharedInstance] jsonStringToArray:authTools];
        NSDictionary *authToolDic = authToolsArr[0];
        NSMutableDictionary *authToolDicM = [NSMutableDictionary dictionaryWithDictionary:authToolDic];
        [authToolDicM removeObjectForKey:@"sms"];
        NSMutableDictionary *smsDic = [NSMutableDictionary dictionaryWithCapacity:0];
        [smsDic setObject:@"15151474388" forKey:@"phoneNo"];
        [smsDic setObject:@"111111" forKey:@"code"];
        [authToolDicM setObject:smsDic forKey:@"sms"];
        NSMutableArray *authToolsArrM = [NSMutableArray arrayWithCapacity:0];
        
        [authToolsArrM addObject:authToolDicM];
        
        NSString *paytool = [[PayNucHelper sharedInstance] dictionaryToJson:payToolDic];
        NSString *authToolsOK = [[PayNucHelper sharedInstance] arrayToJSON:authToolsArrM];
        paynuc.set("authTools", [authToolsOK UTF8String]);
        paynuc.set("payTool", [paytool UTF8String]);
        [[SDRequestHelp shareSDRequest] requestWihtFuncName:@"card/openFastPay/v1" errorBlock:^(SDRequestErrorType type) {
            error = YES;
        } successBlock:^{
            [[SDRequestHelp shareSDRequest] dispatchToMainQueue:^{
                [HUD hidden];
                
                [Tool showDialog:@"开通快捷成功" defulBlock:^{
                    [self.navigationController popToRootViewControllerAnimated:YES];
                }];
            }];
        }];
        if (error) return ;
        
    }];

}

#pragma mark - 设置导航栏
/**
 *@brief 设置导航栏
 *@return
 */
- (void)settingNavigationBar
{

    //导航渐变条
    navCoverView = [NavCoverView shareNavCoverView:CGRectMake(0, 0, viewSize.width, controllerTop) title:@"银行卡管理"];
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
    UIButton *rightBarBtn = [[UIButton alloc] init];
    [rightBarBtn setTitle:@"管理" forState:UIControlStateNormal];
    [rightBarBtn setTitle:@"管理" forState:UIControlStateHighlighted];
    [rightBarBtn setTintColor:[UIColor whiteColor]];
    [rightBarBtn setImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
    [rightBarBtn setImage:[UIImage imageNamed:@""] forState:UIControlStateHighlighted];
    [rightBarBtn addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
    
    CGSize rightBarBtnTitleSize = [rightBarBtn.titleLabel.text sizeWithNSStringFont:rightBarBtn.titleLabel.font];
    rightBarBtn.frame = CGRectMake(viewSize.width - 10 - rightBarBtnTitleSize.width, 20 + (40 - rightBarBtnTitleSize.height) / 2, rightBarBtnTitleSize.width, rightBarBtnTitleSize.height);
    rightBarBtn.tag = 102;
    [navCoverView addSubview:rightBarBtn];
}



/**
 根据银行名字改变icon 底色
 @param dic payToolDic
 */
-(NSArray*)changeIconImage:(NSDictionary*)dic{
    
    NSArray *arr = [Tool getBankIconInfo:[dic objectForKey:@"title"]];
    
    return arr;
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

        titleSize = 17;
        textFieldTextSize = 14;
        btnTextSize = 16;

    
    //创建UIScrollView
    scrollView = [[UIScrollView alloc] init];
    scrollView.userInteractionEnabled = YES;
    scrollView.scrollEnabled = NO;
    scrollView.contentSize = CGSizeMake(viewSize.width, viewSize.height - controllerTop);
    scrollView.directionalLockEnabled = YES; //只能一个方向滑动
    scrollView.pagingEnabled = NO; //是否翻页
    scrollView.showsVerticalScrollIndicator =YES; //垂直方向的滚动指示
    scrollView.indicatorStyle = UIScrollViewIndicatorStyleWhite;//滚动指示的风格
    scrollView.showsHorizontalScrollIndicator = NO;//水平方向的滚动指示
    [scrollView setBackgroundColor:RGBA(242, 242, 242, 1.0)];
    [view addSubview:scrollView];
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    NSArray *arrbackColor =  [self changeIconImage:payToolDic];
    UIColor *bankColor = arrbackColor[2];
    UIColor *bankColor2 = arrbackColor[3];
    UIView *bankView = [[UIView alloc] init];
    bankView.layer.cornerRadius = 5;
    bankView.layer.masksToBounds = YES;
    [scrollView addSubview:bankView];
    
    CAGradientLayer *gradientLayer = [CAGradientLayer layer];
    gradientLayer.colors = @[
                              (__bridge id)bankColor.CGColor,
                              (__bridge id)bankColor2.CGColor
                            ];
    gradientLayer.startPoint = CGPointMake(0.5f, 1);
    gradientLayer.endPoint = CGPointMake(0.5f, 0);
    [bankView.layer addSublayer:gradientLayer];

    
    UIView *bankInfoView = [[UIView alloc] init];
    bankInfoView.backgroundColor = [UIColor clearColor];
    [bankView addSubview:bankInfoView];
    
    UIImage *iconImage = [self changeIconImage:payToolDic][0];
    UIView *iconImageBackView = [[UIView alloc] init];
    iconImageBackView.backgroundColor = [UIColor whiteColor];
    iconImageBackView.layer.cornerRadius = (iconImage.size.width+5)/2;
    iconImageBackView.layer.masksToBounds = YES;
    [bankInfoView addSubview:iconImageBackView];
    
    
    
    UIImageView *iconImageView = [[UIImageView alloc] init];
    iconImageView.image = iconImage;
    iconImageView.backgroundColor = [UIColor whiteColor];
    iconImageView.layer.cornerRadius = iconImage.size.width/2;
    iconImageView.layer.masksToBounds = YES;
    iconImageView.contentMode = UIViewContentModeScaleAspectFit;
    [iconImageBackView addSubview:iconImageView];
    
    UILabel *bankNameLabel = [[UILabel alloc] init];
    bankNameLabel.text = [payToolDic objectForKey:@"title"];
    bankNameLabel.textColor = RGBA(255, 255, 255, 1.0);
    bankNameLabel.font = [UIFont systemFontOfSize:titleSize];
    [bankInfoView addSubview:bankNameLabel];
    
    UILabel *bankTypeLabel = [[UILabel alloc] init];
    bankTypeLabel.text = [self getBankType];
    bankTypeLabel.textColor = RGBA(255, 255, 255, 1.0);
    bankTypeLabel.font = [UIFont systemFontOfSize:titleSize];
    [bankInfoView addSubview:bankTypeLabel];
    
    UILabel *bankNumLabel = [[UILabel alloc] init];
    NSDictionary *accountDic = [payToolDic objectForKey:@"account"];
    bankNumLabel.text = [NSString stringWithFormat:@"**** **** **** %@", [accountDic objectForKey:@"accNo"]];
    bankNumLabel.textColor = RGBA(255, 255, 255, 1.0);
    bankNumLabel.font = [UIFont systemFontOfSize:textFieldTextSize];
    [bankInfoView addSubview:bankNumLabel];
    
    // 按钮
    button = [[UIButton alloc] init];
    [button setTag:1];
    
    fastPayFlag = [[payToolDic objectForKey:@"fastPayFlag"] boolValue];
    [button setTitle:fastPayFlag?@"开通快捷":@"转账" forState: UIControlStateNormal];
    [button setTitleColor:RGBA(255, 255, 255, 1.0) forState:UIControlStateNormal];
    button.titleLabel.font = [UIFont systemFontOfSize:btnTextSize];
    [button.layer setMasksToBounds:YES];
    button.layer.cornerRadius = 5.0;
    button.layer.borderWidth = 1;
    button.tag = 103;
    button.layer.borderColor = [RGBA(255, 255, 255, 1.0) CGColor];
    [button addTarget:self action:@selector(buttonActionToDoSomething:) forControlEvents:UIControlEventTouchUpInside];
    [bankInfoView addSubview:button];
    
    // 设置控件的位置和大小
    CGFloat space = 10.0;
    CGFloat bankNumLabelTop = 25;
    
    CGFloat commWidth = viewSize.width - 2 * leftRightSpace;
    
    CGSize buttonSize = [button.titleLabel.text sizeWithNSStringFont:button.titleLabel.font];
    btnW = buttonSize.width + 2 * 5;
    btnH = buttonSize.height + 2 * 10;
    
    CGFloat labelWidth = commWidth - 3 *leftRightSpace - iconImage.size.width - btnW;
    CGSize bankNameLabelSize = [bankNameLabel sizeThatFits:CGSizeMake(labelWidth, MAXFLOAT)];
    CGSize bankTypeLabelSize = [bankTypeLabel sizeThatFits:CGSizeMake(labelWidth, MAXFLOAT)];
    CGSize bankNumLabelSize = [bankNumLabel sizeThatFits:CGSizeMake(labelWidth, MAXFLOAT)];
    
    CGFloat bankInfoViewHeight = bankNameLabelSize.height + space + bankTypeLabelSize.height + bankNumLabelTop + bankNumLabelSize.height;
    
    CGFloat bankViewHeight = bankInfoViewHeight + 2 * 10;
    gradientLayer.frame = CGRectMake(0, 0, viewSize.width, bankViewHeight);
    
    [scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(navCoverView.mas_bottom).offset(0);
        make.centerX.equalTo(view);
        make.size.mas_equalTo(CGSizeMake(viewSize.width-2*space, viewSize.height - controllerTop));
    }];
    
    [bankView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(scrollView).offset(leftRightSpace);
        make.centerX.equalTo(scrollView);
        make.size.mas_equalTo(CGSizeMake(viewSize.width-2*space, bankViewHeight));
    }];
    
    [bankInfoView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(bankView);
        make.size.mas_equalTo(CGSizeMake(commWidth, bankInfoViewHeight));
    }];
    
    
    [iconImageBackView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(bankInfoView).offset(0);
        make.left.equalTo(bankInfoView).offset(0);
        make.size.mas_equalTo(CGSizeMake(iconImage.size.width+5, iconImage.size.height+5));
    }];
    
    [iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(iconImageBackView).offset(5/2.f);
        make.left.equalTo(iconImageBackView).offset(5/2.f);
    }];
    
    [bankNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(bankInfoView).offset(0);
        make.left.equalTo(iconImageView.mas_right).offset(leftRightSpace);
        make.size.mas_equalTo(CGSizeMake(labelWidth, bankNameLabelSize.height));
    }];
    
    [bankTypeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(bankNameLabel.mas_bottom).offset(space);
        make.left.equalTo(iconImageView.mas_right).offset(leftRightSpace);
        make.size.mas_equalTo(CGSizeMake(labelWidth, bankTypeLabelSize.height));
    }];
    
    [bankNumLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(bankTypeLabel.mas_bottom).offset(bankNumLabelTop);
        make.left.equalTo(iconImageView.mas_right).offset(leftRightSpace);
        make.size.mas_equalTo(CGSizeMake(labelWidth, bankNumLabelSize.height));
    }];
    
    [button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(bankNameLabel.mas_right).offset(leftRightSpace);
        make.centerY.equalTo(bankInfoView);
        make.size.mas_equalTo(CGSizeMake(btnW, btnH));
    }];
    
    
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
            
        }
            break;
        case 201:
        {
            
        }
            break;
        case 202:
        {
            
        }
            break;
        case 203:
        {
            
        }
            break;
        case 301:
        {
            
        }
            break;
        case 302:
        {
            
            
        }
            break;
        case 303:
        {
            
            
        }
            break;
        case 101:
        {
            [self.navigationController popViewControllerAnimated:YES];
        }
            break;
        case 102:
        {
            
            [SDAlertControllerUtil showAlertControllerWihtTitle:nil message:@"管理我的银行卡" actionArray:@[@"删除",@"取消"] presentedViewController:self actionBlock:^(NSInteger index) {
                //删除
                if (index == 0) {
                    [self getAuthTools];
                }
            }];
            
        }
            break;
        case 103:
        {
            if (fastPayFlag) {
                [self openFastPay]; //开通快捷
            }else
            {
                //转账func
                [Tool showDialog:@"哎呀,功能还在开发中..."];
            }
            
        }
            break;
        default:
            break;
    }
}


/**
 *  获取类型
 *
 *  @return  类型
 */
- (NSString *)getBankType
{
    NSString *bankType;
    NSString *type = [payToolDic objectForKey:@"type"];
    if ([@"1001" isEqualToString:type]) {
        bankType = @"快捷借记卡";
    }
    if ([@"1002" isEqualToString:type]) {
        bankType = @"快捷贷记卡";
    }
    if ([@"1003" isEqualToString:type]) {
        bankType = @"记名卡主账户";
    }
    if ([@"1004" isEqualToString:type]) {
        bankType = @"杉德卡钱包";
    }
    if ([@"1005" isEqualToString:type]) {
        bankType = @"杉德现金账户";
    }
    if ([@"1006" isEqualToString:type]) {
        bankType = @"杉德消费账户";
    }
    if ([@"1007" isEqualToString:type]) {
        bankType = @"久璋宝杉德账户";
    }
    if ([@"1008" isEqualToString:type]) {
        bankType = @"久璋宝专用账户";
    }
    if ([@"1009" isEqualToString:type]) {
        bankType = @"久璋宝通用账户";
    }
    if ([@"1010" isEqualToString:type]) {
        bankType = @"会员卡账户";
    }
    if ([@"1011" isEqualToString:type]) {
        bankType = @"网银借记卡";
    }
    if ([@"1012" isEqualToString:type]) {
        bankType = @"网银贷记卡";
    }
    
    
    return bankType;
}


#pragma mark - 业务逻辑

/**
 *@brief 获取鉴权工具
 */
- (void)getAuthTools
{
    HUD = [SDMBProgressView showSDMBProgressOnlyLoadingINViewImg:self.view];
    [SDRequestHelp shareSDRequest].HUD = HUD;
    [SDRequestHelp shareSDRequest].controller = self;
    [[SDRequestHelp shareSDRequest] dispatchGlobalQuque:^{
        __block BOOL error = NO;
        paynuc.set("tTokenType", "01000901");
        [[SDRequestHelp shareSDRequest] requestWihtFuncName:@"token/getTtoken/v1" errorBlock:^(SDRequestErrorType type) {
            error = YES;
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
                
                if ([authToolsArray count] <= 0) {
                    [Tool showDialog:@"获取失败"];
                } else {
                    //根据不同支付密码类型选择UI弹出框
                    NSMutableDictionary *dic = authToolsArray[0];
                    [payView setPayInfo:@[dic] moneyStr:nil orderTypeStr:nil];
                    [payView showPayTool];
                }
            }];
        }];
        if (error) return ;
    }];
}

#pragma mark - SDPayViewDelegate
- (void)payViewPwd:(NSString *)pwdStr paySuccessView:(SDPaySuccessAnimationView *)successView{
    
    //动画开始
    [successView animationStart];
    
    payPassword = pwdStr;
    [self unbandCardbankCradDeleteSuccessed:^(NSArray *paramArr){
        //解绑成功
        [successView animationSuccess];
        dispatch_time_t delayTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5f * NSEC_PER_SEC));
        dispatch_after(delayTime, dispatch_get_main_queue(), ^{
             [self ownPayTools];
        });
    } bankCardDelError:^(NSArray *paramArr){
        //解绑失败
        [successView animationStopClean];
        [payView hidPayTool];
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



/**
 *@brief  解绑
 */
- (void)unbandCardbankCradDeleteSuccessed:(BankManageDeletCardStateBlock)successBlock bankCardDelError:(BankManageDeletCardStateBlock)errorBlock
{
    HUD = [SDMBProgressView showSDMBProgressOnlyLoadingINViewImg:self.view];
    [HUD hidden];
    [SDRequestHelp shareSDRequest].HUD = HUD;
    [SDRequestHelp shareSDRequest].controller = self;
    [[SDRequestHelp shareSDRequest] dispatchGlobalQuque:^{
        __block BOOL error = NO;
        NSMutableArray *tempAuthToolsArray = [[NSMutableArray alloc] init];
        
        NSMutableDictionary *dic = authToolsArray[0];
        NSMutableDictionary *authToolsDic = [NSMutableDictionary dictionaryWithDictionary:dic];
        [authToolsDic removeObjectForKey:@"pass"];
        NSMutableDictionary *passDic = [[NSMutableDictionary alloc] init];
        [passDic setValue:[[PayNucHelper sharedInstance] pinenc:payPassword type:@"paypass"] forKey:@"password"];
        [passDic setValue:@"" forKey:@"description"];
        [passDic setValue:@"" forKey:@"encryptType"];
        [passDic setValue:@"" forKey:@"regular"];
        [authToolsDic setObject:passDic forKey:@"pass"];
        [tempAuthToolsArray addObject:authToolsDic];
        NSString *authToolS = [[PayNucHelper sharedInstance] arrayToJSON:tempAuthToolsArray];
        paynuc.set("authTools", [authToolS UTF8String]);
        [[SDRequestHelp shareSDRequest] requestWihtFuncName:@"authTool/setAuthTools/v1" errorBlock:^(SDRequestErrorType type) {
            error = YES;
            [[SDRequestHelp shareSDRequest] dispatchToMainQueue:^{
                errorBlock(nil);
            }];
        } successBlock:^{
        }];
        if (error) return ;
        

        NSString *payTool = [[PayNucHelper sharedInstance] dictionaryToJson:payToolDic];
        paynuc.set("payTool", [payTool UTF8String]);
        [[SDRequestHelp shareSDRequest] requestWihtFuncName:@"card/unbandCard/v1" errorBlock:^(SDRequestErrorType type) {
            error = YES;
            [[SDRequestHelp shareSDRequest] dispatchToMainQueue:^{
                errorBlock(nil);
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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
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
            [[SDRequestHelp shareSDRequest] dispatchToMainQueue:^{
                [Tool showDialog:@"解绑成功" defulBlock:^{
                    [self.navigationController popToRootViewControllerAnimated:YES];
                }];
            }];
        } successBlock:^{
            
        }];
        if (error) return ;
        
        
        paynuc.set("payToolKinds", "[]");
        [[SDRequestHelp shareSDRequest] requestWihtFuncName:@"payTool/getOwnPayTools/v1" errorBlock:^(SDRequestErrorType type) {
            error = YES;
            [[SDRequestHelp shareSDRequest] dispatchToMainQueue:^{
                [Tool showDialog:@"解绑成功" defulBlock:^{
                    [self.navigationController popToRootViewControllerAnimated:YES];
                }];
            }];
        } successBlock:^{
            [[SDRequestHelp shareSDRequest] dispatchToMainQueue:^{
                [HUD hidden];
                
                NSArray *payToolsArray = [[PayNucHelper sharedInstance] jsonStringToArray:[NSString stringWithUTF8String:paynuc.get("payTools").c_str()]];
                //支付工具排序
                payToolsArray = [Tool orderForPayTools:payToolsArray];
                [CommParameter sharedInstance].ownPayToolsArray = payToolsArray;
                [Tool showDialog:@"解绑成功" defulBlock:^{
                    [self.navigationController popToRootViewControllerAnimated:YES];
                }];
            }];
        }];
        if (error) return ;
    }];
    
}


@end
