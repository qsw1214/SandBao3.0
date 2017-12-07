//
//  RXServerPipe
//
//  Created by Xing Rick on 6/24/13.
//  Copyright (c) 2013年 Xing Rick. All rights reserved.
//

#import <Foundation/Foundation.h>

#define RXHttpPipe_RUN_OK                           0x00000000
#define RXHttpPipe_HTTP_ERROR                       0x000a0001

@interface RXHttpPipe : NSObject
{
    NSMutableString * serverUrl;
    int Code;
}
@property (retain) NSMutableString * serverUrl;
@property int Code;

- (NSString *)getServerData:(NSString *)sending;

@end
