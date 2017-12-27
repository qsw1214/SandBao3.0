//
//  ViewController.m
//  SDSelectBarView2
//
//  Created by tianNanYiHao on 2017/12/26.
//  Copyright © 2017年 tianNanYiHao. All rights reserved.
//

#import "ViewController.h"
#import "SDSelectBarView.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    SDSelectBarView *selectBarView = [[SDSelectBarView alloc] init];
    selectBarView.center = self.view.center;
    
    [self.view addSubview:selectBarView];
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
