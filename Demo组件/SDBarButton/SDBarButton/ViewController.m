//
//  ViewController.m
//  SDBarButton
//
//  Created by tianNanYiHao on 2018/1/22.
//  Copyright © 2018年 tianNanYiHao. All rights reserved.
//

#import "ViewController.h"
#import "SDBarButton.h"
@interface ViewController ()
{
    SDBarButton *btn;
}
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    btn = [[SDBarButton alloc] init];
    UIView *barButtonView = [btn createBarButton:@"确定" font:[UIFont systemFontOfSize:14] titleColor:[UIColor whiteColor] backGroundColor: [UIColor colorWithRed:88/255.0 green:165/255.0 blue:246/255.0 alpha:1/1.0] leftSpace:40];
    [self.view addSubview:barButtonView];
    
    barButtonView.frame = CGRectMake(40, 100, barButtonView.frame.size.width, barButtonView.frame.size.height);
    
}




- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
