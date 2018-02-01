//
//  SandPointsViewController.m
//  sandbao
//
//  Created by tianNanYiHao on 2017/10/27.
//  Copyright © 2017年 sand. All rights reserved.
//

#import "SandPointsViewController.h"
#import "WebViewController.h"

@interface SandPointsViewController ()

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
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self creaetUI];
    
    
}



#pragma mark - 重写父类-baseScrollView设置
- (void)setBaseScrollview{
    [super setBaseScrollview];
    
}
#pragma mark - 重写父类-导航设置方法
- (void)setNavCoverView{
    [super setNavCoverView];
    self.navCoverView.style = NavCoverStyleGradient;
    self.navCoverView.letfImgStr = @"login_icon_back_white";
    self.navCoverView.midTitleStr = @"杉德积分";
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
    
    UIImage *backGroundImg = [UIImage imageNamed:@"billpage_empty"];
    UIImageView *backGroundImgView = [Tool createImagView:backGroundImg];
    [self.baseScrollView addSubview:backGroundImgView];
    
    [backGroundImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.baseScrollView.mas_top);
        make.centerX.equalTo(self.baseScrollView.mas_centerX);
        make.size.mas_equalTo(self.baseScrollView.size);
    }];
    
    
}

- (void)settingData
{
    NSDictionary *ownPayToolDic = [Tool getPayToolsInfo:[CommParameter sharedInstance].ownPayToolsArray];
    
    //钱包账户_被充值_支付工具 - 初始化
    NSDictionary *sandPointDic = [NSMutableDictionary dictionaryWithCapacity:0];
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
