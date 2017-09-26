//
//  BillViewController.m
//  sandbao
//
//  Created by blue sky on 2017/4/12.
//  Copyright © 2017年 sand. All rights reserved.
//

#import "BillViewController.h"
#import "WebViewProgressView.h"
#import "CustomAlertView.h"
#import "CommParameter.h"

@interface BillViewController ()<WebViewProgressViewDelegate>
{
    NavCoverView *navCoverView;
}

@property (nonatomic, assign) CGSize viewSize;

@property (nonatomic, strong) WebViewProgressView *progressView;
@property (nonatomic, strong) CustomAlertView *alertView;

@end

@implementation BillViewController

@synthesize viewSize;

@synthesize progressView;
@synthesize alertView;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.view setBackgroundColor:[UIColor colorWithRed:(242/255.0) green:(242/255.0) blue:(242/255.0) alpha:1.0]];
    viewSize = self.view.bounds.size;
    
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
    navCoverView = [NavCoverView shareNavCoverView:CGRectMake(0, 0, viewSize.width, controllerTop) title:@"账单"];
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
    progressView = [[WebViewProgressView alloc] initWithFrame:CGRectMake(0, controllerTop, viewSize.width, viewSize.height - controllerTop)];
    progressView.delegate = self;
    [view addSubview:progressView];
    self.automaticallyAdjustsScrollViewInsets = NO;
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
    
    NSString *requestStr = [NSString stringWithFormat:@"%@%@sandtoken=%@",AddressHTTP,jnl_order_list_mobile,[CommParameter sharedInstance].sToken];
    [progressView loadURLString:requestStr]; //账户变动  03000101
    
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
}

//加载失败时调用的方法
- (void)cusWebView:(UIWebView *)webview didFailToLoadURL:(NSURL *)URL error:(NSError *)error
{
    
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

#pragma mark - 弹出对话框
/**
 *@brief  弹出对话框
 *@param message NSString 参数：消息
 *@param index int 参数：消息索引
 *@return
 */
- (void)showDialog:(NSString *)message index:(int)index
{
    alertView = [[CustomAlertView alloc] initWithTitle:@"提示" message:message buttonTitles:@"确定",@"取消", nil];
    alertView.alertViewStyle = CustomAlertViewStyleDefault;
    switch (index) {
        case 1:
        {
            [alertView showWithCompletion:^(NSInteger selectIndex) {
                
            }];
        }
            break;
        case 2:
        {
            [alertView showWithCompletion:^(NSInteger selectIndex) {
                if (selectIndex == 1) {
                    
                } else {
                    
                }
            }];
        }
            break;
            
        default:
            break;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
