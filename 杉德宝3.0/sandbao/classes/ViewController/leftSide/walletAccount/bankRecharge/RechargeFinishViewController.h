//
//  RechargeFinishViewController.h
//  sandbao
//
//  Created by tianNanYiHao on 2017/10/28.
//  Copyright © 2017年 sand. All rights reserved.
//

#import "BaseViewController.h"

@interface RechargeFinishViewController : BaseViewController


/**
 交易金额
 */
@property (nonatomic, strong) NSString *amtMoneyStr;

/**
 付款方名称
 */
@property (nonatomic, strong) NSString *payOutName;

/**
 付款卡号
 */
@property (nonatomic, strong) NSString *payOutNo;




@end
