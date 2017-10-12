//
//  RechargeResultViewController.h
//  sandbao
//
//  Created by tianNanYiHao on 2017/3/27.
//  Copyright © 2017年 sand. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RechargeResultViewController : UIViewController

@property (nonatomic, assign) NSInteger viewControllerIndex;
@property (nonatomic, strong) NSDictionary *workDic;


@property (nonatomic, strong) NSDictionary *payToolDic; //支付方支付工具

@end
