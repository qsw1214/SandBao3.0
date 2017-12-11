//
//  CardBaseTableView.m
//  sandbao
//
//  Created by tianNanYiHao on 2017/12/11.
//  Copyright © 2017年 sand. All rights reserved.
//

#import "CardBaseTableView.h"

@implementation CardBaseTableView

- (instancetype)init{
    if ([super init]) {
        
    }
    return self;
}

- (void)layoutSubviews{
    [super layoutSubviews];
    
    //iOS11版本以上,自定义删除按钮高度方法:
    if (IOS_VERSION_11) {
        for (UIView *subview in self.subviews)
        {
            if([subview isKindOfClass:NSClassFromString(@"UISwipeActionPullView")])
            {
                UIView *swipeActionPullView = subview;
                //1.0修改背景颜色
                swipeActionPullView.backgroundColor =  [UIColor clearColor];
                //1.1修改背景圆角
                swipeActionPullView.layer.cornerRadius = 5.f;
                swipeActionPullView.layer.masksToBounds = YES;
                
                //2.0修改按钮-颜色
                UIButton *swipeActionStandardBtn = subview.subviews[0];
                if ([swipeActionStandardBtn isKindOfClass:NSClassFromString(@"UISwipeActionStandardButton")]) {
                    
                    CGFloat swipeActionStandardBtnOX = swipeActionStandardBtn.frame.origin.x;
                    CGFloat swipeActionStandardBtnW  = swipeActionStandardBtn.frame.size.width;
                    swipeActionStandardBtn.frame = CGRectMake(swipeActionStandardBtnOX, 10, swipeActionStandardBtnW, self.cellHeight - 10);
                    //2.1修改按钮背景色
                    swipeActionStandardBtn.backgroundColor =  [UIColor colorWithRed:255/255.f green:173/255.f blue:69/255.f alpha:1.0f];
                    //2.2修改按钮背景圆角
                    swipeActionStandardBtn.layer.cornerRadius = 5.f;
                    swipeActionStandardBtn.layer.masksToBounds = YES;
                }
            }
        }
    }
    
}
@end
