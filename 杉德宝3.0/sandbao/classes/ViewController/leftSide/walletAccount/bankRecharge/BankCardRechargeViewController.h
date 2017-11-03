//
//  BankCardRechargeViewController.h
//  sandbao
//
//  Created by tianNanYiHao on 2017/10/28.
//  Copyright © 2017年 sand. All rights reserved.
//

#import "BaseViewController.h"

@interface BankCardRechargeViewController : BaseViewController


/**
 被充值支付工具
 */
@property (nonatomic, strong)NSMutableDictionary *beRechargePayToolDic;

/**
 tTokenType
 */
@property (nonatomic, strong) NSString *tTokenType;

@end
