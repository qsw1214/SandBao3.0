//
//  NetworkProcess.h
//  sand_bluesky_demonstration
//
//  Created by blue sky on 15/4/25.
//  Copyright (c) 2015年 sand. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Document.h"

@interface NetworkProcess : NSObject{
    
    // 请求返回码
    int _respCode;
    //请求返回信息
    NSString *_respResult;
    
    BOOL _logFlag;
}

- (void)setRespCode:(int)newRespCode;
- (int)respCode;

- (void)setRespResult:(NSString *)newRespResult;
- (NSString *)respResult;

- (void)setLogFlag:(BOOL)newLogFlag;
- (BOOL)logFlag;

+(NetworkProcess *)sharedInstance;

/**
 *@brief 测试环境和生产环境切换
 *@param param BOOL 参数标示：参数
 *@return
 */
- (void )environmentChange:(BOOL)param;

/**
 *@brief 两个数组转成一个数组
 *@param paramOne 数组 参数标示：参数1
 *@param paramTwo 数组 参数标示：参数2
 *@return 数组
 */
- (NSMutableArray *)twoArrayToOneArray:(NSMutableArray *)paramOne paramTwo:(NSMutableArray *)paramTwo;

/**
 *@brief 两个数组转成一个数组
 *@param param 数组 参数标示：参数
 *@return 字符串
 */
- (NSString *)arrayToString:(NSMutableArray *)param;

/**
 *@brief 获取设备信息
 *@param devID 字符串 参数标示：设备编号
 *@param duid 字符串 参数标示：设备会话
 *@return 字符串
 */
- (NSString *)getDeviceInfo:(NSString *) devID duid:(NSString *) duid;

/**
 *@brief 拼接依附设备信息字符串
 *@return 字符串
 */
- (NSString *)getAttachDeviceInfo;

/**
 *@brief 拼接报文头字符穿
 *@param isSign 布尔类型 参数标示：是否要签名
 *@param accessChannelNo 字符串 参数标示：应用接入渠道号
 *@param accessType 字符串 参数标示：应用接入类型
 *@param commType 字符串 参数标示：通讯方式
 *@param deviceType 字符串 参数标示：设备类型
 *@param deviceInfo 字符串 参数标示：设备认证信息
 *@param attachDeviceType 字符串 参数标示：依附设备类型
 *@param attachDeviceInfo 字符串 参数标示：依附设备信息
 *@return 字符串
 */
-(NSString *)getMessageHead:(BOOL)isSign accessChannelNo:(NSString *)accessChannelNo accessType:(NSString *)accessType commType:(NSString *)commType deviceType:(NSString *) deviceType deviceInfo:(NSString *)deviceInfo attachDeviceType:(NSString *)attachDeviceType attachDeviceInfo:(NSString *)attachDeviceInfo;

/**
 *@brief 拼接安全控制域字符穿
 *@param memid 字符串 参数标示：
 *@param sessionid 字符串 参数标示：
 *@param tokey 字符串 参数标示：
 *@param uuid 字符串 参数标示：
 *@param sid 字符串 参数标示：
 *@return 字符串
 */
-(NSString *)getClientSecurityInfo:(NSString *)memid sessionid:(NSString *)sessionid tokey:(NSString *)tokey uuid:(NSString *)uuid sid:(NSString *)sid;

/**
 *@brief 拼接签名报文头字符穿
 *@param messageSignHead 字符串 参数标示：签名报文头
 *@param clientSecurityInfo 字符串 参数标示：客户端安全控制域
 *@param apiName 字符串 参数标示：接口名称
 *@param busiType 字符串 参数标示：业务类型
 *@param busiInfo 字符串 参数标示：业务信息
 *@return 字符串
 */
-(NSString *)getSign:(NSString *)messageSignHead clientSecurityInfo:(NSString *)clientSecurityINfo apiName:(NSString *)apiName busiType:(NSString *)busiType busiInfo:(NSString *)busiInfo;

/**
 *@brief 拼接请求字符穿
 *@param messageHead 字符串 参数标示：报文头
 *@param clientSecurityInfo 字符串 参数标示：客户端安全控制域
 *@param apiName 字符串 参数标示：接口名称
 *@param busiType 字符串 参数标示：业务类型
 *@param busiInfo 字符串 参数标示：业务信息
 *@param sign 字符串 参数标示：签名信息
 *@return 字符串
 */
-(NSMutableString *)getmessage:(NSString *)messageHead clientSecurityInfo:(NSString *)clientSecurityInfo apiName:(NSString *)apiName busiType:(NSString *)busiType busiInfo:(NSString *)busiInfo sign:(NSString *) sign;

/*
 * @brief 把字典配装成业务json模式
 * @param busiInfoDic 字段 参数标示：业务字典
 * @return NSString
 */
- (NSString *)busiInfoDicToStringResult:(NSMutableDictionary *)busiInfoDic;

/*
 * @brief 把数组配装成业务json模式
 * @param busiInfoArray 字段 参数标示：业务字典
 * @return NSString
 */
- (NSString *)busiInfoArrayToStringResult:(NSMutableArray *)busiInfoArray;

/**
 *@brief 执行请求
 *@param message 字符串 参数标示： 请求的报文
 *@return 字符串
 */
-(NSString *)getResuest:(NSString *)message;

/**
 *@brief 获取请求返回信息
 *@param interfaceName 字符串 参数标示：界面名字
 *@param param 数组 参数标示：参数
 *@return 字符串
 */
-(NSString *)getStoreJson:(NSString *)interfaceName param:(NSArray *)param;

/*
 * @brief 把格式化的JSON格式的字符串转换成字典
 * @param jsonString JSON格式的字符串
 * @return 返回字典
 */
- (NSMutableDictionary *)dictionaryWithJsonString:(NSString *)jsonString;

/**
 *@brief 获取请求返回信息
 *@param requestUrl 字符串 参数标示：请求地址
 *@param httpPath 字符串 参数标示：请求路径
 *@param dataKey 字符串 参数标示：请求字典key值
 *@param busiType 字符串 参数标示：业务类型
 *@param busiInfo 字符串 参数标示：业务信息
 *@return 字符串
 */
-(NSString *)requestDataResult:(NSString *)requestUrl httpPath:(NSString *)httpPath dataKey:(NSString *) dataKey busiType:(NSString *)busiType busiInfo:(NSString *)busiInfo;

/**
 *@brief 获取请求返回信息
 *@param requestUrl 字符串 参数标示：请求地址
 *@param httpPath 字符串 参数标示：请求路径
 *@param dataKey 字符串 参数标示：请求字典key值
 *@param busiType 字符串 参数标示：业务类型
 *@param busiInfo 字符串 参数标示：业务信息
 *@return 字符串
 */
- (NSString *)requestDataResult:(NSString *)requestUrl httpPath:(NSString *)httpPath dataKey:(NSString *)dataKey busiType:(NSString *)busiType busiInfoArray:(NSMutableArray *)busiInfoArray;

/**
 *@brief 获取请求返回信息
 *@param requestUrl 字符串 参数标示：请求地址
 *@param httpPath 字符串 参数标示：请求路径
 *@param dataKey 字符串 参数标示：请求字典key值
 *@param busiType 字符串 参数标示：业务类型
 *@param busiInfoDic 字典 参数标示：业务信息
 *@return 字符串
 */
- (NSString *)requestDataResult:(NSString *)requestUrl httpPath:(NSString *)httpPath dataKey:(NSString *)dataKey busiType:(NSString *)busiType busiInfoDic:(NSMutableDictionary *)busiInfoDic;

/**
 *@brief 获取请求返回信息
 *@param requestUrl 字符串 参数标示：请求地址
 *@param httpPath 字符串 参数标示：请求路径
 *@param dataKey 字符串 参数标示：请求字典key值
 *@param busiType 字符串 参数标示：业务类型
 *@param messageData 字符串 参数标示：报文信息
 *@return 字符串
 */
- (NSString *)requestDataResult:(NSString *)requestUrl httpPath:(NSString *)httpPath dataKey:(NSString *)dataKey busiType:(NSString *)busiType messageInfo:(NSString *)messageInfo;

/**
 *@brief 上传文件
 *@param requestUrl 字符串 参数标示：请求地址
 *@param httpPath 字符串 参数标示：请求路径
 *@param busiType 字符串 参数标示：业务类型
 *@param documentInfo 对象 参数标示：文件对象
 *@param busiInfo 字符串 参数标示：报文信息
 *@return 字符串
 */
- (NSString *)upFileResult:(NSString *)requestUrl httpPath:(NSString *)httpPath busiType:(NSString *)busiType documentInfo:(Document *) documentInfo busiInfo:(NSString *)busiInfo;

/**
 *@brief 上传文件
 *@param requestUrl 字符串 参数标示：请求地址
 *@param httpPath 字符串 参数标示：请求路径
 *@param busiType 字符串 参数标示：业务类型
 *@param documentInfo 对象 参数标示：文件对象
 *@param busiInfoDic 字典 参数标示：报文信息
 *@return 字符串
 */
- (NSString *)upFileResult:(NSString *)requestUrl httpPath:(NSString *)httpPath busiType:(NSString *)busiType documentInfo:(Document *) documentInfo busiInfoDic:(NSMutableDictionary *)busiInfoDic;

/**
 *@brief 上传文件
 *@param requestUrl 字符串 参数标示：请求地址
 *@param httpPath 字符串 参数标示：请求路径
 *@param busiType 字符串 参数标示：业务类型
 *@param documentInfo 对象 参数标示：文件对象
 *@param busiInfoArray 数组 参数标示：报文信息
 *@return 字符串
 */
- (NSString *)upFileResult:(NSString *)requestUrl httpPath:(NSString *)httpPath busiType:(NSString *)busiType documentInfo:(Document *) documentInfo busiInfoArray:(NSMutableArray *)busiInfoArray;

/**
 *@brief 获取请求返回信息( ios 自己的http请求  post josn 模式)
 *@param requestUrl 字符串 参数标示：请求地址
 *@param httpPath 字符串 参数标示：请求路径
 *@param busiType 字符串 参数标示：业务类型
 *@param busiInfo 字符串 参数标示：业务信息
 *@return 字符串
 */
-(NSString *)requestJsonResult:(NSString *)requestUrl httpPath:(NSString *)httpPath busiType:(NSString *)busiType busiInfo:(NSString *)busiInfo;

/**
 *@brief 获取请求返回信息( ios 自己的http请求  post josn 模式)
 *@param requestUrl 字符串 参数标示：请求地址
 *@param httpPath 字符串 参数标示：请求路径
 *@param busiType 字符串 参数标示：业务类型
 *@param busiInfoArray 数组 参数标示：业务信息
 *@return 字符串
 */
-(NSString *)requestJsonResult:(NSString *)requestUrl httpPath:(NSString *)httpPath busiType:(NSString *)busiType busiInfoArray:(NSMutableArray *)busiInfoArray;

/**
 *@brief 获取请求返回信息( ios 自己的http请求  post josn 模式)
 *@param requestUrl 字符串 参数标示：请求地址
 *@param httpPath 字符串 参数标示：请求路径
 *@param busiType 字符串 参数标示：业务类型
 *@param busiInfoDic 字典 参数标示：业务信息
 *@return 字符串
 */
-(NSString *)requestJsonResult:(NSString *)requestUrl httpPath:(NSString *)httpPath busiType:(NSString *)busiType busiInfoDic:(NSMutableDictionary *)busiInfoDic;

/**
 *@brief 获取信息
 *@param devID 字符串 参数标示：json字符串
 *@param duid 字符串 参数标示：要查询的值
 *@return 字符串
 */
-(NSString *)getResult:(NSString *)json key:(NSString *)key;

/**
 *@brief 获取信息(字典模式)
 *@param devID 字符串 参数标示：json字符串
 *@param duid 字符串 参数标示：要查询的值
 *@return 字典
 */
-(NSDictionary *)getDicInfo:(NSString *)json key:(NSString *)key;

/**
 *@brief 获取信息（数组模式）
 *@param devID 字符串 参数标示：json字符串
 *@param duid 字符串 参数标示：要查询的值
 *@return 数组
 */
-(NSMutableArray *)getArrayInfo:(NSString *)json key:(NSString *)key;

@end
