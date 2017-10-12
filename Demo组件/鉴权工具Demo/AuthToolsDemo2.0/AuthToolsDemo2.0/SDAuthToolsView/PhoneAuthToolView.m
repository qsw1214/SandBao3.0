//
//  PhoneAuthToolView.m
//  AuthToolsDemo2.0
//
//  Created by tianNanYiHao on 2017/10/12.
//  Copyright © 2017年 tianNanYiHao. All rights reserved.
//

#import "PhoneAuthToolView.h"

@implementation PhoneAuthToolView


- (instancetype)initWithFrame:(CGRect)frame{
    
    if ([super initWithFrame:frame]) {
        self.titleLab.text = @"账号";
        self.textfiled.placeholder = @"输入手机号";
        
    }return self;
    
}



@end
