//
//  LeftSideMenuViewController.m
//  sandbao
//
//  Created by tianNanYiHao on 2017/10/26.
//  Copyright © 2017年 sand. All rights reserved.
//

#import "LeftSideMenuViewController.h"
#import "PayNucHelper.h"



#import "MainViewController.h"
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
}

@property (nonatomic, strong) MainViewController             *mainVC;
@property (nonatomic, strong) MyBillViewController           *myBillVC;
@property (nonatomic, strong) WalletAccountViewController    *walletAccVC;
@property (nonatomic, strong) SandPointsViewController       *sandPointVC;
@property (nonatomic, strong) FinancicleCenterViewController *financicleVC;
@property (nonatomic, strong) BankCardViewController         *bankCardVC;
@property (nonatomic, strong) SandCardViewController         *sandCardVC;
@property (nonatomic, strong) SetViewController              *setVC;

@property (nonatomic, strong) UINavigationController *mainNav;
@property (nonatomic, strong) UINavigationController *myBillNav;
@property (nonatomic, strong) UINavigationController *walletAccNav;
@property (nonatomic, strong) UINavigationController *sandPointNav;
@property (nonatomic, strong) UINavigationController *financicleNav;
@property (nonatomic, strong) UINavigationController *bankCardNav;
@property (nonatomic, strong) UINavigationController *sandCardNav;
@property (nonatomic, strong) UINavigationController *setNav;


@end

@implementation LeftSideMenuViewController


- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    //用户退出后再登陆需刷新数据
    
    
    
}
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
    self.baseScrollView.frame = CGRectMake(0, UPDOWNSPACE_20, leftSideWidth, SCREEN_HEIGHT-UPDOWNSPACE_20);
    
}
#pragma mark - 重写父类-导航设置方法
- (void)setNavCoverView{
    [super setNavCoverView];
    self.navCoverView.hidden = YES;
}
#pragma mark - 重写父类-点击方法集合
- (void)buttonClick:(UIButton *)btn{
    
    if (btn.tag == BTN_TAG_LOGOUT) {

        [self loginOut];
    }
    
}

- (void)addSubViewController{
    self.mainVC = [[MainViewController alloc] init];
    self.myBillVC = [[MyBillViewController alloc] init];
    self.walletAccVC = [[WalletAccountViewController alloc] init];
    self.sandPointVC = [[SandPointsViewController alloc] init];
    self.financicleVC = [[FinancicleCenterViewController alloc] init];
    self.bankCardVC = [[BankCardViewController alloc] init];
    self.sandCardVC = [[SandCardViewController alloc] init];
    self.setVC = [[SetViewController alloc] init];
    
    self.mainNav = [[UINavigationController alloc] initWithRootViewController:self.mainVC];
    self.myBillNav = [[UINavigationController alloc] initWithRootViewController:self.myBillVC];
    self.walletAccNav = [[UINavigationController alloc] initWithRootViewController:self.walletAccVC];
    self.sandPointNav = [[UINavigationController alloc] initWithRootViewController:self.sandPointVC];
    self.financicleNav = [[UINavigationController alloc] initWithRootViewController:self.financicleVC];
    self.bankCardNav = [[UINavigationController alloc] initWithRootViewController:self.bankCardVC];
    self.sandCardNav = [[UINavigationController alloc] initWithRootViewController:self.sandCardVC];
    self.setNav = [[UINavigationController alloc] initWithRootViewController:self.setVC];
    
    
}

#pragma mark  - UI绘制
- (void)createUI_headView{

    //HeadView
    headView = [[UIView alloc] init];
    [self.baseScrollView addSubview:headView];
    
    
    UIImage *headImg = [UIImage imageNamed:@"center_profile_avatar"];
    
    UIImageView *headImgView = [Tool createImagView:headImg];
    [headView addSubview:headImgView];
    
    UILabel *titleLab = [Tool createLable:@"1515****388" attributeStr:nil font:FONT_13_OpenSan textColor:COLOR_343339 alignment:NSTextAlignmentCenter];
    [headView addSubview:titleLab];
    
    UIImage *realNameImg = [UIImage imageNamed:@"center_profile_card"];
    UIImageView *realNameImgView = [Tool createImagView:realNameImg];
    [headView addSubview:realNameImgView];
    
    UILabel *realNameLab = [Tool createLable:@"去实名认证" attributeStr:nil font:FONT_08_Regular textColor:COLOR_FF5D31 alignment:NSTextAlignmentCenter];
    [headView addSubview:realNameLab];
    
    UIButton *couponBtn = [Tool createButton:@"小白积分2000 >" attributeStr:nil font:FONT_08_Regular textColor:COLOR_FFFFFF];
    couponBtn.layer.masksToBounds = YES;
    couponBtn.backgroundColor = COLOR_58A5F6;
    couponBtn.width += LEFTRIGHTSPACE_04;
    couponBtn.height -= UPDOWNSPACE_10;
    couponBtn.layer.cornerRadius = couponBtn.height/2;
    [headView addSubview:couponBtn];
    
    UIButton *accountBtn = [Tool createButton:@"开通辅助账户 >" attributeStr:nil font:FONT_08_Regular textColor:COLOR_58A5F6];
    accountBtn.layer.masksToBounds = YES;
    accountBtn.layer.borderColor = COLOR_58A5F6.CGColor;
    accountBtn.layer.borderWidth = 1.f;
    accountBtn.width += LEFTRIGHTSPACE_04;
    accountBtn.height -= UPDOWNSPACE_10;
    accountBtn.layer.cornerRadius = accountBtn.height/2;
    [headView addSubview:accountBtn];
    
    
    UIButton *rightArrowBtn = [[UIButton alloc] init];
    UIImage *rightArrowImg = [UIImage imageNamed:@"center_profile_arror_right"];
    rightArrowBtn.size = rightArrowImg.size;
    [rightArrowBtn setBackgroundImage:rightArrowImg forState:UIControlStateNormal];
    [headView addSubview:rightArrowBtn];
    
    
    [headView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.baseScrollView.mas_top).offset(UPDOWNSPACE_64);
        make.left.equalTo(self.baseScrollView.mas_left).offset(0);
        make.size.mas_equalTo(CGSizeMake(self.baseScrollView.width, headImg.size.height));
    }];
    
    [headImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(headView.mas_top).offset(UPDOWNSPACE_0);
        make.left.equalTo(self.baseScrollView.mas_left).offset(LEFTRIGHTSPACE_20);
        make.size.mas_equalTo(headImgView.size);
    }];
    
    [titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(headView.mas_top).offset(UPDOWNSPACE_0);
        make.left.equalTo(headImgView.mas_right).offset(LEFTRIGHTSPACE_15);
        make.size.mas_equalTo(titleLab.size);
    }];
    
    [realNameImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(titleLab.mas_bottom).offset(UPDOWNSPACE_09);
        make.left.equalTo(headImgView.mas_right).offset(LEFTRIGHTSPACE_15);
        make.size.mas_equalTo(realNameImgView.size);
    }];
    
    [realNameLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(titleLab.mas_bottom).offset(UPDOWNSPACE_09);
        make.left.equalTo(realNameImgView.mas_right).offset(LEFTRIGHTSPACE_09);
        make.size.mas_equalTo(realNameLab.size);
    }];
    
    [couponBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(realNameLab.mas_bottom).offset(UPDOWNSPACE_09);
        make.left.equalTo(headImgView.mas_right).offset(LEFTRIGHTSPACE_15);
        make.size.mas_equalTo(couponBtn.size);
    }];
    
    [accountBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(realNameLab.mas_bottom).offset(UPDOWNSPACE_09);
        make.left.equalTo(couponBtn.mas_right).offset(LEFTRIGHTSPACE_09);
        make.size.mas_equalTo(accountBtn.size);
    }];
    
    if (SCREEN_WIDTH == SCREEN_WIDTH_320) {
        [rightArrowBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(headView.mas_centerY);
            make.right.equalTo(headView.mas_right).offset(LEFTRIGHTSPACE_00);
            make.size.mas_equalTo(rightArrowBtn.size);
        }];
    }else{
        [rightArrowBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(headView.mas_centerY);
            make.right.equalTo(headView.mas_right).offset(-LEFTRIGHTSPACE_20);
            make.size.mas_equalTo(rightArrowBtn.size);
        }];
    }
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
    CGFloat tableViewH = UPDOWNSPACE_64 * dataArray.count;
    
    [tableview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(headView.mas_bottom).offset(UPDOWNSPACE_25);
        make.left.equalTo(self.baseScrollView.mas_left).offset(LEFTRIGHTSPACE_00);
        make.size.mas_equalTo(CGSizeMake(self.baseScrollView.width, tableViewH));
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
    
    UILabel *titleLab = [Tool createLable:@"退出" attributeStr:nil font:FONT_13_Regular textColor:COLOR_343339_7 alignment:NSTextAlignmentLeft];
    [logOutbtn addSubview:titleLab];
    
    [logOutbtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.baseScrollView.mas_left);
        make.size.mas_equalTo(CGSizeMake(self.baseScrollView.width, logOutImg.size.height*2));
        make.bottom.equalTo(tableview.mas_bottom).offset(UPDOWNSPACE_89);
    }];
    
    [logOutImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(logOutbtn.mas_centerY);
        make.left.equalTo(logOutbtn.mas_left).offset(LEFTRIGHTSPACE_20);
        make.size.mas_equalTo(logOutImg.size);
    }];
    
    [titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(logOutbtn.mas_centerY);
        make.left.equalTo(logOutImgView.mas_right).offset(LEFTRIGHTSPACE_04);
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
    
    if (allHeight < SCREEN_HEIGHT - UPDOWNSPACE_64) {
        self.baseScrollView.contentSize = CGSizeMake(0, SCREEN_HEIGHT - UPDOWNSPACE_64);
    }else{
        self.baseScrollView.contentSize = CGSizeMake(0, allHeight);
    }
}

#pragma mark tableViewDelegate&&dataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return dataArray.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return UPDOWNSPACE_64;
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
    cell.textLabel.textColor = COLOR_343339_7;
    cell.textLabel.font = FONT_15_Regular;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSDictionary *dict = dataArray[indexPath.row];
    NSString *titleName = [dict objectForKey:@"title"];

    
    if ([titleName isEqualToString:@"返回首页"]) {
        //重置RESdieMeun的主控制器
        [self.sideMenuViewController setContentViewController:self.mainNav];
    }
    if ([titleName isEqualToString:@"我的账单"]) {
        //重置RESdieMeun的主控制器
        [self.sideMenuViewController setContentViewController:self.myBillNav];
    }
    if ([titleName isEqualToString:@"钱包账户"]) {
        //重置RESdieMeun的主控制器
        [self.sideMenuViewController setContentViewController:self.walletAccNav];
    }
    if ([titleName isEqualToString:@"杉德积分"]) {
        //重置RESdieMeun的主控制器
        [self.sideMenuViewController setContentViewController:self.sandPointNav];
    }
    if ([titleName isEqualToString:@"理财中心"]) {
        //重置RESdieMeun的主控制器
        [self.sideMenuViewController setContentViewController:self.financicleNav];
    }
    if ([titleName isEqualToString:@"银行卡"]) {
        //重置RESdieMeun的主控制器
        [self.sideMenuViewController setContentViewController:self.bankCardNav];
    }
    if ([titleName isEqualToString:@"杉德卡"]) {
        //重置RESdieMeun的主控制器
        [self.sideMenuViewController setContentViewController:self.sandCardNav];
    }
    if ([titleName isEqualToString:@"设置"]) {
        //重置RESdieMeun的主控制器
        [self.sideMenuViewController setContentViewController:self.setNav];
    }
    
    //隐藏Menu控制器
    [self.sideMenuViewController hideMenuViewController];
    
}




#pragma mark - 业务逻辑
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
                
                //1.退出成功,回到MainVC
                [self.sideMenuViewController setContentViewController:self.mainNav];
                //2.隐藏Menu控制器
                [self.sideMenuViewController hideMenuViewController];
                //3.退出到登录界面
                [Tool presetnLoginVC:self.sideMenuViewController];
            }];
        }];
        if (error) return ;
        
    }];
}




- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
@end
