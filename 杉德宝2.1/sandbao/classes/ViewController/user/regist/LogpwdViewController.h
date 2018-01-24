//
//  LogpwdViewController.h
//  sandbao
//
//  Created by tianNanYiHao on 2017/10/19.
//  Copyright © 2017年 sand. All rights reserved.
//

#import "BaseViewController.h"

@interface LogpwdViewController : BaseViewController

/**
 手机号
 */
@property (nonatomic, strong) NSString *phoneNoStr;


/**
 短信码
 */
@property (nonatomic, strong) NSString *smsCodeString;

/**
 邀请码
 */
@property (nonatomic, strong) NSString *inviteCodeString;

@end

