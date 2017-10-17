//
//  AuthToolBaseView.m
//  AuthToolsDemo2.0
//
//  Created by tianNanYiHao on 2017/10/12.
//  Copyright © 2017年 tianNanYiHao. All rights reserved.
//

#import "AuthToolBaseView.h"

@interface AuthToolBaseView()
{
    CGRect frameRect;
}
@end

@implementation AuthToolBaseView
@synthesize titleLab;
@synthesize textfiled;
@synthesize lineV;
@synthesize tip;
@synthesize leftRightSpace;
@synthesize space;


- (instancetype)initWithFrame:(CGRect)frame{
    if ([super initWithFrame:frame]) {
        frameRect = frame;
        [self createBaseUI];
        
    }
    return self;
}


- (void)createBaseUI{
    
    //title
    titleLab = [[UILabel alloc] init];
    titleLab.text = @"这里是标题";
    titleLab.font =  [UIFont fontWithName:@"PingFang-SC-Medium" size:14];
    titleLab.textColor = [UIColor colorWithRed:52/255.0 green:51/255.0 blue:57/255.0 alpha:1/1.0];
    [self addSubview:titleLab];
    
    //textFiled
    textfiled = [[UITextField alloc] init];
    textfiled.font = [UIFont fontWithName:@"SFUIText-Medium" size:14];
    textfiled.placeholder = @"这里是副标题";
    textfiled.delegate = self;
    textfiled.clearButtonMode = UITextFieldViewModeWhileEditing;
    textfiled.textColor =  [UIColor colorWithRed:52/255.0 green:51/255.0 blue:57/255.0 alpha:1/0.4];
    [self addSubview:textfiled];
    
    
    //line
    lineV = [[UIView alloc] init];
    lineV.backgroundColor = [UIColor colorWithRed:216/255.0 green:216/255.0 blue:216/255.0 alpha:1/1.0];
    [self addSubview:lineV];
    
    
    //frame
    leftRightSpace = 40;
    space = 15.f;
    CGFloat lineH = 0.5f;
    
    CGSize titleLabSize = [titleLab sizeThatFits:CGSizeZero];
    CGSize textfileSize = [textfiled sizeThatFits:CGSizeZero];
    
    
    CGFloat textfiledOY = titleLabSize.height;
    CGFloat textfiledOH = textfileSize.height + 2*space;
    CGFloat lineVOY = textfiledOY + textfiledOH;
    
    titleLab.frame = CGRectMake(leftRightSpace, 0, titleLabSize.width, titleLabSize.height);
    textfiled.frame = CGRectMake(leftRightSpace, textfiledOY,  [UIScreen mainScreen].bounds.size.width-leftRightSpace*2, textfiledOH);
    lineV.frame = CGRectMake(leftRightSpace, lineVOY,  [UIScreen mainScreen].bounds.size.width-leftRightSpace*2, lineH);
    CGFloat selfViewH = lineVOY + lineH;
    self.frame = CGRectMake(frameRect.origin.x, frameRect.origin.y, [UIScreen mainScreen].bounds.size.width, selfViewH);
    
    
    //内置红色tip
    [self addTip];
    
}

- (void)addTip{
    
    tip = [[UILabel alloc] init];
    tip.text = @"这里是红色提示!";
    tip.font = [UIFont fontWithName:@"PingFang-SC-Regular" size:12];
    tip.textColor = [UIColor colorWithRed:242/255.0 green:9/255.0 blue:9/255.0 alpha:1/1.0];
    [self addSubview:tip];
    
    //frame
    CGFloat tipH = [tip sizeThatFits:CGSizeZero].height;
    CGFloat tipOY = CGRectGetMaxY(lineV.frame);
    tip.frame = CGRectMake(leftRightSpace, tipOY, [UIScreen mainScreen].bounds.size.width-leftRightSpace*2, tipH);
    
    tip.alpha = 0.f;
    
    
}

- (void)showTip{
    
    //tip出现
    [UIView animateWithDuration:0.7f animations:^{
        tip.alpha = 1.f;
    } completion:^(BOOL finished) {

        //tip隐藏
        [UIView animateWithDuration:1.f delay:3.f options:UIViewAnimationOptionLayoutSubviews animations:^{
            tip.alpha = 0.f;
        } completion:^(BOOL finished) {
            
        }];
    }];
    
    
}

@end
