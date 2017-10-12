//
//  SmsAuthToolView.h
//  GroupDemo
//
//  Created by tianNanYiHao on 2017/4/8.
//  Copyright © 2017年 tianNanYiHao. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum {
    SmsAuthToolViewStyleNo,
    SmsAuthToolViewStyleYes
}SmsAuthToolViewStyle;

@protocol SmsAuthToolViewDelegate <NSObject>


@end

@interface SmsAuthToolView : UIView

//手机号验证
@property (nonatomic, strong) UITextField *phoneNumVerificationTextField;
//短信验证
@property (nonatomic, strong) UITextField *shortMsgVerificationTextField;
@property (nonatomic, strong) UIButton *shortMsgVerificationBtn;

/**
 鉴权工具样式
 */
@property (nonatomic) SmsAuthToolViewStyle viewStyle;

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
 *@brief 短信+手机号 验证
 *@return CGFloat
 */
- (CGFloat)shortMsgAndPhoneNumVerification;


@end
