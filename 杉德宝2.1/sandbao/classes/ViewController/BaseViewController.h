//
//  BaseViewController.h
//  sandbao
//
//  Created by tianNanYiHao on 2017/10/14.
//  Copyright © 2017年 sand. All rights reserved.
//

//系统框架
#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>

//三方库头文件
#import "Masonry.h"
#import "RESideMenu.h"
#import "UMMobClick/MobClick.h"

//类扩展头文件
#import "UIView+easyFrame.h"

//自定义头文件
#import "SDSqlite.h"
#import "SqliteHelper.h"
#import "NavCoverView.h"
#import "SDMBProgressView.h"
#import "CardNoAuthToolView.h"
#import "IdentityAuthToolView.h"
#import "NameAuthToolView.h"
#import "PhoneAuthToolView.h"
#import "PwdAuthToolView.h"
#import "SixCodeAuthToolView.h"
#import "BankAuthToolView.h"
#import "ValidAuthToolView.h"
#import "CvnAuthToolView.h"
#import "SDPayConfig.h"






#pragma mark - 尺寸:frame
#define SCREEN_RECT [UIScreen mainScreen].bounds
#define SCREEN_SIZE [UIScreen mainScreen].bounds.size
#define SCREEN_WIDTH ([[UIScreen mainScreen] bounds].size.width)
#define SCREEN_HEIGHT ([[UIScreen mainScreen] bounds].size.height)

#define SCREEN_WIDTH_320 320.f  //4s_5c_5s
#define SCREEN_WIDTH_375 375.f  //6_6s_7_8
#define SCREEN_WIDTH_414 414.f  //6+_6s+_7+

#define SCREEN_HEIGHT_480 480.f //4s
#define SCREEN_HEIGHT_568 568.f //5_5s
#define SCREEN_HEIGHT_667 667.f //6_6s_7_8
#define SCREEN_HEIGHT_736 736.f //6+_6s+_7+



/**
 *UI设计以6为模板
 *@return 各机型对应比例的宽
 */
#define LEFTRIGHTSPACE_(float) ((float/SCREEN_WIDTH_375) * SCREEN_WIDTH)
#define LEFTRIGHTSPACE_286 ((286.f/SCREEN_WIDTH_375) * SCREEN_WIDTH)
#define LEFTRIGHTSPACE_120 ((120.f/SCREEN_WIDTH_375) * SCREEN_WIDTH)
#define LEFTRIGHTSPACE_100 ((100.f/SCREEN_WIDTH_375) * SCREEN_WIDTH)
#define LEFTRIGHTSPACE_80 ((80.f/SCREEN_WIDTH_375) * SCREEN_WIDTH)
#define LEFTRIGHTSPACE_66  ((66.f/SCREEN_WIDTH_375) * SCREEN_WIDTH)
#define LEFTRIGHTSPACE_55  ((55.f/SCREEN_WIDTH_375) * SCREEN_WIDTH)
#define LEFTRIGHTSPACE_50  ((50.f/SCREEN_WIDTH_375) * SCREEN_WIDTH)
#define LEFTRIGHTSPACE_45  ((45.f/SCREEN_WIDTH_375) * SCREEN_WIDTH)
#define LEFTRIGHTSPACE_40  ((40.f/SCREEN_WIDTH_375) * SCREEN_WIDTH)
#define LEFTRIGHTSPACE_35  ((35.f/SCREEN_WIDTH_375) * SCREEN_WIDTH)
#define LEFTRIGHTSPACE_30  ((30.f/SCREEN_WIDTH_375) * SCREEN_WIDTH)
#define LEFTRIGHTSPACE_25  ((25.f/SCREEN_WIDTH_375) * SCREEN_WIDTH)
#define LEFTRIGHTSPACE_20  ((20.f/SCREEN_WIDTH_375) * SCREEN_WIDTH)
#define LEFTRIGHTSPACE_18  ((18.f/SCREEN_WIDTH_375) * SCREEN_WIDTH)
#define LEFTRIGHTSPACE_15  ((15.f/SCREEN_WIDTH_375) * SCREEN_WIDTH)
#define LEFTRIGHTSPACE_12  ((12.f/SCREEN_WIDTH_375) * SCREEN_WIDTH)
#define LEFTRIGHTSPACE_09  ((09.f/SCREEN_WIDTH_375) * SCREEN_WIDTH)
#define LEFTRIGHTSPACE_04  ((04.f/SCREEN_WIDTH_375) * SCREEN_WIDTH)
#define LEFTRIGHTSPACE_00  (00.f)


/**
 *UI设计以6为模板
 *@return 各机型对应比例的高
 */
#define UPDOWNSPACE_(float) ((float/SCREEN_HEIGHT_667) * SCREEN_HEIGHT)
#define UPDOWNSPACE_197  ((197.f/SCREEN_HEIGHT_667) * SCREEN_HEIGHT)
#define UPDOWNSPACE_174  ((174.f/SCREEN_HEIGHT_667) * SCREEN_HEIGHT)
#define UPDOWNSPACE_160  ((160.f/SCREEN_HEIGHT_667) * SCREEN_HEIGHT)
#define UPDOWNSPACE_133  ((133.f/SCREEN_HEIGHT_667) * SCREEN_HEIGHT)
#define UPDOWNSPACE_122  ((122.f/SCREEN_HEIGHT_667) * SCREEN_HEIGHT)
#define UPDOWNSPACE_112  ((112.f/SCREEN_HEIGHT_667) * SCREEN_HEIGHT)
#define UPDOWNSPACE_100  ((100.f/SCREEN_HEIGHT_667) * SCREEN_HEIGHT)
#define UPDOWNSPACE_89   ((89.f/SCREEN_HEIGHT_667) * SCREEN_HEIGHT)
#define UPDOWNSPACE_69   ((69.f/SCREEN_HEIGHT_667) * SCREEN_HEIGHT)
#define UPDOWNSPACE_64   ((64.f/SCREEN_HEIGHT_667) * SCREEN_HEIGHT)
#define UPDOWNSPACE_58   ((58.f/SCREEN_HEIGHT_667) * SCREEN_HEIGHT)
#define UPDOWNSPACE_52   ((52.f/SCREEN_HEIGHT_667) * SCREEN_HEIGHT)
#define UPDOWNSPACE_50   ((50.f/SCREEN_HEIGHT_667) * SCREEN_HEIGHT)
#define UPDOWNSPACE_47   ((47.f/SCREEN_HEIGHT_667) * SCREEN_HEIGHT)
#define UPDOWNSPACE_43   ((43.f/SCREEN_HEIGHT_667) * SCREEN_HEIGHT)
#define UPDOWNSPACE_40   ((40.f/SCREEN_HEIGHT_667) * SCREEN_HEIGHT)
#define UPDOWNSPACE_36   ((36.f/SCREEN_HEIGHT_667) * SCREEN_HEIGHT)
#define UPDOWNSPACE_34   ((34.f/SCREEN_HEIGHT_667) * SCREEN_HEIGHT)
#define UPDOWNSPACE_30   ((30.f/SCREEN_HEIGHT_667) * SCREEN_HEIGHT)
#define UPDOWNSPACE_28   ((28.f/SCREEN_HEIGHT_667) * SCREEN_HEIGHT)
#define UPDOWNSPACE_25   ((25.f/SCREEN_HEIGHT_667) * SCREEN_HEIGHT)
#define UPDOWNSPACE_23   ((23.f/SCREEN_HEIGHT_667) * SCREEN_HEIGHT)
#define UPDOWNSPACE_20   ((20.f/SCREEN_HEIGHT_667) * SCREEN_HEIGHT)
#define UPDOWNSPACE_16   ((16.f/SCREEN_HEIGHT_667) * SCREEN_HEIGHT)
#define UPDOWNSPACE_15   ((15.f/SCREEN_HEIGHT_667) * SCREEN_HEIGHT)
#define UPDOWNSPACE_14   ((14.f/SCREEN_HEIGHT_667) * SCREEN_HEIGHT)
#define UPDOWNSPACE_11   ((11.f/SCREEN_HEIGHT_667) * SCREEN_HEIGHT)
#define UPDOWNSPACE_10   ((10.f/SCREEN_HEIGHT_667) * SCREEN_HEIGHT)
#define UPDOWNSPACE_09   ((09.f/SCREEN_HEIGHT_667) * SCREEN_HEIGHT)
#define UPDOWNSPACE_05   ((05.f/SCREEN_HEIGHT_667) * SCREEN_HEIGHT)
#define UPDOWNSPACE_01   ((01.f/SCREEN_HEIGHT_667) * SCREEN_HEIGHT)
#define UPDOWNSPACE_0    (0.f)


#pragma mark - 字体:font
//0.8571:设计师给出(5/6/7)与 (6+/7+)之间的换算比例,基于目前有误的设计UI稿进行的修正值
#define fontSizeFit(float) ((SCREEN_HEIGHT==SCREEN_HEIGHT_736)?(float):(float*0.8571))

#define FONT_50_SFUDisplay_Regular [UIFont fontWithName:@"SFUIDisplay-Regular" size:fontSizeFit(50)]
#define FONT_36_DINAlter [UIFont fontWithName:@"DINAlternate-Bold" size:fontSizeFit(36)]
#define FONT_36_SFUIT_Rrgular [UIFont fontWithName:@"SFUIText-Regular" size:fontSizeFit(36)]
#define FONT_35_SFUIT_Rrgular [UIFont fontWithName:@"SFUIText-Regular" size:fontSizeFit(35)]
#define FONT_28_SFUIT_Rrgular [UIFont fontWithName:@"SFUIText-Regular" size:fontSizeFit(28)]
#define FONT_28_Medium   [UIFont fontWithName:@"PingFang-SC-Medium" size:fontSizeFit(28)]
#define FONT_24_Medium   [UIFont fontWithName:@"PingFang-SC-Medium" size:fontSizeFit(24)]
#define FONT_20_Medium   [UIFont fontWithName:@"SFUIText-Medium" size:fontSizeFit(20)]
#define FONT_20_Regular  [UIFont fontWithName:@"PingFang-SC-Regular" size:fontSizeFit(20)]
#define FONT_18_Regular  [UIFont fontWithName:@"PingFang-SC-Regular" size:fontSizeFit(18)]
#define FONT_16_Regular  [UIFont fontWithName:@"PingFang-SC-Regular" size:fontSizeFit(16)]
#define FONT_16_PingFangSC_Light  [UIFont fontWithName:@"PingFangSC-Light" size:fontSizeFit(16)]
#define FONT_15_Regular [UIFont fontWithName:@"PingFang-SC-Regular" size:fontSizeFit(15)]
#define FONT_18_Medium  [UIFont fontWithName:@"PingFang-SC-Medium" size:fontSizeFit(18)]
#define FONT_15_Medium  [UIFont fontWithName:@"PingFang-SC-Medium" size:fontSizeFit(15)]
#define FONT_14_Regular  [UIFont fontWithName:@"PingFang-SC-Regular" size:fontSizeFit(14)]
#define FONT_14_SFUIT_Rrgular [UIFont fontWithName:@"SFUIText-Regular" size:fontSizeFit(14)]
#define FONT_13_OpenSan  [UIFont fontWithName:@"OpenSans" size:fontSizeFit(13)]
#define FONT_13_Regular  [UIFont fontWithName:@"PingFang-SC-Regular" size:fontSizeFit(13)]
#define FONT_12_Regular  [UIFont fontWithName:@"PingFang-SC-Regular" size:fontSizeFit(12)]
#define FONT_11_Regular  [UIFont fontWithName:@"PingFang-SC-Regular" size:fontSizeFit(11)]
#define FONT_10_Regular  [UIFont fontWithName:@"PingFang-SC-Regular" size:fontSizeFit(10)]
#define FONT_10_DINAlter [UIFont fontWithName:@"DINAlternate-Bold" size:fontSizeFit(10)]
#define FONT_10_PingFangSC_Light  [UIFont fontWithName:@"PingFangSC-Light" size:fontSizeFit(10)]
#define FONT_08_Regular  [UIFont fontWithName:@"PingFang-SC-Regular" size:fontSizeFit(8)]


#pragma mark - 颜色:color
#define RGBA(r,g,b,a) [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:a]
#define HexRGBA(rgbValue,a) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:a]
//正黑
#define COLOR_000000 HexRGBA(0x000000,1.f)
//黑色
#define COLOR_343339 HexRGBA(0x343339,1.f)
//黑色(0.7透明度)
#define COLOR_343339_7 HexRGBA(0x343339,0.7f)
//黑色(0.5透明度)
#define COLOR_343339_5 HexRGBA(0x343339,0.5f)
//按钮灰
#define COLOR_D9D9D9 HexRGBA(0xD9D9D9,1.f)
//线框灰
#define COLOR_D8D8D8 HexRGBA(0xD8D8D8,1.f)
//线灰
#define COLOR_A1A2A5_3 HexRGBA(0xA1A2A5,0.3f)
//灰色
#define COLOR_666666 HexRGBA(0x666666,1.f)
//背景灰
#define COLOR_F5F5F5 HexRGBA(0xF5F5F5,1.f)
//白色
#define COLOR_FFFFFF HexRGBA(0xFFFFFF,1.f)
//灰白
#define COLOR_EFEFF4 HexRGBA(0xEFEFF4,1.f)
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
//绿色
#define COLOR_74D478 HexRGBA(0x74D478,1.f)
//支付宝深蓝
#define COLOR_232B3F HexRGBA(0x232B3F,1.f)


//短信类型
#pragma mark - 短信类型:smsCodeType
#define SMS_CHECKTYPE_REGIST 10001  //用于注册
#define SMS_CHECKTYPE_REALNAME 10002 //用于实名
#define SMS_CHECKTYPE_LOGINT 10003  //用于登陆加强鉴权
#define SMS_CHECKTYPE_ADDBANKCARD 10004 //用于绑银行卡
#define SMS_CHECKTYPE_VERIFYTYPE 10005 //用于修改支付/登陆密码

//修改支付/登陆密码
#pragma mark - 修改支付/登陆密码
#define VERIFY_TYPE_CHANGEPATPWD 2001 //修改支付密码
#define VERIFY_TYPE_CHANGELOGPWD 2002 //修改登录密码
#define VERIFY_TYPE_FORGETLOGPWD 2003 //忘记登录密码

#pragma mark - 按钮Tag:tag
#define BTN_TAG_JUSTCLICK  99999  //仅点击(标识)
#define BTN_TAG_FORGETPWD 100000 //忘记密码
#define BTN_TAG_LOGIN 100001 //登录
#define BTN_TAG_REGIST 100002 //注册
#define BTN_TAG_NEXT 100004 //继续
#define BTN_TAG_SHOWBANKLIST 100005 //支持银行
#define BTN_TAG_REALNAME  100006 //实名
#define BTN_TAG_LOGOUT  100007  //登出
#define BTN_TAG_INOUTPAY  100008 //收付款
#define BTN_TAG_BLANCE  100009 //余额展示
#define BTN_TAG_CARDBAG  100010 //卡券包
#define BTN_TAG_RECHARGE  100011 //充值
#define BTN_TAG_TRANSFER  100012 //转账
#define BTN_TAG_SHOWALLMONEY  100013 //show全部金额
#define BTN_TAG_SEARCH  100014 //搜索
#define BTN_TAG_HONGBAO 100015 //红包
#define BTN_TAG_CHANGPAYPWD 100016 //修改支付密码
#define BTN_TAG_CHANGLOGPWD 100017 //修改登陆密码
#define BTN_TAG_FEEDBACK 100018 //意见反馈
#define BTN_TAG_ABOUTUS 100019 //关于我们
#define BTN_TAG_VERSION 100020 //版本说明
#define BTN_TAG_TOSTAR 100021 //去评分
#define BTN_TAG_ABOUTSAND 100022 //杉德宝隐私政策
#define BTN_TAG_PAYMENTACTIVE 100023 //代付凭证激活
#define BTN_TAG_BINDBANKCARD 100024 //添加银行卡
#define BTN_TAG_BINDSANDCARD 100025 //添加杉德卡
#define BTN_TAG_UNBINDCARD   100026 //解绑卡
#define BTN_TAG_CHANGEHEADIMG  100027 //修改头像
#define BTN_TAG_CHECKIDENTITY  100028 //身份认证
#define BTN_TAG_CHECKACCOUNT  100029 //杉德宝账号
#define BTN_TAG_MYERCODE  100030 //我的二维码
#define BTN_TAG_MYHEADNAME  100031 //我的发票抬头
#define BTN_TAG_CARDNUMFULL 100032 //银行卡超限
#define BTN_TAG_ENTERWEBVC 100033 //点击进入网页VC
#define BTN_TAG_PAY 100034 //立即支付
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



#pragma mark - overried - 供子类重写的公共方法


/**
 设置baseScrollview样式 - 供子类重写实现方法 :必须重写
 */
- (void)setBaseScrollview;

/**
 设置导航样式 - 供子类重写实现方法 : 必须重写
 */
- (void)setNavCoverView;

/**
 按钮触发汇总 - 供子类重写实现方法 : 可选重写
 -- 本类无具体实现方法 , 由子类复制具体实现--
 @param btn 按钮
 */
- (void)buttonClick:(UIButton*)btn;



@end
