 //
//  MainViewController.m
//  sandbao
//
//  Created by tianNanYiHao on 2016/10/31.
//  Copyright © 2016年 sand. All rights reserved.
//

#import "MainViewController.h"
#import "PayNucHelper.h"
#import "Dock.h"
#import "NSObject+NSLocalNotification.h"
#import "SqliteHelper.h"
#import "SDSqlite.h"
#import "SDDrowNoticeView.h"
#import "LoginViewController.h"
#import "RealNameViewController.h"
#import "RealNameViewController.h"

#import "GradualView.h"

@interface MainViewController ()<MqttClientManagerDelegate>
{
    //headView
    GradualView *headView;
    
}
@end

@implementation MainViewController
- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
//    if ([CommParameter sharedInstance].userId == nil) {
//        
//        //明登陆
//        if (_pwdLoginFlag) {
//            [self pwdLogin];
//        }
//        //暗登陆
//        else{
//            [self noPwdLogin];
//            
//        }
//    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self create_HeadView];
    
    
}
#pragma mark - 重写父类-baseScrollView设置
- (void)setBaseScrollview{
    [super setBaseScrollview];
    
}
#pragma mark - 重写父类-导航设置方法
- (void)setNavCoverView{
    [super setNavCoverView];
    self.navCoverView.style = NavCoverStyleGradient;
    self.navCoverView.midTitleStr = @"首页";
    self.navCoverView.letfImgStr = @"index_avatar";
    self.navCoverView.rightImgStr = @"index_msg";
    __block MainViewController *selfBlock = self;
    self.navCoverView.leftBlock = ^{
        
        [selfBlock presentLeftMenuViewController:selfBlock.sideMenuViewController];
    };
    self.navCoverView.rightBlock = ^{
        
    };
    
    
    
    
}
#pragma mark - 重写父类-点击方法集合
- (void)buttonClick:(UIButton *)btn{
    
    if (btn.tag == BTN_TAG_INOUTPAY) {
        NSLog(@"点击了  收付款");
    }
    if (btn.tag == BTN_TAG_BLANCE) {
        NSLog(@"点击了  余额(万元)");
    }
    if (btn.tag == BTN_TAG_CARDBAG) {
        NSLog(@"点击了  卡券包");
    }
    
}

#pragma mark  - UI绘制
//创建头部
- (void)create_HeadView{
    
    //headView
    headView = [[GradualView alloc] init];
    [headView setRect:CGRectMake(LEFTRIGHTSPACE_00, UPDOWNSPACE_0, SCREEN_WIDTH, UPDOWNSPACE_122)];
    [self.baseScrollView addSubview:headView];
    
    [headView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.baseScrollView.mas_top);
        make.left.equalTo(self.baseScrollView.mas_left);
        make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH, UPDOWNSPACE_122));
    }];
    
    
    //payBtn
    UIButton *payBtn = [Tool createButton:nil attributeStr:nil font:nil textColor:nil];
    payBtn.tag = BTN_TAG_INOUTPAY;
    [self.baseScrollView addSubview:payBtn];
    
    UIImage *paybtnImg = [UIImage imageNamed:@"index_function_01"];
    UIImageView *payBtnImgeView = [Tool createImagView:paybtnImg];
    [payBtn addSubview:payBtnImgeView];
    
    UILabel *payBtnBottomlab = [Tool createLable:@"收付款" attributeStr:nil font:FONT_14_Regular textColor:COLOR_FFFFFF alignment:NSTextAlignmentCenter];
    [payBtn addSubview:payBtnBottomlab];
    
    payBtn.width = payBtnBottomlab.width;
    payBtn.height = payBtnBottomlab.height + paybtnImg.size.height + UPDOWNSPACE_10;
    
    [payBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(headView.mas_top).offset(UPDOWNSPACE_30);
        make.left.equalTo(headView.mas_left).offset(LEFTRIGHTSPACE_40);
        make.size.mas_equalTo(CGSizeMake(payBtn.width, payBtn.height));
    }];
    
    [payBtnImgeView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(payBtn.mas_top);
        make.centerX.equalTo(payBtn.mas_centerX);
        make.size.mas_equalTo(payBtnImgeView.size);
    }];
    
    [payBtnBottomlab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(payBtnImgeView.mas_bottom).offset(UPDOWNSPACE_10);
        make.centerX.equalTo(payBtn.mas_centerX);
        make.size.mas_equalTo(payBtnBottomlab.size);
    }];
    
    
    //moneyBtn
    UIButton *moneyBtn = [Tool createButton:nil attributeStr:nil font:nil textColor:nil];
    moneyBtn.tag = BTN_TAG_BLANCE;
    [self.baseScrollView addSubview:moneyBtn];
    
    UILabel *moneyBtnLeftLab = [Tool createLable:@"¥" attributeStr:nil font:FONT_10_DINAlter textColor:COLOR_FFFFFF alignment:NSTextAlignmentCenter];
    [moneyBtn addSubview:moneyBtnLeftLab];
    
    UILabel *moneyBtnMidLab = [Tool createLable:@"9999" attributeStr:nil font:FONT_36_DINAlter textColor:COLOR_FFFFFF alignment:NSTextAlignmentCenter];
    [moneyBtn addSubview:moneyBtnMidLab];
    
    UILabel *moneyBtnRightLab = [Tool createLable:@".00" attributeStr:nil font:FONT_10_DINAlter textColor:COLOR_FFFFFF alignment:NSTextAlignmentCenter];
    [moneyBtn addSubview:moneyBtnRightLab];
    
    UILabel *moneyBtnBottomLab = [Tool createLable:@"余额(万元)" attributeStr:nil font:FONT_10_DINAlter textColor:COLOR_FFFFFF alignment:NSTextAlignmentCenter];
    [moneyBtn addSubview:moneyBtnBottomLab];
    CGFloat upLabWidth = (moneyBtnLeftLab.width + moneyBtnMidLab.width + moneyBtnRightLab.width);
    CGFloat bottomLabWidth = moneyBtnBottomLab.width;
    moneyBtn.width = upLabWidth>bottomLabWidth?upLabWidth:bottomLabWidth;
    moneyBtn.height = moneyBtnMidLab.height + moneyBtnBottomLab.height + UPDOWNSPACE_10;
    
    
    [moneyBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(headView.mas_top).offset(UPDOWNSPACE_30);
        make.centerX.equalTo(headView.mas_centerX);
        make.size.mas_equalTo(CGSizeMake(moneyBtn.width, moneyBtn.height));
    }];
    
    [moneyBtnLeftLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(moneyBtn.mas_top).offset(UPDOWNSPACE_05);
        make.left.equalTo(moneyBtn.mas_left);
        make.size.mas_equalTo(moneyBtnLeftLab.size);
    }];
    
    [moneyBtnMidLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(moneyBtn.mas_top);
        make.left.equalTo(moneyBtnLeftLab.mas_right);
        make.size.mas_equalTo(moneyBtnMidLab.size);
    }];
    
    [moneyBtnRightLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(moneyBtn.mas_top).offset(UPDOWNSPACE_05);
        make.left.equalTo(moneyBtnMidLab.mas_right);
        make.size.mas_equalTo(moneyBtnRightLab.size);
    }];
    
    [moneyBtnBottomLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(moneyBtn.mas_bottom).offset(UPDOWNSPACE_0);
        make.centerX.equalTo(moneyBtn.mas_centerX);
        make.size.mas_equalTo(moneyBtnBottomLab.size);
    }];
    
    
    //cardBag
    UIButton *cardBagBtn = [Tool createButton:nil attributeStr:nil font:nil textColor:nil];
    cardBagBtn.tag = BTN_TAG_CARDBAG;
    [self.baseScrollView addSubview:cardBagBtn];
    
    UIImage *cardBagImg = [UIImage imageNamed:@"index_function_03"];
    UIImageView *cardBagImgeView = [Tool createImagView:cardBagImg];
    cardBagImgeView.image = cardBagImg;
    [cardBagBtn addSubview:cardBagImgeView];
    
    UILabel *cardBagBottomlab = [Tool createLable:@"卡券包" attributeStr:nil font:FONT_14_Regular textColor:COLOR_FFFFFF alignment:NSTextAlignmentCenter];
    [cardBagBtn addSubview:cardBagBottomlab];
    
    cardBagBtn.width = cardBagBottomlab.width;
    cardBagBtn.height = cardBagBottomlab.height + cardBagImg.size.height + UPDOWNSPACE_10;
    
    [cardBagBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(headView.mas_top).offset(UPDOWNSPACE_30);
        make.right.equalTo(headView.mas_right).offset(-LEFTRIGHTSPACE_40);
        make.size.mas_equalTo(CGSizeMake(cardBagBtn.width, cardBagBtn.height));
    }];
    
    [cardBagImgeView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(cardBagBtn.mas_top);
        make.centerX.equalTo(cardBagBtn.mas_centerX);
        make.size.mas_equalTo(cardBagImgeView.size);
    }];
    
    [cardBagBottomlab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(cardBagImgeView.mas_bottom).offset(UPDOWNSPACE_10);
        make.centerX.equalTo(cardBagBtn.mas_centerX);
        make.size.mas_equalTo(cardBagBottomlab.size);
    }];
    
}



#pragma mark - 业务逻辑
#pragma mark 明登陆

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
}
#pragma mark 暗登陆
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



- (void)exitApplication {
    //来 加个动画，给用户一个友好的退出界面
    
    [UIView animateWithDuration:0.4 animations:^{
        self.view.window.alpha = 0;
    } completion:^(BOOL finished) {
        exit(0);
    }];
    
}


@end
