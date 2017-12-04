//
//  SqliteHelper.m
//  sandbao
//
//  Created by tianNanYiHao on 2017/1/9.
//  Copyright © 2017年 sand. All rights reserved.
//

#import "SqliteHelper.h"
#import "SDSqlite.h"

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
    //创建并打开sandbao数据库
    //    NSString *path = [[NSBundle mainBundle] pathForResource:@"sandbao" ofType:@"db"];
    NSString *path = [SDSqlite createDatabase:@"sandbao.db"];
    NSString *path1 = [[NSBundle mainBundle] pathForResource:@"sandBaoLi" ofType:@"db"];
    sandBaoDB = [SDSqlite open:path];
    addressDB = [SDSqlite open:path1];
    
    if (![SDSqlite tableExists:sandBaoDB tableName:@"appconfig"] )
    {
        NSString *appconfigSql = @"create table if not exists appconfig(_key verchar(50) primary key not null,_value text)";
        
        if (![SDSqlite createTable:sandBaoDB sql:appconfigSql]) {
            NSLog(@"appconfig 表创建失败");
            return NO;
        }
    }
    
    if (![SDSqlite tableExists:sandBaoDB tableName:@"minlets"] )
    {
//        NSString *minletsSql = @"create table if not exists minlets(id verchar(20) primary key not null,allowed int not null,caption verchar(20) not null,icon text not null,h5_addr text not null)";
        
        
        NSString *minletsSql = @"create table if not exists minlets(id verchar(20) primary key not null,orders verchar(20) not null,title verchar(20) not null,logo text not null,url text not null,type verchar(20) not null,isTest verchar(20) not null)";
        if (![SDSqlite createTable:sandBaoDB sql:minletsSql]) {
            NSLog(@"minlets 表创建失败");
            return NO;
        }
    }
    
    if (![SDSqlite tableExists:sandBaoDB tableName:@"usersconfig"] )
    {
        NSString *usersconfigSql = @"create table if not exists usersconfig(ID INTEGER PRIMARY KEY AUTOINCREMENT,uid verchar(20) not null,userName verchar(20) not null,active int not null,sToken verchar(50) not null,credit_fp verchar(50),lets text not null)";
        
        if (![SDSqlite createTable:sandBaoDB sql:usersconfigSql]) {
            NSLog(@"usersconfig 表创建失败");
            return NO;
        }
    }
    
    if (![SDSqlite tableExists:sandBaoDB tableName:@"mqttlist"] )
    {
        NSString *mqttlistSql = @"create table if not exists mqttlist(uid verchar(20) not null,msg verchar(20) not null,isRead int not null,indexCount int not null)";
        
        if (![SDSqlite createTable:sandBaoDB sql:mqttlistSql]) {
            NSLog(@"mqttlist 表创建失败");
            return NO;
        }
    }
    
    if ([SDSqlite tableExists:addressDB tableName:@"user1"] )
    {
        NSLog(@"user 不存在");
        return NO;
    }
    return YES;
}

@end
