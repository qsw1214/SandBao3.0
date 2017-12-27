//
//  SDSelectBarView.h
//  SDSelectBarView2
//
//  Created by tianNanYiHao on 2017/12/26.
//  Copyright © 2017年 tianNanYiHao. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SDSelectBarDelegate<NSObject>

- (void)selectBarClick:(NSInteger)index;

@end

@interface SDSelectBarView : UIView

@property (nonatomic, weak)id<SDSelectBarDelegate>delegate;


@end
