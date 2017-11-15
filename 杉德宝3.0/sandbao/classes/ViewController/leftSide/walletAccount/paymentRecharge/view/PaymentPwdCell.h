//
//  PaymentPwdCell.h
//  sandbao
//
//  Created by tianNanYiHao on 2017/10/29.
//  Copyright © 2017年 sand. All rights reserved.
//

#import "PaymentBaseCellView.h"

/**
 输入框内容通过回调
 */
typedef void(^TextSuccessBlock_CardNoAuthTool)(NSString *textfieldText);

@interface PaymentPwdCell : PaymentBaseCellView


/**
 输入框内容通过回调
 */
@property (nonatomic, copy) TextSuccessBlock_CardNoAuthTool successBlock;



@end
