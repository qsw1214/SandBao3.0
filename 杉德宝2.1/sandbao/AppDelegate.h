//
//  AppDelegate.h
//  sandbao
//
//  Created by tianNanYiHao on 2016/10/31.
//  Copyright © 2016年 sand. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SDWeiBoDelegate <NSObject>

//登录的代理
-(void)weiboLoginByResponse:(WBBaseResponse *)response;

@end

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (nonatomic, weak)id<SDWeiBoDelegate> delegate;

@end

