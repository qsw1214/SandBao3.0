//
//  SDRequestHelp.m
//  sandbao
//
//  Created by tianNanYiHao on 2017/8/11.
//  Copyright © 2017年 sand. All rights reserved.
//




/*
 run_ok              = 0,
 msg_parse_err       = 1,
 msg_protocol_err    = 2,
 msg_sign_err        = 3,
 tube_expire         = 4,
 hmac_err            = 5,
 token_invalid       = 6,
 do_nothing          = 7
 */


#import "SDRequestHelp.h"

#import "PayNucHelper.h"

@interface SDRequestHelp(){
    int fr;
}

/**
 消息错误码
 */
@property (nonatomic, strong) NSString *respCode;

/**
 消息错误信息
 */
@property (nonatomic, strong) NSString *respMsg;

/**
 *respCodeErrorType模式下,自动处理标识
 *(自动处理功能:HUD小时,消息内容展示,默认为YES)
 */
@property (nonatomic, assign) BOOL respCodeErrorAutomatic;

@end

@implementation SDRequestHelp
//单例构造
static SDRequestHelp *_instance = nil;

+ (SDRequestHelp*)shareSDRequest{
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [[self alloc] init];
    });
    return _instance;
}

- (instancetype)init{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if ([super init]) {
            self.respCodeErrorAutomatic = YES;
        }
    });
    return self;
}


#pragma mark - **********************error公共处理方法**********************


//开启异步线程方法
- (void)dispatchGlobalQuque:(SDDispatchGlobalQueue)bclok{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        bclok();
    });
}

//返回主线程方法
- (void)dispatchToMainQueue:(SDDispatchMainQueue)block{
    
    dispatch_async(dispatch_get_main_queue(), ^{
        block();
    });
    
}



//特殊错误码组判断方法
- (BOOL)respCodeArray:(NSArray*)arr respCode:(NSString*)respcode{
    
    for (int i = 0; i<arr.count; i++) {
        NSString *code = arr[i];
        if ([code isEqualToString:respcode]) {
            return YES;
            break;
        }
    }
    return NO;
}




#pragma mark - **********************网络请求FUNC**********************

- (void)closedRespCpdeErrorAutomatic{
    self.respCodeErrorAutomatic = NO;
}

- (void)openRespCpdeErrorAutomatic{
    self.respCodeErrorAutomatic = YES;
}


- (void)requestWihtFuncName:(NSString*)funcname errorBlock:(SDResponseErrorBlock)errorBlock successBlock:(SDResponseSuccessBlock)successBlock{
    
    fr = NULL;
//    fr = //paynuc.func([funcname UTF8String]);
    
    //fr 存在异常 - > 处理
    if (fr) {
        SDRequestErrorType errorType = successType;
        if (errorType == frErrorType) {
            errorBlock(frErrorType); //若fr情况导致失败,不需要特别处理,流程没有成功,可以重发
        }
    }
    //响应成功/异常 - > 处理
    else{
        //resp返回respCode - > 处理
        SDRequestErrorType respErrorCode = successType;
        
        //流程走完OK
        if (respErrorCode == successType) {
            successBlock();
        }
        //流程未走完,回调类型为如下
        if (respErrorCode == respCodeErrorType) {
            errorBlock(respCodeErrorType);
        }
    }
}



@end
