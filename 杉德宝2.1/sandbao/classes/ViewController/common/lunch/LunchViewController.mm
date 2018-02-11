//
//  LunchViewController.m
//  sandbao
//
//  Created by tianNanYiHao on 2017/11/3.
//  Copyright © 2017年 sand. All rights reserved.
//

#import "LunchViewController.h"
#import "Loading.h"
#import "PayNucHelper.h"
#import "NSObject+NSLocalNotification.h"
#import "SqliteHelper.h"
#import "SDSqlite.h"
#import "SDDrowNoticeView.h"
#import "LoginViewController.h"

//启动图 lunch
@interface LunchViewController ()
{
    NSInteger netWorkType;
    SDNetwork *netWork;
    NSTimer *timer;
}
@end

@implementation LunchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    //创建UI
    [self setBaseInfo];
    
}


- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
    //检测网络
    [self checkNetwork];
    
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    
    if (timer) {
        [timer invalidate];
        timer = nil;
    }
    
}

- (void)checkNetwork{
    
    //网络状态预判断
    netWork = [[SDNetwork alloc] init];
    netWorkType = [netWork integerWithNetworkType];
    
    /*
     *第一次网络状态返回, 弹出自定义提示 - (避免由于一直无法检测到网络而无交互导致用户误解)
     *第一次网络状态返回,or国行手机网络权限导致无网络/or用户飞行模式/or用户曾主动关闭网络
     *均弹出友好提示 - 引导用户尝试解决网络问题.
     *首次安装App,该弹出会被 国行手机权限询问弹框所遮挡,待用户决定App是否使用网络后,再去引导用户进行设置
     */
    if (netWorkType == 0) {
        // 引导用户去系统设置
        [[SDAlertView shareAlert] showDialog:@"无网络连接" message:@"1.检查是否触发了飞行模式,关闭即可 \n\n2.检查是否关闭了网络权限,请授权杉德宝访问网络,操作方法(设置-蜂窝移动网络-杉德宝)" leftBtnString:@"退出杉德宝" rightBtnString:@"去设置" leftBlock:^{
            [Tool exitApplication:self];
        } rightBlock:^{
            [Tool openUrl:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];
            [Tool exitApplication:self];
        }];
        
    }
    
    //定时器
    timer = [NSTimer timerWithTimeInterval:1.f target:self selector:@selector(netWorkRequest) userInfo:nil repeats:YES];
    [[NSRunLoop currentRunLoop] addTimer:timer forMode:NSRunLoopCommonModes];
}

- (void)netWorkRequest{
    
    /*
     *检测网络状态 - 无网络
     *继续执行定时器
     */
    if (netWorkType == 0) {
        NSLog(@"检测到无网络/未决,继续检测");
        netWorkType = [netWork integerWithNetworkType];
    }
    /*
     *检测网络状态 - 有网络
     *定时器停止
     *隐藏之前弹出的 @"无网络连接" 提示弹框
     *执行大Loading
     */
    else{
        if (timer) {
            [timer invalidate];
            timer = nil;
            
            [[SDAlertView shareAlert] hideDialogAnimation:NO];
            
            NSLog(@"检测到有网络,执行大Loading");
            dispatch_async(dispatch_get_global_queue(DISPATCH_TARGET_QUEUE_DEFAULT, 0), ^{
                [self BigLoading];
            });
        }
    }
    
}

/**大Loading*/
- (void)BigLoading{
    
    //大Loding
    NSInteger loadingResult = [Loading startLoading];
    NSString *loginTypeStr;
    //load失败
    if (loadingResult == 0) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [[SDAlertView shareAlert] showDialog:@"信息加载失败" message:nil leftBtnString:@"重新加载" rightBtnString:@"退出杉德宝" leftBlock:^{
                //延迟1.5秒执行, 避免线程卡主
                [self performSelector:@selector(buttonClick:) withObject:nil afterDelay:1.5f];
            } rightBlock:^{
                [Tool exitApplication:self];
            }];
        });
    }
    //load成功
    else
    {
        //明登陆引导
        if (loadingResult == 1) {
            loginTypeStr = @"PWD_LOGIN";
            //发送通知
            dispatch_async(dispatch_get_main_queue(), ^{
               [[NSNotificationCenter defaultCenter] postNotificationName:LOGINWAYNOTICE object:loginTypeStr];
            });
        }
        //暗登陆引导
        if (loadingResult == 2) {
            loginTypeStr = @"NO_PWD_LOGIN";
            //发送通知
            dispatch_async(dispatch_get_main_queue(), ^{
                [[NSNotificationCenter defaultCenter] postNotificationName:LOGINWAYNOTICE object:loginTypeStr];
            });
        }
    }
}

#pragma mark - 重写父类-baseScrollView设置
- (void)setBaseScrollview{
    [super setBaseScrollview];
    self.baseScrollView.frame = [UIScreen mainScreen].bounds;
}
#pragma mark - 重写父类-导航设置方法
- (void)setNavCoverView{
    [super setNavCoverView];
    self.navCoverView.hidden = YES;
}

#pragma mark - 重写父类-点击方法集合
- (void)buttonClick:(UIButton *)btn{
    
    //大Loading不应再主线程执行
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [self BigLoading];
    });
}

#pragma mark  - UI绘制
- (void)setBaseInfo{

    UIImage *headImage = [UIImage fullscreenAllIphoneImageWithName:@"loading.png"];
    UIImageView *headImageView = [[UIImageView alloc] init];
    headImageView.contentMode = UIViewContentModeScaleAspectFit;
    headImageView.image = headImage;
    [self.baseScrollView addSubview:headImageView];
    [headImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.view);
    }];
    
    
    //显示Build版本lab
    NSString *strVersion = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"] ;
    NSString *strVersionInfo = [NSString stringWithFormat:@"Build版本号: %@",strVersion];
    UILabel *versionLab = [Tool createLable:strVersionInfo attributeStr:nil font:FONT_12_Regular textColor:COLOR_343339 alignment:NSTextAlignmentCenter];
    [self.baseScrollView addSubview:versionLab];
    [versionLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(headImageView.mas_bottom).offset(-UPDOWNSPACE_20);
        make.centerX.equalTo(headImageView.mas_centerX).offset(0);
        make.size.mas_equalTo(versionLab.size);
    }];

//    //显示version版本
//    NSString *strVersion1 = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"] ;
//    //    CFBundleShortVersionString
//    //    CFBundleVersion
//    NSString *versionLab1Info = [NSString stringWithFormat:@"Version版本号:v@%@",strVersion1];
//    UILabel *versionLab1 = [Tool createLable:versionLab1Info attributeStr:nil font:FONT_12_Regular textColor:COLOR_343339 alignment:NSTextAlignmentCenter];
//    [self.baseScrollView addSubview:versionLab1];
//    [versionLab1 mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.bottom.equalTo(headImageView.mas_bottom).offset(-UPDOWNSPACE_20);
//        make.centerX.equalTo(headImageView.mas_centerX).offset(0);
//        make.size.mas_equalTo(versionLab1.size);
//    }];
}


- (void)dealloc{
    
    if (timer) {
        [timer invalidate];
        timer = nil;
    }
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
