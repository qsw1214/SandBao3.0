//
//  BillViewController.m
//  sandbao
//
//  Created by tianNanYiHao on 2017/4/12.
//  Copyright © 2017年 sand. All rights reserved.
//

#import "BillViewController.h"
#import "WebViewProgressView.h"
#import "CommParameter.h"
#import "PayNucHelper.h"



#import "CommParameter.h"
#import <JavaScriptCore/JavaScriptCore.h>
#import "SandMajlet.h"



@interface BillViewController ()<WebViewProgressViewDelegate, SandMajletDelete,SDPopviewDelegate>
{
    NavCoverView *navCoverView;
    NSString *tToken;
    
    UIButton *rightBarBtn;
    NSString *captionUrlStr;
    NSArray *barMenuArray;
    NSMutableArray *nameArr;
}

@property (nonatomic, assign) CGSize viewSize;
@property (nonatomic, strong) WebViewProgressView *progressView;

@property (nonatomic, strong) SDMBProgressView *HUD;




@end

@implementation BillViewController

@synthesize viewSize;
@synthesize HUD;

@synthesize progressView;


- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.view setBackgroundColor:RGBA(242, 242, 242, 1.0)];
    viewSize = self.view.bounds.size;
    
    
    


    [self settingNavigationBar];

    nameArr = [NSMutableArray arrayWithCapacity:0];
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
    
    // 3.设置右边的返回item
    UIImage *rightImage = [UIImage imageNamed:@"icon_details"];
    rightBarBtn = [[UIButton alloc] init];
    [rightBarBtn setImage:[UIImage imageNamed:@"icon_details"] forState:UIControlStateNormal];
    [rightBarBtn setImage:[UIImage imageNamed:@"icon_details"] forState:UIControlStateHighlighted];
    rightBarBtn.frame = CGRectMake(viewSize.width - 10 - rightImage.size.width, 20 + (40 - rightImage.size.height) / 2, rightImage.size.width, rightImage.size.height);
    rightBarBtn.tag = 102;
    [rightBarBtn addTarget:self action:@selector(buttonActionToDoSomething:) forControlEvents:UIControlEventTouchUpInside];
    rightBarBtn.contentMode = UIViewContentModeScaleAspectFit;
    rightBarBtn.hidden = YES;
    [navCoverView addSubview:rightBarBtn];
}


- (void)load
{
    if (!_setBarMenu){
        
        HUD = [SDMBProgressView showSDMBProgressOnlyLoadingINViewImg:self.view];
        [SDRequestHelp shareSDRequest].HUD = HUD;
        [SDRequestHelp shareSDRequest].controller = self;
        [[SDRequestHelp shareSDRequest] dispatchGlobalQuque:^{
            __block BOOL error = NO;
            paynuc.set("tTokenType", "03000201");
            [[SDRequestHelp shareSDRequest] requestWihtFuncName:@"token/getTtoken/v1" errorBlock:^(SDRequestErrorType type) {
                error = YES;
            } successBlock:^{
                [[SDRequestHelp shareSDRequest] dispatchToMainQueue:^{
                    [HUD hidden];
                    tToken = [NSString stringWithUTF8String:paynuc.get("tToken").c_str()];
                    [self addView:self.view];
 
                }];
            }];
            if (error) return ;
        }];
    }else{
         [self addView:self.view];
    }
    
}


#pragma mark - 创建组件
/**
 *@brief 创建组件
 *@param view UIView 参数：组件
 *@return
 */
-(void)addView:(UIView *)view
{
    if (!_setBarMenu) {
        progressView = [[WebViewProgressView alloc] initWithFrame:CGRectMake(0, controllerTop, viewSize.width, viewSize.height - controllerTop)];
        progressView.delegate = self;
        [view addSubview:progressView];
        self.automaticallyAdjustsScrollViewInsets = NO;
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
        
        NSString *requestStr = [NSString stringWithFormat:@"%@%@sandtoken=%@",AddressHTTP,jnl_order_list_mobile,tToken];
        [progressView loadURLString:requestStr]; //账户变动  03000201
    }else{
        progressView = [[WebViewProgressView alloc] initWithFrame:CGRectMake(0, controllerTop, viewSize.width, viewSize.height - controllerTop)];
        progressView.delegate = self;
        [view addSubview:progressView];
        self.automaticallyAdjustsScrollViewInsets = NO;
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
        NSString *requestStr = _captionUrl;
        [progressView loadURLString:requestStr]; //barMenu页
    }
    
    
}



#pragma mark --webViewDelegate

//准备加载内容时调用的方法，通过返回值来进行是否加载的设置
- (void)cusWebView:(UIWebView *)webview shouldStartLoadWithURL:(NSURL *)URL
{
    JSContext *context = [webview valueForKeyPath:@"documentView.webView.mainFrame.javaScriptContext"];
    SandMajlet *mSandMajlet = [[SandMajlet alloc] init];
    mSandMajlet.delegate = self;
    context[@"SandMajlet"] = mSandMajlet;
    
    NSLog(@"加载前截取URL:%@",URL);
}

//开始加载时调用的方法
- (void)cusWebViewDidStartLoad:(UIWebView *)webview
{

}

//结束加载时调用的方法
-(void)cusWebView:(UIWebView *)webview didFinishLoadingURL:(NSURL *)URL
{

}
//加载失败时调用的方法
- (void)cusWebView:(UIWebView *)webview didFailToLoadURL:(NSURL *)URL error:(NSError *)error
{
    NSLog(@"加载失败了 %@",error);
}
#pragma mark - sandMajletDelegate
- (void)SandMajletIndex:(NSInteger)paramInt paramString:(NSString *)paramString{
    
    if (paramInt == 3) {
        if (paramString.length>0) {
            rightBarBtn.hidden = NO;
            barMenuArray = [[PayNucHelper sharedInstance] jsonStringToArray:paramString];
        }else{
            rightBarBtn.hidden = YES;
        }
        
        
    }
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
    
            if (nameArr.count>0) {
                [nameArr removeAllObjects];
            }
            for (int i = 0; i<barMenuArray.count; i++) {
                NSString *str = [barMenuArray[i] objectForKey:@"caption"];
                NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithCapacity:0];
                [dic setValue:str forKey:@"name"];
                [dic setValue:@"" forKey:@"icon"];
                [nameArr addObject:dic];
            }
            SDPopViewConfig *config  = [[SDPopViewConfig alloc] init];
            config.triAngelWidth = 8;
            config.triAngelHeight = 6;
            config.containerViewCornerRadius = 5;
            config.roundMargin = 4;
            config.layerBackGroundColor = RGBA(64, 131, 215, 1.0);
            config.defaultRowHeight = 40;
            config.tableBackgroundColor = RGBA(247, 247, 247, 1.0);;
            config.separatorColor = [UIColor blackColor];
            config.textColor = [UIColor blackColor];
            config.textAlignment = NSTextAlignmentLeft;
            config.font = [UIFont systemFontOfSize:14];
            config.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
            
            SDPopview *v = [[SDPopview alloc] initWithBounds:CGRectMake(0, 0, 60, config.defaultRowHeight*barMenuArray.count) titleInfo:nameArr config:config];
            v.delegate = self;
            [v showFrom:btn alignStyle:SDPopViewStyleRight];


        }
            break;
        default:
            break;
    }
}


#pragma mark- SDPopViewDelegate


- (void)popOverView:(SDPopview *)pView didClickMenuIndex:(NSInteger)index{

    HUD = [SDMBProgressView showSDMBProgressOnlyLoadingINViewImg:self.view];
    [SDRequestHelp shareSDRequest].HUD = HUD;
    [SDRequestHelp shareSDRequest].controller = self;    
    [[SDRequestHelp shareSDRequest] dispatchGlobalQuque:^{
        __block BOOL error = NO;
        paynuc.set("tTokenType", "03000201");
        [[SDRequestHelp shareSDRequest] requestWihtFuncName:@"token/getTtoken/v1" errorBlock:^(SDRequestErrorType type) {
            error = YES;
        } successBlock:^{
            [[SDRequestHelp shareSDRequest] dispatchToMainQueue:^{
                [HUD hidden];
                
                tToken = [NSString stringWithUTF8String:paynuc.get("tToken").c_str()];
                
                BillViewController *newBillVc = [[BillViewController alloc] init];
                newBillVc.setBarMenu = YES;
                newBillVc.titleName = [barMenuArray[index] objectForKey:@"caption"];
                
                NSString *barURL = [barMenuArray[index] objectForKey:@"url"];
                NSString *urlNew;
                if ([barURL rangeOfString:@"?"].location !=NSNotFound) {
                    NSArray *arr = [barURL componentsSeparatedByString:@"?"];
                    urlNew = [NSString stringWithFormat:@"%@?sandtoken=%@&%@",[arr firstObject],tToken,[arr lastObject]];
                }
                newBillVc.captionUrl = urlNew;
                [self.navigationController pushViewController:newBillVc animated:YES];
                
            }];
        }];
        if (error) return ;
    }];

}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
