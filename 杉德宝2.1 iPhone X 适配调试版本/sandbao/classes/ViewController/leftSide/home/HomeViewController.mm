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
#import "SDMQTTManager.h"
#import "SDBannerView.h"

#import "GradualView.h"
#import "SDMajletView.h"
#import "SDDrowNoticeView.h"
#import "SDRechargePopView.h"
#import "BankCardTransferViewController.h"
#import "UserTransferBeginViewController.h"
#import "InviteViewController.h"


@interface HomeViewController ()<SDMQTTManagerDelegate,UICollectionViewDelegate,SDBannerViewDelegate>
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
    
    
    //bannerView
    SDBannerView *bannerView;
    
    //bodyViewOne
    UIView      *bodyViewOne;
    //bodyViewTwo
    UIView      *bodyViewTwo;
    
    
    //钱包账户_被转账_支付工具
    NSMutableDictionary *sandWalletDic;
    
    
}
@property (nonatomic, strong) NSMutableArray *sandServerArr; //杉德服务子件数组
@property (nonatomic, strong) NSMutableArray *limitServerArr; //限时服务子件数组
@end

@implementation HomeViewController

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    //允许RESideMenu的返回手势
    self.sideMenuViewController.panGestureEnabled = YES;
    
    //用户刷新数据信息+支付工具刷新
    [self refreshUI];
    
    //检测是否实名/设置支付密码
    [self checkRealNameOrSetPayPwd];
    
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
    //通知LeftSideMenuViewController 刷新用户信息UI
    [self postNotifactionToLeftSideMenuWithUserInfoRefrush];
    
    // 注册MQTT + 订阅消息
    [self rigistMqtt];
    
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
    [self create_BannerView];
    [self create_bodyViewOne];
    [self create_bodyViewTwo];
    
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
        [SDMBProgressView showSDMBProgressNormalINView:weakSelf.view lableText:@"努力开发中..."];
        /**
        //@"消息"
        MessageViewController *messageVC = [[MessageViewController alloc] init];
        [weakSelf.navigationController pushViewController:messageVC animated:YES];
         */
        
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
    if (btn.tag == BTN_TAG_SCANE) {
        //@"扫一扫"
        ScannerViewController *mScannerViewController = [[ScannerViewController alloc] init];
        [self.navigationController pushViewController:mScannerViewController animated:YES];
    }
    if (btn.tag == BTN_TAG_JUSTCLICK) {
        //@头像点击
        [self presentLeftMenuViewController:self.sideMenuViewController];
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
    headWhiteView.layer.shadowOpacity = 0.35;
    headWhiteView.layer.shadowOffset = CGSizeMake(0, 5.f);
    headWhiteView.layer.shadowRadius = 7.f;
    [headView addSubview:headWhiteView];
    
    
    UIImage *headimg = [UIImage imageNamed:@"home_Head"];
    headIconImgView = [Tool createImagView:headimg];
    headIconImgView.layer.cornerRadius = headimg.size.width/2;
    headIconImgView.layer.masksToBounds = YES;
    headIconImgView.layer.shadowColor = COLOR_343339.CGColor;
    headIconImgView.layer.shadowOpacity = 1;
    headIconImgView.layer.borderWidth = 0.4f;
    headIconImgView.layer.borderColor = COLOR_343339.CGColor;
    headIconImgView.layer.shadowPath = [UIBezierPath bezierPathWithOvalInRect:headIconImgView.frame].CGPath;
    headIconImgView.layer.shadowOffset = CGSizeZero;
    headIconImgView.userInteractionEnabled = YES;
    [headWhiteView addSubview:headIconImgView];
    
    [headIconImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(headWhiteView.mas_top).offset(-UPDOWNSPACE_15);
        make.left.equalTo(headWhiteView.mas_left).offset(LEFTRIGHTSPACE_15);
        make.size.mas_equalTo(headimg.size);
    }];
    
    UIButton *headClickBtn = [Tool createButton:@"" attributeStr:nil font:nil textColor:[UIColor clearColor]];
    headClickBtn.tag = BTN_TAG_JUSTCLICK;
    [headClickBtn addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    [headIconImgView addSubview:headClickBtn];
    
    [headClickBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(headIconImgView.mas_top);
        make.centerX.equalTo(headIconImgView.mas_centerX);
        make.size.mas_equalTo(headIconImgView.size);
    }];
    
    
    headPhoneNoLab = [Tool createLable:@"1111*******1111" attributeStr:nil font:FONT_18_Medium textColor:COLOR_343339 alignment:NSTextAlignmentLeft];
    [headWhiteView addSubview:headPhoneNoLab];
    
    [headPhoneNoLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(headWhiteView.mas_top).offset(UPDOWNSPACE_09);
        make.left.equalTo(headIconImgView.mas_right).offset(LEFTRIGHTSPACE_20);
        make.size.mas_equalTo(headPhoneNoLab.size);
    }];
    
    //payBtn
    payBtn = [Tool createButton:nil attributeStr:nil font:nil textColor:nil];
    [payBtn addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    payBtn.tag = BTN_TAG_SCANE;
    [headWhiteView addSubview:payBtn];
    
    UIImage *paybtnImg = [UIImage imageNamed:@"saoyisao"];
    UIImageView *payBtnImgeView = [Tool createImagView:paybtnImg];
    [payBtn addSubview:payBtnImgeView];
    
    UILabel *payBtnBottomlab = [Tool createLable:@"扫一扫" attributeStr:nil font:FONT_13_Regular textColor:COLOR_000000 alignment:NSTextAlignmentCenter];
    [payBtn addSubview:payBtnBottomlab];
    
    payBtn.width = LEFTRIGHTSPACE_40;
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
    
    UIImage *moneyBtnImg = [UIImage imageNamed:@"yue"];
    UIImageView *moneyBtnImgView = [Tool createImagView:moneyBtnImg];
    [moneyBtn addSubview:moneyBtnImgView];
    
    UILabel *moneyBtnBottomlab = [Tool createLable:@"余 额" attributeStr:nil font:FONT_13_Regular textColor:COLOR_000000 alignment:NSTextAlignmentCenter];
    [moneyBtn addSubview:moneyBtnBottomlab];
    
    moneyBtn.width = LEFTRIGHTSPACE_40;
    moneyBtn.height = moneyBtnBottomlab.height + moneyBtnImg.size.height + UPDOWNSPACE_10;
    
    [moneyBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(headIconImgView.mas_bottom).offset(UPDOWNSPACE_05);
        make.centerX.equalTo(headWhiteView.mas_centerX);
        make.size.mas_equalTo(CGSizeMake(moneyBtn.width, moneyBtn.height));
    }];
    
    [moneyBtnImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(moneyBtn.mas_top);
        make.centerX.equalTo(moneyBtn.mas_centerX);
        make.size.mas_equalTo(moneyBtnImgView.size);
    }];
    
    [moneyBtnBottomlab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(moneyBtnImgView.mas_bottom).offset(UPDOWNSPACE_10);
        make.centerX.equalTo(moneyBtn.mas_centerX);
        make.size.mas_equalTo(moneyBtnBottomlab.size);
    }];
    
    /**
     * 余额显示版本 - 防止以后要用,暂不删除
     
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
     
     */
    
    //saoyisao
    UIButton *cardBagBtn = [Tool createButton:nil attributeStr:nil font:nil textColor:nil];
    [cardBagBtn addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    cardBagBtn.tag = BTN_TAG_INOUTPAY;
    [headWhiteView addSubview:cardBagBtn];
    
    UIImage *cardBagImg = [UIImage imageNamed:@"fukuan"];
    UIImageView *cardBagImgeView = [Tool createImagView:cardBagImg];
    cardBagImgeView.image = cardBagImg;
    [cardBagBtn addSubview:cardBagImgeView];
    
    UILabel *cardBagBottomlab = [Tool createLable:@"付 款" attributeStr:nil font:FONT_13_Regular textColor:COLOR_000000 alignment:NSTextAlignmentCenter];
    [cardBagBtn addSubview:cardBagBottomlab];
    
    cardBagBtn.width = LEFTRIGHTSPACE_40;
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
        make.top.equalTo(headBGimgView.mas_top);
        make.left.equalTo(headBGimgView.mas_left);
        make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH, headViewH));
    }];
    [headWhiteView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(headView.mas_top).offset(UPDOWNSPACE_15);
        make.left.equalTo(headView.mas_left).offset(LEFTRIGHTSPACE_15);
        make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH - 2*LEFTRIGHTSPACE_15, headViewH - 2*UPDOWNSPACE_15));
    }];
    
    //重置背景图片高度 - 辣鸡UI给的图
    [headBGimgView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.baseScrollView.mas_top);
        make.left.equalTo(self.baseScrollView.mas_left);
        make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH, headViewH));
    }];

    
}

- (void)create_BannerView{
    
    UIImage *bannerImg = [UIImage imageNamed:@"banner"];
    bannerView = [[SDBannerView alloc] initStyle:SDBannerViewOnlyImage imageArray:@[bannerImg] UrlArray:nil titleArray:nil];
    bannerView.delegate = self;
    bannerView.rect = CGRectMake(0, 0, SCREEN_WIDTH, bannerImg.size.height);
    [self.baseScrollView addSubview:bannerView];
    
    [bannerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(headBGimgView.mas_bottom).offset(UPDOWNSPACE_0);
        make.centerX.equalTo(self.baseScrollView.mas_centerX);
        make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH, bannerImg.size.height));
    }];
    
}


- (void)create_bodyViewOne{
    
    //bodyViewOne
    bodyViewOne = [[UIView alloc] init];
    bodyViewOne.backgroundColor = COLOR_FFFFFF;
    [self.baseScrollView addSubview:bodyViewOne];
    
    //杉德服务
    UILabel *sandServerLab = [Tool createLable:@"杉德服务" attributeStr:nil font:FONT_15_Medium textColor:COLOR_343339 alignment:NSTextAlignmentLeft];
    [bodyViewOne addSubview:sandServerLab];
    
    UIView *line = [[UIView alloc] init];
    line.backgroundColor = COLOR_A1A2A5_3;
    [bodyViewOne addSubview:line];
    
    
    //majletView
    SDMajletView *sandServerView = [SDMajletView createMajletViewOY:0];
    sandServerView.cellSpace = LEFTRIGHTSPACE_25;
    sandServerView.columnNumber = 4;
    sandServerView.majletArr = self.sandServerArr;
    sandServerView.titleNameBlock = ^(NSString *titleName) {
        
        if ([titleName isEqualToString:@"转账"]) {
            if ([[sandWalletDic objectForKey:@"available"] boolValue] == NO){
                //            [Tool showDialog:@"账户暂时无法转账 available == NO"];
                //            return ;
            }
            SDRechargePopView *popview = [SDRechargePopView showRechargePopView:@"转账到" rechargeChooseBlock:^(NSString *cellName) {
                if ([cellName isEqualToString:@"个人银行卡"]) {
                    if ([[Tool fenToYuanDict:sandWalletDic] isEqualToString:@"0.00"]) {
                        [Tool showDialog:@"账户余额不足,无法转账到银行卡"];
                        return ;
                    }
                    BankCardTransferViewController * bankCardTransferVC = [[BankCardTransferViewController alloc] init];
                    bankCardTransferVC.transferOutPayToolDic = sandWalletDic;
                    bankCardTransferVC.tTokenType = @"02000201";
                    [self.navigationController pushViewController:bankCardTransferVC animated:YES];
                }
                if ([cellName isEqualToString:@"杉德宝用户"]) {
                    if ([[Tool fenToYuanDict:sandWalletDic] isEqualToString:@"0.00"]) {
                        [Tool showDialog:@"账户余额不足,无法转账到杉德宝用户"];
                        return ;
                    }
                    UserTransferBeginViewController *sandUserTransferVC = [[UserTransferBeginViewController alloc] init];
                    [self.navigationController pushViewController:sandUserTransferVC animated:YES];
                }
            }];
            popview.chooseBtnTitleArr = @[@"个人银行卡",@"杉德宝用户"];
        }
        
        if ([titleName isEqualToString:@"钱包"]) {
            [self.sideMenuViewController setContentViewController:[CommParameter sharedInstance].walletAccNav];
        }
        if ([titleName isEqualToString:@"积分商城"]) {
            [SDMBProgressView showSDMBProgressNormalINView:self.view lableText:@"努力开发中..."];
            /*
            [self.sideMenuViewController setContentViewController:[CommParameter sharedInstance].financicleNav];
             */
        }
        if ([titleName isEqualToString:@"卡券"]) {
            [self.sideMenuViewController setContentViewController:[CommParameter sharedInstance].sandCardNav];
        }
        if ([titleName isEqualToString:@"账单"]) {
            [self.sideMenuViewController setContentViewController:[CommParameter sharedInstance].myBillNav];
        }
        if ([titleName isEqualToString:@"积分"]) {
            [self.sideMenuViewController setContentViewController:[CommParameter sharedInstance].sandPointNav];
        }
        if ([titleName isEqualToString:@"银行卡"]) {
            [self.sideMenuViewController setContentViewController:[CommParameter sharedInstance].bankCardNav];
        }
       
    };
    [bodyViewOne addSubview:sandServerView];
    
    CGFloat labSpaceToView = UPDOWNSPACE_11;
    bodyViewOne.height = labSpaceToView + sandServerLab.height + labSpaceToView + sandServerView.height;
    
    [bodyViewOne mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(bannerView.mas_bottom).offset(UPDOWNSPACE_10);
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
    
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(sandServerView.mas_top);
        make.left.equalTo(sandServerLab.mas_left);
        make.size.mas_equalTo(CGSizeMake(sandServerView.width - 2*LEFTRIGHTSPACE_18, 0.8f));
    }];
}

- (void)create_bodyViewTwo{

    //bodyViewTwo
    bodyViewTwo = [[UIView alloc] init];
    bodyViewTwo.backgroundColor = COLOR_FFFFFF;
    [self.baseScrollView addSubview:bodyViewTwo];
    
    //限时服务
    UILabel *limitServerLab = [Tool createLable:@"限时服务" attributeStr:nil font:FONT_15_Medium textColor:COLOR_343339 alignment:NSTextAlignmentLeft];
    [bodyViewTwo addSubview:limitServerLab];
    
    UIView *line = [[UIView alloc] init];
    line.backgroundColor = COLOR_A1A2A5_3;
    [bodyViewTwo addSubview:line];
    
    
    //majletView
    SDMajletView *limitServerView = [SDMajletView createMajletViewOY:0];
    limitServerView.cellSpace = LEFTRIGHTSPACE_25;
    limitServerView.columnNumber = 4;
    limitServerView.majletArr = self.limitServerArr;
    limitServerView.titleNameBlock = ^(NSString *titleName) {
        NSLog(@"titleName == %@",titleName);
        //超值年化
        if ([titleName isEqualToString:@"超值年化"]) {
            [SDMBProgressView showSDMBProgressNormalINView:self.view lableText:@"努力开发中..."];
        }
        //新卡推荐
        if ([titleName isEqualToString:@"新卡推荐"]) {
            [SDMBProgressView showSDMBProgressNormalINView:self.view lableText:@"努力开发中..."];
        }
        //超值兑换
        if ([titleName isEqualToString:@"超值兑换"]) {
            [SDMBProgressView showSDMBProgressNormalINView:self.view lableText:@"努力开发中..."];
        }
        //商户推荐
        if ([titleName isEqualToString:@"商户推荐"]) {
            [SDMBProgressView showSDMBProgressNormalINView:self.view lableText:@"努力开发中..."];
        }
        //邀请好友
        if ([titleName isEqualToString:@"邀请好友"]) {
            InviteViewController *invitedVC = [[InviteViewController alloc] init];
            [self.navigationController pushViewController:invitedVC animated:YES];
        }
        
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
    
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(limitServerView.mas_top);
        make.left.equalTo(limitServerLab.mas_left);
        make.size.mas_equalTo(CGSizeMake(limitServerView.width - 2*LEFTRIGHTSPACE_18, 0.8f));
    }];
    
}

#pragma mark - 业务逻辑
#pragma mark 注册MQTT
- (void)rigistMqtt{
    
    //0.MQTT标识已存在
    [CommParameter sharedInstance].mqttFlag = YES;
    
    //1.注册代理
    [SDMQTTManager shareMQttManager].delegate = self;
    //3.订阅消息
    [[SDMQTTManager shareMQttManager] subscaribeTopic:kMqttTopicUSERID([CommParameter sharedInstance].userId) atLevel:MQTTQosLevelExactlyOnce];
    
}
#pragma mark MQTT代理方法
- (void)messageTopic:(NSString *)toPic dataDic:(NSDictionary *)dic{
    
    //mqtt消息落库
//    [self setMqttlist:dic];
    
    //消息类型
    NSString *msgType = [dic objectForKey:@"msgType"];
    //0-提醒处理 1-静默处理 2-强制处理
    NSInteger msgLevel = [[dic objectForKey:@"msgLevel"] intValue];
    
    
    if ([msgType isEqualToString:@"000001"]) {
        if (msgLevel == 0) {
            
        }
        if (msgLevel == 1) {
            
        }
        if (msgLevel == 2) {
            
        }
    }
    if ([msgType isEqualToString:@"000002"]) {
        if (msgLevel == 0) {
            
        }
        if (msgLevel == 1) {
            
        }
        if (msgLevel == 2) {
            
        }
    }
    if ([msgType isEqualToString:@"100001"]) {
        if (msgLevel == 0) {
            //交易信息推送
            [self transePayNotice:dic];
        }
        if (msgLevel == 1) {
            
        }
        if (msgLevel == 2) {
            
        }
    }
    if ([msgType isEqualToString:@"200001"]) {
        if (msgLevel == 0) {
            
        }
        if (msgLevel == 1) {
            
        }
        if (msgLevel == 2) {
            
        }
    }
    if ([msgType isEqualToString:@"300001"]) {
        if (msgLevel == 0) {
            
        }
        if (msgLevel == 1) {
            
        }
        if (msgLevel == 2) {
            //多账户登录提醒
            [self loginOtherDevice:dic];
        }
    }
    if ([msgType isEqualToString:@"400001"]) {
        if (msgLevel == 0) {
            
        }
        if (msgLevel == 1) {
            
        }
        if (msgLevel == 2) {
            
        }
    }
    if ([msgType isEqualToString:@"500001"]) {
        if (msgLevel == 0) {
            
        }
        if (msgLevel == 1) {
            
        }
        if (msgLevel == 2) {
            
        }
    }
    if ([msgType isEqualToString:@"600001"]) {
        if (msgLevel == 0) {
           
        }
        if (msgLevel == 1) {
            
        }
        if (msgLevel == 2) {
            //商户反扫支付(无秘)推动支付结果
            [self noticeB2c:dic];
        }
    }
    if ([msgType isEqualToString:@"600002"]) {
        if (msgLevel == 0) {
            
        }
        if (msgLevel == 1) {
            
        }
        if (msgLevel == 2) {
            //商户反扫支付(有密)推送TN号
            [self noticeB2cWithPwd:dic];
        }
    }
}

#pragma mark MQTT事件: 交易消息推送处理(100001)
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
        SDDrowNoticeView *sdDrowNoticeView = [SDDrowNoticeView createDrowNoticeView:@[msgTitle,message]];
        [[UIApplication sharedApplication].keyWindow addSubview:sdDrowNoticeView];
        [sdDrowNoticeView animationDrown];
    }
    
}

/**
 多点登陆提醒
 */
#pragma mark MQTT事件: 多点登陆提醒(300001)
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
            
            //从全局变量 [CommParameter sharedInstance].currentVC 获取当前窗口下的主内容视图,用于登出UI操作
            [Tool setContentViewControllerWithLoginFromSideMentuVIewController:[CommParameter sharedInstance].currentVC forLogOut:YES];
        }];
    }
    
}
#pragma mark MQTT事件: 商户反扫支付通知(600001)
- (void)noticeB2c:(NSDictionary*)dic{
    NSString *msgData = [[dic objectForKey:@"data"] objectForKey:@"msgData"];
    NSDictionary *msgDic = [[PayNucHelper sharedInstance] jsonStringToDictionary:msgData];
    NSString *msg = [msgDic objectForKey:@"msg"];
    NSString *respMsg = [msgDic objectForKey:@"respMsg"];
    [[NSNotificationCenter defaultCenter] postNotificationName:MQTT_NOTICE_BSC_TN object:[NSString stringWithFormat:@"%@+%@",respMsg,msg]];
}

#pragma mark MQTT事件: 商户反扫支付通知(600002)
- (void)noticeB2cWithPwd:(NSDictionary*)dic{
    NSString *msgData = [[dic objectForKey:@"data"] objectForKey:@"msgData"];
    NSDictionary *tnDic = [[PayNucHelper sharedInstance] jsonStringToDictionary:msgData];
    NSString *tn = [tnDic objectForKey:@"sandTN"];
    [[NSNotificationCenter defaultCenter] postNotificationName:MQTT_NOTICE_BSC_TN_PWD object:tn];
    
}

#pragma mark SDBannerDelegate
-(void)sanBannerViewDelegateClick:(NSInteger)index{
    NSLog(@"点击了第 %ld 张图片",index);
    
    InviteViewController *invitedVC = [[InviteViewController alloc] init];
    [self.navigationController pushViewController:invitedVC animated:YES];
}


#pragma mark - 本类公共方法调用
#pragma mark 获取用户绑定的银行卡数量
/**获取用户绑定的银行卡数量*/
- (NSArray*)getBankCardPayToolArr
{
    NSDictionary *ownPayToolDic = [Tool getPayToolsInfo:[CommParameter sharedInstance].ownPayToolsArray];
    NSArray *bankCardPayTooArr = [NSMutableArray arrayWithCapacity:0];
    bankCardPayTooArr = [ownPayToolDic objectForKey:@"bankArray"];
    return bankCardPayTooArr;
}
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
    
    //2.刷新手机号
    headPhoneNoLab.text = [CommParameter sharedInstance].userName;
    
    //3.刷新钱包账户工具
    NSDictionary *ownPayToolDic = [Tool getPayToolsInfo:[CommParameter sharedInstance].ownPayToolsArray];
    sandWalletDic = [NSMutableDictionary dictionaryWithDictionary:[ownPayToolDic objectForKey:@"sandWalletDic"]];
    //4.若钱包账户未开通成功,由于UI上不需要展示钱包账户,因此钱包账户未开通情况下,可暂不判断或提示
}

#pragma mark 通知左侧边栏刷新用户信息UI
- (void)postNotifactionToLeftSideMenuWithUserInfoRefrush{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"User_Info_Changed" object:nil];
}

@end
