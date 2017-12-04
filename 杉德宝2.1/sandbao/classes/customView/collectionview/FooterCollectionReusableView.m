//
//  FooterCollectionReusableView.m
//  sandbaocontrol
//
//  Created by tianNanYiHao on 2016/11/2.
//  Copyright © 2016年 sand. All rights reserved.
//

#import "FooterCollectionReusableView.h"

@interface FooterCollectionReusableView ()

@property (nonatomic, strong) UIView *bottomView;
@property (nonatomic, strong) UIView *topView;

@end

@implementation FooterCollectionReusableView

@synthesize bottomView;
@synthesize topView;

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, self.bounds.size.height - 1, self.bounds.size.width, 1)];
        bottomView.backgroundColor = [UIColor colorWithWhite:0.9 alpha:1];
        [self addSubview:bottomView];
        
    }
    return self;
}
- (UIView *)topView {
    if (topView == nil) {
        self.topView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.bounds.size.width, 1)];
        self.topView.backgroundColor = [UIColor colorWithWhite:0.9 alpha:1];
    }
    return topView;
}

- (void)setIsShowTopLine:(BOOL)isShowTopLine {
    if (isShowTopLine) {
        [self addSubview:topView];
    }else {
        [topView removeFromSuperview];
    }
    
}

@end
