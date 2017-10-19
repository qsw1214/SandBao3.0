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
#import "BankAuthToolView.h"
#import "BankPickerView.h"

#import "NextViewController.h"
@interface ViewController ()
@property (weak, nonatomic) IBOutlet UIScrollView *scrollview;

@end

@implementation ViewController

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    
    //啥都塞进去的测试
//    [self testOne];
    
    
    //短信码框/密码框测试
//    [self testTwo];
    
    //银行选择测试
    [self testThree];
    
  
}


- (void)testThree{
    self.scrollview.scrollEnabled = YES;
    self.scrollview.userInteractionEnabled = YES;
    
    BankAuthToolView *b = [BankAuthToolView createAuthToolViewOY:100];
    [self.view addSubview:b];

    [BankPickerView  showBankPickView:@[@[@"测试数据---1", @"测试数据---2", @"测试数据---3", @"测试数据---4", @"测试数据---5", @"测试数据---6"], @[@"123", @"456", @"789"]] blockBankInfo:^(NSArray *bankInfo) {
        NSLog(@"%@ = %@",bankInfo[0],bankInfo[1]);
    }];
    
}


#pragma  - mark testTwo
- (void)testTwo{
    
    self.scrollview.scrollEnabled = YES;
    self.scrollview.userInteractionEnabled = YES;
    
    //短信m
    SixCodeAuthToolView *d = [SixCodeAuthToolView createAuthToolViewOY:(100+30)*1+0];
    d.style = SmsCodeAuthTool;
    d.smsCodeStrBlock = ^(NSString *codeStr) {
        NSLog(@"接受到的短信码为: %@",codeStr);
    };
    d.smsRequestBlock = ^{
        NSLog(@"点击了发送短信码的按钮");
    };
    [self.scrollview addSubview:d];
    
    SixCodeAuthToolView *n = [SixCodeAuthToolView createAuthToolViewOY:d.frame.size.height + 130];
    n.style = PayCodeAuthTool;
    n.smsCodeStrBlock = ^(NSString *codeStr) {
        NSLog(@"接受到的密码为: %@",codeStr);
    };
    [self.scrollview addSubview:n];
    
    
    
}







#pragma  - mark testOne
- (void)testOne{
    
    
    self.scrollview.scrollEnabled = YES;
    
    AuthToolBaseView *b = [[AuthToolBaseView alloc] initWithFrame:CGRectMake(0, 30, 0, 0)];
    [self.scrollview addSubview:b];
    
    
    PhoneAuthToolView *p = [PhoneAuthToolView createAuthToolViewOY:b.frame.size.height + 30 + 0];
    p.titleLab.text = @"预留手机号";
    p.textfiled.placeholder = @"输入银行预留手机号";
    p.tip.text = @"请输入正确的银行预留手机号";
    __block PhoneAuthToolView *selfBlockp = p;
    p.errorBlock = ^{
        [selfBlockp showTip];
    };
    [self.scrollview addSubview:p];
    
    
    PhoneAuthToolView *s = [PhoneAuthToolView createAuthToolViewOY:(b.frame.size.height+30)*2-30];
    [self.scrollview addSubview:s];
    
    
    
    NameAuthToolView *m = [NameAuthToolView createAuthToolViewOY:(b.frame.size.height+30)*5+0];
    [self.scrollview addSubview:m];
    
    IdentityAuthToolView *i = [IdentityAuthToolView createAuthToolViewOY:(b.frame.size.height+30)*6+0];
    i.tip.text = @"请输入正确的证件号码";
    __block IdentityAuthToolView *selfBlocki = i;
    i.errorBlock = ^{
        [selfBlocki showTip];
    };
    [self.scrollview addSubview:i];
    
    CardNoAuthToolView *t = [CardNoAuthToolView createAuthToolViewOY:(b.frame.size.height+30)*7+0];
    [self.scrollview addSubview:t];
    
    
    PwdAuthToolView *j = [PwdAuthToolView createAuthToolViewOY:(b.frame.size.height+30)*8+0];
    [self.scrollview addSubview:j];
    
    
    self.scrollview.contentSize = CGSizeMake(self.view.frame.size.width,3000 + b.frame.size.height + p.frame.size.height + s.frame.size.height + m.frame.size.height+i.frame.size.height+t.frame.size.height+j.frame.size.height);
    
}
@end
