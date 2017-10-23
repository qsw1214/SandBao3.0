//
//  LogpwdViewController.m
//  sandbao
//
//  Created by tianNanYiHao on 2017/10/19.
//  Copyright © 2017年 sand. All rights reserved.
//

#import "LogpwdViewController.h"
#import "RealNameViewController.h"

@interface LogpwdViewController ()

@end

@implementation LogpwdViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
     [self createUI];
}
#pragma - mark 重写父类-baseScrollView设置
- (void)setBaseScrollview{
    [super setBaseScrollview];
    
}
#pragma - mark 重写父类-导航设置方法
- (void)setNavCoverView{
    [super setNavCoverView];
    
    self.navCoverView.rightImgStr = nil;
    self.navCoverView.midTitleStr = nil;
    __block UIViewController *weakself = self;
    self.navCoverView.leftBlock = ^{
        [weakself.navigationController popViewControllerAnimated:YES];
    };
}
#pragma - mark 重写父类-点击方法集合
- (void)buttonClick:(UIButton *)btn{
    
    if (btn.tag == BTN_TAG_NEXT) {
        RealNameViewController *realNameVC = [[RealNameViewController alloc] init];
        [self.navigationController pushViewController:realNameVC animated:YES];
        
    }
    
}
#pragma - mark  UI绘制
- (void)createUI{

    //titleLab1
    UILabel *titleLab = [Tool createLable:@"设置登录密码" attributeStr:nil font:FONT_28_Medium textColor:COLOR_343339 alignment:NSTextAlignmentCenter];
    [self.baseScrollView addSubview:titleLab];

    //titleLab2
    UILabel *titleDesLab = [Tool createLable:@"设置的密码至少包含8-20位字母加数字" attributeStr:nil font:FONT_16_Regular textColor:COLOR_343339_7 alignment:NSTextAlignmentCenter];
    [self.baseScrollView addSubview:titleDesLab];
    
    //pwdAuthToolView
    PwdAuthToolView *pwdAuthToolView = [PwdAuthToolView createAuthToolViewOY:0];
    pwdAuthToolView.titleLab.text = @"登陆密码";
    pwdAuthToolView.tip.text = @"密码必须包含8-20位的字母数字组合";
    __block PwdAuthToolView *selfPwdauthTooView = pwdAuthToolView;
    pwdAuthToolView.errorBlock = ^{
        [selfPwdauthTooView showTip];
    };
    [self.baseScrollView addSubview:pwdAuthToolView];
    
    //newtBtn
    //nextBtn
    UIButton *nextBarbtn = [Tool createBarButton:@"继续" font:FONT_15_Regular titleColor:COLOR_FFFFFF backGroundColor:COLOR_58A5F6 leftSpace:LEFTRIGHTSPACE_40];
    nextBarbtn.tag = BTN_TAG_NEXT;
    [nextBarbtn addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.baseScrollView addSubview:nextBarbtn];
    
    
    [titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.baseScrollView.mas_top).offset(UPDOWNSPACE_64);
        make.centerX.equalTo(self.baseScrollView.mas_centerX);
        make.size.mas_equalTo(titleLab.size);
    }];
    
    [titleDesLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(titleLab.mas_bottom).offset(UPDOWNSPACE_14);
        make.centerX.equalTo(self.baseScrollView.mas_centerX);
        make.size.mas_equalTo(titleDesLab.size);
    }];
    
    [pwdAuthToolView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(titleDesLab.mas_bottom).offset(UPDOWNSPACE_58);
        make.centerX.equalTo(self.baseScrollView.mas_centerX);
        make.size.mas_equalTo(pwdAuthToolView.size);
    }];
    
    [nextBarbtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(pwdAuthToolView.mas_bottom).offset(UPDOWNSPACE_69);
        make.centerX.equalTo(self.baseScrollView.mas_centerX);
        make.size.mas_equalTo(nextBarbtn.size);
    }];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
