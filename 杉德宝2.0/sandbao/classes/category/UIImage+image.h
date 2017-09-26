//
//  UIImage+image.h
//  sand_mobile_mask
//
//  Created by tianNanYiHao on 14-8-9.
//  Copyright (c) 2014年 sand. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (image)

/**
 *@brief 根据屏幕的尺寸返回全屏的图片
 *@param name  字符串
 *@return 返回UIImage
 */
+ (UIImage *)fullscreenImageWithName:(NSString *)name;

/**
 *@brief 根据屏幕的尺寸返回所有iPhone全屏的图片
 *@param name  字符串
 *@return 返回UIImage
 */
+ (UIImage *)fullscreenAllIphoneImageWithName:(NSString *)name;

/**
 *@brief 根据屏幕的尺寸返回iPhone全屏的图片
 *@param name  字符串
 *@return 返回UIImage
 */
+ (UIImage *)fullscreenIphoneImageWithName:(NSString *)name;

/**
 *@brief 修改图片的方向
 *@param aImage  图片
 *@return 返回UIImage
 */
+ (UIImage *)fixOrientation:(UIImage *)aImage;

/**
 *@brief 使用颜色创建image
 *@param color  颜色
 *@return 返回UIImage
 */
+ (UIImage *)imageWithColor:(UIColor *)color;

/**
 *@brief 使用颜色创建image
 *@param color  颜色
 *@param size  大小
 *@return 返回UIImage
 */
+ (UIImage *)imageWithColor:(UIColor *)color size:(CGSize)size;
@end
