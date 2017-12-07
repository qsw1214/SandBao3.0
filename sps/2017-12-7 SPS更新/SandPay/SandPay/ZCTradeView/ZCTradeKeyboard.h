//
//  ZCTradeKeyboard.h
//
//  Created by Rainer on 15-7-3.
//  Copyright (c) 2014年 Rainer. All rights reserved.
//  交易密码键盘

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "UIView+Extension.h"

static NSString *ZCTradeKeyboardDeleteButtonClick = @"ZCTradeKeyboardDeleteButtonClick";
static NSString *ZCTradeKeyboardOkButtonClick = @"ZCTradeKeyboardOkButtonClick";
static NSString *ZCTradeKeyboardNumberButtonClick = @"ZCTradeKeyboardNumberButtonClick";
static NSString *ZCTradeKeyboardNumberKey = @"ZCTradeKeyboardNumberKey";

@class ZCTradeKeyboard;

@protocol ZCTradeKeyboardDelegate <NSObject>

@optional
/** 数字按钮点击 */
- (void)tradeKeyboard:(ZCTradeKeyboard *)keyboard numBtnClick:(NSInteger)num;

/** 删除按钮点击 */
- (void)tradeKeyboardDeleteBtnClick;

/** 确定按钮点击 */
- (void)tradeKeyboardOkBtnClick;

@end

@interface ZCTradeKeyboard : UIView

// 代理
@property (nonatomic, weak) id<ZCTradeKeyboardDelegate> delegate;

@end