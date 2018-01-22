//
//  UserTransferFinishViewController.m
//  sandbao
//
//  Created by tianNanYiHao on 2017/11/10.
//  Copyright © 2017年 sand. All rights reserved.
//

#import "UserTransferFinishViewController.h"
#import "PayNucHelper.h"

@interface UserTransferFinishViewController ()
{
    UIView *headView;
}
@end

@implementation UserTransferFinishViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self createUI];
    [self ownPayTools];
}


#pragma mark - 重写父类-baseScrollView设置
- (void)setBaseScrollview{
    [super setBaseScrollview];
    self.baseScrollView.backgroundColor = COLOR_F5F5F5;
    
}
#pragma mark - 重写父类-导航设置方法
- (void)setNavCoverView{
    [super setNavCoverView];
    self.navCoverView.style = NavCoverStyleWhite;
    self.navCoverView.midTitleStr = @"结果详情";
    self.navCoverView.rightTitleStr = @"完成";
    
    __weak UserTransferFinishViewController *weakSelf = self;
    self.navCoverView.rightBlock = ^{
        [weakSelf.navigationController popToRootViewControllerAnimated:YES];
    };
    
    
}
#pragma mark - 重写父类-点击方法集合
- (void)buttonClick:(UIButton *)btn{
    
}


#pragma mark  - UI绘制

- (void)createUI{

    headView = [[UIView alloc] init];
    headView.backgroundColor = COLOR_FFFFFF;
    [self.baseScrollView addSubview:headView];
    
    
    //transferFinishLab
    UILabel *transferFinishLab = [Tool createLable:self.titleStr attributeStr:nil font:FONT_15_Regular textColor:COLOR_343339_7 alignment:NSTextAlignmentCenter];
    [self.baseScrollView addSubview:transferFinishLab];
    
    
    //transferMoneyLab
    UILabel *transferMoneyLab = [Tool createLable:[NSString stringWithFormat:@"-%@",self.amtStr] attributeStr:nil font:FONT_28_SFUIT_Rrgular textColor:COLOR_000000 alignment:NSTextAlignmentCenter];
    [self.baseScrollView addSubview:transferMoneyLab];
    
    
    headView.height = UPDOWNSPACE_25 *2 + UPDOWNSPACE_15 + transferFinishLab.height + transferMoneyLab.height;
    
    [headView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.baseScrollView.mas_top).offset(UPDOWNSPACE_10);
        make.centerX.equalTo(self.baseScrollView);
        make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH, headView.height));
    }];
    
    [transferFinishLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(headView.mas_top).offset(UPDOWNSPACE_25);
        make.centerX.equalTo(headView);
        make.size.mas_equalTo(transferFinishLab.size);
    }];
    
    [transferMoneyLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(transferFinishLab.mas_bottom).offset(UPDOWNSPACE_15);
        make.centerX.equalTo(headView);
        make.size.mas_equalTo(transferMoneyLab.size);
    }];
    
    

}

#pragma mark - 业务逻辑
#pragma mark 查询我方支付工具鉴权工具
/**
 *@brief 查询我方支付工具
 */
- (void)ownPayTools
{
    self.HUD = [SDMBProgressView showSDMBProgressOnlyLoadingINViewImg:self.view];
    [SDRequestHelp shareSDRequest].HUD = self.HUD;
    [SDRequestHelp shareSDRequest].controller = self;
    [[SDRequestHelp shareSDRequest] dispatchGlobalQuque:^{
        __block BOOL error = NO;
        paynuc.set("tTokenType", "01001501");
        paynuc.set("cfg_termFp", [[Tool setCfgTempFpStaticDataFlag:NO DynamicDataFlag:YES] UTF8String]);
        [[SDRequestHelp shareSDRequest] requestWihtFuncName:@"token/getTtoken/v1" errorBlock:^(SDRequestErrorType type) {
            error = YES;
        } successBlock:^{
            
        }];
        if (error) return ;
        
        paynuc.set("payToolKinds", "[]");
        [[SDRequestHelp shareSDRequest] requestWihtFuncName:@"payTool/getOwnPayTools/v1" errorBlock:^(SDRequestErrorType type) {
            error = YES;
        } successBlock:^{
            [[SDRequestHelp shareSDRequest] dispatchToMainQueue:^{
                [self.HUD hidden];
                
                NSArray *payToolsArray = [[PayNucHelper sharedInstance] jsonStringToArray:[NSString stringWithUTF8String:paynuc.get("payTools").c_str()]];
                //支付工具排序
                payToolsArray = [Tool orderForPayTools:payToolsArray];
                [CommParameter sharedInstance].ownPayToolsArray = payToolsArray;
                
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
