//
//  PaymentRechargeViewController.m
//  sandbao
//
//  Created by tianNanYiHao on 2017/11/1.
//  Copyright © 2017年 sand. All rights reserved.
//

#import "PaymentRechargeViewController.h"
#import "RechargeFinishViewController.h"

#import "PaymentPwdCell.h"

@interface PaymentRechargeViewController ()
{
    
    
}
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
    
    
    __block PaymentRechargeViewController *weakSelf = self;
    self.navCoverView.leftBlock = ^{
        [weakSelf.navigationController popViewControllerAnimated:YES];
    };
    
    
}
#pragma mark - 重写父类-点击方法集合
- (void)buttonClick:(UIButton *)btn{
    
    if (btn.tag == BTN_TAG_RECHARGE) {
        
        RechargeFinishViewController *rechargeFinish = [[RechargeFinishViewController alloc] init];
        [self.navigationController pushViewController:rechargeFinish animated:YES];
        
    }
    
}


#pragma mark  - UI绘制

- (void)createUI{

    PaymentPwdCell *paymentPwdCell = [PaymentPwdCell createPaymentCellViewOY:0];
    paymentPwdCell.line.hidden = YES;
    [self.baseScrollView addSubview:paymentPwdCell];

    [paymentPwdCell mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.baseScrollView.mas_top).offset(UPDOWNSPACE_20);
        make.centerX.equalTo(self.baseScrollView);
        make.size.mas_equalTo(paymentPwdCell.size);
    }];
    
    
    //rechargeBtn
    UIButton *rechargeBtn = [Tool createBarButton:@"充值" font:FONT_15_Regular titleColor:COLOR_FFFFFF backGroundColor:COLOR_358BEF leftSpace:LEFTRIGHTSPACE_40];
    rechargeBtn.tag = BTN_TAG_RECHARGE;
    [rechargeBtn addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.baseScrollView addSubview:rechargeBtn];
    
    [rechargeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(paymentPwdCell.mas_bottom).offset(UPDOWNSPACE_69);
        make.centerX.equalTo(self.baseScrollView.mas_centerX);
        make.size.mas_equalTo(rechargeBtn.size);
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
