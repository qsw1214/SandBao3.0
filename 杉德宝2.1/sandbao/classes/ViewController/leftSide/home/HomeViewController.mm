 //
//  HomeViewController.m
//  sandbao
//
//  Created by tianNanYiHao on 2016/10/31.
//  Copyright © 2016年 sand. All rights reserved.
//

#import "HomeViewController.h"
#import "PayNucHelper.h"

#import "RealNameViewController.h"
#import "VerifyTypeViewController.h"
#import "MessageViewController.h"
#import "PayQrcodeViewController.h"
#import "ScannerViewController.h"


#import "GradualView.h"
#import "SDMajletView.h"
#import "SDDrowNoticeView.h"


@interface HomeViewController ()<MqttClientManagerDelegate,UICollectionViewDelegate,UICollectionViewDataSource>
{
    //headView
    UIImageView *headBGimgView; //背景图视图
    UIView      *headView;

    
    UIImageView *headIconImgView; //头像imgView
    UILabel     *headPhoneNoLab;  //用户手机号
    
    UIButton *payBtn;
    
    UIButton *moneyBtn;
    
    UILabel *moneyBtnLeftLab;
    
    UILabel *moneyBtnMidLab;
    
    UILabel *moneyBtnRightLab;
    
    UILabel *moneyBtnBottomLab;
    
    
    //bodyViewOne
    UIView      *bodyViewOne;
    //bodyViewTwo
    UIView      *bodyViewTwo;
    
}
@property (nonatomic, strong) NSMutableArray *sandServerArr; //杉德服务子件数组
@property (nonatomic, strong) NSMutableArray *limitServerArr; //限时服务子件数组
@end

@implementation HomeViewController

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    //允许RESideMenu的返回手势
    self.sideMenuViewController.panGestureEnabled = YES;
    
    //用户刷新数据信息
    [self refreshUI];
    
    //检测是否实名/设置支付密码
    [self checkRealNameOrSetPayPwd];
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
    //通知LeftSideMenuViewController 刷新用户信息UI
    [self postNotifactionToLeftSideMenuWithUserInfoRefrush];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //杉德服务子件数据读取
    NSURL *sandServerURL = [[NSBundle mainBundle] URLForResource:@"sandServer" withExtension:@"plist"];
    self.sandServerArr = [NSMutableArray arrayWithContentsOfURL:sandServerURL];
    
    //限时服务子件数据读取
    NSURL *limitServerURL = [[NSBundle mainBundle] URLForResource:@"limitServer" withExtension:@"plist"];
    self.limitServerArr = [NSMutableArray arrayWithContentsOfURL:limitServerURL];
    
    
    [self create_HeadView];
    [self create_bodyViewOne];
    [self create_bodyViewTwo];
    
    // 5. MQTT
    [self addMqtt];
    
}
#pragma mark - 重写父类-baseScrollView设置
- (void)setBaseScrollview{
    [super setBaseScrollview];
    
    self.baseScrollView.backgroundColor = COLOR_F5F5F5;
    
}
#pragma mark - 重写父类-导航设置方法
- (void)setNavCoverView{
    [super setNavCoverView];
    self.navCoverView.style = NavCoverStyleGradient;
    self.navCoverView.rightImgStr = @"index_msg";
    [self.navCoverView appendRightItem:@"index_icon_phone"];
    __weak HomeViewController *weakSelf = self;
    
    //最右边按钮事件
    self.navCoverView.rightBlock = ^{
        //@"消息"
        MessageViewController *messageVC = [[MessageViewController alloc] init];
        [weakSelf.navigationController pushViewController:messageVC animated:YES];
        
    };
    //右边第二个按钮事件(由右向左数)
    self.navCoverView.rightSecBlock = ^{
        //@"客服"
        [Tool showDialog:@"为您拨打客服热线" message:@"021-962567" leftBtnString:@"取消" rightBtnString:@"呼叫" leftBlock:^{
            
        } rightBlock:^{
            //呼叫
            if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"tel:021-962567"]]) {
                [Tool openUrl:[NSURL URLWithString:@"tel:021-962567"]];
            }
        }];
        
    };
    
    
    
    
}
#pragma mark - 重写父类-点击方法集合
- (void)buttonClick:(UIButton *)btn{
    
    if (btn.tag == BTN_TAG_INOUTPAY) {
        //@"点击了  收付款"
        PayQrcodeViewController *payQrcodeVC = [[PayQrcodeViewController alloc] init];
        [self.navigationController pushViewController:payQrcodeVC animated:YES];
    }
    if (btn.tag == BTN_TAG_BLANCE) {
        //@"钱包账户"
        [self.sideMenuViewController setContentViewController:[CommParameter sharedInstance].walletAccNav];
    }
    if (btn.tag == BTN_TAG_CARDBAG) {
        //@"扫一扫"
        ScannerViewController *mScannerViewController = [[ScannerViewController alloc] init];
        [self.navigationController pushViewController:mScannerViewController animated:YES];
    }
    
}

#pragma mark  - UI绘制
//创建头部
- (void)create_HeadView{

    UIImage *headBGimg = [UIImage imageNamed:@"index_bg"];
    headBGimgView = [Tool createImagView:headBGimg];
    headBGimgView.userInteractionEnabled = YES;
    [self.baseScrollView addSubview:headBGimgView];
    [headBGimgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.baseScrollView.mas_top);
        make.left.equalTo(self.baseScrollView.mas_left);
        make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH, headBGimg.size.height));
    }];
    
    
    //headView
    headView = [[UIView alloc] init];
    headView.backgroundColor = [UIColor clearColor];
    [headBGimgView addSubview:headView];
    
    //headWhiteView
    UIView *headWhiteView = [[UIView alloc] init];
    headWhiteView.backgroundColor = [UIColor whiteColor];
    headWhiteView.layer.cornerRadius = 5.f;
    headWhiteView.layer.shadowColor = COLOR_343339.CGColor;
    headWhiteView.layer.shadowOpacity = 0.85;
    headWhiteView.layer.shadowOffset = CGSizeMake(0, 1.5f);
    headWhiteView.layer.shadowRadius = 3.5f;
    [headView addSubview:headWhiteView];
    
    
    UIImage *headimg = [UIImage imageNamed:@"home_Head"];
    headIconImgView = [Tool createImagView:headimg];
    headIconImgView.layer.cornerRadius = headimg.size.width/2;
    headIconImgView.layer.masksToBounds = YES;
    headIconImgView.layer.shadowColor = COLOR_343339.CGColor;
    headIconImgView.layer.shadowOpacity = 1;
    headIconImgView.layer.shadowPath = [UIBezierPath bezierPathWithOvalInRect:headIconImgView.frame].CGPath;
    headIconImgView.layer.shadowOffset = CGSizeZero;
    headIconImgView.layer.shadowRadius = 5;
    [headWhiteView addSubview:headIconImgView];
    
    [headIconImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(headWhiteView.mas_top).offset(-UPDOWNSPACE_15);
        make.left.equalTo(headWhiteView.mas_left).offset(LEFTRIGHTSPACE_15);
        make.size.mas_equalTo(headimg.size);
    }];
    
    headPhoneNoLab = [Tool createLable:@"1111*******1111" attributeStr:nil font:FONT_18_Medium textColor:COLOR_343339 alignment:NSTextAlignmentLeft];
    [headWhiteView addSubview:headPhoneNoLab];
    
    [headPhoneNoLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(headWhiteView.mas_top).offset(UPDOWNSPACE_16);
        make.left.equalTo(headIconImgView.mas_right).offset(LEFTRIGHTSPACE_18);
        make.size.mas_equalTo(headPhoneNoLab.size);
    }];
    
    //payBtn
    payBtn = [Tool createButton:nil attributeStr:nil font:nil textColor:nil];
    [payBtn addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    payBtn.tag = BTN_TAG_INOUTPAY;
    [headWhiteView addSubview:payBtn];
    
    UIImage *paybtnImg = [UIImage imageNamed:@"index_function_01"];
    UIImageView *payBtnImgeView = [Tool createImagView:paybtnImg];
    [payBtn addSubview:payBtnImgeView];
    
    UILabel *payBtnBottomlab = [Tool createLable:@"收付款" attributeStr:nil font:FONT_15_Medium textColor:COLOR_000000 alignment:NSTextAlignmentCenter];
    [payBtn addSubview:payBtnBottomlab];
    
    payBtn.width = payBtnBottomlab.width;
    payBtn.height = payBtnBottomlab.height + paybtnImg.size.height + UPDOWNSPACE_10;
    
    [payBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(headIconImgView.mas_bottom).offset(UPDOWNSPACE_05);
        make.left.equalTo(headWhiteView.mas_left).offset(LEFTRIGHTSPACE_50);
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
    moneyBtn = [Tool createButton:nil attributeStr:nil font:nil textColor:nil];
    [moneyBtn addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    moneyBtn.tag = BTN_TAG_BLANCE;
    [headWhiteView addSubview:moneyBtn];
    
    moneyBtnLeftLab = [Tool createLable:@"¥" attributeStr:nil font:FONT_10_DINAlter textColor:COLOR_000000 alignment:NSTextAlignmentCenter];
    [moneyBtn addSubview:moneyBtnLeftLab];

    moneyBtnMidLab = [Tool createLable:@"- -" attributeStr:nil font:FONT_36_DINAlter textColor:COLOR_000000 alignment:NSTextAlignmentCenter];
    [moneyBtn addSubview:moneyBtnMidLab];
    
    moneyBtnRightLab = [Tool createLable:@".00" attributeStr:nil font:FONT_10_DINAlter textColor:COLOR_000000 alignment:NSTextAlignmentCenter];
    [moneyBtn addSubview:moneyBtnRightLab];
    
    moneyBtnBottomLab = [Tool createLable:@"余额(元)" attributeStr:nil font:FONT_15_Medium textColor:COLOR_000000 alignment:NSTextAlignmentCenter];
    [moneyBtn addSubview:moneyBtnBottomLab];
    
    CGFloat upLabWidth = (moneyBtnLeftLab.width + moneyBtnMidLab.width + moneyBtnRightLab.width);
    CGFloat bottomLabWidth = moneyBtnBottomLab.width;
    moneyBtn.width = upLabWidth>bottomLabWidth?upLabWidth:bottomLabWidth;
    
    [moneyBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(headIconImgView.mas_bottom).offset(UPDOWNSPACE_05);
        make.centerX.equalTo(headWhiteView.mas_centerX);
        make.size.mas_equalTo(CGSizeMake(moneyBtn.width, payBtn.height));
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
    
    
    //saoyisao
    UIButton *cardBagBtn = [Tool createButton:nil attributeStr:nil font:nil textColor:nil];
    [cardBagBtn addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    cardBagBtn.tag = BTN_TAG_CARDBAG;
    [headWhiteView addSubview:cardBagBtn];
    
    UIImage *cardBagImg = [UIImage imageNamed:@"index_function_03"];
    UIImageView *cardBagImgeView = [Tool createImagView:cardBagImg];
    cardBagImgeView.image = cardBagImg;
    [cardBagBtn addSubview:cardBagImgeView];
    
    UILabel *cardBagBottomlab = [Tool createLable:@"扫一扫" attributeStr:nil font:FONT_15_Medium textColor:COLOR_000000 alignment:NSTextAlignmentCenter];
    [cardBagBtn addSubview:cardBagBottomlab];
    
    cardBagBtn.width = cardBagBottomlab.width;
    cardBagBtn.height = cardBagBottomlab.height + cardBagImg.size.height + UPDOWNSPACE_10;
    
    [cardBagBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(headIconImgView.mas_bottom).offset(UPDOWNSPACE_05);
        make.right.equalTo(headWhiteView.mas_right).offset(-LEFTRIGHTSPACE_50);
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
    
    
    //根据图片+按钮+间隙 计算整个背景高度
    CGFloat headViewH = headimg.size.height + payBtn.height + 2*UPDOWNSPACE_15 + UPDOWNSPACE_05;
    [headView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(headBGimgView.mas_top).offset(UPDOWNSPACE_05);
        make.left.equalTo(headBGimgView.mas_left);
        make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH, headViewH));
    }];
    [headWhiteView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(headView.mas_top).offset(UPDOWNSPACE_15);
        make.left.equalTo(headView.mas_left).offset(LEFTRIGHTSPACE_15);
        make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH - 2*LEFTRIGHTSPACE_15, headViewH - 2*UPDOWNSPACE_15));
    }];
    
    
}


- (void)create_bodyViewOne{
    
    //bodyViewOne
    bodyViewOne = [[UIView alloc] init];
    bodyViewOne.backgroundColor = COLOR_FFFFFF;
    [self.baseScrollView addSubview:bodyViewOne];
    
    //杉德服务
    UILabel *sandServerLab = [Tool createLable:@"杉德服务" attributeStr:nil font:FONT_14_Regular textColor:COLOR_343339_7 alignment:NSTextAlignmentLeft];
    [bodyViewOne addSubview:sandServerLab];
    
    //majletView
    SDMajletView *sandServerView = [SDMajletView createMajletViewOY:0];
    sandServerView.cellSpace = LEFTRIGHTSPACE_25;
    sandServerView.columnNumber = 5;
    sandServerView.majletArr = self.sandServerArr;
    sandServerView.titleNameBlock = ^(NSString *titleName) {
        NSLog(@"titleName == %@",titleName);
    };
    [bodyViewOne addSubview:sandServerView];
    
    CGFloat labSpaceToView = UPDOWNSPACE_11;
    bodyViewOne.height = labSpaceToView + sandServerLab.height + labSpaceToView + sandServerView.height;
    
    [bodyViewOne mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(headBGimgView.mas_bottom).offset(UPDOWNSPACE_0);
        make.centerX.equalTo(headBGimgView.mas_centerX);
        make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH, bodyViewOne.height));
    }];
    
    [sandServerLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(bodyViewOne.mas_top).offset(labSpaceToView);
        make.left.equalTo(bodyViewOne.mas_left).offset(LEFTRIGHTSPACE_18);
        make.size.mas_equalTo(sandServerLab.size);
    }];
    
    [sandServerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(sandServerLab.mas_bottom).offset(labSpaceToView);
        make.centerX.equalTo(bodyViewOne.mas_centerX);
        make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH, sandServerView.height));
    }];
    
}

- (void)create_bodyViewTwo{

    //bodyViewTwo
    bodyViewTwo = [[UIView alloc] init];
    bodyViewTwo.backgroundColor = COLOR_FFFFFF;
    [self.baseScrollView addSubview:bodyViewTwo];
    
    //限时服务
    UILabel *limitServerLab = [Tool createLable:@"限时服务" attributeStr:nil font:FONT_14_Regular textColor:COLOR_343339_7 alignment:NSTextAlignmentLeft];
    [bodyViewTwo addSubview:limitServerLab];
    
    //majletView
    SDMajletView *limitServerView = [SDMajletView createMajletViewOY:0];
    limitServerView.cellSpace = LEFTRIGHTSPACE_25;
    limitServerView.columnNumber = 4;
    limitServerView.majletArr = self.limitServerArr;
    limitServerView.titleNameBlock = ^(NSString *titleName) {
        NSLog(@"titleName == %@",titleName);
    };
    [bodyViewTwo addSubview:limitServerView];
    
    CGFloat labSpaceToView = UPDOWNSPACE_11;
    bodyViewTwo.height = labSpaceToView + limitServerLab.height + labSpaceToView + limitServerView.height;
    
    [bodyViewTwo mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(bodyViewOne.mas_bottom).offset(UPDOWNSPACE_10);
        make.centerX.equalTo(headBGimgView.mas_centerX);
        make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH, bodyViewTwo.height));
    }];
    
    [limitServerLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(bodyViewTwo.mas_top).offset(labSpaceToView);
        make.left.equalTo(bodyViewTwo.mas_left).offset(LEFTRIGHTSPACE_18);
        make.size.mas_equalTo(limitServerLab.size);
    }];
    
    [limitServerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(limitServerLab.mas_bottom).offset(labSpaceToView);
        make.centerX.equalTo(headBGimgView.mas_centerX);
        make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH, limitServerView.height));
    }];
    
    
}

#pragma mark - 业务逻辑
#pragma mark 注册MQTT
- (void)addMqtt{
    
    //1先注册代理
    [[MqttClientManager shareInstance] registerDelegate:self];
    
    //2再订阅消息
    //订阅主题不能放到子线程,不然消息Block不会回调
    [[MqttClientManager shareInstance] loginWithIp:kIP port:kPort userName:kMqttuserNmae password:kMqttpasswd topic:kMqttTopicUSERID([CommParameter sharedInstance].userId)];
    
    //[[MqttClientManager shareInstance] loginWithIp:kIP port:kPort userName:kMqttuserNmae password:kMqttpasswd topic:kMqttTopicBROADCAST];
}
#pragma mark MQTT代理方法
- (void)messageTopic:(NSString *)topic data:(NSDictionary *)dic
{
    
    //mqtt消息落库
//    [self setMqttlist:dic];
    
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

#pragma mark MQTT事件: 交易消息推送处理
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
        [[UIApplication sharedApplication].keyWindow addSubview:sdDrowNoticeView];
        [sdDrowNoticeView animationDrown];
    }
    
}

/**
 多点登陆提醒
 */
#pragma mark MQTT事件: 多点登陆提醒
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
        AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
        AudioServicesPlaySystemSound(1312);
        //1.退出用户登录页
        [Tool showDialog:msgTitle message:message defulBlock:^{
            [Tool setContentViewControllerWithLoginFromSideMentuVIewController:self forLogOut:YES];
        }];
    }
    
}




#pragma mark - 本类公共方法调用
#pragma mark 检测是否实名或设置支付密码
- (void)checkRealNameOrSetPayPwd{
    
    //在已登陆情况下,检测用户是否实名/是否设置支付密码
    if ([CommParameter sharedInstance].userInfo.length>0)
    {
        //若检测未实名,进行实名
        if (![CommParameter sharedInstance].realNameFlag) {
            [Tool showDialog:@"请进行认证" message:@"检测到您还未实名认证" leftBtnString:@"去实名" rightBtnString:@"登出" leftBlock:^{
                RealNameViewController *realName = [[RealNameViewController alloc] init];
                realName.realNameFromeHomeNav = YES;
                UINavigationController *realNameNav = [[UINavigationController alloc] initWithRootViewController:realName];
                [self.sideMenuViewController setContentViewController:realNameNav];
            } rightBlock:^{
                [Tool setContentViewControllerWithLoginFromSideMentuVIewController:self forLogOut:YES];
            }];
            return;
        }
        //若检测未设置支付密码,则修改支付密码
        if (![CommParameter sharedInstance].payPassFlag) {
            [Tool showDialog:@"请进行设置" message:@"检测到您还未设置支付密码" leftBtnString:@"去设置" rightBtnString:@"登出" leftBlock:^{
                //由于设置支付密码挂在实名流程之下(不能单独设置),因此单独设置支付密码必须走 修改支付密码流程
                VerifyTypeViewController *verifyTypeVC = [[VerifyTypeViewController alloc] init];
                verifyTypeVC.tokenType = @"01000601";
                verifyTypeVC.verifyType = VERIFY_TYPE_CHANGEPATPWD;
                verifyTypeVC.setPayPassFromeHomeNav = YES;
                verifyTypeVC.phoneNoStr = [CommParameter sharedInstance].phoneNo;
                UINavigationController *verifyTypeNav = [[UINavigationController alloc] initWithRootViewController:verifyTypeVC];
                [self.sideMenuViewController setContentViewController:verifyTypeNav];
            } rightBlock:^{
               [Tool setContentViewControllerWithLoginFromSideMentuVIewController:self forLogOut:YES];
            }];
        }
    }
}

#pragma mark 刷新用户信息
- (void)refreshUI{
    
    //1.刷新头像
    headIconImgView.image = [Tool avatarImageWith:[CommParameter sharedInstance].avatar];
    // 刷新手机号
    headPhoneNoLab.text = [CommParameter sharedInstance].userName;
    
    //2.刷新 moneyBtn 金额信息
    //获取且拼装金额数据
    NSDictionary *ownPayToolDic = [Tool getPayToolsInfo:[CommParameter sharedInstance].ownPayToolsArray];
    NSDictionary *sandWalletDic = [ownPayToolDic objectForKey:@"sandWalletDic"];
    NSString *moneyStr = [[sandWalletDic objectForKey:@"account"] objectForKey:@"balance"];
    moneyStr = [NSString stringWithFormat:@"%.2f",[moneyStr floatValue]/100];
    NSString *moneyMidStr = [moneyStr substringToIndex:(moneyStr.length - 3)];
    NSString *moneyRightStr = [moneyStr substringFromIndex:(moneyStr.length - 3)];
    if ([moneyStr floatValue] == 0) {
        moneyMidStr = @"0";
        moneyRightStr = @".00";
    }
    moneyBtnMidLab.text = moneyMidStr;
    moneyBtnRightLab.text = moneyRightStr;
    
    //中间金额模块约束重置
    CGSize moneyBtnMidLabSize = [moneyBtnMidLab sizeThatFits:CGSizeZero];
    CGSize moneyBtnRightLabSize = [moneyBtnRightLab sizeThatFits:CGSizeZero];
    
    CGFloat upLabWidth = (moneyBtnLeftLab.width + moneyBtnMidLabSize.width + moneyBtnRightLabSize.width);
    CGFloat bottomLabWidth = moneyBtnBottomLab.width;
    moneyBtn.width = upLabWidth>bottomLabWidth?upLabWidth:bottomLabWidth;
    
    [moneyBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(headIconImgView.mas_bottom).offset(UPDOWNSPACE_05);
        make.centerX.equalTo(headView.mas_centerX);
        make.size.mas_equalTo(CGSizeMake(moneyBtn.width, payBtn.height));
    }];
    
    [moneyBtnLeftLab mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(moneyBtn.mas_top).offset(UPDOWNSPACE_05);
        if (upLabWidth>bottomLabWidth) {
            make.left.equalTo(moneyBtn.mas_left);
        }else{
            make.left.equalTo(moneyBtn.mas_left).offset((bottomLabWidth-upLabWidth)/2);
        }
        make.size.mas_equalTo(moneyBtnLeftLab.size);
    }];
    
    [moneyBtnMidLab mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(moneyBtn.mas_top);
        make.left.equalTo(moneyBtnLeftLab.mas_right);
        make.size.mas_equalTo(moneyBtnMidLabSize);
    }];
    
    [moneyBtnRightLab mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(moneyBtn.mas_top).offset(UPDOWNSPACE_05);
        make.left.equalTo(moneyBtnMidLab.mas_right);
        make.size.mas_equalTo(moneyBtnRightLabSize);
    }];
}
#pragma mark 通知左侧边栏刷新用户信息UI
- (void)postNotifactionToLeftSideMenuWithUserInfoRefrush{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"User_Info_Changed" object:nil];
}

@end
