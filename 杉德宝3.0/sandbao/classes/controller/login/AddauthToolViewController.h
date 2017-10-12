//
//  AddauthViewController.h
//  sandbao
//
//  Created by tianNanYiHao on 2017/4/17.
//  Copyright © 2017年 sand. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AddauthToolViewController : UIViewController

@property (nonatomic,strong) NSMutableArray *addauthToolsArray; //加强鉴权
@property (nonatomic,strong) NSString *userInfo;
@property (nonatomic,strong) NSMutableArray *authToolsArray1;

@property (nonatomic,strong) NSString *phoneNumberStr;
@property (nonatomic,assign) BOOL isStokenOver;


@property (nonatomic, assign)BOOL isOtherAPPSPS;// 是否其他App启动SPA
@property (nonatomic, strong) NSString *otherAPPSPSurl; //启动的url

@end
