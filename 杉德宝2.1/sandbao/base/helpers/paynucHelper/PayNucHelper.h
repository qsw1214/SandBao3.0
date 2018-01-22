//
//  PayNucHelper.h
//  sandbao
//
//  Created by tianNanYiHao on 2017/1/3.
//  Copyright © 2017年 sand. All rights reserved.
//

#import <Foundation/Foundation.h>
#include "PayNuc.h"

extern PayNuc paynuc;

@interface PayNucHelper : NSObject

@property (nonatomic, assign) int fr;
@property (nonatomic, assign) int respCode;
@property (nonatomic, strong) NSString *respResult;



//实例构造检查静态实例是否为nil
+ (PayNucHelper *) sharedInstance;

/**
 *@brief 生产环境和测试环境切换
 *@param flag BOOL 参数标示：切换生产和测试环境标识
 */
- (void)changeEnvironment:(BOOL)flag;

/**
 *@brief 请求 - paynuc_value字符串模式
 *@param url 字符串 参数标示：请求url后半部分
 *@param paynuc_key 字符串 参数标示：paynuc的set方法前半部分
 *@param paynuc_value 字符串 参数标示：paynuc的set方法后半部分
 *@return int run_ok = 0,msg_parse_err = 1,msg_protocol_err = 2,msg_sign_err = 3,tube_expire = 4,hmac_err = 5,resp_err = 6,token_invalid = 7,do_nothing = 8
 */
- (int)requestResult:(NSString *)url paynuc_key:(NSString *)paynuc_key paynuc_value:(NSString *)paynuc_value;

/**
 *@brief 请求 paynuc_value字典模式
 *@param url 字符串 参数标示：请求url后半部分
 *@param paynuc_key 字符串 参数标示：paynuc的set方法前半部分
 *@param paynuc_valueDic NSMutableDictionary 参数标示：paynuc的set方法后半部分
 *@return int run_ok = 0,msg_parse_err = 1,msg_protocol_err = 2,msg_sign_err = 3,tube_expire = 4,hmac_err = 5,resp_err = 6,token_invalid = 7,do_nothing = 8
 */
- (int)requestResult:(NSString *)url paynuc_key:(NSString *)paynuc_key paynuc_valueDic:(NSMutableDictionary *)paynuc_valueDic;

/**
 *@brief 获取json字符串
 *@param getKey 字符串 参数标示：获取json的key对应的值
 *@return 字符串
 */
- (NSString *)paynucGet:(NSString *)getKey;

/**
 *@brief 获取信息
 *@param devID 字符串 参数标示：json字符串
 *@param duid 字符串 参数标示：要查询的值
 *@return 字符串
 */
-(NSString *)jsonToString:(NSString *)json key:(NSString *)key;

/**
 *@brief 获取信息（字典模式）
 *@param devID 字符串 参数标示：json字符串
 *@param duid 字符串 参数标示：要查询的值
 *@return 字典
 */
-(NSDictionary *)jsonToDictionary:(NSString *)json key:(NSString *)key;


/**
 *@brief 获取信息（数组模式）
 *@param devID 字符串 参数标示：json字符串
 *@param duid 字符串 参数标示：要查询的值
 *@return 数组
 */
-(NSMutableArray *)jsonToArray:(NSString *)json key:(NSString *)key;

/**
 *@brief 获取信息（字典模式）
 *@param jsonString 字符串 参数标示：json字符串
 *@return 字典
 */
-(NSDictionary *)jsonStringToDictionary:(NSString *)jsonString;

/**
 *@brief 字典（NSMutableDictionary）转字符串（NSString）
 *@param dic NSMutableDictionary 参数标示：json字典
 *@return 字符串
 */
- (NSString *)dictionaryToJson:(NSMutableDictionary *)dic;

/**
 *@brief 获取信息（数组模式）
 *@param jsonString 字符串 参数标示：json字符串
 *@return 字典
 */
-(NSArray *)jsonStringToArray:(NSString *)jsonString;

/**
 *@brief 数组转换成json字符串
 *@param paramArray NSMutableArray 参数标示：参数数组
 *@return 数组
 */
- (NSString *)arrayToJSON:(NSMutableArray *)paramArray;

/**
 *@brief 加载-创建通道
 *@return BOOL
 */
- (BOOL)load;



/**
 当tubeID失效时,重新唤起流程

 @param fr 标志
 @param funcName func名
 */
- (BOOL)createTubeIfFr:(int)frCode TubeIDFailure:(NSString *)funcName;










/**
 支付密码明转密

 @param passwd 明文字符串
 @param type 密码类型
 @return 密文字符串
 */
-(NSString*)pinenc:(NSString*)passwd type:(NSString*)type;


/**
 limit域最大限额

 @param limit limit域
 @return 返回最大限额
 */
-(NSDecimalNumber*)limitInfo:(NSDictionary*)limit;



@end
