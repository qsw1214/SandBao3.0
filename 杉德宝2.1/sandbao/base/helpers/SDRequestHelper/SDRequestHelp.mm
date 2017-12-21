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
#import "PayNuc.h"
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


/**
 error公共处理方法
 (关于HUD处理:请求成功则通过block回调确认是否hidden,请求失败则均做hidden处理)
 
 @param funcName 流程名称
 @return 成功/错误Type
 */
- (SDRequestErrorType)errorDisposeWithfuncName:(NSString*)funcName{
    
    __weak typeof(self) weakSelf = self;
    //判断对象一: fr
    if (fr) {
        if(fr == 1 || fr == 2 || fr == 3 || fr == 5 || fr == 6 || fr == 7){
            dispatch_async(dispatch_get_main_queue(), ^{
                if (weakSelf.HUD) {
                    [weakSelf.HUD hidden];
                }
                //自动处理
                if (self.respCodeErrorAutomatic) {
                    [SDMBProgressView showSDMBProgressLoadErrorImgINView:[UIApplication sharedApplication].keyWindow];
                }
                //代码手动处理
                else{
                    
                }
            });
            return frErrorType;
        }
        if(fr == 4){ //tubeID管道失效处理
            NSString *sToken = [NSString stringWithUTF8String:paynuc.get("sToken").c_str()];
            NSString *tToken = [NSString stringWithUTF8String:paynuc.get("tToken").c_str()];
            paynuc.set("cfg_termFp", [[Tool setCfgTempFpStaticDataFlag:YES DynamicDataFlag:NO] UTF8String]);
            paynuc.func("CreateTube");
            paynuc.set("sToken",[sToken UTF8String]);
            paynuc.set("tToken",[tToken UTF8String]);
            fr = paynuc.func([funcName UTF8String]);
            //重新调用判断并返回
            [self errorDisposeWithfuncName:funcName];
        }
    }
    else{
        //判断对象二:respCode = 100000
        weakSelf.respCode = [NSString stringWithUTF8String:paynuc.get("respCode").c_str()];
        if ([@"100000" isEqualToString:weakSelf.respCode]) {
            return successType;
        }else{
            /*1.特殊处理集合:
             *030005 -> 登陆加强鉴权->HUD消失
             *030012 -> 微博第三方登陆为注册->HUD消失
             *050005 -> 绑卡成功,开通快捷失败(后端默认绑卡成功)->HUD消失
             *050004 -> 实名成功,开通快捷失败(后端默认实名成功)->HUD消失
             */
            NSArray *array = @[@"030005",@"030012",@"050005",@"050004"];
            if ([self respCodeArray:array respCode:weakSelf.respCode]) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    if (weakSelf.HUD) {
                        [weakSelf.HUD hidden];
                    }
                });
                return respCodeErrorType;
            }
            /*2.常规处理一:
             *sToken失效处理->HUD消失/退出登录界面
             */
            else if([@"020002" isEqualToString:weakSelf.respCode]|| [@"040006" isEqualToString:weakSelf.respCode]){
                dispatch_async(dispatch_get_main_queue(), ^{
                    if (weakSelf.HUD) {
                        [weakSelf.HUD hidden];
                    }
                    [Tool showDialog:[NSString stringWithUTF8String:paynuc.get("respMsg").c_str()] defulBlock:^{
                        [Tool setContentViewControllerWithLoginFromSideMentuVIewController:weakSelf.controller forLogOut:YES];
                    }];
                });
                return respCodeErrorType;
            }
            /*3.常规处理二:
             *respCode常规处理->HUD消失/展示错误消息
             *respCode常规处理->HUD消失/不展示错误消息,由程序员手动配置操作
             */
            else{
                dispatch_async(dispatch_get_main_queue(), ^{
                    if (weakSelf.HUD) {
                        [weakSelf.HUD hidden];
                    }
                    weakSelf.respMsg = [NSString stringWithUTF8String:paynuc.get("respMsg").c_str()];
                    NSString *authToolStr = [NSString stringWithUTF8String:paynuc.get("authTools").c_str()];
                    NSArray *arrTools = [[PayNucHelper sharedInstance] jsonStringToArray:authToolStr];
                    //自动处理
                    if (self.respCodeErrorAutomatic) {
                        if (arrTools.count>0) {
                            //checkResultMsg错误码提示
                            NSString *checkResultMsg = [[arrTools firstObject] objectForKey:@"checkResultMsg"];
                            if (checkResultMsg.length>0) {
                                [Tool showDialog:checkResultMsg];
                            }else{
                                //respMsg错误码提示
                                [Tool showDialog:weakSelf.respMsg];
                            }
                        }else{
                            //respMsg错误码提示
                            [Tool showDialog:weakSelf.respMsg];
                        }
                    }
                    //代理手动处理
                    else{
                        
                    }
                });
                return respCodeErrorType;
            }
        }
    }
    return otherErrorType;
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
    
    fr = 0;
    
    fr = paynuc.func([funcname UTF8String]);
    
    //error过滤成功,回调成功block,过滤失败,回调失败block
    SDRequestErrorType errorType = [self errorDisposeWithfuncName:funcname];
    
    //流程走完,需要立即回调successBlock,以免下一步流程获取数据失败或提早调用
    if (errorType == successType) {
        
        successBlock();
    }
    if (errorType == frErrorType) {
       
        errorBlock(frErrorType); //若fr情况导致失败,不需要特别处理,流程没有成功,可以重发
    }
    if (errorType == respCodeErrorType) {
        
        errorBlock(respCodeErrorType);

    }

       
    
}



@end
