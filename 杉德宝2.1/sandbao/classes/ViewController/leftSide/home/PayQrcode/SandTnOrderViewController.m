//
//  SandTnOrderViewController.m
//  sandbao
//
//  Created by tianNanYiHao on 2017/12/7.
//  Copyright © 2017年 sand. All rights reserved.
//

#import "SandTnOrderViewController.h"

#import "TnOrderCellView.h"

@interface SandTnOrderViewController ()
{
    UIView *headView;
    UIView *bodyView;
}
@end

@implementation SandTnOrderViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self create_HeadView];
    [self create_bodyView];
    
}
#pragma mark - 重写父类-baseScrollView设置
- (void)setBaseScrollview{
    [super setBaseScrollview];
}
#pragma mark - 重写父类-导航设置方法
- (void)setNavCoverView{
    [super setNavCoverView];
    self.navCoverView.style = NavCoverStyleWhite;
    self.navCoverView.midTitleStr = @"杉德宝安全支付";
    self.navCoverView.rightTitleStr = @"取消";
    
    __weak SandTnOrderViewController *weakSelf = self;
    self.navCoverView.rightBlock = ^{
        UIViewController *secVC = weakSelf.navigationController.viewControllers[1];
        [weakSelf.navigationController popToViewController:secVC animated:YES];
    };

}
#pragma mark - 重写父类-点击方法集合
- (void)buttonClick:(UIButton *)btn{
    
    if (btn.tag == BTN_TAG_PAY) {
        NSLog(@"立即付款");
    }
    
}

#pragma mark  - UI绘制
- (void)create_HeadView{
    
    headView = [[UIView alloc] init];
    headView.backgroundColor = COLOR_F5F5F5;
    [self.baseScrollView addSubview:headView];
    
    UILabel *titleLab = [Tool createLable:@"杉德宝-订单编号0023482842" attributeStr:nil font:FONT_15_Medium textColor:COLOR_343339 alignment:NSTextAlignmentCenter];
    [headView addSubview:titleLab];
    
    UILabel *moneyLab = [Tool createLable:@"¥422.0" attributeStr:nil font:FONT_36_SFUIT_Rrgular textColor:COLOR_343339 alignment:NSTextAlignmentCenter];
    [headView addSubview:moneyLab];
    
    CGFloat headViewH = UPDOWNSPACE_25 + titleLab.height + UPDOWNSPACE_10 + moneyLab.height + UPDOWNSPACE_25;
    
    [headView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.baseScrollView);
        make.centerX.equalTo(self.baseScrollView);
        make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH, headViewH));
    }];
    
    [titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(headView.mas_top).offset(UPDOWNSPACE_25);
        make.centerX.equalTo(headView);
        make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH, titleLab.height));
    }];
    
    [moneyLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(titleLab.mas_bottom).offset(UPDOWNSPACE_10);
        make.centerX.equalTo(headView);
        make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH, moneyLab.height));
    }];
    
}


- (void)create_bodyView{
    bodyView = [[UIView alloc] init];
    bodyView.backgroundColor = COLOR_FFFFFF;
    [self.baseScrollView addSubview:bodyView];
    
    TnOrderCellView *orderTimeCell = [TnOrderCellView createSetCellViewOY:0];
    orderTimeCell.titleStr = @"订单时间";
    orderTimeCell.clickBlock = ^{
        
    };
    orderTimeCell.rightStr = @"2017-12-12 12:30:11";
    [bodyView addSubview:orderTimeCell];
    
    TnOrderCellView *orderNameCell = [TnOrderCellView createSetCellViewOY:0];
    orderNameCell.titleStr = @"商户名称";
    orderNameCell.clickBlock = ^{
        
    };
    orderNameCell.rightStr = @"上海大表哥商务有限公司";
    [bodyView addSubview:orderNameCell];
    
    TnOrderCellView *orderNoCell = [TnOrderCellView createSetCellViewOY:0];
    orderNoCell.titleStr = @"商户订单号";
    orderNoCell.clickBlock = ^{
        
    };
    orderNoCell.rightStr = @"0988273623729001";
    [bodyView addSubview:orderNoCell];
    
    TnOrderCellView *orderPayWayCell = [TnOrderCellView createSetCellViewOY:0];
    orderPayWayCell.titleStr = @"支付方式";
    orderPayWayCell.clickBlock = ^{
        
    };
    orderPayWayCell.rightStr = @"账户余额";
    [bodyView addSubview:orderPayWayCell];

    //logintBtn
    UIButton *payBarBtn = [Tool createBarButton:@"立即付款" font:FONT_15_Regular titleColor:COLOR_FFFFFF backGroundColor:COLOR_358BEF leftSpace:LEFTRIGHTSPACE_40];
    payBarBtn.tag = BTN_TAG_PAY;
    [payBarBtn addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    [bodyView addSubview:payBarBtn];
    
    bodyView.height = orderTimeCell.height *4 + UPDOWNSPACE_69 + payBarBtn.height + UPDOWNSPACE_122;
    
    [bodyView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(headView.mas_bottom);
        make.centerX.equalTo(self.baseScrollView);
        make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH, bodyView.height));
    }];
    
    [orderTimeCell mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(bodyView);
        make.centerX.equalTo(bodyView);
        make.size.mas_equalTo(orderTimeCell.size);
    }];
    
    [orderNameCell mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(orderTimeCell.mas_bottom);
        make.centerX.equalTo(bodyView);
        make.size.mas_equalTo(orderNameCell.size);
    }];
    
    [orderNoCell mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(orderNameCell.mas_bottom);
        make.centerX.equalTo(bodyView);
        make.size.mas_equalTo(orderNoCell.size);
    }];

    [orderPayWayCell mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(orderNoCell.mas_bottom);
        make.centerX.equalTo(bodyView);
        make.size.mas_equalTo(orderPayWayCell.size);
    }];
    
    [payBarBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(orderPayWayCell.mas_bottom).offset(UPDOWNSPACE_69);
        make.centerX.equalTo(bodyView);
        make.size.mas_equalTo(payBarBtn.size);
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
