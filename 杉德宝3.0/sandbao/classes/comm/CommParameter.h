//
//  CommParameter.h
//  sandbao
//
//  Created by tianNanYiHao on 2016/11/28.
//  Copyright © 2016年 sand. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CommParameter : NSObject

@property (nonatomic, assign) BOOL loginFlag;
@property (nonatomic, strong) NSString *userName; //用户名
@property (nonatomic, strong) NSString *userRealName; //用户实名
@property (nonatomic, strong) NSString *phoneNo; //手机号
@property (nonatomic, strong) NSString *userId;  //用户id
@property (nonatomic, assign) BOOL realNameFlag; //实名认证flag
@property (nonatomic, strong) NSArray *ownPayToolsArray; //我方支付工具组
@property (nonatomic, strong) NSString *userInfo; //用户信息
@property (nonatomic, assign) BOOL safeQuestionFlag; //开通快捷flag
@property (nonatomic, strong) NSString *sToken;
@property (nonatomic, strong) NSString *nick; //昵称
@property (nonatomic, strong) NSString *avatar; //头像




//@property (nonatomic, strong) NSString *mid;
//@property (nonatomic, strong) NSString *token;
//@property (nonatomic, strong) NSString *uuid;
//@property (nonatomic, strong) NSString *deviceVersion;
//@property (nonatomic, strong) NSString *phoneSystemVersion;
//@property (nonatomic, strong) NSString *appVersion;
//@property (nonatomic, assign) int selectIndex;


//实例构造检查静态实例是否为nil
+ (CommParameter *) sharedInstance;




/**
 清除数据
 */
-(void)cleanCommParameter;


@end
