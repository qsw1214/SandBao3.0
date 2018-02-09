//
//  UIImage+image.m
//  sand_mobile_mask
//
//  Created by tianNanYiHao on 14-8-9.
//  Copyright (c) 2014年 sand. All rights reserved.
//

#import "UIImage+image.h"



@implementation UIImage (image)

/**
 *@brief 根据屏幕的尺寸返回全屏的图片
 *@param name  字符串
 *@return 返回UIImage
 */
+ (UIImage *)fullscreenImageWithName:(NSString *)name
{
    if (iPhone4) {
        name = [name filenameAppend:@""];
    } else if (iPhone5 || iPhone6) {
        name = [name filenameAppend:@"@2x"];
    } else if (iPhone6plus) {
        name = [name filenameAppend:@"@3x"];
    }else {
        name = [name filenameAppend:@""];
    }
    return [UIImage imageNamed:name];
}

/**
 *@brief 根据屏幕的尺寸返回所有iPhone全屏的图片
 *@param name  字符串
 *@return 返回UIImage
 */
+ (UIImage *)fullscreenAllIphoneImageWithName:(NSString *)name
{
    if (iPhone4) {
        name = [name filenameAppend:@""];
    } else if (iPhone5) {
        name = [name filenameAppend:@"-568h@2x"];
    } else if (iPhone6) {
        name = [name filenameAppend:@"-667h@2x"];
    } else if (iPhone6plus) {
        name = [name filenameAppend:@"-736h@3x"];
    } else if (iPhoneX){
        name = [name filenameAppend:@"-812h@3x"];
    }
    else {
        name = [name filenameAppend:@""];
    }
    
//    NSLog(@"picture: %@", name);
    return [UIImage imageNamed:name];
}

/**
 *@brief 根据屏幕的尺寸返回iPhone全屏的图片
 *@param name  字符串
 *@return 返回UIImage
 */
+ (UIImage *)fullscreenIphoneImageWithName:(NSString *)name
{
    if (iPhone4) {
        name = [name filenameAppend:@""];
    } else if (iPhone5) {
        name = [name filenameAppend:@"-568h@2x"];
    } else if (iPhone6) {
        name = [name filenameAppend:@"-667h@2x"];
    } else if (iPhone6plus) {
        name = [name filenameAppend:@"-736h@3x"];
    } else if (iPhoneX){
        name = [name filenameAppend:@"-812h@3x"];
    }
    else {
        name = [name filenameAppend:@""];
    }
    return [UIImage imageNamed:name];
}

/**
 *@brief 修改图片的方向
 *@param aImage  图片
 *@return 返回UIImage
 */
+ (UIImage *)fixOrientation:(UIImage *)aImage {
    
    // No-op if the orientation is already correct
    if (aImage.imageOrientation == UIImageOrientationUp)
        return aImage;
    
    // We need to calculate the proper transformation to make the image upright.
    // We do it in 2 steps: Rotate if Left/Right/Down, and then flip if Mirrored.
    CGAffineTransform transform = CGAffineTransformIdentity;
    
    switch (aImage.imageOrientation) {
        case UIImageOrientationDown:
        case UIImageOrientationDownMirrored:
            transform = CGAffineTransformTranslate(transform, aImage.size.width, aImage.size.height);
            transform = CGAffineTransformRotate(transform, M_PI);
            break;
            
        case UIImageOrientationLeft:
        case UIImageOrientationLeftMirrored:
            transform = CGAffineTransformTranslate(transform, aImage.size.width, 0);
            transform = CGAffineTransformRotate(transform, M_PI_2);
            break;
            
        case UIImageOrientationRight:
        case UIImageOrientationRightMirrored:
            transform = CGAffineTransformTranslate(transform, 0, aImage.size.height);
            transform = CGAffineTransformRotate(transform, -M_PI_2);
            break;
        default:
            break;
    }
    
    switch (aImage.imageOrientation) {
        case UIImageOrientationUpMirrored:
        case UIImageOrientationDownMirrored:
            transform = CGAffineTransformTranslate(transform, aImage.size.width, 0);
            transform = CGAffineTransformScale(transform, -1, 1);
            break;
            
        case UIImageOrientationLeftMirrored:
        case UIImageOrientationRightMirrored:
            transform = CGAffineTransformTranslate(transform, aImage.size.height, 0);
            transform = CGAffineTransformScale(transform, -1, 1);
            break;
        default:
            break;
    }
    
    // Now we draw the underlying CGImage into a new context, applying the transform
    // calculated above.
    CGContextRef ctx = CGBitmapContextCreate(NULL, aImage.size.width, aImage.size.height,
                                             CGImageGetBitsPerComponent(aImage.CGImage), 0,
                                             CGImageGetColorSpace(aImage.CGImage),
                                             CGImageGetBitmapInfo(aImage.CGImage));
    CGContextConcatCTM(ctx, transform);
    switch (aImage.imageOrientation) {
        case UIImageOrientationLeft:
        case UIImageOrientationLeftMirrored:
        case UIImageOrientationRight:
        case UIImageOrientationRightMirrored:
            // Grr...
            CGContextDrawImage(ctx, CGRectMake(0,0,aImage.size.height,aImage.size.width), aImage.CGImage);
            break;
            
        default:
            CGContextDrawImage(ctx, CGRectMake(0,0,aImage.size.width,aImage.size.height), aImage.CGImage);
            break;
    }
    
    // And now we just create a new UIImage from the drawing context
    CGImageRef cgimg = CGBitmapContextCreateImage(ctx);
    UIImage *img = [UIImage imageWithCGImage:cgimg];
    CGContextRelease(ctx);
    CGImageRelease(cgimg);
    return img;
}

/**
 *@brief 使用颜色创建image
 *@param color  颜色
 *@return 返回UIImage
 */
+ (UIImage *)imageWithColor:(UIColor *)color {
    CGRect rect = CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}

/**
 *@brief 使用颜色创建image
 *@param color  颜色
 *@param size  大小
 *@return 返回UIImage
 */
+ (UIImage *)imageWithColor:(UIColor *)color size:(CGSize)size
{
    CGSize imageSize = size;
    UIGraphicsBeginImageContextWithOptions(imageSize, 0, [UIScreen mainScreen].scale);
    [color set];
    UIRectFill(CGRectMake(0, 0, imageSize.width, imageSize.height));
    UIImage *pressedColorImg = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return pressedColorImg;
}

/**
 *@brief 加载网络图片(放在线程执行)
 *@param paramUrl NSString 网络图片地址
 *@return 返回UIImage
 */
+ (UIImage *)imagewithUrl:(NSString *)paramUrl
{
    //获取网络图片地址
    NSURL *url = [NSURL URLWithString:paramUrl];
    //将网络地址的NSString类型转化为NSData类型
    NSData *data = [NSData dataWithContentsOfURL:url];
    //image与data的相互转换
    return [UIImage imageWithData:data];
}


@end
