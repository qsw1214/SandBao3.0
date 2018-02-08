//
//  SdSpsPay.m
//  moniJiuZhangApp
//
//  Created by tianNanYiHao on 2017/8/1.
//  Copyright © 2017年 tianNanYiHao. All rights reserved.
//

#import "SpsDock.h"
#import <UIKit/UIKit.h>

#define SAND_SCHEMES @"sandbaoApp"
#define OTHER_SCHEMES   @"sandbaoPay"

//杉德宝AppStore:APPID
#define STOREAPPID @"1345742057"
#define APPSTORE_FOR_SANDBAO [NSURL URLWithString:[NSString stringWithFormat:@"https://itunes.apple.com/us/app/id%@?ls=1&mt=8", STOREAPPID]]

@implementation SpsDock


#pragma mark - init_func
//1.静态实例且初始化
static SpsDock *spsDockSharedInstace = nil;

//2.单例实例化
+ (SpsDock*)sharedInstance{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        spsDockSharedInstace = [[SpsDock alloc] init];
    });
    return spsDockSharedInstace;
    
}
//3.init方法实例化
- (instancetype)init{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if ([super init]) {
            
        }
    });
    return self;
}


#pragma mark - public_func
#pragma mark 唤起杉德宝
/**
 唤起杉德宝,传递订单TN号
 成功:直接打开
 失败:弹出提示/引导进入AppStore下载杉德宝(目前由于未上线,暂时弹出打开失败提示)
 
 @param tn TN号
 */
- (void)callSps:(NSString*)tn{
    
    //NSString *urlStr = @"sandbao://TN:2094032421?sandbaoPay";
    NSString *urlStr = [NSString stringWithFormat:@"%@://TN:%@?%@",SAND_SCHEMES,tn,OTHER_SCHEMES];
    NSURL *url = [NSURL URLWithString:urlStr];
    UIApplication *application = [UIApplication sharedApplication];
    
    //能唤起URL
    if ([application canOpenURL:url]){
        if (@available(iOS 11.0,*)){
            if ([application respondsToSelector:@selector(openURL:options:completionHandler:)]) {
                [application openURL:url options:@{} completionHandler:^(BOOL success) {
                    if (success) {
                        //唤起杉德宝成功
                    } else {
                        //唤起杉德宝失败
                        [[SpsDock sharedInstance]  showAlertError];
                    }
                }];
            }
        }
        else{
            if ([application respondsToSelector:@selector(openURL:)]) {
                [application openURL:url];
            }
        }
    }
    //否唤起URL
    else{
        //唤起杉德宝失败
        [[SpsDock sharedInstance] showAlertError];
    }
}

#pragma mark 唤起第三方App的判断
/**
 杉德宝完成支付/取消支付后,能否唤起第三方App的判断
 需要在 application:openURL:sourceApplication:annotation:或者application:handleOpenURL中调用
 1.此方法用于与微博/微信等做区分
 2.注意iOS9系统版本之后的系统代理方法
 
 @param url URL
 @return 会跳成功/失败
 */
- (BOOL)canHandleUrl:(NSURL *)url{
    
    if ([url.absoluteString containsString:OTHER_SCHEMES]) {
        return YES;
    }
    return NO;
}


#pragma mark 杉德宝完成支付/取消支付后,回调方法
/**
 杉德宝完成支付/取消支付后,回调方法
 (处理杉德宝户端程序通过URL启动第三方应用时传递的数据)
 
 @param url url
 @param delegate SpsSDKDelegate对象,用于接受杉德宝回调的信息
 @return 成功/失败
 */
- (BOOL)handleUrl:(NSURL *)url{
    
    //sps启动回调
    if ([url.absoluteString containsString:OTHER_SCHEMES]) {
        NSString *urlStr = [NSString stringWithFormat:@"%@",url];
        NSArray *arr = [urlStr componentsSeparatedByString:@"://"];
        NSString *tnStateStr = [arr lastObject];
        NSArray *arr2 = [tnStateStr componentsSeparatedByString:@"?"];
        NSString *state = [arr2 firstObject];
        NSString *tn = [arr2 lastObject];
        
        
        //支付成功
        if ([state isEqualToString:@"0000"]) {
            if ([self.delegate respondsToSelector:@selector(spsReturn:state:)]) {
                [self.delegate spsReturn:tn state:@"0000"];
            }
            return YES;
        }
        //支付取消
        if ([state isEqualToString:@"0001"]){
            if ([self.delegate respondsToSelector:@selector(spsReturn:state:)]) {
                [self.delegate spsReturn:tn state:@"0001"];
            }
            return YES;
        }
        if ([state isEqualToString:@"0002"]) {
            if ([self.delegate respondsToSelector:@selector(spsReturn:state:)]) {
                [self.delegate spsReturn:tn state:@"0002"];
            }
            return YES;
        }
    }
    return NO;
}

#pragma mark - private_func

/**
 启动失败弹框
 */
- (void)showAlertError{
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"您尚未安装杉德宝" message:@"点击前往AppStore下载" preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:@"好的" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        UIApplication *application = [UIApplication sharedApplication];
        //唤起杉德宝失败,引导进入AppStore安装杉德宝
        [application openURL:APPSTORE_FOR_SANDBAO options:@{} completionHandler:nil];
    }]];
    [[self currentViewController] presentViewController:alert animated:YES completion:nil];
}


/**获取当前窗口下的视图控制器*/
- (UIViewController *)currentViewController
{
    UIWindow *keyWindow  = [UIApplication sharedApplication].keyWindow;
    UIViewController *vc = keyWindow.rootViewController;
    while (vc.presentedViewController)
    {
        vc = vc.presentedViewController;
        
        if ([vc isKindOfClass:[UINavigationController class]])
        {
            vc = [(UINavigationController *)vc visibleViewController];
        }
        else if ([vc isKindOfClass:[UITabBarController class]])
        {
            vc = [(UITabBarController *)vc selectedViewController];
        }
    }
    return vc;
}


@end
