//
//  CardNoAuthToolView.m
//  AuthToolsDemo2.0
//
//  Created by tianNanYiHao on 2017/10/12.
//  Copyright © 2017年 tianNanYiHao. All rights reserved.
//

#import "CardNoAuthToolView.h"

@implementation CardNoAuthToolView

- (instancetype)initWithFrame:(CGRect)frame{
    
    if ([super initWithFrame:frame]) {
        self.titleLab.text = @"银行卡号";
        self.textfiled.placeholder = @"输入银行卡卡号";
        
    }return self;
    
}


@end
