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
    
    _userName = nil;
    _userRealName = nil;
    _phoneNo = nil;
    _userId = nil;
    _realNameFlag = nil;
    _payPassFlag = nil;
    _PayForAnthoerFlag = nil;
    _ownPayToolsArray = nil;
    _userInfo = nil;
    _safeQuestionFlag = nil;
    _sToken = nil;
    _nick = nil;
    _avatar = nil;
    
}

@end
