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
    titleLab.font =  [UIFont fontWithName:@"PingFang-SC-Medium" size:17];
    titleLab.textColor = [UIColor colorWithRed:52/255.0 green:51/255.0 blue:57/255.0 alpha:1/1.0];
    [self addSubview:titleLab];
    
    //textFiled
    textfiled = [[UITextField alloc] init];
    textfiled.font = [UIFont fontWithName:@"PingFang-SC-Regular" size:17];
    textfiled.placeholder = @"这里是副标题";
    textfiled.clearButtonMode = UITextFieldViewModeWhileEditing;
    textfiled.textColor =  [UIColor colorWithRed:52/255.0 green:51/255.0 blue:57/255.0 alpha:1/0.4];
    [self addSubview:textfiled];
    
    
    //line
    UIView *lineV = [[UIView alloc] init];
    lineV.backgroundColor = [UIColor colorWithRed:216/255.0 green:216/255.0 blue:216/255.0 alpha:1/1.0];
    [self addSubview:lineV];
    
    
    //frame
    leftRightSpace = 40;
    space = 15.f;
    CGFloat lineH = 0.5f;
    
    CGSize titleLabSize = [titleLab sizeThatFits:CGSizeZero];
    CGSize textfileSize = [textfiled sizeThatFits:CGSizeZero];
    
    CGFloat textfiledOY = titleLabSize.height + space;
    CGFloat lineVOY = textfiledOY + textfileSize.height + space;
    
    titleLab.frame = CGRectMake(leftRightSpace, 0, titleLabSize.width, titleLabSize.height);
    textfiled.frame = CGRectMake(leftRightSpace, textfiledOY,  [UIScreen mainScreen].bounds.size.width-leftRightSpace*2, textfileSize.height);
    lineV.frame = CGRectMake(leftRightSpace, lineVOY,  [UIScreen mainScreen].bounds.size.width-leftRightSpace*2, lineH);
    CGFloat selfViewH = lineVOY + lineH;
    self.frame = CGRectMake(frameRect.origin.x, frameRect.origin.y, [UIScreen mainScreen].bounds.size.width, selfViewH);
    
    
    
    
    
}


@end
