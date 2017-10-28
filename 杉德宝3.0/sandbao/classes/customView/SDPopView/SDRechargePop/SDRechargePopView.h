//
//  SDRechargePopView.h
//  sandbao
//
//  Created by tianNanYiHao on 2017/10/27.
//  Copyright © 2017年 sand. All rights reserved.
//

#import <UIKit/UIKit.h>


/**
 选择框点击回调

 @param cellName 选择框名
 */
typedef void(^SDRechargePopChooseBlock)(NSString *cellName);

@interface SDRechargePopView : UIView

@property (nonatomic, copy) SDRechargePopChooseBlock chooseBlock;
/**
 显示控件

 @param title 名字
 @param listArray 列表名
 */
+ (void)showRechargePopView:(NSString*)title chooseList:(NSArray*)listArray rechargeChooseBlock:(SDRechargePopChooseBlock)block;


@end
