//
//  PhoneAuthToolView.m
//  AuthToolsDemo2.0
//
//  Created by tianNanYiHao on 2017/10/12.
//  Copyright © 2017年 tianNanYiHao. All rights reserved.
//

#import "PhoneAuthToolView.h"

@implementation PhoneAuthToolView

/**
 创建对象
 
 @param OY Y坐标
 @return 实例
 */
+ (instancetype)createAuthToolViewOY:(CGFloat)OY{
    
    PhoneAuthToolView *view = [[PhoneAuthToolView alloc] initWithFrame:CGRectMake(0, OY, 0, 0)];
    return view;
    
}


- (instancetype)initWithFrame:(CGRect)frame{
    
    if ([super initWithFrame:frame]) {
        self.titleLab.text = @"账号";
        self.textfiled.placeholder = @"输入手机号";
        self.textfiled.keyboardType = UIKeyboardTypeNumberPad;
        
    }return self;
    
}

#pragma - mark textfiledDelegate
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    
    if ([string isEqualToString:@""]) {
        return YES;
    }
    if (textField.text.length<11) {
       
        return YES;
    }else{
         _errorBlock();
        return NO;
    }
    
    return YES;
}


@end
