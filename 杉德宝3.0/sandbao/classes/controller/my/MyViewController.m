//
//  MyViewController.m
//  sandbao
//
//  Created by blue sky on 2016/10/31.
//  Copyright © 2016年 sand. All rights reserved.
//

#import "MyViewController.h"
#import "IndicatorView.h"
#import "CustomAlertView.h"
#import "SDLog.h"
#import "CommParameter.h"
#import "RealNameAuthenticationViewController.h"
#import "BankListViewController.h"
#import "SandListViewController.h"
#import "SetViewController.h"
#import "TestViewController.h"
//#import "CashRechargeViewController.h"
//#import "ConsumeRechargeViewController.h"
#import "SDCircleView.h"
#import "RechargeResultViewController.h"
#import "RechargeChooseViewController.h"


#define navbarColor [UIColor colorWithRed:(242/255.0) green:(242/255.0) blue:(242/255.0) alpha:1.0]

#define navViewColor [UIColor colorWithRed:(255/255.0) green:(125/255.0) blue:(50/255.0) alpha:1.0]

#define lineViewColor [UIColor colorWithRed:(237/255.0) green:(237/255.0) blue:(237/255.0) alpha:1.0]

#define titleColor [UIColor colorWithRed:(174/255.0) green:(174/255.0) blue:(174/255.0) alpha:1.0]

#define textFiledColor [UIColor colorWithRed:(83/255.0) green:(83/255.0) blue:(83/255.0) alpha:1.0]

#define textFiledColordarkBlue [UIColor colorWithRed:(43/255.0) green:(56/255.0) blue:(87/255.0) alpha:1.0]

#define textFiledColorBlue  [UIColor colorWithRed:(65/255.0) green:(131/255.0) blue:(215/255.0) alpha:1.0]

#define textFiledColorlightGray [UIColor colorWithRed:(191/255.0) green:(195/255.0) blue:(204/255.0) alpha:1.0]

#define viewColor [UIColor colorWithRed:(255/255.0) green:(255/255.0) blue:(255/255.0) alpha:1.0]

@interface MyViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    NavCoverView *navCoverView;
    UITableView *tableview;
    CGFloat tableCellH;
    CGFloat tableViewALLH;
    NSArray *imageArray;
    NSArray *titleArray;
    
}

@property (nonatomic, assign) CGSize viewSize;
@property (nonatomic, assign) CGFloat titleTextSize;
@property (nonatomic, assign) CGFloat labelTextSize;
@property (nonatomic, assign) CGFloat lineViewHeight;
@property (nonatomic, assign) CGFloat leftRightSpace;
@property (nonatomic, strong) SDCircleView *circleView;

@property (nonatomic, strong) IndicatorView *mIndicatorView;
@property (nonatomic, strong) CustomAlertView *alertView;
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UILabel *sumContentLabel;
@property (nonatomic, strong) UILabel *cashContentLabel;
@property (nonatomic, strong) UILabel *consumeContentLabel;
@property (nonatomic, strong) UILabel *bankContentLabel;
@property (nonatomic, strong) UILabel *sandContentLabel;

@property (nonatomic, strong) NSMutableDictionary *cashPayToolDic;
@property (nonatomic, strong) NSMutableDictionary *consumePayToolDic;

@property (nonatomic, strong) NSMutableArray *bankArray;
@property (nonatomic, strong) NSMutableArray *sandArray;



@end

@implementation MyViewController

@synthesize viewSize;
@synthesize titleTextSize;
@synthesize labelTextSize;
@synthesize lineViewHeight;
@synthesize leftRightSpace;


@synthesize mIndicatorView;
@synthesize alertView;
@synthesize scrollView;
@synthesize sumContentLabel;
@synthesize cashContentLabel;
@synthesize consumeContentLabel;
@synthesize bankContentLabel;
@synthesize sandContentLabel;

@synthesize cashPayToolDic;
@synthesize consumePayToolDic;

@synthesize bankArray;
@synthesize sandArray;

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
   
    [self settingData];
}
-(void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    
}
- (void)viewDidLoad {
    [self.view setBackgroundColor:[UIColor colorWithRed:(248/255.0) green:(248/255.0) blue:(248/255.0) alpha:1.0]];
    viewSize = self.view.bounds.size;
    leftRightSpace = 15;
    lineViewHeight = 1;
    
    bankArray = [[NSMutableArray alloc] init];
    sandArray = [[NSMutableArray alloc] init];
    
    mIndicatorView = [IndicatorView loadingImageViewInView:[self.view.window.subviews objectAtIndex:0] msgTille:@"正在加载中......"];
    mIndicatorView.center = CGPointMake(viewSize.width * 0.5, viewSize.height * 0.5);
    
    self.navigationController.navigationBarHidden = YES;
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
    navCoverView = [NavCoverView shareNavCoverView:CGRectMake(0, 0, viewSize.width, controllerTop) title:@"个人中心"];
    [self.view addSubview:navCoverView];
    
    // 2.设置左边的返回item
    UIImage *leftImage = [UIImage imageNamed:@"bank_button_search_normal.png"];
    UIButton *leftBarBtn = [[UIButton alloc] init];
    leftBarBtn.frame = CGRectMake(10, 20 + (40 - leftImage.size.height) / 2, leftImage.size.width, leftImage.size.height);
    leftBarBtn.tag = 101;
    [leftBarBtn setImage:[UIImage imageNamed:@"bank_button_search_normal.png"] forState:UIControlStateNormal];
    [leftBarBtn setImage:[UIImage imageNamed:@"bank_button_search_click.png"] forState:UIControlStateHighlighted];
    leftBarBtn.contentMode = UIViewContentModeScaleAspectFit;
    [leftBarBtn addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
//    [navCoverView addSubview:leftBarBtn];
    
    
    // 3.设置右边的返回item
    UIImage *rightImage = [UIImage imageNamed:@"settings"];
    UIButton *rightBarBtn = [[UIButton alloc] init];
    [rightBarBtn setImage:[UIImage imageNamed:@"settings"] forState:UIControlStateNormal];
    [rightBarBtn setImage:[UIImage imageNamed:@"settings"] forState:UIControlStateHighlighted];
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
    
    if (iPhone4 || iPhone5) {
        titleTextSize = 14;
        labelTextSize = 12;
        tableCellH = 50;
    } else if (iPhone6) {
        titleTextSize = 16;
        labelTextSize = 14;
        tableCellH = 53;
    } else {
        titleTextSize = 19;
        labelTextSize = 17;
        tableCellH = 55;
    }
    
//    UIView *navBarView = [[UIView alloc] init];
//    navBarView.backgroundColor = navbarColor;
//    [view addSubview:navBarView];
//    
//    UIView *navView = [[UIView alloc] init];
//    navView.backgroundColor = navViewColor;
//    [view addSubview:navView];
    
    //创建UIScrollView
    scrollView = [[UIScrollView alloc] init];
    scrollView.userInteractionEnabled = YES;
    scrollView.scrollEnabled = YES;
    scrollView.contentSize = CGSizeMake(viewSize.width, viewSize.height - controllerTop);
    scrollView.directionalLockEnabled = YES; //只能一个方向滑动
    scrollView.pagingEnabled = NO; //是否翻页
    scrollView.showsVerticalScrollIndicator =YES; //垂直方向的滚动指示
    scrollView.indicatorStyle = UIScrollViewIndicatorStyleWhite;//滚动指示的风格
    scrollView.showsHorizontalScrollIndicator = NO;//水平方向的滚动指示
    [scrollView setBackgroundColor:navbarColor];
    scrollView.contentSize = CGSizeMake(viewSize.width, viewSize.height*1.5);
    [view addSubview:scrollView];
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    UIView *userView = [[UIView alloc] init];
    userView.backgroundColor = viewColor;
    [scrollView addSubview:userView];
    
    UIView *userInserView = [[UIView alloc] init];
    userInserView.backgroundColor = viewColor;
    [userView addSubview:userInserView];
    
    UIView *userLineview = [[UIView alloc] init];
    userLineview.backgroundColor = lineViewColor;
    [userInserView addSubview:userLineview];
    
    UIImage *headImage = [UIImage imageNamed:@"login_photo"];
    UIButton *headBtn = [[UIButton alloc] init];
    headBtn.tag = 1;
    [headBtn setImage:headImage forState:UIControlStateNormal];
    headBtn.contentMode = UIViewContentModeScaleAspectFit;
    [userInserView addSubview:headBtn];
    
    UIButton *nickBtn = [[UIButton alloc] init];
    nickBtn.tag = 2;
    [nickBtn addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
    [userInserView addSubview:nickBtn];
    
    UILabel *nickLabel = [[UILabel alloc] init];
    if ([@"" isEqualToString:[CommParameter sharedInstance].userName] || [CommParameter sharedInstance].userName == nil) {
        nickLabel.text = @"杉德宝";
    } else {
        nickLabel.text = [CommParameter sharedInstance].userName;
    }
    nickLabel.textColor = [UIColor blackColor];
    nickLabel.font = [UIFont systemFontOfSize:titleTextSize weight:2];
    [nickBtn addSubview:nickLabel];

    
    UILabel *startLabel = [[UILabel alloc] init];
    startLabel.text = @"未实名认证";
    startLabel.textColor = textFiledColorBlue;
    startLabel.backgroundColor = [UIColor whiteColor];
    
    startLabel.userInteractionEnabled = YES;
    startLabel.font = [UIFont systemFontOfSize:labelTextSize];
    UITapGestureRecognizer *startLabelGeusture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(labelActionToDoSomething)];
    [startLabel addGestureRecognizer:startLabelGeusture];
    [userInserView addSubview:startLabel];
    
    UIButton *userInserViewLeftBtn = [[UIButton alloc] init];
    userInserViewLeftBtn.tag = 3;
    [userInserViewLeftBtn addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
    [userInserView addSubview:userInserViewLeftBtn];
    
    UIImage *qrcodeImage = [UIImage imageNamed:@"qrcode"];
    UIImageView *qrcodeImageView = [[UIImageView alloc] init];
    qrcodeImageView.image = qrcodeImage;
    [userInserViewLeftBtn addSubview:qrcodeImageView];
    
    UIImage *arrowImage = [UIImage imageNamed:@"list_forward"];
    UIImageView *arrowImageView = [[UIImageView alloc] init];
    arrowImageView.image = arrowImage;
    arrowImageView.contentMode = UIViewContentModeScaleAspectFit;
    [userInserViewLeftBtn addSubview:arrowImageView];
    
       //现金按钮
    UIButton *cashBtn = [[UIButton alloc] init];
    cashBtn.tag = 5;
    [cashBtn addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
    [userView addSubview:cashBtn];
    
    
    UILabel *cashLabel = [[UILabel alloc] init];
    cashLabel.text = @"现金余额";
    cashLabel.textColor = textFiledColorlightGray;
    cashLabel.font = [UIFont systemFontOfSize:titleTextSize];
    [userView addSubview:cashLabel];
    
    cashContentLabel = [[UILabel alloc] init];
    cashContentLabel.textColor = textFiledColordarkBlue;
    cashContentLabel.font = [UIFont systemFontOfSize:labelTextSize];
    [userView addSubview:cashContentLabel];
    
    
    //消费区
    UIButton *consumeBtn = [[UIButton alloc] init];
    consumeBtn.tag = 6;
    [consumeBtn addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
    [userView addSubview:consumeBtn];

    UILabel *consumeLabel = [[UILabel alloc] init];
    consumeLabel.text = @"消费余额";
    consumeLabel.textColor = textFiledColorlightGray;
    consumeLabel.textAlignment = NSTextAlignmentCenter;
    consumeLabel.font = [UIFont systemFontOfSize:titleTextSize];
    [userView addSubview:consumeLabel];
    
    consumeContentLabel = [[UILabel alloc] init];
    consumeContentLabel.text = @"2000.00";
    consumeContentLabel.textAlignment = NSTextAlignmentCenter;
    consumeContentLabel.textColor = textFiledColordarkBlue;
    consumeContentLabel.font = [UIFont systemFontOfSize:labelTextSize];
    [userView addSubview:consumeContentLabel];
        
    //银行卡区
    UIButton *bankBtn = [[UIButton alloc] init];
    bankBtn.tag = 7;
    [bankBtn addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
    [userView addSubview:bankBtn];
    

    
    UILabel *bankLabel = [[UILabel alloc] init];
    bankLabel.text = @" 银行卡";
    bankLabel.textColor = textFiledColorlightGray;
    bankLabel.textAlignment = NSTextAlignmentCenter;
    bankLabel.font = [UIFont systemFontOfSize:titleTextSize];
    [userView addSubview:bankLabel];
    
    bankContentLabel = [[UILabel alloc] init];
    bankContentLabel.text = @"0张";
    bankContentLabel.textColor = textFiledColordarkBlue;
    bankContentLabel.textAlignment = NSTextAlignmentCenter;
    bankContentLabel.font = [UIFont systemFontOfSize:labelTextSize];
    [userView addSubview:bankContentLabel];

    //杉德卡区
    UIButton *sandBtn = [[UIButton alloc] init];
    sandBtn.tag = 8;
    [sandBtn addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
    [userView addSubview:sandBtn];

    UILabel *sandLabel = [[UILabel alloc] init];
    sandLabel.text = @"杉德卡";
    sandLabel.textColor = textFiledColorlightGray;
    sandLabel.textAlignment = NSTextAlignmentRight;
    sandLabel.font = [UIFont systemFontOfSize:titleTextSize];
    [userView addSubview:sandLabel];
    
    sandContentLabel = [[UILabel alloc] init];
    sandContentLabel.text = @"0张";
    sandContentLabel.textColor = textFiledColordarkBlue;
    sandContentLabel.textAlignment = NSTextAlignmentRight;
    sandContentLabel.font = [UIFont systemFontOfSize:labelTextSize];
    [userView addSubview:sandContentLabel];
    
    if ([@"false" isEqualToString:[CommParameter sharedInstance].realNameFlag]) {
        startLabel.hidden = NO;
        cashContentLabel.text = @"立即认证";
    } else {
        startLabel.hidden = YES;
        cashContentLabel.text = @"0.00";
    }
    
    
    //钱区
    UIView *moneyView = [[UIView alloc] init];
    moneyView.backgroundColor = viewColor;
    [scrollView addSubview:moneyView];
    
    UIView *sumView = [[UIView alloc] init];
    sumView.backgroundColor = [UIColor clearColor];
    [moneyView addSubview:sumView];
    
    UIView *sumContentView = [[UIView alloc] init];
    sumContentView.backgroundColor = [UIColor clearColor];
    [moneyView addSubview:sumContentView];
    
    UILabel *sumLabel = [[UILabel alloc] init];
    sumLabel.text = @"总资产";
    sumLabel.textColor = titleColor;
    sumLabel.font = [UIFont systemFontOfSize:labelTextSize];
    [sumContentView addSubview:sumLabel];
    
    sumContentLabel = [[UILabel alloc] init];
    sumContentLabel.text = @"5900.00";
    sumContentLabel.textColor = textFiledColor;
    sumContentLabel.font = [UIFont systemFontOfSize:titleTextSize];
    [sumContentView addSubview:sumContentLabel];
    
    UIButton *sumBtn = [[UIButton alloc] init];
    sumBtn.tag = 4;
    [sumBtn setTitle:@"资产总览" forState: UIControlStateNormal];
    [sumBtn setTitleColor:[UIColor colorWithRed:(255/255.0) green:(102/255.0) blue:(51/255.0) alpha:1.0] forState:UIControlStateNormal];
    sumBtn.titleLabel.font = [UIFont systemFontOfSize:titleTextSize];
    [sumBtn.layer setMasksToBounds:YES];
    sumBtn.layer.cornerRadius = 5.0;
    sumBtn.layer.borderWidth = 1;
    sumBtn.layer.borderColor = [[UIColor colorWithRed:(255/255.0) green:(218/255.0) blue:(181/255.0) alpha:1.0] CGColor];
    [sumBtn addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
    [sumContentView addSubview:sumBtn];
    
    UIView *sumLineView = [[UIView alloc] init];
    sumLineView.backgroundColor = lineViewColor;
    [moneyView addSubview:sumLineView];
    
    //圆饼图
    CGFloat offset = 10;
    CGFloat circleViewW = viewSize.width;
    CGFloat circleViewH = circleViewW/2+offset*4;
    _circleView  = [[SDCircleView alloc] initWithFrame:CGRectMake(0, 0,circleViewW, circleViewH) offset:offset  numberArray:@[@"2000.00",@"10800.00"] colorArray:@[[UIColor colorWithRed:240/255.0 green:72/255.0 blue:85/225.0 alpha:1],[UIColor colorWithRed:35/255.0 green:218/255.0 blue:254/225.0 alpha:1]]];
    [moneyView addSubview:_circleView];
    
    
    
    //列表区
    tableview = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, viewSize.width, 0)];
    tableview.delegate = self;
    tableview.dataSource = self;
    imageArray = [NSArray array];
    titleArray = [NSArray array];
    NSURL *persenCenterList = [[NSBundle mainBundle] URLForResource:@"persenCenterList" withExtension:@"plist"];
    NSArray *arr = [NSArray arrayWithContentsOfURL:persenCenterList];
    imageArray = arr[0];
    titleArray = arr[1];
    tableViewALLH = imageArray.count*tableCellH;
    [scrollView addSubview:tableview];

    
    
    // 设置控件的位置和大小
    CGFloat space = 10.0;
    CGFloat upDownSpace = 10;

    
    CGFloat commWidth = viewSize.width - 2 * leftRightSpace;
    
    CGFloat userViewHeight = headImage.size.height + 2 * upDownSpace;

    CGSize nickLabelSize = [nickLabel.text sizeWithNSStringFont:nickLabel.font];
    CGFloat nickBtnWidth = nickLabelSize.width + space ;
    CGFloat nickBtnHeight = nickLabelSize.height;
    
    CGFloat userInserViewLeftBtnW = qrcodeImage.size.width + space + arrowImage.size.width;
    CGFloat userInserViewLeftBtnH = qrcodeImage.size.width;
    
    CGSize sumBtnSize = [sumBtn.titleLabel.text sizeWithNSStringFont:sumBtn.titleLabel.font];
    CGFloat sumBtnWidth = sumBtnSize.width + 2 * space;
    CGFloat sumBtnHeight = sumBtnSize.height + 2 * space;
    CGFloat commLableWidth = commWidth - sumBtnWidth - space;
    CGSize sumLabelSize = [sumLabel sizeThatFits:CGSizeMake(commLableWidth, MAXFLOAT)];
    CGSize sumContentLabelSize = [sumContentLabel sizeThatFits:CGSizeMake(commLableWidth, MAXFLOAT)];
    CGFloat sumContentViewHeight = sumLabelSize.height + space + sumContentLabelSize.height;
    CGFloat sumViewHeight = sumContentViewHeight + 2 * 15;
    CGFloat commBtnWidth = (commWidth - lineViewHeight  - 2 * leftRightSpace) / 2;
    CGFloat commBalanceLabelWidth = commBtnWidth - space;
    CGSize cashLabelSize = [cashLabel sizeThatFits:CGSizeMake(commBalanceLabelWidth, MAXFLOAT)];
    CGSize cashContentLabelSize = [cashContentLabel sizeThatFits:CGSizeMake(commBalanceLabelWidth, MAXFLOAT)];
    CGFloat commBalanceBtnHeight = cashLabelSize.height +space + cashContentLabelSize.height;
    CGSize cashLabWH =  [cashContentLabel.text sizeWithNSStringFont:[UIFont systemFontOfSize:labelTextSize]];
    CGSize consumLabWH = [consumeContentLabel.text sizeWithNSStringFont:[UIFont systemFontOfSize:labelTextSize]];
    CGSize bankLabWH = [bankContentLabel.text sizeWithNSStringFont:[UIFont systemFontOfSize:labelTextSize]];
    CGSize sandLabWH = [sandContentLabel.text sizeWithNSStringFont:[UIFont systemFontOfSize:labelTextSize]];
    
    //四个item的space
    CGFloat fourBtnW = commWidth/4;
    CGFloat moneyViewHeight = sumViewHeight + circleViewH + 2 * lineViewHeight;
    CGFloat userViewAllH = userViewHeight + lineViewHeight + space*2 +commBalanceBtnHeight;
    
    [scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(navCoverView.mas_bottom).offset(0);
        make.centerX.equalTo(view);
        make.size.mas_equalTo(CGSizeMake(viewSize.width, viewSize.height - controllerTop));
    }];
    
    //用户信息
    [userView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(scrollView);
        make.left.equalTo(scrollView).offset(0);
        make.size.mas_equalTo(CGSizeMake(viewSize.width, userViewAllH));
    }];
    
    [userInserView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(userView).offset(0);
        make.left.equalTo(userView).offset(leftRightSpace);
        make.size.mas_equalTo(CGSizeMake(commWidth, userViewHeight));
    }];
    [userLineview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(headBtn.mas_bottom).offset(space);
        make.centerX.equalTo(userView);
        make.size.mas_equalTo(CGSizeMake(commWidth,lineViewHeight));
        
    }];
    [headBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(userInserView).offset(0);
        make.centerY.equalTo(userInserView);
    }];
    
    [nickBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(userInserView).offset(leftRightSpace);
        make.left.equalTo(headBtn.mas_right).offset(leftRightSpace);
        make.size.mas_equalTo(CGSizeMake(nickBtnWidth, nickBtnHeight));
    }];
    
    [nickLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(nickBtn).offset(0);
        make.centerY.equalTo(nickBtn);
        make.size.mas_equalTo(CGSizeMake(nickLabelSize.width, nickLabelSize.height));
    }];
    [startLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(nickBtn.mas_bottom).offset(space);
        make.left.equalTo(headBtn.mas_right).offset(leftRightSpace);
    }];
    [userInserViewLeftBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(userInserView.mas_right).offset(0);
        make.centerY.equalTo(userInserView);
        make.size.mas_equalTo(CGSizeMake(userInserViewLeftBtnW,userInserViewLeftBtnH));
    }];
    [qrcodeImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(userInserViewLeftBtn).offset(0);
        make.centerY.equalTo(userInserViewLeftBtn);
        make.size.mas_equalTo(CGSizeMake(qrcodeImage.size.width, qrcodeImage.size.height));
    }];
    [arrowImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(qrcodeImageView.mas_right).offset(space);
        make.centerY.equalTo(userInserViewLeftBtn);
    }];

    //1现金余额
    [cashBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(userLineview).offset(leftRightSpace);
        make.left.equalTo(userLineview);
        make.size.mas_equalTo(CGSizeMake(fourBtnW, commBalanceBtnHeight));
    }];
    [cashLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(cashBtn).offset(0);
        make.left.equalTo(cashBtn).offset(0);
        make.size.mas_equalTo(CGSizeMake(fourBtnW, cashContentLabelSize.height));

    }];
    [cashContentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(cashLabel.mas_bottom).offset(space);
        make.left.equalTo(cashBtn).offset(0);
        make.size.mas_equalTo(CGSizeMake(cashLabWH.width, cashLabWH.height));
    }];
    

    //2消费余额
    [consumeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(userLineview).offset(leftRightSpace);
        make.left.equalTo(cashBtn.mas_right).offset(0);
            make.size.mas_equalTo(CGSizeMake(fourBtnW, commBalanceBtnHeight));

    }];
    [consumeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(consumeBtn).offset(0);
        make.left.equalTo(consumeBtn).offset(0);
        make.size.mas_equalTo(CGSizeMake(fourBtnW, cashContentLabelSize.height));

    }];
    [consumeContentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(consumeLabel.mas_bottom).offset(space);
        make.centerX.equalTo(consumeLabel).offset(0);
        make.size.mas_equalTo(CGSizeMake(consumLabWH.width, consumLabWH.height));
    }];
    
    //3银联卡
    [bankBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(userLineview).offset(leftRightSpace);
        make.left.equalTo(consumeBtn.mas_right).offset(0);
        make.size.mas_equalTo(CGSizeMake(fourBtnW, commBalanceBtnHeight));

    }];
    [bankLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(bankBtn).offset(0);
        make.left.equalTo(bankBtn).offset(0);
        make.size.mas_equalTo(CGSizeMake(fourBtnW, cashContentLabelSize.height));

    }];
    [bankContentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(bankLabel.mas_bottom).offset(space);
        make.centerX.equalTo(bankLabel).offset(0);
        make.size.mas_equalTo(CGSizeMake(bankLabWH.width, bankLabWH.height));

    }];
    
    //4衫德卡
    [sandBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(userLineview).offset(leftRightSpace);
        make.left.equalTo(bankBtn.mas_right).offset(0);
        make.size.mas_equalTo(CGSizeMake(fourBtnW, commBalanceBtnHeight));

    }];
    [sandLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(sandBtn).offset(0);
        make.left.equalTo(sandBtn).offset(0);
        make.size.mas_equalTo(CGSizeMake(fourBtnW, cashContentLabelSize.height));

    }];
    
    
    [sandContentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(sandLabel.mas_bottom).offset(space);
        make.right.equalTo(sandBtn.mas_right).offset(0);
        make.size.mas_equalTo(CGSizeMake(sandLabWH.width, sandLabWH.height));
    }];
    
    //总资产区
    [moneyView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(userView.mas_bottom).offset(upDownSpace);
        make.left.equalTo(scrollView).offset(0);
        make.size.mas_equalTo(CGSizeMake(viewSize.width, moneyViewHeight));
    }];
    
    [sumView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(moneyView).offset(0);
        make.centerX.equalTo(moneyView);
        make.size.mas_equalTo(CGSizeMake(commWidth, sumViewHeight));
    }];
    
    [sumContentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(sumView);
        make.size.mas_equalTo(CGSizeMake(commWidth, sumContentViewHeight));
    }];
    
    [sumLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(sumContentView).offset(0);
        make.left.equalTo(sumContentView).offset(0);
        make.size.mas_equalTo(CGSizeMake(commLableWidth, sumLabelSize.height));
    }];
    
    [sumContentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(sumLabel.mas_bottom).offset(space);
        make.left.equalTo(sumContentView).offset(0);
        make.size.mas_equalTo(CGSizeMake(commLableWidth, sumContentLabelSize.height));
    }];
    
    [sumBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(sumLabel.mas_right).offset(space);
        make.centerY.equalTo(sumContentView);
        make.size.mas_equalTo(CGSizeMake(sumBtnWidth, sumBtnHeight));
    }];
    
    [sumLineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(sumView.mas_bottom).offset(0);
        make.centerX.equalTo(moneyView);
        make.size.mas_equalTo(CGSizeMake(viewSize.width, lineViewHeight));
    }];
    
    [_circleView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(sumLineView).offset(lineViewHeight);
        make.left.equalTo(moneyView).offset(0);
    }];
    

    //tableView
    [tableview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(moneyView.mas_bottom).offset(space);
        make.left.equalTo(scrollView).offset(0);
        make.size.mas_equalTo(CGSizeMake(viewSize.width, tableViewALLH));
    }];
    
    
}



#pragma mark - tableviewdelegate
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [imageArray count];
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return tableCellH;
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *str = @"cellStr";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:str];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:str];
    }
    cell.imageView.image = [UIImage imageNamed:imageArray[indexPath.row]];
    cell.textLabel.text = titleArray[indexPath.row];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    return cell;
   
}


#pragma mark - 添加按钮添加事件
/**
 *@brief 添加按钮添加事件
 *@return
 */
- (void)buttonAction:(id)sender
{
    UIButton *btn = (UIButton *)sender;
    if(btn.tag == 1) {
        [[self class] cancelPreviousPerformRequestsWithTarget:self selector:@selector(buttonActionToDoSomething:) object:sender];
        [self performSelector:@selector(buttonActionToDoSomething:) withObject:sender afterDelay:1];
    } else if(btn.tag == 4) {
        [[self class] cancelPreviousPerformRequestsWithTarget:self selector:@selector(buttonActionToDoSomething:) object:sender];
        [self performSelector:@selector(buttonActionToDoSomething:) withObject:sender afterDelay:1];
    } else {
        [[self class] cancelPreviousPerformRequestsWithTarget:self selector:@selector(buttonActionToDoSomething:) object:sender];
        [self performSelector:@selector(buttonActionToDoSomething:) withObject:sender afterDelay:0];
    }
}

/**
 *@brief  设置数据
 *@return
 */
- (void)settingData
{
    NSInteger bankCardCount = 0;
    NSInteger sandCardCount = 0;
    CGFloat sumBalance = 0;
    NSArray *payToolsArray = [CommParameter sharedInstance].payToolsArray;
    NSInteger payToolsArrayCount = [payToolsArray count];
    
    for (int i = 0; i < payToolsArrayCount; i++) {
        NSDictionary *dic = payToolsArray[i];
        NSString *type = [dic objectForKey:@"type"];
//        NSDictionary *accountDic = [payToolsArray[i] objectForKey:@"account"];
//        NSString *kind = [accountDic objectForKey:@"kind"];
        
        if ([@"1001" isEqualToString:type]) {
            [SDLog logTest:@"执行到了1001"];
            bankCardCount++;
            [bankArray addObject:dic];
        } else if ([@"1002" isEqualToString:type]) {
            [SDLog logTest:@"执行到了1002"];
            bankCardCount++;
            [bankArray addObject:dic];
        }  else if ([@"1003" isEqualToString:type]) {
            [SDLog logTest:@"执行到了1003"];
            sandCardCount++;
            [sandArray addObject:dic];
        } else if ([@"1004" isEqualToString:type]) {
            [SDLog logTest:@"执行到了1004"];
            sandCardCount++;
        } else if ([@"1005" isEqualToString:type]) {
            [SDLog logTest:@"执行到了1005"];
            cashPayToolDic = payToolsArray[i];
            NSDictionary *accountDic = [cashPayToolDic objectForKey:@"account"];
            NSString *cashBalance = [accountDic objectForKey:@"balance"];
            sumBalance = sumBalance + [cashBalance floatValue];
            cashContentLabel.text = cashBalance;
            if (cashBalance.length == 0 ) {  //消费余额判空
                cashContentLabel.text = @"0.00";
            } else {
                cashContentLabel.text = cashBalance;
            }
            
        } else if ([@"1006" isEqualToString:type]) {
            [SDLog logTest:@"执行到了1006"];
            consumePayToolDic = payToolsArray[i];
            NSDictionary *accountDic = [consumePayToolDic objectForKey:@"account"];
            NSString *consumeBalance = [accountDic objectForKey:@"balance"];
            sumBalance = sumBalance + [consumeBalance floatValue];
            consumeContentLabel.text = consumeBalance;
            if (consumeBalance.length == 0 ) {  //现金余额判空
                consumeContentLabel.text = @"0.00";
            } else {
                consumeContentLabel.text = consumeBalance;
            }
            
        }  else if ([@"1007" isEqualToString:type]) {
            [SDLog logTest:@"执行到了1007"];
        }  else if ([@"1008" isEqualToString:type]) {
            [SDLog logTest:@"执行到了1008"];
        }  else if ([@"1009" isEqualToString:type]) {
            [SDLog logTest:@"执行到了1009"];
        }  else if ([@"1010" isEqualToString:type]) {
            [SDLog logTest:@"执行到了1010"];
        }  else if ([@"1011" isEqualToString:type]) {
            [SDLog logTest:@"执行到了1011"];
            bankCardCount++;
            [bankArray addObject:dic];
        }  else if ([@"1012" isEqualToString:type]) {
            [SDLog logTest:@"执行到了1012"];
            bankCardCount++;
            [bankArray addObject:dic];
        }
    }
    
    sumContentLabel.text = [NSString stringWithFormat:@"%.2f", sumBalance];
    bankContentLabel.text = [NSString stringWithFormat:@"%li张", (long)bankCardCount];
    sandContentLabel.text = [NSString stringWithFormat:@"%li张", (long)sandCardCount];
    
}

#pragma mark - 按钮事件处理事情
/**
 *@brief 添加按钮添加事件
 *@return
 */
- (void)buttonActionToDoSomething:(id)sender
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
        case 3:
        {
            SetViewController *mSetViewController = [[SetViewController alloc] init];
            [self.navigationController pushViewController:mSetViewController animated:YES];
        }
            break;
        case 4:
        {
            RechargeResultViewController *mRechargeResultViewController = [[RechargeResultViewController alloc] init];
            [self.navigationController pushViewController:mRechargeResultViewController animated:YES];
        }
            break;
        case 5:
        {
            if ([@"false" isEqualToString:[CommParameter sharedInstance].realNameFlag]) {
                RealNameAuthenticationViewController *mRealNameAuthenticationViewController = [[RealNameAuthenticationViewController alloc] init];
                [self.navigationController pushViewController:mRealNameAuthenticationViewController animated:YES];
            } else {
//                CashRechargeViewController *mCashRechargeViewController = [[CashRechargeViewController alloc] init];
//                mCashRechargeViewController.cashPayToolDic = cashPayToolDic;
//                [self.navigationController pushViewController:mCashRechargeViewController animated:YES];
                
                RechargeChooseViewController *mRechargeChooseViewController = [[RechargeChooseViewController alloc] init];
                mRechargeChooseViewController.controllerIndex = 0;
                mRechargeChooseViewController.payToolarray = bankArray;
                mRechargeChooseViewController.payToolDic = cashPayToolDic;
                [self.navigationController pushViewController:mRechargeChooseViewController animated:YES];
            }
        }
            break;
        case 6:
        {
            if ([@"false" isEqualToString:[CommParameter sharedInstance].realNameFlag]) {
                RealNameAuthenticationViewController *mRealNameAuthenticationViewController = [[RealNameAuthenticationViewController alloc] init];
                [self.navigationController pushViewController:mRealNameAuthenticationViewController animated:YES];
            } else {
//                ConsumeRechargeViewController *mConsumeRechargeViewController = [[ConsumeRechargeViewController alloc] init];
//                mConsumeRechargeViewController.consumePayToolDic = consumePayToolDic;
//                [self.navigationController pushViewController:mConsumeRechargeViewController animated:YES];
                
                RechargeChooseViewController *mRechargeChooseViewController = [[RechargeChooseViewController alloc] init];
                mRechargeChooseViewController.controllerIndex = 1;
                mRechargeChooseViewController.payToolDic = consumePayToolDic;
                mRechargeChooseViewController.payToolarray = sandArray;
                [self.navigationController pushViewController:mRechargeChooseViewController animated:YES];
            }
        }
            break;
        case 7:
        {
            BankListViewController *mBankListViewController = [[BankListViewController alloc] init];
            mBankListViewController.bankArray = bankArray;
            [self.navigationController pushViewController:mBankListViewController animated:YES];
        }
            break;
        case 8: 
        {
            SandListViewController *mSandListViewController = [[SandListViewController alloc] init];
            mSandListViewController.sandArray = sandArray;
            [self.navigationController pushViewController:mSandListViewController animated:YES];
        }
            break;
        case 101:
        {
            [self.navigationController popViewControllerAnimated:YES];
        }
            break;
        case 102:
        {
            TestViewController *mTestViewController = [[TestViewController alloc] init];
            [self.navigationController pushViewController:mTestViewController animated:YES];
        }
            break;
            
        default:
            break;
    }
}

#pragma mark - 弹出对话框
/**
 *@brief  弹出对话框
 *@param message NSString 参数：消息
 *@param index int 参数：消息索引
 *@return
 */
- (void)showDialog:(NSString *)message index:(int)index
{
    alertView = [[CustomAlertView alloc] initWithTitle:@"提示" message:message buttonTitles:@"确定",@"取消", nil];
    alertView.alertViewStyle = CustomAlertViewStyleDefault;
    switch (index) {
        case 1:
        {
            [alertView showWithCompletion:^(NSInteger selectIndex) {
                
            }];
        }
            break;
        case 2:
        {
            [alertView showWithCompletion:^(NSInteger selectIndex) {
                if (selectIndex == 1) {
                    
                } else {
                    
                }
            }];
        }
            break;
            
        default:
            break;
    }
}

#pragma mark - 添加label添加事件
/**
 *@brief 添加label添加事件
 *@return
 */
- (void)labelActionToDoSomething
{
    RealNameAuthenticationViewController *mRealNameAuthenticationViewController = [[RealNameAuthenticationViewController alloc] init];
    [self.navigationController pushViewController:mRealNameAuthenticationViewController animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


@end
