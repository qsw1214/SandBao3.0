//
//  SandPointsViewController.m
//  sandbao
//
//  Created by tianNanYiHao on 2017/10/27.
//  Copyright © 2017年 sand. All rights reserved.
//

#import "SandPointsViewController.h"
#import "PayNucHelper.h"

#import "WebViewController.h"
#import "GradualView.h"
#import "SDWaveViwe.h"

@interface SandPointsViewController ()
{
    UIView *headView;
    GradualView *sandPointBGView;
    SDWaveViwe *waveView;
    UILabel *sandPointCountLab;
    
    //杉德积分账户 - 支付工具字典
    NSDictionary *sandPointDic;
}
@property (nonatomic, strong) NSString *sandPointPayToolID; //积分账户ID
@end

@implementation SandPointsViewController

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    //允许RESideMenu的返回手势
    self.sideMenuViewController.panGestureEnabled = YES;
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
    //设置数据
    [self settingData];

    //查询积分账户余额
    [self getBalances];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    
    //删除水波动画
    [self removeWaveView];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self creaetUI];
    
    
}



#pragma mark - 重写父类-baseScrollView设置
- (void)setBaseScrollview{
    [super setBaseScrollview];
    
    self.baseScrollView.backgroundColor = COLOR_F5F5F5;
}
#pragma mark - 重写父类-导航设置方法
- (void)setNavCoverView{
    [super setNavCoverView];
    self.navCoverView.style = NavCoverStyleGradient_RED;
    self.navCoverView.letfImgStr = @"login_icon_back_white";
    self.navCoverView.midTitleStr = @"";
    self.navCoverView.rightTitleStr = @"明细";
 
    __weak SandPointsViewController *weakSelf = self;
    self.navCoverView.leftBlock = ^{
        //归位Home或SpsLunch
        [Tool setContentViewControllerWithHomeOrSpsLunchFromSideMenuViewController:weakSelf.sideMenuViewController];
    };
    
    self.navCoverView.rightBlock = ^{
        
        WebViewController *webViewVC = [[WebViewController alloc] init];
        webViewVC.payToolID = weakSelf.sandPointPayToolID;
        webViewVC.code = SAND_Point;
        [weakSelf.navigationController pushViewController:webViewVC animated:YES];
    };
    
}
#pragma mark - 重写父类-点击方法集合
- (void)buttonClick:(UIButton *)btn{
    
    
}

#pragma mark  - UI绘制
- (void)creaetUI{
    
    CGFloat sandPointBGViewH = UPDOWNSPACE_133;
    
    sandPointBGView = [[GradualView alloc] init];
    sandPointBGView.colorStyle = GradualColorRed;
    sandPointBGView.rect = CGRectMake(0, 0, SCREEN_WIDTH, sandPointBGViewH);
    [self.baseScrollView addSubview:sandPointBGView];
    
    [sandPointBGView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.baseScrollView);
        make.centerX.equalTo(self.baseScrollView);
        make.size.mas_equalTo(sandPointBGView.rect.size);
    }];
    
    
    //积分余额
    UILabel *sandPointCountDecLab = [Tool createLable:@"积分余额" attributeStr:nil font:FONT_16_Regular textColor:COLOR_FFFFFF alignment:NSTextAlignmentCenter];
    [sandPointBGView addSubview:sandPointCountDecLab];
    
    sandPointCountLab = [Tool createLable:@"2345" attributeStr:nil font:FONT_48_Regular textColor:COLOR_FFFFFF alignment:NSTextAlignmentCenter];
    [sandPointBGView addSubview:sandPointCountLab];
    
    [sandPointCountDecLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(sandPointBGView.mas_top).offset(UPDOWNSPACE_05);
        make.centerX.equalTo(sandPointBGView);
        make.size.mas_equalTo(sandPointCountDecLab.size);
    }];
    
    [sandPointCountLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(sandPointBGView.mas_bottom).offset(-UPDOWNSPACE_30);
        make.centerX.equalTo(sandPointBGView);
        make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH, sandPointCountLab.height));
    }];
    
    
}
/**添加水波动画*/
- (void)addWaveView{
    
    waveView = [[SDWaveViwe alloc] initWithFrame:CGRectMake(0, 0, sandPointBGView.rect.size.width, sandPointBGView.rect.size.height)];
    //水波上涨 - 最终刻度
    waveView.waveUpRang = 3/5.f;
    //水波上涨 - 上涨速度
    waveView.waveUpSpeed = 1.f;
    //水波波动 - 波动振幅
    waveView.waveChangA = 8;
    //水波波动- 波动速度
    waveView.wavaChangeSpeed = 2.f;
    
    [sandPointBGView addSubview:waveView];
}

/**删除水波动画*/
- (void)removeWaveView{
    
    [waveView removeFromSuperview];
    waveView = nil;
}

- (void)settingData
{
    NSDictionary *ownPayToolDic = [Tool getPayToolsInfo:[CommParameter sharedInstance].ownPayToolsArray];
    
    //钱包账户_被充值_支付工具 - 初始化
    sandPointDic = [NSMutableDictionary dictionaryWithCapacity:0];
    sandPointDic = [ownPayToolDic objectForKey:@"sandPointDic"];
    
    //钱包账户未成功开通
    if (sandPointDic.count == 0) {
        [Tool showDialog:@"请联系杉德客服" message:@"积分账户开通失败" leftBtnString:@"返回首页" rightBtnString:@"联系客服" leftBlock:^{
            //归位Home或SpsLunch
            [Tool setContentViewControllerWithHomeOrSpsLunchFromSideMenuViewController:self.sideMenuViewController];
        } rightBlock:^{
            //呼叫
            if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"tel:021-962567"]]) {
                [Tool openUrl:[NSURL URLWithString:@"tel:021-962567"]];
            }
        }];
        
    }else{
        self.sandPointPayToolID = [sandPointDic objectForKey:@"id"];
    }
}



#pragma mark - 业务逻辑

#pragma mark - 积分账户余额
-(void)getBalances{
    self.HUD = [SDMBProgressView showSDMBProgressOnlyLoadingINViewImg:self.view];
    [SDRequestHelp shareSDRequest].HUD = self.HUD;
    [SDRequestHelp shareSDRequest].controller = self;
    [[SDRequestHelp shareSDRequest] dispatchGlobalQuque:^{
        __block BOOL error = NO;
        paynuc.set("tTokenType", "03000401");
        [[SDRequestHelp shareSDRequest] requestWihtFuncName:@"token/getTtoken/v1" errorBlock:^(SDRequestErrorType type) {
            error = YES;
        } successBlock:^{
            
        }];
        if (error) return ;
        
        NSString *payTools = [[PayNucHelper sharedInstance] arrayToJSON:@[sandPointDic]];
        paynuc.set("payTools", [payTools UTF8String]);
        [[SDRequestHelp shareSDRequest] requestWihtFuncName:@"payTool/getBalances/v1" errorBlock:^(SDRequestErrorType type) {
            error = YES;
        } successBlock:^{
            [[SDRequestHelp shareSDRequest] dispatchToMainQueue:^{
                [self.HUD hidden];
                
                //更新数据 积分账户余额
                NSString *payTools = [NSString stringWithUTF8String:paynuc.get("payTools").c_str()];
                NSArray *payToolsArr = [[PayNucHelper sharedInstance] jsonStringToArray:payTools];
                
                //排序
                payToolsArr = [Tool orderForPayTools:payToolsArr];
                if (payToolsArr.count>0) {
                    NSDictionary *payToolDic = payToolsArr[0];
                    if ([[payToolDic objectForKey:@"type"] isEqualToString:@"1015"]) {
                        sandPointCountLab.text = [Tool fenToYuanDict:payToolDic];
                    }
                }
                //添加水波动画
                [self addWaveView];
            }];
        }];
        if (error) return ;
    }];
    
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
