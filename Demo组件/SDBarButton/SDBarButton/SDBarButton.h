//
//  SDBarButton.h
//  SDBarButton
//
//  Created by tianNanYiHao on 2018/1/22.
//  Copyright © 2018年 tianNanYiHao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SDBarButton : UIView


- (UIView*)createBarButton:(NSString*)str font:(UIFont*)font titleColor:(UIColor*)titleColor backGroundColor:(UIColor*)groundColor leftSpace:(CGFloat)space;


- (void)changeState:(BOOL)canClick;


@end
