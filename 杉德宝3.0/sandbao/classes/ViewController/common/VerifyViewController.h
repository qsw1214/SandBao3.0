//
//  VerifyViewController.h
//  sandbao
//
//  Created by tianNanYiHao on 2017/11/7.
//  Copyright © 2017年 sand. All rights reserved.
//

#import "BaseViewController.h"

@interface VerifyViewController : BaseViewController


/**
 短信视图(接受短信视图实例,执行短信验证成功后,短信倒计时停止,不负责在此类展示)
 */
@property (nonatomic, strong) SixCodeAuthToolView *smsCodeAuthToolView;


/**
 使用鉴权类型(修改支付/登陆密码)
 */
@property (nonatomic, assign) NSInteger verifyType;


/**
 鉴权工具(已组装好sms,带组装剩余鉴权)
 */
@property (nonatomic, strong) NSArray *authToolArr;

@end
