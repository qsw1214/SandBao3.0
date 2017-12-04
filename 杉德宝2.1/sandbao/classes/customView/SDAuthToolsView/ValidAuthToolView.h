//
//  ValidAuthToolView.h
//  AuthToolsDemo2.0
//
//  Created by tianNanYiHao on 2017/11/8.
//  Copyright © 2017年 tianNanYiHao. All rights reserved.
//

#import "AuthToolBaseView.h"
/**
 输入框内容通过回调
 */
typedef void(^TextSuccessBlock_PhoneAuthTool)(NSString *textfieldText);

@interface ValidAuthToolView : AuthToolBaseView




/**
 输入框内容通过回调
 */
@property (nonatomic, copy) TextSuccessBlock_PhoneAuthTool successBlock;


@end
