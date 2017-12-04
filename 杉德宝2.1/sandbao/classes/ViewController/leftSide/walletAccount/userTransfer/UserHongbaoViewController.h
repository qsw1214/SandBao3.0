//
//  UserHongbaoViewController.h
//  sandbao
//
//  Created by tianNanYiHao on 2017/11/1.
//  Copyright © 2017年 sand. All rights reserved.
//

#import "BaseViewController.h"

@interface UserHongbaoViewController : BaseViewController


/**
 转账对象:用户信息
 */
@property (nonatomic, strong) NSDictionary *userInfoDic;

/**
 转入支付工具:otherPayTools:1005
 */
@property (nonatomic, strong) NSDictionary *inPayToolDic;

/**
 转出支付工具:ownPayTools:1005
 */
@property (nonatomic, strong) NSDictionary *outPayToolDic;


@end
