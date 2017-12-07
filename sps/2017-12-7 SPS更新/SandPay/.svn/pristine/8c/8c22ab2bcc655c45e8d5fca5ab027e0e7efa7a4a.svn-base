//
//  Comm.m
//  sand_bluesky_demonstration
//
//  Created by blue sky on 15/4/27.
//  Copyright (c) 2015年 sand. All rights reserved.
//

#import "Comm.h"
#import "DBUtil.h"
#import "NetworkProcess.h"
#import "CommParameter.h"

#include "RXSandPayCore.h"
#include "xstring.h"
#include "gv.h"

using namespace sz;


#define dbName @"sand.sqlite"

@interface Comm () {
    DBUtil *mDBUtil;
    NetworkProcess *mNetworkProcess;
    
    NSString *serverUrl;
    //NSString *json;
    
    NSString *httpUrl;
}

@property (nonatomic, strong) NSString *json;

@end

@implementation Comm

- (instancetype)init
{
    self = [super init];
    if (self) {
        mDBUtil = [DBUtil shareDB];
        mNetworkProcess = [[NetworkProcess alloc]init];
        [mDBUtil createDatabase:dbName];
        [mDBUtil openDB];
        
//        [self changeEnvironment:YES]; //修改环境，yes为测试
        [self createAlloction];
        [self createRequestUrl];
    }
    return self;
}

- (void)setRespCode:(int)newRespCode
{
    _respCode = newRespCode;
}

- (int)respCode
{
    return _respCode;
}


- (void)setRespResult:(NSString *)newRespResult
{
    _respResult = newRespResult;
}

- (NSString *)respResult
{
    return _respResult;
}

- (void)setRequestUrl:(NSString *)newRequestUrl
{
    _requestUrl = newRequestUrl;
}

- (NSString *)requestUrl
{
    return _requestUrl;
}

-(void)setMqttUrl:(NSString *)newMqttUrl
{
    _mqttUrl = newMqttUrl;
}

- (NSString *)mqttUrl
{
    return _mqttUrl;
}

- (void)setMqttPort:(int)newMqttPort
{
    _mqttPort = newMqttPort;
}

- (int)mqttPort
{
    return _mqttPort;
}

-(void)setUserName:(NSString *)newUserName
{
    _userName = newUserName;
}

- (NSString *)userName
{
    return _userName;
}

-(void)setUserPwd:(NSString *)newUserPwd
{
    _userPwd = newUserPwd;
}

- (NSString *)userPwd
{
    return _userPwd;
}

- (void)changeEnvironment:(BOOL)flag
{
    if (flag == YES) {
        payCore.TestMode();
        mDBUtil.logFlag = flag;
        mNetworkProcess.logFlag = flag;
//        httpUrl = @"https://query-test.sandpay.com.cn/mobile/controller.srv";
        httpUrl = @"http://go-test.sandpay.com.cn/mobile/controller.srv";
//        httpUrl = @"https://multipay-test.sandpay.com.cn:10443/mobile/controller.srv";
        self.requestUrl = @"https://payment-test.sandpay.com.cn:15678";
        self.mqttUrl = @"payment-test.sandpay.com.cn";
        self.mqttPort = 9083;
        self.userName = @"testuser";
        self.userPwd = @"0d6be69b264717f2dd33652e212b173104b4a647b7c11ae72e9885f11cd312fb";
    } else {
        mDBUtil.logFlag = flag;
        mNetworkProcess.logFlag = flag;
//        httpUrl = @"https://multipay.sandpay.com.cn/mobile/controller.srv";
        httpUrl = @" http://jzb.sandlife.com.cn/mobile/controller.srv";
        
        self.requestUrl = @"http://180.169.86.123:48080";//app_comm_url= "https://180.169.86.123:48080";上面两个请求地址是一样的
        self.mqttUrl = @"180.169.86.123";
        self.mqttPort = 31883;//BROKER_URL = "tcp://180.169.86.123:31883";ip和上面一致，端口换成31883
        self.userName = @"sand-magw-mqtt-user";
        self.userPwd = @"magw@sand#20150805%!_";
    }
}

/**
 *@brief 创建请求地址表
 */
-(void)createRequestUrl
{
    NSString *sql = @"CREATE TABLE IF NOT EXISTS requestUrl(ID INTEGER PRIMARY KEY AUTOINCREMENT, busiType TEXT, busiUrl TEXT) ";
    [mDBUtil createTable:sql];
}

/**
 *@brief 创建配置表
 */
-(void)createAlloction
{
    NSString *sql = @"CREATE TABLE IF NOT EXISTS alloction(ID INTEGER PRIMARY KEY AUTOINCREMENT, alloctionName TEXT, alloctionVersion TEXT) ";
//    [mDBUtil openDB];
    [mDBUtil createTable:sql];
}

/**
 *@brief 获取请求地址获取请求地址(bu带有http模式)
 *@param busiType    字符串  业务类型
 *@return NSString
 */
- (NSString *) requestUrl:(NSString *)busiType
{
    NSString *result = @"";
    result = [mDBUtil selectOneData:@"requestUrl" columnName:@"busiUrl" columnString:@"busiType" paramString:busiType];
    result = [NSString stringWithFormat:@"%@%@/%@", self.requestUrl, result, busiType];
    
    return result;
}

/**
 *@brief 获取请求地址(带有http模式)
 *@param busiType    字符串  业务类型
 *@return NSString
 */
- (NSString *) getHttpRequestUrl:(NSString *)busiType
{
    NSString *result = @"";
    result = [mDBUtil selectOneData:@"requestUrl" columnName:@"busiUrl" columnString:@"busiType" paramString:busiType];
    result = [NSString stringWithFormat:@"%@%@/%@", self.requestUrl, result, busiType];
    
    return result;
}

/**
 *@brief 获取数组转成json字符串(数组 模式)
 *@param busiInfoArray  数组  业务信息
 *@return 字符串
 */
- (NSString *)busiInfoArrayToStringResult:(NSMutableArray *)busiInfoArray
{
    return [mNetworkProcess busiInfoArrayToStringResult:busiInfoArray];
}

/**
 *@brief 获取字典转成json字符串(字典 模式)
 *@param busiInfoDic  字典  业务信息
 *@return 字符串
 */
- (NSString *)busiInfoDicToStringResult:(NSMutableDictionary *)busiInfoDic
{
    return [mNetworkProcess busiInfoDicToStringResult:busiInfoDic];
}

/**
 *@brief 获取请求结果(data 模式)
 *@param busiType    字符串  业务类型
 *@param busiInfo    字符串  业务信息
 *@return
 */
- (void) requestDataResult:(NSString *)busiType busiInfo:(NSString *)busiInfo
{
    NSString *url = [self getHttpRequestUrl:busiType];
    self.json = [mNetworkProcess requestDataResult:url httpPath:nil dataKey:@"data" busiType:busiType busiInfo:busiInfo];
    self.respCode = mNetworkProcess.respCode;
    self.respResult = mNetworkProcess.respResult;
}

/**
 *@brief 获取请求结果(data 模式)
 *@param busiType    字符串  业务类型
 *@param busiInfoArray  数组  业务信息
 *@return
 */
- (void) requestDataResult:(NSString *)busiType busiInfoArray:(NSMutableArray *)busiInfoArray
{
    NSString *url = [self getHttpRequestUrl:busiType];
    self.json = [mNetworkProcess requestDataResult:url httpPath:nil dataKey:@"data" busiType:busiType busiInfoArray:busiInfoArray];
    self.respCode = mNetworkProcess.respCode;
    self.respResult = mNetworkProcess.respResult;
}

/**
 *@brief 获取请求结果(data 模式)
 *@param busiType    字符串  业务类型
 *@param busiInfoDic  字典  业务信息
 *@return
 */
- (void) requestDataResult:(NSString *)busiType busiInfoDic:(NSMutableDictionary *)busiInfoDic
{
    NSString *url = [self getHttpRequestUrl:busiType];
    self.json = [mNetworkProcess requestDataResult:url httpPath:nil dataKey:@"data" busiType:busiType busiInfoDic:busiInfoDic];
    self.respCode = mNetworkProcess.respCode;
    self.respResult = mNetworkProcess.respResult;
}

/**
 *@brief 获取请求结果(data 模式)
 *@param busiType    字符串  业务类型
 *@param messageInfo  字符串  报文信息
 *@return
 */
- (void) requestDataResult:(NSString *)busiType messageInfo:(NSString *)messageInfo
{
    NSString *url = [self getHttpRequestUrl:busiType];
    self.json = [mNetworkProcess requestDataResult:url httpPath:nil dataKey:@"data" busiType:busiType messageInfo:messageInfo];
    self.respCode = mNetworkProcess.respCode;
    self.respResult = mNetworkProcess.respResult;
}

/**
 *@brief 上传文件
 *@param busiType 字符串 参数标示：业务类型
 *@param documentInfo 对象 参数标示：文件对象
 *@param busiInfo 字符串 参数标示：报文信息
 *@return 字符串
 */
- (void)upFileResult:(NSString *)busiType documentInfo:(Document *) documentInfo busiInfo:(NSString *)busiInfo
{
    NSString *url = [self getHttpRequestUrl:busiType];
    self.json = [mNetworkProcess upFileResult:url httpPath:nil busiType:busiType documentInfo:documentInfo busiInfo:busiInfo];
    self.respCode = mNetworkProcess.respCode;
    self.respResult = mNetworkProcess.respResult;
}

/**
 *@brief 上传文件
 *@param busiType 字符串 参数标示：业务类型
 *@param documentInfo 对象 参数标示：文件对象
 *@param busiInfoDic 字典 参数标示：报文信息
 *@return 字符串
 */
- (void)upFileResult:(NSString *)busiType documentInfo:(Document *) documentInfo busiInfoDic:(NSMutableDictionary *)busiInfoDic
{
    NSString *url = [self getHttpRequestUrl:busiType];
    self.json = [mNetworkProcess upFileResult:url httpPath:nil busiType:busiType documentInfo:documentInfo busiInfoDic:busiInfoDic];
    self.respCode = mNetworkProcess.respCode;
    self.respResult = mNetworkProcess.respResult;
}

/**
 *@brief 上传文件
 *@param busiType 字符串 参数标示：业务类型
 *@param documentInfo 对象 参数标示：文件对象
 *@param busiInfoArray 数组 参数标示：报文信息
 *@return 字符串
 */
- (void)upFileResult:(NSString *)busiType documentInfo:(Document *) documentInfo busiInfoArray:(NSMutableArray *)busiInfoArray
{
    NSString *url = [self getHttpRequestUrl:busiType];
    self.json = [mNetworkProcess upFileResult:url httpPath:nil busiType:busiType documentInfo:documentInfo busiInfoArray:busiInfoArray];
    self.respCode = mNetworkProcess.respCode;
    self.respResult = mNetworkProcess.respResult;
}

/**
 *@brief 获取请求结果（json 模式）
 *@param busiType    字符串  业务类型
 *@param busiInfo    字符串  业务信息
 *@return
 */
- (void) requestJsonResult:(NSString *)busiType busiInfo:(NSString *)busiInfo
{
    NSString *url = [self getHttpRequestUrl:busiType];
    self.json = [mNetworkProcess requestDataResult:url httpPath:nil dataKey:@"data" busiType:busiType busiInfo:busiInfo];
    self.respCode = mNetworkProcess.respCode;
    self.respResult = mNetworkProcess.respResult;
}

/**
 *@brief 获取请求结果（json 模式）
 *@param busiType    字符串  业务类型
 *@param busiInfoArray    数组  业务信息
 *@return
 */
- (void) requestJsonResult:(NSString *)busiType busiInfoArray:(NSMutableArray *)busiInfoArray
{
    NSString *url = [self getHttpRequestUrl:busiType];
    self.json = [mNetworkProcess requestDataResult:url httpPath:nil dataKey:@"data" busiType:busiType busiInfoArray:busiInfoArray];
    self.respCode = mNetworkProcess.respCode;
    self.respResult = mNetworkProcess.respResult;
}

/**
 *@brief 获取请求结果（json 模式）
 *@param busiType    字符串  业务类型
 *@param busiInfoDic    字典  业务信息
 *@return
 */
- (void) requestJsonResult:(NSString *)busiType busiInfoDic:(NSMutableDictionary *)busiInfoDic
{
    NSString *url = [self getHttpRequestUrl:busiType];
    self.json = [mNetworkProcess requestDataResult:url httpPath:nil dataKey:@"data" busiType:busiType busiInfoDic:busiInfoDic];
    self.respCode = mNetworkProcess.respCode;
    self.respResult = mNetworkProcess.respResult;
}

- (XString)Transmit:(NSString *)busiType data:(XString)data
{
    [self requestDataResult:busiType messageInfo:[NSString stringWithUTF8String:data.Buffer()]];
    
    if (self.respCode == 0) {
        return XString([self.json UTF8String]);
    }else{
        return XString("");
    }
}

/**
 *@brief 三步认证
 *@return int
 */
- (int)threeSteps
{
    NSLog(@"\n\n\n>>>>>>>>>>>>>>>>>>>> SPS_Three_Code_3Steps <<<<<<<<<<<<<<<<<<<<\n\n\n");
    
    XString recvData;
    
    
    recvData = [self Transmit:@"00010001" data:payCore.Biz_UP("00010001")];
    
    
    if(payCore.Biz_DOWN(recvData) != RXSandPayCore::HANDLE_OK){
        return self.respCode;
    }
    
    
    recvData = [self Transmit:@"00010002" data:payCore.Biz_UP("00010002")];
    if(payCore.Biz_DOWN(recvData) != RXSandPayCore::HANDLE_OK){
        return self.respCode;
    }
    
    recvData = [self Transmit:@"00010003" data:payCore.Biz_UP("00010003")];
    if(payCore.Biz_DOWN(recvData) != RXSandPayCore::HANDLE_OK){
        return self.respCode;
    }
    
    return self.respCode;
}

/*!
 * @brief 把格式化的JSON格式的字符串转换成字典
 * @param jsonString JSON格式的字符串
 * @return 返回字典
 */
- (NSDictionary *)dictionaryWithJsonString:(NSString *)jsonString {
    if (jsonString == nil) {
        return nil;
    }
    
    NSData *jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    NSError *err;
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:&err];
    if(err) {
        NSLog(@"json解析失败：%@",err);
        return nil;
    }
    return dic;
}

/**
 *@brief 二步认证
 *@return int
 */
- (int)twoSteps
{
    NSLog(@"\n\n\n>>>>>>>>>>>>>>>>>>>> SPS_Two_Code_2Steps <<<<<<<<<<<<<<<<<<<<\n\n\n");
    
    XString recvData;
    
    
    recvData = [self Transmit:@"00010001" data:payCore.Biz_UP("00010001")];
    
    
    if(payCore.Biz_DOWN(recvData) != RXSandPayCore::HANDLE_OK){
        return self.respCode;
    }
    
    NSString *fp = [self machineFingerInfo];
    if ([@"" isEqualToString:fp] || fp == nil) {
       fp = @"{}";
    }
    
    payCore.fp = [fp UTF8String];
    
    recvData = [self Transmit:@"00010004" data:payCore.Biz_UP("00010004")];
    
    
    if(payCore.Biz_DOWN(recvData) != RXSandPayCore::HANDLE_OK){
        return self.respCode;
    }
    
    return self.respCode;
}

/**
 *@brief 业务请求
 *@param busiType    字符串  业务类型
 *@return int
 */
- (int)biz:(NSString *)busiType
{
    XString recvData;
    recvData = [self Transmit:busiType data:payCore.Biz_UP(XString([busiType UTF8String]))];
    if(payCore.Biz_DOWN(recvData) != RXSandPayCore::HANDLE_OK){
        return self.respCode;
    }
    return self.respCode;
}

/**
 *@brief 老业务请求
 *@param busiType    字符串  业务类型
 *@return int
 */
- (int)bizGo:(NSString *)busiType
{
    XString recvData;
    
    self.json = [mNetworkProcess requestDataResult:httpUrl httpPath:nil dataKey:@"data" busiType:busiType messageInfo:[NSString stringWithUTF8String:payCore.Biz_UP(XString([busiType UTF8String])).Buffer()]];
    
    if (self.respCode == 0) {
        recvData = XString([self.json UTF8String]);
    }else{
        recvData = XString("");
    }
    
    if(payCore.Biz_DOWN(recvData) != RXSandPayCore::HANDLE_OK){
        return self.respCode;
    }
    return self.respCode;
}

/**
 *@brief 根据key值获取value
 *@param key    字符串  key值
 *@return NSString
 */
- (NSString *)getValue:(NSString *)key
{
    return [mNetworkProcess getResult:self.json key:key];
}

/**
 *@brief 根据key值获取信息（字典模式）
 *@param key    字符串  key值
 *@return NSString
 */
- (NSDictionary *)dicInfo:(NSString *)key
{
    return [mNetworkProcess getDicInfo:self.json key:key];
}

/**
 *@brief 根据key值获取信息（数组模式）
 *@param key    字符串  key值
 *@return NSString
 */
- (NSMutableArray *)arrayInfo:(NSString *)key
{
    return [mNetworkProcess getArrayInfo:self.json key:key];
}

/**
 *@brief 配置请求地址
 *@return
 */
- (void) produceRequestUrl
{
    int requestIndex = 0;
    NSString *busiType = @"SYSR0001";
    NSString *alloctionVersion = [mDBUtil selectOneData:@"alloction" columnName:@"alloctionVersion" columnString:@"alloctionName" paramString:busiType];
    
    if (!alloctionVersion) {
        alloctionVersion = @"";
    }
    
    NSMutableString *url = [NSMutableString stringWithFormat:@"%@/sys/rule/1.0.0/SYSR0001", self.requestUrl];
    
    while (YES) {
        NSMutableString *busiInfo =[NSMutableString stringWithFormat:@"{\"accessVersion\":\"%@\",\"accessPart\":\"%@\",\"accessPartSize\":\"%@\"}", alloctionVersion, [NSString stringWithFormat:@"%d",requestIndex], @"20"];
        
        self.json = [mNetworkProcess requestDataResult:url httpPath:nil dataKey:@"data" busiType:busiType busiInfo:busiInfo];
        
        
        self.respCode = mNetworkProcess.respCode;
        if (self.respCode == 0) {
            requestIndex++;
            int accessPartRemain = 0;
            NSString *SYSR0001_accessPartRemain = [self getValue:@"SYSR0001_accessPartRemain"];
            if ([@"" isEqualToString:SYSR0001_accessPartRemain] || SYSR0001_accessPartRemain == nil) {
                self.respCode = 0;
                self.respResult = @"获取数据失败";
//                return;
            } else {
                accessPartRemain = [SYSR0001_accessPartRemain intValue];
            }
            
            NSString *lastVersion = [self getValue:@"SYSR0001_lastVersion"];
            
            if (![lastVersion isEqualToString:alloctionVersion]) {
                [self insertRequestSql:self.json alloctionName:busiType lastVersion:lastVersion];
            }
            
            accessPartRemain--;
            if (accessPartRemain < 0) {
                return;
            }
        }else{
            self.respCode = mNetworkProcess.respCode;
            self.respResult = mNetworkProcess.respResult;
            return;
        }
        
    }
}


- (void)insertRequestSql:(NSString *)json alloctionName:(NSString *)alloctionName lastVersion:(NSString *)lastVersion
{
    BOOL result = false;
    NSString *tableName = @"requestUrl";
    NSString *columnString = @"busiType";
    NSString *busiType = @"";
    NSString *busiUrl = @"";
    NSMutableArray *columnArray = [[NSMutableArray alloc] init];
    [columnArray addObject:@"busiType"];
    [columnArray addObject:@"busiUrl"];
    
    NSDictionary *accessMapDic = [self dicInfo:@"SYSR0001_accessMap"];
    
    if (accessMapDic.count > 0) {
        for(id key in accessMapDic) {
            busiType = key;
            busiUrl = [accessMapDic objectForKey:key];
            long count = [mDBUtil getCount:tableName columnString:columnString paramString:busiType];
            NSMutableArray *paramArray = [[NSMutableArray alloc] init];
            [paramArray addObject:busiType];
            [paramArray addObject:busiUrl];
            if (count > 0) {
                result = [mDBUtil updateData:tableName columnArray:columnArray paramArray:paramArray columnString:columnString paramString:busiType];
            } else {
                result = [mDBUtil insertData:tableName columnArray:columnArray paramArray:paramArray];
            }
        }
        
        if (result == YES) {
            NSString *alloctionTable = @"alloction";
            NSString *columnString = @"alloctionName";
            long count = [mDBUtil getCount:alloctionTable columnString:columnString paramString:alloctionName];
            if (count > 0) {
                NSMutableArray *columnArray = [[NSMutableArray alloc] init];
                [columnArray addObject:@"alloctionVersion"];
                
                NSMutableArray *paramArray = [[NSMutableArray alloc] init];
                [paramArray addObject:lastVersion];
                
                result = [mDBUtil updateData:alloctionTable columnArray:columnArray paramArray:paramArray columnString:columnString paramString:alloctionName];
            } else {
                NSMutableArray *columnArray = [[NSMutableArray alloc] init];
                [columnArray addObject:@"alloctionName"];
                [columnArray addObject:@"alloctionVersion"];
                
                NSMutableArray *paramArray = [[NSMutableArray alloc] init];
                [paramArray addObject:alloctionName];
                [paramArray addObject:lastVersion];
                
                result = [mDBUtil insertData:alloctionTable columnArray: columnArray paramArray:paramArray];
            }
            
            if (result == YES) {
                self.respCode = 0;
            } else {
                self.respCode = 1;
                self.respResult = @"操作异常";
            }
            
        } else {
            self.respCode = 1;
            self.respResult = @"操作异常";
        }
    }
}

/**
 *@brief 初始化数据
 *@return
 */
-(void)initdata:(NSString *)userId
{
    
    self.userIdTableName = [NSMutableString stringWithFormat:@"table%@", userId];
    
    BOOL result = [mDBUtil tableExists:self.userIdTableName];
    if (!result) {
        NSMutableString *sql = [NSMutableString stringWithFormat: @"CREATE TABLE IF NOT EXISTS %@(ID INTEGER PRIMARY KEY AUTOINCREMENT, authCode varchar(100)) ", self.userIdTableName];
        [mDBUtil createTable:sql];
    }
}

/**
 *@brief 插入数据
 *@param authCodejson 字符串 参数标示：授权码字符串
 *@return BOOL
 */
-(BOOL)insertAuthCode:(NSString *)authCodejson
{
    BOOL result = YES;
    
    result = [mDBUtil restoreID:self.userIdTableName];
    
    if (result == YES) {
        NSArray *authCodeArray = [authCodejson componentsSeparatedByString:@","];
        
        NSMutableArray *columnArray = [[NSMutableArray alloc] init];
        [columnArray addObject:@"authCode"];
        
        for (int i = 0; i < authCodeArray.count; i++) {
            NSMutableArray *paramArray = [[NSMutableArray alloc] init];
            [paramArray addObject:authCodeArray[i]];
            
            result = [mDBUtil insertData:self.userIdTableName columnArray:columnArray paramArray:paramArray];
        }
    }
    
    return result;
}

/**
 *@brief 获取授权码
 *@return NSString
 */
-(NSString *)getAuthCode
{
    int authCodeId = [mDBUtil selectOneData:self.userIdTableName columnName:@"Min(ID)"];
    
    if (0 == authCodeId) {
        return @"";
    }
    
    NSString *authCode = [mDBUtil selectOneData:self.userIdTableName columnName:@"authCode" columnString:@"ID" param:authCodeId];
    
    BOOL result = [mDBUtil deleteData:self.userIdTableName columnString:@"authCode" paramString:authCode];
    
    if (result == NO) {
        return @"";
    }
    
    return authCode;
}

/**
 *@brief 结束数据
 *@return
 */
-(void)enddata
{
    
}

/**
 *@brief 请求授权码
 *@param busiType 字符串 参数标示：业务类型
 *@param userId 字符串 参数标示：用户编号
 *@param authCodCount 字符串 参数标示：个数
 *@return
 */
- (void)authCode:(NSString *)userId authCodCount:(NSString *)authCodCount
{
    payCore.mpcp_userId = [userId UTF8String];
    payCore.b7t7_authCodCount = [authCodCount UTF8String];
    
    [self biz:@"00070007"];
}

/**
 *@brief 支付
 *@param userId 字符串 参数标示：用户编号
 *@param orderCode 字符串 参数标示：订单号
 *@param mid 字符串 参数标示：商户号
 *@param orderAmt 字符串 参数标示：金额
 *@param pwd 字符串 参数标示：支付密码
 *@param isCardNo 字符串 参数标示：卡号
 *@return
 */
- (void)pay:(NSString *)userId orderCode:(NSString *)orderCode mid:(NSString *)mid orderAmt:(NSString *)orderAmt pwd:(NSString *)pwd isCardNo:(NSString *)isCardNo
{
    payCore.mpcp_userId = [userId UTF8String];
    payCore.mpcp_orderCode = [orderCode UTF8String];
    payCore.mpcp_mid = [mid UTF8String];
    payCore.mpcp_orderAmt = [orderAmt UTF8String];
    payCore.b7t4_pwd = [pwd UTF8String];
    payCore.b7t4_isCardNo = [isCardNo UTF8String];
    
    [self biz:@"00070004"];
}

/**
 *@brief 加载数据
 *@param paramData 字符串 参数标示： 参数数据
 *@return
 */
- (void)loadData:(NSString *)paramData
{
    NSData *data = [paramData dataUsingEncoding:NSUTF8StringEncoding];
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
    NSDictionary *mer_profileDic = [dic objectForKey:@"mer_profile"];
    NSDictionary *userDic = [mer_profileDic objectForKey:@"user"];
    [CommParameter sharedInstance].userId = [userDic objectForKey:@"userid"];
    [CommParameter sharedInstance].sid = [userDic objectForKey:@"sid"];
}

/**
 *@brief 支付列表
 *@return
 */
- (void)payModeList
{
    payCore._memid = [[CommParameter sharedInstance].userId UTF8String];
    payCore._sid = [[CommParameter sharedInstance].sid UTF8String];
    
    [self biz:@"00070032"];
}

/**
*@brief 设置支付方式
*@return
*/
- (void)setPayMode:(NSDictionary *)dic
{
    payCore._memid = [[CommParameter sharedInstance].userId UTF8String];
    payCore._sid = [[CommParameter sharedInstance].sid UTF8String];
    payCore.mpcp_userId = [[CommParameter sharedInstance].userId UTF8String];
    payCore.b7t33_transType = [@"0001" UTF8String];
    payCore.b7t33_defaultFlag = [@"1" UTF8String];
    payCore.b7t33_kId = [[NSString stringWithFormat:@"%@", [dic objectForKey:@"kid"]] UTF8String];
    payCore.b7t33_tId = [[NSString stringWithFormat:@"%@", [dic objectForKey:@"tid"]] UTF8String];
    payCore.b7t33_orgId = [[NSString stringWithFormat:@"%@", [dic objectForKey:@"orgid"]] UTF8String];
    payCore.b7t33_sId = [[NSString stringWithFormat:@"%@", [dic objectForKey:@"sid"]] UTF8String];
    payCore.b7t33_mergePayIndex = [[NSString stringWithFormat:@"%@", [dic objectForKey:@"mergePayIndex"]] UTF8String];
    
    [self biz:@"00070033"];
}

/**
 *@brief 采集信息
 *@return NSString
 */
- (NSString *)machineFingerInfo
{
    //获取设备信息
    UIDevice *device = [[UIDevice alloc] init];
    NSString *systemVersion = [device systemVersion];
    NSString *model = [device model];
    NSString *uuid = [[[UIDevice currentDevice] identifierForVendor]UUIDString];
    
    //获取运营商信息
    
    //获取Wi-Fi的mac地址
    
    NSDictionary *osDic = [NSDictionary dictionaryWithObjectsAndKeys:systemVersion, @"Version", nil];
    
    NSDictionary *equipmentDic = [NSDictionary dictionaryWithObjectsAndKeys:@"苹果", @"Manufacturer", model, @"Model", uuid, @"appleId", nil];
    
    NSMutableDictionary *secondaryDic = [NSMutableDictionary dictionaryWithObjectsAndKeys:osDic, @"OS", equipmentDic, @"Equipment",nil];
    
    NSData *secondaryData = [NSJSONSerialization dataWithJSONObject:secondaryDic options:NSJSONWritingPrettyPrinted error:nil];
    
    NSString *secondary = [[NSString alloc] initWithData:secondaryData encoding:NSUTF8StringEncoding];
    
    secondary = [secondary stringByReplacingOccurrencesOfString:@"\\\\" withString:@""];
    
    secondary = [secondary stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    secondary = [secondary stringByReplacingOccurrencesOfString:@" " withString:@""];
    
    NSString *sign = [NSString stringWithUTF8String:payCore.Biz_Sign([secondary UTF8String]).Buffer()];
    
    NSDictionary *primaryDic = [NSDictionary dictionaryWithObjectsAndKeys:@"TRACE-1", @"Version", @"MOBILE", @"HostType", @"IOS", @"OSType", @"", @"IPAddress", @"", @"Coordinate", @"", @"Coordinate", sign, @"Sign", nil];
    
    NSDictionary *fpDic = [NSDictionary dictionaryWithObjectsAndKeys:secondaryDic, @"Secondary", primaryDic, @"Primary", nil];
    
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:fpDic options:NSJSONWritingPrettyPrinted error:nil];
    
    NSString *json_fp = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    
    NSString *fp = [json_fp stringByReplacingOccurrencesOfString:@"\\\\" withString:@""];
    
    fp = [fp stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    fp = [fp stringByReplacingOccurrencesOfString:@" " withString:@""];
    
    return fp;
}

@end
