//
//  SandBaoViewController.m
//  sandbao
//
//  Created by tianNanYiHao on 2016/10/31.
//  Copyright © 2016年 sand. All rights reserved.
//

#import "SandBaoViewController.h"
#import "SDSqlite.h"
#import "SqliteHelper.h"
#import "CommParameter.h"
#import "MinletsManagerViewController.h"
#import "LoginViewController.h"
#import "RegisterViewController.h"
#import "SettingPayPwdViewController.h"
#import "HeadImageBtn.h"
#import "GradualView.h"
#import "SDCycleScrollView.h"
#import "SDBannerView.h"
#import "TransferBeginViewController.h"
#import "Html5ViewController.h"
#import "VerticalLineView.h"
#import "BillViewController.h"
#import "ScannerViewController.h"
#import "QRCodeViewController.h"
#import "OrderInfoH5ViewController.h"
#import "OrderInfoNatiVeViewController.h"
#import "MqttMsgViewController.h"
#import "PayNucHelper.h"
#import "SDLog.h"
#import "RealNameAuthenticationViewController.h"
#import "FAQwebViewController.h"
#import "SDMajletCell.h"



#define TitleColor RGBA(28, 28, 28, 1.0)
#define TitleDecColor RGBA(140, 144, 157, 1.0)
#define lineColor RGBA(229, 229, 229, 1.0)

#define fukuanTag 2001
#define saoTag 2002
#define kabaoTag 2003


@interface SandBaoViewController ()<SDBannerViewDelegate,UIScrollViewDelegate,SDPopviewDelegate,UICollectionViewDelegate,UICollectionViewDataSource>
{
    NavCoverView *navCoverView;
    CGFloat qCoreBotomSpace;
    CGFloat textSize;
    CGFloat btnTitleSize;
    CGFloat qcoreBtHorizonSpace;
    CGFloat space;
    CGFloat bannerBGViewH;
    SDBannerView *bannerBGView;
    UIView *lifeBarView;
    UIView *lifeBgView;
    UIView *incomeBGView;
    UIView *mySandCardBGView;
    UIView *couponsBGView;
    NSMutableArray *minletsArr;
    CGFloat minletsViewH;
    CGFloat qCoreVIewH;
}

@property (nonatomic, assign) CGSize viewSize;
@property (nonatomic,assign) CGFloat moneyTextSize;
@property (nonatomic, assign) CGFloat leftRightSpace;
@property (nonatomic, strong) SDMBProgressView *HUD;
@property (nonatomic, strong) SDPopview *sdPopView;
@property (nonatomic, strong) SDPopViewConfig *sdpopViewconfig;
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UIView *minletsView;
@property (nonatomic, strong) MinletsManagerViewController *mMinletsManagerViewController;





@end

@implementation SandBaoViewController

@synthesize viewSize;
@synthesize leftRightSpace;
@synthesize HUD;
@synthesize sdPopView;
@synthesize sdpopViewconfig;

//@synthesize scrollView;
@synthesize minletsView;
@synthesize moneyTextSize;
@synthesize mMinletsManagerViewController;



- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    #pragma mark - 创建功能区
    [self functionView:qCoreVIewH remove:NO];
    
}

- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
     #pragma mark - remove功能区
    [self functionView:qCoreVIewH remove:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    viewSize = self.view.bounds.size;
    self.navigationController.navigationBarHidden = YES;
    minletsArr = [NSMutableArray arrayWithCapacity:0];
    space = 10;
    leftRightSpace = 15;
    
    [self addsdPopView];
    
    [self settingNavigationBar];
    [self addView:self.view];

}

#pragma mark - 设置导航栏
/**
 *@brief 设置导航栏
 *@return
 */
- (void)settingNavigationBar
{
    
    //导航渐变条
    //衫德宝
    navCoverView = [NavCoverView shareNavCoverView:CGRectMake(0, 0, viewSize.width, controllerTop) title:@""];
    [self.view addSubview:navCoverView];
    
    // 2.设置左边的返回item
//    UIImage *leftImage = [UIImage imageNamed:@"bank_button_search_normal.png"];
    UIButton *leftBarBtn = [[UIButton alloc] init];
    [leftBarBtn setTitle:@"账单" forState:UIControlStateNormal];
    leftBarBtn.titleLabel.font = [UIFont systemFontOfSize:textSize];
    [leftBarBtn setTintColor:[UIColor whiteColor]];
    CGSize leftBtnSize = [leftBarBtn.titleLabel.text sizeWithNSStringFont:leftBarBtn.titleLabel.font];
    leftBarBtn.frame = CGRectMake(18, 20 + (40 - leftBtnSize.height) / 2, leftBtnSize.width, leftBtnSize.height);
    leftBarBtn.tag = 101;
    leftBarBtn.contentMode = UIViewContentModeScaleAspectFit;
    [leftBarBtn addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
    [navCoverView addSubview:leftBarBtn];

    
    // 3.设置右边的返回item
    UIImage *rightImage = [UIImage imageNamed:@"icon_add"];
    CGSize newImageSize = CGSizeMake(rightImage.size.width+space, rightImage.size.height+space);
    UIButton *rightBarBtn = [[UIButton alloc] init];
    [rightBarBtn setImage:[UIImage imageNamed:@"icon_add"] forState:UIControlStateNormal];
    [rightBarBtn setImage:[UIImage imageNamed:@"icon_add"] forState:UIControlStateHighlighted];
    rightBarBtn.frame = CGRectMake(viewSize.width - 10 - newImageSize.width, 20 + (40 - newImageSize.height) / 2, newImageSize.width, newImageSize.height);
    rightBarBtn.tag = 102;
    rightBarBtn.contentMode = UIViewContentModeScaleAspectFit;
    [rightBarBtn addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
    [navCoverView addSubview:rightBarBtn];

}

#pragma mark - 创建组件
/**
 *@brief 创建组件
 *@param view UIView 参数：组件
 *@return
 */
-(void)addView:(UIView *)view
{
    qCoreBotomSpace = 16;
    qcoreBtHorizonSpace = 44.5;
    bannerBGViewH = 85;
    
    //创建UIScrollView
    _scrollView = [[UIScrollView alloc] init];
    _scrollView.userInteractionEnabled = YES;
    _scrollView.scrollEnabled = YES;
    _scrollView.directionalLockEnabled = YES; //只能一个方向滑动
    _scrollView.pagingEnabled = NO; //是否翻页
    _scrollView.delegate = self;
    _scrollView.showsVerticalScrollIndicator = NO; //垂直方向的滚动指示
    _scrollView.indicatorStyle = UIScrollViewIndicatorStyleWhite;//滚动指示的风格
    _scrollView.showsHorizontalScrollIndicator = NO;//水平方向的滚动指示
    [_scrollView setBackgroundColor:RGBA(243, 243, 243, 1.0)];
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    [view addSubview:_scrollView];
    
    //扫码区背景view
    GradualView *qCoreView = [[GradualView alloc] init];
    [_scrollView addSubview:qCoreView];
    
    UIImage *fukuangimage = [UIImage imageNamed:@"menu_fukuan"];
    NSString *fukuanStr = @"付款码";
    UIImage *saoImage = [UIImage imageNamed:@"menu_saoyisao"];
    NSString *saoStr = @"扫一扫";
    UIImage *kabaoImage = [UIImage imageNamed:@"menu_kabao"];
    NSString *kabaoStr = @"卡券包";
    
    HeadImageBtn *btnFukuan = [HeadImageBtn buttonWithType:UIButtonTypeCustom];
    btnFukuan.tag = fukuanTag;
    [btnFukuan addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
    [btnFukuan setImage:fukuangimage forState:UIControlStateNormal];
    [btnFukuan setTitle:fukuanStr forState:UIControlStateNormal];
    [btnFukuan setTintColor:[UIColor whiteColor]];
    btnFukuan.titleLabel.font = [UIFont systemFontOfSize:btnTitleSize];
    CGSize fukuanTitleSize = [fukuanStr sizeWithNSStringFont:[UIFont systemFontOfSize:btnTitleSize]];
    CGFloat btnFukuanH = fukuangimage.size.height + 10 + fukuanTitleSize.height ;
    btnFukuan.frame = CGRectMake(0, 0, fukuanTitleSize.width, btnFukuanH);
    CGFloat btnBianspace = fukuanTitleSize.width/2;
    qcoreBtHorizonSpace = qcoreBtHorizonSpace - btnBianspace;
    [qCoreView addSubview:btnFukuan];
    
    
    HeadImageBtn *btnSao = [HeadImageBtn buttonWithType:UIButtonTypeRoundedRect];
    btnSao.tag = saoTag;
    [btnSao addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
    [btnSao setImage:saoImage forState:UIControlStateNormal];
    [btnSao setTitle:saoStr forState:UIControlStateNormal];
    btnSao.titleLabel.font = [UIFont systemFontOfSize:btnTitleSize];
    [btnSao setTintColor:[UIColor whiteColor]];
    btnSao.frame = CGRectMake(0, 0, btnFukuan.frame.size
                              .width, btnFukuan.frame.size.height);
    [qCoreView addSubview:btnSao];
    
    HeadImageBtn *btnKaBao = [HeadImageBtn buttonWithType:UIButtonTypeRoundedRect];
    btnKaBao.tag = kabaoTag;
    [btnKaBao addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
    [btnKaBao setImage:kabaoImage forState:UIControlStateNormal];
    [btnKaBao setTitle:kabaoStr forState:UIControlStateNormal];
    btnKaBao.titleLabel.font = [UIFont systemFontOfSize:btnTitleSize];
    [btnKaBao setTintColor:[UIColor whiteColor]];
    btnKaBao.frame = CGRectMake(0, 0, btnFukuan.frame.size
                              .width, btnFukuan.frame.size.height);
    [qCoreView addSubview:btnKaBao];
    qCoreVIewH  = btnFukuanH+16+qCoreBotomSpace;
    //根据frame创建扫码区
    qCoreView.rect = CGRectMake(0, 0, viewSize.width, qCoreVIewH);
    
    
    
    
    //banner区
    NSArray *arr = @[[UIImage imageNamed:@"home_banner"],
                     [UIImage imageNamed:@"home_banner"]];
    bannerBGView = [[SDBannerView alloc] initStyle:SDBannerViewOnlyImage imageArray:arr UrlArray:nil titleArray:nil];
    bannerBGView.delegate = self;
    [_scrollView addSubview:bannerBGView];

    //根据frame创建SDBanner区
    bannerBGView.rect = CGRectMake(0, 0, viewSize.width, bannerBGViewH);
    
    //设置控件的位置和大小
    [navCoverView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(view).offset(0);
        make.centerX.equalTo(view);
        make.size.mas_equalTo(CGSizeMake(viewSize.width, controllerTop));
    }];
    
    [_scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(navCoverView.mas_bottom).offset(0);
        make.centerX.equalTo(view);
        make.size.mas_equalTo(CGSizeMake(viewSize.width, viewSize.height - controllerTop));
    }];
    
    [qCoreView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_scrollView).offset(0);
        make.centerX.equalTo(view);
        make.size.mas_equalTo(CGSizeMake(viewSize.width, qCoreVIewH));
    }];
    
    [btnFukuan mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(qCoreView).offset(qCoreBotomSpace/5);
        make.left.equalTo(qCoreView.mas_left).offset(qcoreBtHorizonSpace);
    }];
    
    [btnSao mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(qCoreView).offset(qCoreBotomSpace/5);
        make.centerX.equalTo(qCoreView).offset(0);
    }];
    
    [btnKaBao mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(qCoreView).offset(qCoreBotomSpace/5);
        make.right.equalTo(qCoreView.mas_right).offset(-qcoreBtHorizonSpace);
    }];
    
    [bannerBGView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(qCoreView.mas_bottom).offset(space);
        make.left.equalTo(qCoreView).offset(0);
        make.size.mas_equalTo(CGSizeMake(viewSize.width, bannerBGViewH));
    }];
    
    
    
}

#pragma mark - 功能区创建与删除
-(void)functionView:(CGFloat)qCoreVIewH remove:(BOOL)remov{
    
    if (remov){
        [lifeBgView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
        [incomeBGView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
        [mySandCardBGView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
        [couponsBGView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
        
        [lifeBgView removeFromSuperview];
        [incomeBGView removeFromSuperview];
        [mySandCardBGView removeFromSuperview];
        [couponsBGView removeFromSuperview];
        return;
    }

    
#pragma mark - 懂生活
    //1.懂生活
    lifeBgView = [[UIView alloc] init];
    lifeBgView.backgroundColor = [UIColor whiteColor];
    [_scrollView addSubview:lifeBgView];

    
    lifeBarView = [[UIView alloc] init];
    [lifeBgView addSubview:lifeBarView];
    
    //
    UILabel *lifeLab = [[UILabel alloc] init];
    lifeLab.text = @"懂生活";
    lifeLab.textColor = TitleColor;
    lifeLab.textAlignment = NSTextAlignmentLeft;
    lifeLab.font = [UIFont systemFontOfSize:textSize];
    [lifeBarView addSubview:lifeLab];
    CGSize lifeLabSize = [lifeLab.text sizeWithNSStringFont:[UIFont systemFontOfSize:textSize]];
    
    VerticalLineView *verticalV = [[VerticalLineView alloc] initWithFrame:CGRectMake(0, 0, 2,lifeLabSize.height)];
    [lifeBarView addSubview:verticalV];
    
    UILabel *lifeDecLab = [[UILabel alloc] init];
    lifeDecLab.text = @"想你所想 便捷生活";
    lifeDecLab.textColor = TitleDecColor;
    lifeDecLab.textAlignment = NSTextAlignmentRight;
    lifeDecLab.font = [UIFont systemFontOfSize:btnTitleSize];
    [lifeBarView addSubview:lifeDecLab];
    
    UIView *lifeLineView = [[UIView alloc] init];
    lifeLineView.backgroundColor = lineColor;
    [lifeBarView addSubview:lifeLineView];
    
    //子件区
    minletsView = [[UIView alloc] init];
    [minletsView setBackgroundColor:[UIColor whiteColor]];
    [lifeBgView addSubview:minletsView];
    
    minletsViewH = [self initMinletsBtn:minletsView remove:remov];
    
    
    
#pragma mark - 资金归去来
    /*
    //2.资金归去来
    incomeBGView = [[UIView alloc] init];
    incomeBGView.backgroundColor = [UIColor whiteColor];
    [_scrollView addSubview:incomeBGView];

    
    UIView *incomeBarView = [[UIView alloc] init];
    [incomeBGView addSubview:incomeBarView];
    
    VerticalLineView *verticalV2 = [[VerticalLineView alloc] initWithFrame:CGRectMake(0, 0, 2, lifeLabSize.height)];
    [incomeBarView addSubview:verticalV2];
    
    //
    UILabel *incomLab = [[UILabel alloc] init];
    incomLab.text = @"资金归去来";
    incomLab.textColor = TitleColor;
    incomLab.textAlignment = NSTextAlignmentLeft;
    incomLab.font = [UIFont systemFontOfSize:textSize];
    [incomeBarView addSubview:incomLab];
    
    UILabel *incomeDecLab = [[UILabel alloc] init];
    incomeDecLab.text = @"安心资产 精打细算";
    incomeDecLab.textColor = TitleDecColor;
    incomeDecLab.textAlignment = NSTextAlignmentRight;
    incomeDecLab.font = [UIFont systemFontOfSize:btnTitleSize];
    [incomeBarView addSubview:incomeDecLab];
    
    UIView *incomeLineView = [[UIView alloc] init];
    incomeLineView.backgroundColor = lineColor;
    [incomeBarView addSubview:incomeLineView];
    
    
    UILabel *incomMoneyLab = [[UILabel alloc] init];
    incomMoneyLab.text = @"+1,888.89";
    incomMoneyLab.textColor = RGBA(232, 56, 43, 1.0);
    incomMoneyLab.textAlignment = NSTextAlignmentCenter;
    incomMoneyLab.font = [UIFont systemFontOfSize:moneyTextSize];
    [incomeBGView addSubview:incomMoneyLab];
    
    UILabel *incomDecMoneyLab = [[UILabel alloc] init];
    incomDecMoneyLab.text = @"10月总收入(元)";
    incomDecMoneyLab.textColor = TitleDecColor;
    incomDecMoneyLab.textAlignment = NSTextAlignmentCenter;
    incomDecMoneyLab.font = [UIFont systemFontOfSize:btnTitleSize];
    [incomeBGView addSubview:incomDecMoneyLab];
    
    UILabel *outcomMoneyLab = [[UILabel alloc] init];
    outcomMoneyLab.text = @"-888.00";
    outcomMoneyLab.textColor = RGBA(71, 208, 159, 1.0);
    outcomMoneyLab.textAlignment = NSTextAlignmentCenter;
    outcomMoneyLab.font = [UIFont systemFontOfSize:moneyTextSize];
    [incomeBGView addSubview:outcomMoneyLab];
    
    UILabel *outcomDecMoneyLab = [[UILabel alloc] init];
    outcomDecMoneyLab.text = @"10月总支出(元)";
    outcomDecMoneyLab.textColor = TitleDecColor;
    outcomDecMoneyLab.textAlignment = NSTextAlignmentCenter;
    outcomDecMoneyLab.font = [UIFont systemFontOfSize:btnTitleSize];
    [incomeBGView addSubview:outcomDecMoneyLab];
    */
    
#pragma mark - 我的杉德卡
    /*
    //3.我的杉德卡
    mySandCardBGView = [[UIView alloc] init];
    mySandCardBGView.backgroundColor = [UIColor whiteColor];
    [_scrollView addSubview:mySandCardBGView];
    
    UIView *mySandCardBarView = [[UIView alloc] init];
    [mySandCardBGView addSubview:mySandCardBarView];
    
    VerticalLineView *verticalV3 = [[VerticalLineView alloc] initWithFrame:CGRectMake(0, 0, 2,  lifeLabSize.height)];
    [mySandCardBarView addSubview:verticalV3];
    
    //
    UILabel *mySandCardLab = [[UILabel alloc] init];
    mySandCardLab.text = @"我的杉德卡";
    mySandCardLab.textColor = TitleColor;
    mySandCardLab.textAlignment = NSTextAlignmentLeft;
    mySandCardLab.font = [UIFont systemFontOfSize:textSize];
    [mySandCardBarView addSubview:mySandCardLab];
    
    UIView *mySandCardLineView = [[UIView alloc] init];
    mySandCardLineView.backgroundColor = lineColor;
    [mySandCardBarView addSubview:mySandCardLineView];
    
    UIView *mySandCardAddBgview = [[UIView alloc] init];
    mySandCardAddBgview.backgroundColor = [UIColor whiteColor];
    mySandCardAddBgview.layer.cornerRadius = 5;
    mySandCardAddBgview.layer.borderColor = [UIColor lightGrayColor].CGColor;
    mySandCardAddBgview.layer.borderWidth = 1;
    [mySandCardBGView addSubview:mySandCardAddBgview];
    
    
    UILabel *mySandCardAddLab = [[UILabel alloc] init];
    mySandCardAddLab.text = @"已绑定杉德记名卡";
    mySandCardAddLab.textColor = TitleColor;
    mySandCardAddLab.textAlignment = NSTextAlignmentCenter;
    mySandCardAddLab.font = [UIFont systemFontOfSize:textSize];
    [mySandCardAddBgview addSubview:mySandCardAddLab];
    
    UILabel *mySandCardAddDecLab = [[UILabel alloc] init];
    mySandCardAddDecLab.text = @"绑定杉德记名卡即可随时管理您的账户";
    mySandCardAddDecLab.textColor = TitleDecColor;
    mySandCardAddDecLab.textAlignment = NSTextAlignmentCenter;
    mySandCardAddDecLab.font = [UIFont systemFontOfSize:btnTitleSize-4];
    [mySandCardAddBgview addSubview:mySandCardAddDecLab];
    
    UIButton *mySandCardAddBtn = [[UIButton alloc] init];
    [mySandCardAddBtn setTitle:@"添加新卡" forState:UIControlStateNormal];
    [mySandCardAddBtn setTitleColor:RGBA(63, 151, 215, 1.0) forState:UIControlStateNormal];
    mySandCardAddBtn.layer.cornerRadius = 5;
    mySandCardAddBtn.layer.masksToBounds = YES;
    mySandCardAddBtn.layer.borderWidth = 1;
    mySandCardAddBtn.layer.borderColor = RGBA(63, 151, 215, 1.0).CGColor;
    [mySandCardAddBgview addSubview:mySandCardAddBtn];
    */

#pragma mark - 优惠券
    /*
    //4.优惠券
    couponsBGView = [[UIView alloc] init];
    couponsBGView.backgroundColor = [UIColor whiteColor];
    [_scrollView addSubview:couponsBGView];
    
    UIView *couponsBarView = [[UIView alloc] init];
    [couponsBGView addSubview:couponsBarView];
    
    UIImage *couponsImage = [UIImage imageNamed:@"youhui"];
    UIImageView *couponsImageView = [[UIImageView alloc] init];
    couponsImageView.image = couponsImage;
    [couponsBarView addSubview:couponsImageView];
    
    //
    UILabel *couponsLab = [[UILabel alloc] init];
    couponsLab.text = @"优惠券";
    couponsLab.textColor = TitleColor;
    couponsLab.textAlignment = NSTextAlignmentLeft;
    couponsLab.font = [UIFont systemFontOfSize:textSize];
    [couponsBarView addSubview:couponsLab];
    
    UIView *couponsLineView = [[UIView alloc] init];
    couponsLineView.backgroundColor = lineColor;
    [couponsBarView addSubview:couponsLineView];
    
    UIImage *couponsPhotoImage = [UIImage imageNamed:@"youhui_photo"];
    UIImageView *couponsPhotoImageView = [[UIImageView alloc] init];
    couponsPhotoImageView.image = couponsPhotoImage;
    [couponsBGView addSubview:couponsPhotoImageView];
     
     */
    
    
    //1
    CGFloat ToMoneyLabspace = 35.0f;
    CGSize lifeDecLabSzie = [lifeDecLab.text sizeWithNSStringFont:[UIFont systemFontOfSize:btnTitleSize]];
    CGFloat lifeBarViewH = lifeLabSize.height + 2*leftRightSpace;
    CGFloat lifeBGViewH = lifeBarViewH + minletsViewH;
    
    
    /*
    //2 资金归去来frame
    CGSize incomeLabSize = [incomLab.text sizeWithNSStringFont:[UIFont systemFontOfSize:textSize]];
    CGSize incomeDecLabSize = [incomeDecLab.text sizeWithNSStringFont:[UIFont systemFontOfSize:btnTitleSize]];
    CGSize incomeMoneyLabSize = [incomMoneyLab.text sizeWithNSStringFont:[UIFont systemFontOfSize:moneyTextSize]];
    CGSize incomeMoneyDecLabSize = [incomDecMoneyLab.text sizeWithNSStringFont:[UIFont systemFontOfSize:btnTitleSize]];
    CGFloat incomeBGViewH = lifeBarViewH + ToMoneyLabspace + incomeMoneyLabSize.height + incomeMoneyDecLabSize.height + space/2+ToMoneyLabspace;
    
    //3
    CGFloat mySandCardAddToleft = 60;
    CGFloat mySandCardAddToTop = 30;
    CGFloat mySandCardAddLabToTop = 25;
    CGFloat mySandCardAddLabToBottom = 19;
    CGFloat mySandCardAddBtnToBottom = 16;
    CGFloat mySandCardAddBtnToLeft = 30;
    CGFloat mySandCardAddBtnTitleToTop = 7.5f;
    CGSize mySandCardLabSize = [mySandCardLab.text sizeWithNSStringFont:[UIFont systemFontOfSize:textSize]];
    CGSize mySandCardAddDecLabSize = [mySandCardAddDecLab.text sizeWithNSStringFont:[UIFont systemFontOfSize:btnTitleSize-4]];
    CGFloat mysandCardAddbtnH = lifeDecLabSzie.height+2*mySandCardAddBtnTitleToTop;
    CGFloat mySandCardAddBGViewH = mySandCardAddLabToTop + lifeLabSize.height + space/2 + mySandCardAddDecLabSize.height + mySandCardAddLabToBottom + mysandCardAddbtnH + mySandCardAddBtnToBottom;
    CGSize mySandCardAddBGViewSize = CGSizeMake(viewSize.width- 2*mySandCardAddToleft, mySandCardAddBGViewH);
    CGFloat mySandCargBgViewH = lifeBarViewH + mySandCardAddToTop*2 + mySandCardAddBGViewH;
    
    //4
    CGFloat couponsPhotoImageViewToBottom = 60;
    CGSize couponsLabSize = [couponsLab.text sizeWithNSStringFont:[UIFont systemFontOfSize:textSize]];
    CGFloat couponsPhoteImageViewW = viewSize.width - 2*space;
    CGSize couponsBGviewSize = CGSizeMake(viewSize.width, lifeBarViewH + leftRightSpace + couponsPhotoImageViewToBottom + couponsPhotoImage.size.height);
    */
    
    
    //动态重置scrollerView的contentSize
    CGFloat scrollviewContentSizeH = controllerTop + qCoreVIewH + bannerBGViewH + lifeBGViewH + 2*space;
    if (scrollviewContentSizeH>viewSize.height - controllerTop) {
        _scrollView.contentSize = CGSizeMake(viewSize.width, scrollviewContentSizeH);
    }else{
        _scrollView.contentSize = CGSizeMake(viewSize.width, scrollviewContentSizeH);
    }

    //1
    [lifeBgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(bannerBGView.mas_bottom).offset(space);
        make.centerX.equalTo(_scrollView);
        make.size.mas_equalTo(CGSizeMake(viewSize.width, lifeBGViewH));
    }];
    
    
    [lifeBarView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(lifeBgView).offset(0);
        make.centerX.equalTo(lifeBgView);
        make.size.mas_equalTo(CGSizeMake(viewSize.width, lifeBarViewH));
    }];
    
    [verticalV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(lifeBarView).offset(leftRightSpace);
        make.centerY.equalTo(lifeBarView);
        make.size.mas_equalTo(CGSizeMake(2, lifeLabSize.height));
    }];
    
    [lifeLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(verticalV.mas_left).offset(space/2);
        make.centerY.equalTo(lifeBarView);
        make.size.mas_equalTo(lifeLabSize);
    }];
    
    [lifeDecLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(lifeBgView.mas_right).offset(-leftRightSpace);
        make.centerY.equalTo(lifeBarView);
        make.size.mas_equalTo(lifeDecLabSzie);
    }];
    
    [lifeLineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(lifeBarView).offset(leftRightSpace);
        make.bottom.equalTo(lifeBarView.mas_bottom).offset(0);
        make.size.mas_equalTo(CGSizeMake(viewSize.width-leftRightSpace, 1));
    }];
    
    [minletsView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(lifeBarView.mas_bottom).offset(0);
        make.centerX.equalTo(lifeBgView);
        make.size.mas_equalTo(CGSizeMake(viewSize.width, minletsViewH));
    }];
    
    
    
    /*
    //2
    [incomeBGView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(lifeBgView.mas_bottom).offset(space);
        make.centerX.equalTo(_scrollView);
        make.size.mas_equalTo(CGSizeMake(viewSize.width, incomeBGViewH));
    }];
    
    
    [incomeBarView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(incomeBGView).offset(0);
        make.centerX.equalTo(incomeBGView);
        make.size.mas_equalTo(CGSizeMake(viewSize.width, lifeBarViewH));
    }];
    
    [verticalV2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(incomeBarView).offset(leftRightSpace);
        make.centerY.equalTo(incomeBarView);
        make.size.mas_equalTo(CGSizeMake(2, lifeLabSize.height));
    }];
    
    [incomLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(verticalV2.mas_left).offset(space/2);
        make.centerY.equalTo(incomeBarView);
        make.size.mas_equalTo(incomeLabSize);
    }];
    
    [incomeDecLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(incomeBGView.mas_right).offset(-leftRightSpace);
        make.centerY.equalTo(incomeBarView);
        make.size.mas_equalTo(incomeDecLabSize);
    }];
    
    [incomeLineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(incomeBarView).offset(leftRightSpace);
        make.bottom.equalTo(incomeBarView.mas_bottom).offset(0);
        make.size.mas_equalTo(CGSizeMake(viewSize.width-leftRightSpace, 1));
    }];
    
    [incomMoneyLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(incomeBarView.mas_bottom).offset(ToMoneyLabspace);
        make.left.equalTo(incomeBGView).offset(0);
        make.size.mas_equalTo(CGSizeMake(viewSize.width/2, incomeMoneyLabSize.height));
    }];
    
    [incomDecMoneyLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(incomMoneyLab.mas_bottom).offset(space/2);
        make.left.equalTo(incomeBGView).offset(0);
        make.size.mas_equalTo(CGSizeMake(viewSize.width/2, incomeMoneyDecLabSize.height));
    }];
    
    [outcomMoneyLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(incomeBarView.mas_bottom).offset(ToMoneyLabspace);
        make.right.equalTo(incomeBGView.mas_right).offset(0);
        make.size.mas_equalTo(CGSizeMake(viewSize.width/2, incomeMoneyLabSize.height));
    }];
    
    [outcomDecMoneyLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(incomMoneyLab.mas_bottom).offset(space/2);
        make.right.equalTo(incomeBGView.mas_right).offset(0);
        make.size.mas_equalTo(CGSizeMake(viewSize.width/2, incomeMoneyDecLabSize.height));
    }];
    
    
    
    //3
    [mySandCardBGView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(incomeBGView.mas_bottom).offset(space);
        make.centerX.equalTo(_scrollView);
        make.size.mas_equalTo(CGSizeMake(viewSize.width, mySandCargBgViewH));
    }];
    
    
    [mySandCardBarView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(mySandCardBGView).offset(0);
        make.centerX.equalTo(mySandCardBGView);
        make.size.mas_equalTo(CGSizeMake(viewSize.width, lifeBarViewH));
    }];
    
    [verticalV3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(mySandCardBarView).offset(leftRightSpace);
        make.centerY.equalTo(mySandCardBarView);
        make.size.mas_equalTo(CGSizeMake(2, lifeLabSize.height));
    }];
    
    [mySandCardLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(verticalV3.mas_left).offset(space/2);
        make.centerY.equalTo(mySandCardBarView);
        make.size.mas_equalTo(mySandCardLabSize);
    }];
    
    [mySandCardLineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(mySandCardBarView).offset(leftRightSpace);
        make.bottom.equalTo(mySandCardBarView.mas_bottom).offset(0);
        make.size.mas_equalTo(CGSizeMake(viewSize.width-leftRightSpace, 1));
    }];
    
    
    [mySandCardAddBgview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(mySandCardBarView.mas_bottom).offset(mySandCardAddToTop);
        make.left.equalTo(mySandCardBGView).offset(mySandCardAddToleft);
        make.size.mas_equalTo(mySandCardAddBGViewSize);
    }];
    
    
    [mySandCardAddLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(mySandCardAddBgview).offset(mySandCardAddLabToTop);
        make.left.equalTo(mySandCardAddBgview).offset(0);
        make.size.mas_equalTo(CGSizeMake(mySandCardAddBGViewSize.width, mySandCardLabSize.height));
    }];
    
    [mySandCardAddDecLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(mySandCardAddLab.mas_bottom).offset(space/2);
        make.left.equalTo(mySandCardAddBgview).offset(0);
        make.size.mas_equalTo(CGSizeMake(mySandCardAddBGViewSize.width, mySandCardAddDecLabSize.height));
    }];
    
    [mySandCardAddBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(mySandCardAddDecLab.mas_bottom).offset(mySandCardAddLabToBottom);
        make.left.equalTo(mySandCardAddBgview).offset(mySandCardAddBtnToLeft);
        make.size.mas_equalTo(CGSizeMake(mySandCardAddBGViewSize.width - 2*mySandCardAddBtnToLeft, mysandCardAddbtnH));
    }];
    
    
    
    
    //4
    [couponsBGView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(mySandCardBGView.mas_bottom).offset(space);
        make.centerX.equalTo(_scrollView);
        make.size.mas_equalTo(couponsBGviewSize);
    }];
    
    
    [couponsBarView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(couponsBGView).offset(0);
        make.centerX.equalTo(couponsBGView);
        make.size.mas_equalTo(CGSizeMake(viewSize.width, lifeBarViewH));
    }];
    
    [couponsImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(couponsBarView).offset(leftRightSpace);
        make.centerY.equalTo(couponsBarView);
        make.size.mas_equalTo(couponsImage.size);
    }];
    
    [couponsLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(couponsImageView.mas_right).offset(space/2);
        make.centerY.equalTo(couponsBarView);
        make.size.mas_equalTo(couponsLabSize);
    }];
    
    [couponsLineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(couponsBarView).offset(leftRightSpace);
        make.bottom.equalTo(couponsBarView.mas_bottom).offset(0);
        make.size.mas_equalTo(CGSizeMake(viewSize.width-leftRightSpace, 1));
    }];
    
    [couponsPhotoImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(couponsBarView).offset(space);
        make.top.equalTo(couponsBarView.mas_bottom).offset(leftRightSpace);
        make.size.mas_equalTo(CGSizeMake(couponsPhoteImageViewW, couponsPhotoImage.size.height));
        
    }];
    
     */
    

}

- (void)addsdPopView{
    

        btnTitleSize = 12;
        moneyTextSize = 24;
        textSize = 15;


    sdpopViewconfig  = [[SDPopViewConfig alloc] init];
    sdpopViewconfig.triAngelWidth = 8;
    sdpopViewconfig.triAngelHeight = 6;
    sdpopViewconfig.containerViewCornerRadius = 5;
    sdpopViewconfig.roundMargin = 4;
    sdpopViewconfig.layerBackGroundColor = RGBA(64, 131, 215, 1.0);
    sdpopViewconfig.defaultRowHeight = [UIImage imageNamed:@"add_combo_shoufukuan"].size.height + 2*leftRightSpace;
    sdpopViewconfig.tableBackgroundColor = RGBA(247, 247, 247, 1.0);
    sdpopViewconfig.separatorColor = [UIColor blackColor];
    sdpopViewconfig.textColor = [UIColor blackColor];
    sdpopViewconfig.textAlignment = NSTextAlignmentLeft;
    sdpopViewconfig.font = [UIFont systemFontOfSize:textSize];
    sdpopViewconfig.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    
    
    
}


#pragma mark - 初始化子件
/**
 *@brief 初始化子件
 *@param view UIView 参数：组件
 *@return CGFloat
 */
-(CGFloat)initMinletsBtn:(UIView *)view remove:(BOOL)remo
{
    if (remo) {
        return 0;
        
    }
    
    NSString *lets = [SDSqlite selectStringData:[SqliteHelper shareSqliteHelper].sandBaoDB tableName:@"usersconfig" columnName:@"lets" whereColumnString:@"uid" whereParamString:[NSString stringWithFormat:@"%@", [CommParameter sharedInstance].userId]];
    if (lets.length == 0) {
        return 0;
    }
    NSError *error;
    NSData *jsonData = [lets dataUsingEncoding:NSUTF8StringEncoding];

    NSArray *letsArray = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableLeaves error:&error];
    if (minletsArr.count>0) {
        [minletsArr removeAllObjects];
    }
    NSDictionary *moreDic = @{@"logo":@"more",@"title":@"更多",@"id":@"999999",@"url":@"http://www.baidu.com",@"type":@"Button",@"isTest":@"false"};
    
    
    for (int i = 0; i<letsArray.count; i++) {
        NSDictionary *letDic = [SDSqlite selectOneData:[SqliteHelper shareSqliteHelper].sandBaoDB tableName:@"minlets" columnArray:MINLETS_ARR whereColumnString:@"id" whereParamString:[letsArray[i] objectForKey:@"letId"]];
        [minletsArr addObject:letDic];
        
    }
    //末尾追加一个更多按钮
    [minletsArr addObject:moreDic];
    
    
    
    
    
    NSInteger columnNumber = 4;
    //flowLayout布局
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    CGFloat spaceCount = columnNumber + 1 ; //(间隙count永远比列数多1)
    CGFloat cellWith = (self.view.bounds.size.width - spaceCount*leftRightSpace)/columnNumber;
    //cell size
    UIImage *iconImag = [UIImage imageNamed:@"more"];
    CGFloat cellHeight = iconImag.size.height*2;
    //布局item大小
    flowLayout.itemSize = CGSizeMake(cellWith, cellHeight);
    //布局边距
    flowLayout.sectionInset = UIEdgeInsetsMake(leftRightSpace-5, leftRightSpace, leftRightSpace-5, leftRightSpace);
    //布局最小行间距
    flowLayout.minimumLineSpacing = leftRightSpace-5;
    //布局最小列间距
    flowLayout.minimumInteritemSpacing = leftRightSpace;

    
   UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 0) collectionViewLayout:flowLayout];
    collectionView.scrollEnabled = NO;
    collectionView.backgroundColor = [UIColor whiteColor];
    //复用ID必须和代理中的ID一致
    [collectionView registerClass:[SDMajletCell class] forCellWithReuseIdentifier:@"SDMajletCell"];
    collectionView.delegate = self;
    collectionView.dataSource = self;
    [view addSubview:collectionView];
    
    
    NSInteger lineCount = 0;
    if (minletsArr.count%columnNumber == 0) {
        lineCount = minletsArr.count/columnNumber;
    }else{
        if (minletsArr.count<columnNumber*1) {
            lineCount = 1;
        }
        else if (minletsArr.count<columnNumber*2) {
            lineCount = 2;
        }
        else if (minletsArr.count<columnNumber*3) {
            lineCount = 3;
        }
        else if (minletsArr.count<columnNumber*4) {
            lineCount = 4;
        }
    }
    CGFloat collectionViewH = lineCount*cellHeight+lineCount*leftRightSpace;
    collectionView.frame = CGRectMake(0, 0, self.view.bounds.size.width, collectionViewH);
    return collectionViewH;
    
    
    
}

#pragma mark - 按钮事件处理事情
/**
 *@brief 添加按钮添加事件
 *@return
 */
- (void)buttonAction:(id)sender
{
    UIButton *btn = (UIButton *)sender;
    //实名认证
    if ([CommParameter sharedInstance].realNameFlag == NO) {
        [Tool showDialog:@"您还未实名认证,请先实名!" defulBlock:^{
            //点击确定去实名认证
            RealNameAuthenticationViewController *mRealNameAuthenticationViewController = [[RealNameAuthenticationViewController alloc] init];
            [self.navigationController pushViewController:mRealNameAuthenticationViewController animated:YES];
        }];
        
    }else{
    switch (btn.tag) {
        case 1:
        {
            
        }
            break;
        case 2:
        {
            
        }
            break;
        case 101:
        {
            BillViewController *mBillViewController = [[BillViewController alloc] init];
            mBillViewController.titleName = @"账单";
            
            [self.navigationController pushViewController:mBillViewController animated:YES];
        }
            break;
        case 102:
        {
            NSArray *arr = @[@{@"name":@"付款码",@"icon":@"add_combo_shoufukuan"},
                             @{@"name":@"扫一扫",@"icon":@"add_combo_saoyisao"},
                             @{@"name":@"帮助",@"icon":@"add_combo_help"},
                             @{@"name":@"消息",@"icon":@"mqttMsgIcon"}
                             ];
            
            sdPopView = [[SDPopview alloc] initWithBounds:CGRectMake(0, 0, 120, sdpopViewconfig.defaultRowHeight *arr.count) titleInfo:arr config:sdpopViewconfig];
            sdPopView.delegate = self;
            
            [sdPopView showFrom:btn alignStyle:SDPopViewStyleRight];
        }
            break;
        case fukuanTag:
        {
//            NSLog(@"付款码");
            QRCodeViewController *mQRCodeViewController = [[QRCodeViewController alloc] init];
            [self.navigationController pushViewController:mQRCodeViewController animated:YES];
        }
            break;
        case saoTag:
        {
//            NSLog(@"扫一扫");
            ScannerViewController *mScannerViewController = [[ScannerViewController alloc] init];
            [self.navigationController pushViewController:mScannerViewController animated:YES];
        }
            break;
        case kabaoTag:
        {
//            NSLog(@"卡券包");
            [Tool showDialog:@"哎呀,功能还在开发中..."];
        }
            break;
            
        default:
            break;
    }
    }
}


#pragma mark - 滚动图点击方法
-(void)sanBannerViewDelegateClick:(NSInteger)index{
    NSLog(@"点击了第 %ld 张图片",index);
}


#pragma mark - scrollerViewDelegate
//只能向上滚动
-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    if (scrollView.contentOffset.y < 0 || scrollView.contentOffset.y == 0 ) {
        scrollView.contentOffset = CGPointMake(0, 0);
    }
    
}
#pragma mark- SDPopViewDelegate
- (void)popOverView:(SDPopview *)pView didClickMenuIndex:(NSInteger)index{
    //实名认证
    if ([CommParameter sharedInstance].realNameFlag == NO) {
        [Tool showDialog:@"您还未实名认证,请先实名!" defulBlock:^{
            //点击确定去实名认证
            RealNameAuthenticationViewController *mRealNameAuthenticationViewController = [[RealNameAuthenticationViewController alloc] init];
            [self.navigationController pushViewController:mRealNameAuthenticationViewController animated:YES];
        }];
        return;
    }
    switch (index) {
        case 0:
        {
            //付款码
            QRCodeViewController *mQRCodeViewController = [[QRCodeViewController alloc] init];
            [self.navigationController pushViewController:mQRCodeViewController animated:YES];
        }
            break;
        case 1:
        {
            //扫一扫
            ScannerViewController *mScannerViewController = [[ScannerViewController alloc] init];
            [self.navigationController pushViewController:mScannerViewController animated:YES];
        }
            
            
            break;
        case 2:
        {
            //帮助中心
            FAQwebViewController *vc = [[FAQwebViewController alloc] init];
            vc.titleName = @"帮助中心";
            vc.urlstr = [NSString stringWithFormat:@"%@ot/help-normal-FAQ.html",AddressHTTP];
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
            
            
        case 3:
        {

            //查询表所有数据(测试用)
            NSMutableArray *arree =  [SDSqlite selectData:[SqliteHelper shareSqliteHelper].sandBaoDB tableName:@"mqttlist" columnArray:MQTTLIST_ARR];
            NSLog(@"%@",arree);
            
            //读取当前uid下的数据条数
            NSMutableArray *mqttlistArray = [SDSqlite selectWhereData:[SqliteHelper shareSqliteHelper].sandBaoDB tableName:@"mqttlist" columnArray:MQTTLIST_ARR whereColumnString:@"uid" whereParamString:[CommParameter sharedInstance].userId];
            NSLog(@"%@",mqttlistArray);
            if (mqttlistArray.count == 0) {
                [Tool showDialog:@"暂无消息记录"];
                return;
            }
            MqttMsgViewController *mMqttMsgViewController = [[MqttMsgViewController alloc] init];
            [self.navigationController pushViewController:mMqttMsgViewController animated:YES];

        }
            break;
            
        default:
            break;
    }


}
#pragma mark - collectionDelegate
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return minletsArr.count;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *cellID = @"SDMajletCell";
    SDMajletCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellID forIndexPath:indexPath];
    cell.font = 13;
    cell.iconName = [minletsArr[indexPath.row] objectForKey:@"logo"];
    cell.title = [minletsArr[indexPath.row] objectForKey:@"title"];
    return cell;
    
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    //实名认证
    if ([CommParameter sharedInstance].realNameFlag == NO) {
        [Tool showDialog:@"您还未实名认证,请先实名!" defulBlock:^{
            //点击确定去实名认证
            RealNameAuthenticationViewController *mRealNameAuthenticationViewController = [[RealNameAuthenticationViewController alloc] init];
            [self.navigationController pushViewController:mRealNameAuthenticationViewController animated:YES];
        }];
        return;
    }
    NSString *nativeOrHtml = [minletsArr[indexPath.row] objectForKey:@"type"];
    NSString *minletID = [minletsArr[indexPath.row] objectForKey:@"id"];
    [SDLog logTest:[NSString stringWithFormat:@"  minletID == %@",minletID]];
    
    //1.子件触发原生功能
    if ([nativeOrHtml isEqualToString:@"native"]) {
        if ([minletID isEqualToString:@"1"]) { //及时转账
            TransferBeginViewController *transferBeg = [[TransferBeginViewController alloc] init];
            [self.navigationController pushViewController:transferBeg animated:YES];
        }
        
    }
    //2.子件触发html功能
    if ([nativeOrHtml isEqualToString:@"html"]) {
        
        OrderInfoH5ViewController *mOrderInfoH5ViewController = [[OrderInfoH5ViewController alloc] init];
        [self.navigationController pushViewController:mOrderInfoH5ViewController animated:YES];
        
        /*
         Html5ViewController *mHtml5ViewController = [[Html5ViewController alloc] init];
         [self.navigationController pushViewController:mHtml5ViewController animated:YES];
         */
    }
    
    //3.更多按钮
    if ([nativeOrHtml isEqualToString:@"Button"]) {
        mMinletsManagerViewController = [[MinletsManagerViewController alloc] init];
        [self.navigationController pushViewController:mMinletsManagerViewController animated:YES];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}





@end
