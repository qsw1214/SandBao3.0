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


@protocol SDQrcodeViewDelegate<NSObject>

/**
 付款码首次展示代理

 @param show 是否展示
 @param close 是否关闭 - 点击了我知道了(YES)
 */
- (void)payQrcodeWaringTip:(BOOL)show close:(BOOL)close;

@end



@interface SDQrcodeView : UIView

#pragma mark - 公共属性部分

/**
 代理
 */
@property (nonatomic, weak)id<SDQrcodeViewDelegate>delegate;

/**
 类型
 */
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
 外部调用 - 隐藏放大的条码图片
 */
- (void)hiddenBigQrcodeView;


@end
