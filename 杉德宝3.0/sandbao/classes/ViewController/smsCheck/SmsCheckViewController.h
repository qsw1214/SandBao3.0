//
//  SmsCheckViewController.h
//  sandbao
//
//  Created by tianNanYiHao on 2017/10/18.
//  Copyright © 2017年 sand. All rights reserved.
//

#import "BaseViewController.h"

@interface SmsCheckViewController : BaseViewController

#pragma mark - 共用属性
/**
 共用属性:手机号
 */
@property (nonatomic, strong) NSString *phoneNoStr;


/**
 共用属性:短信的用途类型
 */
@property (nonatomic, assign) NSInteger smsCheckType;

/**
 共用属性:六位短信码字符串
 */
@property (nonatomic, strong) NSString *smsCodeString;



#pragma mark - 登陆模式下属性

/**
 加强鉴权:发送短信成功后执行登陆所需的 鉴权工具
 */
@property (nonatomic, strong) NSMutableArray *authToolArray;


/**
 加强鉴权:发送短信成功后执行登陆所需的 用户信息
 */
@property (nonatomic, strong) NSString *userInfo;


#pragma mark - 实名模式下属性

/**
 实名认证:工具字典
 */
@property (nonatomic, strong) NSDictionary *payToolDic;

/**
 实名认证:用户信息字典
 */
@property (nonatomic, strong) NSDictionary *userInfoDic;


/**
 实名认证:四要素:信用卡校验码
 */
@property (nonatomic, strong) NSString *cvnStr;

/**
 实名认证:四要素:信用卡有效期
 */
@property (nonatomic, strong) NSString *expiryStr;

/**
 实名认证:四要素:身份证号
 */
@property (nonatomic, strong) NSString *identityNoStr;

/**
 实名认证:四幺四:姓名
 */
@property (nonatomic, strong) NSString *realNameStr;

/**
 实名认证:四要素:卡号
 */
@property (nonatomic, strong) NSString *bankCardNoStr;

@end
