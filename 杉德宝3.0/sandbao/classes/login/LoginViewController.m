//
//  LoginViewController.m
//  sandbao
//
//  Created by tianNanYiHao on 2017/10/13.
//  Copyright © 2017年 sand. All rights reserved.
//

#import "LoginViewController.h"


@interface LoginViewController ()

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationController.navigationBar.hidden = YES;
    [self createUI];
    
    
}

- (void)createUI{
    
    //titleLab1
    UILabel *titleLab = [Tool createLable:@"欢迎回来" attributeStr:nil font:FONT_28 textColor:COLOR_343339 alignment:NSTextAlignmentLeft];
    [self.baseScrollView addSubview:titleLab];
    
    
    //titleLab2
    UILabel *titleDesLab = [Tool createLable:@"继续登录" attributeStr:nil font:FONT_16 textColor:COLOR_343339_7 alignment:NSTextAlignmentLeft];
    [self.baseScrollView addSubview:titleDesLab];
    
    //PhoneAuthToolView
    PhoneAuthToolView *phoneAuthToolView = [PhoneAuthToolView createAuthToolViewOY:0];
    __block PhoneAuthToolView *phoneATV = phoneAuthToolView;
    phoneAuthToolView.errorBlock = ^{
        [phoneATV showTip];
    };
    [self.baseScrollView addSubview:phoneAuthToolView];
    
    //PwdAuthToolView
    PwdAuthToolView *pwdAuthToolView = [PwdAuthToolView createAuthToolViewOY:0];
    [self.baseScrollView addSubview:pwdAuthToolView];
    
    //forgetPwd
    UIButton *forgetBtn = [Tool createButton:@"忘记密码?" attributeStr:nil font:FONT_14 textColor:COLOR_343339];
    [self.baseScrollView addSubview:forgetBtn];
    
    //logintBtn
    SDBarBtnView *loginBarbtn = [[SDBarBtnView alloc] init];
    loginBarbtn.title = @"登录";
    loginBarbtn.titleColor = COLOR_FFFFFF;
    loginBarbtn.btnColor = COLOR_58A5F6;
    [self.baseScrollView addSubview:loginBarbtn];
    
    
    
    
    
    //frame
    
    CGFloat sizeToNav = 68.f;
    CGSize titleLabSize = [titleLab sizeThatFits:CGSizeZero];
    CGSize titleDesLabSize = [titleDesLab sizeThatFits:CGSizeZero];
    CGSize forgetBtnSize = [forgetBtn systemLayoutSizeFittingSize:CGSizeZero];
    CGFloat loginBarbtnW = SCREEN_SIZE.width - LEFTRIGHTSPACE_40*2;

    
    [titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.baseScrollView.mas_left).offset(LEFTRIGHTSPACE_35);
        make.top.equalTo(self.baseScrollView.mas_top).offset(0);
        make.size.mas_equalTo(titleLabSize);
    }];
    
    [titleDesLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(titleLab.mas_bottom).offset(UPDOWNSPACE_15);
        make.left.equalTo(titleLab);
        make.size.mas_equalTo(titleDesLabSize);
    }];
    
    [phoneAuthToolView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.baseScrollView);
        make.top.equalTo(titleDesLab.mas_bottom).offset(UPDOWNSPACE_58);
        make.size.mas_equalTo(phoneAuthToolView.size);
    }];
    
    [pwdAuthToolView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.baseScrollView);
        make.top.equalTo(phoneAuthToolView.mas_bottom).offset(UPDOWNSPACE_30);
        make.size.mas_equalTo(pwdAuthToolView.size);
    }];
    
    [forgetBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(pwdAuthToolView.mas_bottom).offset(UPDOWNSPACE_25);
        make.right.equalTo(pwdAuthToolView.mas_right).offset(-LEFTRIGHTSPACE_40);
        make.size.mas_equalTo(forgetBtnSize);
    }];
    
    [loginBarbtn mas_makeConstraints:^(MASConstraintMaker *make) {
        
    }];
    
    
}






















- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
