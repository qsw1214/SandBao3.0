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



/**
 清除数据
 */
-(void)cleanCommParameter{
    
    _loginFlag = nil;
    _userName = nil;
    _userRealName = nil;
    _phoneNo = nil;
    _userId = nil;
    _realNameFlag = nil;
    _ownPayToolsArray = nil;
    _userInfo = nil;
    _safeQuestionFlag = nil;
    _sToken = nil;
    _nick = nil;
    _avatar = nil;
}

@end
