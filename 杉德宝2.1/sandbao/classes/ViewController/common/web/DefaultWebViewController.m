//
//  DefaultWebViewController.m
//  sandbao
//
//  Created by tianNanYiHao on 2018/2/2.
//  Copyright © 2018年 sand. All rights reserved.
//

#import "DefaultWebViewController.h"
#import "SDWkWebView.h"
@interface DefaultWebViewController ()<SDWkWebNavgationDelegate,UIScrollViewDelegate>
{
    SDWkWebView *sdWebView;
}
@end

@implementation DefaultWebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
      [self createUI];
}

#pragma mark - 重写父类-baseScrollView设置
- (void)setBaseScrollview{
    [super setBaseScrollview];
    
    self.baseScrollView.scrollEnabled = NO;
    self.baseScrollView.delegate = self;
}
#pragma mark - 重写父类-导航设置方法
- (void)setNavCoverView{
    [super setNavCoverView];
    self.navCoverView.style = NavCoverStyleWhite;
    self.navCoverView.letfImgStr = @"login_icon_back";
    self.navCoverView.midTitleStr = @"";
    
    
    __weak DefaultWebViewController *weakSelf = self;
    self.navCoverView.leftBlock = ^{
        [weakSelf.navigationController popViewControllerAnimated:YES];
    };
}
#pragma mark - 重写父类-点击方法集合
- (void)buttonClick:(UIButton *)btn{
    
}

#pragma mark  - UI绘制
- (void)createUI{
    
    sdWebView = [[SDWkWebView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, self.baseScrollView.height)];
    sdWebView.navgationDelegate = self;
    [self.baseScrollView addSubview:sdWebView];
    
    __weak typeof(self) weakself = self;
    sdWebView.webView.scrollView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [weakself loadURL];
    }];
    [sdWebView.webView.scrollView.mj_header beginRefreshing];
}


#pragma mark - 业务逻辑

/**加载url*/
- (void)loadURL{
    if (self.requestStr.length>0) {
        [sdWebView load:[NSURL URLWithString:self.requestStr]];
    }else{
        [sdWebView.webView.scrollView.mj_header endRefreshing];
    }
}


#pragma mark - SDWkwebViewNavigationDelegate
// 页面开始加载时调用
- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(WKNavigation *)navigation{
    
}
// 当内容开始返回时调用
- (void)webView:(WKWebView *)webView didCommitNavigation:(WKNavigation *)navigation{
    
}
// 页面加载完成之后调用
- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation{
    [sdWebView.webView.scrollView.mj_header endRefreshing];
}
// 页面加载失败时调用
- (void)webView:(WKWebView *)webView didFailProvisionalNavigation:(WKNavigation *)navigation{
    [sdWebView.webView.scrollView.mj_header endRefreshing];
}



//scrollorView代理 - 屏蔽父类方法即可, 不需具体实现
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
