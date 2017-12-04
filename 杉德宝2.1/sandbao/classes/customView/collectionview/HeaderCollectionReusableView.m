//
//  HeaderCollectionReusableView.m
//  sandbaocontrol
//
//  Created by tianNanYiHao on 2016/11/2.
//  Copyright © 2016年 sand. All rights reserved.
//

#import "HeaderCollectionReusableView.h"

@interface HeaderCollectionReusableView()

@property (nonatomic, strong) UILabel *label;
@property (nonatomic, strong) UITextView *messageView;

@end

@implementation HeaderCollectionReusableView

@synthesize label;
@synthesize messageView;


- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        label = [[UILabel alloc] init];
        label.font = [UIFont systemFontOfSize:15];
        label.tag = 2000;
        [self addSubview:label];
        self.backgroundColor = [UIColor whiteColor];
        
        CGFloat labelOX = 10;
        CGFloat labelOY = 5;
        CGFloat labelW = self.bounds.size.width - 2 * labelOX;
        CGSize labelSize = [label sizeThatFits:CGSizeMake(labelW, MAXFLOAT)];
        CGFloat labelH = labelSize.height + 10;
        label.frame = CGRectMake(labelOX, labelOY, labelW, labelH);
    }
    return self;
}


- (void)setTitle:(NSString *)title {
    self.label.text = title;
}


- (void)setIsShowMessage:(BOOL)isShowMessage {
    if (isShowMessage) {
        [self addSubview:messageView];
    }else {
        [messageView removeFromSuperview];
    }
    
}

- (UITextView *)messageView {
    if (messageView == nil) {
        self.messageView = [[UITextView alloc] init];
        self.messageView.textAlignment = NSTextAlignmentCenter;
        self.messageView.text = @"您还为添加任何应用\n长按下面的应用可以添加";
        self.messageView.font = [UIFont systemFontOfSize:12];
        
        CGFloat messageViewOX = 0;
        CGFloat messageViewOY = CGRectGetMaxY(label.frame);
        CGFloat messageViewW = self.bounds.size.width - 2 * 10;
        CGSize messageViewSize = [messageView sizeThatFits:CGSizeMake(messageViewW, MAXFLOAT)];
        CGFloat messageViewH = messageViewSize.height + 10;
        messageView.frame = CGRectMake(messageViewOX, messageViewOY, messageViewW, messageViewH);
    }
    return messageView;
}

@end
