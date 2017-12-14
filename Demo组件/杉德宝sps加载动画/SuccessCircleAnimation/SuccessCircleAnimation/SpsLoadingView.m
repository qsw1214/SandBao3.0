//
//  SpsLoadingView.m
//  SuccessCircleAnimation
//
//  Created by tianNanYiHao on 2017/12/14.
//  Copyright © 2017年 tianNanYiHao. All rights reserved.
//

#import "SpsLoadingView.h"

//圆线宽度
#define strokeLineWidth 6.f
//角度转弧度
#define radian(degress) ((M_PI * (degress))/180.f)

@interface SpsLoadingView(){
    
    //圆frma
    CGRect circleFrame;
    //半径
    CGFloat radius;
    //logo尺寸
    CGSize logoImgSize;
    //centerPoint
    CGPoint centerPoint;
    
    UIBezierPath *path_circleStart;
}

/**
 背景圆
 */
@property (nonatomic, strong) CAShapeLayer *circleBackLayer;

/**
 圆
 */
@property (nonatomic, strong) CAShapeLayer *circleLayer;
@end

@implementation SpsLoadingView



- (instancetype)initWithFrame:(CGRect)frame{
    if ([super initWithFrame:frame]) {
        
        circleFrame = frame;
        logoImgSize = CGSizeMake(circleFrame.size.width - strokeLineWidth, circleFrame.size.width - strokeLineWidth);
        centerPoint = CGPointMake(circleFrame.size.width/2, circleFrame.size.width/2);
        radius = logoImgSize.width/2;
        
        [self addCirClelayer];
        
        [self addLogoImg];
    }
    return self;
}

- (CAShapeLayer*)circleBackLayer{
    if (!_circleBackLayer) {
        _circleBackLayer = [CAShapeLayer layer];
        _circleBackLayer.frame = CGRectMake(0, 0, radius, radius);
        [self.layer addSublayer:_circleBackLayer];
    }
    return _circleBackLayer;
}

- (CAShapeLayer*)circleLayer{
    if (!_circleLayer) {
        _circleLayer = [CAShapeLayer layer];
        _circleLayer.frame = CGRectMake(0, 0, radius, radius);
        [self.layer addSublayer:_circleLayer];
    }
    return _circleLayer;
}


- (void)addCirClelayer{
    
    //0.背景圆
     UIBezierPath *path_circleBack = [UIBezierPath bezierPathWithArcCenter:centerPoint radius:radius startAngle:radian(0) endAngle:radian(360) clockwise:YES];
    self.circleBackLayer.path = path_circleBack.CGPath;
    self.circleBackLayer.fillColor = [UIColor clearColor].CGColor;
    self.circleBackLayer.strokeColor = [UIColor blackColor].CGColor;
    self.circleBackLayer.lineWidth = strokeLineWidth;
    self.circleBackLayer.strokeEnd = 1;
    
    
    
    //1.动画圆
    UIBezierPath *path_circle = [UIBezierPath bezierPathWithArcCenter:centerPoint radius:radius startAngle:radian(270) endAngle:radian(269.9) clockwise:YES];
    self.circleLayer.path = path_circle.CGPath;
    self.circleLayer.fillColor = [UIColor clearColor].CGColor;
    self.circleLayer.strokeColor = [UIColor colorWithRed:31/255.f green:140/255.f blue:224/255.f alpha:1.f].CGColor;
    self.circleLayer.lineWidth = strokeLineWidth;
    self.circleLayer.strokeStart = 0.f;
    self.circleLayer.strokeEnd = 0.f;
}
- (void)addLogoImg{
    
    UILabel *logoLab = [[UILabel alloc] init];
    logoLab.frame = CGRectMake(strokeLineWidth/2, strokeLineWidth/2, logoImgSize.width, logoImgSize.height);
    logoLab.backgroundColor = [UIColor colorWithRed:31/255.f green:43/255.f blue:63/255.f alpha:1.f];
    logoLab.layer.cornerRadius = logoImgSize.height/2;
    logoLab.layer.masksToBounds = YES;
    logoLab.text = @"杉德";
    logoLab.textAlignment = NSTextAlignmentCenter;
    logoLab.font = [UIFont systemFontOfSize:40];
    logoLab.textColor = [UIColor colorWithRed:31/255.f green:140/255.f blue:224/255.f alpha:1.f];
    [self addSubview:logoLab];
    
}


- (void)startCircleAnimation{
    
    CABasicAnimation *strokeStartAnimation = [CABasicAnimation animationWithKeyPath:@"strokeStart"];
    strokeStartAnimation.duration = 1.f;
    strokeStartAnimation.repeatCount = 1;
    strokeStartAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
    strokeStartAnimation.fromValue = @(1);
    strokeStartAnimation.toValue = @(0);
    strokeStartAnimation.fillMode = kCAFillModeForwards;
    strokeStartAnimation.removedOnCompletion = NO;
    

    
    CABasicAnimation *strokeEndAnimation = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
    strokeEndAnimation.duration = 1.f;
    strokeEndAnimation.repeatCount = 1;
    strokeEndAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
    strokeEndAnimation.fromValue = @(0.f);
    strokeEndAnimation.toValue = @(1.f);
    strokeEndAnimation.fillMode = kCAFillModeForwards;
    strokeEndAnimation.removedOnCompletion = NO;

    
    CAAnimationGroup *group = [CAAnimationGroup animation];
    group.animations = @[strokeEndAnimation,strokeStartAnimation];
    group.duration = 1;
    group.removedOnCompletion = NO;
    group.repeatCount = MAXFLOAT;
    
    [self.circleLayer addAnimation:group forKey:nil];
    
    
    
}

- (void)stopCircleAnimation{
    
    [self.circleLayer removeAllAnimations];
    [self removeFromSuperview];

}

@end
