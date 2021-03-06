//
//  AddBankCardSecViewController.h
//  sandbao
//
//  Created by tianNanYiHao on 2017/11/6.
//  Copyright © 2017年 sand. All rights reserved.
//

#import "BaseViewController.h"

@interface AddBankCardSecViewController : BaseViewController

@property (nonatomic, strong) NSDictionary *payToolDic;   //支付工具字典

@property (nonatomic, strong) NSDictionary *userInfoDic;  //用户信息字典

@property (nonatomic, strong) NSDictionary *accountDic;   //支付工具域下账户域字典

@property (nonatomic, strong) NSString *bankCardNo;       //需要用到的银行卡号
@end
