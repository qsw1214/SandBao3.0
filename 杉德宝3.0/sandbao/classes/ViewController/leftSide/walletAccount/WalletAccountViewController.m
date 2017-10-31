//
//  WalletAccountViewController.m
//  sandbao
//
//  Created by tianNanYiHao on 2017/10/27.
//  Copyright © 2017年 sand. All rights reserved.
//

#import "WalletAccountViewController.h"

#import "GradualView.h"
#import "SDRechargePopView.h"

#import "BankCardRechargeViewController.h"
#import "PaymentRechargeViewController.h"

#import "BankCardTransferViewController.h"
#import "SandUserTransferViewController.h"

#import "MainViewController.h"
@interface WalletAccountViewController ()
{
    //headView
    GradualView *headView;
}
@end

@implementation WalletAccountViewController

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    // 禁用返回手势
    if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.navigationController.interactivePopGestureRecognizer.enabled = NO;
    }
    //允许RESideMenu的返回手势
    self.sideMenuViewController.panGestureEnabled = YES;
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
    
    __block WalletAccountViewController *weakSelf = self;
    self.navCoverView.leftBlock = ^{
        [weakSelf presentLeftMenuViewController:weakSelf.sideMenuViewController];
    };
}
#pragma mark - 重写父类-点击方法集合
- (void)buttonClick:(UIButton *)btn{
    
    if (btn.tag == BTN_TAG_RECHARGE) {
        NSLog(@"充值");
        
        BOOL paymentActivite = 1;
        
        if (paymentActivite) {
            
            SDRechargePopView *popview =  [SDRechargePopView showRechargePopView:@"选择充值账户" rechargeChooseBlock:^(NSString *cellName) {
                
                //充值
                if ([cellName isEqualToString:@"银行卡充值"]) {
                    BankCardRechargeViewController *bankCardRechargeVC = [[BankCardRechargeViewController alloc] init];
                    [self.navigationController pushViewController:bankCardRechargeVC animated:YES];
                }
                if ([cellName isEqualToString:@"代付凭证充值"]) {
                    PaymentRechargeViewController *paymentRechargeVC = [[PaymentRechargeViewController alloc] init];
                    [self.navigationController pushViewController:paymentRechargeVC animated:YES];
                }
            }];
            
            popview.chooseBtnTitleArr = @[@"银行卡充值",@"代付凭证充值"];
        }
        else{
            SDRechargePopView *popview = [SDRechargePopView showRechargePopView:@"选择充值账户" rechargeChooseBlock:^(NSString *cellName) {
                //跳转去代付凭证激活页
                PaymentRechargeViewController *paymentRechargeVC = [[PaymentRechargeViewController alloc] init];
                [self.navigationController pushViewController:paymentRechargeVC animated:YES];
                
            }];
            popview.chooseBtnTitleArr = @[@"银行卡充值"];
            
        }
    }
    if (btn.tag == BTN_TAG_TRANSFER) {
        NSLog(@"转账");
        
        SDRechargePopView *popview = [SDRechargePopView showRechargePopView:@"选择充值账户" rechargeChooseBlock:^(NSString *cellName) {
            
            //转账
            if ([cellName isEqualToString:@"个人银行卡"]) {
                BankCardTransferViewController * bankCardTransferVC = [[BankCardTransferViewController alloc] init];
                [self.navigationController pushViewController:bankCardTransferVC animated:YES];
            }
            if ([cellName isEqualToString:@"杉德宝用户"]) {
                SandUserTransferViewController *sandUserTransferVC = [[SandUserTransferViewController alloc] init];
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
    UILabel *balanceLab = [Tool createLable:@"9,999,999.00" attributeStr:nil font:FONT_35_SFUIT_Rrgular textColor:COLOR_FFFFFF alignment:NSTextAlignmentCenter];
    [headView addSubview:balanceLab];
    
    [titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(headView.mas_top).offset(UPDOWNSPACE_20);
        make.centerX.equalTo(headView.mas_centerX);
        make.size.mas_equalTo(titleLab.size);
    }];
    
    [balanceLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(titleLab.mas_bottom).offset(UPDOWNSPACE_16);
        make.centerX.equalTo(headView.mas_centerX);
        make.size.mas_equalTo(balanceLab.size);
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
