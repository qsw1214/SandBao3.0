//
//  DataModel.h
//  sandbaocontrol
//
//  Created by tianNanYiHao on 2016/11/2.
//  Copyright © 2016年 sand. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger ,ServeButtonStates) {
    ServeAdd = 0,
    ServeSelected
};

@interface DataModel : NSObject

@property (nonatomic, strong) UIColor *backGroundColor;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *letId;
@property (nonatomic, copy) NSString *allowed;
@property (nonatomic, copy) NSString *icon;
@property (nonatomic, assign) ServeButtonStates state;
@property (nonatomic, assign) BOOL isSectionOne;
@property (nonatomic, assign) BOOL isNewAdd;

@end
