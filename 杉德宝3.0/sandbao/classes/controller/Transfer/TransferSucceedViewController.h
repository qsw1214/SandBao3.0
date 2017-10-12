//
//  Transfer BeginViewController.h
//  sandbao
//
//  Created by tianNanYiHao on 2017/3/23.
//  Copyright © 2017年 sand. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TransferSucceedViewController : UIViewController


@property (nonatomic,strong) NSString *otherPayInfoName;  //转入方 name
@property (nonatomic,strong) NSString *otherPayDescribeNum;  //转入方 手机号

@property (nonatomic,strong) NSString *moneyStr;   //转账金额

@property (nonatomic,strong) NSString *payDescribeStr; //付款信息



@end
