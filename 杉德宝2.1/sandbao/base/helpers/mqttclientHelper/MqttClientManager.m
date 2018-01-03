//
//  MqttClientManager.m
//  sandbao
//
//  Created by tianNanYiHao on 2017/5/3.
//  Copyright © 2017年 sand. All rights reserved.
//

#import "MqttClientManager.h"
#import "MqttClientManagerDelegate.h"
#import "MqttStatus.h"
#import "MQTTClient.h"
#import <UIKit/UIDevice.h>

@interface MqttClientManager ()<MqttClientManagerDelegate,MQTTSessionDelegate>
{
    BOOL applogout; //手动退出后 不需要重新连接MQTT
}
@property(nonatomic, weak)      id<MqttClientManagerDelegate> delegate;//代理
@property(nonatomic, strong)    MQTTSession *mqttSession;
@property(nonatomic, strong)    MQTTCFSocketTransport *transport;//连接服务器属性
@property(nonatomic, strong)    NSString *ip;//服务器ip地址
@property(nonatomic)            UInt16 port;//服务器ip地址
@property(nonatomic, strong)    NSString *userName;//用户名
@property(nonatomic, strong)    NSString *password;//密码
@property(nonatomic, strong)    NSString *topic;//单个主题订阅
@property(nonatomic, strong)    NSDictionary *topics;//多个主题订阅
@property(nonatomic, strong)    MqttStatus *mqttStatus;//连接服务器状态

@end

@implementation MqttClientManager

#pragma mark 懒加载
-(MQTTSession *)mqttSession{
    if (!_mqttSession) {
        /*app包名+|iOS|+设备信息作为连接id确保唯一性*/
        NSString *clientID = [CommParameter sharedInstance].sToken;
        [SDLog logTest:[NSString stringWithFormat:@"-----------------MQTT连接的ClientID\n%@",clientID]];
        _mqttSession=[[MQTTSession alloc] initWithClientId:clientID];
    }
    return _mqttSession;
}

-(MQTTCFSocketTransport *)transport{
    if (!_transport) {
        _transport=[[MQTTCFSocketTransport alloc] init];
    }
    return _transport;
}

-(MqttStatus *)mqttStatus{
    if (!_mqttStatus) {
        _mqttStatus=[[MqttStatus alloc] init];
    }
    return _mqttStatus;
}

#pragma mark 对外方法
/**
 单例
 
 @return self
 */
+(MqttClientManager *)shareInstance{
    static id instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance=[[self alloc] init];
    });
    return instance;
}

/**
 MQTT登陆，订阅单个主题
 
 @param ip 服务器ip
 @param port 服务器端口
 @param userName 用户名
 @param password 密码
 @param topic 订阅的主题，可以订阅的主题与账户是相关联的，例：@"mqtt/test"
 */
-(void)loginWithIp:(NSString *)ip port:(UInt16)port userName:(NSString *)userName password:(NSString *)password topic:(NSString *)topic{
    self.topic=topic;
    [self loginWithIp:ip port:port userName:userName password:password];
}

/**
 MQTT登陆，订阅多个主题
 
 @param ip 服务器ip
 @param port 服务器端口
 @param userName 用户名
 @param password 密码
 @param topics 订阅的主题，可以订阅的主题与账户是相关联的，例：@{@"mqtt/test":@"mqtt/test",@"mqtt/test1":@"mqtt/test1"}
 */
-(void)loginWithIp:(NSString *)ip port:(UInt16)port userName:(NSString *)userName password:(NSString *)password topics:(NSDictionary *)topics{
    self.topics=topics;
    [self loginWithIp:ip port:port userName:userName password:password];
}


-(void)loginWithIp:(NSString *)ip port:(UInt16)port userName:(NSString *)userName password:(NSString *)password {
    self.ip=ip;
    self.port=port;
    self.userName=userName;
    self.password=password;
    
    [self loginMQTT];
    
}
/*实际登陆处理*/
-(void)loginMQTT{

    
    /*设置ip和端口号*/
    self.transport.host = _ip;
    self.transport.port = _port;

    /*设置MQTT账号和密码*/
    self.mqttSession.transport = self.transport;//给MQTTSession对象设置基本信息
    self.mqttSession.delegate = self;//设置代理
    [self.mqttSession setUserName:_userName];
    [self.mqttSession setPassword:_password];
    
    
    //    //心跳时间，单位秒，每隔固定时间发送心跳包
    self.mqttSession.keepAliveInterval = 10;
    
//    self.mqttSession.cleanSessionFlag = false;
    
//    //    //确保消息送达?
//    self.mqttSession.willQoS = MQTTQosLevelAtMostOnce;
//    
    
    
    //会话链接并设置超时时间(最后设置,否则代理不会执行)
    //网络情况不好时,建议设置超时时间小一点
    [self.mqttSession connectAndWaitTimeout:1];
    

}
/**
 断开连接，清空数据
 */
-(void)close:(BOOL)Applogout{
    //手动退出后 不需要重新连接MQTT
    applogout = Applogout;
    
    [_mqttSession close];
    
    _delegate=nil;//代理
    _mqttSession=nil;
    _transport=nil;//连接服务器属性
    _ip=nil;//服务器ip地址
    _port=0;//服务器ip地址
    _userName=nil;//用户名
    _password=nil;//密码
    _topic=nil;//单个主题订阅
    _topics=nil;//多个主题订阅
}

/**
 注册代理
 
 @param obj 需要实现代理的对象
 */
-(void)registerDelegate:(id)obj{
    self.delegate=obj;
}


/**
 解除代理
 
 @param obj 需要接触代理的对象
 */
-(void)unRegisterDelegate:(id)obj{
    self.delegate=nil;
}

#pragma mark MQTTClientManagerDelegate
/*连接成功回调*/
-(void)connected:(MQTTSession *)session{
    
    if (_topic) {
        [SDLog logTest:@"-----------------MQTT订阅单个主题-----------------"];
        dispatch_async(dispatch_get_main_queue(), ^{
            // [self.mqttSession subscribeTopic:_topic];
            [self.mqttSession subscribeToTopic:_topic atLevel:MQTTQosLevelAtLeastOnce];
        });
    }
    else if(_topics){
        [SDLog logTest:@"-----------------MQTT订阅多个个主题-----------------"];
        dispatch_async(dispatch_get_main_queue(), ^{
            //[self.mqttSession subscribeTopic:_topic];
            [self.mqttSession subscribeToTopic:_topic atLevel:MQTTQosLevelAtLeastOnce];
        });
    }
}


/*连接状态回调*/
-(void)handleEvent:(MQTTSession *)session event:(MQTTSessionEvent)eventCode error:(NSError *)error{
 
    NSDictionary *events = @{
                             @(MQTTSessionEventConnected): @"connected",
                             @(MQTTSessionEventConnectionRefused): @"connection refused",
                             @(MQTTSessionEventConnectionClosed): @"connection closed",
                             @(MQTTSessionEventConnectionError): @"connection error",
                             @(MQTTSessionEventProtocolError): @"protocoll error",
                             @(MQTTSessionEventConnectionClosedByBroker): @"connection closed by broker"
                             };

    [SDLog logTest:[NSString stringWithFormat:@"-----------------MQTT连接状态-----------------\n%@",[events objectForKey:@(eventCode)]]];
    
    
    [self.mqttStatus setStatusCode:eventCode];
    [self.mqttStatus setStatusInfo:[events objectForKey:@(eventCode)]];
    if (self.delegate&&[self.delegate respondsToSelector:@selector(didMQTTReceiveServerStatus:)]) {
        [self.delegate didMQTTReceiveServerStatus:self.mqttStatus];
    }
    
    
    
    
    //1.Closed目前情况看不管什么错误都会通知，再和实际的错误通知一起就等于通知了2次
    if (eventCode == MQTTSessionEventConnectionClosed) {
        //所以do nothing
    }
    //2.实际错误处理
    if (eventCode == MQTTSessionEventConnectionError || eventCode == MQTTSessionEventProtocolError || eventCode == MQTTSessionEventConnectionClosedByBroker) {
        //手动退出后 不需要重新连接MQTT
        if (applogout) {
            return;
        }
        //延迟重登，避免mqtt缓冲区处理不及时崩溃
        [self performSelector:@selector(loginMQTT) withObject:nil afterDelay:0.5];
    }
    
}


/*收到消息*/
-(void)newMessage:(MQTTSession *)session data:(NSData *)data onTopic:(NSString *)topic qos:(MQTTQosLevel)qos retained:(BOOL)retained mid:(unsigned int)mid{
    NSString *jsonStr=[NSString stringWithUTF8String:data.bytes];
    [SDLog logTest:[NSString stringWithFormat:@"-----------------MQTT收到消息主题：%@内容：%@",topic,jsonStr]];
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
    
    if (self.delegate&&[self.delegate respondsToSelector:@selector(messageTopic:data:)]) {
        [self.delegate messageTopic:topic data:dic];
    }
    if (self.delegate&&[self.delegate respondsToSelector:@selector(messageTopic:jsonStr:)]) {
        [self.delegate messageTopic:topic jsonStr:jsonStr];
    }
}

@end
