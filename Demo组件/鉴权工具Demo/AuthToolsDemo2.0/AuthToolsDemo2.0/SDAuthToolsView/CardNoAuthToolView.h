//
//  CardNoAuthToolView.h
//  AuthToolsDemo2.0
//
//  Created by tianNanYiHao on 2017/10/12.
//  Copyright © 2017年 tianNanYiHao. All rights reserved.
//

#import "AuthToolBaseView.h"

/**
 输入框内容通过回调
 */
typedef void(^TextSuccessBlock_CardNoAuthTool)(NSString *textfieldText);

/**
 输入框内容校验不通过回调
 */
typedef void(^TextErrorBlock_CardNoAuthTool)();

@interface CardNoAuthToolView : AuthToolBaseView

/**
 输入框内容通过回调
 */
@property (nonatomic, copy) TextSuccessBlock_CardNoAuthTool successBlock;

/**
 输入框内容校验不通过回调
 */
@property (nonatomic, copy) TextErrorBlock_CardNoAuthTool errorBlock;


@end
