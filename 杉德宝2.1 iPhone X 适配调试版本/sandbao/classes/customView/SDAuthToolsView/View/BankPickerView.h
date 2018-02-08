//
//  BankPickerView.h
//  AuthToolsDemo2.0
//
//  Created by tianNanYiHao on 2017/10/19.
//  Copyright © 2017年 tianNanYiHao. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 回调

 @param bankInfo 数据
 */
typedef void(^BankInfoBlock)(NSArray *bankInfo);

@interface BankPickerView : UIPickerView


/**
 显示pickview

 @param data 需要显示的数据
 @param blockBankInfo 选择后的回调数据
 */
+ (void)showBankPickView:(NSArray*)data blockBankInfo:(BankInfoBlock)blockBankInfo;



@end
