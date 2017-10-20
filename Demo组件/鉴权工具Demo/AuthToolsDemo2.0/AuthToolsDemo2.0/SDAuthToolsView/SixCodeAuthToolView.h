//
//  SixCodeAuthToolView.h
//  AuthToolsDemo2.0
//
//  Created by tianNanYiHao on 2017/10/13.
//  Copyright © 2017年 tianNanYiHao. All rights reserved.
//

#import "AuthToolBaseView.h"

/**
 输入框内容通过回调
 */
typedef void(^TextSuccessBlock)();


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
 block-返回sixCodeAuthTool的文本信息
 */
@property (nonatomic, copy) TextSuccessBlock successBlock;


/**
 block-返回短信码重发请求的回调
 */
@property (nonatomic, copy) TextSuccessBlock successRequestBlock;



@end
