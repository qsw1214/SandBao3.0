//
//  PaymentBaseCellView.h
//  sandbao
//
//  Created by tianNanYiHao on 2017/10/29.
//  Copyright © 2017年 sand. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PaymentBaseCellView : UIView<UITextFieldDelegate>



/**
 标题Lab
 */
@property (nonatomic, strong) UILabel *titleLab;


/**
 信息输入框
 */
@property (nonatomic, strong) UITextField *textfield;


/**
 line
 */
@property (nonatomic, strong) UIView *line;


/**
 左右间距
 */
@property (nonatomic, assign) CGFloat leftRightSpace;

/**
 常用间距(上下)
 */
@property (nonatomic, assign) CGFloat space;


/**
 代付凭证cell类-工程方法

 @param OY OY点
 @return 实例
 */
+ (instancetype)createPaymentCellViewOY:(CGFloat)OY;




@end
