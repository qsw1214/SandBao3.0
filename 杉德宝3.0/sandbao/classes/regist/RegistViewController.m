//
//  RegistViewController.m
//  sandbao
//
//  Created by tianNanYiHao on 2017/10/17.
//  Copyright © 2017年 sand. All rights reserved.
//

#import "RegistViewController.h"

@interface RegistViewController ()

@end

@implementation RegistViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    
    [self createUI];
    
}

#pragma - mark  UI绘制
- (void)createUI{
    
    //titleLab1
    UILabel *titleLab = [Tool createLable:@"输入你的手机号" attributeStr:nil font:FONT_28_Medium textColor:COLOR_343339 alignment:NSTextAlignmentLeft];
    [self.baseScrollView addSubview:titleLab];
    
    
    
    //PhoneAuthToolView
    PhoneAuthToolView *phoneAuthToolView = [PhoneAuthToolView createAuthToolViewOY:0];
    phoneAuthToolView.titleLab.text = @"你的手机号";
    phoneAuthToolView.textfiled.placeholder = @"输入手机号";
    __block PhoneAuthToolView *phoneATV = phoneAuthToolView;
    phoneAuthToolView.errorBlock = ^{
        [phoneATV showTip];
    };
    [self.baseScrollView addSubview:phoneAuthToolView];
    
    //PwdAuthToolView
    PwdAuthToolView *pwdAuthToolView = [PwdAuthToolView createAuthToolViewOY:0];
    [self.baseScrollView addSubview:pwdAuthToolView];
    
    //forgetPwd
    UIButton *forgetBtn = [Tool createButton:@"忘记密码?" attributeStr:nil font:FONT_14_Regular textColor:COLOR_343339_7];
    forgetBtn.tag = 101;
    [forgetBtn addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.baseScrollView addSubview:forgetBtn];
    
    //logintBtn
    UIButton *loginBarbtn = [Tool createBarButton:@"登录" font:FONT_15_Regular titleColor:COLOR_FFFFFF backGroundColor:COLOR_58A5F6 leftSpace:LEFTRIGHTSPACE_40];
    loginBarbtn.tag = 102;
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
    registbtn.tag = 103;
    [self.baseScrollView addSubview:registbtn];
    
    
    //frame
    [titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.baseScrollView.mas_left).offset(LEFTRIGHTSPACE_35);
        make.top.equalTo(self.baseScrollView.mas_top).offset(UPDOWNSPACE_64);
        make.size.mas_equalTo(titleLab.size);
    }];
    
    
    [phoneAuthToolView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.baseScrollView);
        make.top.equalTo(titleLab.mas_bottom).offset(UPDOWNSPACE_58);
        make.size.mas_equalTo(phoneAuthToolView.size);
    }];
    
    [pwdAuthToolView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(phoneAuthToolView.mas_bottom).offset(UPDOWNSPACE_30);
        make.left.equalTo(self.baseScrollView);
        make.size.mas_equalTo(pwdAuthToolView.size);
    }];
    
    [forgetBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(pwdAuthToolView.mas_bottom).offset(UPDOWNSPACE_25);
        make.right.equalTo(pwdAuthToolView.mas_right).offset(-LEFTRIGHTSPACE_40);
        make.size.mas_equalTo(forgetBtn.size);
    }];
    
    [loginBarbtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(forgetBtn.mas_bottom).offset(UPDOWNSPACE_28);
        make.left.equalTo(self.baseScrollView.mas_left).offset(LEFTRIGHTSPACE_40);
        make.size.mas_equalTo(loginBarbtn.size);
    }];
    
    [registbtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(loginBarbtn.mas_bottom).offset(UPDOWNSPACE_47);
        make.centerX.equalTo(self.baseScrollView.mas_centerX);
        make.size.mas_equalTo(registbtn.size);
    }];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
