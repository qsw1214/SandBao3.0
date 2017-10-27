//
//  FinancicleCenterViewController.m
//  sandbao
//
//  Created by tianNanYiHao on 2017/10/27.
//  Copyright © 2017年 sand. All rights reserved.
//

#import "FinancicleCenterViewController.h"

@interface FinancicleCenterViewController ()

@end

@implementation FinancicleCenterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}



#pragma mark - 重写父类-baseScrollView设置
- (void)setBaseScrollview{
    [super setBaseScrollview];
    
}
#pragma mark - 重写父类-导航设置方法
- (void)setNavCoverView{
    [super setNavCoverView];
    self.navCoverView.style = NavCoverStyleGradient;
    self.navCoverView.midTitleStr = @"理财中心";
    self.navCoverView.letfImgStr = @"";
    self.navCoverView.rightImgStr = @"";
    
    
    
    
    
}
#pragma mark - 重写父类-点击方法集合
- (void)buttonClick:(UIButton *)btn{
    
    
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
