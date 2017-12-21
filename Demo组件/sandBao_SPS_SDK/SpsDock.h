//
//  SdSpsPay.h
//  moniJiuZhangApp
//
//  Created by tianNanYiHao on 2017/8/1.
//  Copyright © 2017年 tianNanYiHao. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol SpsDockDelegate<NSObject>

/**
 sps回调代理

 @param tn tn号
 @param state state [0000 == 成功 ,0001 == 取消 ,0002 == 异常]
 */
- (void)spsReturn:(NSString*)tn state:(NSString*)state;

@end



@interface SpsDock : NSObject

/**
 代理
 */
@property (nonatomic, weak)id<SpsDockDelegate>delegate;


/**
 单例实例化

 @return 实例
 */
+ (SpsDock*)sharedInstance;



/**
 唤起杉德宝,传递订单TN号
 成功:直接打开
 失败:弹出提示/引导进入AppStore下载杉德宝(目前由于未上线,暂时弹出打开失败提示)

 @param tn TN号
 */
- (void)callSps:(NSString*)tn;



/**
 杉德宝完成支付/取消支付后,能否唤起第三方App的判断
 需要在 application:openURL:sourceApplication:annotation:或者application:handleOpenURL中调用
 (1.此方法用于与微博/微信等做区分)
 (2.注意iOS9系统版本之后的系统代理方法)
 
 @param url URL
 @return 会跳成功/失败
 */
- (BOOL)canHandleUrl:(NSURL*)url;



/**
 杉德宝完成支付/取消支付后,回调方法
 (处理杉德宝户端程序通过URL启动第三方应用时传递的数据)
 
 @param url url
 @return 唤起成功/失败
 */
- (BOOL)handleUrl:(NSURL *)url;




@end
