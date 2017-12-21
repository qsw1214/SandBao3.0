//
//  IdentityDetailCellView.m
//  sandbao
//
//  Created by tianNanYiHao on 2017/11/17.
//  Copyright © 2017年 sand. All rights reserved.
//

#import "IdentityDetailCellView.h"
#define AdapterFfloat(f) (([[UIScreen mainScreen] bounds].size.height==736.f)?(f):(f*0.8571))
@implementation IdentityDetailCellView


+ (instancetype)createSetCellViewOY:(CGFloat)OY{
    
    IdentityDetailCellView *cell = [[IdentityDetailCellView alloc] initWithFrame:CGRectMake(0, OY, 0, 0)];
    return cell;
    
}

- (instancetype)initWithFrame:(CGRect)frame{
    
    if ([super initWithFrame:frame]) {
        self.titleStr = @"这里是标题";
    }
    return self;

}

- (void)setRightStr:(NSString *)rightStr{
    
    
    _rightStr = rightStr;
    UILabel *rightLab = [[UILabel alloc] init];
    rightLab.text = _rightStr;
    rightLab.numberOfLines = 0;
    rightLab.textAlignment = NSTextAlignmentRight;
    rightLab.font = [UIFont fontWithName:@"PingFangSC-Regular" size:AdapterFfloat(13)];
    rightLab.textColor = [UIColor colorWithRed:52/255.0 green:51/255.0 blue:57/255.0 alpha:1/1.0];
    [self insertSubview:rightLab atIndex:1];
    
    CGFloat rightLabRealWidth = [self.titleLab sizeThatFits:CGSizeZero].width;
    
    CGSize rightLabSize = [rightLab sizeThatFits:CGSizeZero];
    
    CGFloat rightLabWidth;
    
    CGFloat rightLabOX = self.titleLab.frame.origin.x + rightLabRealWidth;
    CGFloat rightLabOY = self.titleLab.frame.origin.y;
    
    if (!self.rightImgStr) {
        
        rightLabWidth = [UIScreen mainScreen].bounds.size.width - rightLabRealWidth - 2*self.leftRightSpace;
    }else{
        rightLabWidth = [UIScreen mainScreen].bounds.size.width - rightLabRealWidth - 2*self.leftRightSpace - self.rightImgView.frame.size.width - 10;
    }
    rightLab.frame = CGRectMake(rightLabOX, rightLabOY, rightLabWidth, rightLabSize.height);
    
}

@end
