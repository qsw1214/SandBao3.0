//
//  BaseViewController.m
//  sandbao
//
//  Created by tianNanYiHao on 2017/10/14.
//  Copyright © 2017年 sand. All rights reserved.
//

#import "BaseViewController.h"

@interface BaseViewController ()

@end

@implementation BaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //配置所有控制器背景色为白色
    self.view.backgroundColor = [UIColor whiteColor];
    
    
    self.baseScrollView = [[UIScrollView alloc] initWithFrame:CGRectZero];
    [self.view addSubview:self.baseScrollView];
    
    
    [self.baseScrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(0);
        make.top.equalTo (self.view.mas_top).offset(UPDOWNSPACE_64);
        make.size.mas_equalTo(CGSizeMake(SCREEN_SIZE.width, SCREEN_SIZE.height -  UPDOWNSPACE_64));
    }];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}



@end
