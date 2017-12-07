//
//  Str2Data.mm
//  ItestXC
//
//  Created by Rick on 16/6/21.
//  Copyright © 2016年 SAND. All rights reserved.
//

#import <Foundation/Foundation.h>
#include "Str2Data.h"
#include "stdrfx.h"
#include "rx_coder_pii.h"

#include "xstring.h"
using namespace sz;

NSData * str2data(NSString * str)
{
    unsigned char * bytes = new unsigned char [[str length]];
    unsigned long bytes_len = 0;
    rx_Coder_HexFormatAsc_To_Byte([str UTF8String], [str length], bytes, &bytes_len);
    NSData * data = [NSData dataWithBytes:bytes length:bytes_len];
    delete [] bytes;
    return data;
}


NSString * data2str(NSData * data)
{
    int all_len = [data length] * 2 + 1;
    char * cstr = new char [all_len];
    for(int i = 0; i < all_len; i++)
        cstr[i] = 0x00;
    unsigned long cstr_len = 0;
    rx_Coder_Byte_To_HexFormatAsc((unsigned char *)[data bytes], [data length], cstr, &cstr_len);
    NSString * str = [NSString stringWithUTF8String:cstr];
    delete [] cstr;
    return str;
}


NSData * xstr2data(XString str)
{
    unsigned char * bytes = new unsigned char [str.Length()];
    unsigned long bytes_len = 0;
    rx_Coder_HexFormatAsc_To_Byte(str.Buffer(), str.Length(), bytes, &bytes_len);
    NSData * data = [NSData dataWithBytes:bytes length:bytes_len];
    delete [] bytes;
    return data;
}


XString data2xstr(NSData * data, int offset, int len)
{
    int all_len = [data length] * 2 + 1;
    char * cstr = new char [all_len];
    for(int i = 0; i < all_len; i++)
        cstr[i] = 0x00;
    unsigned long cstr_len = 0;
    rx_Coder_Byte_To_HexFormatAsc((unsigned char *)[data bytes] + offset, len, cstr, &cstr_len);
    XString str = cstr;
    delete [] cstr;
    return str;
}




