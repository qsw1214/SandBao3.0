//
//  MyBillViewController.m
//  sandbao
//
//  Created by tianNanYiHao on 2017/10/27.
//  Copyright © 2017年 sand. All rights reserved.
//

#import "MyBillViewController.h"
#import "PayNucHelper.h"
#import <WebKit/WebKit.h>


@interface MyBillViewController ()
{
    NSString *tToken;
    WKWebView *webView;
    
}
@end

@implementation MyBillViewController

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    //允许RESideMenu的返回手势
    self.sideMenuViewController.panGestureEnabled = YES;
}

- (void)viewDidLoad {
    [super viewDidLoad];
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
    self.navCoverView.style = NavCoverStyleGradient;
    self.navCoverView.letfImgStr = @"login_icon_back_white";
    self.navCoverView.midTitleStr = @"我的账单";

    __weak MyBillViewController *weakSelf = self;
    self.navCoverView.leftBlock = ^{
        //归位Home或SpsLunch
        [Tool setContentViewControllerWithHomeOrSpsLunchFromSideMenuViewController:weakSelf.sideMenuViewController];
    };
    
 
}

#pragma mark - 重写父类-点击方法集合
- (void)buttonClick:(UIButton *)btn{
    
    
}

#pragma mark - UI绘制
- (void)createUI{
    
    webView = [[WKWebView alloc] init];
    webView.frame = CGRectMake(0, 0, SCREEN_WIDTH, self.baseScrollView.height);
    [self.baseScrollView addSubview:webView];
    
    __weak typeof(self) weakself = self;
    webView.scrollView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [weakself getToken];
    }];
}

#pragma mark - 业务逻辑
- (void)getToken{
    
    self.HUD = [SDMBProgressView showSDMBProgressOnlyLoadingINViewImg:self.view];
    [SDRequestHelp shareSDRequest].HUD = self.HUD;
    [SDRequestHelp shareSDRequest].controller = self;
    [[SDRequestHelp shareSDRequest] dispatchGlobalQuque:^{
        __block BOOL error = NO;
        
        
        paynuc.set("tTokenType", "03000201");
        [[SDRequestHelp shareSDRequest] requestWihtFuncName:@"token/getTtoken/v1" errorBlock:^(SDRequestErrorType type) {
            error = YES;
        } successBlock:^{
            [[SDRequestHelp shareSDRequest] dispatchToMainQueue:^{
                [self.HUD hidden];
                tToken = [NSString stringWithUTF8String:paynuc.get("tToken").c_str()];
                [self createUI];
                NSString *requestStr = [NSString stringWithFormat:@"%@%@sandtoken=%@",AddressHTTP,jnl_order_list_mobile,tToken];
                [webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:requestStr]]];
            }];
        }];
        if (error) return ;
    }];

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
