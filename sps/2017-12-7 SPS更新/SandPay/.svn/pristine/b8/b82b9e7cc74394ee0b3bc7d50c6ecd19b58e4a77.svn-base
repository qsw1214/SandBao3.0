//
//  DBUtil.h
//  sand_bluesky_demonstration
//
//  Created by blue sky on 15/4/25.
//  Copyright (c) 2015年 sand. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DBUtil : NSObject {
    NSString *_dbPath;
    BOOL _logFlag;
}

- (void)setDbPath:(NSString *)newDbPath;
- (NSString *)dbPath;

- (void)setLogFlag:(BOOL)newLogFlag;
- (BOOL)logFlag;

/**
 *@brief 创建单例
 */
+ (DBUtil *)shareDB;

/**
 *@brief 列的拼接
 *@param array    数组 列的标题
 *@param symbol  符号
 *@return NSString
 */
+ (NSString *)stringAppding:(NSMutableArray *)array symbol:(NSString *)symbol;

/**
 *@brief 创建数据库
 *@param databaseName    字符串  数据库名称
 *@return BOOL
 */
- (void)createDatabase:(NSString *)databaseName;

/**
 *@brief 打开数据库
 *@return BOOL
 */
- (BOOL)openDB;

/**
 *@brief 关闭数据库
 *@return BOOL
 */
- (BOOL)closeDB;

/**
 *@brief 判断表是否存在
 *@param 字符串 tableName 表名称
 *@return Bool
 */

- (BOOL)tableExists:(NSString *)tableName;

/**
 *@brief 还原id主键值为0
 *@param tableName    字符串  表名称
 *@return BOOL
 */
- (BOOL)restoreID:(NSString *)tableName;

/**
 *@brief 创建表
 *@param tableSql    字符串  创建表sql字符串
 *@return BOOL
 */
- (BOOL)createTable:(NSString *)tableSql;

/**
 *@brief 插入数据
 *@param tableName  NSString  表名字
 *@param columnArray  NSArray  列数组
 *@param paramArray  NSArray  列值数组
 *@return BOOL
 */
- (BOOL)insertData:(NSString *)tableName columnArray:(NSMutableArray *) columnArray paramArray:(NSMutableArray *)paramArray;

/**
 *@brief 更新数据
 *@param tableName    字符串  表名称
 *@param columnArray  数组  表的列名称
 *@param paramArray   数组   表的列的值
 *@param columnString  字符串  表的列名称
 *@param paramString   字符串   表的列的值
 *@return BOOL
 */
- (BOOL)updateData:(NSString *)tableName columnArray:(NSMutableArray *) columnArray paramArray:(NSMutableArray *)paramArray columnString:(NSString *) columnString paramString:(NSString *)paramString;

/**
 *@brief 删除数据
 *@param tableName    字符串  表名称
 *@param columnString  字符串  表的列名称
 *@param paramString   字符串   表的列的值
 *@return BOOL
 */
- (BOOL)deleteData:(NSString *)tableName columnString:(NSString *)columnString paramString:(NSString *)paramString;

/**
 *@brief 删除数据
 *@param tableName    字符串  表名称
 *@param columnString  字符串  表的列名称
 *@param param   整形   表的列的值
 *@return BOOL
 */
- (BOOL)deleteData:(NSString *)tableName columnString:(NSString *)columnString param:(int)param;

/**
 *@brief 删除表所有数据
 *@param tableName    字符串  表名称
 *@return BOOL
 */

- (BOOL)deleteAllData:(NSString *) tableName;

/**
 *@brief 查询数据
 *@param tableName    字符串  表名称
 *@param columnArray  数组  表的列名称
 *@return NSMutableArray
 */
- (NSMutableArray *)selectData:(NSString *) tableName columnArray:(NSMutableArray *) columnArray;

/**
 *@brief 根据条件查询数据
 *@param tableName    字符串  表名称
 *@param columnArray  数组  表的列名称
 *@param columnString  字符串  表的列名称
 *@param paramString   字符串   表的列的值
 *@return NSMutableArray
 */

- (NSMutableArray *)selectWhereData:(NSString *) tableName columnArray:(NSMutableArray *) columnArray columnString:(NSString *) columnString paramString:(NSString *)paramString;

/**
 *@brief 分页查询数据
 *@param tableName    字符串  表名称
 *@param columnArray  数组  表的列名称
 *@param columnString  字符串  表的列名称
 *@param paramString   字符串   表的列的值
 *@param limit   整形   分页
 *@return NSMutableArray
 */

- (NSMutableArray *)selectLimitData:(NSString *)tableName columnArray:(NSMutableArray *)columnArray columnString:(NSString *)columnString paramString:(NSString *)paramString limit:(int) limit;

/**
 *@brief 查询一条数据
 *@param tableName    字符串  表名称
 *@param columnName  字符串  表的列名称
 *@param columnString  字符串  表的列名称
 *@param paramString   字符串   表的列的值
 *@return NSString
 */
-(NSString *)selectOneData:(NSString *)tableName columnName:(NSString *)columnName columnString:(NSString *)columnString paramString:(NSString *)paramString;

/**
 *@brief 查询一条数据
 *@param tableName    字符串  表名称
 *@param columnName  字符串  表的列名称
 *@return int
 */
-(int)selectOneData:(NSString *)tableName columnName:(NSString *)columnName;

/**
 *@brief 查询一条数据
 *@param tableName    字符串  表名称
 *@param columnName  字符串  表的列名称
 *@param columnString  字符串  表的列名称
 *@param param   整形   表的列的值
 *@return NSString
 */
-(NSString *)selectOneData:(NSString *)tableName columnName:(NSString *)columnName columnString:(NSString *)columnString param:(int)param;

/**
 *@brief 查询表有多少条数据
 *@param tableName    字符串  表名称
 *@return long
 */
- (long)getCount:(NSString *)tableName;

/**
 *@brief 根据条件查询表有多少条数据
 *@param tableName    字符串  表名称
 *@param columnString  字符串  表的列名称
 *@param paramString   字符串   表的列的值
 *@return long
 */
- (long)getCount:(NSString *)tableName columnString:(NSString *)columnString paramString:(NSString *)paramString;

@end
