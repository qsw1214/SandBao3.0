//
//  ZCTradeInputView.h
//
//  Created by Rainer on 15-7-3.
//  Copyright (c) 2014年 Rainer. All rights reserved.
//  交易输入视图

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "UIView+Extension.h"

static NSString *ZCTradeInputViewCancleButtonClick = @"ZCTradeInputViewCancleButtonClick";
static NSString *ZCTradeInputViewOkButtonClick = @"ZCTradeInputViewOkButtonClick";
static NSString *ZCTradeInputViewPwdKey = @"ZCTradeInputViewPwdKey";

@class ZCTradeInputView;

@protocol ZCTradeInputViewDelegate <NSObject>

@optional
/** 确定按钮点击 */
- (void)tradeInputView:(ZCTradeInputView *)tradeInputView okBtnClick:(UIButton *)okBtn withDictionary:(NSDictionary *)dictionarty;
/** 取消按钮点击 */
- (void)tradeInputView:(ZCTradeInputView *)tradeInputView cancleBtnClick:(UIButton *)cancleBtn;

@end

@interface ZCTradeInputView : UIView

@property (nonatomic, weak) id<ZCTradeInputViewDelegate> delegate;

@end