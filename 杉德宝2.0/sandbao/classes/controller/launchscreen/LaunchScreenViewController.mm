//
//  LaunchScreenViewController.m
//  sandbao
//
//  Created by tianNanYiHao on 2016/10/31.
//  Copyright © 2016年 sand. All rights reserved.
//

#import "LaunchScreenViewController.h"
#import "MainViewController.h"
#import "LoginViewController.h"
#import "SqliteHelper.h"
#import "Majlet_Func.h"
#import "SDSqlite.h"
#import "CommParameter.h"
#import "SDWaveViwe.h"
#import "PayNucHelper.h"
#import "SDLog.h"
#import "SDNetwork.h"
#import "AppDelegate.h"
#import "SpsPayViewController.h"
@interface LaunchScreenViewController ()
{
    
}

@property (nonatomic, assign) CGSize viewSize;

@property (nonatomic, strong) SDWaveViwe *waveView;

@property (nonatomic, strong) SDMBProgressView *HUD;


@end



@implementation LaunchScreenViewController

@synthesize viewSize;
@synthesize waveView;



@synthesize HUD;




- (void)viewDidLoad {
    [super viewDidLoad];
    viewSize = self.view.bounds.size;
    
    
    
    
    //修改状态栏白色
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:NO];
    
    
    
    
    UIImage *headImage = [UIImage fullscreenAllIphoneImageWithName:@"loading.png"];
    UIImageView *headImageView = [[UIImageView alloc] init];
    headImageView.contentMode = UIViewContentModeScaleAspectFit;
    headImageView.image = headImage;
    [self.view addSubview:headImageView];
    [headImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.view);
    }];
    
    //显示Build版本lab
    UILabel *versionLab = [[UILabel alloc] init];
    NSString *strVersion = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"] ;
    versionLab.text = [NSString stringWithFormat:@"Build版本号: %@",strVersion];
    versionLab.textAlignment = NSTextAlignmentCenter;
    CGSize versionLabsize = CGSizeMake(viewSize.width - 2*15, 15);
    versionLab.textColor = [UIColor whiteColor];
    [self.view addSubview:versionLab];
    [versionLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(headImageView.mas_bottom).offset(-20);
        make.centerX.equalTo(headImageView.mas_centerX).offset(0);
        make.size.mas_equalTo(versionLabsize);
    }];
    
    //显示version版本
    UILabel *versionLab1 = [[UILabel alloc] init];
    NSString *strVersion1 = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"] ;
    //    CFBundleShortVersionString
    //    CFBundleVersion
    versionLab1.text = [NSString stringWithFormat:@"@Version版本号: %@",strVersion1];
    versionLab1.textAlignment = NSTextAlignmentCenter;
    versionLab1.font = [UIFont systemFontOfSize:11];
    CGSize versionLabsize1 = CGSizeMake(viewSize.width - 2*15, 15);
    versionLab1.textColor = [UIColor lightGrayColor];
    [self.view addSubview:versionLab1];
    [versionLab1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(headImageView.mas_bottom).offset(-40);
        make.centerX.equalTo(headImageView.mas_centerX).offset(0);
        make.size.mas_equalTo(versionLabsize1);
    }]; 

    
    //添加水波纹
    [self addWaveView];
    
    [self loadData];
}


/**
 添加水波浪
 */
- (void)addWaveView{
    waveView = [[SDWaveViwe alloc] initWithFrame:self.view.bounds];
    //初始速度
    waveView.waveSpeed = 1.f;
    //初始振幅
    waveView.waveA = 3;
    [self.view addSubview:waveView];
}


/**
 *@brief   加载数据
 *@param view UIView 参数：组件
 *@return
 */
- (void)loadData
{

    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        BOOL result = [[Majlet_Func shareMajlet_Func] load];
        
        
        if (!result) {
            dispatch_async(dispatch_get_main_queue(), ^{
                SDNetwork *sdnet = [[SDNetwork alloc] init];
                if ([@"" isEqualToString:[sdnet stringWithNetworkType]]) {
                    [Tool showDialog:@"无网络连接" defulBlock:^{
                        [self exitApplication];
                    }];
                }else{
                    [Tool showDialog:@"网络异常" defulBlock:^{
                        [self exitApplication];
                    }];
                }
            });
            return ;
        }
        
        // 设置子件数据以及版本信息
        [self setDataAndAppVersion];
        
    });
}



/**
 *@brief 设置子件数据以及版本信息
 *@param view UIView 参数：组件
 *@return
 */
- (void)setDataAndAppVersion
{
    
    //获取子件数据
    NSMutableDictionary *minlets = [NSMutableDictionary dictionaryWithCapacity:0];
    //查询minlets数据库
    NSMutableArray *minletsArr = [SDSqlite selectData:[SqliteHelper shareSqliteHelper].sandBaoDB tableName:@"minlets" columnArray:MINLETS_ARR];
    NSString *version = [[NSUserDefaults standardUserDefaults] objectForKey:@"MINLETVERSION"];
    if (minletsArr.count == 0 || version ==nil ) {
        [minlets setObject:@"0" forKey:@"version"];
        [minlets setObject:@"" forKey:@"minletChanges"];
    }else{
        [minlets setObject:version forKey:@"version"];
        [minlets setObject:minletsArr forKey:@"minletChanges"];
    }
    NSString *minletsStr = [[PayNucHelper sharedInstance] dictionaryToJson:minlets];
    
     __block BOOL error = NO;
    paynuc.set("minlets", [minletsStr UTF8String]);
    [[SDRequestHelp shareSDRequest] requestWihtFuncName:@"minlet/getMinlets/v1" errorBlock:^(SDRequestErrorType type) {
        error = YES;
        [[SDRequestHelp shareSDRequest] dispatchToMainQueue:^{
           [Tool showDialog:@"子件下载失败" defulBlock:^{
               [self exitApplication];
           }];
        }];
    } successBlock:^{
        [[SDRequestHelp shareSDRequest] dispatchToMainQueue:^{
            waveView.scaleRang = 1/8.f;
            waveView.waveSpeed = 1.f + (1/8.f);
            waveView.waveA = 3 + 1;
            NSString *minletsJsonStr = [NSString stringWithUTF8String:paynuc.get("minlets").c_str()];
            NSDictionary *minletDic = [[PayNucHelper sharedInstance] jsonStringToDictionary:minletsJsonStr];
            NSString *version = [minletDic objectForKey:@"version"];
            NSArray  *minletChanges = [minletDic objectForKey:@"minletChanges"];
            
            [[NSUserDefaults standardUserDefaults] setObject:version forKey:@"MINLETVERSION"];
            [self setDataWith:minletChanges];
        }];
        
    }];
    if (error) return;
    
    
    //获取版本
    [[SDRequestHelp shareSDRequest] requestWihtFuncName:@"token/getStoken/v1" errorBlock:^(SDRequestErrorType type) {
        error = YES;
        [[SDRequestHelp shareSDRequest] dispatchToMainQueue:^{
            [Tool showDialog:@"版本检测失败" defulBlock:^{
                [self exitApplication];
            }];
        }];
    } successBlock:^{
        [[SDRequestHelp shareSDRequest] dispatchToMainQueue:^{
           waveView.scaleRang = 2/8.f;
            waveView.waveSpeed = 1.f + (2/8.f);
            waveView.waveA = 3+2;
        }];
    }];
    if (error) return ;
    
    paynuc.set("tTokenType", "06000101");
    [[SDRequestHelp shareSDRequest] requestWihtFuncName:@"token/getTtoken/v1" errorBlock:^(SDRequestErrorType type) {
        error = YES;
        [[SDRequestHelp shareSDRequest] dispatchToMainQueue:^{
            [Tool showDialog:@"版本检测失败" defulBlock:^{
                [self exitApplication];
            }];
        }];
    } successBlock:^{
        [[SDRequestHelp shareSDRequest] dispatchToMainQueue:^{
            waveView.scaleRang = 3/8.f;
            waveView.waveSpeed = 1.f + (3/8.f);
            waveView.waveA = 3 + 3;
        }];
    }];
    if (error) return ;
    
    //检查用户更新
    [[SDRequestHelp shareSDRequest] requestWihtFuncName:@"application/checkUpdate/v1" errorBlock:^(SDRequestErrorType type) {
        error = YES;
        [[SDRequestHelp shareSDRequest] dispatchToMainQueue:^{
            [Tool showDialog:@"版本检测失败" defulBlock:^{
                [self exitApplication];
            }];
        }];
    } successBlock:^{
        [[SDRequestHelp shareSDRequest] dispatchToMainQueue:^{
            waveView.scaleRang = 4/8.f;
            waveView.waveSpeed = 1.f + (4/8.f);
            waveView.waveA = 3 + 4;

            NSString *appReleasejson = [NSString stringWithUTF8String:paynuc.get("appRelease").c_str()];
            NSString *appUpdatejson = [NSString stringWithUTF8String:paynuc.get("appUpdate").c_str()];
            NSDictionary *appReleaseDic = [[PayNucHelper sharedInstance] jsonStringToDictionary:appReleasejson];
            NSDictionary *appUpdateDic = [[PayNucHelper sharedInstance] jsonStringToDictionary:appUpdatejson];
            
            NSString *version = [appReleaseDic objectForKey:@"version"];
            NSString *updateLevel = [appUpdateDic objectForKey:@"updateLevel"];  //0:可不更新 1:可选更新 2:强制更新
            NSArray *downloadFiles = [appUpdateDic objectForKey:@"downloadFiles"];
            
            [SDLog logTest:version];
            [SDLog logTest:updateLevel];
            
            //获取当前工程项目版本号
            NSString *currentShortVersion = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
            NSString *currentBundleVersion = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"] ;
            //打印版本号
            NSLog(@"当前版本号:%@\n商店版本号:%@",currentBundleVersion,version);
            
            //4前版本号小于商店版本号,就更新
            int intCV = [[currentBundleVersion stringByReplacingOccurrencesOfString:@"." withString:@""] intValue];
            int intAV = [[version stringByReplacingOccurrencesOfString:@"." withString:@""] intValue];
            
            if(intCV < intAV){
                //可不更新
                if ([updateLevel isEqualToString:@"0"]) {
                    //  执行登陆流程
                    [self starlogin];
                }
                //可选更新
                if ([updateLevel isEqualToString:@"1"]) {
                    [Tool showDialog:@"检测到新版本" message:@"更新信息" leftBtnString:@"继续使用" rightBtnString:@"去更新" leftBlock:^{
                        //  执行登陆流程
                        [self starlogin];
                    } rightBlock:^{
                        NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"https://itunes.apple.com/us/app/id%@?ls=1&mt=8", @"595615424"]];
                        [[UIApplication sharedApplication] openURL:url];
                        [self exitApplication];
                    }];
                }
                //强制更新
                if ([updateLevel isEqualToString:@"2"]) {
                    [Tool showDialog:@"更新信息" defulBlock:^{
                        NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"https://itunes.apple.com/us/app/id%@?ls=1&mt=8", @"595615424"]];
                        [[UIApplication sharedApplication] openURL:url];
                        [self exitApplication];
                        
                    }];
                }
            }else{
                //  执行登陆流程
                [self starlogin];
                
            }
        }];
    }];
    if (error) return;
}

//设置数据:数据库操作
- (void)setDataWith:(NSArray*)minletChangeArr{

    //1.分离add与delete数组
    NSMutableArray *addMinletArrM = [NSMutableArray arrayWithCapacity:0];
    NSMutableArray *deleteMinletArrM = [NSMutableArray arrayWithCapacity:0];
    for (int i = 0; i<minletChangeArr.count; i++) {
        NSDictionary *minletDic = [minletChangeArr[i] objectForKey:@"minlet"];
        NSString *type = [minletChangeArr[i] objectForKey:@"type"];
        if ([type isEqualToString:@"add"]) {
            [addMinletArrM addObject:minletDic];
        }else if ([type isEqualToString:@"delete"]){
            [deleteMinletArrM addObject:minletDic];
        }
    }
    
    //2.minlets数据库操作
    NSMutableArray *minletsArr = [SDSqlite selectData:[SqliteHelper shareSqliteHelper].sandBaoDB tableName:@"minlets" columnArray:MINLETS_ARR];
    //2.1 检测子件未更新处理
    if (addMinletArrM.count == 0 && deleteMinletArrM.count == 0) {
        return;
    }
    //2.2 检测子件有更新处理
    else{
        //2.2.1 add处理
        if (addMinletArrM.count>0) {
            //复制一个addMinletArrM(备用)
            NSMutableArray *addMinetArrOnlyadd = [NSMutableArray arrayWithArray:addMinletArrM];
            //双循环遍历
            for (int a = 0; a<addMinletArrM.count; a++) {
                for (int b = 0; b<minletsArr.count; b++) {
                    NSString *addID = [NSString stringWithFormat:@"%@",[addMinletArrM[a] objectForKey:@"id"]];
                    NSString *minletID = [NSString stringWithFormat:@"%@",[minletsArr[b] objectForKey:@"id"]];
                    BOOL exist = [addID isEqualToString:minletID];
                    if (exist) {
                        //交集部分在minlets数据库中则updata
                        [SDLog logTest:[NSString stringWithFormat:@"----- 交集ID %@",[addMinletArrM[a] objectForKey:@"id"]]];
                        [addMinetArrOnlyadd removeObject:addMinletArrM[a]];
                        // 设置SQL更新语句集
                        NSString *sqlStr = [self updataForMinlets:addMinletArrM[a]];
                        BOOL updatasuccess = [SDSqlite updateData:[SqliteHelper shareSqliteHelper].sandBaoDB sql:sqlStr];
                        [SDLog logTest:[NSString stringWithFormat:@"更新成功 %d",updatasuccess]];
                        if (!updatasuccess) {
                            [Tool showDialog:@"子件更新失败" defulBlock:^{
                                [self exitApplication];
                            }];
                        }
                    }
                }
            }
            //三,未交集部分在minlets数据库中insert(第一次minletsArr为空)
            for (int c = 0 ; c<addMinetArrOnlyadd.count; c++) {
                [SDLog logTest:[NSString stringWithFormat:@"----- 未交集ID %@",[addMinetArrOnlyadd[c] objectForKey:@"id"]]];
                // 设置SQL插入语句集
                NSString *sqlStr = [self insertIntoMinlets:addMinetArrOnlyadd[c]];
                BOOL successInsert = [SDSqlite insertData:[SqliteHelper shareSqliteHelper].sandBaoDB sql:sqlStr];
                [SDLog logTest:[NSString stringWithFormat:@"插入成功 %d",successInsert]];
                if (!successInsert) {
                    [Tool showDialog:@"子件添加失败" defulBlock:^{
                        [self exitApplication];
                    }];
                }
            }
        }
        
        //2.2.2 delete处理
        if (deleteMinletArrM.count>0) {
            //删除minlets数据库中对应的数据
            for (int d = 0; d<deleteMinletArrM.count; d++) {
                [SDLog logTest:[NSString stringWithFormat:@"----- 删除的ID %@",[deleteMinletArrM[d] objectForKey:@"id"]]];
                // 设置SQL删除语句集
                NSString *sqlStr = [self deleteFromMinlets:deleteMinletArrM[d]];
                BOOL deleteSuccess = [SDSqlite deleteData:[SqliteHelper shareSqliteHelper].sandBaoDB sql:sqlStr];
                [SDLog logTest:[NSString stringWithFormat:@"删除成功 %d",deleteSuccess]];
                if (!deleteSuccess) {
                    [Tool showDialog:@"子件删除失败" defulBlock:^{
                        [self exitApplication];
                    }];
                }
            }
        }
    }
}
/**
 编辑插入SQL命令
 
 @param dic 数据
 @return 命令语句
 */
- (NSString*)insertIntoMinlets:(NSDictionary*)dic{
    
    NSString *insertSQLstr = [NSString stringWithFormat:@"insert into minlets (id, orders, title, logo, url, type, isTest) values ('%@', '%@', '%@', '%@', '%@', '%@', '%@')",[dic objectForKey:@"id"],[dic objectForKey:@"orders"],[dic objectForKey:@"title"],[dic objectForKey:@"logo"],[dic objectForKey:@"url"],[dic objectForKey:@"type"],[dic objectForKey:@"isTest"]];
    return insertSQLstr;
    
}

/**
 编辑更新SQL命令
 
 @param dic shuju
 @return 命令语句
 */
- (NSString*)updataForMinlets:(NSDictionary*)dic{
    
    NSString *updataSQLstr =   [NSString stringWithFormat:@"update minlets set id = '%@', orders = '%@', title = '%@' ,logo = '%@',url = '%@',type = '%@',isTest = '%@'  where id = '%@'",[dic objectForKey:@"id"],[dic objectForKey:@"orders"],[dic objectForKey:@"title"],[dic objectForKey:@"logo"],[dic objectForKey:@"url"],[dic objectForKey:@"type"],[dic objectForKey:@"isTest"],[dic objectForKey:@"id"]];
    
    return updataSQLstr;
    
}


/**
 编辑删除SQL命令
 
 @param dic 数据
 @return 命令语句
 */
- (NSString*)deleteFromMinlets:(NSDictionary*)dic{
    
    NSString *deleteSQLstr =   [NSString stringWithFormat:@"delete from minlets where id = '%@'",[dic objectForKey:@"id"]];
    return deleteSQLstr;
}


/**
 *@brief 执行登陆流程
 */
- (void)starlogin
{
    [[SDRequestHelp shareSDRequest] dispatchGlobalQuque:^{
        
        //查询活跃状态用户数量(1且只能为1)
        long count = [SDSqlite getCount:[SqliteHelper shareSqliteHelper].sandBaoDB sql:[NSString stringWithFormat:@"select count(*) from usersconfig where active = '%@'", @"0"]];
        //1.明登录
        if (count <= 0) {
            [[SDRequestHelp shareSDRequest] dispatchToMainQueue:^{
                [self pwdLogin];
            }];
            return ;
        }
        
        //2.暗登陆
        [self noPwdLogin];

    }];
    
}
#pragma mark - 明登陆

- (void)pwdLogin{
    //如果走明登陆,则数据库状态则全部要为无激活用户状态 (1为不活跃,0位活跃且只有一个活跃用户)
    //跟新数据库,走明登陆则数据库活跃用户全部置为不活跃,
    BOOL result = [SDSqlite updateData:[SqliteHelper shareSqliteHelper].sandBaoDB sql:[NSString stringWithFormat:@"update usersconfig set active = '%@', sToken = '%@' where active = '%@'", @"1", @"", @"0"]];
    
    if (result) {
        LoginViewController *mLoginViewController = [[LoginViewController alloc] init];
        mLoginViewController.isOtherAPPSPS = _isOtherAPPSPS;
        mLoginViewController.otherAPPSPSurl = _otherAPPSPSurl;
        UINavigationController *navLogin = [[UINavigationController alloc] initWithRootViewController:mLoginViewController];
        [self presentViewController:navLogin animated:YES completion:nil];
    }

}

#pragma mark - 暗登陆 (不管任何原因,一旦暗登录失败->必须保证有一个明登陆)
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
        [[SDRequestHelp shareSDRequest] dispatchToMainQueue:^{
            waveView.scaleRang = 5/8.f;
            waveView.waveSpeed = 1.f + (5/8.f);
            waveView.waveA = 3 + 5;
        }];
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
            waveView.scaleRang = 6/8.f;
            waveView.waveSpeed = 1.f + (6/8.f);
            waveView.waveA = 3 + 6 ;

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
            [[SDRequestHelp shareSDRequest] dispatchToMainQueue:^{
                waveView.scaleRang = 8/8.f;
                waveView.waveSpeed = 1.f + (8/8.f);
                waveView.waveA = 3 + 8;
            }];
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
                waveView.scaleRang = 9/8.f;
                waveView.waveSpeed = 1.f + (9/8.f);
                waveView.waveA = 3 + 9;
                NSArray *payToolsArray = [[PayNucHelper sharedInstance] jsonStringToArray:[NSString stringWithUTF8String:paynuc.get("payTools").c_str()]];
                //根据order 字段排序
                payToolsArray = [Tool orderForPayTools:payToolsArray];
                [CommParameter sharedInstance].ownPayToolsArray = payToolsArray;
                
                //暗登陆情况下启动SPS(不必进入主页面)
                if (_isOtherAPPSPS) {
                    SpsPayViewController *mSpsPayViewController = [[SpsPayViewController alloc] init];
                    mSpsPayViewController.controllerIndex = SDQRPAY; //设置支付类型为扫码支付
                    NSArray *urlArr = [_otherAPPSPSurl componentsSeparatedByString:@"TN:"];
                    urlArr = [[urlArr lastObject] componentsSeparatedByString:@"?"];
                    NSString *tn = [urlArr firstObject];
                    mSpsPayViewController.TN = tn;
                    mSpsPayViewController.otherAPPSPSurl = _otherAPPSPSurl;
                    //Sps模态切换,因此为其创建一个导航,(sps结束后模态切换即可销毁)
                    UINavigationController *navSps = [[UINavigationController alloc] initWithRootViewController:mSpsPayViewController];
                    [self presentViewController:navSps animated:YES completion:nil];
                    _isOtherAPPSPS = NO;
                }else{
                    //正常暗登陆(进入主页面)
                    MainViewController *mMainViewController = [[MainViewController alloc] init];
                    [self presentViewController:mMainViewController animated:NO completion:nil];
                }
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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}







#pragma mark - 暂存备用代码

/*
#pragma mark - 检测更新AppStore
-(void)hsupdateAppFromAppStore{
    
    //2先获取当前工程项目版本号
    NSDictionary *infoDic=[[NSBundle mainBundle] infoDictionary];
    NSString *currentVersion=infoDic[@"CFBundleShortVersionString"];
    
    
    NSString *urlStr = [NSString stringWithFormat:@"https://itunes.apple.com/cn/lookup"];
    NSString *postStr = [NSString stringWithFormat:@"id=%@",STOREAPPID];
    NSData   *postData = [postStr dataUsingEncoding:NSUTF8StringEncoding];
    
    NSMutableURLRequest *urlRequest = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:urlStr]];
    urlRequest.HTTPMethod = @"POST";
    urlRequest.HTTPBody = postData;
    
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:urlRequest completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if (error) {
            NSLog(@"更新AppStore ERROR : %@",error);
        }else{
            
            NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:nil];
            NSArray *array = dict[@"results"];
            if (array.count == 0) {
                return ;
            }
            NSDictionary *dic = array[0];
            NSString *appStoreVersion = dic[@"version"];
            NSString *releaseNotesStr = dic[@"releaseNotes"];
            //打印版本号
            NSLog(@"当前版本号:%@\n商店版本号:%@",currentVersion,appStoreVersion);
            //4当前版本号小于商店版本号,就更新
            int intSV = [[currentVersion stringByReplacingOccurrencesOfString:@"." withString:@""] intValue];
            int intAV = [[appStoreVersion stringByReplacingOccurrencesOfString:@"." withString:@""] intValue];
            
            if(intSV < intAV)
            {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [Tool showDialog:[NSString stringWithFormat:@"发现新版本(%@)",appStoreVersion] message:[NSString stringWithFormat:@"本次更新内容:\n%@",releaseNotesStr] leftBtnString:@"退出App" rightBtnString:@"更新" leftBlock:^{
                        exit(0);
                    } rightBlock:^{
                        NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"https://itunes.apple.com/us/app/id%@?ls=1&mt=8", STOREAPPID]];
                        [[UIApplication sharedApplication] openURL:url];
                    }];
                });
            }else{
                NSLog(@"版本号好像比商店大噢!检测到不需要更新");
            }
        }
    }];
    [dataTask resume];
}
*/

@end
