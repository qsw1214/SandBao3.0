//
//  LeftSideMenuViewController.m
//  sandbao
//
//  Created by tianNanYiHao on 2017/10/26.
//  Copyright © 2017年 sand. All rights reserved.
//

#import "LeftSideMenuViewController.h"
#import "PayNucHelper.h"

#import "LunchGuideViewController.h"

#import "LoginViewController.h"
#import "MyCenterViewController.h"
#import "HomeViewController.h"
#import "MyBillViewController.h"
#import "WalletAccountViewController.h"
#import "SandPointsViewController.h"
#import "FinancicleCenterViewController.h"
#import "BankCardViewController.h"
#import "SandCardViewController.h"
#import "SetViewController.h"
#import "LoginViewController.h"



/**
 左边栏控制器:由于使用RESideMenu之后的present以及dismiss均交由RESideMenu控制,因此本控制器仅加载一次.
 */
@interface LeftSideMenuViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    
    //HeadView
    UIView *headView;
    
    //tableView
    UITableView *tableview;
    
    //logOutbtn
    UIButton *logOutbtn;
    
    //数据源
    NSArray *dataArray;
    
    //头像
    UIImageView *headImgView;
    
    //用户名lab
    UILabel *nickNameLab;
    
    //实名认证图片标志
    UIImageView *realNameImgView;
    
    //去实名提示
    UILabel *realNameLab;
    
}
@property (nonatomic, strong) MyCenterViewController         *myCenterVC;
@property (nonatomic, strong) HomeViewController             *homeVC;
@property (nonatomic, strong) MyBillViewController           *myBillVC;
@property (nonatomic, strong) WalletAccountViewController    *walletAccVC;
@property (nonatomic, strong) SandPointsViewController       *sandPointVC;
@property (nonatomic, strong) FinancicleCenterViewController *financicleVC;
@property (nonatomic, strong) BankCardViewController         *bankCardVC;
@property (nonatomic, strong) SandCardViewController         *sandCardVC;
@property (nonatomic, strong) SetViewController              *setVC;


@property (nonatomic, strong) UINavigationController *myCenterNav;
@property (nonatomic, strong) UINavigationController *homeNav;
@property (nonatomic, strong) UINavigationController *myBillNav;
@property (nonatomic, strong) UINavigationController *walletAccNav;
@property (nonatomic, strong) UINavigationController *sandPointNav;
@property (nonatomic, strong) UINavigationController *financicleNav;
@property (nonatomic, strong) UINavigationController *bankCardNav;
@property (nonatomic, strong) UINavigationController *sandCardNav;
@property (nonatomic, strong) UINavigationController *setNav;


@end

@implementation LeftSideMenuViewController

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
    //重置baseScrollview的Contentsize
    [self setBaseScrollViewContentSize];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];

    //加载子控制器
    [self addSubViewController];
    
    //增加监听
    //监听决定明暗登录的通知
    [self addNotifaction_Login];
    //监听用户信息变化
    [self addNotifaction_UserInfo];
    //监听昵称变化
    [self addNotifaction_NickName];
    //监听头像变化
    [self addNotifaction_avatar];
    //监听OtherAppOpen启动 - 当杉德宝已启动+已登陆
    [self addNotifaction_otherAppOpen];
    
    //加载UI
    [self createUI_headView];
    [self createUI_tableView];
    [self createUI_LogOutView];
}


#pragma mark - 重写父类-baseScrollView设置
- (void)setBaseScrollview{
    [super setBaseScrollview];
    
    //重置frame.width
    CGFloat leftSideWidth = SCREEN_WIDTH * (1-0.258);
    self.baseScrollView.frame = CGRectMake(0, UPDOWNSPACE_0, leftSideWidth, SCREEN_HEIGHT);
}
#pragma mark - 重写父类-导航设置方法
- (void)setNavCoverView{
    [super setNavCoverView];
    self.navCoverView.hidden = YES;
}
#pragma mark - 重写父类-点击方法集合
- (void)buttonClick:(UIButton *)btn{
    
    //退出
    if (btn.tag == BTN_TAG_LOGOUT) {
        [self loginOut];
        //友盟自定义时间统计 - 计数事件
        [MobClick event:UM_Logout];
    }
    //个人信息
    if (btn.tag == BTN_TAG_JUSTCLICK) {
        //重置RESdieMeun的主控制器
        [self.sideMenuViewController setContentViewController:self.myCenterNav];
        //隐藏Menu控制器
        [self.sideMenuViewController hideMenuViewController];
    }
    
}

- (void)addSubViewController{
    
    self.myCenterVC = [[MyCenterViewController alloc] init];
    self.homeVC = [[HomeViewController alloc] init];
    self.myBillVC = [[MyBillViewController alloc] init];
    self.walletAccVC = [[WalletAccountViewController alloc] init];
    self.sandPointVC = [[SandPointsViewController alloc] init];
    self.financicleVC = [[FinancicleCenterViewController alloc] init];
    self.bankCardVC = [[BankCardViewController alloc] init];
    self.sandCardVC = [[SandCardViewController alloc] init];
    self.setVC = [[SetViewController alloc] init];
    
    self.myCenterNav = [[UINavigationController alloc] initWithRootViewController:self.myCenterVC];
    self.homeNav = [[UINavigationController alloc] initWithRootViewController:self.homeVC];
    self.myBillNav = [[UINavigationController alloc] initWithRootViewController:self.myBillVC];
    self.walletAccNav = [[UINavigationController alloc] initWithRootViewController:self.walletAccVC];
    self.sandPointNav = [[UINavigationController alloc] initWithRootViewController:self.sandPointVC];
    self.financicleNav = [[UINavigationController alloc] initWithRootViewController:self.financicleVC];
    self.bankCardNav = [[UINavigationController alloc] initWithRootViewController:self.bankCardVC];
    self.sandCardNav = [[UINavigationController alloc] initWithRootViewController:self.sandCardVC];
    self.setNav = [[UINavigationController alloc] initWithRootViewController:self.setVC];
    
    //全局变量存储所需要的 带导航视图控制器
    [CommParameter sharedInstance].myCenterNav = self.myCenterNav;
    [CommParameter sharedInstance].homeNav = self.homeNav;
    [CommParameter sharedInstance].myBillNav = self.myBillNav;
    [CommParameter sharedInstance].walletAccNav = self.walletAccNav;
    [CommParameter sharedInstance].sandPointNav = self.sandPointNav;
    [CommParameter sharedInstance].financicleNav = self.financicleNav;
    [CommParameter sharedInstance].bankCardNav = self.bankCardNav;
    [CommParameter sharedInstance].sandCardNav = self.sandCardNav;
    [CommParameter sharedInstance].setNav = self.setNav;
}

#pragma mark  - UI绘制
- (void)createUI_headView{

    //HeadView
    headView = [[UIView alloc] init];
    [self.baseScrollView addSubview:headView];
    
    //headImgView
    CGFloat headImgViewWH = LEFTRIGHTSPACE_80;
    UIImage *headImg = [UIImage imageNamed:@"center_profile_avatar"];
    headImgView = [Tool createImagView:headImg];
    headImgView.layer.cornerRadius = headImgViewWH/2;
    headImgView.layer.masksToBounds = YES;
    headImgView.userInteractionEnabled = YES;
    [headView addSubview:headImgView];
    
    //headCoverBtn:头像按钮上的透明按钮
    UIButton *headCoverBtn = [Tool createButton:nil attributeStr:nil font:nil textColor:nil];
    headCoverBtn.backgroundColor = [UIColor clearColor];
    headCoverBtn.tag = BTN_TAG_JUSTCLICK;
    headCoverBtn.frame = CGRectMake(0, 0, headImgViewWH, headImgViewWH);
    [headCoverBtn addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    [headImgView addSubview:headCoverBtn];
    
    
    //titleLab
    nickNameLab = [Tool createLable:@"1515****388" attributeStr:nil font:(SCREEN_WIDTH == SCREEN_WIDTH_320?FONT_14_Regular:FONT_16_Regular) textColor:COLOR_343339 alignment:NSTextAlignmentLeft];
    [headView addSubview:nickNameLab];
    
    //realNameImgView
    UIImage *realNameImg = [UIImage imageNamed:@"center_profile_card"];
    realNameImgView = [Tool createImagView:realNameImg];
    [headView addSubview:realNameImgView];
    
    //realNameLab
    realNameLab = [Tool createLable:@"去实名认证" attributeStr:nil font:(SCREEN_WIDTH == SCREEN_WIDTH_320?FONT_10_Regular:FONT_12_Regular) textColor:COLOR_FF5D31 alignment:NSTextAlignmentLeft];
    [headView addSubview:realNameLab];
    
    
    //rightArrowBtn
    UIButton *rightArrowBtn = [[UIButton alloc] init];
    UIImage *rightArrowImg = [UIImage imageNamed:@"center_profile_arror_right"];
    rightArrowBtn.size = rightArrowImg.size;
    [rightArrowBtn setBackgroundImage:rightArrowImg forState:UIControlStateNormal];
    [headView addSubview:rightArrowBtn];
    
    
    
    
    [headView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.baseScrollView.mas_top).offset(UPDOWNSPACE_64);
        make.left.equalTo(self.baseScrollView.mas_left).offset(0);
        make.size.mas_equalTo(CGSizeMake(self.baseScrollView.width, headImgViewWH));
    }];
    
    [headImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(headView.mas_top).offset(UPDOWNSPACE_0);
        make.left.equalTo(self.baseScrollView.mas_left).offset(LEFTRIGHTSPACE_20);
        make.size.mas_equalTo(CGSizeMake(headImgViewWH, headImgViewWH));
    }];
    
    [nickNameLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(headView.mas_centerY).offset(- nickNameLab.height/2);
        make.left.equalTo(headImgView.mas_right).offset(LEFTRIGHTSPACE_15);
        make.size.mas_equalTo(CGSizeMake(self.baseScrollView.width - headImgViewWH - LEFTRIGHTSPACE_20-LEFTRIGHTSPACE_15, nickNameLab.height));
    }];
    
    [realNameImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(realNameLab.mas_centerY);
        make.left.equalTo(headImgView.mas_right).offset(LEFTRIGHTSPACE_15);
        make.size.mas_equalTo(realNameImgView.size);
    }];
    
    [realNameLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(headView.mas_centerY).offset(realNameLab.height/2);
        make.left.equalTo(realNameImgView.mas_right).offset(LEFTRIGHTSPACE_04);
        make.size.mas_equalTo(realNameLab.size);
    }];
    

    [rightArrowBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(headView.mas_centerY);
        make.right.equalTo(headView.mas_right).offset(-LEFTRIGHTSPACE_20);
        make.size.mas_equalTo(rightArrowBtn.size);
    }];
    
}

- (void)createUI_tableView{
    //tableView
    tableview = [[UITableView alloc] init];
    
    tableview.delegate = self;
    tableview.dataSource = self;
    tableview.scrollEnabled = NO;
    tableview.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.baseScrollView addSubview:tableview];
    
    
    NSURL *setPlistDataPath = [[NSBundle mainBundle] URLForResource:@"leftMenu" withExtension:@"plist"];
    NSArray *arrar = [NSArray arrayWithContentsOfURL:setPlistDataPath];
    dataArray = arrar;
    CGFloat tableViewH = UPDOWNSPACE_52 * dataArray.count;
    
    UIView *line = [[UIView alloc] init];
    line.backgroundColor = COLOR_A1A2A5_3;
    [self.baseScrollView addSubview:line];
    
    
    [tableview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(headView.mas_bottom).offset(UPDOWNSPACE_25);
        make.left.equalTo(self.baseScrollView.mas_left).offset(LEFTRIGHTSPACE_09);
        make.size.mas_equalTo(CGSizeMake(self.baseScrollView.width-LEFTRIGHTSPACE_09, tableViewH));
    }];
    
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(tableview.mas_bottom).offset(UPDOWNSPACE_10);
        make.left.equalTo(tableview.mas_left).offset(LEFTRIGHTSPACE_15);
        make.size.mas_equalTo(CGSizeMake(self.baseScrollView.width-LEFTRIGHTSPACE_25*2, 0.7));
    }];
    
}

- (void)createUI_LogOutView{

    logOutbtn = [[UIButton alloc] init];
    logOutbtn.tag = BTN_TAG_LOGOUT;
    [logOutbtn addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.baseScrollView addSubview:logOutbtn];
    
    UIImage *logOutImg = [UIImage imageNamed:@"center_menu_08"];
    UIImageView *logOutImgView = [[UIImageView alloc] initWithImage:logOutImg];
    [logOutbtn addSubview:logOutImgView];
    
    UILabel *titleLab = [Tool createLable:@"退出" attributeStr:nil font:FONT_15_Regular textColor:COLOR_000000 alignment:NSTextAlignmentLeft];
    [logOutbtn addSubview:titleLab];
    
    [logOutbtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.baseScrollView.mas_left);
        make.size.mas_equalTo(CGSizeMake(self.baseScrollView.width, logOutImg.size.height*2));
        make.bottom.equalTo(tableview.mas_bottom).offset(UPDOWNSPACE_100);
    }];
    
    [logOutImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(logOutbtn.mas_centerY);
        make.left.equalTo(logOutbtn.mas_left).offset(LEFTRIGHTSPACE_25);
        make.size.mas_equalTo(logOutImg.size);
    }];
    
    [titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(logOutbtn.mas_centerY);
        make.left.equalTo(logOutImgView.mas_right).offset(LEFTRIGHTSPACE_12);
        make.size.mas_equalTo(titleLab.size);
    }];
    

}

/**
 设置baseScrollview的滚动区间
 */
- (void)setBaseScrollViewContentSize{
    
    CGFloat allHeight = 0.f;
    
    UIView *lasetObjectView = self.baseScrollView.subviews.lastObject;
    
    CGFloat lasetObjectViewOY = CGRectGetMaxY(lasetObjectView.frame);
    
    allHeight = lasetObjectViewOY + UPDOWNSPACE_20;
    
    if (allHeight < SCREEN_HEIGHT - SafeAreaNavgationTop) {
        self.baseScrollView.contentSize = CGSizeMake(0, SCREEN_HEIGHT - SafeAreaNavgationTop);
    }else{
        self.baseScrollView.contentSize = CGSizeMake(0, allHeight);
    }
}

#pragma mark tableViewDelegate&&dataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return dataArray.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return UPDOWNSPACE_52;
}
- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    static NSString *cells = @"cells";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cells];
    
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cells];
    }
    NSDictionary *dict = dataArray[indexPath.row];
    cell.imageView.image = [UIImage imageNamed:[dict objectForKey:@"imgName"]];
    cell.textLabel.text = [dict objectForKey:@"title"];
    cell.textLabel.textColor = COLOR_000000;
    cell.textLabel.font = FONT_15_Regular;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSDictionary *dict = dataArray[indexPath.row];
    NSString *titleName = [dict objectForKey:@"title"];
    
    if ([titleName isEqualToString:@"我的账单"]) {
        //重置RESdieMeun的主控制器
        [self.sideMenuViewController setContentViewController:self.myBillNav];
        //隐藏Menu控制器
        [self.sideMenuViewController hideMenuViewController];
        //友盟自定义时间统计 - 计数事件
        [MobClick event:UM_Bill];
    }
    if ([titleName isEqualToString:@"钱包账户"]) {
        //重置RESdieMeun的主控制器
        [self.sideMenuViewController setContentViewController:self.walletAccNav];
        //隐藏Menu控制器
        [self.sideMenuViewController hideMenuViewController];
        //友盟自定义时间统计 - 计数事件
        [MobClick event:UM_Wallet];
    }
    if ([titleName isEqualToString:@"杉德积分"]) {
        //重置RESdieMeun的主控制器
        [self.sideMenuViewController setContentViewController:self.sandPointNav];
        //隐藏Menu控制器
        [self.sideMenuViewController hideMenuViewController];
        //友盟自定义时间统计 - 计数事件
        [MobClick event:UM_Sandpoint];
    }
    if ([titleName isEqualToString:@"理财中心"]) {
        //重置RESdieMeun的主控制器
        [SDMBProgressView showSDMBProgressNormalINView:self.view lableText:@"努力开发中..."];
        /** 点击进入理财 - 暂时屏蔽
        [self.sideMenuViewController setContentViewController:self.financicleNav];
        //隐藏Menu控制器
        [self.sideMenuViewController hideMenuViewController];
         */
        //友盟自定义时间统计 - 计数事件
        [MobClick event:UM_Financial];
    }
    if ([titleName isEqualToString:@"银行卡"]) {
        //重置RESdieMeun的主控制器
        [self.sideMenuViewController setContentViewController:self.bankCardNav];
        //隐藏Menu控制器
        [self.sideMenuViewController hideMenuViewController];
        //友盟自定义时间统计 - 计数事件
        [MobClick event:UM_BankCard];
    }
    if ([titleName isEqualToString:@"卡券包"]) {
        //重置RESdieMeun的主控制器
        [self.sideMenuViewController setContentViewController:self.sandCardNav];
        //隐藏Menu控制器
        [self.sideMenuViewController hideMenuViewController];
        //友盟自定义时间统计 - 计数事件
        [MobClick event:UM_SandCard];
    }
    if ([titleName isEqualToString:@"设置"]) {
        //重置RESdieMeun的主控制器
        [self.sideMenuViewController setContentViewController:self.setNav];
        //隐藏Menu控制器
        [self.sideMenuViewController hideMenuViewController];
        //友盟自定义时间统计 - 计数事件
        [MobClick event:UM_Setting];
    }
}




#pragma mark - 业务逻辑
#pragma mark 明登陆

- (void)pwdLogin{
    [Tool setContentViewControllerWithLoginFromSideMentuVIewController:self forLogOut:NO];
}
#pragma mark 暗登陆
- (void)noPwdLogin{
    
    [[SDRequestHelp shareSDRequest] dispatchGlobalQuque:^{
        __block BOOL error = NO;
        
        NSMutableDictionary *userInfoDic = [SDSqlite selectOneData:[SqliteHelper shareSqliteHelper].sandBaoDB tableName:@"usersconfig" columnArray:USERSCONFIG_ARR whereColumnString:@"active" whereParamString:@"0"];
        //2.1 暗登陆 -从数据库获取sTokey
        [CommParameter sharedInstance].sToken = [userInfoDic objectForKey:@"sToken"];
        NSString *creditFp = [userInfoDic objectForKey:@"credit_fp"];
        
        paynuc.set("sToken", [[CommParameter sharedInstance].sToken UTF8String]);
        paynuc.set("creditFp", [creditFp UTF8String]);
        paynuc.set("tTokenType", "01001401");
        paynuc.set("cfg_termFp", [[Tool setCfgTempFpStaticDataFlag:NO DynamicDataFlag:YES] UTF8String]);
        [[SDRequestHelp shareSDRequest] closedRespCpdeErrorAutomatic];
        [[SDRequestHelp shareSDRequest] requestWihtFuncName:@"token/getTtoken/v1" errorBlock:^(SDRequestErrorType type) {
            error = YES;
            [[SDRequestHelp shareSDRequest] dispatchToMainQueue:^{
                [[SDRequestHelp shareSDRequest] openRespCpdeErrorAutomatic];
                if (type == frErrorType) {
                    //2.2 数据库中sToken失效/查询用户tToken获取失败 -> 明登陆
                    [self pwdLogin];
                }
                if (type == respCodeErrorType) {
                    //2.2 数据库中sToken失效/查询用户tToken获取失败 -> 明登陆
                    [self pwdLogin];
                }
            }];
        } successBlock:^{
            [[SDRequestHelp shareSDRequest] dispatchToMainQueue:^{
                [[SDRequestHelp shareSDRequest] openRespCpdeErrorAutomatic];
            }];
        }];
        if (error) return;
        
        [[SDRequestHelp shareSDRequest] closedRespCpdeErrorAutomatic];
        [[SDRequestHelp shareSDRequest] requestWihtFuncName:@"user/queryInfo/v1" errorBlock:^(SDRequestErrorType type) {
            error = YES;
            [[SDRequestHelp shareSDRequest] dispatchToMainQueue:^{
                [[SDRequestHelp shareSDRequest] openRespCpdeErrorAutomatic];
                if (type == frErrorType) {
                    //2.3 查询用户信息失败/查询用户信息失败  - > 直接明登陆
                    [self pwdLogin];
                }
                if (type == respCodeErrorType) {
                    //2.3 查询用户信息失败/查询用户信息失败  - > 直接明登陆
                    [self pwdLogin];
                }
            }];
        } successBlock:^{
            [[SDRequestHelp shareSDRequest] dispatchToMainQueue:^{
                [[SDRequestHelp shareSDRequest] openRespCpdeErrorAutomatic];
                
                //3. 暗登陆成功
                //更新用户数据信息
                [Tool refreshUserInfo:[NSString stringWithUTF8String:paynuc.get("userInfo").c_str()]];
                //更新用户数据库
                [self updateUserData];
            }];
        }];
        if (error) return;
    }];
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
        paynuc.set("cfg_termFp", [[Tool setCfgTempFpStaticDataFlag:NO DynamicDataFlag:YES] UTF8String]);
        [[SDRequestHelp shareSDRequest] closedRespCpdeErrorAutomatic];
        [[SDRequestHelp shareSDRequest] requestWihtFuncName:@"token/getTtoken/v1" errorBlock:^(SDRequestErrorType type) {
            error = YES;
            [[SDRequestHelp shareSDRequest] dispatchToMainQueue:^{
                [[SDRequestHelp shareSDRequest] openRespCpdeErrorAutomatic];
                if (type == respCodeErrorType) {
                    [[SDAlertView shareAlert] showDialog:@"网络连接失败,请退出重试" defulBlock:^{
                        [Tool exitApplication:self];
                    }];
                }else{
                    [[SDAlertView shareAlert] showDialog:@"网络连接超时,请退出重试" defulBlock:^{
                        [Tool exitApplication:self];
                    }];
                }
            }];
        } successBlock:^{
            [[SDRequestHelp shareSDRequest] dispatchToMainQueue:^{
                [[SDRequestHelp shareSDRequest] openRespCpdeErrorAutomatic];
            }];
        }];
        if (error) return;
        
        
        paynuc.set("payToolKinds", "[]");
        [[SDRequestHelp shareSDRequest] closedRespCpdeErrorAutomatic];
        [[SDRequestHelp shareSDRequest] requestWihtFuncName:@"payTool/getOwnPayTools/v1" errorBlock:^(SDRequestErrorType type) {
            error = YES;
            [[SDRequestHelp shareSDRequest] dispatchToMainQueue:^{
                [[SDRequestHelp shareSDRequest] openRespCpdeErrorAutomatic];
                if (type == respCodeErrorType) {
                    [[SDAlertView shareAlert] showDialog:@"加载支付工具失败,请退出重试" defulBlock:^{
                        [Tool exitApplication:self];
                    }];
                }else{
                    [[SDAlertView shareAlert] showDialog:@"网络连接超时,请退出重试" defulBlock:^{
                        [Tool exitApplication:self];
                    }];
                }
            }];
        } successBlock:^{
            [[SDRequestHelp shareSDRequest] dispatchToMainQueue:^{
                [[SDRequestHelp shareSDRequest] openRespCpdeErrorAutomatic];
                [self.HUD hidden];
                
                NSArray *payToolsArray = [[PayNucHelper sharedInstance] jsonStringToArray:[NSString stringWithUTF8String:paynuc.get("payTools").c_str()]];
                //根据order 字段排序
                payToolsArray = [Tool orderForPayTools:payToolsArray];
                [CommParameter sharedInstance].ownPayToolsArray = payToolsArray;
                
                //MQTT登录
                [[SDMQTTManager shareMQttManager] loginMQTT:[CommParameter sharedInstance].sToken];
                
                //暗登陆成功
                //刷新UI数据
                [self refreshUI];
                //归位Home或SpsLunch
                [Tool setContentViewControllerWithHomeOrSpsLunchFromSideMenuViewController:self.sideMenuViewController];
            }];
        }];
        if (error) return;
        
    }];
}







#pragma mark 登出
/**
 *@brief 登出
 */
- (void)loginOut
{
    self.HUD = [SDMBProgressView showSDMBProgressOnlyLoadingINViewImg:self.view];
    [SDRequestHelp shareSDRequest].HUD = self.HUD;
    [SDRequestHelp shareSDRequest].controller = self;
    [[SDRequestHelp shareSDRequest] dispatchGlobalQuque:^{
        __block BOOL error = NO;
        paynuc.set("tTokenType", "01000301");
        paynuc.set("cfg_termFp", [[Tool setCfgTempFpStaticDataFlag:NO DynamicDataFlag:YES] UTF8String]);
        [[SDRequestHelp shareSDRequest] requestWihtFuncName:@"token/getTtoken/v1" errorBlock:^(SDRequestErrorType type) {
            error = YES;
        } successBlock:^{
            
        }];
        if (error) return ;
        
        
        [[SDRequestHelp shareSDRequest] requestWihtFuncName:@"user/logout/v1" errorBlock:^(SDRequestErrorType type) {
            error = YES;
        } successBlock:^{
            [[SDRequestHelp shareSDRequest] dispatchToMainQueue:^{
                [self.HUD hidden];
                //1. 退出成功 - 滚动到顶部
                [self.baseScrollView setContentOffset:CGPointMake(0, 0)];
                //2. 退出成功 - 归位到login页
                [Tool setContentViewControllerWithLoginFromSideMentuVIewController:self forLogOut:YES];
            }];
        }];
        if (error) return ;
        
    }];
}


#pragma mark - 本类公共方法调用
#pragma mark 决定明暗登录的通知
- (void)addNotifaction_Login{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(Applogin:) name:LOGINWAYNOTICE object:nil];
}
#pragma mark 用户信息变化监听
- (void)addNotifaction_UserInfo{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshUI) name:@"User_Info_Changed" object:nil];
}
#pragma mark 昵称变化监听
//昵称接受通知
- (void)addNotifaction_NickName{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshUI) name:@"Nick_Name_Changed" object:nil];
}
#pragma mark 头像变化监听
- (void)addNotifaction_avatar{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshUI) name:@"Avatar_Changed" object:nil];
}
#pragma mark 监听OtherAppOpen启动
- (void)addNotifaction_otherAppOpen{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(openSpsLunch:) name:OPEN_SPSPAY_NOTIFACTION_STATE_LOGIN object:nil];
}

#pragma mark 明暗登录
- (void)Applogin:(NSNotification*)noti{
    //明暗登录类型
    NSString *type = noti.object;
    
    //如果未登录情况,进行明暗登录操作
    if ([CommParameter sharedInstance].userInfo.length == 0) {
        
        [[SDRequestHelp shareSDRequest] dispatchGlobalQuque:^{
            //查询活跃状态用户数量(1且只能为1)
            long count = [SDSqlite getCount:[SqliteHelper shareSqliteHelper].sandBaoDB sql:[NSString stringWithFormat:@"select count(*) from usersconfig where active = '%@'", @"0"]];
            //1.明登录
            if (count <= 0 && [type isEqualToString:@"PWD_LOGIN"])
            {
                //第一次安装 - 明登陆
                if (![[NSUserDefaults standardUserDefaults] objectForKey:FIRST_INSTALL_APP]) {
                    [[SDRequestHelp shareSDRequest] dispatchToMainQueue:^{
                        LunchGuideViewController *lunchGuideVC = [[LunchGuideViewController alloc] init];
                        [self.sideMenuViewController setContentViewController:lunchGuideVC];
                    }];
                }else{
                    //常规 - 明登陆
                    [[SDRequestHelp shareSDRequest] dispatchToMainQueue:^{
                        [self pwdLogin];
                    }];
                }
            }
            //2.暗登陆
            else
            {
                [[SDRequestHelp shareSDRequest] dispatchToMainQueue:^{
                    //暗登陆成 - 切换到首页
                    [self noPwdLogin];
                }];
            }
        }];
    }
}

#pragma mark 刷新用户信息
- (void)refreshUI{
    
    //0.刷新用户名(用户手机号)
    nickNameLab.text = [CommParameter sharedInstance].userName;
    
    //1.刷新头像数据
    headImgView.image = [Tool avatarImageWith:[CommParameter sharedInstance].avatar];
    
    //2.刷新实名认证FLag
    if ([CommParameter sharedInstance].realNameFlag == NO) {
        realNameImgView.image = [UIImage imageNamed:@"center_profile_card"];
        realNameLab.text = @"未实名认证";
        realNameLab.textColor = COLOR_FF5D31;
        realNameLab.layer.cornerRadius = 0.f;
        realNameLab.layer.borderColor = COLOR_000000.CGColor;
        realNameLab.layer.borderWidth = 0.f;
    }else{
        realNameImgView.image = [UIImage imageNamed:@"center_profile_card_RealName"];
        //3.昵称刷新
        if ([CommParameter sharedInstance].nick.length>0) {
            realNameLab.text = [CommParameter sharedInstance].nick;
            realNameLab.textColor = COLOR_343339;
            realNameLab.layer.borderWidth = 0.f;
        }else{
            realNameLab.text = @"已实名认证";
            realNameLab.textColor = COLOR_74D478;
            realNameLab.layer.cornerRadius = 1.5f;
            realNameLab.layer.borderColor = COLOR_74D478.CGColor;
            realNameLab.layer.borderWidth = 0.5f;
        }
    }
}
#pragma mark 第三方App起动sps支付
- (void)openSpsLunch:(NSNotification*)noti{
    
    //App从后台激活,进入前台,接受通知后,当前页面归位到spsLunch页
    //归位Home或SpsLunch
    [Tool setContentViewControllerWithHomeOrSpsLunchFromSideMenuViewController:self.sideMenuViewController];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc{
    
    //App结束,清除通知
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
}

@end
