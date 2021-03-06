//
//  SDQrcodeView.h
//  SDQrcodeView
//
//  Created by tianNanYiHao on 2017/12/5.
//  Copyright © 2017年 tianNanYiHao. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger,SDQrcodeViewStyle)
{
    //付款码
    PayQrcodeView = 1,
    //收款码
    CollectionQrcordView,
    
};

@interface SDQrcodeView : UIView

#pragma mark - 公共属性部分

@property (nonatomic, assign) SDQrcodeViewStyle style;

/**
 条形码信息
 */
@property (nonatomic, strong) NSString  *oneQrCodeStr;

/**
 二维码信息
 */
@property (nonatomic, strong) NSString  *twoQrCodeStr;

/**
 左右小圆点颜色 = 背景色
 */
@property (nonatomic, strong) UIColor *roundRLColor;

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
 公共 - 创建底部空白视图
 */
- (void)createBottomEmptyView;

/**
 付款码 - 创建底部支付工具视图
 */
- (void)createPayToolShowView;

/**
 收款码 - 创建设置金额视图
 */
- (void)createSetMoneyBtnView;


@end
