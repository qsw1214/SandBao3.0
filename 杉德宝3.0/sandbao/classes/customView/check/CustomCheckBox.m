//
//  CustomCheckBox.m
//  collectionTreasure
//
//  Created by tianNanYiHao on 15/7/2.
//  Copyright (c) 2015年 sand. All rights reserved.
//

#import "CustomCheckBox.h"

@interface CustomCheckBox()
{
    CGRect mframe;
}

@end

@implementation CustomCheckBox

- (id)initWithFrame:(CGRect)frame
    {
        self = [super initWithFrame:frame];
        if (self) {
            self.backgroundColor = [UIColor clearColor];
            mframe = frame;
        }
        return self;
    }

- (void)setTitle:(NSString *)newTitle
{
    _title = newTitle;
}

- (NSString *)title
{
    [super initWithFrame:mframe];
    return _title;
}

- (void)setCheckImage:(UIImage *)newCheckImage
{
    _checkImage = newCheckImage;
}

- (UIImage *)checkImage
{
    [super initWithFrame:mframe];
    return _checkImage;
}

- (void)setNormalImage:(UIImage *)newNormalImage
{
    _normalImage = newNormalImage;
}

- (UIImage *)normalImage
{
    [super initWithFrame:mframe];
    return _normalImage;
}

- (void)setFont:(UIFont *)newFont
{
    _font = newFont;
}

- (UIFont *)font
{
    [super initWithFrame:mframe];
    return _font;
}

- (void)setTitleColor:(UIColor *)newTitleColor
{
    
    _titleColor = newTitleColor;
}

- (UIColor *)titleColor
{
    [super initWithFrame:mframe];
    return _titleColor;
}

- (void)setChecked:(BOOL)checked
{
    _checked = checked;
    //注册代理事件，通知状态改变
    if ([self.delegate respondsToSelector:@selector(onChangeDelegate:isCheck:)]) {
        [self.delegate onChangeDelegate:self isCheck:_checked];
    }
    [self setNeedsDisplay];
}

- (void)drawRect:(CGRect)rect
{
    UIImage *image = self.checked?_checkImage:_normalImage;
    CGFloat imageOX = 0;
    CGFloat imageOY = 0;
    CGFloat textOX = 0;
    CGFloat textOY = 0;
    
    imageOX = (rect.size.width - image.size.width) / 2;
    imageOY = rect.size.height / 2 - image.size.height - 2.5 ;
    
    [image drawAtPoint:CGPointMake(imageOX, imageOY)];
    
    if (_font) {
        _font = [UIFont systemFontOfSize:12];
    }
    
    NSDictionary *attrs = @{NSFontAttributeName : _font};
    CGSize size = [_title sizeWithAttributes:attrs];
    
    textOX = (rect.size.width - size.width) / 2;
    textOY = rect.size.height / 2 + 2.5;
    [_titleColor setFill];
    [_title drawAtPoint:CGPointMake(textOX, textOY) withFont:_font];
}

//点击事件
- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    self.checked = !self.checked;
}

@end
