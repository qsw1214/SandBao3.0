//
//  Transfer BeginViewController.h
//  sandbao
//
//  Created by tianNanYiHao on 2017/3/23.
//  Copyright © 2017年 sand. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TransferPayViewController : UIViewController

@property (nonatomic,strong) NSDictionary *userInfoDic; //被转账用户信息
//@property (nonatomic,strong) NSArray *inpayToolsArr; //可用转入*用户支付工具集
//@property (nonatomic,strong) NSArray *outpayToolsArr; //可用转出*用户支付工具集
//
//@property (nonatomic,assign) NSInteger indext;


@property (nonatomic,strong) NSMutableDictionary *inPayToolDic;
@property (nonatomic,strong) NSMutableDictionary *outPayToolDic;


@end
