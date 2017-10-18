//
//  SmsCodeViewController.h
//  sandbao
//
//  Created by tianNanYiHao on 2017/10/18.
//  Copyright © 2017年 sand. All rights reserved.
//

#import "BaseViewController.h"

@interface SmsCodeViewController : BaseViewController


/**
 接收一个可供发短信的手机号
 */
@property (nonatomic, strong) NSString *phoneNoStr;

@property (nonatomic, assign) NSInteger smsCodeType;

@end
