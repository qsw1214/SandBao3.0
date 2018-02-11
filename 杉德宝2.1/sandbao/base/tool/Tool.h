//
//  Tool.h
//  sandbao
//
//  Created by tianNanYiHao on 2017/5/17.
//  Copyright © 2017年 sand. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIViewController+RESideMenu.h>
typedef void(^LeftBtnBlock)();
typedef void(^RightBtnBlock)();
typedef void(^DefulBtnBlock)();


@interface Tool : NSObject


#pragma mark - popVc指定返回到某一个具体视图控制器
/**
 popVc指定返回到某一个具体视图控制器
 
 @param vc 当前视图控制器
 @param vcName 要返回的视图控制器
 */
+ (void)popToPenultimateViewController:(UIViewController*)vc vcName:(NSString*)vcName;



#pragma mark - url跳转
/**
 url跳转
 
 @param url 地址
 */
+ (void)openUrl:(NSURL*)url;


#pragma mark - 归位登陆页
/**
 归位登陆页

 @param sideMenuViewController sideMenuViewController description
 @param forLogOut 是否用于退出登录
 */
+ (void)setContentViewControllerWithLoginFromSideMentuVIewController:(id)sideMenuViewController forLogOut:(BOOL)forLogOut;

#pragma mark - 归位Home页或SpsLunch页
/**
 归位到Home页
 
 @param sideMenuViewController sideMenuViewController description
 */
+ (void)setContentViewControllerWithHomeOrSpsLunchFromSideMenuViewController:(id)sideMenuViewController;

#pragma mark - 支付工具排序
/**
 支付工具排序

 @param payTools 排序前支付工具组
 @return 排序后支付工具组
 */
+(NSArray*)orderForPayTools:(NSArray*)payTools;


#pragma mark - 生成条形码

/**
 生成条形码

 @param str code
 @return image
 */
+ (UIImage *)barCodeImageWithStr:(NSString *)str;


#pragma mark - 生成二维码

/**
 生成二维码

 @param str code
 @param size 二维码宽高
 @return image
 */
+ (UIImage *)twoDimensionCodeWithStr:(NSString *)str size:(CGFloat)size;


#pragma mark - 分转换为元
/**
 分转换为元
 
 @param payToolDic 支付工具字典
 @return 元 字符串
 */
+ (NSString*)fenToYuanDict:(NSDictionary*)payToolDic;

#pragma mark - 用户信息获取/刷新
/**
 刷新当前用户信息
 
 @param userInfoStr 用户信息json串
 */
+ (void)refreshUserInfo:(NSString*)userInfoStr;


#pragma mark - 装配我方支付工具
/**
 装配我方支付工具

 @param ownPayToolsArr 支付工具数组
 @return 支付工具分类
 */
+ (NSDictionary*)getPayToolsInfo:(NSArray*)ownPayToolsArr;


#pragma mark - 头像图片转换(avatar的两种形式_1.文件形式的base64_2.网络Url的Base64)

/**
 头像图片转换

 @param avatar 头像base64字符串
 @return 图片img
 */
+(UIImage*)avatarImageWith:(NSString*)avatar;


#pragma mark - 银行icon数据获取
/**
 获取银卡列表icon及相关UI信息

 @param bankName 银行名
 @return 信息数组
 */
+ (NSArray*)getBankIconInfo:(NSString*)bankName;


#pragma mark - 获取payList列表不同支付工具描述
/**
 获取payList列表不同支付工具描述
 
 @param type type
 @param userBalanceFloat 可用余额float
 @return NSString
 */
+ (NSString *)getbankLimitLabelText:(NSString*)type userblance:(CGFloat)userBalanceFloat;



#pragma mark - 获取paylist列表icon
/**
 获取paylist列表icon
 
 @param type 支付工具type
 @param title 支付工具title
 @param imaUrl 已获取imgurl
 @return img文件名
 */
+ (NSString *)getIconImageName:(NSString*)type title:(NSString*)title imaUrl:(NSString*)imaUrl;


#pragma mark  - 拼装终端标记域(cgf_tempFp)
/**
 拼装终端标记域(cgf_tempFp)

 @param StaticDataFlag 静态数据域标记
 @param DynamicDataFlag 动态数据域标记
 @return json串
 */
+ (NSString*)setCfgTempFpStaticDataFlag:(BOOL)StaticDataFlag DynamicDataFlag:(BOOL)DynamicDataFlag;

#pragma mark - 结束App
/**
 结束App

 @param vc 控制器
 */
+ (void)exitApplication:(UIViewController*)vc;

#pragma mark - ImageView工厂方法

/**
 ImageView工厂方法

 @param image 图片
 @return 实例
 */
+ (UIImageView*)createImagView:(UIImage*)image;

#pragma mark -  textfield工厂方法

/**
 textfield工厂方法

 @param placehold 预留字
 @param font font
 @param textColor 颜色
 @return 实例
 */
+ (UITextField*)createTextField:(NSString*)placehold font:(UIFont*)font textColor:(UIColor*)textColor;


#pragma mark -  Label工厂方法
/**
 Label工厂方法

 @param str 文字
 @param attributeStr attribute文字
 @param font 字体大小
 @param textColor 颜色
 @param alignment 位置
 @return 实例
 */
+ (UILabel*)createLable:(NSString*)str attributeStr:(NSMutableAttributedString*)attributeStr font:(UIFont*)font textColor:(UIColor*)textColor alignment:(NSTextAlignment)alignment;

#pragma mark -  Btn工厂方法
/**
 Btn工厂方法

 @param str 文字
 @param attributeStr attribute文字
 @param font 字体大小
 @param textColor 颜色
 @return
 */
+ (UIButton*)createButton:(NSString*)str attributeStr:(NSMutableAttributedString*)attributeStr font:(UIFont*)font textColor:(UIColor*)textColor;

@end
