//
//  PaymentCodeCell.m
//  sandbao
//
//  Created by tianNanYiHao on 2017/10/29.
//  Copyright © 2017年 sand. All rights reserved.
//

#import "PaymentCodeCell.h"

/**
 代付凭证校验码
 */
@implementation PaymentCodeCell

+(instancetype)createPaymentCellViewOY:(CGFloat)OY{
    
    PaymentCodeCell *cell = [[PaymentCodeCell alloc] initWithFrame:CGRectMake(0, OY, 0, 0)];
    return cell;
}

- (instancetype)initWithFrame:(CGRect)frame{
    
    if ([super initWithFrame:frame]) {
        self.titleLab.text = @"代付凭证校验码";
        self.textfield.placeholder = @"输入代付凭证校验码";
    }return self;
}

@end
