//
//  MinletsData.h
//  sandbao
//
//  Created by tianNanYiHao on 2016/11/25.
//  Copyright © 2016年 sand. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MinletsData : NSObject

@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, strong) NSMutableArray *headArray;
@property (nonatomic, strong) NSMutableArray *titleArray;
@property (nonatomic, assign) BOOL isShowHeaderMessage;
@property (nonatomic, assign) BOOL isEditing;

+ (MinletsData *)shareMinletsData;

@end
