//
//  TnOrderViewController.h
//  sandbao
//
//  Created by tianNanYiHao on 2017/12/7.
//  Copyright © 2017年 sand. All rights reserved.
//

#import "BaseViewController.h"
typedef NS_ENUM(NSInteger,SandTnOrderType){
    //正扫(c扫b)
    SandTnOrderTypeC2B = 0,
    //反扫(b扫c)
    SandTnOrderTypeB2C,
    //sps跳转
    SandTnOrderTypeSps,
};

@interface TnOrderViewController : BaseViewController

/**
 TN
 */
@property (nonatomic, strong) NSString *TN;

/**
 类型 - 正扫/反扫/sps跳转
 */
@property (nonatomic, assign) SandTnOrderType type;


@end
