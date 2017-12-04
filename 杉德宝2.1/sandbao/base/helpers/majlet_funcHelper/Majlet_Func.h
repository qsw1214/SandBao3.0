//
//  Majlet_Func.h
//  sandbao
//
//  Created by tianNanYiHao on 2016/11/24.
//  Copyright © 2016年 sand. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Majlet_Func : NSObject

/**
 *@brief 创建单例
 */
+ (Majlet_Func *)shareMajlet_Func;

/**
 *@brief  加载
 */
- (BOOL)load;

@end
