//
//  CommParameter.h
//  sandbao
//
//  Created by tianNanYiHao on 2016/11/28.
//  Copyright © 2016年 sand. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <RESideMenu.h>

@interface CommParameter : NSObject



#pragma mark - *********用户退出后不进行置空*********
#pragma mark - HomeNav
@property (nonatomic, strong) UINavigationController *myCenterNav;    //全局的 个人中心
@property (nonatomic, strong) UINavigationController *homeNav;        //全局的 首页
@property (nonatomic, strong) UINavigationController *myBillNav;      //全局的 我的账单
@property (nonatomic, strong) UINavigationController *walletAccNav;   //全局的 钱包
@property (nonatomic, strong) UINavigationController *sandPointNav;   //全局的 杉德积分
@property (nonatomic, strong) UINavigationController *financicleNav;  //全局的 理财中心
@property (nonatomic, strong) UINavigationController *bankCardNav;    //全局的 银行卡
@property (nonatomic, strong) UINavigationController *sandCardNav;    //全局的 卡券包
@property (nonatomic, strong) UINavigationController *setNav;         //全局的 设置

#pragma mark - RESideMenu(current)
@property (nonatomic, strong) RESideMenu *currentResideMenu;  //全局存储的当前主内容控制器









#pragma mark - *********用户退出后置空*********
#pragma mark - mqttFlag
@property (nonatomic, assign) BOOL mqttFlag;      //mqtt存在标识

#pragma mark - sToken
@property (nonatomic, strong) NSString *sToken;   //用户活动状态标识

#pragma mark - URL Schemes
@property (nonatomic, strong) NSString *urlSchemes; //第三方App低调杉德宝支付的URL Schemes

#pragma mark - userInfo域
@property (nonatomic, strong) NSString *userInfo; //用户信息json串
@property (nonatomic, strong) NSString *userName; //用户名
@property (nonatomic, strong) NSString *userRealName; //用户实名
@property (nonatomic, strong) NSString *phoneNo; //手机号
@property (nonatomic, strong) NSString *userId;  //用户id
@property (nonatomic, strong) NSString *nick; //昵称
@property (nonatomic, strong) NSString *avatar; //头像
@property (nonatomic, assign) BOOL realNameFlag; //实名认证flag
@property (nonatomic, assign) BOOL payPassFlag;  //是否设置支付密码flag
@property (nonatomic, assign) BOOL payForAnotherFlag; //代付凭证是否激活标志
@property (nonatomic, assign) BOOL safeQuestionFlag; //开通快捷flag

#pragma mark - ownPayTools
@property (nonatomic, strong) NSArray *ownPayToolsArray; //我方支付工具组



//@property (nonatomic, strong) NSString *mid;
//@property (nonatomic, strong) NSString *token;
//@property (nonatomic, strong) NSString *uuid;
//@property (nonatomic, strong) NSString *deviceVersion;
//@property (nonatomic, strong) NSString *phoneSystemVersion;
//@property (nonatomic, strong) NSString *appVersion;
//@property (nonatomic, assign) int selectIndex;


//实例构造检查静态实例是否为nil
+ (CommParameter *) sharedInstance;


/**
 打印查看当前信息
 */
- (void)showCommParameter;

/**
 清除数据
 */
-(void)cleanCommParameter;


@end
