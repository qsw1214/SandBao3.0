//
//  SetCellView.m
//  sandbao
//
//  Created by tianNanYiHao on 2017/10/30.
//  Copyright © 2017年 sand. All rights reserved.
//

#import "SetCellView.h"

@implementation SetCellView

+ (instancetype)createSetCellViewOY:(CGFloat)OY{
    SetCellView *cell = [[SetCellView alloc] initWithFrame:CGRectMake(0, OY, 0, 0)];
    return cell;
}

- (instancetype)initWithFrame:(CGRect)frame{
    
    if ([super initWithFrame:frame]) {
        self.backgroundColor = [UIColor whiteColor];
        self.titleStr = @"这里是标题";
        self.rightImgStr = @"center_profile_arror_right";
    }
    return self;
    
}

@end
