//
//  Tool.h
//  sandbao
//
//  Created by tianNanYiHao on 2017/5/17.
//  Copyright © 2017年 sand. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^LeftBtnBlock)();
typedef void(^RightBtnBlock)();
typedef void(^DefulBtnBlock)();


@interface Tool : NSObject


#pragma mark - APPDelegate中弹框提示



#pragma mark - 弹出默认对话框+无事件处理

/**
 弹出(CustomAlertViewStyleDefault)对话框+无事件处理 (一般用于反馈后端resMsg)

 @param message 消息
 */
+ (void)showDialog:(NSString *)message;



#pragma mark - 弹出默认对话框+默认事件处理

/**
 弹出(CustomAlertViewStyleDefault)对话框+默认事件处理 (一般用于反馈后端resMsg,并需要处理一定事件如sToken失效提示后退出重登陆)

 @param message 消息
 @param defulblock 默认事件回调
 */
+ (void)showDialog:(NSString *)message defulBlock:(DefulBtnBlock)defulblock;



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
+ (void)showDialog:(NSString*)title message:(NSString*)message leftBtnString:(NSString*)leftString rightBtnString:(NSString*)rightString leftBlock:(LeftBtnBlock)leftbtnblock rightBlock:(RightBtnBlock)rightbtnblock;


#pragma mark - 跳转登陆页
/**
 跳转登陆页(1.Stoken失效/2.点击退出按钮/3.MQTT异地登陆)
 
 @param viewController 当前控制器
 */
+(void)presetnLoginVC:(UIViewController*)viewController;





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


#pragma mark - 金额格式化

/**
 数字:金额格式化

 @param number 数字
 @return 数组化字符串
 */
+ (NSString *)numberStyleWith:(NSNumber*)number;


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
+ (NSDictionary*)getOwnPayToolsInfo:(NSArray*)ownPayToolsArr;


#pragma mark - 头像图片转换(avatar的两种形式_1.文件形式的base64_2.网络Url的Base64)

/**
 头像图片转换

 @param avatar 头像base64字符串
 @return 图片img
 */
+(UIImage*)avatarImageWith:(NSString*)avatar;


#pragma mark - 头像缓存获取
/**
 获取缓存的头像

 @param uid 数据库userConfig的表名字段
 @return headimage
 */
+ (UIImage*)headAvatarDataGetWithSQLUid:(NSString*)uid;



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


#pragma mark -  BarBtn工厂方法
/**
 BarBtn工厂方法

 @param str 文字
 @param font 字体
 @param titleColor 字体颜色
 @param groundColor 背景颜色
 @param space 间距
 @return 实例
 */
+ (UIButton*)createBarButton:(NSString*)str font:(UIFont*)font titleColor:(UIColor*)titleColor backGroundColor:(UIColor*)groundColor leftSpace:(CGFloat)space;

@end
