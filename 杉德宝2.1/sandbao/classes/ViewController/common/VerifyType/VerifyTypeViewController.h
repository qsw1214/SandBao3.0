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
 从首页进入设置支付密码
 */
@property (nonatomic, assign) BOOL setPayPassFromeHomeNav;


/**
 需要返回按钮
 */
@property (nonatomic, assign) BOOL needGoBackIcon;


/**
 类型
 */
@property (nonatomic, strong) NSString *tokenType;

/**
 使用鉴权工具集组的类型(修改支付/登陆 密码等)
 */
@property (nonatomic, assign) NSInteger verifyType;


/**
 发送的手机好
 */
@property (nonatomic, strong) NSString *phoneNoStr;


@end
