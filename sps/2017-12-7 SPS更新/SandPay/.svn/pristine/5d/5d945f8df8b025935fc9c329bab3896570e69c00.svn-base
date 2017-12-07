//
//  CommParameter.m
//  collectionTreasure
//
//  Created by blue sky on 15/7/24.
//  Copyright (c) 2015年 sand. All rights reserved.
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

@end
