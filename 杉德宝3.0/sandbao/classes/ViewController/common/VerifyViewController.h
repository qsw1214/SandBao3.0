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
 使用鉴权类型(修改支付/登陆密码)
 */
@property (nonatomic, assign) NSInteger verifyType;


/**
 鉴权工具(已组装好sms,带组装剩余鉴权)
 */
@property (nonatomic, strong) NSArray *authToolArr;

@end
