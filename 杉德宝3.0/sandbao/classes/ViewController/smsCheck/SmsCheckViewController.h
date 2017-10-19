//
//  SmsCheckViewController.h
//  sandbao
//
//  Created by tianNanYiHao on 2017/10/18.
//  Copyright © 2017年 sand. All rights reserved.
//

#import "BaseViewController.h"

@interface SmsCheckViewController : BaseViewController


/**
 接收一个可供发短信的手机号
 */
@property (nonatomic, strong) NSString *phoneNoStr;


/**
 接受: 调用发送短信的用途类型
 */
@property (nonatomic, assign) NSInteger smsCheckType;

@end
