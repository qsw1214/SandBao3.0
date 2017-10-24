//
//  NameAuthToolView.h
//  AuthToolsDemo2.0
//
//  Created by tianNanYiHao on 2017/10/12.
//  Copyright © 2017年 tianNanYiHao. All rights reserved.
//

#import "AuthToolBaseView.h"

/**
 输入框内容通过回调
 */
typedef void(^TextSuccessBlock_NameAuthTool)(NSString *textfieldText);

/**
 输入框内容校验不通过回调
 */
typedef void(^TextErrorBlock_NameAuthTool)();

@interface NameAuthToolView : AuthToolBaseView

/**
 输入框内容通过回调
 */
@property (nonatomic, copy) TextSuccessBlock_NameAuthTool successBlock;

/**
 输入框内容校验不通过回调
 */
@property (nonatomic, copy) TextErrorBlock_NameAuthTool errorBlock;


@end
