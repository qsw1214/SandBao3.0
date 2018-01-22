//
//  PayNucHelper.m
//  sandbao
//
//  Created by tianNanYiHao on 2017/1/3.
//  Copyright © 2017年 sand. All rights reserved.
//

#import "PayNucHelper.h"
#import "SDSqlite.h"
#import "SqliteHelper.h"

#include "HttpComm.h"
#import "SDLog.h"
#import <SystemConfiguration/CaptiveNetwork.h>

/*
 run_ok              = 0,
 msg_parse_err       = 1,
 msg_protocol_err    = 2,
 msg_sign_err        = 3,
 tube_expire         = 4,
 hmac_err            = 5,
 token_invalid       = 6,
 do_nothing          = 7
 */

PayNuc paynuc;

//第一步：静态实例，并初始化。
static PayNucHelper *payNucHelperSharedInstance = nil;

@implementation PayNucHelper

@synthesize fr;
@synthesize respCode;
@synthesize respResult;

//第二步：实例构造检查静态实例是否为nil
+ (PayNucHelper *) sharedInstance
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        payNucHelperSharedInstance = [[PayNucHelper alloc] init];
    });
    
    return payNucHelperSharedInstance;
}

/**
 *@brief 生产环境和测试环境切换
 *@param flag BOOL 参数标示：切换生产和测试环境标识
 */
- (void)changeEnvironment:(BOOL)flag
{
    
    PostWithData_Address = PostWithData;
    paynuc.init();
    paynuc.set("cfg_appMark", "sandbao-ios-1.0");
    paynuc.set("cfg_termFp", [[Tool setCfgTempFpStaticDataFlag:YES DynamicDataFlag:NO] UTF8String]);
    
    if (flag) {
        paynuc.set("cfg_test", "true");
        paynuc.set("cfg_debug", "true");
        paynuc.set("cfg_httpAddress", [[NSString stringWithFormat:@"%@app/api/",AddressHTTP] UTF8String]);
        [SDLog setLogFlag:YES];

    } else {
        paynuc.set("cfg_test", "false");
        paynuc.set("cfg_debug", "true");
        paynuc.set("cfg_httpAddress", [[NSString stringWithFormat:@"%@app/api/",AddressHTTP] UTF8String]);//生产
        [SDLog setLogFlag:NO];
    }
}


/**
 获取终端附近的WIFI的SSID列表

 @return 列表信息
 */
- (id)getSSIDInfo {
    NSArray *ifs = (__bridge_transfer id)CNCopySupportedInterfaces();
    NSLog(@"Supported interfaces: %@", ifs);
    id info = nil;
    for (NSString *ifnam in ifs) {
        info = (__bridge_transfer id)CNCopyCurrentNetworkInfo((__bridge CFStringRef)ifnam);
        NSLog(@"%@ => %@", ifnam, info);
        if (info && [info count]) { break; }
    }
    return info;
}

/**
 *@brief 请求
 *@param url 字符串 参数标示：请求url后半部分
 *@return int run_ok = 0,msg_parse_err = 1,msg_protocol_err = 2,msg_sign_err = 3,tube_expire = 4,hmac_err = 5,resp_err = 6,token_invalid = 7,do_nothing = 8
 */
- (int)requestResult:(NSString *)url
{
    return paynuc.func([url UTF8String]);
}

/**
 *@brief 请求
 *@param url 字符串 参数标示：请求url后半部分
 *@param paynuc_key 字符串 参数标示：paynuc的set方法前半部分
 *@param paynuc_value 字符串 参数标示：paynuc的set方法后半部分
 *@return int run_ok = 0,msg_parse_err = 1,msg_protocol_err = 2,msg_sign_err = 3,tube_expire = 4,hmac_err = 5,resp_err = 6,token_invalid = 7,do_nothing = 8
 */
- (int)requestResult:(NSString *)url paynuc_key:(NSString *)paynuc_key paynuc_value:(NSString *)paynuc_value
{
    if (paynuc_key != nil && ![@"" isEqualToString:paynuc_key]) {
        NSString *jsonStr = @"";
        if (paynuc_value != nil && ![@"" isEqualToString:paynuc_value]) {
            jsonStr = paynuc_value;
        } else {
            jsonStr = @"";
        }
        paynuc.set([paynuc_key UTF8String], [jsonStr UTF8String]);
        return paynuc.func([url UTF8String]);
    } else {
        return paynuc.func([url UTF8String]);
    }
    
}

/**
 *@brief 请求
 *@param url 字符串 参数标示：请求url后半部分
 *@param paynuc_key 字符串 参数标示：paynuc的set方法前半部分
 *@param paynuc_valueDic NSMutableDictionary 参数标示：paynuc的set方法后半部分
 *@return int run_ok = 0,msg_parse_err = 1,msg_protocol_err = 2,msg_sign_err = 3,tube_expire = 4,hmac_err = 5,resp_err = 6,token_invalid = 7,do_nothing = 8
 */
- (int)requestResult:(NSString *)url paynuc_key:(NSString *)paynuc_key paynuc_valueDic:(NSMutableDictionary *)paynuc_valueDic
{
    if (paynuc_key != nil && ![@"" isEqualToString:paynuc_key]) {
        NSString *jsonStr = @"";
        if (paynuc_valueDic != nil) {
            jsonStr = [self dictionaryToJson:paynuc_valueDic];
        } else {
            jsonStr = @"";
        }
        paynuc.set([paynuc_key UTF8String], [jsonStr UTF8String]);
        return paynuc.func([url UTF8String]);
    } else {
        return paynuc.func([url UTF8String]);
    }
    
}

/**
 *@brief 获取json字符串
 *@param getKey 字符串 参数标示：获取json的key对应的值
 *@return 字符串
 */
- (NSString *)paynucGet:(NSString *)getKey
{
    return [NSString stringWithUTF8String:paynuc.get([getKey UTF8String]).c_str()];
}

/**
 *@brief 获取信息
 *@param json 字符串 参数标示：json字符串
 *@param duid 字符串 参数标示：要查询的值
 *@return 字符串
 */
-(NSString *)jsonToString:(NSString *)json key:(NSString *)key
{
    NSError *error;
    NSString *result = @"";
    NSArray *array = [key componentsSeparatedByString:@"_"];
    NSInteger count = [array count] -1;
    
    if (count == 1) {
        NSString *messageKey = [array objectAtIndex:1];
        
        NSData *jsonData = [json dataUsingEncoding:NSUTF8StringEncoding];
        NSDictionary *jsonDic = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableLeaves error:&error];
        NSDictionary *busiInfoDic = [jsonDic objectForKey:@"busiInfo"];
        result = [busiInfoDic objectForKey:messageKey];
    } else if (count == 2){
        NSString *firstKey =[array objectAtIndex:1];
        NSString *messageKey = [array objectAtIndex:2];
        
        NSData *jsonData = [json dataUsingEncoding:NSUTF8StringEncoding];
        NSDictionary *jsonDic = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableLeaves error:&error];
        NSDictionary *firstDic = [jsonDic objectForKey:@"busiInfo"];
        NSDictionary *busiInfoDic = [firstDic objectForKey:firstKey];
        result = [busiInfoDic objectForKey:messageKey];
    } else {
        NSString *firstKey =[array objectAtIndex:1];
        NSString *secondKey =[array objectAtIndex:2];
        NSString *messageKey = [array objectAtIndex:3];
        
        NSData *jsonData = [json dataUsingEncoding:NSUTF8StringEncoding];
        NSDictionary *jsonDic = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableLeaves error:&error];
        NSDictionary *firstDic = [jsonDic objectForKey:@"busiInfo"];
        NSDictionary *secoundDic = [firstDic objectForKey:firstKey];
        NSDictionary *busiInfoDic = [secoundDic objectForKey:secondKey];
        result = [busiInfoDic objectForKey:messageKey];
    }
    return result;
}

/**
 *@brief 获取信息（字典模式）
 *@param json 字符串 参数标示：json字符串
 *@param duid 字符串 参数标示：要查询的值
 *@return 字典
 */
-(NSDictionary *)jsonToDictionary:(NSString *)json key:(NSString *)key
{
    NSError *error;
    NSDictionary *dicInfo;
    NSArray *array = [key componentsSeparatedByString:@"_"];
    NSInteger count = [array count] -1;
    
    if (count == 1) {
        NSString *messageKey = [array objectAtIndex:1];
        
        NSData *jsonData = [json dataUsingEncoding:NSUTF8StringEncoding];
        NSDictionary *jsonDic = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableLeaves error:&error];
        NSDictionary *busiInfoDic = [jsonDic objectForKey:@"busiInfo"];
        dicInfo = [busiInfoDic objectForKey:messageKey];
    } else if (count == 2){
        NSString *firstKey =[array objectAtIndex:1];
        NSString *messageKey = [array objectAtIndex:2];
        
        NSData *jsonData = [json dataUsingEncoding:NSUTF8StringEncoding];
        NSDictionary *jsonDic = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableLeaves error:&error];
        NSDictionary *firstDic = [jsonDic objectForKey:@"busiInfo"];
        NSDictionary *busiInfoDic = [firstDic objectForKey:firstKey];
        dicInfo = [busiInfoDic objectForKey:messageKey];
    } else {
        NSString *firstKey =[array objectAtIndex:1];
        NSString *secondKey =[array objectAtIndex:2];
        NSString *messageKey = [array objectAtIndex:3];
        
        NSData *jsonData = [json dataUsingEncoding:NSUTF8StringEncoding];
        NSDictionary *jsonDic = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableLeaves error:&error];
        NSDictionary *firstDic = [jsonDic objectForKey:@"busiInfo"];
        NSDictionary *secoundDic = [firstDic objectForKey:firstKey];
        NSDictionary *busiInfoDic = [secoundDic objectForKey:secondKey];
        dicInfo = [busiInfoDic objectForKey:messageKey];
    }
    return dicInfo;
}


/**
 *@brief 获取信息（数组模式）
 *@param json 字符串 参数标示：json字符串
 *@param duid 字符串 参数标示：要查询的值
 *@return 数组
 */
-(NSMutableArray *)jsonToArray:(NSString *)json key:(NSString *)key
{
    NSError *error;
    NSMutableArray *arrayInfo;
    NSArray *array = [key componentsSeparatedByString:@"_"];
    NSInteger count = [array count] -1;
    
    if (count == 1) {
        NSString *messageKey = [array objectAtIndex:1];
        
        NSData *jsonData = [json dataUsingEncoding:NSUTF8StringEncoding];
        NSDictionary *jsonDic = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableLeaves error:&error];;
        NSDictionary *busiInfoDic = [jsonDic objectForKey:@"busiInfo"];
        arrayInfo = [busiInfoDic objectForKey:messageKey];
    } else if (count == 2){
        NSString *firstKey =[array objectAtIndex:1];
        NSString *messageKey = [array objectAtIndex:2];
        
        NSData *jsonData = [json dataUsingEncoding:NSUTF8StringEncoding];
        NSDictionary *jsonDic = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableLeaves error:&error];;
        NSDictionary *firstDic = [jsonDic objectForKey:@"busiInfo"];
        NSDictionary *busiInfoDic = [firstDic objectForKey:firstKey];
        arrayInfo = [busiInfoDic objectForKey:messageKey];
    } else {
        NSString *firstKey =[array objectAtIndex:1];
        NSString *secondKey =[array objectAtIndex:2];
        NSString *messageKey = [array objectAtIndex:3];
        
        NSData *jsonData = [json dataUsingEncoding:NSUTF8StringEncoding];
        NSDictionary *jsonDic = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableLeaves error:&error];;
        NSDictionary *firstDic = [jsonDic objectForKey:@"busiInfo"];
        NSDictionary *secoundDic = [firstDic objectForKey:firstKey];
        NSDictionary *busiInfoDic = [secoundDic objectForKey:secondKey];
        arrayInfo = [busiInfoDic objectForKey:messageKey];
    }
    return arrayInfo;
}

/**
 *@brief 获取信息（字典模式）
 *@param jsonString 字符串 参数标示：json字符串
 *@return 字典
 */
-(NSDictionary *)jsonStringToDictionary:(NSString *)jsonString
{
    NSError *error;
    NSData *jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    NSDictionary *jsonDic = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableLeaves error:&error];
    return jsonDic;
}

/**
 *@brief 字典（NSMutableDictionary）转字符串（NSString）
 *@param dic NSMutableDictionary 参数标示：json字典
 *@return 字符串
 */
- (NSString *)dictionaryToJson:(NSMutableDictionary *)dic
{
    if (dic != nil) {
        NSError *error;
        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dic options:NSJSONWritingPrettyPrinted error:&error];
        NSString *str = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
        return [[str stringByReplacingOccurrencesOfString:@"\n" withString:@""] stringByReplacingOccurrencesOfString:@" " withString:@""];
    }
    
    return @"";
}

/**
 *@brief 获取信息（数组模式）
 *@param jsonString 字符串 参数标示：json字符串
 *@return 字典
 */
-(NSArray *)jsonStringToArray:(NSString *)jsonString
{
    NSError *error;
    NSData *jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    NSArray *tempArray = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableLeaves error:&error];
    return tempArray;
}

/**
 *@brief 数组转换成json字符串
 *@param paramArray NSMutableArray 参数标示：参数数组
 *@return 数组
 */
- (NSString *)arrayToJSON:(NSMutableArray *)paramArray
{
    NSString *jsonStr = @"[";
    if (paramArray && paramArray.count > 0) {
        
        for (int i = 0; i < paramArray.count; i++) {
            NSDictionary *dic = paramArray[i];
            NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dic options:NSJSONWritingPrettyPrinted error:nil];
            NSString *jsonText = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
            
            if (i != 0) {
                jsonStr = [jsonStr stringByAppendingString:@","];
            }
            jsonStr = [jsonStr stringByAppendingString:jsonText];
        }
    }
    
    jsonStr = [jsonStr stringByAppendingString:@"]"];
    
    return [[jsonStr stringByReplacingOccurrencesOfString:@"\n" withString:@""] stringByReplacingOccurrencesOfString:@" " withString:@""];
}


/**
 *@brief 加载-创建通道
 *@return BOOL
 */
- (BOOL)load
{
    int result = paynuc.func("CreateTube");
    if (result == 0) {
        return YES;
    } else {
        return NO;
    }
}







/**
 当tubeID失效时,重新唤起流程
 
 @param frCode 标志
 @param funcName func名
 */
- (BOOL)createTubeIfFr:(int)frCode TubeIDFailure:(NSString *)funcName{
    
    if (frCode == 4) {
        NSString *sToken = [NSString stringWithUTF8String:paynuc.get("sToken").c_str()];
        NSString *tToken = [NSString stringWithUTF8String:paynuc.get("tToken").c_str()];
        paynuc.func("CreateTube");
        paynuc.set("sToken",[sToken UTF8String]);
        paynuc.set("tToken",[tToken UTF8String]);
        paynuc.func([funcName UTF8String]);
        
        return YES;
    }
    return NO;

    
}








/**
 支付密码明转密
 
 @param passwd 明文字符串
 @param type 密码类型
 @return 密文字符串
 */
-(NSString*)pinenc:(NSString*)passwd type:(NSString*)type{
    
    if ([type isEqualToString:@"paypass"]) {
        //根据业务需求,paypass补足8位
        NSString *str ;
        passwd = [NSString stringWithFormat:@"%@  ",passwd];
        str = [NSString stringWithUTF8String:paynuc.pinenc([passwd UTF8String]).c_str()];
        return str;
    }
    else if([type isEqualToString:@"accpass"]){
        //根据业务需求,accpass补足8位
        NSString *str ;
        passwd = [NSString stringWithFormat:@"%@  ",passwd];
        str = [NSString stringWithUTF8String:paynuc.pinenc([passwd UTF8String]).c_str()];
        return str;
    }else{
        
        return passwd;
    }
  
}


/**
 limit域最大限额
 
 @param limit limit域
 @return 返回最大限额
 */
-(NSDecimalNumber*)limitInfo:(NSDictionary*)limitDic{
    
    //单月最高
    NSString *month = [limitDic objectForKey:@"month"];

    //单月可用
    NSString *monthRemain = [limitDic objectForKey:@"monthRemain"];
    CGFloat monthRemainFloat = [monthRemain floatValue];
    //单日最高
    NSString *day = [limitDic objectForKey:@"day"];

    //单日可用
    NSString *dayRemain = [limitDic objectForKey:@"dayRemain"];
    CGFloat dayRemainFloat = [dayRemain floatValue];
    
    //单笔
    NSString *single = [limitDic objectForKey:@"single"];
    CGFloat singleFloat = [single floatValue];
    
    monthRemainFloat = monthRemainFloat<dayRemainFloat?monthRemainFloat:dayRemainFloat;
    monthRemainFloat = monthRemainFloat<singleFloat?monthRemainFloat:singleFloat;
    
    
    NSDecimalNumber *limitDec = [NSDecimalNumber decimalNumberWithString:[NSString stringWithFormat:@"%f",monthRemainFloat]];
    //分转换为元
    NSDecimalNumber *hundredDec = [NSDecimalNumber decimalNumberWithString:@"100"];
    limitDec = [limitDec decimalNumberByDividingBy:hundredDec];
    
    return limitDec;
}


@end
