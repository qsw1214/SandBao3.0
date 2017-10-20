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
    
    
//    //啥都塞进去的测试
//    [self testOne];
//    
//    //短信码框/密码框测试
//    [self testTwo];
//
//    //银行选择测试
//    [self testThree];
//    
//    //手机号的测试
//    [self testFour];
//
//    //密码框的测试
//    [self testFiv];
//    
//    //姓名框的测试
//     [self testSix];
//    
//    //证件号的测试
//    [self testSev];
    
    //银行卡号测试
    [self testeight];
    
  
}

- (void)testeight{
    
    CardNoAuthToolView *card = [CardNoAuthToolView createAuthToolViewOY:100];
    
    card.tip.text = @"请输入正确的银行卡号";
    __block CardNoAuthToolView *selfCard = card;
    card.successBlock = ^{
        NSLog(@"正确的卡号为 : %@",selfCard.textfiled.text);
    };
    card.errorBlock = ^{
        [selfCard showTip];
    };
    [self.scrollview addSubview:card];
    
}

- (void)testSev{
    IdentityAuthToolView *idv = [IdentityAuthToolView createAuthToolViewOY:0];
    
    idv.tip.text = @"请输入正确身份证号码";
    __block IdentityAuthToolView *selfIdv = idv;
    idv.successBlock = ^{
        NSLog(@"身份证号 : %@",selfIdv.textfiled.text);
    };
    idv.errorBlock = ^{
        [selfIdv showTip];
    };
    
    [self.scrollview addSubview:idv];
    
}

- (void)testSix{
    
    NameAuthToolView * name = [NameAuthToolView createAuthToolViewOY:0];
    name.tip.text = @"请输入真实姓名";
    __block NameAuthToolView *selfName = name;
    name.successBlock = ^{
        NSLog(@"真实姓名 : %@",selfName.textfiled.text);
    };
    name.errorBlock = ^{
        [selfName showTip];
    };
    
    [self.scrollview addSubview:name];
}

- (void)testFiv{
    
    
    PwdAuthToolView *pwd = [PwdAuthToolView createAuthToolViewOY:100];
    pwd.tip.text = @"请输入8-20位数字字母组合密码";
    __block PwdAuthToolView *selfPwd = pwd;
    pwd.successBlock = ^{
        NSLog(@"密码 : %@",selfPwd.textfiled.text);
    };
    pwd.errorBlock = ^{
        [selfPwd showTip];
    };
    [self.scrollview addSubview:pwd];
    
}

- (void)testFour{
    
    PhoneAuthToolView *p = [PhoneAuthToolView createAuthToolViewOY:100];
    p.tip.text = @"请输入正确的手机号";
    __block PhoneAuthToolView *selfP = p;
    p.successBlock = ^{
        NSLog(@"获取到的可用手机号码为 : %@",selfP.textfiled.text);
    };
    p.errorBlock = ^{
        [selfP showTip];
    };
    [self.scrollview addSubview:p];
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
    d.successBlock = ^(NSString *codeStr) {
        NSLog(@"接受到的短信码为: %@",codeStr);
    };
    d.successRequestBlock = ^{
        NSLog(@"点击了发送短信码的按钮");
    };
    [self.scrollview addSubview:d];
    
    SixCodeAuthToolView *n = [SixCodeAuthToolView createAuthToolViewOY:d.frame.size.height + 130];
    n.style = PayCodeAuthTool;
    n.successBlock = ^(NSString *codeStr) {
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
    j.tip.text = @"请输入8-20位的数字字母组合密码";
    __block id selfj = j;
    j.errorBlock = ^{
        [selfj showTip];
    };
    [self.scrollview addSubview:j];
    
    
    self.scrollview.contentSize = CGSizeMake(self.view.frame.size.width,3000 + b.frame.size.height + p.frame.size.height + s.frame.size.height + m.frame.size.height+i.frame.size.height+t.frame.size.height+j.frame.size.height);
    
}
@end
