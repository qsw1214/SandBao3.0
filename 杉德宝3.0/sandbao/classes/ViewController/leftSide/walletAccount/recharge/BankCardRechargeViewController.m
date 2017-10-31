//
//  BankCardRechargeViewController.m
//  sandbao
//
//  Created by tianNanYiHao on 2017/10/28.
//  Copyright © 2017年 sand. All rights reserved.
//

#import "BankCardRechargeViewController.h"

#import "RechargeFinishViewController.h"

/**
 银行卡充值
 */
@interface BankCardRechargeViewController ()
{
    
    UIView *headView;
    UIView *tipView;
    UIView *bodyView;
    
}
@end

@implementation BankCardRechargeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self create_HeadView];
    [self create_TipView];
    [self create_BodyView];
    [self create_NextBarBtn];
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
    self.navCoverView.midTitleStr = @"银行卡充值";
    self.navCoverView.letfImgStr = @"general_icon_back";

    
    __block BankCardRechargeViewController *weakSelf = self;
    self.navCoverView.leftBlock = ^{
        [weakSelf.navigationController popViewControllerAnimated:YES];
    };
    
    
}
#pragma mark - 重写父类-点击方法集合
- (void)buttonClick:(UIButton *)btn{
    
    if (btn.tag == BTN_TAG_RECHARGE) {
        RechargeFinishViewController *rechargeFinishVC = [[RechargeFinishViewController alloc] init];
        [self.navigationController pushViewController:rechargeFinishVC animated:YES];
    }
    
    if (btn.tag == BTN_TAG_SHOWALLMONEY) {
         
    }
    
}


#pragma mark  - UI绘制

- (void)create_HeadView{
    //headView
    headView = [[UIView alloc] init];
    headView.backgroundColor = COLOR_FFFFFF;
    [self.baseScrollView addSubview:headView];
    
    //bankIcon
    UIImage *bankIconImag = [UIImage imageNamed:@"banklist_gh"];
    UIImageView *bankIconImgView = [Tool createImagView:bankIconImag];
    [headView addSubview:bankIconImgView];
    
    //bankName
    UILabel *bankNameLab = [Tool createLable:@"中国工商银行储蓄卡" attributeStr:nil font:FONT_13_Regular textColor:COLOR_343339 alignment:NSTextAlignmentLeft];
    [headView addSubview:bankNameLab];
    
    //bankNum
    UILabel *bankNumLab = [Tool createLable:@"尾号0008" attributeStr:nil font:FONT_13_Regular textColor:COLOR_343339_5 alignment:NSTextAlignmentLeft];
    [headView addSubview:bankNumLab];
    
    headView.height = bankIconImag.size.height + UPDOWNSPACE_16*2;
    CGFloat bankNameLabW = SCREEN_WIDTH - bankIconImgView.width - LEFTRIGHTSPACE_35 - LEFTRIGHTSPACE_09;
    
    [headView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.baseScrollView.mas_bottom).offset(UPDOWNSPACE_10);
        make.centerX.equalTo(self.baseScrollView);
        make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH, headView.height));
    }];
    
    [bankIconImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(headView.mas_top).offset(UPDOWNSPACE_16);
        make.left.equalTo(headView.mas_left).offset(LEFTRIGHTSPACE_35);
        make.size.mas_equalTo(bankIconImgView.size);
    }];
    
    [bankNameLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(bankIconImgView.mas_top);
        make.left.equalTo(bankIconImgView.mas_right).offset(LEFTRIGHTSPACE_09);
        make.size.mas_equalTo(CGSizeMake(bankNameLabW, bankNameLab.height));
    }];
    
    [bankNumLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(bankIconImgView.mas_bottom);
        make.left.equalTo(bankIconImgView.mas_right).offset(LEFTRIGHTSPACE_09);
        make.size.mas_equalTo(CGSizeMake(bankNameLabW, bankNumLab.height));
    }];
    
    
}

//提示View
- (void)create_TipView{
    
    tipView = [[UIView alloc] init];
    tipView.backgroundColor = COLOR_F5F5F5;
    [self.baseScrollView addSubview:tipView];
    
    //tipLab
    UILabel *tipLab = [Tool createLable:@"该卡最多可免费充值1000.00元" attributeStr:nil font:FONT_11_Regular textColor:COLOR_343339_5 alignment:NSTextAlignmentLeft];
    [tipView addSubview:tipLab];
    
    tipView.height = tipLab.height + UPDOWNSPACE_15*2;
    CGFloat tipLabW = SCREEN_WIDTH - LEFTRIGHTSPACE_35;
    
    [tipView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.baseScrollView);
        make.top.equalTo(headView.mas_bottom);
        make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH, tipView.height));
    }];
    
    [tipLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(tipView.mas_centerY);
        make.left.equalTo(tipView.mas_left).offset(LEFTRIGHTSPACE_35);
        make.size.mas_equalTo(CGSizeMake(tipLabW, tipLab.height));
    }];
    
    
}

- (void)create_BodyView{
    
    bodyView = [[UIView alloc] init];
    bodyView.backgroundColor = COLOR_FFFFFF;
    [self.baseScrollView addSubview:bodyView];
    
    
    //rechargeMoneyLab
    UILabel *rechargeMoneyLab = [Tool createLable:@"充值金额" attributeStr:nil font:FONT_13_Regular textColor:COLOR_343339 alignment:NSTextAlignmentLeft];
    [bodyView addSubview:rechargeMoneyLab];
    
    //rmbLab
    UILabel *rmbLab = [Tool createLable:@"¥" attributeStr:nil font:FONT_24_Medium textColor:COLOR_343339 alignment:NSTextAlignmentLeft];
    [bodyView addSubview:rmbLab];
    
    //moneyTextfield
    UITextField *moneyTextfield = [Tool createTextField:@"0.00" font:FONT_36_SFUIT_Rrgular textColor:COLOR_343339_5];
    moneyTextfield.keyboardType = UIKeyboardTypeNumberPad;
    moneyTextfield.clearButtonMode = UITextFieldViewModeWhileEditing;
    moneyTextfield.height += UPDOWNSPACE_30*2;
    moneyTextfield.width = SCREEN_WIDTH - LEFTRIGHTSPACE_55;
    [bodyView addSubview:moneyTextfield];
    
    //line
    UIView *line = [[UIView alloc] init];
    line.backgroundColor = COLOR_A1A2A5_3;
    line.size = CGSizeMake(SCREEN_WIDTH - 2*LEFTRIGHTSPACE_20, 1);
    [bodyView addSubview:line];
    
    //bottomTipLab
    UILabel *bottomTipLab = [Tool createLable:@"超出最多可免费充值的金额将收取手续费" attributeStr:nil font:FONT_11_Regular textColor:COLOR_343339_5 alignment:NSTextAlignmentLeft];
    [bodyView addSubview:bottomTipLab];
    
    //bottomBtn
    UIButton *bottomBtn = [Tool createButton:@"全部充值" attributeStr:nil font:FONT_13_Regular textColor:COLOR_FF5D31];
    bottomBtn.tag = BTN_TAG_SHOWALLMONEY;
    [bottomBtn addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    bottomBtn.size = CGSizeMake(bottomBtn.width, bottomBtn.height + UPDOWNSPACE_25);
    [bodyView addSubview:bottomBtn];
    
    
    CGFloat bodyViewH = UPDOWNSPACE_20 + rechargeMoneyLab.height + moneyTextfield.height + UPDOWNSPACE_25 + bottomTipLab.height + UPDOWNSPACE_25;
    
    [bodyView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(tipView.mas_bottom);
        make.centerX.equalTo(self.baseScrollView);
        make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH, bodyViewH));
    }];
    
    [rechargeMoneyLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(bodyView.mas_top).offset(UPDOWNSPACE_20);
        make.left.equalTo(bodyView.mas_left).offset(LEFTRIGHTSPACE_35);
        make.size.mas_equalTo(rechargeMoneyLab.size);
    }];
    
    [moneyTextfield mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(rechargeMoneyLab.mas_bottom).offset(UPDOWNSPACE_0);
        make.left.equalTo(bodyView.mas_left).offset(LEFTRIGHTSPACE_55);
        make.size.mas_equalTo(CGSizeMake(moneyTextfield.width, moneyTextfield.height));
    }];
    
    [rmbLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(moneyTextfield.mas_centerY);
        make.left.equalTo(bodyView.mas_left).offset(LEFTRIGHTSPACE_35);
        make.size.mas_equalTo(rmbLab.size);
    }];
    
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(moneyTextfield.mas_bottom);
        make.left.equalTo(bodyView.mas_left).offset(LEFTRIGHTSPACE_20);
        make.size.mas_equalTo(line.size);
    }];
    
    [bottomTipLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(line.mas_bottom).offset(UPDOWNSPACE_25);
        make.left.equalTo(bodyView.mas_left).offset(LEFTRIGHTSPACE_35);
        make.size.mas_equalTo(bottomTipLab.size);
    }];
    
    [bottomBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(bottomTipLab.mas_centerY);
        make.right.equalTo(bodyView.mas_right).offset(-LEFTRIGHTSPACE_20);
        make.size.mas_equalTo(bottomBtn.size);
    }];
    


    
}

- (void)create_NextBarBtn{
    //rechargeBtn
    UIButton *rechargeBtn = [Tool createBarButton:@"充值" font:FONT_15_Regular titleColor:COLOR_FFFFFF backGroundColor:COLOR_358BEF leftSpace:LEFTRIGHTSPACE_40];
    rechargeBtn.tag = BTN_TAG_RECHARGE;
    [rechargeBtn addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.baseScrollView addSubview:rechargeBtn];
    
    [rechargeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(bodyView.mas_bottom).offset(UPDOWNSPACE_69);
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
