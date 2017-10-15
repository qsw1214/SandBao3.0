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
    
    
    self.baseScrollView = [[UIScrollView alloc] initWithFrame:SCREEN_RECT];
    [self.view addSubview:self.baseScrollView];
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}



@end
