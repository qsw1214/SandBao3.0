//
//  viewLLL.h
//  yuabingLayer
//
//  Created by tianNanYiHao on 2017/3/16.
//  Copyright © 2017年 tianNanYiHao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SDCircleView : UIView


/**
 创建圆饼
 
 @param frame 宽为屏幕宽
 @param offset 偏移量
 @param numberArr 金额数组
 @param colorArr 颜色数组
 @return self
 */
-(instancetype)initWithFrame:(CGRect)frame offset:(CGFloat)offset numberArray:(NSArray*)numberArr colorArray:(NSArray*)colorArr;





/**
 刷新数据

 @param numberArr 数据数组
 */
-(void)sdCircleViewSetNumberArrayDate:(NSArray*)numberArr;



@end
