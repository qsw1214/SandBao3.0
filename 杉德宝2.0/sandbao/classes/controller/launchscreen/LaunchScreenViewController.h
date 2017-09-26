//
//  LaunchScreenViewController.h
//  sandbao
//
//  Created by tianNanYiHao on 2016/10/31.
//  Copyright © 2016年 sand. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LaunchScreenViewController : UIViewController

@property (nonatomic, assign)BOOL isOtherAPPSPS;// 是否其他App启动SPA
@property (nonatomic, strong) NSString *otherAPPSPSurl; //启动的url

@end
