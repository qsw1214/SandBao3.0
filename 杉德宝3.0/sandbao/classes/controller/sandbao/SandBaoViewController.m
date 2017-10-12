//
//  SandBaoViewController.m
//  sandbao
//
//  Created by blue sky on 2016/10/31.
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
#import "WebbedViewController.h"



#define TitleColor [UIColor colorWithRed:(28/255.0) green:(28/255.0) blue:(28/255.0) alpha:1.0]
#define TitleDecColor [UIColor colorWithRed:(140/255.0) green:(144/255.0) blue:(157/255.0) alpha:1.0]
#define lineColor [UIColor colorWithRed:(229/255.0) green:(229/255.0) blue:(229/255.0) alpha:1.0]

#define fukuanTag 2001
#define saoTag 2002
#define kabaoTag 2003
@interface SandBaoViewController ()<SDBannerViewDelegate,UIScrollViewDelegate>
{
    NavCoverView *navCoverView;
    CGFloat qCoreBotomSpace;
    CGFloat textSize;
    CGFloat btnTitleSize;
    CGFloat qcoreBtHorizonSpace;
    CGFloat space;
    CGFloat bannerBGViewH;
    SDBannerView *bannerBGView;
}

@property (nonatomic, assign) CGSize viewSize;
@property (nonatomic,assign) CGFloat moneyTextSize;
@property (nonatomic, assign) BOOL runFlag;
@property (nonatomic, assign) CGFloat leftRightSpace;

@property (nonatomic, strong) NSMutableArray *minletsArray;
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UIView *minletsView;
@property (nonatomic, strong) MinletsManagerViewController *mMinletsManagerViewController;





@end

@implementation SandBaoViewController

@synthesize viewSize;
@synthesize runFlag;
@synthesize leftRightSpace;
@synthesize minletsArray;
//@synthesize scrollView;
@synthesize minletsView;
@synthesize moneyTextSize;
@synthesize mMinletsManagerViewController;

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];

    [self updateMinlets:_scrollView];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    viewSize = self.view.bounds.size;
    self.navigationController.navigationBarHidden = YES;
    qCoreBotomSpace = 16;
    qcoreBtHorizonSpace = 44.5;
    space = 10;
    bannerBGViewH = 85;
    leftRightSpace = 15;
    
    if (iPhone4 || iPhone5) {
        btnTitleSize = 12;
        moneyTextSize = 24;
        textSize = 15;
    } else if (iPhone6) {
        btnTitleSize = 13;
        moneyTextSize = 25;
        textSize = 16;
    } else {
        btnTitleSize = 14;
        moneyTextSize = 26;
        textSize = 17;
    }
    
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
    UIButton *rightBarBtn = [[UIButton alloc] init];
    [rightBarBtn setImage:[UIImage imageNamed:@"icon_add"] forState:UIControlStateNormal];
    [rightBarBtn setImage:[UIImage imageNamed:@"icon_add"] forState:UIControlStateHighlighted];
    rightBarBtn.frame = CGRectMake(viewSize.width - 10 - rightImage.size.width, 20 + (40 - rightImage.size.height) / 2, rightImage.size.width, rightImage.size.height);
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
    [_scrollView setBackgroundColor:[UIColor colorWithRed:(243/255.0) green:(243/255.0) blue:(243/255.0) alpha:1.0]];
    _scrollView.contentSize = CGSizeMake(viewSize.width, [UIScreen mainScreen].bounds.size.height*1.9);
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
        
    
    //banner区
    NSArray *arr = @[[UIImage imageNamed:@"home_banner"],
                     [UIImage imageNamed:@"home_banner"]];
    bannerBGView = [[SDBannerView alloc] initStyle:SDBannerViewOnlyImage imageArray:arr UrlArray:nil titleArray:nil];
    bannerBGView.delegate = self;
    [_scrollView addSubview:bannerBGView];
    
    //1.懂生活
    UIView *lifeBgView = [[UIView alloc] init];
    lifeBgView.backgroundColor = [UIColor whiteColor];
    [_scrollView addSubview:lifeBgView];
    
    UIView *lifeBarView = [[UIView alloc] init];
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
    
    CGFloat minletsViewH = [self initMinletsBtn:minletsView];
    CGFloat qCoreVIewH  = btnFukuanH+16+qCoreBotomSpace;
    
    //根据frame创建扫码区
    qCoreView.rect = CGRectMake(0, 0, viewSize.width, qCoreVIewH);
    
    //根据frame创建SDBanner区
    bannerBGView.rect = CGRectMake(0, 0, viewSize.width, bannerBGViewH);
    runFlag = YES;
    
    
    
    
    
    //2.资金归去来
    UIView *incomeBGView = [[UIView alloc] init];
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
    incomMoneyLab.textColor = [UIColor colorWithRed:232/255.0 green:56/255.0 blue:43/255.0 alpha:1];
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
    outcomMoneyLab.textColor = [UIColor colorWithRed:71/255.0 green:208/255.0 blue:159/255.0 alpha:1];
    outcomMoneyLab.textAlignment = NSTextAlignmentCenter;
    outcomMoneyLab.font = [UIFont systemFontOfSize:moneyTextSize];
    [incomeBGView addSubview:outcomMoneyLab];
    
    UILabel *outcomDecMoneyLab = [[UILabel alloc] init];
    outcomDecMoneyLab.text = @"10月总支出(元)";
    outcomDecMoneyLab.textColor = TitleDecColor;
    outcomDecMoneyLab.textAlignment = NSTextAlignmentCenter;
    outcomDecMoneyLab.font = [UIFont systemFontOfSize:btnTitleSize];
    [incomeBGView addSubview:outcomDecMoneyLab];
    
    
    
    
    
    
    
    //3.我的杉德卡
    UIView *mySandCardBGView = [[UIView alloc] init];
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
    [mySandCardAddBtn setTitleColor:[UIColor colorWithRed:63/255.0 green:151/255.0 blue:215/255.0 alpha:1] forState:UIControlStateNormal];
    mySandCardAddBtn.layer.cornerRadius = 5;
    mySandCardAddBtn.layer.masksToBounds = YES;
    mySandCardAddBtn.layer.borderWidth = 1;
    mySandCardAddBtn.layer.borderColor = [UIColor colorWithRed:63/255.0 green:151/255.0 blue:215/255.0 alpha:1].CGColor;
    [mySandCardAddBgview addSubview:mySandCardAddBtn];
    
    
    
    
    
    
    
    //4.优惠券
    UIView *couponsBGView = [[UIView alloc] init];
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
    

    //1
    CGFloat ToMoneyLabspace = 35.0f;
    CGSize lifeDecLabSzie = [lifeDecLab.text sizeWithNSStringFont:[UIFont systemFontOfSize:btnTitleSize]];
    CGFloat lifeBarViewH = lifeLabSize.height + 2*leftRightSpace;
    CGFloat lifeBGViewH = lifeBarViewH + minletsViewH;
    
    //2
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

    
    
}

/**
 *@brief 更新子件
 *@param view UIView 参数：组件
 *@return CGFloat
 */
- (void)updateMinlets: (UIView *)view
{
    if (!runFlag) {
        [minletsView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
        
        CGFloat minletsViewH = [self initMinletsBtn:minletsView];
        
        [minletsView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(bannerBGView.mas_bottom).offset(space);
            make.centerX.equalTo(_scrollView);
            make.size.mas_equalTo(CGSizeMake(viewSize.width, minletsViewH));
        }];
    }
}


/**
 *@brief 初始化子件
 *@param view UIView 参数：组件
 *@return CGFloat
 */
-(CGFloat)initMinletsBtn:(UIView *)view
{
    CGFloat height = 0;
    
    NSMutableArray *columnArray = [[NSMutableArray alloc] init];
    [columnArray addObject:@"letId"];
    [columnArray addObject:@"allowed"];
    [columnArray addObject:@"caption"];
    [columnArray addObject:@"icon"];
    [columnArray addObject:@"h5_addr"];
    
    NSString *lets = [SDSqlite selectStringData:[SqliteHelper shareSqliteHelper].sandBaoDB tableName:@"usersconfig" columnName:@"lets" whereColumnString:@"uid" whereParamString:[NSString stringWithFormat:@"%@", [CommParameter sharedInstance].userId]];
    
    NSError *error;
    NSData *jsonData = [lets dataUsingEncoding:NSUTF8StringEncoding];
    NSArray *letsArray = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableLeaves error:&error];
    
    NSInteger letsArrayCount = [letsArray count];
    NSInteger count = 0;
    
    if (letsArrayCount == 0) {
        count = letsArrayCount + 1;
    } else if (letsArrayCount == 3) {
        count = letsArrayCount + 1;
    } else if (letsArrayCount >= 8) {
        count = 8;
    } else {
        count = letsArrayCount + 1;
    }
    
    // 配置空间和大小
    CGFloat leftRightSpace = 15;
//    CGFloat space = 10;
    CGFloat minletsBtnW = (viewSize.width - leftRightSpace * 2 - space * 3) / 4.0;
    CGFloat minletsImageViewW = 0;
    
    CGFloat OX = 0;
    CGFloat OY = 0;
    
    for (int i = 0; i < count; i++) {
        
        if (count > 1 && i < count - 1) {
            
            NSDictionary *letsDic = letsArray[i];
            NSMutableDictionary *minletsDic = [SDSqlite selectOneData:[SqliteHelper shareSqliteHelper].sandBaoDB tableName:@"minlets" columnArray:columnArray whereColumnString:@"letId" whereParamString:[letsDic objectForKey:@"letId"]];
            
            //子件按钮
            UIButton *minletsBtn = [[UIButton alloc] init];
            [minletsBtn setTag:1000 + i + 1];
            [minletsBtn setBackgroundImage:[UIImage imageWithColor:[UIColor whiteColor]] forState:UIControlStateNormal];
            [minletsBtn setBackgroundImage:[UIImage imageWithColor:[UIColor grayColor]] forState:UIControlStateHighlighted];
            [minletsBtn addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
            [view addSubview:minletsBtn];
            
            //子件图标
            UIImage *image = [UIImage imageNamed:[minletsDic objectForKey:@"icon"]];
            UIImageView *minletsImageView = [[UIImageView alloc] init];
            minletsImageView.image = image;
            minletsImageView.contentMode = UIViewContentModeScaleAspectFit;
            [minletsBtn addSubview:minletsImageView];
            
            //子件标题
            UILabel *minletsLabel = [[UILabel alloc] init];
            minletsLabel.text = [minletsDic objectForKey:@"caption"];
            minletsLabel.textColor = [UIColor blackColor];
            minletsLabel.font = [UIFont systemFontOfSize:12];
            minletsLabel.textAlignment = NSTextAlignmentCenter;
            [minletsBtn addSubview:minletsLabel];
            
            //设置控件的位置和大小
            minletsImageViewW = image.size.width;
            CGSize minletsLabelSize = [minletsLabel sizeThatFits:CGSizeMake(minletsBtnW, MAXFLOAT)];
            
            if (i < 4) {
                OX = leftRightSpace + i * (minletsBtnW + space);
                OY = 0;
                height = minletsBtnW;
                [minletsBtn mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.top.equalTo(view).offset(OY);
                    make.left.equalTo(view).offset(OX);
                    make.size.mas_equalTo(CGSizeMake(minletsBtnW, minletsBtnW));
                }];
                
                [minletsImageView mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.top.equalTo(minletsBtn).offset((minletsBtnW - minletsImageViewW - space - minletsLabelSize.height) / 2);
                    make.centerX.equalTo(minletsBtn);
                    make.size.mas_equalTo(CGSizeMake(minletsImageViewW, minletsImageViewW));
                }];
                
                [minletsLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.top.equalTo(minletsImageView.mas_bottom).offset(space);
                    make.centerX.equalTo(minletsBtn);
                    make.size.mas_equalTo(CGSizeMake(minletsBtnW, minletsLabelSize.height));
                }];
            } else {
                OX = leftRightSpace + (i - 4) * (minletsBtnW + space);
                OY = minletsBtnW + space;
                height = minletsBtnW * 2 + space;
                [minletsBtn mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.top.equalTo(view).offset(OY);
                    make.left.equalTo(view).offset(OX);
                    make.size.mas_equalTo(CGSizeMake(minletsBtnW, minletsBtnW));
                }];
                
                [minletsImageView mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.top.equalTo(minletsBtn).offset((minletsBtnW - minletsImageViewW - space - minletsLabelSize.height) / 2);
                    make.centerX.equalTo(minletsBtn);
                    make.size.mas_equalTo(CGSizeMake(minletsImageViewW, minletsImageViewW));
                }];
                
                [minletsLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.top.equalTo(minletsImageView.mas_bottom).offset(space);
                    make.centerX.equalTo(minletsBtn);
                    make.size.mas_equalTo(CGSizeMake(minletsBtnW, minletsLabelSize.height));
                }];
            }
            
        } else {
            //子件按钮
            UIButton *minletsBtn = [[UIButton alloc] init];
            [minletsBtn setTag:1008];
            [minletsBtn setBackgroundImage:[UIImage imageWithColor:[UIColor whiteColor]] forState:UIControlStateNormal];
            [minletsBtn setBackgroundImage:[UIImage imageWithColor:[UIColor grayColor]] forState:UIControlStateHighlighted];
            [minletsBtn addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
            [view addSubview:minletsBtn];
            
            //子件图标
            UIImage *image = [UIImage imageNamed:@"more"];
            UIImageView *minletsImageView = [[UIImageView alloc] init];
            minletsImageView.image = image;
            minletsImageView.contentMode = UIViewContentModeScaleAspectFit;
            [minletsBtn addSubview:minletsImageView];
            
            //子件标题
            UILabel *minletsLabel = [[UILabel alloc] init];
            minletsLabel.text = @"更多";
            minletsLabel.textColor = [UIColor blackColor];
            minletsLabel.font = [UIFont systemFontOfSize:12 ];
            minletsLabel.textAlignment = NSTextAlignmentCenter;
            [minletsBtn addSubview:minletsLabel];
            
            //设置控件的位置和大小
            CGSize minletsLabelSize = [minletsLabel sizeThatFits:CGSizeMake(minletsBtnW, MAXFLOAT)];
            
            if (i < 4) {
                OX = leftRightSpace + i * (minletsBtnW + space);
                OY = 0;
                height = minletsBtnW;
            } else {
                OX = leftRightSpace + (i - 4) * (minletsBtnW + space);
                OY = minletsBtnW + space;
                height = minletsBtnW * 2 + space;
            }
            
            [minletsBtn mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(view).offset(OY);
                make.left.equalTo(view).offset(OX);
                make.size.mas_equalTo(CGSizeMake(minletsBtnW, minletsBtnW));
            }];
            
            [minletsImageView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(minletsBtn).offset((minletsBtnW - minletsImageViewW - space - minletsLabelSize.height) / 2);
                make.centerX.equalTo(minletsBtn);
                make.size.mas_equalTo(CGSizeMake(minletsImageViewW, minletsImageViewW));
            }];
            
            [minletsLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(minletsImageView.mas_bottom).offset(space);
                make.centerX.equalTo(minletsBtn);
                make.size.mas_equalTo(CGSizeMake(minletsBtnW, minletsLabelSize.height));
            }];
        }
    }
    
    return height;
}

#pragma mark - 按钮事件处理事情
/**
 *@brief 添加按钮添加事件
 *@return
 */
- (void)buttonAction:(id)sender
{
    UIButton *btn = (UIButton *)sender;
    
    switch (btn.tag) {
        case 1:
        {
            
        }
            break;
        case 2:
        {
            
        }
            break;
        case 1001:
        {
            TransferBeginViewController *transferBeg = [[TransferBeginViewController alloc] init];
            [self.navigationController pushViewController:transferBeg animated:YES];
        }
            break;
        case 1002:
        {
            WebbedViewController *mWebbedViewController = [[WebbedViewController alloc] init];
            [self.navigationController pushViewController:mWebbedViewController animated:YES];
        }
            break;
        case 1003:
        {
            Html5ViewController *mHtml5ViewController = [[Html5ViewController alloc] init];
            [self.navigationController pushViewController:mHtml5ViewController animated:YES];
        }
            break;
        case 1004:
        {
            
        }
            break;
        case 1005:
        {
            
        }
            break;
        case 1006:
        {
            
        }
            break;
        case 1007:
        {
            
        }
            break;
        case 1008:
        {
            
            
            if (mMinletsManagerViewController == nil) {
                mMinletsManagerViewController = [[MinletsManagerViewController alloc] init];
            }
            
            [self.navigationController pushViewController:mMinletsManagerViewController animated:YES];
            runFlag = NO;
        }
            break;
        case 101:
        {
            BillViewController *mBillViewController = [[BillViewController alloc] init];
            
            [self.navigationController pushViewController:mBillViewController animated:YES];
        }
            break;
        case 102:
        {
            
        }
            break;
        case fukuanTag:
        {
            NSLog(@"付款码");
            QRCodeViewController *mQRCodeViewController = [[QRCodeViewController alloc] init];
            [self.navigationController pushViewController:mQRCodeViewController animated:YES];
        }
            break;
        case saoTag:
        {
            NSLog(@"扫一扫");
            ScannerViewController *mScannerViewController = [[ScannerViewController alloc] init];
            [self.navigationController pushViewController:mScannerViewController animated:YES];
        }
            break;
        case kabaoTag:
        {
            NSLog(@"卡券包");
        }
            break;
            
        default:
            break;
    }
}
-(void)sanBannerViewDelegateClick:(NSInteger)index{
    NSLog(@"点击了第 %ld 张图片",index);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

#pragma mark - scrollerViewDelegate
//只能向上滚动
-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    if (scrollView.contentOffset.y < 0 || scrollView.contentOffset.y == 0 ) {
        scrollView.contentOffset = CGPointMake(0, 0);
    }
    
}


@end
