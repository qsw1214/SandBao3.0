//
//  MyCenterViewController.m
//  sandbao
//
//  Created by tianNanYiHao on 2017/11/2.
//  Copyright © 2017年 sand. All rights reserved.
//

#import "MyCenterViewController.h"

#import "MyCenterCellView.h"

@interface MyCenterViewController ()

@end

@implementation MyCenterViewController

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    //允许RESideMenu的返回手势
    self.sideMenuViewController.panGestureEnabled = YES;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
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
    self.navCoverView.letfImgStr = @"login_icon_back";
    self.navCoverView.midTitleStr = @"个人信息";
    
    __block MyCenterViewController *weakSelf = self;
    self.navCoverView.leftBlock = ^{
        [weakSelf presentLeftMenuViewController:weakSelf.sideMenuViewController];
    };
    
    
}

#pragma mark - 重写父类-点击方法集合
- (void)buttonClick:(UIButton *)btn{
    
    
}


#pragma mark  - UI绘制
- (void)createUI{
    
    MyCenterCellView *headCell = [MyCenterCellView createSetCellViewOY:0];
    headCell.cellType = myCenterCellType_Head;
    [self.baseScrollView addSubview:headCell];
    
    MyCenterCellView *identityCell = [MyCenterCellView createSetCellViewOY:0];
    identityCell.cellType = myCenterCellType_Identity;
    [self.baseScrollView addSubview:identityCell];
    
    MyCenterCellView *accountCell = [MyCenterCellView createSetCellViewOY:0];
    accountCell.cellType = myCenterCellType_Account;
    [self.baseScrollView addSubview:accountCell];
    
    
    MyCenterCellView *erCodeCell = [MyCenterCellView createSetCellViewOY:0];
    erCodeCell.cellType = myCenterCellType_ErCode;
    [self.baseScrollView addSubview:erCodeCell];
    
    MyCenterCellView *nameHeadCell = [MyCenterCellView createSetCellViewOY:0];
    nameHeadCell.cellType = myCenterCellType_NameHead;
    nameHeadCell.line.hidden = YES;
    [self.baseScrollView addSubview:nameHeadCell];
    
    
    [headCell mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.baseScrollView.mas_top).offset(UPDOWNSPACE_10);
        make.centerX.equalTo(self.baseScrollView);
        make.size.mas_equalTo(headCell.size);
    }];
    
    [identityCell mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(headCell.mas_bottom).offset(UPDOWNSPACE_0);
        make.centerX.equalTo(self.baseScrollView);
        make.size.mas_equalTo(identityCell.size);
    }];
    
    [accountCell mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(identityCell.mas_bottom).offset(UPDOWNSPACE_0);
        make.centerX.equalTo(self.baseScrollView);
        make.size.mas_equalTo(accountCell.size);
    }];
    
    [erCodeCell mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(accountCell.mas_bottom).offset(UPDOWNSPACE_0);
        make.centerX.equalTo(self.baseScrollView);
        make.size.mas_equalTo(erCodeCell.size);
    }];
    
    [nameHeadCell mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(erCodeCell.mas_bottom).offset(UPDOWNSPACE_0);
        make.centerX.equalTo(self.baseScrollView);
        make.size.mas_equalTo(nameHeadCell.size);
    }];
    
    
    
}


#pragma mark - 业务逻辑










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
