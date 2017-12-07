//
//  SDSandSPS.m
//  SandLife
//
//  Created by WeiWei on 16/9/8.
//  Copyright © 2016年 Sand. All rights reserved.
//

#import "SDSandSPS.h"
#import "RXSPSEntry.h"
#import "SDLog.h"

#define  kSandPaySpSURL @"https://query-test.sandpay.com.cn/mobile/controller.srv"

//#define  kSandPaySpSURL @"https://jzb.sandpay.com.cn/mobile/controller.srv"


static SDSandSPS *sharedInstance;

@implementation SDSandSPS

+( instancetype ) instance  {
    
    static  dispatch_once_t  onceToken;
    
    dispatch_once (&onceToken, ^ {
        
        sharedInstance = [[SDSandSPS alloc] init];
                              
    });
    
    return sharedInstance;
}

#pragma mark SPS
- (void)SpsNetWork{

    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        int result = [self three];
        
        if (0 == result) {
            
           dispatch_async(dispatch_get_main_queue(), ^{
               
               self.isSpsPass = YES;
               [SDLog logTest:[NSString stringWithFormat:@"isSpsPass = %d",_isSpsPass]];
           });
            
        } else {
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                self.isSpsPass = NO;
                [SDLog logTest:[NSString stringWithFormat:@"isSpsPass = %d",_isSpsPass]];
                
            });

        }
        
    });
}
- (int)three
{
    NSString *recvData = @"";
    NSString *requestData = @"";

    requestData = [NSString stringWithFormat:@"%@=%@", @"data", [[RXSPSEntry sharedInstance] bizUP:@"00010001"]];
    recvData = [self httpSystemPost:kSandPaySpSURL message:requestData];
    if ([@"" isEqualToString:recvData] || recvData == nil) {
        return 1;
    }
    if ([[RXSPSEntry sharedInstance] bizDOWN:recvData] != 0) {
        return 1;
    }
    
    
    requestData = [NSString stringWithFormat:@"%@=%@", @"data", [[RXSPSEntry sharedInstance] bizUP:@"00010002"]];
    recvData = [self httpSystemPost:kSandPaySpSURL message:requestData];
    if ([@"" isEqualToString:recvData] || recvData == nil) {
        return 1;
    }
    if ([[RXSPSEntry sharedInstance] bizDOWN:recvData] != 0) {
        return 1;
    }

    
    requestData = [NSString stringWithFormat:@"%@=%@", @"data", [[RXSPSEntry sharedInstance] bizUP:@"00010003"]];;
    recvData = [self httpSystemPost:kSandPaySpSURL message:requestData];
    if ([@"" isEqualToString:recvData] || recvData == nil) {
        return 1;
    }
    if ([[RXSPSEntry sharedInstance] bizDOWN:recvData] != 0) {
        return 1;
    }
    
    
    return 0;
}

- (NSString *)httpSystemPost:(NSString *)requestUrl message:(NSString *)message
{
    NSString *json;
    NSURL * Url = [NSURL URLWithString:requestUrl];
    NSMutableURLRequest * UrlRequest = [NSMutableURLRequest requestWithURL:Url];
    NSMutableString * RequestParameter = [[NSMutableString alloc] initWithString:message];
    
    [UrlRequest setHTTPMethod:@"POST"];
    [UrlRequest setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    [UrlRequest setHTTPBody:[RequestParameter dataUsingEncoding:NSUTF8StringEncoding]];
    UrlRequest.timeoutInterval = 15;
    
    [SDLog logTest:[NSString stringWithFormat:@"RequestParameter = %@",RequestParameter]];
    
    NSError *UrlError;
    NSURLResponse *UrlResponse;
    NSData * RespData = [NSURLConnection sendSynchronousRequest:UrlRequest returningResponse:&UrlResponse error:&UrlError];

    if (RespData) {
        json = [[NSString alloc] initWithData:RespData encoding:NSUTF8StringEncoding];
        [SDLog logTest:[NSString stringWithFormat:@"三步认证返回报文-------------%@",json]];
    } else {
        [SDLog logTest:[NSString stringWithFormat:@"HTTPError[%@]", [UrlError localizedDescription]]];
        
        json = @"";
    }
    return json;
}

@end
