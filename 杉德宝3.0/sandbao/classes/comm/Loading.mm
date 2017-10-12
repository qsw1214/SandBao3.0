//
//  Loading.m
//  sandbao
//
//  Created by tianNanYiHao on 2017/10/12.
//  Copyright © 2017年 sand. All rights reserved.
//

#import "Loading.h"

@implementation Loading


+ (NSInteger)startLoading{
    
    // 0.测试/生产开关/指纹采集 (paynuc相关参数必须先设置好)
    [[PayNucHelper sharedInstance] changeEnvironment:YES];
    
    // 2.LOADING : 两步认证+数据库创建+明暗登录判定 (0:load失败 1:load成功+明登陆 2:load成功+暗登陆)
    // 2.1 load
    BOOL result = [[Majlet_Func shareMajlet_Func] load];
    if (!result) {
        return 0;
    }
    // 2.2 明暗登录判定
    //查询活跃状态用户数量(1且只能为1)
    long count = [SDSqlite getCount:[SqliteHelper shareSqliteHelper].sandBaoDB sql:[NSString stringWithFormat:@"select count(*) from usersconfig where active = '%@'", @"0"]];
    if (count <= 0) {
        return 1;
    }
    return 2;
}
@end
