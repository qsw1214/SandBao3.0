//
//  AppDelegate.m
//  sandbao
//
//  Created by tianNanYiHao on 2016/10/31.
//  Copyright © 2016年 sand. All rights reserved.
//

#import "AppDelegate.h"
#import "MainViewController.h"
#import "ErrorMainViewController.h"
#import "PayNucHelper.h"
#import "UIDevice+DeviceoInfo.h"
#import "Majlet_Func.h"
#import "SDNetwork.h"
#import "OrderInfoNatiVeViewController.h"
#import "SDSqlite.h"
#import "SqliteHelper.h"
#import "Loading.h"


@interface AppDelegate ()<WeiboSDKDelegate>

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {

    // 0.注册微博微信SDK
    [WeiboSDK enableDebugMode:YES];
    [WeiboSDK registerApp:WB_App_Key];
    
    // 1.创建窗口
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    
    // 2.loading
    NSInteger LoadingResult = [Loading startLoading];
    switch (LoadingResult) {
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
                self.window.rootViewController = mMainViewController;
            }

                break;
            //暗登陆引导
            case 2:
            {
                MainViewController *mMainViewController = [[MainViewController alloc] init];
                mMainViewController.pwdLoginFlag = NO;
                self.window.rootViewController = mMainViewController;
            }
                
                break;
            default:
                break;
    }
    
    // 3.显示窗口
    [self.window makeKeyAndVisible];
    // 4.接受本地消息通知
    [self noticeLoacalGet];
    return YES;
}
- (void)loadingError:(NSString*)errorStr {
    ErrorMainViewController *mErrorMainViewController = [[ErrorMainViewController alloc] init];
    mErrorMainViewController.errorInfo = errorStr;
    self.window.rootViewController = mErrorMainViewController;
    [self.window makeKeyAndVisible];
}



- (void)noticeLoacalGet{
    
    UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:UIUserNotificationTypeBadge | UIUserNotificationTypeSound | UIUserNotificationTypeAlert categories:nil];
    [[UIApplication sharedApplication] registerUserNotificationSettings:settings];
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

/**
 收到一个来自微博客户端程序的响应
 
 收到微博的响应后，第三方应用可以通过响应类型、响应的数据和 WBBaseResponse.userInfo 中的数据完成自己的功能
 @param response 具体的响应对象
 */
- (void)didReceiveWeiboResponse:(WBBaseResponse *)response
{
    
    if ([response isKindOfClass:WBSendMessageToWeiboResponse.class])
    {
//        NSString *title = NSLocalizedString(@"发送结果", nil);
//        NSString *message = [NSString stringWithFormat:@"%@: %d\n%@: %@\n%@: %@", NSLocalizedString(@"响应状态", nil), (int)response.statusCode, NSLocalizedString(@"响应UserInfo数据", nil), response.userInfo, NSLocalizedString(@"原请求UserInfo数据", nil),response.requestUserInfo];
//        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title
//                                                        message:message
//                                                       delegate:nil
//                                              cancelButtonTitle:NSLocalizedString(@"确定", nil)
//                                              otherButtonTitles:nil];
//        WBSendMessageToWeiboResponse* sendMessageToWeiboResponse = (WBSendMessageToWeiboResponse*)response;
//        NSString* accessToken = [sendMessageToWeiboResponse.authResponse accessToken];
//        if (accessToken)
//        {
//        }
//        NSString* userID = [sendMessageToWeiboResponse.authResponse userID];
//        if (userID) {
//        }
//        [alert show];
    }
    else if ([response isKindOfClass:WBAuthorizeResponse.class])
    {
        
        if ([_delegate respondsToSelector:@selector(weiboLoginByResponse:)]) {
            [_delegate weiboLoginByResponse:response];
        }
        
//        NSString *title = NSLocalizedString(@"认证结果", nil);
//        NSString *message = [NSString stringWithFormat:@"%@: %d\nresponse.userId: %@\nresponse.accessToken: %@\n%@: %@\n%@: %@", NSLocalizedString(@"响应状态", nil), (int)response.statusCode,[(WBAuthorizeResponse *)response userID], [(WBAuthorizeResponse *)response accessToken],  NSLocalizedString(@"响应UserInfo数据", nil), response.userInfo, NSLocalizedString(@"原请求UserInfo数据", nil), response.requestUserInfo];
//        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title
//                                                        message:message
//                                                       delegate:nil
//                                              cancelButtonTitle:NSLocalizedString(@"确定", nil)
//                                              otherButtonTitles:nil];
//        [alert show];
    }
}


/**
 收到一个来自微博客户端程序的请求
 
 收到微博的请求后，第三方应用应该按照请求类型进行处理，处理完后必须通过 [WeiboSDK sendResponse:] 将结果回传给微博
 @param request 具体的请求对象
 */
- (void)didReceiveWeiboRequest:(WBBaseRequest *)request{ //向微博发送请求
    
    NSLog(@" %@",request.class);
}


//接受微博或微信等各类App的起调
#pragma mark 9.0之后
-(BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<NSString *,id> *)options{
    
    //微博启动回调
    if ([WeiboSDK handleOpenURL:url delegate:self]) {
        return [WeiboSDK handleOpenURL:url delegate:self];
    }
    //sps启动回调
    if ([url.absoluteString containsString:@"com.sand.sandbao"]) {
        NSString *urlStr = [NSString stringWithFormat:@"%@",url];
        //查询活跃状态用户数量(1个且只能为1)
        long count = [SDSqlite getCount:[SqliteHelper shareSqliteHelper].sandBaoDB sql:[NSString stringWithFormat:@"select count(*) from usersconfig where active = '%@'", @"0"]];
        //无活跃用户,通知发送到 AddauthToolViewController(propety:isOtherAPPSPS=YES)
        if (count <= 0) {
            [[NSNotificationCenter defaultCenter] postNotificationName:OPENSPSPAYNOTICELOGOUT object:urlStr];
        }
        //有活跃用户,发通知到 MainViewController (propety:isOtherAPPSPS=YES)
        else{
            [[NSNotificationCenter defaultCenter] postNotificationName:OPENSPSPAYNOTICELOGIN object:urlStr];
        }
        return YES;
    }
    
    
    return NO;
   
}

#pragma mark 9.0之前
- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url{
   
    //微博启动回调
    if ([WeiboSDK handleOpenURL:url delegate:self]) {
        return [WeiboSDK handleOpenURL:url delegate:self];
    }
    //sps启动回调
    if ([url.absoluteString containsString:@"com.sand.sandbao"]) {
        NSString *urlStr = [NSString stringWithFormat:@"%@",url];
        //查询活跃状态用户数量(1且只能为1)
        long count = [SDSqlite getCount:[SqliteHelper shareSqliteHelper].sandBaoDB sql:[NSString stringWithFormat:@"select count(*) from usersconfig where active = '%@'", @"0"]];
        //无活跃用户,通知发送到 AddauthToolViewController(propety:isOtherAPPSPS=YES)
        if (count <= 0) {
            [[NSNotificationCenter defaultCenter] postNotificationName:OPENSPSPAYNOTICELOGOUT object:urlStr];
        }
        //有活跃用户,发通知到 MainViewController (propety:isOtherAPPSPS=YES)
        else{
            [[NSNotificationCenter defaultCenter] postNotificationName:OPENSPSPAYNOTICELOGIN object:urlStr];
        }
        return YES;
    }
    
    return NO;
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(nullable NSString *)sourceApplication annotation:(id)annotation{

    //微博启动回调
    if ([WeiboSDK handleOpenURL:url delegate:self]) {
        return [WeiboSDK handleOpenURL:url delegate:self];
    }
    //sps启动回调
    if ([url.absoluteString containsString:@"com.sand.sandbao"]) {
        NSString *urlStr = [NSString stringWithFormat:@"%@",url];
        //查询活跃状态用户数量(1且只能为1)
        long count = [SDSqlite getCount:[SqliteHelper shareSqliteHelper].sandBaoDB sql:[NSString stringWithFormat:@"select count(*) from usersconfig where active = '%@'", @"0"]];
        //(SPS场景3) 无活跃用户,通知发送到 AddauthToolViewController(propety:isOtherAPPSPS=YES)
        if (count <= 0) {
            [[NSNotificationCenter defaultCenter] postNotificationName:OPENSPSPAYNOTICELOGOUT object:urlStr];
        }
        //(SPS场景4) 有活跃用户,发通知到 MainViewController (propety:isOtherAPPSPS=YES)
        else{
            [[NSNotificationCenter defaultCenter] postNotificationName:OPENSPSPAYNOTICELOGIN object:urlStr];
        }
        return YES;
    }
    
    
    return NO;
}









@end
