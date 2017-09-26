//
//  LaunchScreenViewController.m
//  sandbao
//
//  Created by blue sky on 2016/10/31.
//  Copyright © 2016年 sand. All rights reserved.
//

#import "LaunchScreenViewController.h"
#import "MainViewController.h"
#import "LoginViewController.h"
#import "SqliteHelper.h"
#import "Majlet_Func.h"
#import "SDSqlite.h"
#import "CommParameter.h"
#import "IndicatorView.h"

@interface LaunchScreenViewController ()
{
    
}

@property (nonatomic, assign) CGSize viewSize;


@property (nonatomic, strong) IndicatorView *mIndicatorView;

@end



@implementation LaunchScreenViewController

@synthesize viewSize;


@synthesize mIndicatorView;

- (void)viewDidLoad {
    [super viewDidLoad];
    viewSize = self.view.bounds.size;
    
    mIndicatorView = [IndicatorView loadingImageViewInView:[self.view.window.subviews objectAtIndex:0] msgTille:@"正在加载中......"];
    mIndicatorView.center = CGPointMake(viewSize.width * 0.5, viewSize.height * 0.5);
    
    UIImage *headImage = [UIImage fullscreenAllIphoneImageWithName:@"start_page.png"];
    UIImageView *headImageView = [[UIImageView alloc] init];
    headImageView.contentMode = UIViewContentModeScaleAspectFit;
    headImageView.image = headImage;
    [self.view addSubview:headImageView];
    
    
    [headImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.view);
    }];
    
    [self loadData];
    
    //    MainViewController *mMainViewController = [[MainViewController alloc] init];
    //    [self presentViewController:mMainViewController animated:YES completion:nil];
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
        
        [self setData];
        
        if (result) {
            dispatch_async(dispatch_get_main_queue(), ^{
                //修改状态栏白色
                [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:NO];
//                MainViewController *mMainViewController = [[MainViewController alloc] init];
//                [self presentViewController:mMainViewController animated:NO completion:nil];
                
                LoginViewController *mLoginViewController = [[LoginViewController alloc] init];
//                UINavigationController *navLogin = [[UINavigationController alloc] initWithRootViewController:mLoginViewController];
                [self presentViewController:mLoginViewController animated:YES completion:nil];
            });
        } else {
            dispatch_async(dispatch_get_main_queue(), ^{
                [self exitApplication];
            });
        }
    });
}

/**
 *@brief 设置数据
 *@param view UIView 参数：组件
 *@return
 */
- (void)setData
{
    NSMutableArray *minletsArray = [[NSMutableArray alloc] init];
    
    for (int i = 0; i < 18; i++) {
        if (i < 9) {
            NSMutableDictionary *minletsdDic = [[NSMutableDictionary alloc] init];
            [minletsdDic setValue:[NSString stringWithFormat:@"1000%i",i+1] forKey:@"letId"];
            [minletsArray addObject:minletsdDic];
        } else {
            NSMutableDictionary *minletsdDic = [[NSMutableDictionary alloc] init];
            [minletsdDic setValue:[NSString stringWithFormat:@"100%i",i+1] forKey:@"letId"];
            [minletsArray addObject:minletsdDic];
        }
    }
    
    
    NSMutableArray *minletsSqlArray = [[NSMutableArray alloc] init];
    
    [minletsSqlArray addObject:@"insert into minlets (letId, allowed, caption, icon, h5_addr) values ('10001', '0', '记帐本', 'icon', 'http://www.baidu.com')"];
    
    [minletsSqlArray addObject:@"insert into minlets (letId, allowed, caption, icon, h5_addr) values ('10002', '0', '加油服务', 'icon', 'http://www.baidu.com')"];
    
    [minletsSqlArray addObject:@"insert into minlets (letId, allowed, caption, icon, h5_addr) values ('10003', '0', '发票管家', 'icon', 'http://www.baidu.com')"];
    
    [minletsSqlArray addObject:@"insert into minlets (letId, allowed, caption, icon, h5_addr) values ('10004', '0', '羊城通充值', 'icon', 'http://www.baidu.com')"];
    
    [minletsSqlArray addObject:@"insert into minlets (letId, allowed, caption, icon, h5_addr) values ('10005', '0', '我的快递', 'icon', 'http://www.baidu.com')"];
    
    [minletsSqlArray addObject:@"insert into minlets (letId, allowed, caption, icon, h5_addr) values ('10006', '0', '我的客服', 'icon', 'http://www.baidu.com')"];
    
    [minletsSqlArray addObject:@"insert into minlets (letId, allowed, caption, icon, h5_addr) values ('10007', '0', '服务窗', 'icon', 'http://www.baidu.com')"];
    
    [minletsSqlArray addObject:@"insert into minlets (letId, allowed, caption, icon, h5_addr) values ('10008', '1', '城市服务', 'icon', 'http://www.baidu.com')"];
    
    [minletsSqlArray addObject:@"insert into minlets (letId, allowed, caption, icon, h5_addr) values ('10009', '1', '生活缴费', 'icon', 'http://www.baidu.com')"];
    
    [minletsSqlArray addObject:@"insert into minlets (letId, allowed, caption, icon, h5_addr) values ('10010', '1', '信用卡还款', 'icon', 'http://www.baidu.com')"];
    
    [minletsSqlArray addObject:@"insert into minlets (letId, allowed, caption, icon, h5_addr) values ('10011', '1', '手机充值', 'icon', 'http://www.baidu.com')"];
    
    [minletsSqlArray addObject:@"insert into minlets (letId, allowed, caption, icon, h5_addr) values ('10012', '1', '便民生活', 'icon', 'http://www.baidu.com')"];
    
    [minletsSqlArray addObject:@"insert into minlets (letId, allowed, caption, icon, h5_addr) values ('10013', '0', '余额宝', 'icon', 'http://www.baidu.com')"];
    
    [minletsSqlArray addObject:@"insert into minlets (letId, allowed, caption, icon, h5_addr) values ('10014', '1', '蚂蚁花呗', 'icon', 'http://www.baidu.com')"];
    
    [minletsSqlArray addObject:@"insert into minlets (letId, allowed, caption, icon, h5_addr) values ('10015', '1', '芝麻信用', 'icon', 'http://www.baidu.com')"];
    
    [minletsSqlArray addObject:@"insert into minlets (letId, allowed, caption, icon, h5_addr) values ('10016', '1', '蚂蚁聚宝', 'icon', 'http://www.baidu.com')"];
    
    [minletsSqlArray addObject:@"insert into minlets (letId, allowed, caption, icon, h5_addr) values ('10017', '1', '股票', 'icon', 'http://www.baidu.com')"];
    
    [minletsSqlArray addObject:@"insert into minlets (letId, allowed, caption, icon, h5_addr) values ('10018', '1', '保险服务', 'icon', 'http://www.baidu.com')"];
    
    NSInteger minletsArrayCount = [minletsArray count];
    
    for (int i = 0; i < minletsArrayCount; i++) {
        
        NSMutableDictionary *minletsDic = minletsArray[i];
        
        long count = [SDSqlite getCount:[SqliteHelper shareSqliteHelper].sandBaoDB sql:[NSString stringWithFormat:@"select count(*) from minlets where letId = '%@'", [minletsDic objectForKey:@"letId"]]];
        
        if (count <= 0) {
            [SDSqlite insertData:[SqliteHelper shareSqliteHelper].sandBaoDB sql:minletsSqlArray[i]];
            //            [SDDBUtil insertData:[Majlet_Func shareMajlet_Func].sandBaoDB sql:[NSString stringWithFormat:@"insert into minlets (letId, allowed, caption, icon, h5_addr) values ('%@', '%@', '%@', '%@', '%@')",[minletsDic objectForKey:@"letId"], [minletsDic objectForKey:@"allowed"], [minletsDic objectForKey:@"caption"], [minletsDic objectForKey:@"icon"], [minletsDic objectForKey:@"h5_addr"]]];
        } else {
            //            [SDDBUtil updateData:[Majlet_Func shareMajlet_Func].sandBaoDB sql:[NSString stringWithFormat:@"update usersconfig set allowed = '%@', caption = '%@', icon = '%@', h5_addr = '%@' where letId = '%@'", [minletsDic objectForKey:@"allowed"], [minletsDic objectForKey:@"caption"], [minletsDic objectForKey:@"icon"], [minletsDic objectForKey:@"h5_addr"], [minletsDic objectForKey:@"letId"]]];
        }
    }
    
    [CommParameter sharedInstance].userId = @"3472";
    
    long count = [SDSqlite getCount:[SqliteHelper shareSqliteHelper].sandBaoDB sql:[NSString stringWithFormat:@"select count(*) from usersconfig where uid = '%@'", [CommParameter sharedInstance].userId]];
    
    if (count > 0) {
        [SDSqlite updateData:[SqliteHelper shareSqliteHelper].sandBaoDB sql:[NSString stringWithFormat:@"update usersconfig set active = '%@', sToken = '%@', credit_fp = '%@'  where uid = '%@'", @"0", @"ssss", @"sss", [CommParameter sharedInstance].userId]];
    } else {
        
        NSMutableArray *columnArray = [[NSMutableArray alloc] init];
        [columnArray addObject:@"letId"];
        [columnArray addObject:@"allowed"];
        [columnArray addObject:@"caption"];
        [columnArray addObject:@"icon"];
        [columnArray addObject:@"h5_addr"];
        
        NSMutableArray *minletsArray = [SDSqlite selectData:[SqliteHelper shareSqliteHelper].sandBaoDB tableName:@"minlets" columnArray:columnArray ];
        
        NSInteger minletsArrayCount = [minletsArray count];
        
        NSMutableArray *letsDicArray = [[NSMutableArray alloc] init];
        if (minletsArrayCount > 8) {
            for (int i = 0; i < 7; i++) {
                NSMutableDictionary *letsDic = [[NSMutableDictionary alloc] init];
                NSMutableDictionary *minletsDic = minletsArray[i];
                [letsDic setValue:[minletsDic objectForKey:@"letId"] forKey:@"letId"];
                [letsDicArray addObject:letsDic];
            }
        } else {
            for (int i = 0; i < minletsArrayCount; i++) {
                NSMutableDictionary *letsDic = [[NSMutableDictionary alloc] init];
                NSMutableDictionary *minletsDic = minletsArray[i];
                [letsDic setValue:[minletsDic objectForKey:@"letId"] forKey:@"letId"];
                [letsDicArray addObject:letsDic];
            }
        }
        
        
        NSError *error;
        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:letsDicArray options:NSJSONWritingPrettyPrinted error:&error];
        NSString *letsJson = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
        letsJson = [[letsJson stringByReplacingOccurrencesOfString:@"\n" withString:@""] stringByReplacingOccurrencesOfString:@" " withString:@""];
        
        [SDSqlite insertData:[SqliteHelper shareSqliteHelper].sandBaoDB sql:[NSString stringWithFormat:@"insert into usersconfig (uid, active, sToken, credit_fp, lets) values ('%@', '%@', '%@', '%@', '%@')", [CommParameter sharedInstance].userId, @"sss", @"ssss", @"sssss", letsJson]];
    }
}

- (void)exitApplication {
    //来 加个动画，给用户一个友好的退出界面
    [UIView beginAnimations:@"exitApplication" context:nil];
    [UIView setAnimationDuration:0.5];
    [UIView setAnimationDelegate:self];
//     [UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
    [UIView setAnimationTransition:UIViewAnimationCurveEaseOut forView:self.view.window cache:NO];
//    [UIView setAnimationTransition:UIViewAnimationCurveEaseOut forView:appDelegate.window cache:NO];
    [UIView setAnimationDidStopSelector:@selector(animationFinished:finished:context:)];
    self.view.window.bounds = CGRectMake(0, 0, 0, 0);
//    appDelegate.window.bounds = CGRectMake(0, 0, 0, 0);
    [UIView commitAnimations];
}




- (void)animationFinished:(NSString *)animationID finished:(NSNumber *)finished context:(void *)context
{
    if ([animationID compare:@"exitApplication"] == 0) {
        exit(0);
    }
}


- (void)viewDidAppear:(BOOL)animated {
    
    //    MainViewController *mMainViewController = [[MainViewController alloc] init];
    //    [self presentViewController:mMainViewController animated:NO completion:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
