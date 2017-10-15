//
//  LoginViewController.m
//  sandbao
//
//  Created by tianNanYiHao on 2017/10/13.
//  Copyright © 2017年 sand. All rights reserved.
//

#import "LoginViewController.h"

@interface LoginViewController ()

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSMutableAttributedString *a = [[NSMutableAttributedString alloc] initWithString:@"111111111111"];
    [a addAttributes:@{
                       NSFontAttributeName:FONT_28,
                       NSForegroundColorAttributeName:COLOR_DARKBLUE
                       } range:NSMakeRange(1, 3)];
    

    
    UILabel *l = [Tool createLable:@"1234567890" attributeStr:nil font:FONT_28 textColor:COLOR_DARKBALCK alignment:0];
    
    l.frame = CGRectMake(0, 88, 320, 50);
    
    [self.baseScrollView addSubview:l];
    
    
    
}























- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
