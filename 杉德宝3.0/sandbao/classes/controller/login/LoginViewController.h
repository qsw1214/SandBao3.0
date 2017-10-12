//
//  LoginViewController.h
//  sandbao
//
//  Created by tianNanYiHao on 2017/1/13.
//  Copyright © 2017年 sand. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LoginViewController : UIViewController

@property (nonatomic, assign) BOOL isStokenOver;


@property (nonatomic, assign)BOOL isOtherAPPSPS;// 是否其他App启动SPA
@property (nonatomic, strong) NSString *otherAPPSPSurl; //启动的url


@end
