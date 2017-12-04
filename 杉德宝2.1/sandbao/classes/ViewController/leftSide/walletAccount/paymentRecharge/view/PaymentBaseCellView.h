//
//  PaymentBaseCellView.h
//  sandbao
//
//  Created by tianNanYiHao on 2017/10/29.
//  Copyright © 2017年 sand. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 代付凭证cell父类
 */
@interface PaymentBaseCellView : UIView<UITextFieldDelegate>




/**
 标题名:动态计算宽度
 */
@property (nonatomic, strong) NSString *titleStr;


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
 红色Tip
 */
@property (nonatomic, strong) UILabel *tip;

/**
 代付凭证cell类-工程方法

 @param OY OY点
 @return 实例
 */
+ (instancetype)createPaymentCellViewOY:(CGFloat)OY;




/**
 红色提示动画
 */
- (void)showTip;




@end
