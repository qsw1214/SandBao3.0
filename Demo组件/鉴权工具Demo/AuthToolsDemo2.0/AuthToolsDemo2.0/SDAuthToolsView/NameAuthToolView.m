//
//  NameAuthToolView.m
//  AuthToolsDemo2.0
//
//  Created by tianNanYiHao on 2017/10/12.
//  Copyright © 2017年 tianNanYiHao. All rights reserved.
//

#import "NameAuthToolView.h"

@implementation NameAuthToolView

- (instancetype)initWithFrame:(CGRect)frame{
    
    if ([super initWithFrame:frame]) {
        self.titleLab.text = @"真实姓名";
        self.textfiled.placeholder = @"输入真实姓名";
        
    }return self;
    
}




@end
