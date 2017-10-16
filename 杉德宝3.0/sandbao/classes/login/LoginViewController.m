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
    
    //frame
    
    CGFloat sizeToNav = 68.f;
    CGSize titleLabSize = [titleLab sizeThatFits:CGSizeZero];
    CGSize titleDesLabSize = [titleDesLab sizeThatFits:CGSizeZero];

    CGFloat titleDesLabOY = sizeToNav + titleLabSize.height + UPDOWNSPACE_15;
    CGFloat phoneAuthToolViewOY = titleDesLabOY + titleDesLabSize.height + UPDOWNSPACE_58;
    CGFloat pwdAuthToolViewOY = phoneAuthToolViewOY + phoneAuthToolView.height +  UPDOWNSPACE_30;
    
    titleLab.frame = CGRectMake(LEFTRIGHTSPACE_35, sizeToNav, titleLabSize.width, titleLabSize.height);
    titleDesLab.frame = CGRectMake(LEFTRIGHTSPACE_35, titleDesLabOY, titleDesLabSize.width, titleDesLabSize.height);
    phoneAuthToolView.y = phoneAuthToolViewOY;
    pwdAuthToolView.y = pwdAuthToolViewOY;
    
    
    
    
    
}






















- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
