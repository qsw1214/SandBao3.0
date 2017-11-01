//
//  UserHongbaoViewController.m
//  sandbao
//
//  Created by tianNanYiHao on 2017/11/1.
//  Copyright © 2017年 sand. All rights reserved.
//

#import "UserHongbaoViewController.h"

@interface UserHongbaoViewController ()<UITextFieldDelegate>
{
    UIView *headView;
    UIView *bodyView;
}
@end

@implementation UserHongbaoViewController

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
    self.navCoverView.midTitleStr = @"发红包";
    self.navCoverView.letfImgStr = @"general_icon_back";
    
    __block UserHongbaoViewController *weakSelf = self;
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
    
    headView.height = UPDOWNSPACE_20 + iconimg.size.height + UPDOWNSPACE_11 + accountNoLab.height + UPDOWNSPACE_10 + realNameLab.height + UPDOWNSPACE_58;
    
    [headView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.baseScrollView.mas_top).offset(UPDOWNSPACE_01);
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
    
    //bodyView
    bodyView = [[UIView alloc] init];
    bodyView.backgroundColor = COLOR_FFFFFF;
    [self.baseScrollView addSubview:bodyView];
    
    
    //moneyTextfield
    UITextField *moneyTextfield = [Tool createTextField:@"0.00" font:FONT_14_SFUIT_Rrgular textColor:COLOR_343339];
    moneyTextfield.layer.borderColor = COLOR_358BEF.CGColor;
    moneyTextfield.layer.borderWidth = 1.f;
    moneyTextfield.layer.cornerRadius = 5.f;
    moneyTextfield.layer.masksToBounds = YES;
    moneyTextfield.keyboardType = UIKeyboardTypeNumberPad;
    moneyTextfield.clearButtonMode = UITextFieldViewModeWhileEditing;
    moneyTextfield.delegate = self;
    //设置左边视图的宽度(占位)
    moneyTextfield.leftView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, LEFTRIGHTSPACE_20, 0)];
    //设置显示模式为永远显示(默认不显示 必须设置 否则没有效果)
    moneyTextfield.leftViewMode = UITextFieldViewModeAlways;
    [bodyView addSubview:moneyTextfield];

    //transferBtn
    UIButton *transferBtn = [Tool createButton:@"→" attributeStr:nil font:FONT_36_SFUIT_Rrgular textColor:COLOR_FFFFFF];
    transferBtn.tag = BTN_TAG_TRANSFER;
    transferBtn.backgroundColor = COLOR_358BEF;
    transferBtn.layer.cornerRadius = 5.f;
    transferBtn.layer.masksToBounds = YES;
    [transferBtn addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    [bodyView addSubview:transferBtn];

    //limitTipLab
    UILabel *limitTipLab = [Tool createLable:@"最高可发200.00元红包" attributeStr:nil font:FONT_12_Regular textColor:COLOR_343339_5 alignment:NSTextAlignmentLeft];
    [bodyView addSubview:limitTipLab];
    
    
    
    moneyTextfield.height += UPDOWNSPACE_16*2;
    
    transferBtn.height = moneyTextfield.height;
    
    moneyTextfield.width = SCREEN_WIDTH - LEFTRIGHTSPACE_35*2 - transferBtn.height - LEFTRIGHTSPACE_09;
    
    transferBtn.width = moneyTextfield.height;
    
    bodyView.height = moneyTextfield.height + UPDOWNSPACE_16 + limitTipLab.height;
    
    
    
    
    [bodyView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(headView.mas_bottom);
        make.centerX.equalTo(self.baseScrollView.mas_centerX);
        make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH, bodyView.height));
    }];
    
    [moneyTextfield mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(bodyView.mas_top);
        make.left.equalTo(bodyView.mas_left).offset(LEFTRIGHTSPACE_35);
        make.size.mas_equalTo(CGSizeMake(moneyTextfield.width, moneyTextfield.height));
    }];
    
    [transferBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(moneyTextfield.mas_top);
        make.right.mas_equalTo(bodyView.mas_right).offset(-LEFTRIGHTSPACE_35);
        make.size.mas_equalTo(CGSizeMake(transferBtn.width, transferBtn.height));
    }];
    
    [limitTipLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(moneyTextfield.mas_bottom).offset(UPDOWNSPACE_16);
        make.left.equalTo(bodyView.mas_left).offset(LEFTRIGHTSPACE_35);
        make.size.mas_equalTo(limitTipLab.size);
    }];
    
}



#pragma mark textfielDelegate
- (void)textFieldDidEndEditing:(UITextField *)textField{
    
    
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
