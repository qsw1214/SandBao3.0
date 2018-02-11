//
//  SDAlertView.m
//  SDAlertView
//
//  Created by tianNanYiHao on 2018/2/11.
//  Copyright © 2018年 tianNanYiHao. All rights reserved.
//

#import "SDAlertView.h"
#import <UIKit/UIKit.h>
#import "HDAlertView.h"



@interface SDAlertView()
{
    
}
@property (nonatomic, strong) HDAlertView *alertView;
@end

static SDAlertView *onceAlerView = nil;

@implementation SDAlertView

//单例
+ (instancetype)shareAlert{
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        onceAlerView = [[SDAlertView alloc] init];
    });
    return onceAlerView;
}

+ (instancetype)allocWithZone:(struct _NSZone *)zone{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        onceAlerView = [super allocWithZone:zone];
    });
    return onceAlerView;
}



#pragma mark - 强制消失
/**
 强制消失
 
 @param keepAnimation 是否保持动画
 */
- (void)hideDialogAnimation:(BOOL)keepAnimation{
    
    if ([SDAlertView shareAlert].alertView) {
        if (keepAnimation) {
            [[SDAlertView shareAlert].alertView removeAlertView];
        }else{
            [[SDAlertView shareAlert].alertView removeAlertView];
            [[SDAlertView shareAlert].alertView removeFromSuperview];
        }
    }
}


#pragma mark - 弹出默认对话框+无事件处理
/**
 弹出(CustomAlertViewStyleDefault)对话框+无事件处理 (一般用于反馈后端resMsg)
 
 @param message 消息
 */
- (void)showDialog:(NSString *)message{
    
    [SDAlertView shareAlert].alertView = [HDAlertView alertViewWithTitle:@"提示" andMessage:message];
    [SDAlertView shareAlert].alertView.transitionStyle = HDAlertViewTransitionStyleDropDown;
    [SDAlertView shareAlert].alertView .backgroundStyle = HDAlertViewBackgroundStyleSolid;
    [SDAlertView shareAlert].alertView .isSupportRotating = YES;
    
    [[SDAlertView shareAlert].alertView  addButtonWithTitle:@"确定" type:HDAlertViewButtonTypeDefault handler:^(HDAlertView *alertView) {
        // do nothing
    }];
    [[SDAlertView shareAlert].alertView  show];
    
}




#pragma mark - 弹出默认对话框+默认事件处理
/**
 弹出(CustomAlertViewStyleDefault)对话框+默认事件处理 (一般用于反馈后端resMsg,并需要处理一定事件如sToken失效提示后退出重登陆)
 
 @param message 消息
 @param defulblock 默认事件回调
 */
- (void)showDialog:(NSString *)message defulBlock:(DefulBtnBlock)defulblock{
    
    [SDAlertView shareAlert].alertView = [HDAlertView alertViewWithTitle:@"提示" andMessage:message];
    [SDAlertView shareAlert].alertView.transitionStyle = HDAlertViewTransitionStyleDropDown;
    [SDAlertView shareAlert].alertView.backgroundStyle = HDAlertViewBackgroundStyleSolid;
    [SDAlertView shareAlert].alertView.isSupportRotating = YES;
    
    [[SDAlertView shareAlert].alertView addButtonWithTitle:@"确定" type:HDAlertViewButtonTypeDefault handler:^(HDAlertView *alertView) {
        defulblock();
    }];
    
    [[SDAlertView shareAlert].alertView show];
    
}


#pragma mark - 弹出带标题对话框+默认事件处理 + 消息标题
/**
 弹出带标题对话框+默认事件处理
 
 @param title 标题
 @param message 信息
 @param defulblock 默认事件处理
 */
- (void)showDialog:(NSString*)title message:(NSString*)message defulBlock:(DefulBtnBlock)defulblock{
    
    [SDAlertView shareAlert].alertView = [HDAlertView alertViewWithTitle:title andMessage:message];
    [SDAlertView shareAlert].alertView.transitionStyle = HDAlertViewTransitionStyleDropDown;
    [SDAlertView shareAlert].alertView.backgroundStyle = HDAlertViewBackgroundStyleSolid;
    [SDAlertView shareAlert].alertView.isSupportRotating = YES;
    
    [[SDAlertView shareAlert].alertView addButtonWithTitle:@"确定" type:HDAlertViewButtonTypeDefault handler:^(HDAlertView *alertView) {
        defulblock();
    }];
    
    [[SDAlertView shareAlert].alertView show];
}

#pragma mark - 弹出带标题对话框+事件处理+自定义处理标题
/**
 弹出带标题对话框+事件处理+自定义处理标题
 
 @param title 标题
 @param message 消息内容
 @param sureTitle 确认消息标题
 @param defaultBlock 自定义的事件处理
 */
- (void)showDialog:(NSString*)title message:(NSString*)message sureTitle:(NSString*)sureTitle defualtBlcok:(DefulBtnBlock)defaultBlock{
    
    [SDAlertView shareAlert].alertView = [HDAlertView alertViewWithTitle:title andMessage:message];
    [SDAlertView shareAlert].alertView.transitionStyle = HDAlertViewTransitionStyleDropDown;
    [SDAlertView shareAlert].alertView.backgroundStyle = HDAlertViewBackgroundStyleSolid;
    [SDAlertView shareAlert].alertView.isSupportRotating = YES;
    
    [[SDAlertView shareAlert].alertView addButtonWithTitle:sureTitle type:HDAlertViewButtonTypeDefault handler:^(HDAlertView *alertView) {
        defaultBlock();
    }];
    [[SDAlertView shareAlert].alertView show];
}


#pragma mark - 弹出带标题对话框+事件处理
/**
 弹出(CustomAlertViewStyleDefault)带标题对话框+事件处理
 
 @param title 标题
 @param message 消息
 @param leftString 左边文字
 @param rightString 右边文字
 @param leftbtnblock 左按钮回调
 @param rightbtnblock 右按钮回调
 */
- (void)showDialog:(NSString*)title message:(NSString*)message leftBtnString:(NSString*)leftString rightBtnString:(NSString*)rightString leftBlock:(LeftBtnBlock)leftbtnblock rightBlock:(RightBtnBlock)rightbtnblock{
    
    [SDAlertView shareAlert].alertView = [HDAlertView alertViewWithTitle:title andMessage:message];
    [SDAlertView shareAlert].alertView.transitionStyle = HDAlertViewTransitionStyleDropDown;
    [SDAlertView shareAlert].alertView.backgroundStyle = HDAlertViewBackgroundStyleSolid;
    [SDAlertView shareAlert].alertView.isSupportRotating = YES;
    
    [[SDAlertView shareAlert].alertView addButtonWithTitle:leftString type:HDAlertViewButtonTypeDefault handler:^(HDAlertView *alertView) {
        leftbtnblock();
    }];
    
    [[SDAlertView shareAlert].alertView addButtonWithTitle:rightString type:HDAlertViewButtonTypeDestructive handler:^(HDAlertView *alertView) {
        rightbtnblock();
    }];
    
    [[SDAlertView shareAlert].alertView show];
    
}
@end
