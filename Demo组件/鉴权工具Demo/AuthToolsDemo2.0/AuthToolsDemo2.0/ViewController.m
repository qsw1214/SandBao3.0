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
@property (weak, nonatomic) IBOutlet UIScrollView *scrollview;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.scrollview.scrollEnabled = YES;
    
    
    
    
    
    AuthToolBaseView *b = [[AuthToolBaseView alloc] initWithFrame:CGRectMake(0, 10, 0, 0)];
    [self.scrollview addSubview:b];
    
    
    PhoneAuthToolView *p = [PhoneAuthToolView createAuthToolViewOY:b.frame.size.height + 10 + 30];
    p.titleLab.text = @"预留手机号";
    p.textfiled.placeholder = @"输入银行预留手机号";
    p.tip.text = @"请输入正确的银行预留手机号";
    __block PhoneAuthToolView *selfBlockp = p;
    p.errorBlock = ^{
        [selfBlockp showTip];
    };
    [self.scrollview addSubview:p];
    

    PhoneAuthToolView *s = [PhoneAuthToolView createAuthToolViewOY:(b.frame.size.height+30)*2+10];
    [self.scrollview addSubview:s];
    
    
    SixCodeAuthToolView *d = [SixCodeAuthToolView createAuthToolViewOY:(b.frame.size.height+30)*3+10];
    d.style = PayCodeAuthTool;
    d.codeStrBlock = ^(NSString *codeStr) {
        NSLog(@"%@",codeStr);
    };
    [self.scrollview addSubview:d];
    
    SixCodeAuthToolView *n = [SixCodeAuthToolView createAuthToolViewOY:(b.frame.size.height+30)*4+10];
    n.codeStrBlock = ^(NSString *codeStr) {
        NSLog(@"%@",codeStr);
    };
    [self.scrollview addSubview:n];
    
    
    NameAuthToolView *m = [NameAuthToolView createAuthToolViewOY:(b.frame.size.height+30)*5+10];
    [self.scrollview addSubview:m];
    
    IdentityAuthToolView *i = [IdentityAuthToolView createAuthToolViewOY:(b.frame.size.height+30)*6+10];
    i.tip.text = @"请输入正确的证件号码";
    __block IdentityAuthToolView *selfBlocki = i;
    i.errorBlock = ^{
        [selfBlocki showTip];
    };
    [self.scrollview addSubview:i];
    
    CardNoAuthToolView *t = [CardNoAuthToolView createAuthToolViewOY:(b.frame.size.height+30)*7+10];
    [self.scrollview addSubview:t];
    
    
    PwdAuthToolView *j = [PwdAuthToolView createAuthToolViewOY:(b.frame.size.height+30)*8+10];
    [self.scrollview addSubview:j];
    
    
    
    
    
    
    
    
    self.scrollview.contentSize = CGSizeMake(self.view.frame.size.width,3000 + b.frame.size.height + p.frame.size.height + s.frame.size.height + d.frame.size.height+n.frame.size.height+m.frame.size.height+i.frame.size.height+t.frame.size.height+j.frame.size.height);
    
}




- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
