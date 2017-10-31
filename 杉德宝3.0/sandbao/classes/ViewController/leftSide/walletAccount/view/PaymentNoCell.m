//
//  PaymentNoCell.m
//  sandbao
//
//  Created by tianNanYiHao on 2017/10/29.
//  Copyright © 2017年 sand. All rights reserved.
//

#import "PaymentNoCell.h"

/**
 代付凭证号
 */
@implementation PaymentNoCell


+(instancetype)createPaymentCellViewOY:(CGFloat)OY{
    
    PaymentNoCell *cell = [[PaymentNoCell alloc] initWithFrame:CGRectMake(0, OY, 0, 0)];
    return cell;
}

- (instancetype)initWithFrame:(CGRect)frame{
    
    if ([super initWithFrame:frame]) {
        
        self.titleStr = @"代付凭证号";
        self.textfield.placeholder = @"请输入代付凭证号";
        
    }return self;
}


@end
