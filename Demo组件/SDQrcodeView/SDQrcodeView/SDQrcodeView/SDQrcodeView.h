//
//  SDQrcodeView.h
//  SDQrcodeView
//
//  Created by tianNanYiHao on 2017/12/5.
//  Copyright © 2017年 tianNanYiHao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SDQrcodeView : UIView

#pragma mark - 公共属性部分
/**
 标题
 */
@property (nonatomic, strong) NSString *titleStr;

/**
 二维码图片描述
 */
@property (nonatomic, strong) NSString *qrCodeDesStr;

/**
 二维码图片
 */
@property (nonatomic, strong) UIImage  *qrCodeImg;


#pragma mark - 收款码属性(collection)

#pragma mark - 付款码属性(pay)
/**
 付款码 - 支付工具图标名
 */
@property (nonatomic, strong) NSString *payToolIconimgStr;

/**
 付款码 - 支付工具名
 */
@property (nonatomic, strong) NSString *payToolNameStr;


/**
 创建底部支付工具视图
 */
- (void)createPayToolShowView;

@end
