//
//  RXServerPipe
//
//  Created by Xing Rick on 6/24/13.
//  Copyright (c) 2012年 Xing Rick. All rights reserved.
//

#import "RXHttpPipe.h"
#include "stdrfx.h"

@implementation RXHttpPipe
@synthesize serverUrl;
@synthesize Code;

- (id)init
{
    self = [super init];
    if (!self) return nil;
    
    serverUrl = nil;
    Code = 0;
    
    return self;
}

- (NSString *)getServerData:(NSString *)sending
{
    NSURL * Url = [NSURL URLWithString:self.serverUrl];
    NSMutableURLRequest * UrlRequest = [NSMutableURLRequest requestWithURL:Url];
    NSMutableString * RequestParameter = [[[NSMutableString alloc] initWithString:sending] autorelease];
    
    [UrlRequest setHTTPMethod:@"POST"];
    [UrlRequest setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    [UrlRequest setHTTPBody:[RequestParameter dataUsingEncoding:NSUTF8StringEncoding]];
    
    NSError * UrlError;
    NSHTTPURLResponse * UrlResponse;
    NSData * RespData = [NSURLConnection sendSynchronousRequest:UrlRequest returningResponse:&UrlResponse error:&UrlError];
    
    NSString * Resp = @"";
    
    switch (UrlResponse.statusCode) {
        case 400:
            self.Code = RXHttpPipe_HTTP_ERROR;
            break;
        case 500:
            self.Code = RXHttpPipe_HTTP_ERROR;
            break;
        default:
            if (RespData) {
                self.Code = RXHttpPipe_RUN_OK;
                Resp = [[[NSString alloc] initWithData:RespData encoding:NSUTF8StringEncoding] autorelease];
            } else {
                self.Code = RXHttpPipe_HTTP_ERROR;
            }
            
            break;
    }
    
    return Resp;
}

@end
