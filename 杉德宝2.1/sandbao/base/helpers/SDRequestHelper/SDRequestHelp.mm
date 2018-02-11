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
    fr = paynuc.func([funcname UTF8String]);
    
    //fr 存在异常 - > 处理
    if (fr) {
         SDRequestErrorType errorType = [self frErrorDisposeWithfuncName:funcname];
        if (errorType == frErrorType) {
            errorBlock(frErrorType); //若fr情况导致失败,不需要特别处理,流程没有成功,可以重发
        }
    }
    //响应成功/异常 - > 处理
    else{
        //resp返回respCode - > 处理
         SDRequestErrorType respErrorCode = [self respErrorDispose];
        
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

/**
 fr异常处理方法

 @param funcName 方法名
 @return 结果
 */
- (SDRequestErrorType)frErrorDisposeWithfuncName:(NSString*)funcName{
    
    __weak typeof(self) weakSelf = self;
    //判断对象一: fr
    if(fr == 1 || fr == 2 || fr == 3 || fr == 5 || fr == 6 || fr == 7){
        dispatch_async(dispatch_get_main_queue(), ^{
            if (weakSelf.HUD) {
                [weakSelf.HUD hidden];
            }
            //自动处理
            if (weakSelf.respCodeErrorAutomatic) {
                [SDMBProgressView showSDMBProgressLoadErrorImgINView:[UIApplication sharedApplication].keyWindow];
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
        [weakSelf frErrorDisposeWithfuncName:funcName];
    }
    return otherErrorType;
}


/**
 resp成功/异常处理

 @return 结果
 */
- (SDRequestErrorType)respErrorDispose{
    
    __weak typeof(self) weakSelf = self;
    
    //判断对象二:respCode = 100000
    weakSelf.respCode = [NSString stringWithUTF8String:paynuc.get("respCode").c_str()];
    if ([@"100000" isEqualToString:weakSelf.respCode]) {
        return successType;
    }
    else{
        /*1.特殊处理集合(默认不弹框提示,除非程序员自己外部修改):
         *030005 -> 登陆加强鉴权->HUD消失
         *030012 -> 微博第三方登陆为注册->HUD消失
         *050005 -> 绑卡成功,开通快捷失败(后端默认绑卡成功)->HUD消失
         *050004 -> 实名成功,开通快捷失败(后端默认实名成功)->HUD消失
         *040071 -> 检测没有发送短信(第一次setRealName上送信息给后端,后端返回该特殊错误码,用于UI跳转短信页)->HUD消失
         */
        NSArray *array = @[@"030005",@"030012",@"050005",@"050004",@"040071"];
        if ([weakSelf respCodeArray:array respCode:weakSelf.respCode]) {
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
                if (weakSelf.respCodeErrorAutomatic) {
                    [[SDAlertView shareAlert] showDialog:[NSString stringWithUTF8String:paynuc.get("respMsg").c_str()] defulBlock:^{
                        [Tool setContentViewControllerWithLoginFromSideMentuVIewController:weakSelf.controller forLogOut:YES];
                    }];
                }
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
                if (weakSelf.respCodeErrorAutomatic) {
                    if (arrTools.count>0) {
                        //checkResultMsg错误码提示
                        NSString *checkResultMsg = [[arrTools firstObject] objectForKey:@"checkResultMsg"];
                        if (checkResultMsg.length>0) {
                            [[SDAlertView shareAlert] showDialog:checkResultMsg];
                        }else{
                            //respMsg错误码提示
                            [[SDAlertView shareAlert] showDialog:weakSelf.respMsg];
                        }
                    }else{
                        //respMsg错误码提示
                        [[SDAlertView shareAlert] showDialog:weakSelf.respMsg];
                    }
                }
            });
            return respCodeErrorType;
        }
    }
    return otherErrorType;
}




@end
