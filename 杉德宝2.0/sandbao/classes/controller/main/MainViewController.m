 //
//  MainViewController.m
//  sandbao
//
//  Created by tianNanYiHao on 2016/10/31.
//  Copyright © 2016年 sand. All rights reserved.
//

#import "MainViewController.h"
#import "Dock.h"
#import "SandBaoViewController.h"
#import "LifePerimeterViewController.h"
#import "MyViewController.h"
#import "NSObject+NSLocalNotification.h"
#import <AVFoundation/AVFoundation.h>
#import "SpsPayViewController.h"
#import "SqliteHelper.h"
#import "SDSqlite.h"
#import "SDDrowNoticeView.h"




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

- (void)viewDidLoad {
    [super viewDidLoad];
    
    kDockHeight = [UIImage imageNamed:@"tab_bg.png"].size.height;
    
    // 1.添加dock
    [self addDock];
    
    // 2.创建所有的子控制器
    [self createChildViewControllers];
    
    // 3.默认选中第0个控制器
    [self selecteControllerAtIndex:0];
    
    // 4.设置导航栏主题
    [self setNavigationTheme];
    
    // 5. MQTT
    [self addMqtt];


    
    //注册通知
    //退出后切回首页通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(noticeBarItem:) name:LOGOUTNOTICEBARITEM object:nil];
    //退出后 重置MQTT的clientID
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(noticeMqtt) name:LOGOUTNOTICEMQTT object:nil];
    //登录情况下,第三方应用调用杉德宝启动SPS支付
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(openSPSPay:) name:OPENSPSPAYNOTICELOGIN object:nil];
    
    
    
    
    
}
/**
 监听

 @return
 */
-(void)noticeBarItem:(NSNotification*)noti{
    
    [self selecteControllerAtIndex:0];
    //监听Dock内部item的点击
    dock.selectedIndex = 0;

}

-(void)noticeMqtt{
    [self addMqtt];
}

- (void)openSPSPay:(NSNotification*)noti{
    //已登录且AppState为 active状态时 启动SPS
    NSString *urlstr = noti.object;
    SpsPayViewController *mSpsPayViewController = [[SpsPayViewController alloc] init];
    mSpsPayViewController.controllerIndex = SDQRPAY; //设置支付类型为扫码支付
    NSArray *urlArr = [urlstr componentsSeparatedByString:@"TN:"];
    urlArr = [[urlArr lastObject] componentsSeparatedByString:@"?"];
    NSString *tn = [urlArr firstObject];
    mSpsPayViewController.TN = tn;
    mSpsPayViewController.otherAPPSPSurl = urlstr;
    //Sps模态切换,因此为其创建一个导航,(sps结束后模态切换即可销毁)
    UINavigationController *navSps = [[UINavigationController alloc] initWithRootViewController:mSpsPayViewController];
    [self presentViewController:navSps animated:YES completion:nil];
    
}

#pragma mark 设置导航栏主题
- (void)setNavigationTheme
{
    // 1.导航栏
    // 1.1.操作navBar相当操作整个应用中的所有导航栏
    UINavigationBar *navBar = [UINavigationBar appearance];
    // 1.3.设置状态栏背景
    //    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleBlackOpaque;
    // 1.2.设置导航栏背景
    //    [navBar setBackgroundImage:[UIImage imageNamed:@"nav_bg_image.png"] forBarMetrics:UIBarMetricsDefault];
    
    [navBar setBackgroundImage:[UIImage new] forBarMetrics:0];
    navBar.shadowImage=[UIImage new];
    
    // 1.4.设置导航栏的文字
    //    [navBar setTitleTextAttributes:@{
    //                                     NSForegroundColorAttributeName : [UIColor darkGrayColor],
    //                                     NSShadowAttributeName : [NSValue valueWithUIOffset:UIOffsetZero]
    //                                     }];
    
    // 2.导航栏上面的item
    //    UIBarButtonItem *barItem =[UIBarButtonItem appearance];
    // 2.1.设置背景
    //    [barItem setBackgroundImage:[UIImage imageNamed:@"back_bar_button"] forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
    //    [barItem setBackgroundImage:[UIImage imageNamed:@"back_bar_button_s"] forState:UIControlStateHighlighted barMetrics:UIBarMetricsDefault];
    //    [barItem setBackgroundImage:[UIImage imageNamed:@"back_bar_button_s"] forState:UIControlStateDisabled barMetrics:UIBarMetricsDefault];
    // 2.2.设置item的文字属性
    //    NSDictionary *barItemTextAttr = @{
    //                                      NSForegroundColorAttributeName : [UIColor darkGrayColor],
    //                                      NSShadowAttributeName : [NSValue valueWithUIOffset:UIOffsetZero],
    //                                      NSFontAttributeName : [UIFont systemFontOfSize:13]
    //                                      };
    //    [barItem setTitleTextAttributes:barItemTextAttr forState:UIControlStateNormal];
    //    [barItem setTitleTextAttributes:barItemTextAttr forState:UIControlStateHighlighted];
}

#pragma mark 重写父类的方法：添加一个子控制器
- (void)addChildViewController:(UIViewController *)childController
{
    // 1.创建导航控制器的目的：需要一个导航条
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:childController];
    nav.delegate = self;
    // 2.添加子控制器（包装过后的导航控制器）
    // childViewControllers里面都是导航控制器
    [super addChildViewController:nav];
}

#pragma mark 创建所有的子控制器
- (void)createChildViewControllers
{
    // 1.杉德宝
     SandBaoViewController *sandBao = [[SandBaoViewController alloc] init];
    // 会将子控制器添加到childViewControllers中去
    [self addChildViewController:sandBao];
    
    // 2.朋友
//     FriendViewController *friend = [[FriendViewController alloc] init];
//    [self addChildViewController:friend];
    
//    // 3.生活周边
    LifePerimeterViewController *lifePerimeter = [[LifePerimeterViewController alloc] init];
    [self addChildViewController:lifePerimeter];
    
    // 4.我的
    MyViewController *my = [[MyViewController alloc] init];
    [self addChildViewController:my];
}






#pragma mark 添加dock
- (void)addDock
{
    // 1.添加dock
    dock = [[Dock alloc] init];
    dock.frame = CGRectMake(0, self.view.frame.size.height - kDockHeight, self.view.frame.size.width, kDockHeight);
    [self.view addSubview:dock];
    
    // 2.添加dock里面的item
    [dock addDockItemWithIcon:@"home_default" title:@"杉德宝"];
//    [dock addDockItemWithIcon:@"tab_button_plan_normal.png" title:@"朋友"];
    [dock addDockItemWithIcon:@"life_default" title:@"生活周边"];
    [dock addDockItemWithIcon:@"personal_default" title:@"个人中心"];
    
    
    __typeof(self) weakSelf = self;
    // 3.监听Dock内部item的点击
    dock.itemClickBlock = ^(int index){
        currentVCindex = index;
        [weakSelf selecteControllerAtIndex:index];
    };
}

#pragma mark 选中index位置对应的子控制器
- (void)selecteControllerAtIndex:(NSInteger)index
{
    /*
     切换上面子控制器的内容
     
     控制器view默认的frame（iPhone4的情况）
     有状态栏：{0, 20}, {320, 460}
     无状态栏：{0, 0}, {320, 480}
     */
    // 0.取出新的控制器
    UIViewController *new = self.childViewControllers[index];
    if (new == selectedViewController) return;
    
    // 1.移除当前控制器的view
    [selectedViewController.view removeFromSuperview];
    
    // 2.添加新控制器的view
    new.view.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height - kDockHeight);
    [self.view addSubview:new.view];
    
    // 3.让新控制器成为当前当前选中的控制器
    selectedViewController = new;
}

#pragma mark - 导航控制器代理方法
- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    //根控制器
    UIViewController *root = navigationController.viewControllers[0];
    
    // 如果不是栈底控制器（根控制器），才需要设置返回按钮
    
    if (viewController != root) {
        // 更改导航控制器view的frame
        navigationController.view.frame = self.view.bounds;
        
        // 让Dock从MainViewController上移除
        [mDock removeFromSuperview];
        
        // 调整Dock的Y值
        CGRect dockFrame = mDock.frame;
        if ([root.view isKindOfClass:[UIScrollView class]]) {
            UIScrollView *scrollview = (UIScrollView *)root.view;
            dockFrame.origin.y = scrollview.contentOffset.y + root.view.frame.size.height - kDockHeight;
        } else {
            dockFrame.origin.y -= kDockHeight;
        }
        mDock.frame = dockFrame;
        
        // 添加dock到根控制器界面
        [root.view addSubview:mDock];
    }
}

- (void)navigationController:(UINavigationController *)navigationController didShowViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    // 根控制器
    UIViewController *root = navigationController.viewControllers[0];
    
    if (viewController == root) {
        // 更改导航控制器view的frame
        navigationController.view.frame = kContentFrame;
        
        // 让Dock从root上移除
        [mDock removeFromSuperview];
        
        // 添加dock到MainViewController
        mDock.frame = KDockFrame;
        [self.view addSubview:mDock];
    }
}

/**
 订阅mqtt消息
 */
- (void)addMqtt{
    
    //1先注册代理
    [[MqttClientManager shareInstance] registerDelegate:self];
    
    //2再订阅消息
    //订阅主题不能放到子线程,不然消息Block不会回调
    [[MqttClientManager shareInstance] loginWithIp:kIP port:kPort userName:kMqttuserNmae password:kMqttpasswd topic:kMqttTopicUSERID([CommParameter sharedInstance].userId)];
        
    //[[MqttClientManager shareInstance] loginWithIp:kIP port:kPort userName:kMqttuserNmae password:kMqttpasswd topic:kMqttTopicBROADCAST];
}

#pragma mark - MQTT代理方法
- (void)messageTopic:(NSString *)topic data:(NSDictionary *)dic
{
    
    //mqtt消息落库
    [self setMqttlist:dic];
    
    NSString *msgType = [dic objectForKey:@"msgType"];
    //提醒处理
    if ([[dic objectForKey:@"msgLevel"] intValue] == 0) {
        if ([@"000001" isEqualToString:msgType]) {
            
        }
        if ([@"000001" isEqualToString:msgType]) {
           
        }
        if ([@"100001" isEqualToString:msgType]) {
            //交易信息推送
            [self transePayNotice:dic];
        }
        if ([@"200001" isEqualToString:msgType]) {
            
        }
        if ([@"300001" isEqualToString:msgType]) {
            
        }
     
    }
    //静默处理
    if ([[dic objectForKey:@"msgLevel"] intValue] == 1) {
        if ([@"000001" isEqualToString:msgType]) {
            
        }
        if ([@"000001" isEqualToString:msgType]) {
            
        }
        if ([@"100001" isEqualToString:msgType]) {
            
        }
        if ([@"200001" isEqualToString:msgType]) {
            
        }
        if ([@"300001" isEqualToString:msgType]) {
            
        }
    }
    //强制处理
    if ([[dic objectForKey:@"msgLevel"] intValue] == 2) {
        if ([@"000001" isEqualToString:msgType]) {
            
        }
        if ([@"000001" isEqualToString:msgType]) {
            
        }
        if ([@"100001" isEqualToString:msgType]) {
            
        }
        if ([@"200001" isEqualToString:msgType]) {
            
        }
        if ([@"300001" isEqualToString:msgType]) {
            //多账户登录提醒
            [self loginOtherDevice:dic];
        }
    }
    
}
/**
 mqtt消息落库
 
 @param dic 消息回调数据
 */
- (void)setMqttlist:(NSDictionary*)dic{

    //数据字符化
    NSString *msg = [self dictToJSON:(NSMutableDictionary*)dic];
    
    //读取当前uid下的数据条数
    NSMutableArray *mqttlistArray = [SDSqlite selectWhereData:[SqliteHelper shareSqliteHelper].sandBaoDB tableName:@"mqttlist" columnArray:MQTTLIST_ARR whereColumnString:@"uid" whereParamString:[CommParameter sharedInstance].userId];
    //1.先源源不断的,根据UID插入数据
    NSString *indexStr = [NSString stringWithFormat:@"%lu",(unsigned long)mqttlistArray.count];
    BOOL success =  [SDSqlite insertData:[SqliteHelper shareSqliteHelper].sandBaoDB tableName:@"mqttlist" columnArray:MQTTLIST_ARR paramArray:(NSMutableArray*)@[[CommParameter sharedInstance].userId,msg,@"0",indexStr]];
    if (!success) {
        return;
    }
    //2.获取mqttlist最新数据库数据
    mqttlistArray = [SDSqlite selectWhereData:[SqliteHelper shareSqliteHelper].sandBaoDB tableName:@"mqttlist" columnArray:MQTTLIST_ARR whereColumnString:@"uid" whereParamString:[CommParameter sharedInstance].userId];
    //3.当前UID下数据量控制
    if (mqttlistArray.count>100) {
        //3.1 删除下标为零的数据
        BOOL deleteSuccess = [SDSqlite deleteData:[SqliteHelper shareSqliteHelper].sandBaoDB sql:[NSString stringWithFormat:@"delete from mqttlist where uid = '%@' and indexCount = '0'",[CommParameter sharedInstance].userId]];
        if (!deleteSuccess) {
            return;
        }
        //3.2 for循环-更新所有同一个UID下的index均前移1 (即-1)
        NSMutableArray *mqttlistArray = [SDSqlite selectWhereData:[SqliteHelper shareSqliteHelper].sandBaoDB tableName:@"mqttlist" columnArray:MQTTLIST_ARR whereColumnString:@"uid" whereParamString:[CommParameter sharedInstance].userId];
        for (int i = 0; i<mqttlistArray.count; i++) {
            NSString *indexCountstr = [mqttlistArray[i] objectForKey:@"indexCount"];
            NSInteger indexCount = [indexCountstr intValue] - 1;
            NSString *indexCountstrNew = [NSString stringWithFormat:@"%ld",(long)indexCount];
            BOOL updateSuccess = [SDSqlite updateData:[SqliteHelper shareSqliteHelper].sandBaoDB sql:[NSString stringWithFormat:@"update mqttlist set indexCount = '%@' where uid = '%@' and indexCount = '%@'",indexCountstrNew,[CommParameter sharedInstance].userId,indexCountstr]];
            if (!updateSuccess) {
                return;
            }
        }
        
    }
    
}

/**
 交易消息推送
 */
- (void)transePayNotice:(NSDictionary*)dic{
    
    
    NSString *msgTitle = [[dic objectForKey:@"data"] objectForKey:@"msgTitle"];
    NSError *error;
    NSData *jsonData = [[[dic objectForKey:@"data"] objectForKey:@"msgData"] dataUsingEncoding:NSUTF8StringEncoding];
    NSDictionary *msgDataDic = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableLeaves error:&error];
    NSString *OldStoken = [msgDataDic objectForKey:@"stoken"];
    NSString *message = [msgDataDic objectForKey:@"msg"];
    //根据sToken过滤消息显示
    if ([OldStoken isEqualToString:[CommParameter sharedInstance].sToken]) {
        //普通弹窗(系统声音)
        NSString *mssageStr = [NSString stringWithFormat:@" %@\n %@",msgTitle,message];
        SDDrowNoticeView *sdDrowNoticeView = [SDDrowNoticeView createDrowNoticeView:@[msgTitle,message]];
        [self.view addSubview:sdDrowNoticeView];
        [sdDrowNoticeView animationDrown];
    }
    
}


/**
 多点登陆提醒
 */
- (void)loginOtherDevice:(NSDictionary*)dic{

    //异常登陆处理
        NSString *msgTitle = [[dic objectForKey:@"data"] objectForKey:@"msgTitle"];
        NSError *error;
        NSData *jsonData = [[[dic objectForKey:@"data"] objectForKey:@"msgData"] dataUsingEncoding:NSUTF8StringEncoding];
        NSDictionary *msgDataDic = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableLeaves error:&error];
        
        NSString *OldStoken = [msgDataDic objectForKey:@"stoken"];
        NSString *message = [msgDataDic objectForKey:@"msg"];
        //根据sToken过滤消息显示
        if ([OldStoken isEqualToString:[CommParameter sharedInstance].sToken]) {
            //0.播放提示音
            [self playSoundID:1312];
            
//            [MainViewController registerLocalNotification:0 content:message key:@"localNotificationKey"];
            [Tool showDialog:msgTitle message:message leftBtnString:@"我知道了" rightBtnString:nil leftBlock:^{
                //1.获取当前下标
                if (!currentVCindex) {
                    currentVCindex = 0;
                }
                //2.获取当前页面栈顶VC
                UIViewController *currentViewController = [[self.childViewControllers[currentVCindex] childViewControllers] lastObject];
                NSString *controllerName = NSStringFromClass([currentViewController class]);
                   //2.1 导航控制器下有present模态切换的情况判断处理(if列表)
                if ([controllerName isEqualToString:@"MqttMsgViewController"]) {
                    UIViewController *mqttPPP = currentViewController.presentedViewController;
                    [mqttPPP dismissViewControllerAnimated:YES completion:^{
                        [Tool presetnLoginVC:currentViewController];
                    }];
                    return;
                }
                
                [Tool presetnLoginVC:currentViewController];
                
            } rightBlock:^{
                
                // do nothing ;
            }];
        }
    
}


- (void)messageTopic:(NSString *)topic jsonStr:(NSString *)jsonStr
{
    
    
}




#pragma mark - 播放音效文件
/** 播放音效文件 */
- (void)playSoundID:(int)soundID {
    AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
    AudioServicesPlaySystemSound(soundID);
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}
- (NSString *)dictToJSON:(NSMutableDictionary *)dic
{
    if (dic != nil) {
        NSError *error;
        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dic options:NSJSONWritingPrettyPrinted error:&error];
        NSString *str = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
        return [[str stringByReplacingOccurrencesOfString:@"\n" withString:@""] stringByReplacingOccurrencesOfString:@" " withString:@""];
    }
    
    return @"";
}

@end
