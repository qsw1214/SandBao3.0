//
//  BaseViewController.h
//  sandbao
//
//  Created by tianNanYiHao on 2017/10/14.
//  Copyright © 2017年 sand. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Masonry.h"
#import "UIView+easyFrame.h"


#import "CardNoAuthToolView.h"
#import "IdentityAuthToolView.h"
#import "NameAuthToolView.h"
#import "PhoneAuthToolView.h"
#import "PwdAuthToolView.h"
#import "SixCodeAuthToolView.h"





#pragma -mark frame
#define SCREEN_RECT [UIScreen mainScreen].bounds
#define SCREEN_SIZE [UIScreen mainScreen].bounds.size
#define SCREEN_WIDTH ([[UIScreen mainScreen] bounds].size.width)
#define SCREEN_HEIGHT ([[UIScreen mainScreen] bounds].size.height)

#define LEFTRIGHTSPACE_40 40.f
#define LEFTRIGHTSPACE_35 35.f
#define LEFTRIGHTSPACE_20 20.f
#define LEFTRIGHTSPACE_15 15.f
#define LEFTRIGHTSPACE_12 12.f

#define UPDOWNSPACE_64 64.f
#define UPDOWNSPACE_58 58.f
#define UPDOWNSPACE_47 47.f
#define UPDOWNSPACE_30 30.f
#define UPDOWNSPACE_28 28.f
#define UPDOWNSPACE_25 25.f
#define UPDOWNSPACE_15 15.f
#define UPDOWNSPACE_10 10.f



#pragma -mark font
#define FONT_28_Medium   [UIFont fontWithName:@"PingFang-SC-Medium" size:28]
#define FONT_20_Medium   [UIFont fontWithName:@"SFUIText-Medium" size:20]
#define FONT_16_Regular  [UIFont fontWithName:@"PingFang-SC-Regular" size:16]
#define FONT_15_Regular  [UIFont fontWithName:@"PingFang-SC-Medium" size:15]
#define FONT_14_Regular  [UIFont fontWithName:@"PingFang-SC-Regular" size:14]
#define FONT_12_Regular  [UIFont fontWithName:@"PingFang-SC-Regular" size:12]


#pragma -mark color
#define RGBA(r,g,b,a) [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:a]
#define HexRGBA(rgbValue,a) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:a]
//黑色
#define COLOR_343339 HexRGBA(0x343339,1.f)
//黑色(0.7透明度)
#define COLOR_343339_7 HexRGBA(0x343339,0.7f)
//灰色
#define COLOR_666666 HexRGBA(0x666666,1.f)
//白色
#define COLOR_FFFFFF HexRGBA(0xFFFFFF,1.f)
//深蓝
#define COLOR_358BEF HexRGBA(0x358BEF,1.f)
//浅蓝
#define COLOR_58A5F6 HexRGBA(0x58A5F6,1.f)
//红色
#define COLOR_F20909 HexRGBA(0xF20909,1.f)
//橘色
#define COLOR_FF5D31 HexRGBA(0xFF5D31,1.f)
//浅橘
#define COLOR_FF7D5A HexRGBA(0xFF7D5A,1.f)
//渐变蓝1
#define COLOR_4591F1 HexRGBA(0x4591F1,1.f)
//渐变蓝2
#define COLOR_6CB9F9 HexRGBA(0x6CB9F9,1.f)




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



/**
 按钮触发汇总
 -- 提供可重写父类的方法 --

 @param btn 按钮
 */
- (void)buttonClick:(UIButton*)btn;



@end
