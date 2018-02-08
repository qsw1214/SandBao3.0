//
//  BankCardTransferViewController.h
//  sandbao
//
//  Created by tianNanYiHao on 2017/10/30.
//  Copyright © 2017年 sand. All rights reserved.
//

#import "BaseViewController.h"

@interface BankCardTransferViewController : BaseViewController

/**
 被转出支付工具
 */
@property (nonatomic, strong)NSMutableDictionary *transferOutPayToolDic;


/**
 tTokenType
 */
@property (nonatomic, strong) NSString *tTokenType;

@end
