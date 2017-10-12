//
//  IdentityAuthToolView.m
//  AuthToolsDemo2.0
//
//  Created by tianNanYiHao on 2017/10/12.
//  Copyright © 2017年 tianNanYiHao. All rights reserved.
//

#import "IdentityAuthToolView.h"

@implementation IdentityAuthToolView

- (instancetype)initWithFrame:(CGRect)frame{
    
    if ([super initWithFrame:frame]) {
        self.titleLab.text = @"证件号码";
        self.textfiled.placeholder = @"输入证件号码";
        
    }return self;
    
}




@end
