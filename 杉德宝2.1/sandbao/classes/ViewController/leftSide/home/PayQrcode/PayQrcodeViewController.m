//
//  PayQrcodeViewController.m
//  sandbao
//
//  Created by tianNanYiHao on 2017/12/5.
//  Copyright © 2017年 sand. All rights reserved.
//

#import "PayQrcodeViewController.h"
#import "SDSelectBarView.h"
@interface PayQrcodeViewController ()

@end

@implementation PayQrcodeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self creaetUI];
    
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
    self.navCoverView.letfImgStr = @"login_icon_back";
    self.navCoverView.midTitleStr = @"收付款";
    
    __weak PayQrcodeViewController *weakSelf = self;
    self.navCoverView.leftBlock = ^{
        [weakSelf.navigationController popViewControllerAnimated:YES];
    };
    
}
#pragma mark - 重写父类-点击方法集合
- (void)buttonClick:(UIButton *)btn{
    
    
}


#pragma mark  - UI绘制
- (void)creaetUI{
    
    SDSelectBarView *selectBarView = [SDSelectBarView showSelectBarView:@[@"收款码",@"付款码"] selectBarBlock:^(NSInteger index) {
        switch (index) {
            case 0:
            {
                
            }
                break;
                
            case 1:
            {
                
            }
                break;
            default:
                break;
        }
        
    }];
    
    [self.baseScrollView addSubview:selectBarView];
    
    
    [selectBarView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.baseScrollView.mas_top).offset(UPDOWNSPACE_11);
        make.centerX.equalTo(self.baseScrollView.mas_centerX);
        make.size.mas_equalTo(selectBarView.size);
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
