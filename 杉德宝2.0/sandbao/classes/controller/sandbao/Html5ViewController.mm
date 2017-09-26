//
//  Html5ViewController.m
//  sandbao
//
//  Created by tianNanYiHao on 2017/4/7.
//  Copyright © 2017年 sand. All rights reserved.
//

#import "Html5ViewController.h"
#import "WebViewProgressView.h"
#import "SandMajletDemo.h"
#import "SDLog.h"
#import "PayNucHelper.h"


#import "OrderInfoNatiVeViewController.h"
#import "CommParameter.h"

#define titleColor RGBA(174, 174, 174, 1.0)

#define textFiledColor RGBA(83, 83, 83, 1.0)

#define btnColor RGBA(255, 97, 51, 1.0)

#define viewColor RGBA(255, 255, 255, 1.0)

@interface Html5ViewController ()<WebViewProgressViewDelegate, SandMajletDelete>
{
    NavCoverView *navCoverView;
}

@property (nonatomic, assign) CGSize viewSize;
@property (nonatomic, assign) CGFloat leftRightSpace;
@property (nonatomic, assign) CGFloat textFieldTextSize;
@property (nonatomic, assign) CGFloat btnTextSize;

@property (nonatomic, strong) WebViewProgressView *progressView;
@property (nonatomic, strong) SDMBProgressView *HUD;



@end

@implementation Html5ViewController

@synthesize viewSize;
@synthesize leftRightSpace;
@synthesize textFieldTextSize;
@synthesize btnTextSize;

@synthesize progressView;
@synthesize HUD;



- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.view setBackgroundColor:RGBA(242, 242, 242, 1.0)];
    viewSize = self.view.bounds.size;
    leftRightSpace = 15;
    
    
    

    
    
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
    navCoverView = [NavCoverView shareNavCoverView:CGRectMake(0, 0, viewSize.width, controllerTop) title:@"TN测试"];
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
    CGFloat labelTextSize = 0;

        labelTextSize = 27;
        titleSize = 14;
        textFieldTextSize = 27;
        btnTextSize = 16;

    
    progressView = [[WebViewProgressView alloc] initWithFrame:CGRectMake(0, 64, viewSize.width, viewSize.height - 64)];
    progressView.delegate = self;
    [view addSubview:progressView];
    self.automaticallyAdjustsScrollViewInsets = NO;
    
//    [progressView loadURLString:@"https://www.baidu.com"];
    
    NSString* path = [[NSBundle mainBundle] pathForResource:@"h5test" ofType:@"html"];
    NSURL* url = [NSURL fileURLWithPath:path];
    
    [progressView loadURL:url];
    
//    NSString *resource = [[NSBundle mainBundle] resourcePath];
//    NSString *filePath = [resource stringByAppendingPathComponent:@"h5test.html"];
//    
//    NSString *htmlPath = [[NSString alloc] initWithContentsOfURL:[NSURL URLWithString:filePath] encoding:NSUTF8StringEncoding error:nil ];
//    
//    [progressView loadHTMLString:htmlPath baseURL:[NSURL fileURLWithPath:[[NSBundle mainBundle] bundlePath]]];
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
    
    SandMajletDemo *SandMajlet = [[SandMajletDemo alloc] init];
    SandMajlet.delegate = self;
    mJSContext[@"SandMajlet"] = SandMajlet;
}

//加载失败时调用的方法
- (void)cusWebView:(UIWebView *)webview didFailToLoadURL:(NSURL *)URL error:(NSError *)error
{
    
}


#pragma mark --导航取消按钮
- (void)cancel
{
    [self.navigationController popViewControllerAnimated:YES];
}


#pragma mark  -- SandMajletDelete
- (void)SandMajletIndex:(NSInteger)paramInt paramString:(NSString *)paramString
{
    if (paramInt == 0) {
        [self TNOrder:paramString];
    }
}

 
//跳转下一个界面
- (void)goNext:(NSString *)httpUrl
{
    
}

- (void)TNOrder:(NSString*)TN
{
    dispatch_async(dispatch_get_main_queue(), ^{
        HUD = [SDMBProgressView showSDMBProgressOnlyLoadingINViewImg:self.view];
        [SDRequestHelp shareSDRequest].HUD = HUD;
        [SDRequestHelp shareSDRequest].controller = self;
    });
    
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
                NSArray *payToolsArray = [[PayNucHelper sharedInstance] jsonStringToArray:payTools];
                //排序
                payToolsArray = [Tool orderForPayTools:payToolsArray];
                
                NSString *order = [NSString stringWithUTF8String:paynuc.get("order").c_str()];
                NSDictionary *orderDic = [[PayNucHelper sharedInstance] jsonStringToDictionary:order];
                
                OrderInfoNatiVeViewController *mOrderInfoNatiVeViewController = [[OrderInfoNatiVeViewController alloc] init];
                mOrderInfoNatiVeViewController.TN = TN;
                [self.navigationController pushViewController:mOrderInfoNatiVeViewController animated:YES];
            }];
        }];
        if (error) return ;
    }];
}

- (void)pay
{
    
}


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

@end
