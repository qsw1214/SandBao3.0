//
//  InviteAuthToolView.h
//  sandbao
//
//  Created by tianNanYiHao on 2018/1/24.
//  Copyright © 2018年 sand. All rights reserved.
//

#import "AuthToolBaseView.h"

/**
 输入框内容通过回调
 */
typedef void(^TextSuccessBlock_PhoneAuthTool)(NSString *textfieldText);

@interface InviteAuthToolView : AuthToolBaseView



/**
 输入框内容通过回调
 */
@property (nonatomic, copy) TextSuccessBlock_PhoneAuthTool successBlock;



@end
