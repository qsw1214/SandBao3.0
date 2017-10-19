//
//  RealNameViewController.m
//  sandbao
//
//  Created by tianNanYiHao on 2017/10/19.
//  Copyright © 2017年 sand. All rights reserved.
//

#import "RealNameViewController.h"
#import "SmsCheckViewController.h"

@interface RealNameViewController ()

@end

@implementation RealNameViewController


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
    self.navCoverView.letfImgStr  = nil;
    
}
#pragma - mark 重写父类-点击方法集合
- (void)buttonClick:(UIButton *)btn{
    if (btn.tag == BTN_TAG_SHOWBANKLIST) {
        NSLog(@"点击了 支持银行 按钮");
    }
    if (btn.tag == BTN_TAG_NEXT) {
        NSLog(@"点击了 继续 按钮");
        SmsCheckViewController *smsVC = [[SmsCheckViewController alloc] init];
        smsVC.phoneNoStr = @"15151474388";
        smsVC.smsCheckType = SMS_CHECKTYPE_REALNAME;
        [self.navigationController pushViewController:smsVC animated:YES];
    }
    
}

#pragma - mark  UI绘制
- (void)createUI{
    
    //titleLab1
    UILabel *titleLab = [Tool createLable:@"实名认证" attributeStr:nil font:FONT_28_Medium textColor:COLOR_343339 alignment:NSTextAlignmentCenter];
    [self.baseScrollView addSubview:titleLab];
    
    //titleLab2
    UILabel *titleDesLab = [Tool createLable:@"请完成实名认证,体验更多服务" attributeStr:nil font:FONT_16_Regular textColor:COLOR_343339_7 alignment:NSTextAlignmentCenter];
    [self.baseScrollView addSubview:titleDesLab];
    
    
    //nameAuthToolView
    NameAuthToolView *nameAuthToolView = [NameAuthToolView createAuthToolViewOY:0];
    [self.baseScrollView addSubview:nameAuthToolView];
    
    //identityAuthToolView
    IdentityAuthToolView *identityAuthToolView = [IdentityAuthToolView createAuthToolViewOY:0];
    [self.baseScrollView addSubview:identityAuthToolView];
    
    //cardNoAuthToolView
    CardNoAuthToolView *cardNoAuthToolView = [CardNoAuthToolView createAuthToolViewOY:0];
    [self.baseScrollView addSubview:cardNoAuthToolView];
    
    //bankAuthToolView
    BankAuthToolView *bankAuthToolView = [BankAuthToolView createAuthToolViewOY:0];
    [self.baseScrollView addSubview:bankAuthToolView];
    
    //moreBankListBtn
    UIButton *moreBankListBtn = [Tool createButton:@"支持银行" attributeStr:nil font:FONT_14_Regular textColor:COLOR_343339_7];
    moreBankListBtn.tag = BTN_TAG_SHOWBANKLIST;
    [moreBankListBtn setImage:[UIImage imageNamed:@"general_icon_detail"] forState:UIControlStateNormal];
    CGSize moreBankListBtnSize = [moreBankListBtn sizeThatFits:CGSizeZero];
    [self.baseScrollView addSubview:moreBankListBtn];
    
    
    
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
    
    
    [nameAuthToolView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(titleDesLab.mas_bottom).offset(UPDOWNSPACE_58);
        make.centerX.equalTo(self.baseScrollView);
        make.size.mas_equalTo(nameAuthToolView.size);
    }];
    
    [identityAuthToolView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(nameAuthToolView.mas_bottom).offset(UPDOWNSPACE_0);
        make.centerX.equalTo(self.baseScrollView);
        make.size.mas_equalTo(identityAuthToolView.size);
    }];
    
    [cardNoAuthToolView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(identityAuthToolView.mas_bottom).offset(UPDOWNSPACE_0);
        make.centerX.equalTo(self.baseScrollView);
        make.size.mas_equalTo(cardNoAuthToolView.size);
    }];
    
    [bankAuthToolView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(cardNoAuthToolView.mas_bottom).offset(UPDOWNSPACE_0);
        make.centerX.equalTo(self.baseScrollView);
        make.size.mas_equalTo(bankAuthToolView.size);
    }];

    [moreBankListBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(bankAuthToolView.mas_bottom).offset(UPDOWNSPACE_25);
        make.right.equalTo(bankAuthToolView.mas_right).offset(-LEFTRIGHTSPACE_40);
        make.size.mas_equalTo(moreBankListBtnSize);
    }];
    
    [nextBarbtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(bankAuthToolView.mas_bottom).offset(UPDOWNSPACE_69);
        make.centerX.equalTo(self.baseScrollView.mas_centerX);
        make.size.mas_equalTo(nextBarbtn.size);
    }];
    
}











- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    // 禁用返回手势
    if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.navigationController.interactivePopGestureRecognizer.enabled = NO;
    }
}
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    // 开启返回手势
    if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.navigationController.interactivePopGestureRecognizer.enabled = YES;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
