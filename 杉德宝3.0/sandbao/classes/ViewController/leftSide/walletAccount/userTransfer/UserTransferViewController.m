//
//  UserTransferViewController.m
//  sandbao
//
//  Created by tianNanYiHao on 2017/11/1.
//  Copyright © 2017年 sand. All rights reserved.
//

#import "UserTransferViewController.h"

@interface UserTransferViewController ()<UITextFieldDelegate>
{
    UIView *headView;
    UIView *bodyView;
    UIView *bottomView;
    
    UITextField *moneyTextfield;
}
@end

@implementation UserTransferViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
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
    self.navCoverView.style = NavCoverStyleWhite;
    self.navCoverView.midTitleStr = @"转账到杉德宝账户";
    self.navCoverView.letfImgStr = @"general_icon_back";
    
    __block UserTransferViewController *weakSelf = self;
    self.navCoverView.leftBlock = ^{
        [weakSelf.navigationController popViewControllerAnimated:YES];
    };
    
    
}
#pragma mark - 重写父类-点击方法集合
- (void)buttonClick:(UIButton *)btn{

    //转账!
    if (btn.tag == BTN_TAG_TRANSFER) {
        
        
    }
    
}


#pragma mark  - UI绘制
- (void)create_HeadView{
  
    
    headView = [[UIView alloc] init];
    headView.backgroundColor = COLOR_FFFFFF;
    [self.baseScrollView addSubview:headView];
    
    //iconImgView
    UIImage *iconimg = [UIImage imageNamed:@"transfer_headIcon"];
    UIImageView *headIconImgeView = [Tool createImagView:iconimg];
    [self.baseScrollView addSubview:headIconImgeView];
    
    //accountNoLab
    UILabel *accountNoLab = [Tool createLable:@"杉德宝账号:138******88" attributeStr:nil font:FONT_14_Regular textColor:COLOR_343339 alignment:NSTextAlignmentCenter];
    [self.baseScrollView addSubview:accountNoLab];
    
    //realNameLab
    UILabel *realNameLab = [Tool createLable:@"真实姓名:Flora" attributeStr:nil font:FONT_12_Regular textColor:COLOR_343339_5 alignment:NSTextAlignmentCenter];
    [self.baseScrollView addSubview:realNameLab];
    
    headView.height = UPDOWNSPACE_20 + iconimg.size.height + UPDOWNSPACE_11 + accountNoLab.height + UPDOWNSPACE_10 + realNameLab.height + UPDOWNSPACE_20;
    
    [headView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.baseScrollView.mas_top).offset(UPDOWNSPACE_10);
        make.centerX.equalTo(self.baseScrollView.mas_centerX);
        make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH, headView.height));
    }];
    
    
    [headIconImgeView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(headView.mas_top).offset(UPDOWNSPACE_20);
        make.centerX.equalTo(headView.mas_centerX);
        make.size.mas_equalTo(iconimg.size);
    }];
    
    [accountNoLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(headIconImgeView.mas_bottom).offset(UPDOWNSPACE_11);
        make.centerX.equalTo(headView.mas_centerX);
        make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH, accountNoLab.height));
    }];
    
    [realNameLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(accountNoLab.mas_bottom).offset(UPDOWNSPACE_10);
        make.centerX.equalTo(headView.mas_centerX);
        make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH, realNameLab.height));
    }];


}

- (void)create_BodyView{
    
    //tipLab
    UILabel *limitTipLab = [Tool createLable:@"该账户最多可转账999.00元" attributeStr:nil font:FONT_11_Regular textColor:COLOR_343339_5     alignment:NSTextAlignmentLeft];
    [self.baseScrollView addSubview:limitTipLab];
    
    [limitTipLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(headView.mas_bottom).offset(UPDOWNSPACE_15);
        make.left.equalTo(self.baseScrollView.mas_left).offset(LEFTRIGHTSPACE_35);
        make.size.mas_equalTo(limitTipLab.size);
    }];
    
    
    //bodyView
    bodyView = [[UIView alloc] init];
    bodyView.backgroundColor = COLOR_FFFFFF;
    [self.baseScrollView addSubview:bodyView];
    
    
    //tansferLab
    UILabel *tansferLab = [Tool createLable:@"转账金额" attributeStr:nil font:FONT_13_Regular textColor:COLOR_343339 alignment:NSTextAlignmentLeft];
    [bodyView addSubview:tansferLab];
    
    //rmbLab
    UILabel *rmbLab = [Tool createLable:@"¥" attributeStr:nil font:FONT_24_Medium textColor:COLOR_343339 alignment:NSTextAlignmentLeft];
    [bodyView addSubview:rmbLab];
    
    //moneyTextfield
    moneyTextfield = [Tool createTextField:@"0.00" font:FONT_36_SFUIT_Rrgular textColor:COLOR_343339_5];
    moneyTextfield.keyboardType = UIKeyboardTypeNumberPad;
    moneyTextfield.clearButtonMode = UITextFieldViewModeWhileEditing;
    moneyTextfield.height += UPDOWNSPACE_30*2;
    moneyTextfield.width = SCREEN_WIDTH - LEFTRIGHTSPACE_55;
    moneyTextfield.delegate = self;
    [bodyView addSubview:moneyTextfield];
    
    
    //transferBtn
    UIButton *transferBtn = [Tool createBarButton:@"确认并转账" font:FONT_15_Regular titleColor:COLOR_FFFFFF backGroundColor:COLOR_58A5F6 leftSpace:LEFTRIGHTSPACE_40];
    transferBtn.tag = BTN_TAG_TRANSFER;
    [transferBtn addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.baseScrollView addSubview:transferBtn];
    
    

    CGFloat bodyViewH = UPDOWNSPACE_20 + tansferLab.height + moneyTextfield.height;
    
    
    [bodyView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(limitTipLab.mas_bottom).offset(UPDOWNSPACE_15);
        make.centerX.equalTo(self.baseScrollView);
        make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH, bodyViewH));
    }];
    
    [tansferLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(bodyView.mas_top).offset(UPDOWNSPACE_20);
        make.left.equalTo(bodyView.mas_left).offset(LEFTRIGHTSPACE_35);
        make.size.mas_equalTo(tansferLab.size);
    }];
    
    [moneyTextfield mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(tansferLab.mas_bottom).offset(UPDOWNSPACE_0);
        make.left.equalTo(bodyView.mas_left).offset(LEFTRIGHTSPACE_55);
        make.size.mas_equalTo(CGSizeMake(moneyTextfield.width, moneyTextfield.height));
    }];
    
    [rmbLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(moneyTextfield.mas_centerY);
        make.left.equalTo(bodyView.mas_left).offset(LEFTRIGHTSPACE_35);
        make.size.mas_equalTo(rmbLab.size);
    }];
    
    [transferBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(bodyView.mas_bottom).offset(UPDOWNSPACE_112);
        make.centerX.equalTo(self.baseScrollView.mas_centerX);
        make.size.mas_equalTo(transferBtn.size);
    }];
   
    
}

- (void)create_bottomView{
    
    //bottomView
    bottomView = [[UIView alloc] init];
    bottomView.backgroundColor = COLOR_FFFFFF;
    [self.baseScrollView addSubview:bottomView];
    
    //line
    UIView *line = [[UIView alloc] init];
    line.backgroundColor = COLOR_A1A2A5_3;
    line.size = CGSizeMake(SCREEN_WIDTH - 2*LEFTRIGHTSPACE_20, 1);
    [bottomView addSubview:line];
    
    //bottomTipLab
    UILabel *bottomTipLab = [Tool createLable:@"金额已超过可转账余额" attributeStr:nil font:FONT_12_Regular textColor:COLOR_FF5D31 alignment:NSTextAlignmentLeft];
    [bottomView addSubview:bottomTipLab];
    
    
    bottomView.height = bottomTipLab.height + UPDOWNSPACE_25*2;
    
    [bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(bodyView.mas_bottom);
        make.centerX.equalTo(self.baseScrollView.mas_centerX);
        make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH, bottomView.height));
    }];
    
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(bottomView.mas_top);
        make.left.equalTo(bodyView.mas_left).offset(LEFTRIGHTSPACE_20);
        make.size.mas_equalTo(line.size);
    }];
    
    
    [bottomTipLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(line.mas_bottom).offset(UPDOWNSPACE_25);
        make.left.equalTo(bodyView.mas_left).offset(LEFTRIGHTSPACE_35);
        make.size.mas_equalTo(bottomTipLab.size);
    }];
    
    
    
}


#pragma mark textfielDelegate
- (void)textFieldDidEndEditing:(UITextField *)textField{
    
    if ([textField.text floatValue]< 999.00) {
        if (bottomView.subviews.count > 0) {
            [bottomView removeFromSuperview];
        }
    }
    if ([moneyTextfield.text floatValue] > 999) {
        [self create_bottomView];
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
