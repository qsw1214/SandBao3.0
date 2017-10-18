//
//  MainViewController.h
//  sandbao
//
//  Created by tianNanYiHao on 2016/10/31.
//  Copyright © 2016年 sand. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"
@interface MainViewController : BaseViewController<UINavigationControllerDelegate>



/**
 明暗登录标识
 */
@property (nonatomic, assign) BOOL pwdLoginFlag;

@end
