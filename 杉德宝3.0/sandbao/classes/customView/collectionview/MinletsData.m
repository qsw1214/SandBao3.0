//
//  MinletsData.m
//  sandbao
//
//  Created by tianNanYiHao on 2016/11/25.
//  Copyright © 2016年 sand. All rights reserved.
//

#import "MinletsData.h"
#import <UIKit/UIKit.h>
#import "SDSqlite.h"
#import "SqliteHelper.h"
#import "DataModel.h"
#import "CommParameter.h"


static MinletsData *mMinletsData = nil;

@implementation MinletsData

+(MinletsData *)shareMinletsData {
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        mMinletsData = [[MinletsData alloc] init];
    });
    return mMinletsData;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.isEditing = NO;
        
        NSMutableArray *allArray = [[NSMutableArray alloc] init];
        
        NSMutableArray *allMinletsArray = [SDSqlite selectData:[SqliteHelper shareSqliteHelper].sandBaoDB tableName:@"minlets" columnArray:MINLETS_ARR];
        if ([allMinletsArray count] > 0) {
            [allArray addObject:allMinletsArray];
        }
        
        
        NSInteger allArrayCount = [allArray count];
        
        NSMutableArray *temp = @[].mutableCopy;
        self.titleArray = @[].mutableCopy;
        [self.titleArray addObject:@"我的应用"];
        
        for (int i = 0; i < allArrayCount; i++) {
            NSMutableArray *tempSection = @[].mutableCopy;
            [self.titleArray addObject:@"所有的应用"];
            
            NSMutableArray *minletsArray = allArray[i];
            
            NSInteger minletsArrayCount = [minletsArray count];
            for (int j = 0; j < minletsArrayCount; j++) {
                NSMutableDictionary *dic = minletsArray[j];
                DataModel *mDataModel = [DataModel new];
                mDataModel.state = ServeAdd;
                mDataModel.isNewAdd = NO;
                mDataModel.backGroundColor = [UIColor whiteColor];
                mDataModel.title = [dic objectForKey:@"caption"];
                mDataModel.letId = [dic objectForKey:@"letId"];
                mDataModel.icon = [dic objectForKey:@"icon"];
                mDataModel.allowed = [dic objectForKey:@"allowed"];
                
                
                [tempSection addObject:mDataModel];
            }
            [temp addObject:tempSection.copy];
        }
        
        
        NSString *lets = [SDSqlite selectStringData:[SqliteHelper shareSqliteHelper].sandBaoDB tableName:@"usersconfig" columnName:@"lets" whereColumnString:@"uid" whereParamString:[NSString stringWithFormat:@"%@", [CommParameter sharedInstance].userId]];
        NSMutableArray *sectionOne = @[].mutableCopy;
        if (![@""isEqualToString:lets] && lets != nil){
            
            NSInteger tempCount = [temp count];
            for (int p = 0; p < tempCount; p++) {
                NSMutableArray *minletsArray = temp[p];
                
                NSInteger minletsArrayCount = [minletsArray count];
                for (int q = 0; q < minletsArrayCount; q++) {
                    DataModel *mDataModel = minletsArray[q];
                    if ([lets rangeOfString:mDataModel.letId].location != NSNotFound) {
                        
                        mDataModel.state = ServeSelected;
                        
                        [sectionOne addObject:mDataModel];
                    }
                }
            }
        }
        [temp insertObject:sectionOne atIndex:0];
        self.headArray = [NSMutableArray arrayWithArray:temp[0]];
        self.dataArray = temp.mutableCopy;
    }
    
    return self;
}

//- (instancetype)init
//{
//    self = [super init];
//    if (self) {
//        self.isEditing = NO;
//        
//        NSMutableArray *allArray = [[NSMutableArray alloc] init];
//        
//        NSMutableArray *columnArray = [[NSMutableArray alloc] init];
//        [columnArray addObject:@"letId"];
//        [columnArray addObject:@"allowed"];
//        [columnArray addObject:@"caption"];
//        [columnArray addObject:@"icon"];
//        [columnArray addObject:@"h5_addr"];
//        NSMutableArray *allMinletsArray = [SDDBUtil selectData:[Majlet_Func shareMajlet_Func].sandBaoDB tableName:@"minlets" columnArray:columnArray];
//        if ([allMinletsArray count] > 0) {
//            [allArray addObject:allMinletsArray];
//        }
//        
//        
//        NSInteger allArrayCount = [allArray count];
//        
//        NSMutableArray *temp = @[].mutableCopy;
//        self.titleArray = @[].mutableCopy;
//        [self.titleArray addObject:@"我的应用"];
//        
//        for (int i = 0; i < allArrayCount; i++) {
//            NSMutableArray *tempSection = @[].mutableCopy;
//            [self.titleArray addObject:@"所有的应用"];
//            
//            NSMutableArray *minletsArray = allArray[i];
//            
//            NSInteger minletsArrayCount = [minletsArray count];
//            for (int j = 0; j < minletsArrayCount; j++) {
//                NSMutableDictionary *dic = minletsArray[i];
//                DataModel *mDataModel = [DataModel new];
//                mDataModel.state = ServeAdd;
//                mDataModel.isNewAdd = NO;
//                mDataModel.backGroundColor = [UIColor whiteColor];
//                mDataModel.title = [dic objectForKey:@"caption"];
//                mDataModel.letId = [dic objectForKey:@"letId"];
//                mDataModel.icon = [dic objectForKey:@"icon"];
//                mDataModel.allowed = [dic objectForKey:@"allowed"];
//                
//                
//                [tempSection addObject:mDataModel];
//            }
//            [temp addObject:tempSection.copy];
//        }
//        
//        
//        NSString *lets = [SDDBUtil selectOneData:[Majlet_Func shareMajlet_Func].sandBaoDB tableName:@"usersconfig" columnName:@"lets" whereColumnString:@"uid" whereParamString:@"1"];
//        if (![@""isEqualToString:lets] || lets != nil){
//            NSArray *letsArray = [lets componentsSeparatedByString:@","];
//            NSInteger letsArrayCount = [letsArray count];
//            
//            NSMutableArray *sectionOne = @[].mutableCopy;
//            
//            for (int q = 0; q < letsArrayCount; q++) {
//                
//                NSInteger tempCount = [temp count];
//                for (int p = 0; p < tempCount; p++) {
//                    NSMutableArray *minletsArray = temp[p];
//                    
//                    NSInteger minletsArrayCount = [minletsArray count];
//                    for (int x = 0; x < minletsArrayCount; x++) {
//                        if ([letsArray[q] isEqualToString: [minletsArray[x] objectForKey:@"letId"]]) {
//                            DataModel *mDataModel = minletsArray[x];
//                            
//                            mDataModel.state = ServeSelected;
//                            
//                            [sectionOne addObject:mDataModel];
//                        }
//                    }
//                }
//            }
//            [temp insertObject:sectionOne atIndex:0];
//            self.headArray = [NSMutableArray arrayWithArray:temp[0]];
//            self.dataArray = temp.mutableCopy;
//        }
//    }
//    
//    return self;
//}

@end
