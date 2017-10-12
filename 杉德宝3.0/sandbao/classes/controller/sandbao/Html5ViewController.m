//
//  Html5ViewController.m
//  sandbao
//
//  Created by blue sky on 2017/4/7.
//  Copyright © 2017年 sand. All rights reserved.
//

#import "Html5ViewController.h"
#import "WebViewProgressView.h"
#import "SandMajletDemo.h"

#define titleColor [UIColor colorWithRed:(174/255.0) green:(174/255.0) blue:(174/255.0) alpha:1.0]

#define textFiledColor [UIColor colorWithRed:(83/255.0) green:(83/255.0) blue:(83/255.0) alpha:1.0]

#define btnColor [UIColor colorWithRed:(255/255.0) green:(97/255.0) blue:(51/255.0) alpha:1.0]

#define viewColor [UIColor colorWithRed:(255/255.0) green:(255/255.0) blue:(255/255.0) alpha:1.0]

@interface Html5ViewController ()<WebViewProgressViewDelegate>
{
    NavCoverView *navCoverView;
}

@property (nonatomic, assign) CGSize viewSize;
@property (nonatomic, assign) CGFloat leftRightSpace;
@property (nonatomic, assign) CGFloat textFieldTextSize;
@property (nonatomic, assign) CGFloat btnTextSize;

@property (nonatomic, strong) WebViewProgressView *progressView;

@end

@implementation Html5ViewController

@synthesize viewSize;
@synthesize leftRightSpace;
@synthesize textFieldTextSize;
@synthesize btnTextSize;

@synthesize progressView;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [super viewDidLoad];
    [self.view setBackgroundColor:[UIColor colorWithRed:(242/255.0) green:(242/255.0) blue:(242/255.0) alpha:1.0]];
    viewSize = self.view.bounds.size;
    leftRightSpace = 10;
    
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
    navCoverView = [NavCoverView shareNavCoverView:CGRectMake(0, 0, viewSize.width, controllerTop) title:@"H5测试"];
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
    if (iPhone4 || iPhone5) {
        labelTextSize = 27;
        titleSize = 14;
        textFieldTextSize = 27;
        btnTextSize = 16;
    } else if (iPhone6) {
        labelTextSize = 29;
        titleSize = 16;
        textFieldTextSize = 29;
        btnTextSize = 18;
    } else {
        labelTextSize = 32;
        titleSize = 19;
        textFieldTextSize = 32;
        btnTextSize = 20;
    }
    
    progressView = [[WebViewProgressView alloc] initWithFrame:CGRectMake(0, 64, viewSize.width, viewSize.height - 64)];
    progressView.delegate = self;
    [view addSubview:progressView];
    self.automaticallyAdjustsScrollViewInsets = NO;
    
//    [progressView loadURLString:@"https://www.baidu.com"];
    
//    NSString* path = [[NSBundle mainBundle] pathForResource:@"h5test" ofType:@"html"];
//    NSURL* url = [NSURL fileURLWithPath:path];
//    
//    [progressView loadURL:url];
    
    NSString *resource = [[NSBundle mainBundle] resourcePath];
    NSString *filePath = [resource stringByAppendingPathComponent:@"h5test.html"];
    
    NSString *htmlPath = [[NSString alloc] initWithContentsOfURL:[NSURL URLWithString:filePath] encoding:NSUTF8StringEncoding error:nil ];
    
    [progressView loadHTMLString:htmlPath baseURL:[NSURL fileURLWithPath:[[NSBundle mainBundle] bundlePath]]];
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


//网页加载之前会调用此方法
- (void)cusWebViewDidStartLoad:(UIWebView *)webview
{
    NSLog(@"页面开始加载");
}

//网页加载之前会调用此方法
- (void)cusWebView:(UIWebView *)webview shouldStartLoadWithURL:(NSURL *)URL
{
    NSLog(@"截取到URL：%@",URL);
}

//网页加载完成调用此方法
- (void)cusWebView:(UIWebView *)webview didFinishLoadingURL:(NSURL *)URL
{
    NSLog(@"页面加载完成");
    
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
    
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        JSContext *mJSContext = [webview valueForKeyPath:@"documentView.webView.mainFrame.javaScriptContext"];
        
        mJSContext[@"pay"] = ^(){
            NSArray *mArray = [JSContext currentArguments];
            if (mArray.count > 0) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    NSString *args = [NSString stringWithFormat:@"%@", mArray[0]];
                    NSLog(@"aaaaaaaaa%@", args);
//                    [self goNext:args];
                });
            } else {
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                });
            }
            
        };
    });
    
}

//网页加载失败 调用此方法
- (void)cusWebView:(UIWebView *)webview didFailToLoadURL:(NSURL *)URL error:(NSError *)error
{
    NSLog(@"加载出现错误");
}

//
//-(BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
//{
//
//    return YES;
//}
//
//
//- (void)webViewDidStartLoad:(UIWebView *)webView
//{
//
//}
//

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    JSContext *mJSContext = [webView valueForKeyPath:@"documentView.webView.mainFrame.javaScriptContext"];
    
    SandMajletDemo *SandMajlet = [[SandMajletDemo alloc] init];
    
    mJSContext[@"SandMajlet"] = SandMajlet;
    
    [webView stringByEvaluatingJavaScriptFromString:[NSString stringWithFormat:@"SandMajlet_Callback('%@', '%@');", @"1", @"支付成功"]];
    
}
//
//
//- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
//{
//    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
//}


#pragma mark --导航取消按钮
- (void)cancel
{
    [self.navigationController popViewControllerAnimated:YES];
}

//跳转下一个界面
- (void)goNext:(NSString *)httpUrl
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
