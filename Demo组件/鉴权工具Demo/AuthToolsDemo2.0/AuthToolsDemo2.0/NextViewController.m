//
//  NextViewController.m
//  AuthToolsDemo2.0
//
//  Created by tianNanYiHao on 2017/10/19.
//  Copyright © 2017年 tianNanYiHao. All rights reserved.
//

#import "NextViewController.h"
#import "BankPickerView.h"

#import "SixCodeAuthToolView.h"

@interface NextViewController ()

@end

@implementation NextViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    //    //短信码框/密码框测试
        [self testTwo];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma  - mark testTwo
- (void)testTwo{
    

    //短信m
    SixCodeAuthToolView *d = [SixCodeAuthToolView createAuthToolViewOY:(100+30)*1+0];
    d.style = SmsCodeAuthTool;
    d.successBlock = ^(NSString *textfieldText){
        NSLog(@"%@",textfieldText);
    };
    
    d.successRequestBlock = ^(NSString *textfieldText){
        NSLog(@"点击了发送短信码的按钮");
    };
    [self.view addSubview:d];
    
    SixCodeAuthToolView *n = [SixCodeAuthToolView createAuthToolViewOY:d.frame.size.height + 130];
    n.style = PayCodeAuthTool;
    n.successBlock = ^(NSString *textfieldText) {
        NSLog(@"接受到的密码为: %@",textfieldText);
    };
    [self.view addSubview:n];
    
}







@end
