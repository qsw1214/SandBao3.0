//
//  RegistViewController.m
//  sandbao
//
//  Created by tianNanYiHao on 2017/10/17.
//  Copyright © 2017年 sand. All rights reserved.
//

#import "RegistViewController.h"
#import "SmsCheckViewController.h"
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
        NSLog(@"点击了 继续");
        SmsCheckViewController *smsVC = [[SmsCheckViewController alloc] init];
        smsVC.phoneNoStr = @"15151474388";
        smsVC.smsCheckType = SMS_CHECKTYPE_REGIST;
        [self.navigationController pushViewController:smsVC animated:YES];
    }
    if (btn.tag == BTN_TAG_LOGIN) {
        NSLog(@"点击了 返回继续登陆");
        [self.navigationController popViewControllerAnimated:YES];
    }
    
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
    __block PhoneAuthToolView *selfPhoneAuthToolView = phoneAuthToolView;
    phoneAuthToolView.successBlock = ^{
        NSLog(@"成功获取的手机号码为 : %@",selfPhoneAuthToolView.textfiled.text);
    };
    phoneAuthToolView.errorBlock = ^{
        [selfPhoneAuthToolView showTip];
    };
    [self.baseScrollView addSubview:phoneAuthToolView];
    
    
    //nextBtn
    UIButton *nextBarbtn = [Tool createBarButton:@"继续" font:FONT_15_Regular titleColor:COLOR_FFFFFF backGroundColor:COLOR_58A5F6 leftSpace:LEFTRIGHTSPACE_40];
    nextBarbtn.tag = BTN_TAG_NEXT;
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
    comeBackLogBtn.tag = BTN_TAG_LOGIN;
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





- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
