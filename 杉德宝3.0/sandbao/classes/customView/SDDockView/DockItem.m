//
//  DockItem.m
//  weibo
//
//  Created by apple on 13-8-28.
//  Copyright (c) 2013年 itcast. All rights reserved.
//

#define kImageRatio 0.6

#import "DockItem.h"

@implementation DockItem

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // 1.设置文字属性
        self.titleLabel.textAlignment = NSTextAlignmentCenter; // 文字居中
        self.titleLabel.textColor = [UIColor colorWithRed:51/255.0 green:51/255.0 blue:51/255.0 alpha:1];
        [self setTitleColor:[UIColor colorWithRed:51/255.0 green:51/255.0 blue:51/255.0 alpha:1] forState:UIControlStateNormal];

        self.titleLabel.font = [UIFont systemFontOfSize:10];
        
        // 2.设置图片属性
        self.imageView.contentMode = UIViewContentModeBottom;
        self.adjustsImageWhenHighlighted = NO;
        
//        // 3.设置选中时的背景
//        [self setBackgroundImage:[UIImage imageNamed:@"tabbar_slider.png"] forState:UIControlStateSelected];
    }
    return self;
}

#pragma mark 重写父类的方法（覆盖父类在高亮时所作的行为）
- (void)setHighlighted:(BOOL)highlighted {}

#pragma mark 返回是按钮内部UILabel的边框
- (CGRect)titleRectForContentRect:(CGRect)contentRect
{
    CGFloat titleY = contentRect.size.height * kImageRatio - 5;
    CGFloat titleHeight = contentRect.size.height - titleY;
    return CGRectMake(0, titleY, contentRect.size.width, titleHeight);
}

#pragma mark 返回是按钮内部UIImageView的边框
- (CGRect)imageRectForContentRect:(CGRect)contentRect
{
    return CGRectMake(0, 0, contentRect.size.width, contentRect.size.height * kImageRatio);
}

@end
