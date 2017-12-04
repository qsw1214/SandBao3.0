//
//  WebViewProgressView.m
//  sandFactoring
//
//  Created by tianNanYiHao on 16/6/24.
//  Copyright © 2016年 sand. All rights reserved.
//

#import "WebViewProgressView.h"

#define isiOS8 [[[UIDevice currentDevice] systemVersion] floatValue]>=8.0
static void *KINWebBrowserContext = &KINWebBrowserContext;

@interface WebViewProgressView()

@property (nonatomic, strong) NSTimer *fakeProgressTimer;
@property (nonatomic, assign) BOOL uiWebViewIsLoading;
@property (nonatomic, strong) NSURL *uiWebViewCurrentURL;
@property (nonatomic, strong) NSURL *URLToLaunchWithPermission;

@end

@implementation WebViewProgressView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self configureViews:frame];
    }
    return self;
}

-(void)configureViews:(CGRect)frame
{
    self.uiWebView = [[UIWebView alloc] init];
    [self.uiWebView setFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
    [self.uiWebView setAutoresizingMask:UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight];
    [self.uiWebView setDelegate:self];
    [self.uiWebView setMultipleTouchEnabled:YES];
    [self.uiWebView setAutoresizesSubviews:YES];
    [self.uiWebView setScalesPageToFit:YES];
    [self.uiWebView.scrollView setAlwaysBounceVertical:YES];
    self.uiWebView.scrollView.bounces = NO;
    [self addSubview:self.uiWebView];
    
    self.progressView = [[UIProgressView alloc] initWithProgressViewStyle:UIProgressViewStyleDefault];
    [self.progressView setTrackTintColor:[UIColor colorWithWhite:1.0f alpha:0.0f]];
    [self.progressView setFrame:CGRectMake(0, 0, self.frame.size.width, self.progressView.frame.size.height)];
    [self.progressView setAutoresizingMask:UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin];
    
    
    //设置进度条颜色
    [self setTintColor:[UIColor colorWithRed:0.400 green:0.863 blue:0.133 alpha:1.000]];
    [self addSubview:self.progressView];
}



- (void)loadRequest:(NSURLRequest *)request {
    if(self.uiWebView) {
        [self.uiWebView loadRequest:request];
    }
}

- (void)loadURL:(NSURL *)URL {
    [self loadRequest:[NSURLRequest requestWithURL:URL]];
}

- (void)loadURLString:(NSString *)URLString {
    NSString *str = [[NSString stringWithFormat:@"%@",URLString] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSURL *URL = [NSURL URLWithString:str];
    [self loadURL:URL];
}

- (void)loadHTMLString:(NSString *)HTMLString {
    if(self.uiWebView) {
        [self.uiWebView loadHTMLString:HTMLString baseURL:nil];
    }
}

- (void)loadHTMLString:(NSString *)HTMLString baseURL:(NSURL *)baseURL {
    if(self.uiWebView) {
        [self.uiWebView loadHTMLString:HTMLString baseURL:baseURL];
    }
}

#pragma mark - UIWebViewDelegate



- (void)webViewDidStartLoad:(UIWebView *)webView
{
    if(webView == self.uiWebView) {
        [self.delegate cusWebViewDidStartLoad:webView];
        
    }
}

//监视请求
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
    
    if(webView == self.uiWebView) {
        
        if(![self externalAppRequiredToOpenURL:request.URL]) {
            self.uiWebViewCurrentURL = request.URL;
            self.uiWebViewIsLoading = YES;
            
            [self fakeProgressViewStartLoading];
            
            
            //back delegate
            [self.delegate cusWebView:webView shouldStartLoadWithURL:request.URL];
            return YES;
        }
        else {
            return NO;
        }
    }
    return NO;
}


- (void)webViewDidFinishLoad:(UIWebView *)webView {
    
    
    NSLog(@"alert : currwebview is UIWebView");
    if(webView == self.uiWebView) {
        if(!self.uiWebView.isLoading) {
            self.uiWebViewIsLoading = NO;
            
            [self fakeProgressBarStopLoading];
        }
        
        //back delegate
        [self.delegate cusWebView:webView didFinishLoadingURL:self.uiWebView.request.URL];
        
    }
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
    
    if(webView == self.uiWebView) {
        if(!self.uiWebView.isLoading) {
            self.uiWebViewIsLoading = NO;
            
            [self fakeProgressBarStopLoading];
        }
        
        //back delegate
        [self.delegate cusWebView:webView didFailToLoadURL:self.uiWebView.request.URL error:error];
    }
}

#pragma mark - Fake Progress Bar Control (UIWebView)

- (void)fakeProgressViewStartLoading {
    [self.progressView setProgress:0.0f animated:NO];
    [self.progressView setAlpha:1.0f];
    
    if(!self.fakeProgressTimer) {
        self.fakeProgressTimer = [NSTimer scheduledTimerWithTimeInterval:1.0f/60.0f target:self selector:@selector(fakeProgressTimerDidFire:) userInfo:nil repeats:YES];
    }
}

- (void)fakeProgressBarStopLoading {
    if(self.fakeProgressTimer) {
        [self.fakeProgressTimer invalidate];
    }
    
    if(self.progressView) {
        [self.progressView setProgress:1.0f animated:YES];
        [UIView animateWithDuration:0.3f delay:0.3f options:UIViewAnimationOptionCurveEaseOut animations:^{
            [self.progressView setAlpha:0.0f];
        } completion:^(BOOL finished) {
            [self.progressView setProgress:0.0f animated:NO];
        }];
    }
}

- (void)fakeProgressTimerDidFire:(id)sender {
    CGFloat increment = 0.005/(self.progressView.progress + 0.2);
    if([self.uiWebView isLoading]) {
        CGFloat progress = (self.progressView.progress < 0.75f) ? self.progressView.progress + increment : self.progressView.progress + 0.0005;
        if(self.progressView.progress < 0.95) {
            [self.progressView setProgress:progress animated:YES];
        }
    }
}

#pragma mark - External App Support

- (BOOL)externalAppRequiredToOpenURL:(NSURL *)URL {
    NSSet *validSchemes = [NSSet setWithArray:@[@"http", @"https",@"file"]];
    return ![validSchemes containsObject:URL.scheme];
}

#pragma mark - Dealloc

- (void)dealloc {
    [self.uiWebView setDelegate:nil];
}

@end
