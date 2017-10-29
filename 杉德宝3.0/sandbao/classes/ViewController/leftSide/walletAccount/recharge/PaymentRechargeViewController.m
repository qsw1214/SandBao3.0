//
//  PaymentRechargeViewController.m
//  sandbao
//
//  Created by tianNanYiHao on 2017/10/29.
//  Copyright © 2017年 sand. All rights reserved.
//


#import "PaymentRechargeViewController.h"

#import "PaymentNoCell.h"
#import "PaymentCodeCell.h"
#import "PaymentPwdCell.h"
#import "PaymentMoneyCell.h"


/**
 代付凭证充值
 */
@interface PaymentRechargeViewController ()

@end

@implementation PaymentRechargeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self createUI];
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
    self.navCoverView.midTitleStr = @"代付凭证充值";
    self.navCoverView.letfImgStr = @"general_icon_back";
    
    
    __block PaymentRechargeViewController *selfBlock = self;
    self.navCoverView.leftBlock = ^{
        [selfBlock.navigationController popViewControllerAnimated:YES];
    };
    
    
}
#pragma mark - 重写父类-点击方法集合
- (void)buttonClick:(UIButton *)btn{
    

    
}


#pragma mark  - UI绘制

- (void)createUI{
    
    PaymentNoCell *paymentNoCell = [PaymentNoCell createPaymentCellViewOY:0];
    [self.baseScrollView addSubview:paymentNoCell];
    
    PaymentCodeCell *paymenCodeCell = [PaymentCodeCell createPaymentCellViewOY:0];
    [self.baseScrollView addSubview:paymenCodeCell];
    
    PaymentPwdCell *paymentPwdCell = [PaymentPwdCell createPaymentCellViewOY:0];
    [self.baseScrollView addSubview:paymentPwdCell];
    
    PaymentMoneyCell *paymentMoneyCell = [PaymentMoneyCell createPaymentCellViewOY:0];
    [self.baseScrollView addSubview:paymentMoneyCell];
    
    [paymentNoCell mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.baseScrollView.mas_top).offset(UPDOWNSPACE_20);
        make.centerX.equalTo(self.baseScrollView);
        make.size.mas_equalTo(paymentNoCell.size);
    }];
    
    [paymenCodeCell mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(paymentNoCell.mas_bottom);
        make.centerX.equalTo(self.baseScrollView);
        make.size.mas_equalTo(paymenCodeCell.size);
    }];
    
    [paymentPwdCell mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(paymenCodeCell.mas_bottom);
        make.centerX.equalTo(self.baseScrollView);
        make.size.mas_equalTo(paymentPwdCell.size);
    }];
    
    [paymentMoneyCell mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(paymentPwdCell.mas_bottom);
        make.centerX.equalTo(self.baseScrollView);
        make.size.mas_equalTo(paymentMoneyCell.size);
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
