//
//  SDWkWebView.m
//  SDWkWebView
//
//  Created by tianNanYiHao on 2018/1/31.
//  Copyright © 2018年 tianNanYiHao. All rights reserved.
//

#import "SDWkWebView.h"

@interface SDWkWebView()<WKUIDelegate,WKNavigationDelegate>
{
    
}
@property (nonatomic, strong) UIProgressView *progressView;
@end

@implementation SDWkWebView

- (instancetype) initWithFrame:(CGRect)frame{
    if ([super initWithFrame:frame]) {        
        [self createWkWebView];
    }
    return self;
}

- (void)createWkWebView{
    
    //webView
    self.webView = [[WKWebView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
    self.webView.UIDelegate = self;
    self.webView.navigationDelegate = self;
    [self addSubview:self.webView];
    
    //progressView
    self.progressView = [[UIProgressView alloc] initWithFrame:CGRectMake(0, 0, [[UIScreen mainScreen] bounds].size.width, 2)];
    self.progressView.tintColor = [UIColor greenColor];
    //设置进度条的高度，下面这句代码表示进度条的宽度变为原来的1倍，高度变为原来的1.5倍.
    self.progressView.transform = CGAffineTransformMakeScale(1.0f, 1.5f);
    [self addSubview:self.progressView];
    
}

/**
 加载请求

 @param url url地址
 */
- (void)load:(NSURL*)url{
    //请求
    [self.webView loadRequest:[NSURLRequest requestWithURL:url]];
}


#pragma mark - KVO
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context{
    
    if ([keyPath isEqualToString:@"estimatedProgress"]) {
        
        //progress不断赋值,提供进度显示
        self.progressView.progress = self.webView.estimatedProgress;
        
        if (self.progressView.progress == 1) {
            //进度条进度最大时,完成加载.隐藏进度条
            [self progressHidden];
        }else{
            NSLog(@"%f",self.webView.estimatedProgress);
        }
    }
}


/**进度条显示*/
- (void)progressShow{
    
    //添加请求监听
    [self.webView addObserver:self forKeyPath:@"estimatedProgress" options:NSKeyValueObservingOptionNew context:nil];
    
    //开始加载网页时展示出progressView
    self.progressView.hidden = NO;
    //开始加载网页的时候将progressView的Height恢复为1.5倍
    self.progressView.transform = CGAffineTransformMakeScale(1.0f, 1.5f);
    //防止progressView被网页挡住
    [self bringSubviewToFront:self.progressView];
}

/**进度条隐藏*/
- (void)progressHidden{
    /*
     *添加一个简单的动画，将progressView的Height变为1.4倍，在开始加载网页的代理中会恢复为1.5倍
     *动画时长0.25s，延时0.3s后开始动画
     *动画结束后将progressView隐藏
     */
    __weak typeof (self)weakSelf = self;
    [UIView animateWithDuration:0.25f delay:0.3f options:UIViewAnimationOptionCurveEaseOut animations:^{
        weakSelf.progressView.transform = CGAffineTransformMakeScale(1.0f, 1.4f);
    } completion:^(BOOL finished) {
        //隐藏progress
        weakSelf.progressView.hidden = YES;
        //加载成功 - 删除监听
        [self.webView removeObserver:self forKeyPath:@"estimatedProgress"];
    }];
}






#pragma mark - WKNavigationDelegate
// 页面开始加载时调用
- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(WKNavigation *)navigation{
    if ([_navgationDelegate respondsToSelector:@selector(webView:didStartProvisionalNavigation:)]) {
        [_navgationDelegate webView:webView didStartProvisionalNavigation:navigation];
    }
    //页面开始加载时,显示进度条(进度为0)
    [self progressShow];
}
// 当内容开始返回时调用
- (void)webView:(WKWebView *)webView didCommitNavigation:(WKNavigation *)navigation{
    if ([_navgationDelegate respondsToSelector:@selector(webView:didCommitNavigation:)]) {
        [_navgationDelegate webView:webView didCommitNavigation:navigation];
    }
}
// 页面加载完成之后调用
- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation{
    if ([_navgationDelegate respondsToSelector:@selector(webView:didFinishNavigation:)]) {
        [_navgationDelegate webView:webView didFinishNavigation:navigation];
    }
}
// 页面加载失败时调用
- (void)webView:(WKWebView *)webView didFailProvisionalNavigation:(WKNavigation *)navigation{
    if ([_navgationDelegate respondsToSelector:@selector(webView:didFailProvisionalNavigation:)]) {
        [_navgationDelegate webView:webView didFailProvisionalNavigation:navigation];
    }
    
    //加载失败 - 删除监听
    @try{
        [self.webView removeObserver:self forKeyPath:@"estimatedProgress"];
    }
    @catch(NSException *exception){
    }
    
}
// 接收到服务器跳转请求之后调用
- (void)webView:(WKWebView *)webView didReceiveServerRedirectForProvisionalNavigation:(WKNavigation *)navigation{
    if ([_navgationDelegate respondsToSelector:@selector(webView:didReceiveServerRedirectForProvisionalNavigation:)]) {
        [_navgationDelegate webView:webView didReceiveServerRedirectForProvisionalNavigation:navigation];
    }
}
// 在收到响应后，决定是否跳转
- (void)webView:(WKWebView *)webView decidePolicyForNavigationResponse:(WKNavigationResponse *)navigationResponse decisionHandler:(void (^)(WKNavigationResponsePolicy))decisionHandler{
    
    if ([_navgationDelegate respondsToSelector:@selector(webView:decidePolicyForNavigationResponse:decisionHandler:)]) {
        [_navgationDelegate webView:webView decidePolicyForNavigationResponse:navigationResponse decisionHandler:decisionHandler];
    }
    //允许跳转
    decisionHandler(WKNavigationResponsePolicyAllow);
    //不允许跳转
    //decisionHandler(WKNavigationResponsePolicyCancel);
}
// 在发送请求之前，决定是否跳转
- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler{
    
    if ([_navgationDelegate respondsToSelector:@selector(webView:decidePolicyForNavigationAction:decisionHandler:)]) {
        [_navgationDelegate webView:webView decidePolicyForNavigationAction:navigationAction decisionHandler:decisionHandler];
    }
    //允许跳转
    decisionHandler(WKNavigationActionPolicyAllow);
    //不允许跳转
    //decisionHandler(WKNavigationActionPolicyCancel);
}



#pragma mark - WKUIDelegate
// 创建一个新的WebView
- (WKWebView *)webView:(WKWebView *)webView createWebViewWithConfiguration:(WKWebViewConfiguration *)configuration forNavigationAction:(WKNavigationAction *)navigationAction windowFeatures:(WKWindowFeatures *)windowFeatures{
    
    if ([_uidelegate respondsToSelector:@selector(webView:createWebViewWithConfiguration:forNavigationAction:windowFeatures:)]) {
        return  [_uidelegate webView:webView createWebViewWithConfiguration:configuration forNavigationAction:navigationAction windowFeatures:windowFeatures];
    }
    return [[WKWebView alloc]init];
}
// 输入框
- (void)webView:(WKWebView *)webView runJavaScriptTextInputPanelWithPrompt:(NSString *)prompt defaultText:(nullable NSString *)defaultText initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(NSString * __nullable result))completionHandler{
    
    if ([_uidelegate respondsToSelector:@selector(webView:runJavaScriptTextInputPanelWithPrompt:defaultText:initiatedByFrame:completionHandler:)]) {
        [_uidelegate webView:webView runJavaScriptTextInputPanelWithPrompt:prompt defaultText:defaultText initiatedByFrame:frame completionHandler:completionHandler];
    }
    
    //    completionHandler(@"http");
    
}
// 确认框
- (void)webView:(WKWebView *)webView runJavaScriptConfirmPanelWithMessage:(NSString *)message initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(BOOL result))completionHandler{
    
    if ([_uidelegate respondsToSelector:@selector(webView:runJavaScriptConfirmPanelWithMessage:initiatedByFrame:completionHandler:)]) {
        [_uidelegate webView:webView runJavaScriptConfirmPanelWithMessage:message initiatedByFrame:frame completionHandler:completionHandler];
    }
//    completionHandler(YES);
}
// 警告框
- (void)webView:(WKWebView *)webView runJavaScriptAlertPanelWithMessage:(NSString *)message initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(void))completionHandler{
    NSLog(@"%@",message);
    
    if ([_uidelegate respondsToSelector:@selector(webView:runJavaScriptAlertPanelWithMessage:initiatedByFrame:completionHandler:)]) {
        [_uidelegate webView:webView runJavaScriptAlertPanelWithMessage:message initiatedByFrame:frame completionHandler:completionHandler];
    }
    
//    completionHandler();
}

@end
