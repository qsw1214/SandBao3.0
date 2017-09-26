//
//  ViewController.m
//  SandControlDemo
//
//  Created by tianNanYiHao on 2017/9/25.
//  Copyright © 2017年 tianNanYiHao. All rights reserved.
//

#import "ViewController.h"
#import "ControlView.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.view.backgroundColor = [UIColor whiteColor];
    
    
    
    ControlView *cv = [[ControlView alloc] initWithFrame:CGRectMake(0, 88, self.view.frame.size.width, 500)];
    [self.view addSubview:cv];
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
