//
//  SqliteHelper.h
//  sandbao
//
//  Created by tianNanYiHao on 2017/1/9.
//  Copyright © 2017年 sand. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <sqlite3.h>

@interface SqliteHelper : NSObject

@property sqlite3 * sandBaoDB;
@property sqlite3 * addressDB;

/**
 *@brief 创建单例
 */
+ (SqliteHelper *)shareSqliteHelper;

/**
 *@brief 加载-初始化数据库
 *@return BOOL
 */
- (BOOL)load;

@end
