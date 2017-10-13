//
//  ViewController.m
//  AuthToolsDemo2.0
//
//  Created by tianNanYiHao on 2017/10/12.
//  Copyright © 2017年 tianNanYiHao. All rights reserved.
//

#import "ViewController.h"
#import "AuthToolBaseView.h"
#import "PhoneAuthToolView.h"
#import "PwdAuthToolView.h"
#import "NameAuthToolView.h"
#import "IdentityAuthToolView.h"
#import "CardNoAuthToolView.h"
#import "SixCodeAuthToolView.h"
@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    AuthToolBaseView *b = [[AuthToolBaseView alloc] initWithFrame:CGRectMake(0, 100, 0, 0)];
    [self.view addSubview:b];
    
    PhoneAuthToolView *p = [[PhoneAuthToolView alloc] initWithFrame:CGRectMake(0, b.frame.size.height+100+30, 0, 0)];
    p.titleLab.text = @"预留手机号";
    p.textfiled.placeholder = @"输入银行预留手机号";
    [self.view addSubview:p];
    
    
    SixCodeAuthToolView *d = [[SixCodeAuthToolView alloc] initWithFrame:CGRectMake(0, p.frame.size.height*2+100+30*2, 0, 0)];
    d.style = PayCodeAuthTool;
    d.codeStrBlock = ^(NSString *codeStr) {
        NSLog(@"%@",codeStr);
    };
    [self.view addSubview:d];
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
