//
//  SDBarButton.m
//  SDBarButton
//
//  Created by tianNanYiHao on 2018/1/22.
//  Copyright © 2018年 tianNanYiHao. All rights reserved.
//

#import "SDBarButton.h"
@interface SDBarButton(){
    UIView *shadowView;
    UILabel *midLab;
}

@end



@implementation SDBarButton

- (instancetype)init{
    if ([super init]) {
        
    }return self;
    
}


- (UIView*)createBarButton:(NSString*)str font:(UIFont*)font titleColor:(UIColor*)titleColor backGroundColor:(UIColor*)groundColor leftSpace:(CGFloat)space{
    
    self.btn = [[UIButton alloc] init];
    [self.btn setBackgroundImage:[SDBarButton imageWithColor:groundColor] forState:UIControlStateNormal];
    [self.btn setBackgroundImage:[SDBarButton imageWithColor: [UIColor colorWithRed:53/255.0 green:139/255.0 blue:239/255.0 alpha:1/1.0]] forState:UIControlStateHighlighted];
    
    self.btn.layer.cornerRadius = 5.f;
    self.btn.layer.masksToBounds = YES;
    
    midLab = [[UILabel alloc] init];
    midLab.textAlignment = NSTextAlignmentCenter;
    midLab.textColor = titleColor;
    midLab.alpha = 0.5f;
    midLab.font = font;
    midLab.text = str;
    //防止lab遮挡按钮的点击事件,因此添加其layer - (待验证)
    [self.btn.layer addSublayer:midLab.layer];
    
    //frame
    CGFloat upSpace = ((20/667.f) * ([[UIScreen mainScreen] bounds].size.height));
    CGSize midLabSize = [midLab sizeThatFits:CGSizeZero];
    
    CGFloat selfWidth = [UIScreen mainScreen].bounds.size.width - 2*space;
    CGFloat selfHeight = upSpace*2 + midLabSize.height;
    self.btn.frame = CGRectMake(0, 0, selfWidth, selfHeight);
    
    midLab.frame = CGRectMake(0, 0, midLabSize.width, midLabSize.height);
    midLab.center = self.btn.center;
    
    CALayer *layer = [CALayer layer];
    layer.shadowOpacity = 0.9f;
    layer.shadowOffset = CGSizeMake(1, 3);
    layer.shadowRadius = 7.f;
    layer.shadowColor = [UIColor greenColor].CGColor;
    [self.btn.layer addSublayer:layer];
    
    
    
    //创建阴影
    shadowView = [[UIView alloc] initWithFrame:self.btn.frame];
    shadowView.backgroundColor = [UIColor clearColor];
    shadowView.layer.shadowOpacity = 0.96f;
    shadowView.layer.shadowOffset = CGSizeMake(0, 3);
    shadowView.layer.shadowRadius = 2.f;
    shadowView.layer.shadowOpacity = 0.f;
    shadowView.layer.shadowColor = [UIColor lightGrayColor].CGColor;
    [shadowView addSubview:self.btn];
    
    
    //初始默认不能点击
    [self changeState:NO];
    
    return shadowView;
}

//改变按钮可用状态
- (void)changeState:(BOOL)canClick{
    if (canClick) {
        self.btn.userInteractionEnabled = YES;
        shadowView.layer.shadowOpacity = 1;
        midLab.alpha = 1.f;
    }
    else{
        self.btn.userInteractionEnabled = NO;
        shadowView.layer.shadowOpacity = 0;
        midLab.alpha = 0.5f;
    }
    
    
}


/**
 *@brief 使用颜色创建image
 *@param color  颜色
 *@return 返回UIImage
 */
+ (UIImage *)imageWithColor:(UIColor *)color {
    CGRect rect = CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}
@end
