//
//  SetViewController.m
//  sandbao
//
//  Created by tianNanYiHao on 2017/10/27.
//  Copyright © 2017年 sand. All rights reserved.
//

#import "SetViewController.h"
#import "SetCellView.h"

#import "AboutUSViewController.h"

@interface SetViewController ()

@end

@implementation SetViewController

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];

    
    //允许RESideMenu的返回手势
    self.sideMenuViewController.panGestureEnabled = YES;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self creaetUI];
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
    self.navCoverView.midTitleStr = @"设置";
  
    __block SetViewController *weakSelf = self;
    self.navCoverView.leftBlock = ^{
        [weakSelf presentLeftMenuViewController:weakSelf.sideMenuViewController];
    };
    
}
#pragma mark - 重写父类-点击方法集合
- (void)buttonClick:(UIButton *)btn{
    
    if (btn.tag == BTN_TAG_CHANGPAYPWD) {
        NSLog(@"修改支付密码");
    }
    if (btn.tag == BTN_TAG_CHANGLOGPWD) {
        NSLog(@"修改登录密码");
    }
    if (btn.tag == BTN_TAG_FEEDBACK) {
        NSLog(@"意见反馈");
    }
    if (btn.tag == BTN_TAG_ABOUTUS) {
        NSLog(@"关于");
        
        AboutUSViewController *aboutUsVC = [[AboutUSViewController alloc] init];
        [self.navigationController pushViewController:aboutUsVC animated:YES];
        
    }
    
}


#pragma mark  - UI绘制
- (void)creaetUI{
    
    __block SetViewController *weakSelf = self;
    
    //changePayPwdCell
    SetCellView *changePayPwdCell = [SetCellView createSetCellViewOY:0];
    changePayPwdCell.titleStr = @"修改支付密码";
    changePayPwdCell.clickBlock = ^{
        UIButton *btn = [UIButton new];
        btn.tag = BTN_TAG_CHANGPAYPWD;
        [weakSelf performSelector:@selector(buttonClick:) withObject:btn];
    };
    [self.baseScrollView addSubview:changePayPwdCell];
    
    //changeLogPwdCell
    SetCellView *changeLogPwdCell = [SetCellView createSetCellViewOY:0];
    changeLogPwdCell.titleStr = @"修改登录密码";
    changeLogPwdCell.line.hidden = YES;
    changeLogPwdCell.clickBlock = ^{
        UIButton *btn = [UIButton new];
        btn.tag = BTN_TAG_CHANGLOGPWD;
        [weakSelf performSelector:@selector(buttonClick:) withObject:btn];
    };
    [self.baseScrollView addSubview:changeLogPwdCell];
    
    
    //feedBackCell
    SetCellView *feedBackCell = [SetCellView createSetCellViewOY:0];
    feedBackCell.titleStr = @"意见反馈";
    feedBackCell.clickBlock = ^{
        UIButton *btn = [UIButton new];
        btn.tag = BTN_TAG_FEEDBACK;
        [weakSelf performSelector:@selector(buttonClick:) withObject:btn];
    };
    [self.baseScrollView addSubview:feedBackCell];
    
    //aboutCell
    SetCellView *aboutCell = [SetCellView createSetCellViewOY:0];
    aboutCell.titleStr = @"关于";
    aboutCell.line.hidden = YES;
    aboutCell.clickBlock = ^{
        UIButton *btn = [UIButton new];
        btn.tag = BTN_TAG_ABOUTUS;
        [weakSelf performSelector:@selector(buttonClick:) withObject:btn];
    };
    [self.baseScrollView addSubview:aboutCell];
    
    
    [changePayPwdCell mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.baseScrollView.mas_top).offset(UPDOWNSPACE_10);
        make.centerX.equalTo(self.baseScrollView.mas_centerX);
        make.size.mas_equalTo(changePayPwdCell.size);
    }];
    
    [changeLogPwdCell mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(changePayPwdCell.mas_bottom).offset(UPDOWNSPACE_0);
        make.centerX.equalTo(self.baseScrollView.mas_centerX);
        make.size.mas_equalTo(changeLogPwdCell.size);
    }];
    
    [feedBackCell mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(changeLogPwdCell.mas_bottom).offset(UPDOWNSPACE_20);
        make.centerX.equalTo(self.baseScrollView.mas_centerX);
        make.size.mas_equalTo(feedBackCell.size);
    }];
    
    [aboutCell mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(feedBackCell.mas_bottom).offset(UPDOWNSPACE_0);
        make.centerX.equalTo(self.baseScrollView.mas_centerX);
        make.size.mas_equalTo(aboutCell.size);
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
