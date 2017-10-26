//
//  BaseViewController.h
//  sandbao
//
//  Created by tianNanYiHao on 2017/10/14.
//  Copyright © 2017年 sand. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>

#import "Masonry.h"
#import "UIView+easyFrame.h"
#import "NavCoverView.h"
#import "SDMBProgressView.h"

#import "SDSqlite.h"
#import "SqliteHelper.h"

#import "CardNoAuthToolView.h"
#import "IdentityAuthToolView.h"
#import "NameAuthToolView.h"
#import "PhoneAuthToolView.h"
#import "PwdAuthToolView.h"
#import "SixCodeAuthToolView.h"
#import "BankAuthToolView.h"





#pragma -mark 尺寸:frame
#define SCREEN_RECT [UIScreen mainScreen].bounds
#define SCREEN_SIZE [UIScreen mainScreen].bounds.size
#define SCREEN_WIDTH ([[UIScreen mainScreen] bounds].size.width)
#define SCREEN_HEIGHT ([[UIScreen mainScreen] bounds].size.height)

#define LEFTRIGHTSPACE_40 40.f
#define LEFTRIGHTSPACE_35 35.f
#define LEFTRIGHTSPACE_20 20.f
#define LEFTRIGHTSPACE_15 15.f
#define LEFTRIGHTSPACE_12 12.f

#define UPDOWNSPACE_112 112.f
#define UPDOWNSPACE_89 89.f
#define UPDOWNSPACE_69 69.f
#define UPDOWNSPACE_64 64.f
#define UPDOWNSPACE_58 58.f
#define UPDOWNSPACE_47 47.f
#define UPDOWNSPACE_43 43.f
#define UPDOWNSPACE_40 40.f
#define UPDOWNSPACE_36 36.f
#define UPDOWNSPACE_30 30.f
#define UPDOWNSPACE_28 28.f
#define UPDOWNSPACE_25 25.f
#define UPDOWNSPACE_20 20.f
#define UPDOWNSPACE_16 16.f
#define UPDOWNSPACE_15 15.f
#define UPDOWNSPACE_14 14.f
#define UPDOWNSPACE_11 11.f
#define UPDOWNSPACE_10 10.f
#define UPDOWNSPACE_0 0.f


#pragma -mark 字体:font
#define FONT_28_Medium   [UIFont fontWithName:@"PingFang-SC-Medium" size:28]
#define FONT_20_Medium   [UIFont fontWithName:@"SFUIText-Medium" size:20]
#define FONT_20_Regular  [UIFont fontWithName:@"PingFang-SC-Regular" size:20]
#define FONT_16_Regular  [UIFont fontWithName:@"PingFang-SC-Regular" size:16]
#define FONT_15_Regular  [UIFont fontWithName:@"PingFang-SC-Medium" size:15]
#define FONT_14_Regular  [UIFont fontWithName:@"PingFang-SC-Regular" size:14]
#define FONT_13_OpenSan  [UIFont fontWithName:@"OpenSans" size:13]
#define FONT_12_Regular  [UIFont fontWithName:@"PingFang-SC-Regular" size:12]
#define FONT_08_Regular  [UIFont fontWithName:@"PingFang-SC-Regular" size:8]

#pragma -mark 颜色:color
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


//短信类型
#pragma - mark 短信类型:smsCodeType
#define SMS_CHECKTYPE_REGIST 10001  //用于注册
#define SMS_CHECKTYPE_REALNAME 10002 //用于实名
#define SMS_CHECKTYPE_LOGINT 10003  //用于登陆加强鉴权



#pragma - mark 按钮Tag:tag
#define BTN_TAG_FORGETPWD 100000
#define BTN_TAG_LOGIN 100001
#define BTN_TAG_REGIST 100002
#define BTN_TAG_NEXT 100004
#define BTN_TAG_SHOWBANKLIST 100005
#define BTN_TAG_REALNAME  100006




/**
 项目工程:所有VC控制器均继承BaseViewController
 BaseViewController内置全屏Scrollview备用
 */
@interface BaseViewController : UIViewController<UIScrollViewDelegate>



/**
 所有子控件的父控件 - 类型:滚动视图
 */
@property (nonatomic, strong) UIScrollView *baseScrollView;


/**
 所有子控件的父控件 - 类型:导航视图
 */
@property (nonatomic, strong) NavCoverView *navCoverView;


/**
 HUD
 */
@property (nonatomic, strong) SDMBProgressView *HUD;



#pragma - mark overried - 供子类重写的公共方法


/**
 设置baseScrollview样式 - 供子类重写实现方法
 */
- (void)setBaseScrollview;

/**
 设置导航样式 - 供子类重写实现方法
 */
- (void)setNavCoverView;

/**
 按钮触发汇总 - 供子类重写实现方法
 -- 本类无具体实现方法 , 由子类复制具体实现--

 @param btn 按钮
 */
- (void)buttonClick:(UIButton*)btn;



@end
