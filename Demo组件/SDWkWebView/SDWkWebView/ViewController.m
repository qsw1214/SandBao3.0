//
//  ViewController.m
//  SDWkWebView
//
//  Created by tianNanYiHao on 2018/1/31.
//  Copyright © 2018年 tianNanYiHao. All rights reserved.
//

#import "ViewController.h"
#import "SDWkWebView.h"
@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    
    
    
    SDWkWebView *webView = [[SDWkWebView alloc] initWithFrame:CGRectMake(0, 64, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height-64)];

    [webView load:[NSURL URLWithString:@"http://172.28.247.111:17892/ot/share.html?inviteCode=CBkDwp"]];
    
    [self.view addSubview:webView];
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
