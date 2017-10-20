 //
//  MainViewController.m
//  sandbao
//
//  Created by tianNanYiHao on 2016/10/31.
//  Copyright © 2016年 sand. All rights reserved.
//

#import "MainViewController.h"
#import "Dock.h"
#import "PayNucHelper.h"
#import "NSObject+NSLocalNotification.h"
#import "SqliteHelper.h"
#import "SDSqlite.h"
#import "SDDrowNoticeView.h"
#import "LoginViewController.h"
#import <AVFoundation/AVFoundation.h>

#define kContentFrame CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height - kDockHeight)

#define KDockFrame CGRectMake(0, self.view.frame.size.height - kDockHeight, self.view.frame.size.width, kDockHeight)

@interface MainViewController ()<MqttClientManagerDelegate>
{
    Dock *dock;
    NSInteger currentVCindex;
    
}
// 选中的控制器
@property (nonatomic, strong) UIViewController *selectedViewController;
@property (nonatomic, strong) Dock *mDock;
@property (nonatomic, assign) CGFloat kDockHeight;
@end

@implementation MainViewController

@synthesize kDockHeight;
@synthesize selectedViewController;
@synthesize mDock;

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
    if ([CommParameter sharedInstance].userId == nil) {
        
        //明登陆
        if (_pwdLoginFlag) {
            [self pwdLogin];
        }
        //暗登陆
        else{
            [self noPwdLogin];
            
        }
    }
    

}
#pragma mark - 明登陆

- (void)pwdLogin{
    //如果走明登陆,则数据库状态则全部要为无激活用户状态 (1为不活跃,0位活跃且只有一个活跃用户)
    //跟新数据库,走明登陆则数据库活跃用户全部置为不活跃,
    BOOL result = [SDSqlite updateData:[SqliteHelper shareSqliteHelper].sandBaoDB sql:[NSString stringWithFormat:@"update usersconfig set active = '%@', sToken = '%@' where active = '%@'", @"1", @"", @"0"]];
    
    if (result) {
        LoginViewController *mLoginViewController = [[LoginViewController alloc] init];
                [mLoginViewController setModalTransitionStyle:UIModalTransitionStyleFlipHorizontal];
        UINavigationController *navLogin = [[UINavigationController alloc] initWithRootViewController:mLoginViewController];
        [self presentViewController:navLogin animated:YES completion:nil];
    }
    
//    PayPwdViewController *mLoginViewController = [[PayPwdViewController alloc] init];
//    UINavigationController *navLogin = [[UINavigationController alloc] initWithRootViewController:mLoginViewController];
//    [self presentViewController:navLogin animated:YES completion:nil];
}
#pragma mark - 暗登陆
- (void)noPwdLogin{
    
    NSMutableDictionary *userInfoDic = [SDSqlite selectOneData:[SqliteHelper shareSqliteHelper].sandBaoDB tableName:@"usersconfig" columnArray:USERSCONFIG_ARR whereColumnString:@"active" whereParamString:@"0"];
    
    //2.1 暗登陆 -从数据库获取sTokey
    [CommParameter sharedInstance].sToken = [userInfoDic objectForKey:@"sToken"];
    NSString *creditFp = [userInfoDic objectForKey:@"credit_fp"];
    
    __block BOOL error = NO;
    paynuc.set("sToken", [[CommParameter sharedInstance].sToken UTF8String]);
    paynuc.set("creditFp", [creditFp UTF8String]);
    paynuc.set("tTokenType", "01001401");
    [[SDRequestHelp shareSDRequest] requestWihtFuncName:@"token/getTtoken/v1" errorBlock:^(SDRequestErrorType type) {
        error = YES;
        [[SDRequestHelp shareSDRequest] dispatchToMainQueue:^{
            //2.2 数据库中sToken失效/查询用户tToken获取失败 -> 明登陆
            [self pwdLogin];
        }];
    } successBlock:^{
        
    }];
    if (error) return;
    
    [[SDRequestHelp shareSDRequest] requestWihtFuncName:@"user/queryInfo/v1" errorBlock:^(SDRequestErrorType type) {
        error = YES;
        [[SDRequestHelp shareSDRequest] dispatchToMainQueue:^{
            //2.3 查询用户信息失败/查询用户信息失败  - > 直接明登陆
            [self pwdLogin];
        }];
    } successBlock:^{
        [[SDRequestHelp shareSDRequest] dispatchToMainQueue:^{
            
            //3. 暗登陆成功
            [CommParameter sharedInstance].userInfo = [NSString stringWithUTF8String:paynuc.get("userInfo").c_str()];
            NSDictionary *userInfoDic = [[PayNucHelper sharedInstance] jsonStringToDictionary:[CommParameter sharedInstance].userInfo];
            
            [CommParameter sharedInstance].avatar = [userInfoDic objectForKey:@"avatar"];
            [CommParameter sharedInstance].realNameFlag = [[userInfoDic objectForKey:@"realNameFlag"] boolValue];
            [CommParameter sharedInstance].userRealName = [userInfoDic objectForKey:@"userRealName"];
            [CommParameter sharedInstance].userName = [userInfoDic objectForKey:@"userName"];
            [CommParameter sharedInstance].phoneNo = [userInfoDic objectForKey:@"phoneNo"];
            [CommParameter sharedInstance].userId = [userInfoDic objectForKey:@"userId"];
            [CommParameter sharedInstance].safeQuestionFlag = [[userInfoDic objectForKey:@"safeQuestionFlag"] boolValue];
            [CommParameter sharedInstance].nick = [userInfoDic objectForKey:@"nick"];
            [self updateUserData];
        }];
    }];
    if (error) return;
}

/**
 *@brief 更新用户数据
 */
- (void)updateUserData
{
    //查询minlets数据库最新子件
    NSMutableArray *minletsArray = [SDSqlite selectData:[SqliteHelper shareSqliteHelper].sandBaoDB tableName:@"minlets" columnArray:MINLETS_ARR ];
    //2.更新该用户下lets信息
    //查询此用户对应的lets信息
    NSString *letsStr = [SDSqlite selectStringData:[SqliteHelper shareSqliteHelper].sandBaoDB tableName:@"usersconfig" columnName:@"lets" whereColumnString:@"uid" whereParamString:[CommParameter sharedInstance].userId];
    //如果该用户lets信息在minlets库中不存在则删除之
    NSArray *lensArr = [[PayNucHelper sharedInstance] jsonStringToArray:letsStr];
    NSMutableArray *lensArrM = [NSMutableArray arrayWithCapacity:0];
    //取交集
    for (int i = 0; i<lensArr.count; i++) {
        for (int ii = 0; ii<minletsArray.count; ii++) {
            if ([[lensArr[i] objectForKey:@"letId"] isEqualToString:[minletsArray[ii] objectForKey:@"id"]]) {
                [lensArrM addObject:lensArr[i]];
            }
        }
    }
    //更新该用户lets信息
    NSString *letsStrNew = [[PayNucHelper sharedInstance] arrayToJSON:lensArrM];
    [SDSqlite updateData:[SqliteHelper shareSqliteHelper].sandBaoDB  tableName:@"usersconfig" columnArray:(NSMutableArray*)@[@"lets"] paramArray:(NSMutableArray *)@[letsStrNew] whereColumnString:@"uid" whereParamString:[CommParameter sharedInstance].userId];
    
    //查询用户信息
    [self ownPayTools];
}

/**
 *@brief 查询信息
 */
- (void)ownPayTools
{
    
    [[SDRequestHelp shareSDRequest] dispatchGlobalQuque:^{
        __block BOOL error = NO;
        
        paynuc.set("tTokenType", "01001501");
        [[SDRequestHelp shareSDRequest] requestWihtFuncName:@"token/getTtoken/v1" errorBlock:^(SDRequestErrorType type) {
            error = YES;
            [[SDRequestHelp shareSDRequest] dispatchToMainQueue:^{
                if (type == respCodeErrorType) {
                    [Tool showDialog:@"获取Ttoken失败,请退出" defulBlock:^{
                        [self exitApplication];
                    }];
                }else{
                    [Tool showDialog:@"网络连接超时" defulBlock:^{
                        [self exitApplication];
                    }];
                }
            }];
        } successBlock:^{
            
        }];
        if (error) return;
        
        
        paynuc.set("payToolKinds", "[]");
        [[SDRequestHelp shareSDRequest] requestWihtFuncName:@"payTool/getOwnPayTools/v1" errorBlock:^(SDRequestErrorType type) {
            error = YES;
            [[SDRequestHelp shareSDRequest] dispatchToMainQueue:^{
                if (type == respCodeErrorType) {
                    [Tool showDialog:@"获取支付工具失败,请退出" defulBlock:^{
                        [self exitApplication];
                    }];
                }else{
                    [Tool showDialog:@"网络连接超时" defulBlock:^{
                        [self exitApplication];
                    }];
                }
            }];
        } successBlock:^{
            [[SDRequestHelp shareSDRequest] dispatchToMainQueue:^{

                NSArray *payToolsArray = [[PayNucHelper sharedInstance] jsonStringToArray:[NSString stringWithUTF8String:paynuc.get("payTools").c_str()]];
                //根据order 字段排序
                payToolsArray = [Tool orderForPayTools:payToolsArray];
                [CommParameter sharedInstance].ownPayToolsArray = payToolsArray;
                
            }];
        }];
        if (error) return;
        
    }];
}



#pragma - mark =====ViewDidLoad=====

- (void)viewDidLoad {
    [super viewDidLoad];

}
#pragma - mark 重写父类-baseScrollView设置
- (void)setBaseScrollview{
    [super setBaseScrollview];
    
}
#pragma - mark 重写父类-导航设置方法
- (void)setNavCoverView{
    [super setNavCoverView];
    self.navCoverView.style = NavCoverStyleGradient;
    self.navCoverView.midTitleStr = @"";
    self.navCoverView.letfImgStr = @"index_avatar";
    self.navCoverView.rightImgStr = @"index_msg";
    self.navCoverView.leftBlock = ^{
        
    };
    __block id selfBlock = self;
    self.navCoverView.rightBlock = ^{
        LoginViewController *mLoginViewController = [[LoginViewController alloc] init];
        [mLoginViewController setModalTransitionStyle:UIModalTransitionStyleFlipHorizontal];
        UINavigationController *navLogin = [[UINavigationController alloc] initWithRootViewController:mLoginViewController];
        [selfBlock presentViewController:navLogin animated:YES completion:nil];
    };
    
    
    
    
}
#pragma - mark 重写父类-点击方法集合
- (void)buttonClick:(UIButton *)btn{
    
    
}
- (void)exitApplication {
    //来 加个动画，给用户一个友好的退出界面
    
    [UIView animateWithDuration:0.4 animations:^{
        self.view.window.alpha = 0;
    } completion:^(BOOL finished) {
        exit(0);
    }];
    
}


@end
