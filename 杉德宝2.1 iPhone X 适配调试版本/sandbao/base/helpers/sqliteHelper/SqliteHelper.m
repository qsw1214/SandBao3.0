//
//  SqliteHelper.m
//  sandbao
//
//  Created by tianNanYiHao on 2017/1/9.
//  Copyright © 2017年 sand. All rights reserved.
//

#import "SqliteHelper.h"


static SqliteHelper *mSqliteHelper = nil;

@implementation SqliteHelper


@synthesize sandBaoDB;
@synthesize addressDB;


/**
 *@brief 创建单例
 */
+ (SqliteHelper *)shareSqliteHelper
{
    if (nil == mSqliteHelper) {
        mSqliteHelper = [[SqliteHelper alloc] init];
    }
    return mSqliteHelper;
}

/**
 *@brief  初始化数据库
 */
- (BOOL)load
{
    return YES;
}

@end
