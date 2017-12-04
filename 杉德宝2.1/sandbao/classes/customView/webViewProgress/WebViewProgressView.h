//
//  WebViewProgressView.h
//  sandFactoring
//
//  Created by tianNanYiHao on 16/6/24.
//  Copyright © 2016年 sand. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol WebViewProgressViewDelegate <NSObject>

@optional
- (void)cusWebView:(UIWebView *)webview didFinishLoadingURL:(NSURL *)URL;
- (void)cusWebView:(UIWebView *)webview didFailToLoadURL:(NSURL *)URL error:(NSError *)error;
- (void)cusWebView:(UIWebView *)webview shouldStartLoadWithURL:(NSURL *)URL;
- (void)cusWebViewDidStartLoad:(UIWebView *)webview;
@end



@interface WebViewProgressView : UIView<UIWebViewDelegate>

- (instancetype)initWithFrame:(CGRect)frame;

@property (nonatomic, weak) id <WebViewProgressViewDelegate> delegate;

@property (nonatomic, strong) UIProgressView *progressView;

@property (nonatomic, strong) UIWebView *uiWebView;



- (void)loadRequest:(NSURLRequest *)request;

- (void)loadURL:(NSURL *)URL;

- (void)loadURLString:(NSString *)URLString;

- (void)loadHTMLString:(NSString *)HTMLString;

- (void)loadHTMLString:(NSString *)HTMLString baseURL:(NSURL *)baseURL;

@end
