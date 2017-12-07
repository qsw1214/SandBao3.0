//
//  Comm.h
//  sand_bluesky_demonstration
//
//  Created by blue sky on 15/4/27.
//  Copyright (c) 2015年 sand. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Document;

@interface Comm : NSObject{
    int _respCode;
    NSString *_respResult;
    
    NSString *_requestUrl;
    NSString *_mqttUrl;
    int _mqttPort;
    NSString *_userName;
    NSString *_userPwd;
    
}

// 电话号码
@property (nonatomic,strong) NSMutableString *userIdTableName;

- (void)setRespCode:(int)newRespCode;
- (int)respCode;

- (void)setRespResult:(NSString *)newRespResult;
- (NSString *)respResult;

- (void)setRequestUrl:(NSString *)newRequestUrl;
- (NSString *)requestUrl;

- (void)setMqttUrl:(NSString *)newMqttUrl;
- (NSString *)mqttUrl;

- (void)setMqttPort:(int)newMqttPort;
- (int)mqttPort;

- (void)setUserName:(NSString *)newUserName;
- (NSString *)userName;

- (void)setUserPwd:(NSString *)newUserPwd;
- (NSString *)userPwd;




/**
 *@brief 切换环境
 *@param flag    BOOL  标志  yes为测试  no为生产环境
 *@return BOOL
 */
- (void)changeEnvironment:(BOOL)flag;

/**
 *@brief 配置请求地址
 *@return
 */
- (void) produceRequestUrl;

/**
 *@brief 获取请求地址
 *@param busiType    字符串  业务类型
 *@return NSString
 */
- (NSString *) requestUrl:(NSString *)busiType;

/**
 *@brief 获取数组转成json字符串(数组 模式)
 *@param busiInfoArray  数组  业务信息
 *@return 字符串
 */
- (NSString *)busiInfoArrayToStringResult:(NSMutableArray *)busiInfoArray;

/**
 *@brief 获取字典转成json字符串(字典 模式)
 *@param busiInfoDic  字典  业务信息
 *@return 字符串
 */
- (NSString *)busiInfoDicToStringResult:(NSMutableDictionary *)busiInfoDic;

/**
 *@brief 获取请求结果(data 模式)
 *@param busiType    字符串  业务类型
 *@param busiInfo    字符串  业务信息
 *@return
 */
- (void) requestDataResult:(NSString *)busiType busiInfo:(NSString *)busiInfo;

/**
 *@brief 获取请求结果(data 模式)
 *@param busiType    字符串  业务类型
 *@param busiInfoArray  数组  业务信息
 *@return
 */
- (void) requestDataResult:(NSString *)busiType busiInfoArray:(NSMutableArray *)busiInfoArray;

/**
 *@brief 获取请求结果(data 模式)
 *@param busiType    字符串  业务类型
 *@param busiInfoDic  字典  业务信息
 *@return
 */
- (void) requestDataResult:(NSString *)busiType busiInfoDic:(NSMutableDictionary *)busiInfoDic;

/**
 *@brief 获取请求结果（json 模式）
 *@param busiType    字符串  业务类型
 *@param busiInfo    字符串  业务信息
 *@return
 */
- (void) requestJsonResult:(NSString *)busiType busiInfo:(NSString *)busiInfo;

/**
 *@brief 获取请求结果（json 模式）
 *@param busiType    字符串  业务类型
 *@param busiInfoArray    数组  业务信息
 *@return
 */
- (void) requestJsonResult:(NSString *)busiType busiInfoArray:(NSMutableArray *)busiInfoArray;

/**
 *@brief 获取请求结果（json 模式）
 *@param busiType    字符串  业务类型
 *@param busiInfoDic    字典  业务信息
 *@return
 */
- (void) requestJsonResult:(NSString *)busiType busiInfoDic:(NSMutableDictionary *)busiInfoDic;

/**
 *@brief 业务请求
 *@param busiType    字符串  业务类型
 *@return int
 */
- (int)biz:(NSString *)busiType;

/**
 *@brief 老业务请求
 *@param busiType    字符串  业务类型
 *@return int
 */
- (int)bizGo:(NSString *)busiType;

/**
 *@brief 三步认证
 *@return int
 */
- (int)threeSteps;

/**
 *@brief 二步认证
 *@return int
 */
- (int)twoSteps;

/**
 *@brief 根据key值获取value
 *@param key    字符串  key值
 *@return NSString
 */
- (NSString *)getValue:(NSString *)key;

/**
 *@brief 根据key值获取信息（字典模式）
 *@param key    字符串  key值
 *@return NSString
 */
- (NSDictionary *)dicInfo:(NSString *)key;

/**
 *@brief 根据key值获取信息（数组模式）
 *@param key    字符串  key值
 *@return NSString
 */
- (NSMutableArray *)arrayInfo:(NSString *)key;

/**
 *@brief 上传文件
 *@param busiType 字符串 参数标示：业务类型
 *@param documentInfo 对象 参数标示：文件对象
 *@param busiInfo 字符串 参数标示：报文信息
 *@return 字符串
 */
- (void)upFileResult:(NSString *)busiType documentInfo:(Document *) documentInfo busiInfo:(NSString *)busiInfo;

/**
 *@brief 上传文件
 *@param busiType 字符串 参数标示：业务类型
 *@param documentInfo 对象 参数标示：文件对象
 *@param busiInfoDic 字典 参数标示：报文信息
 *@return 字符串
 */
- (void)upFileResult:(NSString *)busiType documentInfo:(Document *) documentInfo busiInfoDic:(NSMutableDictionary *)busiInfoDic;

/**
 *@brief 上传文件
 *@param busiType 字符串 参数标示：业务类型
 *@param documentInfo 对象 参数标示：文件对象
 *@param busiInfoArray 数组 参数标示：报文信息
 *@return 字符串
 */
- (void)upFileResult:(NSString *)busiType documentInfo:(Document *) documentInfo busiInfoArray:(NSMutableArray *)busiInfoArray;

/**
 *@brief 初始化数据
 *@param userId 字符串 参数标示：用户编号
 *@return
 */
-(void)initdata:(NSString *)userId;

/**
 *@brief 插入数据
 *@param authCodejson 字符串 参数标示：授权码字符串
 *@return BOOL
 */
-(BOOL)insertAuthCode:(NSString *)authCodejson;

/**
 *@brief 获取授权码
 *@return NSString
 */
-(NSString *)getAuthCode;

/**
 *@brief 结束数据
 *@return
 */
-(void)enddata;

/**
 *@brief 请求授权码
 *@param busiType 字符串 参数标示：业务类型
 *@param userId 字符串 参数标示：用户编号
 *@param authCodCount 字符串 参数标示：个数
 *@return BOOL
 */
- (void)authCode:(NSString *)userId authCodCount:(NSString *)authCodCount;

/**
 *@brief 支付
 *@param userId 字符串 参数标示：用户编号
 *@param orderCode 字符串 参数标示：订单号
 *@param mid 字符串 参数标示：商户号
 *@param orderAmt 字符串 参数标示：金额
 *@param pwd 字符串 参数标示：支付密码
 *@param isCardNo 字符串 参数标示：卡号
 *@return BOOL
 */
- (void)pay:(NSString *)userId orderCode:(NSString *)orderCode mid:(NSString *)mid orderAmt:(NSString *)orderAmt pwd:(NSString *)pwd isCardNo:(NSString *)isCardNo;

/**
 *@brief 支付列表
 *@return
 */
- (void)payModeList;

/**
 *@brief 设置支付方式
 *@return
 */
- (void)setPayMode:(NSDictionary *)dic;

/**
 *@brief 加载数据
 *@param paramData 字符串 参数标示： 参数数据
 *@return
 */
- (void)loadData:(NSString *)paramData;

@end
