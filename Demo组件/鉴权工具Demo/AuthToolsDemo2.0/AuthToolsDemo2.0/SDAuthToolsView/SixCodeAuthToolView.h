//
//  SixCodeAuthToolView.h
//  AuthToolsDemo2.0
//
//  Created by tianNanYiHao on 2017/10/13.
//  Copyright © 2017年 tianNanYiHao. All rights reserved.
//

#import "AuthToolBaseView.h"

typedef void(^CodeStrBlock)(NSString * codeStr);

typedef NS_ENUM(NSInteger,CodeAuthToolStyle){
    SmsCodeAuthTool = 0,
    PayCodeAuthTool,
};

@interface SixCodeAuthToolView : AuthToolBaseView


/**
 类型
 */
@property (nonatomic, assign) CodeAuthToolStyle style;



@property (nonatomic, copy) CodeStrBlock codeStrBlock;

@end
