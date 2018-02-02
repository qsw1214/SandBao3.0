//
//  GradualView.m
//  sandbao
//
//  Created by tianNanYiHao on 2017/3/14.
//  Copyright © 2017年 sand. All rights reserved.
//

#import "GradualView.h"
@interface GradualView(){
    CAGradientLayer *layerRGB;
}@end
@implementation GradualView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

-(instancetype)init{
    if (self = [super init]) {
        //4.渐变色
        layerRGB = [CAGradientLayer layer];
        layerRGB.frame = CGRectZero;
        layerRGB.startPoint = CGPointMake(0, 0);
        layerRGB.endPoint = CGPointMake(1, 0);
        
        [self.layer addSublayer:layerRGB];

            }
    return self;
}

-(void)setRect:(CGRect)rect{
    
    if (_colorStyle == GradualColorBlue) {
        layerRGB.colors = @[(__bridge id)[UIColor colorWithRed:69/255.0 green:145/255.0 blue:241/255.0 alpha:1].CGColor,(__bridge id)[UIColor colorWithRed:108/255.0 green:185/255.0 blue:249/255.0 alpha:1].CGColor];
    }
    if (_colorStyle == GradualColorRed) {
        layerRGB.colors = @[(__bridge id)[UIColor colorWithRed:253/255.0 green:133/255.0 blue:132/255.0 alpha:1].CGColor,(__bridge id)[UIColor colorWithRed:253/255.0 green:157/255.0 blue:140/255.0 alpha:1].CGColor];
    }
    _rect = rect;
    layerRGB.frame = _rect;
}

@end
