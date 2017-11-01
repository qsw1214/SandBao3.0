//
//  RechargeFinishViewController.m
//  sandbao
//
//  Created by tianNanYiHao on 2017/10/28.
//  Copyright © 2017年 sand. All rights reserved.
//

#import "RechargeFinishViewController.h"

@interface RechargeFinishViewController ()
{
    UIView *headView;
    UIView *bodyView;
}
@end

@implementation RechargeFinishViewController

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    self.sideMenuViewController.panGestureEnabled = NO;
    self.baseScrollView.pagingEnabled = NO;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
    
    [self create_HeadView];
    [self create_BodyView];
    
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
    self.navCoverView.midTitleStr = @"充值完成";
    self.navCoverView.rightTitleStr = @"完成";
 
    
    __block RechargeFinishViewController *weakSelf = self;
    self.navCoverView.rightBlock = ^{
        [weakSelf.navigationController popToRootViewControllerAnimated:YES];
    };
    
}
#pragma mark - 重写父类-点击方法集合
- (void)buttonClick:(UIButton *)btn{
    
    
    
}


#pragma mark  - UI绘制

- (void)create_HeadView{
    //headView
    headView = [[UIView alloc] init];
    headView.backgroundColor = COLOR_FFFFFF;
    [self.baseScrollView addSubview:headView];
    
    //titleLab
    UILabel *titleLab = [Tool createLable:@"杉德宝" attributeStr:nil font:FONT_15_Regular textColor:COLOR_343339 alignment:NSTextAlignmentCenter];
    [headView addSubview:titleLab];
    
    //moneyLab
    UILabel *moneyLab = [Tool createLable:@"+1000.00" attributeStr:nil font:FONT_28_SFUIT_Rrgular textColor:COLOR_000000 alignment:NSTextAlignmentCenter];
    [headView addSubview:moneyLab];
    
    //rechargeFinishLab
    UILabel *rechargeFinishLab = [Tool createLable:@"充值成功" attributeStr:nil font:FONT_14_Regular textColor:COLOR_343339_7 alignment:NSTextAlignmentCenter];
    [headView addSubview:rechargeFinishLab];
    
    headView.width = SCREEN_WIDTH;
    headView.height = UPDOWNSPACE_25 + titleLab.height + UPDOWNSPACE_20 +  moneyLab.height + UPDOWNSPACE_15 + rechargeFinishLab.height + UPDOWNSPACE_43;
    
    [headView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.baseScrollView.mas_top).offset(UPDOWNSPACE_20);
        make.centerX.equalTo(self.baseScrollView);
        make.size.mas_equalTo(CGSizeMake(headView.width, headView.height));
    }];
    
    [titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(headView.mas_top).offset(UPDOWNSPACE_25);
        make.centerX.equalTo(headView);
        make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH, titleLab.height));
    }];
    
    [moneyLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(titleLab.mas_bottom).offset(UPDOWNSPACE_20);
        make.centerX.equalTo(headView);
        make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH, moneyLab.height));
    }];
    
    [rechargeFinishLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(moneyLab.mas_bottom).offset(UPDOWNSPACE_15);
        make.centerX.equalTo(headView);
        make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH, rechargeFinishLab.height));
    }];
    
}

- (void)create_BodyView{
    //bodyView
    bodyView = [[UIView alloc] init];
    bodyView.backgroundColor = COLOR_FFFFFF;
    [self.baseScrollView addSubview:bodyView];
    
    //payObjectLab
    UILabel *payObjectLab = [Tool createLable:@"付款方" attributeStr:nil font:FONT_13_Regular textColor:COLOR_343339_7 alignment:NSTextAlignmentLeft];
    [bodyView addSubview:payObjectLab];
    
    //payObjectDetLab
    UILabel *payObjectDetLab = [Tool createLable:@"个人银行卡" attributeStr:nil font:FONT_13_Regular textColor:COLOR_343339 alignment:NSTextAlignmentRight];
    [bodyView addSubview:payObjectDetLab];
    
    //line
    UIView *line = [[UIView alloc] init];
    line.backgroundColor = COLOR_A1A2A5_3;
    line.size = CGSizeMake(SCREEN_WIDTH - 2*LEFTRIGHTSPACE_20, 1);
    [bodyView addSubview:line];
    
    //payMoneyLab
    UILabel *payMoneyLab = [Tool createLable:@"扣款信息" attributeStr:nil font:FONT_13_Regular textColor:COLOR_343339_7 alignment:NSTextAlignmentLeft];
    [bodyView addSubview:payMoneyLab];
    
    //payMoneyDetLab
    UILabel *payMoneyDetLab = [Tool createLable:@"-1000.00" attributeStr:nil font:FONT_13_Regular textColor:COLOR_343339 alignment:NSTextAlignmentRight];
    [bodyView addSubview:payMoneyDetLab];
    
    
    payObjectDetLab.width = SCREEN_WIDTH - LEFTRIGHTSPACE_35 - payObjectLab.width - LEFTRIGHTSPACE_35;
    payMoneyDetLab.width = SCREEN_WIDTH - LEFTRIGHTSPACE_35 - payMoneyLab.width - LEFTRIGHTSPACE_35;
    bodyView.height = (UPDOWNSPACE_25 + payObjectLab.height + UPDOWNSPACE_25)*2;
    
    
    [bodyView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(headView.mas_bottom).offset(UPDOWNSPACE_0);
        make.left.equalTo(self.baseScrollView.mas_left);
        make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH, bodyView.height));
    }];
    
    [payObjectLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(bodyView.mas_top).offset(UPDOWNSPACE_25);
        make.left.equalTo(bodyView.mas_left).offset(LEFTRIGHTSPACE_35);
        make.size.mas_equalTo(payObjectLab.size);
    }];
    
    [payObjectDetLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(bodyView.mas_top).offset(UPDOWNSPACE_25);
        make.left.equalTo(payObjectLab.mas_right).offset(LEFTRIGHTSPACE_00);
        make.size.mas_equalTo(CGSizeMake(payObjectDetLab.width, payObjectDetLab.height));
    }];
    
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(payObjectLab.mas_bottom).offset(UPDOWNSPACE_25);
        make.left.equalTo(bodyView.mas_left).offset(LEFTRIGHTSPACE_20);
        make.size.mas_equalTo(line.size);
    }];
    
    [payMoneyLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(line.mas_bottom).offset(UPDOWNSPACE_25);
        make.left.equalTo(bodyView.mas_left).offset(LEFTRIGHTSPACE_35);
        make.size.mas_equalTo(payMoneyLab.size);
    }];
   
    [payMoneyDetLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(line.mas_bottom).offset(UPDOWNSPACE_25);
        make.left.equalTo(payMoneyLab.mas_right).offset(LEFTRIGHTSPACE_00);
        make.size.mas_equalTo(CGSizeMake(payMoneyDetLab.width, payMoneyDetLab.height));
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
