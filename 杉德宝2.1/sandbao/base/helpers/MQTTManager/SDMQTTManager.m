//
//  SDMQTTManager.m
//  MQTTManagerDemo
//
//  Created by tianNanYiHao on 2018/1/3.
//  Copyright © 2018年 tianNanYiHao. All rights reserved.
//

#import "SDMQTTManager.h"

@interface SDMQTTManager()<MQTTSessionDelegate,MQTTSessionManagerDelegate>{
    
}
/*
 * MQTTClient: keep a strong reference to your MQTTSessionManager here
 */
@property (strong, nonatomic) MQTTSessionManager *manager;

@end


static SDMQTTManager *mqttManager = nil;
@implementation SDMQTTManager

/**
 单例实例化

 @return 封装的实例
 */
+ (instancetype)shareMQttManager{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        mqttManager = [[SDMQTTManager alloc] init];
    });
    return mqttManager;
}

+ (instancetype)allocWithZone:(struct _NSZone *)zone{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        mqttManager = [super allocWithZone:zone];
    });
    return mqttManager;
}

- (instancetype)init{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if ([super init]) {
            
        }
    });
    return self;
}

//连接MQTT
- (void)linkMQTT:(NSString*)clientID{
    
    if (!self.manager) {
        self.manager = [[MQTTSessionManager alloc] init];
        self.manager.delegate = self;
        [self.manager connectTo:kIP
                           port:kPort
                            tls:false
                      keepalive:30
                          clean:true   //session是否清除，这个需要注意，如果是false，代表保持登录，如果客户端离线了再次登录就可以接收到离线消息。注意：QoS为1和QoS为2，并需订阅和发送一致
                           auth:true
                           user:kMqttuserNmae
                           pass:kMqttpasswd
                      willTopic:@""
                           will:[@"offline" dataUsingEncoding:NSUTF8StringEncoding]
                        willQos:MQTTQosLevelExactlyOnce
                 willRetainFlag:false
                   withClientId:clientID];
    } else {
        self.manager.session.clientId = clientID;
        [self.manager connectToLast];
    }
    
    /*
     * MQTTCLient: observe the MQTTSessionManager's state to display the connection status
     */
    [self.manager addObserver:self
                   forKeyPath:@"state"
                      options:NSKeyValueObservingOptionInitial | NSKeyValueObservingOptionNew
                      context:nil];
    
}



/**
 登录MQTT

 @param clientID sToken
 */
- (void)loginMQTT:(NSString *)clientID{
    if (clientID.length>0) {
        [self linkMQTT:clientID];
    }
}

/**
 关闭MQTT
 */
- (void)closeMQTT{
    
    //避免删除kvo异常
    @try{
        //清除kvo监听
        [self.manager removeObserver:self forKeyPath:@"state"];
    }
    @catch(NSException *exception){
        
    }
    
    //关闭连接 - 触发监听(有可能关成功,测试出有关失败的可能)
    [self.manager disconnect];
    
}

/**
 MQTT状态的消息监听(kvo)

 @param keyPath path
 @param object object description
 @param change change description
 @param context context description
 */
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    switch (self.manager.state) {
        case MQTTSessionManagerStateClosed://连接已经关闭
            NSLog(@"-------- MQTT连接已经关闭 --------");
            break;
        case MQTTSessionManagerStateClosing://连接正在关闭
            NSLog(@"-------- MQTT连接正在关闭 --------");
            break;
        case MQTTSessionManagerStateConnected://已经连接
            NSLog(@"-------- MQTT已经连接 --------");
            break;
        case MQTTSessionManagerStateConnecting://正在连接中
            NSLog(@"-------- MQTT正在连接中 --------");
            break;
        case MQTTSessionManagerStateError://连接异常
            NSLog(@"-------- MQTT连接异常--------");
            break;
        case MQTTSessionManagerStateStarting://开始连接
        default:
            NSLog(@"-------- MQTT未连接 --------");
            break;
    }
}



/**
 订阅一条消息
 
 @param topic 订阅URL
 @param qosLevel 消息接收级别
 */
- (void)subscaribeTopic:(NSString *)topic atLevel:(MQTTQosLevel)qosLevel{
    
    self.manager.subscriptions = [NSDictionary dictionaryWithObject:[NSNumber numberWithInt:qosLevel] forKey:topic];
}


#pragma mark - MQTTSessionManagerDelegate
/**
 订阅消息回调

 @param data data
 @param topic 主题
 @param retained 服务器是否保留数据
 */
- (void)handleMessage:(NSData *)data onTopic:(NSString *)topic retained:(BOOL)retained{
    /*
     * MQTTClient: process received message
     */
    NSString *jsonStr=[NSString stringWithUTF8String:data.bytes];
    NSLog(@"%@",[NSString stringWithFormat:@"-----------------MQTT收到消息主题：%@内容：%@",topic,jsonStr]);
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
    if ([SDMQTTManager shareMQttManager].delegate && [[SDMQTTManager shareMQttManager].delegate respondsToSelector:@selector(messageTopic:dataDic:)]) {
        [[SDMQTTManager shareMQttManager].delegate messageTopic:topic dataDic:dic];
    }
    
}



@end

