//
//  PaymentMoneyCell.m
//  sandbao
//
//  Created by tianNanYiHao on 2017/10/29.
//  Copyright © 2017年 sand. All rights reserved.
//

#import "PaymentMoneyCell.h"

/**
 代付充值金额
 */
@implementation PaymentMoneyCell

+(instancetype)createPaymentCellViewOY:(CGFloat)OY{
    
    PaymentMoneyCell *cell = [[PaymentMoneyCell alloc] initWithFrame:CGRectMake(0, OY, 0, 0)];
    return cell;
}

- (instancetype)initWithFrame:(CGRect)frame{
    
    if ([super initWithFrame:frame]) {
        self.titleLab.text = @"充值金额";
        self.textfield.placeholder = @"输入充值金额";
        
        self.line.hidden = YES;
        
    }return self;
}

@end
