//
//  DetailsWebViewController.m
//  sandbao
//
//  Created by tianNanYiHao on 2017/12/26.
//  Copyright © 2017年 sand. All rights reserved.
//

#import "DetailsWebViewController.h"
#import "PayNucHelper.h"
#import "SDWkWebView.h"

@interface DetailsWebViewController ()<SDWkWebNavgationDelegate,UIScrollViewDelegate>
{
    NSString *tToken;
    SDWkWebView *sdWebView;
    NSString *requestStr;
}
@end

@implementation DetailsWebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self createUI];
    
    [self getToken];
    
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
    self.navCoverView.midTitleStr = @"明细";
    
    
    __weak DetailsWebViewController *weakSelf = self;
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
}


#pragma mark - 业务逻辑
- (void)getToken{
    
    self.HUD = [SDMBProgressView showSDMBProgressOnlyLoadingINViewImg:self.view];
    [SDRequestHelp shareSDRequest].HUD = self.HUD;
    [SDRequestHelp shareSDRequest].controller = self;
    [[SDRequestHelp shareSDRequest] dispatchGlobalQuque:^{
        __block BOOL error = NO;
        
        paynuc.set("tTokenType", "03000101");
        [[SDRequestHelp shareSDRequest] requestWihtFuncName:@"token/getTtoken/v1" errorBlock:^(SDRequestErrorType type) {
            error = YES;
            [[SDRequestHelp shareSDRequest] dispatchToMainQueue:^{
               [sdWebView.webView.scrollView.mj_header endRefreshing];
            }];
        } successBlock:^{
            [[SDRequestHelp shareSDRequest] dispatchToMainQueue:^{
                [self.HUD hidden];
                tToken = [NSString stringWithUTF8String:paynuc.get("tToken").c_str()];
                
                requestStr = [NSString stringWithFormat:@"%@%@sandtoken=%@&accountType=%@&id=%@",AddressHTTP,jnl_trans_flow_mobile,tToken,self.code,self.payToolID];
                
                [self loadURL];
            }];
        }];
        if (error) return ;
    }];
}


/**加载url*/
- (void)loadURL{
    if (requestStr.length>0) {
        [sdWebView load:[NSURL URLWithString:requestStr]];
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
