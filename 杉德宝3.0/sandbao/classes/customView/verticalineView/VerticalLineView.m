//
//  VerticalLineView.m
//  sandbao
//
//  Created by tianNanYiHao on 2017/4/7.
//  Copyright © 2017年 sand. All rights reserved.
//

#import "VerticalLineView.h"
@interface VerticalLineView(){

    CGRect framE;
    
}@end

@implementation VerticalLineView

-(instancetype)initWithFrame:(CGRect)frame{
    
    if (self = [super initWithFrame:frame]) {
        CAGradientLayer *layerRGB = [CAGradientLayer layer];
        layerRGB.frame = frame;
        layerRGB.startPoint = CGPointMake(0, 0);
        layerRGB.endPoint = CGPointMake(0, 1);
        layerRGB.colors = @[(__bridge id)[UIColor colorWithRed:51/255.0 green:165/255.0 blue:218/255.0 alpha:1].CGColor,(__bridge id)[UIColor colorWithRed:98/255.0 green:27/255.0 blue:226/255.0 alpha:1].CGColor];
        [self.layer addSublayer:layerRGB];

    }
    return self;
    
}


@end
