//
//  ViewController.m
//  SuccessCircleAnimation
//
//  Created by tianNanYiHao on 2017/12/14.
//  Copyright © 2017年 tianNanYiHao. All rights reserved.
//

#import "ViewController.h"
#import "SpsLoadingView.h"
@interface ViewController ()
{
    SpsLoadingView *sps;
}
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    CGFloat wh = 100;
    
    sps = [[SpsLoadingView alloc] initWithFrame:CGRectMake(([UIScreen mainScreen].bounds.size.width - wh)/2, 100, wh, wh)];
    
   
    [sps startCircleAnimation];
    [self.view addSubview:sps];
    
    
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    
    [sps stopCircleAnimation];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
