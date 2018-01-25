//
//  SDMQTTManager.h
//  MQTTManagerDemo
//
//  Created by tianNanYiHao on 2018/1/3.
//  Copyright © 2018年 tianNanYiHao. All rights reserved.
//

#import <Foundation/Foundation.h>
/*
 * MQTTClient: imports
 * MQTTSessionManager.h is optional
 * 基于MQTTClient,自动管理断线重连
 */
#import <MQTTClient/MQTTClient.h>
#import <MQTTClient/MQTTSessionManager.h>

@protocol SDMQTTManagerDelegate<NSObject>

@required
/**
 订阅消息回调

 @param toPic 订阅消息类型
 @param dic 回调报文
 */
- (void)messageTopic:(NSString*)toPic dataDic:(NSDictionary*)dic;

@end

@interface SDMQTTManager : NSObject


@property (nonatomic, weak) id<SDMQTTManagerDelegate>delegate;

/**
 单例实例化

 @return 实例
 */
+ (instancetype)shareMQttManager;


/**
 登录MQTT

 @param clientID sToken
 */
- (void)loginMQTT:(NSString *)clientID;

/**
 订阅单条广播

 @param topic 广播URL
 @param qosLevel 接受消息级别 
 */
- (void)subscaribeTopic:(NSString*)topic atLevel:(MQTTQosLevel)qosLevel;


/**
 mqtt关闭
 */
- (void)closeMQTT;

@end
