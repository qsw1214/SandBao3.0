//
//  CommParameter.m
//  sandbao
//
//  Created by tianNanYiHao on 2016/11/28.
//  Copyright © 2016年 sand. All rights reserved.
//

#import "CommParameter.h"

//第一步：静态实例，并初始化。
static CommParameter *commParameterSharedInstance = nil;

@implementation CommParameter

//第二步：实例构造检查静态实例是否为nil
+ (CommParameter *) sharedInstance
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        commParameterSharedInstance = [[CommParameter alloc] init];
    });
    
    return commParameterSharedInstance;
}

- (void)showCommParameter{
    
    NSLog(@"******************************");
    
    NSLog(@" _userName :%@",_userName);
    NSLog(@" _userRealName :%@",_userRealName);
    NSLog(@" _phoneNo :%@",_phoneNo);
    NSLog(@" _userId :%@",_userId);
    NSLog(@" _realNameFlag :%d",_realNameFlag);
    NSLog(@" _payPassFlag :%d",_payPassFlag);
    NSLog(@" _PayForAnthoerFlag :%d",_PayForAnthoerFlag);
    
    NSLog(@" _safeQuestionFlag :%d",_safeQuestionFlag);
    NSLog(@" _nick :%@",_nick);
    NSLog(@" _avatar :%@",_avatar);
    NSLog(@" _ownPayToolsArray :%@",_ownPayToolsArray);
    NSLog(@" _userInfo :%@",_userInfo);
    
    NSLog(@"******************************");
    
}

/**
 清除数据
 */
-(void)cleanCommParameter{
    
    _sToken = nil;   //用户活动状态标识
    _userInfo = nil; //用户信息
    
    _userName = nil; //用户名
    _userRealName = nil; //用户实名
    _phoneNo = nil; //手机号
    _userId = nil;  //用户id
    _nick = nil; //昵称
    _avatar = nil; //头像
    
    _realNameFlag = nil; //实名认证flag
    _payPassFlag = nil;  //是否设置支付密码flag
    _PayForAnthoerFlag = nil; //代付凭证是否激活标志
    _safeQuestionFlag = nil; //开通快捷flag
    
    _ownPayToolsArray = nil; //我方支付工具组

}

@end
