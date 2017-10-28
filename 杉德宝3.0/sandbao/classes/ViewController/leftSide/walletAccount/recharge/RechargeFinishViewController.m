//
//  RechargeFinishViewController.m
//  sandbao
//
//  Created by tianNanYiHao on 2017/10/28.
//  Copyright © 2017年 sand. All rights reserved.
//

#import "RechargeFinishViewController.h"

@interface RechargeFinishViewController ()

@end

@implementation RechargeFinishViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
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
    self.navCoverView.midTitleStr = @"充值成功";
    self.navCoverView.letfImgStr = @"";
    self.navCoverView.rightImgStr = @"";
    
    __block RechargeFinishViewController *selfBlock = self;
    self.navCoverView.leftBlock = ^{
        [selfBlock.navigationController popToRootViewControllerAnimated:YES];
    };
    
    
}
#pragma mark - 重写父类-点击方法集合
- (void)buttonClick:(UIButton *)btn{
    
    if (btn.tag == BTN_TAG_RECHARGE) {
        
    }
    
}


#pragma mark  - UI绘制





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
