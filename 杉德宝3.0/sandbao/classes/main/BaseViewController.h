//
//  BaseViewController.h
//  sandbao
//
//  Created by tianNanYiHao on 2017/10/14.
//  Copyright © 2017年 sand. All rights reserved.
//

#import <UIKit/UIKit.h>


#pragma -mark frame
#define SCREEN_RECT [UIScreen mainScreen].bounds
#define SCREEN_SIZE [UIScreen mainScreen].bounds.size

#pragma -mark font
#define FONT_28  [UIFont fontWithName:@"PingFang-SC-Medium" size:28]
#define FONT_16  [UIFont fontWithName:@"PingFang-SC-Regular" size:16]
#define FONT_15  [UIFont fontWithName:@"SFUIText-Medium" size:15]
#define FONT_14  [UIFont fontWithName:@"SFUIText-Medium" size:14]
#define FONT_12  [UIFont fontWithName:@"PingFang-SC-Regular" size:12]


#pragma -mark color
#define RGBA(r,g,b,a) [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:a]
#define HexRGBA(rgbValue,a) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:a]

//深黑
#define COLOR_DARKBALCK HexRGBA(0x343339,1.f)
//浅黑
#define COLOR_LIGHTBALCK  HexRGBA(0x343339,0.7f)
//灰色
#define COLOR_GRAY  HexRGBA(0x666666,1.f)
//白色
#define COLOR_WHITE HexRGBA(0xFFFFFF,1.f)
//深蓝
#define COLOR_DARKBLUE HexRGBA(0x358BEF,1.f)
//浅蓝
#define COLOR_LIGHTBLUE HexRGBA(0x58A5F6,1.f)
//红色
#define COLOR_RED HexRGBA(0xF20909,1.f)




/**
 项目工程:所有VC控制器均继承BaseViewController
 BaseViewController内置全屏Scrollview备用
 */
@interface BaseViewController : UIViewController



/**
 所有子控件的父控件
 type:滚动视图
 */
@property (nonatomic, strong) UIScrollView *baseScrollView;



@end
