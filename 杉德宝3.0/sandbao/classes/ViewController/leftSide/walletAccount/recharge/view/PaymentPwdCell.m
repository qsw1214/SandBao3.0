//
//  PaymentPwdCell.m
//  sandbao
//
//  Created by tianNanYiHao on 2017/10/29.
//  Copyright © 2017年 sand. All rights reserved.
//

#import "PaymentPwdCell.h"

/**
 代付凭证密码
 */
@implementation PaymentPwdCell

+(instancetype)createPaymentCellViewOY:(CGFloat)OY{
    
    PaymentPwdCell *cell = [[PaymentPwdCell alloc] initWithFrame:CGRectMake(0, OY, 0, 0)];
    return cell;
}

- (instancetype)initWithFrame:(CGRect)frame{
    
    if ([super initWithFrame:frame]) {
        self.titleStr = @"代付凭证密码";
        self.textfield.placeholder = @"输入代付凭证密码";
    }return self;
}
@end
