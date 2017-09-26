//
//  Majlet_Func.m
//  sandbao
//
//  Created by tianNanYiHao on 2016/11/24.
//  Copyright © 2016年 sand. All rights reserved.
//

#import "Majlet_Func.h"
#import "SqliteHelper.h"
#import "PayNucHelper.h"



@implementation Majlet_Func

/**
 *@brief 创建单例
 */
static Majlet_Func *mMajlet_Func = nil;

+ (Majlet_Func *)shareMajlet_Func
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        mMajlet_Func = [[Majlet_Func alloc] init];
    });
    return mMajlet_Func;
}

/**
 *@brief 加载
 */
- (BOOL)load
{
    //1. 加载数据库
    BOOL result1 = [[SqliteHelper shareSqliteHelper] load];
    if (!result1) {
        return NO;
    }
    
    //2. 加载认证
     BOOL result2 = [[PayNucHelper sharedInstance] load];
    if (!result2) {
        return NO;
    }
    return YES;
}

@end
