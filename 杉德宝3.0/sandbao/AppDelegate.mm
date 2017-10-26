//
//  AppDelegate.m
//  sandbao
//
//  Created by tianNanYiHao on 2016/10/31.
//  Copyright © 2016年 sand. All rights reserved.
//

#import "AppDelegate.h"
#import <IQKeyboardManager.h>
#import "MainViewController.h"
#import "ErrorMainViewController.h"
#import "PayNucHelper.h"
#import "UIDevice+DeviceoInfo.h"
#import "Majlet_Func.h"
#import "SDNetwork.h"
#import "SDSqlite.h"
#import "SqliteHelper.h"
#import "Loading.h"
#import "LeftSideMenuViewController.h"

@interface AppDelegate ()<WeiboSDKDelegate>

@end

@implementation AppDelegate

- (BOOL)testView{
    // 1.创建窗口
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // 2.
    LeftSideMenuViewController *fs = [[LeftSideMenuViewController alloc] init];
    self.window.rootViewController = fs;
    // 3.显示窗口
    [self.window makeKeyAndVisible];
    
    return YES;
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {

    // 0.注册微博微信SDK
    [WeiboSDK enableDebugMode:YES];
    [WeiboSDK registerApp:WB_App_Key];
    
    
    //IQkeyBoard配置
    [self IQKeyBoardSet];
    
    // 1.创建窗口
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    
    return [self testView];
    
    // 2.loading
    NSInteger loadingResult = [Loading startLoading];
    switch (loadingResult) {
            //load失败
            case 0:
            {
                SDNetwork *sdnet = [[SDNetwork alloc] init];
                if ([@"" isEqualToString:[sdnet stringWithNetworkType]]) {
                    [self loadingError:@"无网络连接"];
                }else{
                    [self loadingError:@"网络异常"];
                }
            }
                break;
            //明登陆引导
            case 1:
            {
                MainViewController *mMainViewController = [[MainViewController alloc] init];
                mMainViewController.pwdLoginFlag = YES;
                UINavigationController *navMainViewController = [[UINavigationController alloc] initWithRootViewController:mMainViewController];
                self.window.rootViewController = navMainViewController;
            }

                break;
            //暗登陆引导
            case 2:
            {
                MainViewController *mMainViewController = [[MainViewController alloc] init];
                mMainViewController.pwdLoginFlag = NO;
                UINavigationController *navMainViewController = [[UINavigationController alloc] initWithRootViewController:mMainViewController];
                self.window.rootViewController = navMainViewController;
            }
                
                break;
            default:
                break;
    }
    
    // 3.显示窗口
    [self.window makeKeyAndVisible];
    
    
    return YES;
}

#pragma  mark IQKeyBoard键盘库设置
- (void)IQKeyBoardSet{
    
    IQKeyboardManager *keyboardManager = [IQKeyboardManager sharedManager]; // 获取类库的单例变量
    
    keyboardManager.enable = YES; // 控制整个功能是否启用
    
    keyboardManager.shouldResignOnTouchOutside = YES; // 控制点击背景是否收起键盘
    
    keyboardManager.shouldToolbarUsesTextFieldTintColor = YES; // 控制键盘上的工具条文字颜色是否用户自定义
    keyboardManager.toolbarTintColor = [UIColor colorWithRed:102/255.0 green:102/255.0 blue:102/255.0 alpha:1/1.0];
    
    keyboardManager.toolbarManageBehaviour = IQAutoToolbarByTag; // 有多个输入框时，可以通过点击Toolbar 上的“前一个”“后一个”按钮来实现移动到不同的输入框
    
    keyboardManager.enableAutoToolbar = YES; // 控制是否显示键盘上的工具条
    
    keyboardManager.shouldShowTextFieldPlaceholder = NO; // 是否显示占位文字placehordel
    
    keyboardManager.placeholderFont = [UIFont fontWithName:@"PingFang-SC-Medium" size:14]; // 设置占位文字的字体
    
    keyboardManager.keyboardDistanceFromTextField = 30.f; // 输入框距离键盘的距离

}

#pragma mark Loading失败 - 进入失败页
- (void)loadingError:(NSString*)errorStr {
    ErrorMainViewController *mErrorMainViewController = [[ErrorMainViewController alloc] init];
    mErrorMainViewController.errorInfo = errorStr;
    self.window.rootViewController = mErrorMainViewController;
    [self.window makeKeyAndVisible];
}




#pragma mark - 处理后台和前台通知点击
- (void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification{
    
    // 查看当前的状态出于 (前台: 0) / (后台: 2) / (从后台进入前台: 1)    
    // 执行响应操作
    // 如果当前App在前台,执行操作
    if (application.applicationState == UIApplicationStateActive) {
        [SDLog logTest:@"执行前台对应的操作"];
    } else if (application.applicationState == UIApplicationStateInactive) {
        // 后台进入前台
        [SDLog logTest:@"执行后台进入前台对应的操作"];
        [SDLog logTest:[NSString stringWithFormat:@"%@",notification.userInfo]];
        [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
    } else if (application.applicationState == UIApplicationStateBackground) {
        // 当前App在后台
        [SDLog logTest:@"执行后台对应的操作"];
    }

}

//监听通知操作行为的点击
- (void)application:(UIApplication *)application handleActionWithIdentifier:(NSString *)identifier forLocalNotification:(UILocalNotification *)notification completionHandler:(void (^)())completionHandler
{
    NSLog(@"监听通知操作行为的点击");
}


-(BOOL)application:(UIApplication *)application willFinishLaunchingWithOptions:(NSDictionary *)launchOptions{
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}



@end
