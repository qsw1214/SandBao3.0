//
//  PaymentRechargeViewController.h
//  sandbao
//
//  Created by tianNanYiHao on 2017/11/1.
//  Copyright © 2017年 sand. All rights reserved.
//

#import "BaseViewController.h"

@interface PaymentRechargeViewController : BaseViewController

/**
 被充值支付工具
 */
@property (nonatomic, strong)NSMutableDictionary *rechargeInPayToolDic;


/**
 tTokenType
 */
@property (nonatomic, strong) NSString *tTokenType;


@end
