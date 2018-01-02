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
typedef void(^SDAuthorazitionBlock)(NSString *cellName);

@interface SDAuthorazithonPopView : UIView

@property (nonatomic, copy) SDAuthorazitionBlock chooseBlock;


/**
 按钮标题文字
 */
@property (nonatomic, strong) NSArray *chooseBtnTitleArr;


/**
 显示充值pop控件

 @param title 名字
 */
+ (instancetype)showRechargePopView:(NSString*)title rechargeChooseBlock:(SDAuthorazitionBlock)block;


@end
