//
//  SmsCheckViewController.m
//  sandbao
//
//  Created by tianNanYiHao on 2017/10/18.
//  Copyright © 2017年 sand. All rights reserved.
//

#import "SmsCheckViewController.h"
#import "LogpwdViewController.h"
#import "PayPwdViewController.h"
@interface SmsCheckViewController ()

@end

@implementation SmsCheckViewController

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
    
    
    
}

#pragma - mark  UI绘制
- (void)createUI{
    
    //titleLab1
    UILabel *titleLab = [Tool createLable:@"验证手机" attributeStr:nil font:FONT_28_Medium textColor:COLOR_358BEF alignment:NSTextAlignmentCenter];
    [self.baseScrollView addSubview:titleLab];
    
    //titleLab2
    UILabel *titleDesLab = [Tool createLable:@"短信验证码将会发送到" attributeStr:nil font:FONT_16_Regular textColor:COLOR_343339_7 alignment:NSTextAlignmentCenter];
    [self.baseScrollView addSubview:titleDesLab];

    //titleLab3
    UILabel *titlePhoneNoLab = [Tool createLable:self.phoneNoStr attributeStr:nil font:FONT_20_Medium textColor:COLOR_666666 alignment:NSTextAlignmentCenter];
    [self.baseScrollView addSubview:titlePhoneNoLab];
    
    
    //smsCodeAuth:sixCodeAuth
    SixCodeAuthToolView *smsCodeAuthToolView = [SixCodeAuthToolView createAuthToolViewOY:0];
    smsCodeAuthToolView.style = SmsCodeAuthTool;
    smsCodeAuthToolView.smsCodeStrBlock = ^(NSString *codeStr) {
        NSLog(@"接收到的短信码为: %@",codeStr);
        
        if (self.smsCheckType == SMS_CHECKTYPE_REGIST) {
            //模拟输入短信成功后,跳转设置 登陆密码 页面
            LogpwdViewController *setLogpwdVC = [[LogpwdViewController alloc] init];
            [self.navigationController pushViewController:setLogpwdVC animated:YES];
        }
        if (self.smsCheckType == SMS_CHECKTYPE_REALNAME) {
            //模拟输入短信成功后,跳转设置 支付密码 页面
            PayPwdViewController *setPayPwdVC = [[PayPwdViewController alloc] init];
            [self.navigationController pushViewController:setPayPwdVC animated:YES];
        }
        
    };
    smsCodeAuthToolView.smsRequestBlock = ^{
        NSLog(@"点击了发送短信码的按钮,触发了请求事件,请求事件待攻城狮处理");
        
    };
    [self.baseScrollView addSubview:smsCodeAuthToolView];
    
    
    
    //frame
    [titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.baseScrollView.mas_top).offset(UPDOWNSPACE_64);
        make.centerX.equalTo(self.baseScrollView.mas_centerX);
        make.size.mas_equalTo(titleLab.size);
    }];
    
    [titleDesLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(titleLab.mas_bottom).offset(UPDOWNSPACE_16);
        make.centerX.equalTo(self.baseScrollView.mas_centerX);
        make.size.mas_equalTo(titleDesLab.size);
    }];
    
    [titlePhoneNoLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(titleDesLab.mas_bottom).offset(UPDOWNSPACE_11);
        make.centerX.equalTo(self.baseScrollView.mas_centerX);
        make.size.mas_equalTo(titlePhoneNoLab.size);
    }];
    
    [smsCodeAuthToolView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(titlePhoneNoLab.mas_bottom).offset(UPDOWNSPACE_43);
        make.centerX.equalTo(self.baseScrollView.mas_centerX);
        make.size.mas_equalTo(smsCodeAuthToolView.size);
    }];

    
}









- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
