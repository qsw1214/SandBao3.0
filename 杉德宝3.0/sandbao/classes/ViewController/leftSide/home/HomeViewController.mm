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

#import "GradualView.h"
#import "SDMajletView.h"
@interface HomeViewController ()<MqttClientManagerDelegate,UICollectionViewDelegate,UICollectionViewDataSource>
{
    //headView
    GradualView *headView;
    UIView      *bodyViewOne;
    UIView      *bodyViewTwo;
    
    UIButton *payBtn;
    
    UIButton *moneyBtn;
    
    UILabel *moneyBtnLeftLab;
    
    UILabel *moneyBtnMidLab;
    
    UILabel *moneyBtnRightLab;
    
    UILabel *moneyBtnBottomLab;
    
    
}
@property (nonatomic, strong) NSMutableArray *sandServerArr; //杉德服务子件数组
@property (nonatomic, strong) NSMutableArray *limitServerArr; //限时服务子件数组
@end

@implementation HomeViewController

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    //允许RESideMenu的返回手势
    self.sideMenuViewController.panGestureEnabled = YES;
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
    //用户刷新数据信息
    [self refreshUI];
    
    //检测是否实名/设置支付密码
    [self checkRealNameOrSetPayPwd];
    
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
    [self create_bodyView];
    
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
    self.navCoverView.letfImgStr = @"index_avatar";
    self.navCoverView.rightImgStr = @"index_msg";
    [self.navCoverView appendRightItem:@"index_icon_phone"];
    __block HomeViewController *weakSelf = self;
    self.navCoverView.leftBlock = ^{
        
        [weakSelf presentLeftMenuViewController:weakSelf.sideMenuViewController];
    };
    //最右边按钮事件
    self.navCoverView.rightBlock = ^{
        //@"消息"
        
    };
    //右边第二个按钮事件(由右向左数)
    self.navCoverView.rightSecBlock = ^{
        //@"客服"
        [Tool showDialog:@"为您拨打客服热线" message:@"021-962567" leftBtnString:@"取消" rightBtnString:@"呼叫" leftBlock:^{
            
        } rightBlock:^{
             [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"tel:021-962567"]];
        }];
        
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
    payBtn = [Tool createButton:nil attributeStr:nil font:nil textColor:nil];
    [payBtn addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
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
    moneyBtn = [Tool createButton:nil attributeStr:nil font:nil textColor:nil];
    [moneyBtn addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    moneyBtn.tag = BTN_TAG_BLANCE;
    [self.baseScrollView addSubview:moneyBtn];
    
    moneyBtnLeftLab = [Tool createLable:@"¥" attributeStr:nil font:FONT_10_DINAlter textColor:COLOR_FFFFFF alignment:NSTextAlignmentCenter];
    [moneyBtn addSubview:moneyBtnLeftLab];

    moneyBtnMidLab = [Tool createLable:@"- -" attributeStr:nil font:FONT_36_DINAlter textColor:COLOR_FFFFFF alignment:NSTextAlignmentCenter];
    [moneyBtn addSubview:moneyBtnMidLab];
    
    moneyBtnRightLab = [Tool createLable:@".00" attributeStr:nil font:FONT_10_DINAlter textColor:COLOR_FFFFFF alignment:NSTextAlignmentCenter];
    [moneyBtn addSubview:moneyBtnRightLab];
    
    moneyBtnBottomLab = [Tool createLable:@"余额(元)" attributeStr:nil font:FONT_14_Regular textColor:COLOR_FFFFFF alignment:NSTextAlignmentCenter];
    [moneyBtn addSubview:moneyBtnBottomLab];
    
    CGFloat upLabWidth = (moneyBtnLeftLab.width + moneyBtnMidLab.width + moneyBtnRightLab.width);
    CGFloat bottomLabWidth = moneyBtnBottomLab.width;
    moneyBtn.width = upLabWidth>bottomLabWidth?upLabWidth:bottomLabWidth;
    
    [moneyBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(headView.mas_top).offset(UPDOWNSPACE_30);
        make.centerX.equalTo(headView.mas_centerX);
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
    
    
    //cardBag
    UIButton *cardBagBtn = [Tool createButton:nil attributeStr:nil font:nil textColor:nil];
    [cardBagBtn addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
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


- (void)create_bodyView{
    
    //杉德服务
    UILabel *sandServerLab = [Tool createLable:@"杉德服务" attributeStr:nil font:FONT_14_Regular textColor:COLOR_343339_7 alignment:NSTextAlignmentLeft];
    [self.baseScrollView addSubview:sandServerLab];
    
    
    //bodyViewOne
    bodyViewOne = [[UIView alloc] init];
    bodyViewOne.backgroundColor = COLOR_FFFFFF;
    [self.baseScrollView addSubview:bodyViewOne];
    
   
    //majletView
    SDMajletView *sandServerView = [SDMajletView createMajletViewOY:0];
    sandServerView.cellSpace = LEFTRIGHTSPACE_25;
    sandServerView.columnNumber = 4;
    sandServerView.majletArr = self.sandServerArr;
    sandServerView.titleNameBlock = ^(NSString *titleName) {
        [SDLog logTest:[NSString stringWithFormat:@"  titleName == %@",titleName]];
    };
    [bodyViewOne addSubview:sandServerView];
    
    [sandServerLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(headView.mas_bottom).offset(UPDOWNSPACE_10);
        make.left.equalTo(self.baseScrollView.mas_left).offset(LEFTRIGHTSPACE_15);
        make.size.mas_equalTo(sandServerLab.size);
    }];
    
    [bodyViewOne mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(sandServerLab.mas_bottom).offset(UPDOWNSPACE_10);
        make.centerX.equalTo(headView.mas_centerX);
        make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH, sandServerView.height));
    }];
    
    [sandServerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(bodyViewOne.mas_top).offset(UPDOWNSPACE_0);
        make.centerX.equalTo(headView.mas_centerX);
        make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH, sandServerView.height));
    }];
    
    
    
    //杉德服务
    UILabel *limitServerLab = [Tool createLable:@"限时服务" attributeStr:nil font:FONT_14_Regular textColor:COLOR_343339_7 alignment:NSTextAlignmentLeft];
    [self.baseScrollView addSubview:limitServerLab];
    
    //bodyViewTwo
    bodyViewTwo = [[UIView alloc] init];
    bodyViewTwo.backgroundColor = COLOR_FFFFFF;
    [self.baseScrollView addSubview:bodyViewTwo];
    
    //majletView
    SDMajletView *limitServerView = [SDMajletView createMajletViewOY:0];
    limitServerView.cellSpace = LEFTRIGHTSPACE_12;
    limitServerView.columnNumber = 3;
    limitServerView.majletArr = self.limitServerArr;
    limitServerView.titleNameBlock = ^(NSString *titleName) {
        [SDLog logTest:[NSString stringWithFormat:@"  titleName == %@",titleName]];
    };
    [bodyViewTwo addSubview:limitServerView];
    
    [limitServerLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(sandServerView.mas_bottom).offset(UPDOWNSPACE_0);
        make.left.equalTo(self.baseScrollView.mas_left).offset(LEFTRIGHTSPACE_15);
        make.size.mas_equalTo(limitServerLab.size);
    }];
    
    [bodyViewTwo mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(limitServerLab.mas_bottom).offset(UPDOWNSPACE_10);
        make.centerX.equalTo(headView.mas_centerX);
        make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH, limitServerView.height));
    }];
    
    [limitServerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(bodyViewTwo.mas_top).offset(UPDOWNSPACE_0);
        make.centerX.equalTo(headView.mas_centerX);
        make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH, limitServerView.height));
    }];
    
    
    
}

#pragma mark - 业务逻辑














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
                UINavigationController *realNameNav = [[UINavigationController alloc] initWithRootViewController:realName];
                [self presentViewController:realNameNav animated:YES completion:nil];
            } rightBlock:^{
                [Tool presetnLoginVC:self];
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
                [self.navigationController pushViewController:verifyTypeVC animated:YES];
            } rightBlock:^{
                [Tool presetnLoginVC:self];
            }];
        }
    }
}

#pragma mark 刷新用户信息
- (void)refreshUI{
    
    //1.刷新导航左边头像
    self.navCoverView.leftImg = [Tool avatarImageWith:[CommParameter sharedInstance].avatar];
    
    //2.刷新 moneyBtn 金额信息
    //获取金额数据
    NSDictionary *ownPayToolDic = [Tool getPayToolsInfo:[CommParameter sharedInstance].ownPayToolsArray];
    NSDictionary *sandWalletDic = [ownPayToolDic objectForKey:@"sandWalletDic"];
    NSString *moneyStr = [[sandWalletDic objectForKey:@"account"] objectForKey:@"balance"];
    moneyStr = [NSString stringWithFormat:@"%.2f",[moneyStr floatValue]/100];
    NSString *moneyMidStr = [moneyStr substringToIndex:(moneyStr.length - 3)];
    NSString *moneyRightStr = [moneyStr substringFromIndex:(moneyStr.length - 3)];
    
    moneyBtnMidLab.text = moneyMidStr;
    moneyBtnRightLab.text = moneyRightStr;
    
    CGSize moneyBtnMidLabSize = [moneyBtnMidLab sizeThatFits:CGSizeZero];
    CGSize moneyBtnRightLabSize = [moneyBtnRightLab sizeThatFits:CGSizeZero];
    
    CGFloat upLabWidth = (moneyBtnLeftLab.width + moneyBtnMidLabSize.width + moneyBtnRightLabSize.width);
    CGFloat bottomLabWidth = moneyBtnBottomLab.width;
    moneyBtn.width = upLabWidth>bottomLabWidth?upLabWidth:bottomLabWidth;
    
    [moneyBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(headView.mas_top).offset(UPDOWNSPACE_30);
        make.centerX.equalTo(headView.mas_centerX);
        make.size.mas_equalTo(CGSizeMake(moneyBtn.width, payBtn.height));
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


@end
