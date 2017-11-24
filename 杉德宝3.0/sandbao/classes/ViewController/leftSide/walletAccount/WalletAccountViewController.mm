//
//  WalletAccountViewController.m
//  sandbao
//
//  Created by tianNanYiHao on 2017/10/27.
//  Copyright © 2017年 sand. All rights reserved.
//

#import "WalletAccountViewController.h"
#import "PayNucHelper.h"
#import "GradualView.h"
#import "SDRechargePopView.h"

#import "BankCardRechargeViewController.h"
#import "PaymentRechargeViewController.h"
#import "PaymentActiveViewController.h"

#import "BankCardTransferViewController.h"
#import "UserTransferBeginViewController.h"

@interface WalletAccountViewController ()
{
    //headView
    GradualView *headView;
    
    //钱包账户_被充值_支付工具
    NSMutableDictionary *rechargeInPayToolDic;
    //钱包账户_被转账_支付工具
    NSMutableDictionary *transferOutPayToolDic;

    
    UILabel *balanceLab;
    
    BOOL payForAnthoerFlag; //代付凭证标识
}
@end

@implementation WalletAccountViewController

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    //允许RESideMenu的返回手势
    self.sideMenuViewController.panGestureEnabled = YES;
}


- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
    //1.刷新支付工具
    [self ownPayTools];
    
    //2.检查代付凭证标识
    [self checkPayAnthoerFlag];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    [self create_HeadView];
    [self create_BodyView];
    
}

#pragma mark - 重写父类-baseScrollView设置
- (void)setBaseScrollview{
    [super setBaseScrollview];
    
    self.baseScrollView.backgroundColor = COLOR_F5F5F5;
    
}
#pragma mark - 重写父类-导航设置方法
- (void)setNavCoverView{
    [super setNavCoverView];
    self.navCoverView.style = NavCoverStyleGradient;
    self.navCoverView.letfImgStr = @"login_icon_back_white";
    self.navCoverView.midTitleStr = @"钱包账户";
    
    __weak WalletAccountViewController *weakSelf = self;
    self.navCoverView.leftBlock = ^{
        [weakSelf presentLeftMenuViewController:weakSelf.sideMenuViewController];
    };
}
#pragma mark - 重写父类-点击方法集合
- (void)buttonClick:(UIButton *)btn{
    
    if (btn.tag == BTN_TAG_RECHARGE) {
        //@"充值"
        if ([[rechargeInPayToolDic objectForKey:@"available"] boolValue] == NO){
//            [Tool showDialog:@"账户暂时无法充值 available == NO"];
//            return ;
        }
        //1.代付凭证已激活
        if (payForAnthoerFlag) {
            SDRechargePopView *popview =  [SDRechargePopView showRechargePopView:@"选择充值账户" rechargeChooseBlock:^(NSString *cellName) {
                if ([cellName isEqualToString:@"银行卡充值"]) {
                    BankCardRechargeViewController *bankCardRechargeVC = [[BankCardRechargeViewController alloc] init];
                    bankCardRechargeVC.rechargeInPayToolDic = rechargeInPayToolDic;
                    bankCardRechargeVC.tTokenType = @"02000101";
                    [self.navigationController pushViewController:bankCardRechargeVC animated:YES];
                }
                if ([cellName isEqualToString:@"代付凭证充值"]) {
                    PaymentRechargeViewController *paymentRechargeVC = [[PaymentRechargeViewController alloc] init];
                    paymentRechargeVC.rechargeInPayToolDic = rechargeInPayToolDic;
                    paymentRechargeVC.tTokenType = @"02000101";
                    [self.navigationController pushViewController:paymentRechargeVC animated:YES];
                }
            }];
            popview.chooseBtnTitleArr = @[@"银行卡充值",@"代付凭证充值"];
        }
        //2.代付凭证未激活
        else{
            SDRechargePopView *popview = [SDRechargePopView showRechargePopView:@"选择充值账户" rechargeChooseBlock:^(NSString *cellName) {
                if ([cellName isEqualToString:@"银行卡充值"]) {
                    BankCardRechargeViewController *bankCardRechargeVC = [[BankCardRechargeViewController alloc] init];
                    bankCardRechargeVC.rechargeInPayToolDic = rechargeInPayToolDic;
                    bankCardRechargeVC.tTokenType = @"02000101";
                    [self.navigationController pushViewController:bankCardRechargeVC animated:YES];
                }else{
                    //跳转去代付凭证激活页
                    PaymentActiveViewController *paymentActiveVC = [[PaymentActiveViewController alloc] init];
                    [self.navigationController pushViewController:paymentActiveVC animated:YES];
                }
            }];
            popview.chooseBtnTitleArr = @[@"银行卡充值"];
        }
    }
    if (btn.tag == BTN_TAG_TRANSFER) {
        if ([[transferOutPayToolDic objectForKey:@"available"] boolValue] == NO){
//            [Tool showDialog:@"账户暂时无法转账 available == NO"];
//            return ;
        }
        SDRechargePopView *popview = [SDRechargePopView showRechargePopView:@"转账到" rechargeChooseBlock:^(NSString *cellName) {
            if ([cellName isEqualToString:@"个人银行卡"]) {
                if ([[[transferOutPayToolDic objectForKey:@"account"] objectForKey:@"useableBalance"] floatValue] == 0) {
                    [Tool showDialog:@"账户余额不足,无法转账到银行卡"];
                    return ;
                }
                BankCardTransferViewController * bankCardTransferVC = [[BankCardTransferViewController alloc] init];
                bankCardTransferVC.transferOutPayToolDic = transferOutPayToolDic;
                bankCardTransferVC.tTokenType = @"02000201";
                [self.navigationController pushViewController:bankCardTransferVC animated:YES];
            }
            if ([cellName isEqualToString:@"杉德宝用户"]) {
                if ([[[transferOutPayToolDic objectForKey:@"account"] objectForKey:@"useableBalance"] floatValue] == 0) {
                    [Tool showDialog:@"账户余额不足,无法转账到杉德宝用户"];
                    return ;
                }
                UserTransferBeginViewController *sandUserTransferVC = [[UserTransferBeginViewController alloc] init];
                [self.navigationController pushViewController:sandUserTransferVC animated:YES];
            }
        }];
        popview.chooseBtnTitleArr = @[@"个人银行卡",@"杉德宝用户"];
    }
}


#pragma mark  - UI绘制
//创建头部
- (void)create_HeadView{

    //headView
    headView = [[GradualView alloc] init];
    [headView setRect:CGRectMake(LEFTRIGHTSPACE_00, UPDOWNSPACE_0, SCREEN_WIDTH, UPDOWNSPACE_122)];
    [self.baseScrollView addSubview:headView];
    
    [headView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.baseScrollView.mas_top);
        make.left.equalTo(self.baseScrollView.mas_left);
        make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH, UPDOWNSPACE_122));
    }];
    
    //titleLab
    UILabel *titleLab = [Tool createLable:@"账户余额(元)" attributeStr:nil font:FONT_14_Regular textColor:COLOR_FFFFFF alignment:NSTextAlignmentCenter];
    [headView addSubview:titleLab];
    
    //balanceLab
    balanceLab = [Tool createLable:@"0.00" attributeStr:nil font:FONT_35_SFUIT_Rrgular textColor:COLOR_FFFFFF alignment:NSTextAlignmentCenter];
    [headView addSubview:balanceLab];
    
    [titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(headView.mas_top).offset(UPDOWNSPACE_20);
        make.centerX.equalTo(headView.mas_centerX);
        make.size.mas_equalTo(titleLab.size);
    }];
    
    [balanceLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(titleLab.mas_bottom).offset(UPDOWNSPACE_16);
        make.centerX.equalTo(headView.mas_centerX);
        make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH, balanceLab.height));
    }];
    
}


- (void)create_BodyView{
    
    //rechargeAccBtn
    UIButton *rechargeAccBtn = [Tool createButton:nil attributeStr:nil font:nil textColor:nil];
    rechargeAccBtn.backgroundColor = COLOR_FFFFFF;
    rechargeAccBtn.tag = BTN_TAG_RECHARGE;
    [rechargeAccBtn addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.baseScrollView  addSubview:rechargeAccBtn];
    
    UIImage *rechargeImg = [UIImage imageNamed:@"wallet_account_icon_add"];
    UIImageView *rechargeImgView = [Tool createImagView:rechargeImg];
    [rechargeAccBtn addSubview:rechargeImgView];
    
    UILabel *rechargeLab = [Tool createLable:@"充值" attributeStr:nil font:FONT_15_Regular textColor:COLOR_343339_7 alignment:NSTextAlignmentCenter];
    [rechargeAccBtn addSubview:rechargeLab];
    rechargeAccBtn.width = rechargeImg.size.width + LEFTRIGHTSPACE_50 *2;
    rechargeAccBtn.height = rechargeImg.size.height + UPDOWNSPACE_30 + UPDOWNSPACE_20 + rechargeLab.height + UPDOWNSPACE_58;
    
    CGFloat leftAndRightMargin = (SCREEN_WIDTH - LEFTRIGHTSPACE_12 - rechargeAccBtn.width*2)/2;
    
    
    [rechargeAccBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(headView.mas_bottom).offset(UPDOWNSPACE_40);
        make.left.equalTo(self.baseScrollView.mas_left).offset(leftAndRightMargin);
        make.size.mas_equalTo(CGSizeMake(rechargeAccBtn.width, rechargeAccBtn.height));
    }];
    
    [rechargeImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(rechargeAccBtn.mas_top).offset(UPDOWNSPACE_36);
        make.centerX.equalTo(rechargeAccBtn.mas_centerX);
        make.size.mas_equalTo(rechargeImgView.size);
    }];
    
    [rechargeLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(rechargeImgView.mas_bottom).offset(UPDOWNSPACE_25);
        make.centerX.equalTo(rechargeAccBtn.mas_centerX);
        make.size.mas_equalTo(rechargeLab.size);
    }];
    
    
    //transferAccBtn
    UIButton *transferAccBtn = [Tool createButton:nil attributeStr:nil font:nil textColor:nil];
    transferAccBtn.tag = BTN_TAG_TRANSFER;
    transferAccBtn.backgroundColor = COLOR_FFFFFF;
    [transferAccBtn addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.baseScrollView  addSubview:transferAccBtn];
    
    UIImage *transferImg = [UIImage imageNamed:@"wallet_account_icon_transfer"];
    UIImageView *transferImgView = [Tool createImagView:transferImg];
    [transferAccBtn addSubview:transferImgView];
    
    UILabel *transferLab = [Tool createLable:@"转账" attributeStr:nil font:FONT_15_Regular textColor:COLOR_343339_7 alignment:NSTextAlignmentCenter];
    [transferAccBtn addSubview:transferLab];
    
    
    [transferAccBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(headView.mas_bottom).offset(UPDOWNSPACE_40);
        make.left.equalTo(rechargeAccBtn.mas_right).offset(LEFTRIGHTSPACE_12);
        make.size.mas_equalTo(CGSizeMake(rechargeAccBtn.width, rechargeAccBtn.height));
    }];
    
    [transferImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(transferAccBtn.mas_top).offset(UPDOWNSPACE_36);
        make.centerX.equalTo(transferAccBtn.mas_centerX);
        make.size.mas_equalTo(transferImgView.size);
    }];
    
    [transferLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(transferImgView.mas_bottom).offset(UPDOWNSPACE_25);
        make.centerX.equalTo(transferAccBtn.mas_centerX);
        make.size.mas_equalTo(transferLab.size);
    }];
    
    
}

#pragma mark - 业务逻辑
#pragma mark 查询我方支付工具鉴权工具
/**
 *@brief 查询我方支付工具
 */
- (void)ownPayTools
{
    //不允许RESideMenu的返回手势
    self.sideMenuViewController.panGestureEnabled = NO;
    
    self.HUD = [SDMBProgressView showSDMBProgressOnlyLoadingINViewImg:self.view];
    [SDRequestHelp shareSDRequest].HUD = self.HUD;
    [SDRequestHelp shareSDRequest].controller = self;
    [[SDRequestHelp shareSDRequest] dispatchGlobalQuque:^{
        __block BOOL error = NO;
        paynuc.set("tTokenType", "01001501");
        [[SDRequestHelp shareSDRequest] requestWihtFuncName:@"token/getTtoken/v1" errorBlock:^(SDRequestErrorType type) {
            error = YES;
            //允许RESideMenu的返回手势
            self.sideMenuViewController.panGestureEnabled = YES;
        } successBlock:^{
            
        }];
        if (error) return ;
        
        
        paynuc.set("payToolKinds", "[]");
        [[SDRequestHelp shareSDRequest] requestWihtFuncName:@"payTool/getOwnPayTools/v1" errorBlock:^(SDRequestErrorType type) {
            error = YES;
            //允许RESideMenu的返回手势
            self.sideMenuViewController.panGestureEnabled = YES;
        } successBlock:^{
            [[SDRequestHelp shareSDRequest] dispatchToMainQueue:^{
                [self.HUD hidden];
                
                //允许RESideMenu的返回手势
                self.sideMenuViewController.panGestureEnabled = YES;
                
                NSArray *payToolsArray = [[PayNucHelper sharedInstance] jsonStringToArray:[NSString stringWithUTF8String:paynuc.get("payTools").c_str()]];
                //支付工具排序
                payToolsArray = [Tool orderForPayTools:payToolsArray];
                [CommParameter sharedInstance].ownPayToolsArray = payToolsArray;
                
                //设置支付工具
                [self settingData];
                
            }];
        }];
        if (error) return ;
    }];
    
}

/**
 *@brief  设置支付工具
 *@return
 */
- (void)settingData
{
    NSDictionary *ownPayToolDic = [Tool getPayToolsInfo:[CommParameter sharedInstance].ownPayToolsArray];
    
    //钱包账户_被充值_支付工具 - 初始化
    rechargeInPayToolDic = [NSMutableDictionary dictionaryWithCapacity:0];
    rechargeInPayToolDic = [ownPayToolDic objectForKey:@"sandWalletDic"];
    
    if (rechargeInPayToolDic == nil) {
        //钱包账户未成功开通
        [Tool showDialog:@"钱包账户不存在,请联系客服!" defulBlock:^{
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"tel:021-962567"]];
        }];
    }else{
        
        NSString *balacneStr = [[rechargeInPayToolDic objectForKey:@"account"] objectForKey:@"balance"];
        NSString *moneyStr_fen = [Tool numberStyleWith:[NSNumber numberWithFloat:[balacneStr floatValue]]];
        
        NSString *moneyYuanStr = [moneyStr_fen substringToIndex:(moneyStr_fen.length -2)];
        NSString *moneyFenStr  = [moneyStr_fen substringFromIndex:(moneyStr_fen.length - 2)];
        
        if ([balacneStr floatValue] != 0) {
            balanceLab.text = [NSString stringWithFormat:@"%@.%@",moneyYuanStr,moneyFenStr];
        }else{
            balanceLab.text = @"0.00";
        }
        
        //钱包账户_被转账_支付工具
        transferOutPayToolDic = [NSMutableDictionary dictionaryWithCapacity:0];
        transferOutPayToolDic = [ownPayToolDic objectForKey:@"sandWalletDic"];
    }
    
}


#pragma mark - 本类公共方法调用

#pragma mark 检查代付凭证标识
- (void)checkPayAnthoerFlag{
    
    //取代付凭证标识
    payForAnthoerFlag = [CommParameter sharedInstance].payForAnotherFlag;
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
