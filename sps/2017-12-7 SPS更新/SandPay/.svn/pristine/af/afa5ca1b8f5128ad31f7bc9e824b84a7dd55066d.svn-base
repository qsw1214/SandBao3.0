//
//  Utils.m
//  TestPlat
//
//  Created by Xing Rick on 12-4-12.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "Utils.h"
#include "stdrfx.h"
#include "rx_coder_pii.h"

@implementation Utils

+ (NSString *)byte2hex:(BYTE *)byte Length:(int)len
{
    int hexAscArrayLen = len * 2 + 1;
    char * hexAsc = new char [hexAscArrayLen];
    memset(hexAsc, 0, hexAscArrayLen);
    unsigned long hexAsc_len = 0;
    rx_Coder_Byte_To_HexFormatAsc(byte, len, hexAsc, &hexAsc_len);
    NSString * nsstr = [NSString stringWithUTF8String:hexAsc];
    delete [] hexAsc;
    return nsstr;
}

+ (int)hex2byte:(NSString *)hex Byte:(BYTE *)byte
{
    unsigned long byte_len = 0;
    rx_Coder_HexFormatAsc_To_Byte([hex UTF8String], [hex length], byte, &byte_len);
    return byte_len;
}


@end






