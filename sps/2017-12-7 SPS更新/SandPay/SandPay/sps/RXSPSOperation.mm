//
//  RXSPSOperation.m
//  sps2-dev
//
//  Created by Rick Xing on 6/24/13.
//  Copyright (c) 2013 Rick Xing. All rights reserved.
//

#import "RXSPSOperation.h"
#import "RXHttpPipe.h"
#include "RunCode.h"
#include "RXSandPayCore.h"
#include "gv.h"



//替换地方
//#define HttpAddress     "https://query-test.sandpay.com.cn/mobile/controller.srv"  //测试
//#define HttpAddress   "http://go-test.sandpay.com.cn/mobile/controller.srv"
//#define HttpAddress  "https://multipay-test.sandpay.com.cn:10443/mobile/controller.srv"
//#define HttpAddress     "https://multipay.sandpay.com.cn/mobile/controller.srv" //生产
#define HttpAddress     "https://jzb.sandpay.com.cn/mobile/controller.srv" //生产
//#define HttpAddress     "http://jzb.sandlife.com.cn/mobile/controller.srv" //生产

#define IF_ERROR_GOTO_END(function_name) \
if(ReturnCode != RunCode_Ok) \
{ \
    [self.delegate performSelectorOnMainThread:@selector(function_name) withObject:[NSNumber numberWithInt:ReturnCode] waitUntilDone:YES]; \
    break; \
}

@implementation RXSPSOperation
@synthesize delegate;
@synthesize ThreadCode;
@synthesize ReturnCode;

- (XString)Transmit:(XString)data
{
    RXHttpPipe* httpPipe = [[[RXHttpPipe alloc] init] autorelease];
    NSLog(@"请求地址: %s", HttpAddress);
    httpPipe.serverUrl = [NSMutableString stringWithUTF8String:HttpAddress];
    
    XString senddata = "data=" + data;
     NSLog(@"senddata===%@",[NSString stringWithUTF8String:senddata.Buffer()]);
    NSMutableString* recvdata = [[NSMutableString alloc] init];
    
    [recvdata setString:[httpPipe getServerData:[NSString stringWithUTF8String:senddata.Buffer()]]];
    
    if(httpPipe.Code == RXHttpPipe_RUN_OK)
    {
        ReturnCode = RunCode_Ok;
        NSLog(@"recvdata===%@",recvdata);
        return XString([recvdata UTF8String]);
    }
    else
    {
        ReturnCode = RunCode_Network_Error;
        return XString("");
    }
}

- (void)main
{
    switch (self.ThreadCode)
    {
        case SPS_Thread_Code_Loading:
        {
            NSLog(@"\n\n\n>>>>>>>>>>>>>>>>>>>> SPS_Thread_Code_Loading <<<<<<<<<<<<<<<<<<<<\n\n\n");
            
            XString recvData;
            
            recvData = [self Transmit:payCore.Biz_UP("00010001")];  //安全认证第一步
            IF_ERROR_GOTO_END(OperationEnd:)
            if(payCore.Biz_DOWN(recvData) != RXSandPayCore::HANDLE_OK) ReturnCode = RunCode_PayCore_Error;
            IF_ERROR_GOTO_END(OperationEnd:)
            
            
            recvData = [self Transmit:payCore.Biz_UP("00010002")];   //安全认证第二步
            IF_ERROR_GOTO_END(OperationEnd:)
            if(payCore.Biz_DOWN(recvData) != RXSandPayCore::HANDLE_OK) ReturnCode = RunCode_PayCore_Error;
            IF_ERROR_GOTO_END(OperationEnd:)
            
            
            recvData = [self Transmit:payCore.Biz_UP("00010003")];   //安全认证第三步
            IF_ERROR_GOTO_END(OperationEnd:)
            if(payCore.Biz_DOWN(recvData) != RXSandPayCore::HANDLE_OK) ReturnCode = RunCode_PayCore_Error;
            IF_ERROR_GOTO_END(OperationEnd:)

            
            recvData = [self Transmit:payCore.Biz_UP("00020001")];   // 执行任务开始付款
            IF_ERROR_GOTO_END(OperationEnd:)
            if(payCore.Biz_DOWN(recvData) != RXSandPayCore::HANDLE_OK) ReturnCode = RunCode_PayCore_Error;
            IF_ERROR_GOTO_END(OperationEnd:)

            if(payCore._sid == "")
            {
//                payCore.lgnType = "0";
//                payCore.memName = "tensking";
//                payCore.memPasswd = "tensking1";
//                recvData = [self Transmit:payCore.Biz_UP("00040001")];
//                IF_ERROR_GOTO_END(OperationEnd:)
//                if(payCore.Biz_DOWN(recvData) != RXSandPayCore::HANDLE_OK) ReturnCode = RunCode_PayCore_Error;
//                IF_ERROR_GOTO_END(OperationEnd:)
            }
            recvData = [self Transmit:payCore.Biz_UP("00040002")];
            IF_ERROR_GOTO_END(OperationEnd:)
            if(payCore.Biz_DOWN(recvData) != RXSandPayCore::HANDLE_OK) ReturnCode = RunCode_PayCore_Error;
            IF_ERROR_GOTO_END(OperationEnd:)
            
            payCore.SetPayTools();
            
            ReturnCode = RunCode_Ok;
            [self.delegate performSelectorOnMainThread:@selector(OperationEnd:) withObject:[NSNumber numberWithInt:ReturnCode] waitUntilDone:YES];
            break;
        }
        case SPS_Thread_Code_Exchange:
        {
            NSLog(@"\n\n\n>>>>>>>>>>>>>>>>>>>> SPS_Thread_Code_Exchange <<<<<<<<<<<<<<<<<<<<\n\n\n");
            
            XString recvData;
            

            recvData = [self Transmit:payCore.Biz_UP("00020002")];
            IF_ERROR_GOTO_END(OperationEnd:)
            if(payCore.Biz_DOWN(recvData) != RXSandPayCore::HANDLE_OK) ReturnCode = RunCode_PayCore_Error;
            IF_ERROR_GOTO_END(OperationEnd:)
            

            ReturnCode = RunCode_Ok;
            [self.delegate performSelectorOnMainThread:@selector(OperationEnd:) withObject:[NSNumber numberWithInt:ReturnCode] waitUntilDone:YES];
            break;
        }
        case SPS_Thread_Code_Pay:
        {
            NSLog(@"\n\n\n>>>>>>>>>>>>>>>>>>>> SPS_Thread_Code_Pay <<<<<<<<<<<<<<<<<<<<\n\n\n");
            
            XString recvData;
            
            
            recvData = [self Transmit:payCore.Biz_UP("00020003")];
            IF_ERROR_GOTO_END(OperationEnd:)
            if(payCore.Biz_DOWN(recvData) != RXSandPayCore::HANDLE_OK) ReturnCode = RunCode_PayCore_Error;
            IF_ERROR_GOTO_END(OperationEnd:)
            
            
            ReturnCode = RunCode_Ok;
            [self.delegate performSelectorOnMainThread:@selector(OperationEnd:) withObject:[NSNumber numberWithInt:ReturnCode] waitUntilDone:YES];
            break;
        }
        case SPS_Thread_Code_RechargePay:
        {
            NSLog(@"\n\n\n>>>>>>>>>>>>>>>>>>>> SPS_Thread_Code_Pay <<<<<<<<<<<<<<<<<<<<\n\n\n");
            
            XString recvData;
            
            
            recvData = [self Transmit:payCore.Biz_UP("00030011")];
            IF_ERROR_GOTO_END(OperationEnd:)
            if(payCore.Biz_DOWN(recvData) != RXSandPayCore::HANDLE_OK) ReturnCode = RunCode_PayCore_Error;
            IF_ERROR_GOTO_END(OperationEnd:)
            
            
            ReturnCode = RunCode_Ok;
            [self.delegate performSelectorOnMainThread:@selector(OperationEnd:) withObject:[NSNumber numberWithInt:ReturnCode] waitUntilDone:YES];
            break;
        }
        case SPS_Thread_Code_3Steps:
        {
            NSLog(@"\n\n\n>>>>>>>>>>>>>>>>>>>> SPS_Thread_Code_3Steps <<<<<<<<<<<<<<<<<<<<\n\n\n");
            
            XString recvData;
            
            
            recvData = [self Transmit:payCore.Biz_UP("00010001")];
            IF_ERROR_GOTO_END(OperationEnd_3Steps:)
            if(payCore.Biz_DOWN(recvData) != RXSandPayCore::HANDLE_OK) ReturnCode = RunCode_PayCore_Error;
            IF_ERROR_GOTO_END(OperationEnd_3Steps:)
            
            
            recvData = [self Transmit:payCore.Biz_UP("00010002")];
            IF_ERROR_GOTO_END(OperationEnd_3Steps:)
            if(payCore.Biz_DOWN(recvData) != RXSandPayCore::HANDLE_OK) ReturnCode = RunCode_PayCore_Error;
            IF_ERROR_GOTO_END(OperationEnd_3Steps:)
            
            
            recvData = [self Transmit:payCore.Biz_UP("00010003")];
            IF_ERROR_GOTO_END(OperationEnd_3Steps:)
            if(payCore.Biz_DOWN(recvData) != RXSandPayCore::HANDLE_OK) ReturnCode = RunCode_PayCore_Error;
            IF_ERROR_GOTO_END(OperationEnd_3Steps:)
            
            
            ReturnCode = RunCode_Ok;
            [self.delegate performSelectorOnMainThread:@selector(OperationEnd_3Steps:) withObject:[NSNumber numberWithInt:ReturnCode] waitUntilDone:YES];
            break;
        }
        case SPS_Thread_Code_UnionPay:
        {
            NSLog(@"\n\n\n>>>>>>>>>>>>>>>>>>>> SPS_Thread_Code_UnionPay <<<<<<<<<<<<<<<<<<<<\n\n\n");
            
            XString recvData;
            
            
            recvData = [self Transmit:payCore.Biz_UP("00020007")];
            IF_ERROR_GOTO_END(OperationEnd:)
            if(payCore.Biz_DOWN(recvData) != RXSandPayCore::HANDLE_OK) ReturnCode = RunCode_PayCore_Error;
            IF_ERROR_GOTO_END(OperationEnd:)
            
            
            ReturnCode = RunCode_Ok;
            [self.delegate performSelectorOnMainThread:@selector(OperationEnd:) withObject:[NSNumber numberWithInt:ReturnCode] waitUntilDone:YES];
            break;
        }
        case SPS_Thread_Code_shortMsg:
        {
            NSLog(@"\n\n\n>>>>>>>>>>>>>>>>>>>> SPS_Thread_Code_shortMsg <<<<<<<<<<<<<<<<<<<<\n\n\n");
            XString recvData;
            
            recvData = [self Transmit:payCore.Biz_UP("00040004")];
            IF_ERROR_GOTO_END(OperationEnd:)
            if(payCore.Biz_DOWN(recvData) != RXSandPayCore::HANDLE_OK) ReturnCode = RunCode_PayCore_Error;
            IF_ERROR_GOTO_END(OperationEnd:)
            
            
            ReturnCode = RunCode_Ok;
            [self.delegate performSelectorOnMainThread:@selector(OperationEnd:) withObject:[NSNumber numberWithInt:ReturnCode] waitUntilDone:YES];
            break;
        }
        default:
            break;
    }
}


@end
