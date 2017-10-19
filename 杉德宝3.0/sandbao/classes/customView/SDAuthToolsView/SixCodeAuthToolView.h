//
//  SixCodeAuthToolView.h
//  AuthToolsDemo2.0
//
//  Created by tianNanYiHao on 2017/10/13.
//  Copyright © 2017年 tianNanYiHao. All rights reserved.
//

#import "AuthToolBaseView.h"


/**
 短信码回调

 @param codeStr 6位短信码字符串
 */
typedef void(^SmsCodeStrBlock)(NSString * codeStr);

/**
 重复短信事件回调  
 */
typedef void(^SmsRequestBlock)();


/**
 支付密码回调

 @param codeStr 6位支付密码字符串
 */
typedef void(^PayCodeStrBlock)(NSString *codeStr);

/**
 六位字符码鉴权视图样式
 
 - SmsCodeAuthTool: 短信模式
 - PayCodeAuthTool: 密码模式
 */
typedef NS_ENUM(NSInteger,CodeAuthToolStyle){
    SmsCodeAuthTool = 0,
    PayCodeAuthTool,
};

@interface SixCodeAuthToolView : AuthToolBaseView


/**
 控件类型:sms短信模式/pay密码模式
 */
@property (nonatomic, assign) CodeAuthToolStyle style;


/**
 block-返回输入的六位短信字符码
 */
@property (nonatomic, copy) SmsCodeStrBlock smsCodeStrBlock;


/**
 block-回调在此发送短信码的请求标识
 */
@property (nonatomic, copy) SmsRequestBlock smsRequestBlock;


/**
 block-返回输入的六位支付密码
 */
@property (nonatomic, copy) PayCodeStrBlock payCodeStrBlock;


@end
