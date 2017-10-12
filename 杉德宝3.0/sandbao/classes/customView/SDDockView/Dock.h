//
//  Dock.h
//  weibo
//
//  Created by apple on 13-8-28.
//  Copyright (c) 2013年 itcast. All rights reserved.
//  主控制器底部的选项条

#import <UIKit/UIKit.h>

@interface Dock : UIView
// 添加一个选项卡（图标、文字标题）
- (void)addDockItemWithIcon:(NSString *)icon title:(NSString *)title;

@property (nonatomic, copy) void (^itemClickBlock)(int index);

// 不要求掌握
@property (nonatomic, assign) int selectedIndex;
@end