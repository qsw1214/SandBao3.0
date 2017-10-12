//
//  GzipUtility.h
//  selfService
//
//  Created by tianNanYiHao on 15/9/17.
//  Copyright (c) 2015年 sand. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "zlib.h"

@interface GzipUtility : NSObject

/**
 *@brief 压缩
 *@param pUncompressedData  数据
 *@return 返回NSData
 */
+(NSData*) gzipData: (NSData*)pUncompressedData;

/**
 *@brief 解压
 *@param pUncompressedData  数据
 *@return 返回NSData
 */
+ (NSData *)uncompressZippedData:(NSData *)compressedData;

@end
