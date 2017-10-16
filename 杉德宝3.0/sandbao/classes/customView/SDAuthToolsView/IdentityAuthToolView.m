//
//  IdentityAuthToolView.m
//  AuthToolsDemo2.0
//
//  Created by tianNanYiHao on 2017/10/12.
//  Copyright © 2017年 tianNanYiHao. All rights reserved.
//

#import "IdentityAuthToolView.h"

@implementation IdentityAuthToolView

/**
 创建对象
 
 @param OY Y坐标
 @return 实例
 */
+ (instancetype)createAuthToolViewOY:(CGFloat)OY{
    
    IdentityAuthToolView *view = [[IdentityAuthToolView alloc] initWithFrame:CGRectMake(0, OY, 0, 0)];
    return view;
    
}

- (instancetype)initWithFrame:(CGRect)frame{
    
    if ([super initWithFrame:frame]) {
        self.titleLab.text = @"证件号码";
        self.textfiled.placeholder = @"输入证件号码";
        
    }return self;
    
}

#pragma - mark textfiledDelegate
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    
    if ([string isEqualToString:@""]) {
        return YES;
    }
    if (textField.text.length<18) {
        
        return YES;
    }else{
        _errorBlock();
        return NO;
    }
    
    return YES;
}


@end
