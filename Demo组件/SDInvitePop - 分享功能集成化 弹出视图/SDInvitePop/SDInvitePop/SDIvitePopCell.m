//
//  SDIvitePopCell.m
//  SDInvitePop
//
//  Created by tianNanYiHao on 2018/1/24.
//  Copyright © 2018年 tianNanYiHao. All rights reserved.
//

#import "SDIvitePopCell.h"


#define AdapterWfloat(f) ((f/375.f)*[UIScreen mainScreen].bounds.size.width)
#define AdapterHfloat(f) ((f/667.f)*[UIScreen mainScreen].bounds.size.height)
#define AdapterFfloat(f) (([[UIScreen mainScreen] bounds].size.height==736.f)?(f):(f*0.8571))

@interface SDIvitePopCell(){
    
    
    
}
@end
@implementation SDIvitePopCell


- (void)createSDIvitePopCell{
    
    UIImage *iconimg = [UIImage imageNamed:self.iconName];
    UIImageView *icon = [[UIImageView alloc] init];
    icon.image = iconimg;
    [self addSubview:icon];
    
    UILabel *label = [[UILabel alloc] init];
    label.frame = CGRectMake(55, 590, 48, 12);
    label.text = @"一二三四三二一";
    label.textAlignment = NSTextAlignmentCenter;
    label.font = [UIFont fontWithName:@"PingFangSC-Regular" size:AdapterFfloat(12)];
    label.textColor = [UIColor colorWithRed:74/255.0 green:74/255.0 blue:74/255.0 alpha:1/1.0];
    [self addSubview:label];
    
    
    CGSize iconSize = iconimg.size;
    CGSize labelSize = [label sizeThatFits:CGSizeZero];
    CGFloat space = AdapterHfloat(10);
    
    
    CGFloat selfW = iconSize.width;
    CGFloat selfH = iconSize.height + space*2 + labelSize.height;
    
    CGFloat iconOX = (selfW - iconSize.width)/2;
    
    self.frame = CGRectMake(0, 0, selfW, selfH);
    icon.frame = CGRectMake(iconOX, space, iconSize.width, iconSize.height);
    label.frame = CGRectMake(0, selfH - labelSize.height, labelSize.width, labelSize.height);
    label.center = CGPointMake(icon.center.x, selfH - labelSize.height/2);
    
    UIButton *coverBtn = [[UIButton alloc] init];
    coverBtn.backgroundColor = [UIColor clearColor];
    coverBtn.frame = CGRectMake(0, 0, selfW, selfH);
    [self addSubview:coverBtn];
    
    
    //重新赋值
    label.text = self.titleName;
    
}


@end
