//
//  BindingBankSecondViewController.h
//  sandbao
//
//  Created by tianNanYiHao on 2017/2/13.
//  Copyright © 2017年 sand. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BindingBankSecondViewController : UIViewController

@property (nonatomic, strong) NSMutableDictionary *passDic;

@property (nonatomic, strong) NSString *userRealName; //姓名
@property (nonatomic, strong) NSString *identityNo;   //身份证
@property (nonatomic, strong) NSString *phoneNo;     //验证手机号
@property (nonatomic, assign) BOOL fastPayFlag; //是否可以开通快捷标志




@end
