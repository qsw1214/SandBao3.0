//
//  NoCopyTextField.m
//  sandbao
//
//  Created by tianNanYiHao on 2017/10/18.
//  Copyright © 2017年 sand. All rights reserved.
//

#import "NoCopyTextField.h"

@implementation NoCopyTextField



- (instancetype)init{
    if ([super init]) {
        
    }return self;
}

/**
*  创建UITextField 的子类 ，将此方法粘贴到.m文件。
*  也就是重写长按方法 ,将长按的菜单关闭掉.
*  @return 使用方法:使用该类的实例对象替换UITextfiledView
*/
- (BOOL)canPerformAction:(SEL)action withSender:(id)sender {
//    if (action == @selector(paste:))//禁止粘贴
//        return NO;
//    if (action == @selector(select:))// 禁止选择
//        return NO;
//    if (action == @selector(selectAll:))// 禁止全选
    //        return NO;
    //    return [super canPerformAction:action withSender:sender];
    
    
    UIMenuController *menuController = [UIMenuController sharedMenuController];
    if (menuController)
    {
        [UIMenuController sharedMenuController].menuVisible = NO;
    }
    return NO;
}


@end
