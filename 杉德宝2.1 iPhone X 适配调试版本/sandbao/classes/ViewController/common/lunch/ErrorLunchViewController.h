//
//  ErrorLunchViewController.h
//  sandbao
//
//  Created by tianNanYiHao on 2017/10/12.
//  Copyright © 2017年 sand. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"
@interface ErrorLunchViewController : BaseViewController

@property (nonatomic, strong) NSString *errorInfo;


/**
 不同error处理类型
 0:系统网络权限受限
 1://paynuc.func()网络失败:两步认证失败等
 */
@property (nonatomic, assign) NSInteger errorType;

@end
