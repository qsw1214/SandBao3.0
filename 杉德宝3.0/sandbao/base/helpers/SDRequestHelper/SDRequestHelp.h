//
//  SDRequestHelp.h
//  sandbao
//
//  Created by tianNanYiHao on 2017/8/11.
//  Copyright © 2017年 sand. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SDMBProgressView.h"

/**
 请求成功/失败类型

 - successType: 成功type
 - frErrorType: fr失败type
 - respCodeErrorType: respCode失败type
 - otherErrorType: 其他type
 */
typedef NS_ENUM(NSInteger,SDRequestErrorType){
    successType = 0,
    frErrorType,
    respCodeErrorType,
    otherErrorType
};

/**
 成功回调Block:若有UI操作,则需要在主线程中刷新
 */
typedef void(^SDResponseSuccessBlock)();

/**
 失败回调Block
 (一般请求失败情况没有特殊处理则用不到SDRequestErrorType来区分error类型,若有失败需要特殊处理,请使用type进行区分)
 (关于HUD处理:请求成功则通过block回调确认是否hidden,请求失败则均做hidden处理)
 */
typedef void(^SDResponseErrorBlock)(SDRequestErrorType type);


/**
 主线程回调Block
 */
typedef void(^SDDispatchMainQueue)();


/**
 开全局线程
 */
typedef void(^SDDispatchGlobalQueue)();

@interface SDRequestHelp : NSObject


/**
 接收的每个页面的HUD,以便处理
 */
@property (nonatomic, strong) SDMBProgressView *HUD;


/**
 接受的每个控制器,以便失败处理
 */
@property (nonatomic, strong) UIViewController *controller;



//单利构造方法
+ (instancetype)shareSDRequest;


/**
 开启异步线程方法
 
 @param bclok 方法块
 */
- (void)dispatchGlobalQuque:(SDDispatchGlobalQueue)bclok;



/**
 返回主线程方法
 
 @param block 方法块
 */
- (void)dispatchToMainQueue:(SDDispatchMainQueue)block;



/**
 网络请求

 @param funcname 流程名称
 @param errorBlock 失败回调(携带失败type:需要则使用,不需要则可忽略)
 @param successBlock 成功回调
 */
- (void)requestWihtFuncName:(NSString*)funcname errorBlock:(SDResponseErrorBlock)errorBlock successBlock:(SDResponseSuccessBlock)successBlock;











/*
//获取Stoken
- (void)token_getStoken_v1;

//获取Ttoke
- (void)token_getTtoken_v1;

//查询鉴权工具
- (void)authTool_getAuthTools_v1;

//查询待注册鉴权工具
- (void)authTool_getRegAuthTools_v1;

//上送鉴权工具进行鉴权
- (void)authTool_setAuthTools_v1;

//用户校验
- (void)user_checkUser_v1;

//用户注册
- (void)user_register_v1;

//用户登录
- (void)user_login_v1;

//销毁用户上下文环境(登出)
- (void)user_logout_v1;

//获取鉴权工具集组描述
- (void)authTool_getAuthGroups_v1;

//获取鉴权工具集
- (void)authTool_getAuthToolsForAuthGroup_v1;

//重置登录密码
- (void)authTool_setRegAuthTools_v1;

//银行卡解卡
- (void)card_unbandCard_v1;

//查询银行卡信息
- (void)card_queryCardDetail_v1;

//银行卡绑卡
- (void)card_bandCard_v1;

//实名认证
- (void)user_setRealName_v1;

//更换手机号
- (void)user_resetPhoneNo_v1;

//查询用户信息
- (void)user_queryInfo_v1;

//查询绑定支付工具
- (void)payTool_getOwnPayTools_v1;

//开通快捷
- (void)card_openFastPay_v1;

//用户基础信息修改
- (void)user_resetUserBaseInfo_v1;

//修改用户绑定的所有支付工具使用顺序
- (void)payTool_setOwnPayToolOrder_v1;

//获取用户登录授权码
- (void)user_getLoginCode_v1;

//手机APP对登录授权码授权
- (void)user_setLoginCode_v1;

//根据待充值的账户查询可用于充值的支付工具
- (void)payTool_getPayTools_v1;

//手续费计算
- (void)business_fee_v1;

//支付(充值转账提现)
- (void)business_acc2acc_v1;

//根据待转账接收人查询可用于转账的支付工具
- (void)payTool_getOtherPayTools_v1;

//获取支付工具
- (void)payTool_getPayToolsForPay_v1;

//支付(SPS支付,扫码付等)
- (void)business_pay_v1;

//查询账户余额
- (void)payTool_getBalances_v1;

//查询用户授权码
- (void)user_getAuthCodes_v1;


*/

@end
