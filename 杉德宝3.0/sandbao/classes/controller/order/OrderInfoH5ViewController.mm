//
//  OrderInfoH5ViewController.m
//  sandbao
//
//  Created by tianNanYiHao on 2017/4/13.
//  Copyright © 2017年 sand. All rights reserved.
//

#import "OrderInfoH5ViewController.h"


#import "WebViewProgressView.h"
#import "CommParameter.h"
#import "SandMajlet.h"
#import "PayNucHelper.h"
#import "SDLog.h"
#import "SDPayView.h"
#import "OrderInfoNatiVeViewController.h"
#import "BindingSandViewController.h"
#import "RechargeResultViewController.h"
#import "VerificationModeViewController.h"
#import "SandPwdViewController.h"

typedef void(^OrderInfoPayStateBlock)(NSArray *paramArr);
@interface OrderInfoH5ViewController ()<WebViewProgressViewDelegate, SandMajletDelete, SDPayViewDelegate>
{
    NavCoverView *navCoverView;
    NSMutableArray *payToolsArrayUsableM;  //可用支付工具
    NSMutableArray *payToolsArrayUnusableM; //不可用支付工具
    NSMutableDictionary *currentPayToolDic; //当前选择的支付工具
    
    NSArray *payToolsArray;
    NSDictionary *orderDic;
}

@property (nonatomic, assign) CGSize viewSize;

@property (nonatomic, strong) SDMBProgressView *HUD;


@property (nonatomic, strong) WebViewProgressView *progressView;
@property (nonatomic, strong) SandMajlet *mSandMajlet;
@property (nonatomic, strong) SDPayView *payView;
@property (nonatomic, copy) NSMutableArray *payModeArray;
@property (nonatomic, copy) NSMutableDictionary *payModeDic;
@property (nonatomic,assign) float limitFloat;
@property (nonatomic, strong)NSString *TN;


@end

@implementation OrderInfoH5ViewController

@synthesize viewSize;

@synthesize HUD;


@synthesize progressView;
@synthesize mSandMajlet;
@synthesize payView;
@synthesize payModeArray;
@synthesize payModeDic;



- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.view setBackgroundColor:RGBA(242, 242, 242, 1.0)];
    viewSize = self.view.bounds.size;
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    mSandMajlet = [[SandMajlet alloc] init];
    mSandMajlet.delegate = self;
    
    [self settingNavigationBar];
    [self addView:self.view];
}

#pragma mark - 设置导航栏
/**
 *@brief 设置导航栏
 *@return
 */
- (void)settingNavigationBar
{
    //导航渐变条
    navCoverView = [NavCoverView shareNavCoverView:CGRectMake(0, 0, viewSize.width, controllerTop) title:@"手机充值"];
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
    progressView = [[WebViewProgressView alloc] initWithFrame:CGRectMake(0, 64, viewSize.width, viewSize.height - 64)];
    progressView.delegate = self;
    [view addSubview:progressView];
    self.automaticallyAdjustsScrollViewInsets = NO;
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
    
    NSString *requestString = [NSString stringWithFormat:@"%@%@", @"http://test.sandlife.com.cn/index.php/lifeh5-mobile.html?sandtoken=", [CommParameter sharedInstance].sToken];
    
    [progressView loadURLString:requestString];
    
    payView = [SDPayView getPayView];
    payView.delegate = self;
    [self.view addSubview:payView];
    
}

#pragma mark --webViewDelegate

//准备加载内容时调用的方法，通过返回值来进行是否加载的设置
- (void)cusWebView:(UIWebView *)webview shouldStartLoadWithURL:(NSURL *)URL
{
    
}

//开始加载时调用的方法
- (void)cusWebViewDidStartLoad:(UIWebView *)webview
{
    
}

//结束加载时调用的方法
-(void)cusWebView:(UIWebView *)webview didFinishLoadingURL:(NSURL *)URL
{
    NSLog(@"截取到URL：%@",URL);
    
    JSContext *mJSContext = [webview valueForKeyPath:@"documentView.webView.mainFrame.javaScriptContext"];
    
    mJSContext[@"SandMajlet"] = mSandMajlet;
}

//加载失败时调用的方法
- (void)cusWebView:(UIWebView *)webview didFailToLoadURL:(NSURL *)URL error:(NSError *)error
{
    
}

#pragma mark  -- SandMajletDelete
- (void)SandMajletIndex:(NSInteger)paramInt paramString:(NSString *)paramString
{
    if (paramInt == 0) {
        _TN = paramString;
        //回主线程-(预防有UI操作)
        dispatch_async(dispatch_get_main_queue(), ^{
             [self TNOrder:paramString];
        });
        
       
    }
}

#pragma mark - 业务逻辑

/**
 *@brief   根据tn号获取订单信息
 *@param TN NSString 参数：tn号
 *@return
 */
- (void)TNOrder:(NSString*)TN
{
    HUD = [SDMBProgressView showSDMBProgressOnlyLoadingINViewImg:self.view];
    [SDRequestHelp shareSDRequest].HUD = HUD;
    [SDRequestHelp shareSDRequest].controller = self;
    [[SDRequestHelp shareSDRequest] dispatchGlobalQuque:^{
        __block BOOL error = NO;
        paynuc.set("cfg_httpAddress", [[NSString stringWithFormat:@"%@app/api/",AddressHTTP] UTF8String]);
        paynuc.set("tTokenType", "04000101");
        [[SDRequestHelp shareSDRequest] requestWihtFuncName:@"token/getTtoken/v1" errorBlock:^(SDRequestErrorType type) {
            error = YES;
        } successBlock:^{
            
        }];
        if (error) return ;
        
        
        
        NSMutableDictionary *workDic = [[NSMutableDictionary alloc] init];
        [workDic setValue:@"tnPay" forKey:@"type"];
        [workDic setValue:@"" forKey:@"merOrderId"];
        [workDic setValue:TN forKey:@"sandTN"];
        [workDic setValue:@"" forKey:@"thirdParty"];
        [workDic setValue:@"" forKey:@"transAmt"];
        [workDic setValue:@"" forKey:@"remark"];
        [workDic setValue:@"" forKey:@"feeType"];
        [workDic setValue:@"" forKey:@"fee"];
        [workDic setValue:@"" forKey:@"feeRate"];
        
        NSString *work = [[PayNucHelper sharedInstance] dictionaryToJson:workDic];
        [SDLog logDebug:work];
        
        paynuc.set("cfg_httpAddress", [[NSString stringWithFormat:@"%@app/api/",AddressHTTP] UTF8String]);
        paynuc.set("work", [work UTF8String]);
        [[SDRequestHelp shareSDRequest] requestWihtFuncName:@"payTool/getPayToolsForPay/v1" errorBlock:^(SDRequestErrorType type) {
            error = YES;
        } successBlock:^{
            [[SDRequestHelp shareSDRequest] dispatchToMainQueue:^{
                [HUD hidden];
                
                
                NSString *payTools = [NSString stringWithUTF8String:paynuc.get("payTools").c_str()];
                payToolsArray = [[PayNucHelper sharedInstance] jsonStringToArray:payTools];
                NSString *order = [NSString stringWithUTF8String:paynuc.get("order").c_str()];
                orderDic = [[PayNucHelper sharedInstance] jsonStringToDictionary:order];
                
                [self setPayTools];
            }];
        }];
        if (error) return ;
    }];

}


#pragma mark - 设置支付工具列表
-(void)setPayTools{
    
    //排序
    payToolsArray = [Tool orderForPayTools:payToolsArray];
    if ([payToolsArray count] <= 0) {
        [Tool showDialog:@"无可用方式,请绑卡重试" defulBlock:^{
            BindingSandViewController *mBindingSandViewController = [[BindingSandViewController alloc] init];
            [self.navigationController pushViewController:mBindingSandViewController animated:YES];
        }];
    }else{
        //1.过滤用支付工具
        payToolsArrayUsableM = [NSMutableArray arrayWithCapacity:0];
        payToolsArrayUnusableM = [NSMutableArray arrayWithCapacity:0];
        for (int i = 0; i<payToolsArray.count; i++) {
            if ([@"0" isEqualToString:[NSString stringWithFormat:@"%@",[[payToolsArray[i] objectForKey:@"account"] objectForKey:@"useableBalance"]]] || [[payToolsArray[i] objectForKey:@"available"] boolValue]== NO) {
                //不可用支付工具集
                [payToolsArrayUnusableM addObject:payToolsArray[i]];
            }else{
                //可用支付工具集
                [payToolsArrayUsableM addObject:payToolsArray[i]];
            }
        }
        
        //3.设置支付方式列表
        [self initPayMode:payToolsArray];
    }
    
    
}


/**
 *@brief 初始化支付方式
 */
- (void)initPayMode:(NSArray *)paramArray
{
    
    NSMutableDictionary *bankDic = [[NSMutableDictionary alloc] init];
    [bankDic setValue:@"PAYLTOOL_LIST_ACCPASS" forKey:@"type"];
    [bankDic setValue:@"添加杉德卡支付" forKey:@"title"];
    [bankDic setValue:@"list_sand_AddCard" forKey:@"img"];
    [bankDic setValue:@"" forKey:@"limit"];
    [bankDic setValue:@"2" forKey:@"state"];
    [bankDic setValue:@"true" forKey:@"available"];
    [payToolsArrayUsableM addObject:bankDic];
    
    NSInteger unavailableArrayCount = [payToolsArrayUnusableM count];
    for (int i = 0; i < unavailableArrayCount; i++) {
        [payToolsArrayUsableM addObject:payToolsArrayUnusableM[i]];
    }
    payModeArray = payToolsArrayUsableM;
    
    //订单金额
    NSNumber *orderMoneyNumber = [orderDic objectForKey:@"amount"];
    NSString *orderMoney = [NSString stringWithFormat:@"¥ %.2f", [orderMoneyNumber floatValue]];
    [payView setPayInfo:payModeArray moneyStr:orderMoney orderTypeStr:@"手机充值订单"];
    [payView showPayTool];
    
}




#pragma mark - SDPayViewDelegate

- (void)payViewSelectPayToolDic:(NSMutableDictionary *)selectPayToolDict{
    
    
    //1.
    payModeDic = [[NSMutableDictionary alloc] initWithDictionary:selectPayToolDict];
    
    //根据不同支付密码类型选择UI弹出框
    currentPayToolDic = [selectPayToolDict objectForKey:@"authTools"][0];
    
    
    //2.可用金额作限制
    //订单金额
    float orderMoneyflot = [[orderDic objectForKey:@"amount"] floatValue];
    //limit金额
    _limitFloat = [[PayNucHelper sharedInstance] limitInfo:[selectPayToolDict objectForKey:@"limit"]]/100;
    
    if (orderMoneyflot>_limitFloat) {
        [Tool showDialog:@"您的可使用金额已超限,可继续付款" defulBlock:^{
        }];
        //        return;
    }
    
}

- (void)payViewPwd:(NSString *)pwdStr paySuccessView:(SDPaySuccessAnimationView *)successView{
    
    //支付动画开始
    [successView animationStart];
    
    [self pay:pwdStr orderPaySuccessBlock:^(NSArray *paramArr){
        //支付成功
        [successView animationSuccess];
        dispatch_time_t delayTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5f * NSEC_PER_SEC));
        dispatch_after(delayTime, dispatch_get_main_queue(), ^{
            RechargeResultViewController *mRechargeResultViewController = [[RechargeResultViewController alloc] init];
            mRechargeResultViewController.viewControllerIndex = SPSPay;
            mRechargeResultViewController.workDic = paramArr[0];
            mRechargeResultViewController.payToolDic = paramArr[1];
            [self.navigationController pushViewController:mRechargeResultViewController animated:YES];
        });
    } oederErrorBlock:^(NSArray *paramArr){
        //支付失败
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
        SandPwdViewController *mSandPwdViewController = [[SandPwdViewController alloc] init];
        NSMutableDictionary *accountDic = [currentPayToolDic objectForKey:@"account"];
        mSandPwdViewController.accountDic = accountDic;
        [self.navigationController pushViewController:mSandPwdViewController animated:YES];
        
    }
    
}

- (void)payViewAddPayToolCard:(NSString *)type{
    
    if ([type isEqualToString:PAYTOOL_PAYPASS]) {
        
    }
    if ([type isEqualToString:PAYTOOL_ACCPASS]) {
        BindingSandViewController *mBindingSandViewController = [[BindingSandViewController alloc] init];
        [self.navigationController pushViewController:mBindingSandViewController animated:YES];
    }
}






/**
 *@brief 支付
 *@return
 */
- (void)pay:(NSString *)param orderPaySuccessBlock:(OrderInfoPayStateBlock)successBlock oederErrorBlock:(OrderInfoPayStateBlock)errorBlock
{
    HUD = [SDMBProgressView showSDMBProgressOnlyLoadingINViewImg:self.view];
    [HUD hidden];
    [SDRequestHelp shareSDRequest].HUD = HUD;
    [SDRequestHelp shareSDRequest].controller = self;
    [[SDRequestHelp shareSDRequest] dispatchGlobalQuque:^{
        __block BOOL error = NO;
        
        NSString *transAmt = [NSString stringWithFormat:@"%.0f", [[orderDic objectForKey:@"amount"] floatValue]];
        
        NSMutableDictionary *workDic = [[NSMutableDictionary alloc] init];
        [workDic setValue:@"tnPay" forKey:@"type"];
        [workDic setValue:[orderDic objectForKey:@"orderId"] forKey:@"merOrderId"];
        [workDic setValue:_TN forKey:@"sandTN"];
        [workDic setValue:@"" forKey:@"thirdParty"];
        [workDic setValue:transAmt forKey:@"transAmt"];
        [workDic setValue:@"" forKey:@"remark"];
        [workDic setValue:@"out" forKey:@"feeType"];
        [workDic setValue:@"" forKey:@"fee"];
        [workDic setValue:@"" forKey:@"feeRate"];
        
        NSString *work = [[PayNucHelper sharedInstance] dictionaryToJson:workDic];
        [SDLog logDebug:work];
        
        NSArray *authToolsArray = [payModeDic objectForKey:@"authTools"];
        
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
        [payModeDic setObject:tempAuthToolsArray forKey:@"authTools"];
        
        NSString *payTool = [[PayNucHelper sharedInstance] dictionaryToJson:payModeDic];
        [SDLog logDebug:payTool];
        paynuc.set("work", [work UTF8String]);
        paynuc.set("payTool", [payTool UTF8String]);
        paynuc.set("authTools", [@"[]" UTF8String]);
        [[SDRequestHelp shareSDRequest] requestWihtFuncName:@"business/pay/v1" errorBlock:^(SDRequestErrorType type) {
            error = YES;
            [[SDRequestHelp shareSDRequest] dispatchToMainQueue:^{
                errorBlock(nil);
            }];
        } successBlock:^{
            [[SDRequestHelp shareSDRequest] dispatchToMainQueue:^{
                [HUD hidden];
                
                NSString *work = [NSString stringWithUTF8String:paynuc.get("work").c_str()];
                NSDictionary *workDic = [[PayNucHelper sharedInstance] jsonStringToDictionary:work];
                successBlock(@[workDic,payModeDic]);
            }];
        }];
        if (error) return ;
    }];
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



/**
 *@brief 隐藏键盘
 */
- (void)dismissKeyboard {
    //将视图的Y坐标向上移动offset个单位，以使下面腾出地方用于软键盘的显示
//    [scrollView setContentOffset:CGPointMake(0.0f, 0.0f) animated:YES] ;
    [self.view endEditing:YES];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    
    //流程结束 必须重置cfg_httpAddress 地址(返回主Api地址:paynuc工具设计如此)
    paynuc.set("cfg_httpAddress", [[NSString stringWithFormat:@"%@app/api/",AddressHTTP] UTF8String]);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
