//
//  GradualView.h
//  sandbao
//
//  Created by tianNanYiHao on 2017/3/14.
//  Copyright © 2017年 sand. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger,GradualColor) {
    
    GradualColorBlue = 1,
    GradualColorRed
};

@interface GradualView : UIView

@property (nonatomic,assign)CGRect rect;

/**
 样式
 */
@property (nonatomic, assign) GradualColor colorStyle;

@end
