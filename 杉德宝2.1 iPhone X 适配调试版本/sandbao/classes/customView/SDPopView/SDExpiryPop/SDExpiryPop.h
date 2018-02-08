//
//  SDExpiryPop.h
//  SDpopViewDemo
//
//  Created by tianNanYiHao on 2018/1/29.
//  Copyright © 2018年 tianNanYiHao. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^SDExpiryPopBlock)(NSString *mY);

@interface SDExpiryPop : UIView


+ (void)showExpiryPopView:(SDExpiryPopBlock)block;


@end
