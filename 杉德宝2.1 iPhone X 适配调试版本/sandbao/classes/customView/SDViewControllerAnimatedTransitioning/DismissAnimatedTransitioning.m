//
//  DismissAnimatedTransitioning.m
//  PoppingDemo
//
//  Created by tianNanYiHao on 2017/8/7.
//  Copyright © 2017年 tianNanYiHao. All rights reserved.
//

#import "DismissAnimatedTransitioning.h"
#import <POP/POP.h>

@implementation DismissAnimatedTransitioning

-(NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext{
    return 0.5f;
}

-(void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext{
    
    //一.各视图获取
    //获取且出的VC
    UIViewController *toVC = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    toVC.view.tintAdjustmentMode = UIViewTintAdjustmentModeNormal;
    toVC.view.userInteractionEnabled = YES;
    
    //获取切入的VC
    UIViewController *fromVC = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    
    //获取maskView
    __block UIView *maskView;
    //循环遍历子视图
    [transitionContext.containerView.subviews enumerateObjectsUsingBlock:^(UIView *view, NSUInteger idx, BOOL *stop) {
        if (view.layer.opacity<1) {
            maskView = view;
            *stop = YES;
        }
    }];
    
    
    //二.各视图动画
    //opacity
    POPBasicAnimation *maskViewLayeropacityAnimation = [POPBasicAnimation animationWithPropertyNamed:kPOPLayerOpacity];
    maskViewLayeropacityAnimation.toValue = @(0.0);
    
    //rotate
    POPSpringAnimation *roteteAnimation = [POPSpringAnimation animationWithPropertyNamed:kPOPLayerRotation];
    roteteAnimation.toValue = @(5*M_PI);
    
    //scaler
    POPSpringAnimation *scaleAnimation = [POPSpringAnimation animationWithPropertyNamed:kPOPLayerScaleXY];
    scaleAnimation.toValue = [NSValue valueWithCGPoint:CGPointMake(0.1, 0.1)];
    
    
    //opacity
    POPBasicAnimation *opacityAnimation = [POPBasicAnimation animationWithPropertyNamed:kPOPLayerOpacity];
    opacityAnimation.toValue = @(0);
   
    //position
    POPBasicAnimation *positionAniamtion = [POPBasicAnimation animationWithPropertyNamed:kPOPLayerPosition];
    positionAniamtion.toValue = [NSValue valueWithCGPoint:CGPointMake(transitionContext.containerView.frame.size.width, 0)];
    [positionAniamtion setCompletionBlock:^(POPAnimation *anim ,BOOL finished){
        [transitionContext completeTransition:YES];
    }];
    
    [fromVC.view.layer pop_addAnimation:roteteAnimation forKey:@"roteteAnimation"];
    [fromVC.view.layer pop_addAnimation:scaleAnimation forKey:@"scaleAnimation"];
    [fromVC.view.layer pop_addAnimation:positionAniamtion forKey:@"positionAniamtion"];
    [maskView.layer pop_addAnimation:maskViewLayeropacityAnimation forKey:@"maskViewLayeropacityAnimation"];
    [fromVC.view.layer pop_addAnimation:opacityAnimation forKey:@"opacityAnimation"];
    

    
}
@end
