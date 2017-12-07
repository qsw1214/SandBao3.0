//
//  ZCTradeView.h
//
//  Created by Rainer on 15-7-3.
//  Copyright (c) 2014年 Rainer. All rights reserved.
//  交易密码视图\负责整个项目的交易密码输入

#import <UIKit/UIKit.h>

@class ZCTradeKeyboard;

@protocol ZCTradeViewDelegate <NSObject>

@optional
/** 输入完成点击确定按钮 */
- (void)finish:(NSString *)password;

/** 取消按钮点击事件代理 */
- (void)cancelButtonClickAction;

@end

@interface ZCTradeView : UIView

/** 代理方法 */
@property (nonatomic, weak) id<ZCTradeViewDelegate> delegate;

/** 完成的回调block */
@property (nonatomic, copy) void (^finish) (NSString *passWord);

/** 快速创建 */
+ (instancetype)shareTradeView;

/** 弹出密码框 */
- (void)show;

/** 在某个试图上弹出密码框 */
- (void)showInView:(UIView *)view;

/** 隐藏密码框 */
- (void)hiden;

@end