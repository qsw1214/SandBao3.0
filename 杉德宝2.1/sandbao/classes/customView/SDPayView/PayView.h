//
//  PayView.h
//  sandbao
//
//  Created by tianNanYiHao on 2017/2/23.
//  Copyright © 2017年 sand. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum {
    PayViewStyleDefault = 0,
    PayViewStylePaypass,        //支付(paypass)密码控件模式
    PayViewStyleAccpass,        //卡账户(Accpass)密码控件模式
    PayViewStylePayList,        //支付工具列表模式
    PayViewStylePayDetails      //付款详情控件模式(暂未使用)
} PayViewStyle;

/*
 规定:
 
 100开头:PayViewStylePaypass模式下:btn的tag开头
 200开头:PayViewStyleAccpass模式下:btn的tag开头
 300开头:PayViewStylePayList模式下:btn的tag开头
 400开头:PayViewStylePayDetails模式下:btn的tag开头
 ...
 */
typedef enum : NSUInteger {
    TAG_BTN_CLOSED        = 999999,    //关闭Btn.tag
    PAYPASS_BTN_FORGETPWD = 10000001,  //payPass模式忘记密码Btn.tag
    ACCPASS_BTN_FORGETPWD = 20000001,  //accPass模式忘记密码Btn.tag
    PAYLIST_BTN_CELLCLICK = 30000101,  //payList模式点击cell.tag
    PAYLIST_BTN_ADDCARD   = 30000200,  //paylist模式添加新卡Btn.tag
    PAYDETAIL_BTN_HELP    = 40000001,  //payList模式帮助Btn.tag
    PAYDETAIL_BTN_PAYMODE = 40000002,  //payDetail模式支付方式Btn.tag
    PAYDETAIL_BTN_PAY     = 40000003   //payDetail模式支付Btn.tag
} PayViewBtnTag;


@protocol PayViewDelegate <NSObject>

/**
 *@brief  支付密码
 *@param param NSString 参数：支付密码
 *
 */
- (void)payPwd:(NSString *)param;

/**
 *@brief  按钮点击索引
 *@param param NSInteger 参数：索引  10000001:付款方式按钮   10000002:付款按钮   10000101:关闭按钮   10000102:？帮助按钮   20000101:关闭按钮   20000102:返回按钮   30000001:忘记密码按钮   30000101:关闭按钮   30000102:返回按钮
 *
 */
- (void)btnAction:(PayViewBtnTag)param;

/**
 *@brief   默认支付
 *@param param NSDictionary 参数： 默认支付字典
 *
 */
- (void)defaultPay:(NSDictionary *)param;

@end


@interface PayView : UIView

/**
 代理
 */
@property (nonatomic, strong) id<PayViewDelegate> delegate;


/**
 PayViewStylePayList(支付工具控件标题)
 */
@property (nonatomic, strong) NSString *payListTitle;




/**
 初始化对象

 @return 实例
 */
+ (instancetype)getPayView;


/**
 显示控件（支付密码）
 *
 */
- (void)showPaypassPwdView;


/**
 显示控件 (账户密码)
 */
- (void)showAccpassPwdView;

/**
 *@brief  支付列表
 *@param param NSString 参数：默认支付
 *@param payArray NSMutableArray 参数：支付列表
 *
 */
- (void)showRechargeModeView:(NSDictionary *)payModeDic paramArray:(NSMutableArray *)paramArray ;

/**
 *@brief  付款详情
 *@param orderDic NSDictionary 参数：订单信息
 *@param paramDic NSDictionary 参数：默认支付方式
 *
 */
- (void)showPayDetailsView:(NSDictionary *)orderDic paramDic:(NSDictionary *)paramDic;




@end
