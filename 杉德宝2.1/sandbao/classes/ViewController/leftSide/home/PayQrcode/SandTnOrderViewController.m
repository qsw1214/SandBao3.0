//
//  SandTnOrderViewController.m
//  sandbao
//
//  Created by tianNanYiHao on 2017/12/7.
//  Copyright © 2017年 sand. All rights reserved.
//

#import "SandTnOrderViewController.h"

@interface SandTnOrderViewController ()
{
    UIView *headView;
    UIView *bodyView;
}
@end

@implementation SandTnOrderViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self create_HeadView];
    
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
    self.navCoverView.midTitleStr = @"杉德宝安全支付";
    self.navCoverView.rightTitleStr = @"取消";
    
    __weak SandTnOrderViewController *weakSelf = self;
    self.navCoverView.rightBlock = ^{
        [weakSelf.navigationController popViewControllerAnimated:YES];
    };

}
#pragma mark - 重写父类-点击方法集合
- (void)buttonClick:(UIButton *)btn{
    
    
}

#pragma mark  - UI绘制
- (void)create_HeadView{
    
    headView = [[UIView alloc] init];
    headView.backgroundColor = COLOR_F5F5F5;
    [self.baseScrollView addSubview:headView];
    
    
}


- (void)create_bodyView{
    bodyView = [[UIView alloc] init];
    bodyView.backgroundColor = COLOR_FFFFFF;
    [self.baseScrollView addSubview:bodyView];
    
    
    
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
