//
//  Loading.h
//  sandbao
//
//  Created by tianNanYiHao on 2017/10/12.
//  Copyright © 2017年 sand. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Majlet_Func.h"
#import "PayNucHelper.h"


#import "SqliteHelper.h"

@interface Loading : NSObject


/**
 开始大Loading

 @return 0:loading失败 1:Loading成功+明登陆 2:Loading成功+暗登陆
 */
+ (NSInteger)startLoading;


@end
