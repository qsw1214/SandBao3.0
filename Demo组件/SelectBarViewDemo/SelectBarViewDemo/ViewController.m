//
//  ViewController.m
//  SelectBarViewDemo
//
//  Created by tianNanYiHao on 2017/9/25.
//  Copyright © 2017年 tianNanYiHao. All rights reserved.
//

#import "ViewController.h"
#import "SelectBarView.h"
@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    SelectBarView *sl = [[SelectBarView alloc] init];
    
    sl.titleArr = @[@"我的我我的我的",@"钱包",@"抽奖",@"飞享",@"飞享",@"飞享啦啦啦啦"];
    [self.view addSubview:sl];
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
