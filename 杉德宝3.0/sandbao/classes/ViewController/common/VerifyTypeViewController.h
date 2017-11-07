//
//  VerifyTypeViewController.h
//  sandbao
//
//  Created by tianNanYiHao on 2017/11/6.
//  Copyright © 2017年 sand. All rights reserved.
//

#import "BaseViewController.h"

@interface VerifyTypeViewController : BaseViewController


/**
 类型
 */
@property (nonatomic, strong) NSString *tokenType;

/**
 使用鉴权工具集组的类型(修改支付/登陆 密码等)
 */
@property (nonatomic, assign) NSInteger verifyType;


@end
