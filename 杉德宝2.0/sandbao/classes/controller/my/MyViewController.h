//
//  MyViewController.h
//  sandbao
//
//  Created by tianNanYiHao on 2016/10/31.
//  Copyright © 2016年 sand. All rights reserved.
//

#import <UIKit/UIKit.h>

enum {
    CASHBALABNCE = 0, //现金余额 充值
    CASHBALABNCEDRAW, //现金余额 提现
    CONSUMBALANCE,    //消费余额 充值
    SANDCARDACCOUNT,  //杉德卡主账户充值
    SDQRPAY,           //扫码支付
    SPSPay             //sps支付
};

@interface MyViewController : UIViewController


@end
