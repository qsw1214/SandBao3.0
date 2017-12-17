//
//  AppDelegate.m
//  sandbao
//
//  Created by tianNanYiHao on 2016/10/31.
//  Copyright © 2016年 sand. All rights reserved.
//

#import "AppDelegate.h"
#import <IQKeyboardManager.h>
#import <UIKit/UIKit.h>
#import "LunchViewController.h"
#import "ErrorLunchViewController.h"
#import "PayNucHelper.h"
#import "UIDevice+DeviceoInfo.h"
#import "Majlet_Func.h"
#import "SDNetwork.h"
#import "SDSqlite.h"
#import "SqliteHelper.h"
#import "Loading.h"
#import "RESideMenu.h"
#import "LeftSideMenuViewController.h"

#import "UMMobClick/MobClick.h"
#import <PgySDK/PgyManager.h>
#import <PgyUpdate/PgyUpdateManager.h>

@interface AppDelegate ()<WeiboSDKDelegate>

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {

#pragma mark - ***上传AppStore前 请务必删除蒲公英SDK***
    //启动基本SDK
    // 7e2e46b54026ae02b7b963ae1e3d54b3 (上传生产版本key) com.sand.sandbao2
    // 33bb2bbf63b37e4e8e82c5a53cd14ca8 (上传测试版本Key) com.sand.sandbao
    [[PgyManager sharedPgyManager] startManagerWithAppId:@"33bb2bbf63b37e4e8e82c5a53cd14ca8"];
    //启动更新检查SDK
    [[PgyUpdateManager sharedPgyManager] startManagerWithAppId:@"33bb2bbf63b37e4e8e82c5a53cd14ca8"];
    //执行版本更新检测-(上传AppStore前 请务必删除蒲公英SDK)
    [[PgyUpdateManager sharedPgyManager] checkUpdate];
#pragma mark - ***上传AppStore前 请务必删除蒲公英SDK***
    
    //-2. 启动定位 - 实例化
    [LocationUtil shareLocationManager];

    //-1. 友盟相关设置
    [self UMSetAbout];
    
    // 0.注册微博微信SDK
    [WeiboSDK enableDebugMode:NO];
    [WeiboSDK registerApp:WB_App_Key];
    
    // 1.IQkeyBoard配置
    [self IQKeyBoardSet];
    
    // 2.window设置
    [self setWindows];
    
    // 3.loading
    [self loading:launchOptions];

    return YES;
}


- (void)loading:(NSDictionary *)launchOptions{
    
    NSInteger loadingResult = [Loading startLoading];
    //判断久彰App调用启动
    NSString *loginTypeStr;
    NSURL *url = [launchOptions objectForKey:UIApplicationLaunchOptionsURLKey];
    if (url) {
        loadingResult += 10;
        [CommParameter sharedInstance].urlSchemes = [NSString stringWithFormat:@"%@",url];
    }
    //load失败
    if (loadingResult == 0 || loadingResult == 10) {
        
        SDNetwork *sdnet = [[SDNetwork alloc] init];
        if ([@"" isEqualToString:[sdnet stringWithNetworkType]]) {
            [self loadingError:@"无网络连接"];
        }else{
            [self loadingError:@"网络异常"];
        }
    }
    
    //杉德宝未启动 : 用户自启动+明登陆引导
    if (loadingResult == 1) {
        loginTypeStr = @"PWD_LOGIN";
    }
    //杉德宝未启动 : 用户自启动+暗登陆引导
    if (loadingResult == 2) {
        loginTypeStr = @"NO_PWD_LOGIN";
    }
    //杉德宝未启动 : OtherApp启动+明登陆引导
    if (loadingResult == 11) {
        loginTypeStr = @"PWD_LOGIN";
    }
    //杉德宝未启动 : OtherApp启动+暗登陆引导
    if (loadingResult == 12) {
        loginTypeStr = @"NO_PWD_LOGIN";
    }
    
    //lunchVC
    LunchViewController *lunchVC = [[LunchViewController alloc] init];
    UINavigationController *lunchNav = [[UINavigationController alloc] initWithRootViewController:lunchVC];
    
    //leftVC
    LeftSideMenuViewController *leftVC = [[LeftSideMenuViewController alloc] init];
    leftVC.loginTypeStr = loginTypeStr;
    //RESidenMenu控制器
    RESideMenu *sideMenuVC = [[RESideMenu alloc] initWithContentViewController:lunchNav leftMenuViewController:leftVC rightMenuViewController:nil];
    
    self.window.rootViewController = sideMenuVC;
    // 3.显示窗口
    [self.window makeKeyAndVisible];
    
}

#pragma mark 友盟相关设置
- (void)UMSetAbout{

//    UMConfigInstance.appKey = @"59edaad7a40fa37273000561";//接入统计
    UMConfigInstance.appKey = @"";//不接入统计
    UMConfigInstance.channelId = nil;
    UMConfigInstance.eSType = E_UM_NORMAL;
    UMConfigInstance.ePolicy = SEND_INTERVAL;
    [MobClick setLogSendInterval:120];
    [MobClick startWithConfigure:UMConfigInstance];//配置以上参数后调用此方法初始化SDK！
    
    //集成测试模式 - 打印日志
    [MobClick setLogEnabled:NO];
    
    //开启CrashReport收集
    [MobClick setCrashReportEnabled:YES];
    
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
    
    keyboardManager.placeholderFont = [UIFont fontWithName:@"PingFang-SC-Regular" size:14]; // 设置占位文字的字体
    
    keyboardManager.keyboardDistanceFromTextField = 30.f; // 输入框距离键盘的距离

}
#pragma mark - 设置window属性
- (void)setWindows{
    
    //设置短信倒计时归零
    [SixCodeAuthToolView setZeroForCurrentTimeOut];
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    UIImageView * imgv =  [[UIImageView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    imgv.image = [UIImage imageNamed:@"Stars"];
    [self.window addSubview:imgv];
    
}


#pragma mark - Loading失败 - 进入失败页
- (void)loadingError:(NSString*)errorStr {
    ErrorLunchViewController *mErrorLunchViewController = [[ErrorLunchViewController alloc] init];
    mErrorLunchViewController.errorInfo = errorStr;
    self.window.rootViewController = mErrorLunchViewController;
    [self.window makeKeyAndVisible];
}




#pragma mark - 处理后台和前台通知点击
- (void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification{
    
    // 查看当前的状态出于 (前台: 0) / (后台: 2) / (从后台进入前台: 1)    
    // 执行响应操作
    // 如果当前App在前台,执行操作
    if (application.applicationState == UIApplicationStateActive) {
        NSLog(@"执行前台对应的操作");
    } else if (application.applicationState == UIApplicationStateInactive) {
        // 后台进入前台
        NSLog(@"执行后台进入前台对应的操作");
        NSLog(@"%@",notification.userInfo);
        [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
    } else if (application.applicationState == UIApplicationStateBackground) {
        // 当前App在后台
        NSLog(@"执行后台对应的操作");
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


//接受微博或微信等各类App的起调
#pragma mark 9.0之后
-(BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<NSString *,id> *)options{
    
    //微博启动回调
    if ([WeiboSDK handleOpenURL:url delegate:self]) {
        return [WeiboSDK handleOpenURL:url delegate:self];
    }
    //sps启动回调
    if ([url.absoluteString containsString:@"sandbao"]) {
        NSString *urlStr = [NSString stringWithFormat:@"%@",url];
        [CommParameter sharedInstance].urlSchemes = urlStr;
        //查询活跃状态用户数量(1个且只能为1)
        long count = [SDSqlite getCount:[SqliteHelper shareSqliteHelper].sandBaoDB sql:[NSString stringWithFormat:@"select count(*) from usersconfig where active = '%@'", @"0"]];
        //杉德宝已启动 : 用户已登录 + 消息通知让 spslunch页面归位
        if (count > 0) {
            [[NSNotificationCenter defaultCenter] postNotificationName:OPEN_SPSPAY_NOTIFACTION_STATE_LOGIN object:nil];
        }else{
            //杉德宝已启动 : 用户未登录 + 全局变量( [CommParameter sharedInstance].urlSchemes = urlStr;) 判断登陆后跳转sps
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
    if ([url.absoluteString containsString:@"sandbao"]) {
        NSString *urlStr = [NSString stringWithFormat:@"%@",url];
        [CommParameter sharedInstance].urlSchemes = urlStr;
        //查询活跃状态用户数量(1个且只能为1)
        long count = [SDSqlite getCount:[SqliteHelper shareSqliteHelper].sandBaoDB sql:[NSString stringWithFormat:@"select count(*) from usersconfig where active = '%@'", @"0"]];
        //杉德宝已启动 : 用户已登录 + 消息通知让 spslunch页面归位
        if (count > 0) {
            [[NSNotificationCenter defaultCenter] postNotificationName:OPEN_SPSPAY_NOTIFACTION_STATE_LOGIN object:nil];
        }else{
            //杉德宝已启动 : 用户未登录 + 全局变量( [CommParameter sharedInstance].urlSchemes = urlStr;) 判断登陆后跳转sps
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
    if ([url.absoluteString containsString:@"sandbao"]) {
        NSString *urlStr = [NSString stringWithFormat:@"%@",url];
        [CommParameter sharedInstance].urlSchemes = urlStr;
        //查询活跃状态用户数量(1个且只能为1)
        long count = [SDSqlite getCount:[SqliteHelper shareSqliteHelper].sandBaoDB sql:[NSString stringWithFormat:@"select count(*) from usersconfig where active = '%@'", @"0"]];
        //杉德宝已启动 : 用户已登录 + 消息通知让 spslunch页面归位
        if (count > 0) {
            [[NSNotificationCenter defaultCenter] postNotificationName:OPEN_SPSPAY_NOTIFACTION_STATE_LOGIN object:nil];
        }else{
            //杉德宝已启动 : 用户未登录 + 全局变量( [CommParameter sharedInstance].urlSchemes = urlStr;) 判断登陆后跳转sps
        }
        return YES;
    }
    
    
    return NO;
}






@end
