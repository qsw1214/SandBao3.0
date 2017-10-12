//
//  SDAlertControllerUtil.h
//  UIControlAlertSheet
//
//  Created by tianNanYiHao on 2017/9/1.
//  Copyright © 2017年 tianNanYiHao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef void(^SDAlertControllerActionBlock)(NSInteger index);

@interface SDAlertControllerUtil : NSObject


/**
 ActionSheet模式下弹框
 PSTAlertControllerStyleActionSheet 模式
 @param title 标题
 @param message 消息
 @param actionArray 功能数组
 @param viewController 从该控制器的弹出
 @param actionBlock 回调代码块
 */
+ (void)showAlertControllerWihtTitle:(NSString*)title message:(NSString*)message actionArray:(NSArray*)actionArray presentedViewController:(UIViewController*)viewController actionBlock:(SDAlertControllerActionBlock)actionBlock;


+ (void)showAlertControllerDefult:(NSString*)title actionBlock:(SDAlertControllerActionBlock)actionBlock;


@end
