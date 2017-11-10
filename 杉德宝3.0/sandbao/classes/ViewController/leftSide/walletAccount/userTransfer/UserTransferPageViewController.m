//
//  UserTransferPageViewController.m
//  sandbao
//
//  Created by tianNanYiHao on 2017/10/30.
//  Copyright © 2017年 sand. All rights reserved.
//

#import "UserTransferPageViewController.h"
#import "UserTransferViewController.h"
#import "UserHongbaoViewController.h"
@interface UserTransferPageViewController ()
{
    UIView *headView;
    UIButton *transferBtn;
    UIButton *hongbaoBtn;
}
@end

@implementation UserTransferPageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self create_HeadView];
    
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
    self.navCoverView.midTitleStr = @"个人主页";
    self.navCoverView.letfImgStr = @"general_icon_back";
    
    __block UserTransferPageViewController *weakSelf = self;
    self.navCoverView.leftBlock = ^{
        [weakSelf.navigationController popViewControllerAnimated:YES];
    };
    
    
}
#pragma mark - 重写父类-点击方法集合
- (void)buttonClick:(UIButton *)btn{
    if (btn.tag == BTN_TAG_TRANSFER) {
        //转账选中
        transferBtn.selected = YES;
        transferBtn.backgroundColor = COLOR_358BEF;
        //红包反选
        hongbaoBtn.selected = NO;
        hongbaoBtn.backgroundColor = COLOR_FFFFFF;
        
        //跳转去转账
        UserTransferViewController *userTransferVC = [[UserTransferViewController alloc] init];
        [self.navigationController pushViewController:userTransferVC animated:YES];
        
    }
    
    if (btn.tag == BTN_TAG_HONGBAO) {
        //红包选中
        hongbaoBtn.selected = YES;
        hongbaoBtn.backgroundColor = COLOR_358BEF;
        //转账反宣
        transferBtn.selected = NO;
        transferBtn.backgroundColor = COLOR_FFFFFF;
        
        //跳转去红包
        UserHongbaoViewController *userHongbaoVC = [[UserHongbaoViewController alloc] init];
        [self.navigationController pushViewController:userHongbaoVC animated:YES];
        
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
    
    //transferBtn
    transferBtn = [Tool createButton:@"转账" attributeStr:nil font:FONT_14_Regular textColor:COLOR_358BEF];
    [transferBtn setTitleColor:COLOR_FFFFFF forState:UIControlStateSelected];
    transferBtn.tag = BTN_TAG_TRANSFER;
    transferBtn.layer.cornerRadius = transferBtn.height/2;
    transferBtn.layer.masksToBounds = YES;
    transferBtn.width = LEFTRIGHTSPACE_120;
    transferBtn.backgroundColor = COLOR_FFFFFF;
    transferBtn.layer.borderColor = COLOR_358BEF.CGColor;
    transferBtn.layer.borderWidth = 1.f;
    [transferBtn addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.baseScrollView addSubview:transferBtn];
    
    //hongbaoBtn
    hongbaoBtn = [Tool createButton:@"发红包" attributeStr:nil font:FONT_14_Regular textColor:COLOR_358BEF];
    [hongbaoBtn setTitleColor:COLOR_FFFFFF forState:UIControlStateSelected];
    hongbaoBtn.tag = BTN_TAG_HONGBAO;
    hongbaoBtn.layer.cornerRadius = hongbaoBtn.height/2;
    hongbaoBtn.layer.masksToBounds = YES;
    hongbaoBtn.width = LEFTRIGHTSPACE_120;
    hongbaoBtn.backgroundColor = COLOR_FFFFFF;
    hongbaoBtn.layer.borderColor = COLOR_358BEF.CGColor;
    hongbaoBtn.layer.borderWidth = 1.f;
    [hongbaoBtn addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.baseScrollView addSubview:hongbaoBtn];
    
    
    headView.height = UPDOWNSPACE_20 + iconimg.size.height + UPDOWNSPACE_14 + accountNoLab.height + UPDOWNSPACE_10 + realNameLab.height + UPDOWNSPACE_25 + transferBtn.height + UPDOWNSPACE_40;
    CGFloat transferBtnleftSpace = (SCREEN_WIDTH - LEFTRIGHTSPACE_120*2 - LEFTRIGHTSPACE_20)/2;
    
    
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
        make.top.equalTo(headIconImgeView.mas_bottom).offset(UPDOWNSPACE_14);
        make.centerX.equalTo(headView.mas_centerX);
        make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH, accountNoLab.height));
    }];
    
    [realNameLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(accountNoLab.mas_bottom).offset(UPDOWNSPACE_10);
        make.centerX.equalTo(headView.mas_centerX);
        make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH, realNameLab.height));
    }];
    
    [transferBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(realNameLab.mas_bottom).offset(UPDOWNSPACE_25);
        make.left.equalTo(headView.mas_left).offset(transferBtnleftSpace);
        make.size.mas_equalTo(CGSizeMake(transferBtn.width, transferBtn.height));
    }];
    
    [hongbaoBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(realNameLab.mas_bottom).offset(UPDOWNSPACE_25);
        make.left.equalTo(transferBtn.mas_right).offset(LEFTRIGHTSPACE_20);
        make.size.mas_equalTo(CGSizeMake(hongbaoBtn.width, hongbaoBtn.height));
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
