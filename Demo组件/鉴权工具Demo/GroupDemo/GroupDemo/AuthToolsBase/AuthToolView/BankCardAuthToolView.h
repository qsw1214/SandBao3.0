//
//  BankCardAuthToolView.h
//  GroupDemo
//
//  Created by tianNanYiHao on 2017/4/8.
//  Copyright © 2017年 tianNanYiHao. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef enum {
    BankCardAuthToolViewStyleNo,
    BankCardAuthToolViewStyleYes
}BankCardAuthToolViewStyle;


@interface BankCardAuthToolView : UIView
//银行卡验证
@property (nonatomic, strong) UILabel *bankNameContentVerificationLabel;
@property (nonatomic, strong) UITextField *bankCardVerificationTextField;

/**
 鉴权工具样式
 */
@property (nonatomic) BankCardAuthToolViewStyle viewStyle;

/**
 鉴权提示文字
 */
@property (nonatomic, strong) NSString *tipString;

/**
 鉴权提示是否显示
 */
@property (nonatomic, assign) BOOL tipShow;

/**
 底部白色view是否显示
 */
@property (nonatomic, assign) BOOL bottomShow;



/**
 初始化
 */
-(instancetype)init;



/**
 *@brief 银行卡验证
 *@return CGFloat
 */
- (CGFloat)bankCardVerification;



@end
