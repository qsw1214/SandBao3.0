//
//  RegistViewController.m
//  sandbao
//
//  Created by tianNanYiHao on 2017/10/17.
//  Copyright © 2017年 sand. All rights reserved.
//

#import "RegistViewController.h"
#import "SmsCodeViewController.h"
@interface RegistViewController ()

@end

@implementation RegistViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    

    
    [self createUI];
    
}
#pragma - mark 重写父类-baseScrollView设置
- (void)setBaseScrollview{
    [super setBaseScrollview];
    
}
#pragma - mark 重写父类-导航设置方法
- (void)setNavCoverView{
    [super setNavCoverView];
    __block UIViewController *weakself = self;
    self.navCoverView.leftBlock = ^{
        [weakself.navigationController popViewControllerAnimated:YES];
    };
    self.navCoverView.rightImgStr = @"";
    self.navCoverView.midTitleStr = @"lalalalal";
    
    
}

#pragma - mark  UI绘制
- (void)createUI{
    
    //titleLab1
    UILabel *titleLab = [Tool createLable:@"输入你的手机号" attributeStr:nil font:FONT_28_Medium textColor:COLOR_343339 alignment:NSTextAlignmentCenter];
    [self.baseScrollView addSubview:titleLab];
    
    
    //PhoneAuthToolView
    PhoneAuthToolView *phoneAuthToolView = [PhoneAuthToolView createAuthToolViewOY:0];
    phoneAuthToolView.titleLab.text = @"你的手机号";
    phoneAuthToolView.textfiled.placeholder = @"输入手机号";
    phoneAuthToolView.tip.text = @"请输入正确手机号";
    __block PhoneAuthToolView *phoneATV = phoneAuthToolView;
    phoneAuthToolView.errorBlock = ^{
        [phoneATV showTip];
    };
    [self.baseScrollView addSubview:phoneAuthToolView];
    
    
    //nextBtn
    UIButton *nextBarbtn = [Tool createBarButton:@"继续" font:FONT_15_Regular titleColor:COLOR_FFFFFF backGroundColor:COLOR_58A5F6 leftSpace:LEFTRIGHTSPACE_40];
    nextBarbtn.tag = 101;
    [nextBarbtn addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.baseScrollView addSubview:nextBarbtn];
    
    //comeBackLogBtn
    NSMutableAttributedString *registAttributeStr = [[NSMutableAttributedString alloc] initWithString:@"已有账号, 立即登陆"];
    [registAttributeStr addAttributes:@{
                                        NSFontAttributeName:FONT_14_Regular,
                                        NSForegroundColorAttributeName:COLOR_358BEF
                                        } range:NSMakeRange(6, 4)];
    UIButton *comeBackLogBtn = [Tool createButton:@"" attributeStr:registAttributeStr font:FONT_14_Regular textColor:COLOR_343339_7];
    [comeBackLogBtn addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    comeBackLogBtn.tag = 102;
    [self.baseScrollView addSubview:comeBackLogBtn];
    
    
    //frame
    [titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.baseScrollView.mas_top).offset(UPDOWNSPACE_64);
        make.centerX.equalTo(self.baseScrollView.mas_centerX);
        make.size.mas_equalTo(titleLab.size);
    }];
    
    
    [phoneAuthToolView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.baseScrollView.mas_centerX);
        make.top.equalTo(titleLab.mas_bottom).offset(UPDOWNSPACE_89);
        make.size.mas_equalTo(phoneAuthToolView.size);
    }];
    
    
    [nextBarbtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(phoneAuthToolView.mas_bottom).offset(UPDOWNSPACE_40);
        make.centerX.equalTo(self.baseScrollView.mas_centerX);
        make.size.mas_equalTo(nextBarbtn.size);
    }];
    
    [comeBackLogBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(nextBarbtn.mas_bottom).offset(UPDOWNSPACE_47);
        make.centerX.equalTo(self.baseScrollView.mas_centerX);
        make.size.mas_equalTo(comeBackLogBtn.size);
    }];
    
}


- (void)buttonClick:(UIButton *)btn{
    
    if (btn.tag == 101) {
        NSLog(@"点击了 继续");
        SmsCodeViewController *smsVC = [[SmsCodeViewController alloc] init];
        smsVC.phoneNoStr = @"15151474388";
        smsVC.smsCodeType = SMS_CODETYPE_REGIST;
        [self.navigationController pushViewController:smsVC animated:YES];
    }
    if (btn.tag == 102) {
        NSLog(@"点击了 返回继续登陆");
        [self.navigationController popViewControllerAnimated:YES];
    }
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
