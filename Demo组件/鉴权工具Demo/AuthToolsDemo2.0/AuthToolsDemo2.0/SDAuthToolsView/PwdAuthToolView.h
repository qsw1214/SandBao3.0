//
//  PwdAuthToolView.h
//  AuthToolsDemo2.0
//
//  Created by tianNanYiHao on 2017/10/12.
//  Copyright © 2017年 tianNanYiHao. All rights reserved.
//

#import "AuthToolBaseView.h"

typedef NS_ENUM(NSInteger,PwdAuthToolViewType){
    PwdAuthToolLoginPwdType = 0,
    PwdAuthToolSandPayPwdType
};


/**
 输入框内容通过回调
 */
typedef void(^TextSuccessBlock_PwdAuthTool)(NSString *textfieldText);


@interface PwdAuthToolView : AuthToolBaseView

/**
 输入框内容通过回调
 */
@property (nonatomic, copy) TextSuccessBlock_PwdAuthTool successBlock;

/**
 密码框类型 (登陆密码类型,杉德卡支付密码类型)
 */
@property (nonatomic, assign) PwdAuthToolViewType type;


@end
