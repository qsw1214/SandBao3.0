//
//  FAQwebViewController.m
//  sandbao
//
//  Created by tianNanYiHao on 2017/5/16.
//  Copyright © 2017年 sand. All rights reserved.
//

#import "FAQwebViewController.h"
#import "WebViewProgressView.h"

@interface FAQwebViewController ()<WebViewProgressViewDelegate>
{
    NavCoverView *navCoverView;
}
@property (nonatomic, assign) CGSize viewSize;
@property (nonatomic, strong) WebViewProgressView *progressView;
@property (nonatomic, strong) SDMBProgressView *HUD;

@end

@implementation FAQwebViewController
@synthesize progressView;
@synthesize viewSize;
@synthesize HUD;





- (void)viewDidLoad {
    [super viewDidLoad];
   
    [self.view setBackgroundColor:RGBA(242, 242, 242, 1.0)];
    viewSize = self.view.bounds.size;
    
    
    

    [self settingNavigationBar];
    
    [self load];
    

}
#pragma mark - 设置导航栏
/**
 *@brief 设置导航栏
 *@return
 */
- (void)settingNavigationBar
{
    //导航渐变条
    navCoverView = [NavCoverView shareNavCoverView:CGRectMake(0, 0, viewSize.width, controllerTop) title:_titleName];
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


- (void)load{
    progressView = [[WebViewProgressView alloc] initWithFrame:CGRectMake(0, controllerTop, viewSize.width, viewSize.height - controllerTop)];
    progressView.delegate = self;
    [self.view addSubview:progressView];
    self.automaticallyAdjustsScrollViewInsets = NO;
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
    [progressView loadURLString:_urlstr];

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
        case 102:
        {

            
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
