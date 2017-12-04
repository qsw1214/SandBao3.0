//
//  MqttStatus.h
//  sandbao
//
//  Created by tianNanYiHao on 2017/5/3.
//  Copyright © 2017年 sand. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MQTTClient.h"

@interface MqttStatus : NSObject

//状态
@property(nonatomic,assign) MQTTSessionEvent statusCode;
//状态信息
@property(nonatomic,copy)  NSString *statusInfo;

@end
