//
//  LoginViewController.m
//  sandbao
//
//  Created by tianNanYiHao on 2017/10/13.
//  Copyright © 2017年 sand. All rights reserved.
//

#import "LoginViewController.h"
#import "RegistViewController.h"

@interface LoginViewController ()

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //隐藏系统导航栏的navigationBar
    self.navigationController.navigationBar.hidden = YES;
    [self clearUserInfo];
    [self createUI];
    
    
}
#pragma - mark 重写父类-baseScrollView设置
- (void)setBaseScrollview{
    [super setBaseScrollview];
    self.baseScrollView.scrollEnabled = YES;
    self.baseScrollView.frame = CGRectMake(0, UPDOWNSPACE_20, SCREEN_WIDTH, SCREEN_HEIGHT-UPDOWNSPACE_20);
}

#pragma - mark 重写父类-导航设置方法
- (void)setNavCoverView{
    [super setNavCoverView];
    self.navCoverView.hidden = YES;
}
#pragma - mark 重写父类-点击方法集合
- (void)buttonClick:(UIButton *)btn{
    
    if (btn.tag == BTN_TAG_FORGETPWD) {
        NSLog(@"点击了忘记密码");
    }
    if (btn.tag == BTN_TAG_LOGIN) {
        NSLog(@"点击了登陆");
        [self dismissViewControllerAnimated:YES completion:nil];
        [CommParameter sharedInstance].userId = @"======";
    }
    if (btn.tag == BTN_TAG_REGIST) {
        NSLog(@"点击了注册");
        RegistViewController *regVc = [[RegistViewController alloc] init];
        [self.navigationController pushViewController:regVc animated:YES];
    }
    
}

#pragma - mark 登陆注册前,清除缓存中的用户信息
- (void)clearUserInfo{
    [CommParameter sharedInstance].userId = nil;
}

#pragma - mark  UI绘制
- (void)createUI{
    
    //titleLab1
    UILabel *titleLab = [Tool createLable:@"欢迎回来" attributeStr:nil font:FONT_28_Medium textColor:COLOR_343339 alignment:NSTextAlignmentLeft];
    [self.baseScrollView addSubview:titleLab];
    
    
    //titleLab2
    UILabel *titleDesLab = [Tool createLable:@"继续登录" attributeStr:nil font:FONT_16_Regular textColor:COLOR_343339_7 alignment:NSTextAlignmentLeft];
    [self.baseScrollView addSubview:titleDesLab];
    
    //PhoneAuthToolView
    PhoneAuthToolView *phoneAuthToolView = [PhoneAuthToolView createAuthToolViewOY:0];
    phoneAuthToolView.tip.text = @"请输入能登陆的手机号";
    __block PhoneAuthToolView *selfPhoneAuthToolView = phoneAuthToolView;
    phoneAuthToolView.errorBlock = ^{
        [selfPhoneAuthToolView showTip];
    };
    [self.baseScrollView addSubview:phoneAuthToolView];
    
    //PwdAuthToolView
    PwdAuthToolView *pwdAuthToolView = [PwdAuthToolView createAuthToolViewOY:0];
    pwdAuthToolView.tip.text = @"密码必须包含8-20位的字母数字组合";
    __block id selfpwdAuthToolView = pwdAuthToolView;
    pwdAuthToolView.errorBlock = ^{
        [selfpwdAuthToolView showTip];
    };
    [self.baseScrollView addSubview:pwdAuthToolView];
    
    //forgetPwd
    UIButton *forgetBtn = [Tool createButton:@"忘记密码?" attributeStr:nil font:FONT_14_Regular textColor:COLOR_343339_7];
    forgetBtn.tag = BTN_TAG_FORGETPWD;
    [forgetBtn addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.baseScrollView addSubview:forgetBtn];
    
    //logintBtn
    UIButton *loginBarbtn = [Tool createBarButton:@"登录" font:FONT_15_Regular titleColor:COLOR_FFFFFF backGroundColor:COLOR_58A5F6 leftSpace:LEFTRIGHTSPACE_40];
    loginBarbtn.tag = BTN_TAG_LOGIN;
    [loginBarbtn addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.baseScrollView addSubview:loginBarbtn];
    
    //registBtn
    NSMutableAttributedString *registAttributeStr = [[NSMutableAttributedString alloc] initWithString:@"新用户? 注册"];
    [registAttributeStr addAttributes:@{
                                        NSFontAttributeName:FONT_14_Regular,
                                        NSForegroundColorAttributeName:COLOR_358BEF
                                       } range:NSMakeRange(5, 2)];
    UIButton *registbtn = [Tool createButton:@"" attributeStr:registAttributeStr font:FONT_14_Regular textColor:COLOR_343339_7];
    [registbtn addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    registbtn.tag = BTN_TAG_REGIST;
    [self.baseScrollView addSubview:registbtn];
    
    
    //frame
    [titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.baseScrollView.mas_top).offset(UPDOWNSPACE_112);
        make.left.equalTo(self.baseScrollView.mas_left).offset(LEFTRIGHTSPACE_35);
        make.size.mas_equalTo(titleLab.size);
    }];
    
    [titleDesLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(titleLab.mas_bottom).offset(UPDOWNSPACE_15);
        make.left.equalTo(titleLab);
        make.size.mas_equalTo(titleDesLab.size);
    }];
    
    [phoneAuthToolView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(titleDesLab.mas_bottom).offset(UPDOWNSPACE_58);
        make.centerX.equalTo(self.baseScrollView.mas_centerX);
        make.size.mas_equalTo(phoneAuthToolView.size);
    }];
    
    [pwdAuthToolView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(phoneAuthToolView.mas_bottom).offset(UPDOWNSPACE_0);
        make.centerX.equalTo(self.baseScrollView.mas_centerX);
        make.size.mas_equalTo(pwdAuthToolView.size);
    }];
    
    [forgetBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(pwdAuthToolView.mas_bottom).offset(UPDOWNSPACE_25);
        make.right.equalTo(pwdAuthToolView.mas_right).offset(-LEFTRIGHTSPACE_40);
        make.size.mas_equalTo(forgetBtn.size);
    }];
    
    [loginBarbtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(forgetBtn.mas_bottom).offset(UPDOWNSPACE_28);
        make.centerX.equalTo(self.baseScrollView.mas_centerX);
        make.size.mas_equalTo(loginBarbtn.size);
    }];
    
    [registbtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(loginBarbtn.mas_bottom).offset(UPDOWNSPACE_28);
        make.centerX.equalTo(self.baseScrollView.mas_centerX);
        make.size.mas_equalTo(registbtn.size);
    }];
    
}













- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
