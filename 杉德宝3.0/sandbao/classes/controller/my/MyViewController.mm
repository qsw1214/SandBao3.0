//
//  MyViewController.m
//  sandbao
//
//  Created by tianNanYiHao on 2016/10/31.
//  Copyright © 2016年 sand. All rights reserved.
//

#import "MyViewController.h"


#import "SDLog.h"
#import "PayNucHelper.h"
#import "CommParameter.h"
#import "RealNameAuthenticationViewController.h"
#import "BankListViewController.h"
#import "SandListViewController.h"
#import "SetViewController.h"

#import "SDCircleView.h"
#import "RechargeChooseViewController.h"
#import "AccountManageViewController.h"

#import "Base64Util.h"
#import "GzipUtility.h"


#define navbarColor RGBA(242, 242, 242, 1.0)

#define navViewColor RGBA(255, 125, 50, 1.0)

#define lineViewColor RGBA(237, 237, 237, 1.0)

#define titleColor RGBA(174, 174, 174, 1.0)

#define textFiledColor RGBA(83, 83, 83, 1.0)

#define textFiledColordarkBlue RGBA(43, 56, 87, 1.0)

#define textFiledColorBlue  RGBA(65, 131, 215, 1.0)

#define textFiledColorlightGray RGBA(191, 195, 204, 1.0)

#define viewColor RGBA(255, 255, 255, 1.0)

@interface MyViewController ()<UITableViewDelegate,UITableViewDataSource,UINavigationControllerDelegate,UIImagePickerControllerDelegate>
{
    NavCoverView *navCoverView;
    UITableView *tableview;
    CGFloat tableCellH;
    CGFloat tableViewALLH;
    NSArray *imageArray;
    NSArray *titleArray;
    UILabel *nickLabel;
    UILabel *startLabel;

    UIImageView *headImageView;
    NSString *base64Str;
}

@property (nonatomic, assign) CGSize viewSize;
@property (nonatomic, assign) CGFloat titleTextSize;
@property (nonatomic, assign) CGFloat labelTextSize;
@property (nonatomic, assign) CGFloat lineViewHeight;
@property (nonatomic, assign) CGFloat leftRightSpace;
@property (nonatomic, assign) CGFloat cashBalance;
@property (nonatomic, assign) CGFloat consumeBalance;
@property (nonatomic, strong) SDCircleView *circleView;

@property (nonatomic, strong) SDMBProgressView *HUD;



@property (nonatomic, strong) UIScrollView *scrollView;
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

@synthesize cashBalance;
@synthesize consumeBalance;
@synthesize HUD;



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
    
    //1.刷新支付工具:设置各payTool数据
    [self settingData];
    
    //2.刷新用户个人信息
    [self updataUserInfo];
    
    //3.刷新实名认证FLag
    if ([CommParameter sharedInstance].realNameFlag == NO) {
        cashContentLabel.text = @"0.00";
        
        startLabel.text = @"未实名认证";
        startLabel.textColor = textFiledColorlightGray;
        startLabel.layer.cornerRadius = 1.5f;
        startLabel.layer.borderColor = textFiledColorlightGray.CGColor;
        startLabel.layer.borderWidth = 0.5f;
    }else{
        startLabel.text = @"已实名认证";
        startLabel.textColor = RGBA(116, 212, 120, 1.0f);
        startLabel.layer.cornerRadius = 1.5f;
        startLabel.layer.borderColor = RGBA(116, 212, 120, 1.0f).CGColor;
        startLabel.layer.borderWidth = 0.5f;
    }
    
}
-(void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
}
- (void)viewDidLoad {
    
    [self.view setBackgroundColor:RGBA(248, 248, 248, 1.0)];
    viewSize = self.view.bounds.size;
    leftRightSpace = 15;
    lineViewHeight = 1;
    
    bankArray = [[NSMutableArray alloc] init];
    sandArray = [[NSMutableArray alloc] init];
    

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
    [HUD hidden];
                

        titleTextSize = 14;
        labelTextSize = 12;
        tableCellH = 50;

    
    
    //创建UIScrollView
    _scrollView = [[UIScrollView alloc] init];
    _scrollView.userInteractionEnabled = YES;
    _scrollView.scrollEnabled = YES;
    _scrollView.delegate = self;
    _scrollView.contentSize = CGSizeMake(viewSize.width, viewSize.height - controllerTop);
    _scrollView.directionalLockEnabled = YES; //只能一个方向滑动
    _scrollView.pagingEnabled = NO; //是否翻页
    _scrollView.showsVerticalScrollIndicator =YES; //垂直方向的滚动指示
    _scrollView.indicatorStyle = UIScrollViewIndicatorStyleWhite;//滚动指示的风格
    _scrollView.showsHorizontalScrollIndicator = NO;//水平方向的滚动指示
    [_scrollView setBackgroundColor:navbarColor];
    
    [view addSubview:_scrollView];
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    UIView *userView = [[UIView alloc] init];
    userView.backgroundColor = viewColor;
    [_scrollView addSubview:userView];
    
    UIView *userInserView = [[UIView alloc] init];
    userInserView.backgroundColor = viewColor;
    [userView addSubview:userInserView];
    
    UIView *userLineview = [[UIView alloc] init];
    userLineview.backgroundColor = lineViewColor;
    [userInserView addSubview:userLineview];
    
    UIImage *headImage = [UIImage imageNamed:@"banaba_cot"];
    headImageView = [[UIImageView alloc] init];
    headImageView.tag = 1;
    UITapGestureRecognizer *headViewTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapHeadView:)];
    headViewTap.numberOfTapsRequired = 1;
    [headImageView addGestureRecognizer:headViewTap];
    headImageView.userInteractionEnabled = YES;
    headImageView.image = headImage;
    headImageView.layer.cornerRadius = headImage.size.height/2;
    headImageView.layer.masksToBounds = YES;
    headImageView.layer.borderColor = RGBA(51, 165, 218, 1.0f).CGColor;
    headImageView.layer.borderWidth = 1.0f;
    [userInserView addSubview:headImageView];
    
    UIButton *nickBtn = [[UIButton alloc] init];
    nickBtn.tag = 2;
    [nickBtn addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
    [userInserView addSubview:nickBtn];
    
    nickLabel = [[UILabel alloc] init];
    nickLabel.textColor = [UIColor blackColor];
    nickLabel.text = @"我的杉德宝";
    nickLabel.font = [UIFont systemFontOfSize:titleTextSize weight:2];
    [nickBtn addSubview:nickLabel];

    
    
    startLabel = [[UILabel alloc] init];
    startLabel.text = @" 未实名认证 ";
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
    cashLabel.textAlignment = NSTextAlignmentCenter;
    cashLabel.font = [UIFont systemFontOfSize:titleTextSize];
    [userView addSubview:cashLabel];
    
    cashContentLabel = [[UILabel alloc] init];
    cashContentLabel.textColor = textFiledColordarkBlue;
    cashContentLabel.textAlignment = NSTextAlignmentCenter;
    cashContentLabel.text =  [NSString stringWithFormat:@"%.2f",cashBalance];
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
    consumeContentLabel.text =  [NSString stringWithFormat:@"%.2f",consumeBalance];
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
    sandLabel.textAlignment = NSTextAlignmentCenter;
    sandLabel.font = [UIFont systemFontOfSize:titleTextSize];
    [userView addSubview:sandLabel];
    
    sandContentLabel = [[UILabel alloc] init];
    sandContentLabel.text = @"0张";
    sandContentLabel.textColor = textFiledColordarkBlue;
    sandContentLabel.textAlignment = NSTextAlignmentCenter;
    sandContentLabel.font = [UIFont systemFontOfSize:labelTextSize];
    [userView addSubview:sandContentLabel];
    
    if ([CommParameter sharedInstance].realNameFlag == NO) {
        cashContentLabel.text = @"立即认证";
    } else {
        cashContentLabel.text = [NSString stringWithFormat:@"%.2f",cashBalance];
    }
    
    //钱区
    UIView *moneyView = [[UIView alloc] init];
    moneyView.backgroundColor = viewColor;
    [_scrollView addSubview:moneyView];
    
    UIView *sumView = [[UIView alloc] init];
    sumView.backgroundColor = [UIColor clearColor];
    [moneyView addSubview:sumView];
    
    UIView *sumContentView = [[UIView alloc] init];
    sumContentView.backgroundColor = [UIColor clearColor];
    [moneyView addSubview:sumContentView];
    
    UILabel *sumLabel = [[UILabel alloc] init];
    sumLabel.text = @"总资产占比分析图";
    sumLabel.textColor = textFiledColor;
    sumLabel.font = [UIFont systemFontOfSize:labelTextSize];
    [sumContentView addSubview:sumLabel];
    
    UIView *sumLineView = [[UIView alloc] init];
    sumLineView.backgroundColor = lineViewColor;
    [moneyView addSubview:sumLineView];
    
    //圆饼图
    CGFloat offset = 10;
    CGFloat circleViewW = viewSize.width;
    CGFloat circleViewH = circleViewW/2+offset*4;
    _circleView  = [[SDCircleView alloc] initWithFrame:CGRectMake(0, 0,circleViewW, circleViewH) offset:offset  numberArray:@[[NSString stringWithFormat:@"%.2f",cashBalance],[NSString stringWithFormat:@"%.2f",consumeBalance]] colorArray:@[RGBA(240, 72, 85, 1.0),RGBA(35, 218, 254, 1.0)]];
    [moneyView addSubview:_circleView];
    
    
    
    //服务助手bg
    UIView *viewServerBG = [[UIView alloc] init];
    viewServerBG.backgroundColor = [UIColor whiteColor];
    [_scrollView addSubview:viewServerBG];
    
    //服务助手
    UILabel *serverLab = [[UILabel alloc] init];
    serverLab.text = @"服务助手";
    serverLab.textColor = textFiledColor;
    serverLab.textAlignment = NSTextAlignmentLeft;
    serverLab.font = [UIFont systemFontOfSize:titleTextSize];
    [viewServerBG addSubview:serverLab];
    
    //服务助手
    UILabel *serverDecLab = [[UILabel alloc] init];
    serverDecLab.text = @"方便快捷的一站式生活助手";
    serverDecLab.textColor = textFiledColorlightGray;
    serverDecLab.textAlignment = NSTextAlignmentRight;
    serverDecLab.font = [UIFont systemFontOfSize:labelTextSize];
    [viewServerBG addSubview:serverDecLab];
    
    
    
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
    [_scrollView addSubview:tableview];

    
    // 设置控件的位置和大小
    CGFloat space = 10.0;
    CGFloat upDownSpace = 10;

    
    CGFloat commWidth = viewSize.width - 2 * leftRightSpace;
    
    CGFloat userViewHeight = headImage.size.height + 2 * upDownSpace;

    CGFloat nickLabelSizeH = [@"nickLabelSizeH" sizeWithNSStringFont:[UIFont systemFontOfSize:titleTextSize]].height;
    CGFloat nickLabelSizeW = commWidth - qrcodeImage.size.width - headImage.size.width - 2*leftRightSpace;
    CGFloat nickBtnWidth = nickLabelSizeW + space ;
    CGFloat nickBtnHeight = nickLabelSizeH;
    
    CGFloat userInserViewLeftBtnW = qrcodeImage.size.width + space + arrowImage.size.width;
    CGFloat userInserViewLeftBtnH = qrcodeImage.size.width;
    
    CGFloat commLableWidth = commWidth;
    CGSize sumLabelSize = [sumLabel sizeThatFits:CGSizeMake(commLableWidth, MAXFLOAT)];
    CGFloat sumContentViewHeight = sumLabelSize.height;
    CGFloat sumViewHeight = sumContentViewHeight + 2 * leftRightSpace;
    CGFloat commBtnWidth = (commWidth - lineViewHeight  - 2 * leftRightSpace) / 2;
    CGFloat commBalanceLabelWidth = commBtnWidth - space;
    CGSize cashLabelSize = [cashLabel sizeThatFits:CGSizeMake(commBalanceLabelWidth, MAXFLOAT)];
    CGSize cashContentLabelSize = [cashContentLabel sizeThatFits:CGSizeMake(commBalanceLabelWidth, MAXFLOAT)];
    CGFloat commBalanceBtnHeight = cashLabelSize.height +space + cashContentLabelSize.height;
    
    //四个item的space
    CGFloat fourBtnW = commWidth/4;
    CGFloat moneyViewHeight = sumViewHeight + circleViewH + 2 * lineViewHeight;
    
    CGSize cashLabWH =  [cashContentLabel sizeThatFits:CGSizeMake(fourBtnW, MAXFLOAT)];
    CGSize consumLabWH = [consumeContentLabel sizeThatFits:CGSizeMake(fourBtnW, MAXFLOAT)];
    CGSize bankLabWH = [bankContentLabel sizeThatFits:CGSizeMake(fourBtnW, MAXFLOAT)];
    CGSize sandLabWH = [sandContentLabel sizeThatFits:CGSizeMake(fourBtnW, MAXFLOAT)];
    CGFloat userViewAllH = userViewHeight + lineViewHeight + space*2 +commBalanceBtnHeight;
    
    CGSize serverLabSize = [serverLab.text sizeWithNSStringFont:[UIFont systemFontOfSize:titleTextSize]];
    CGSize serverBGSize = CGSizeMake(viewSize.width, serverLabSize.height+2*leftRightSpace);
    
    //重置滚动区间
    CGFloat scrollviewContainSizeH = tableViewALLH + userViewHeight + moneyViewHeight + serverBGSize.height + 2*leftRightSpace + controllerTop*2;
    _scrollView.contentSize = CGSizeMake(viewSize.width, scrollviewContainSizeH);
    
    
    [_scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(navCoverView.mas_bottom).offset(0);
        make.centerX.equalTo(view);
        make.size.mas_equalTo(CGSizeMake(viewSize.width, viewSize.height - controllerTop));
    }];
    
    //用户信息
    [userView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_scrollView);
        make.left.equalTo(_scrollView).offset(0);
        make.size.mas_equalTo(CGSizeMake(viewSize.width, userViewAllH));
    }];

    
    
    [userInserView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(userView).offset(0);
        make.left.equalTo(userView).offset(leftRightSpace);
        make.size.mas_equalTo(CGSizeMake(commWidth, userViewHeight));
    }];
    [userLineview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(headImageView.mas_bottom).offset(space);
        make.centerX.equalTo(userView);
        make.size.mas_equalTo(CGSizeMake(commWidth,lineViewHeight));
        
    }];
    
    [headImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(userInserView).offset(0);
        make.centerY.equalTo(userInserView);
        make.size.mas_equalTo(headImage.size);
    }];
    
    [nickBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(headImageView.mas_right).offset(leftRightSpace);
        make.centerY.equalTo(headImageView.mas_centerY).offset(-space);
        make.size.mas_equalTo(CGSizeMake(nickBtnWidth, nickBtnHeight));
    }];
    
    [nickLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(nickBtn).offset(0);
        make.centerY.equalTo(nickBtn);
        make.size.mas_equalTo(CGSizeMake(nickLabelSizeW, nickLabelSizeH));
    }];
    [startLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(nickBtn.mas_bottom).offset(space/2);
        make.left.equalTo(headImageView.mas_right).offset(leftRightSpace);
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
        make.size.mas_equalTo(CGSizeMake(fourBtnW, cashLabWH.height));
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
        make.size.mas_equalTo(CGSizeMake(fourBtnW, consumLabWH.height));
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
        make.size.mas_equalTo(CGSizeMake(fourBtnW, bankLabWH.height));

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
        make.size.mas_equalTo(CGSizeMake(fourBtnW, sandLabWH.height));
    }];
    
    //总资产区
    [moneyView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(userView.mas_bottom).offset(upDownSpace);
        make.left.equalTo(_scrollView).offset(0);
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
    
    [sumLineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(sumView.mas_bottom).offset(0);
        make.centerX.equalTo(moneyView);
        make.size.mas_equalTo(CGSizeMake(viewSize.width, lineViewHeight));
    }];
    
    [_circleView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(sumLineView).offset(lineViewHeight);
        make.left.equalTo(moneyView).offset(0);
    }];
    
    
    //serverBG
    [viewServerBG mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(moneyView.mas_bottom).offset(space);
        make.centerX.equalTo(_scrollView.mas_centerX).offset(0);
        make.size.mas_equalTo(serverBGSize);
    }];
    
    [serverLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(viewServerBG.mas_centerY).offset(0);
        make.left.equalTo(moneyView).offset(space);
        make.size.mas_equalTo(serverLabSize);
    }];

    [serverDecLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(viewServerBG.mas_centerY).offset(0);
        make.right.equalTo(moneyView.mas_right).offset(-space);
        make.size.mas_equalTo(CGSizeMake(commWidth-serverLabSize.width, serverLabSize.height));
    }];
    //tableView
    [tableview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(viewServerBG.mas_bottom).offset(1);
        make.left.equalTo(_scrollView).offset(0);
        make.size.mas_equalTo(CGSizeMake(viewSize.width, tableViewALLH));
    }];
    
    
}

#pragma makr - 刷新用户个人信息
- (void)updataUserInfo{
    
    
    //刷新昵称
    if ([CommParameter sharedInstance].nick.length>0) {
        nickLabel.text = [CommParameter sharedInstance].nick;
    }else{
        nickLabel.text = @"我的杉德宝";
       
    }
    //刷新头像数据
    NSString *str = [CommParameter sharedInstance].avatar;
    if (str==nil) {
        headImageView.image = [UIImage imageNamed:@"banaba_cot"];
        return;
    }
    //填充头像
    UIImage *headimg = [Tool avatarImageWith:str];
    headImageView.image = headimg;
    
    
    NSData *saveHeadImageData = UIImageJPEGRepresentation(headimg, 1.0f);
    //沙盒缓存此头像
    [[NSUserDefaults standardUserDefaults] setObject:@{@"data":saveHeadImageData} forKey:[NSString stringWithFormat:@"HEAD_AVATAR_DATA%@",[CommParameter sharedInstance].userId]];

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
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
   
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [Tool showDialog:@"哎呀,功能还在开发中..."];
    
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
    //1 每次设置前数据初始化所有容器类实例
    if (bankArray.count>0) {
        [bankArray removeAllObjects];
    }
    if (sandArray.count>0) {
        [sandArray removeAllObjects];
    }
    NSInteger bankCardCount = 0;
    NSInteger sandCardCount = 0;
    cashBalance = 0;
    consumeBalance = 0;
    cashPayToolDic = nil;
    consumePayToolDic = nil;
    
    //2 整合数据
    NSArray *payToolsArray = [CommParameter sharedInstance].ownPayToolsArray;
    NSInteger payToolsArrayCount = [payToolsArray count];
    
    for (int i = 0; i < payToolsArrayCount; i++) {
        NSDictionary *dic = payToolsArray[i];
        NSString *type = [dic objectForKey:@"type"];
        
        if ([@"1001" isEqualToString:type]) {
            bankCardCount++;
            [bankArray addObject:dic];
        } else if ([@"1002" isEqualToString:type]) {
            bankCardCount++;
            [bankArray addObject:dic];
        }  else if ([@"1003" isEqualToString:type]) {
            sandCardCount++;
            [sandArray addObject:dic];
        } else if ([@"1004" isEqualToString:type]) {
            sandCardCount++;
        } else if ([@"1005" isEqualToString:type]) {
            cashPayToolDic = payToolsArray[i];
            NSDictionary *accountDic = [cashPayToolDic objectForKey:@"account"];
            cashBalance = [[NSString stringWithFormat:@"%@", [accountDic objectForKey:@"balance"]] floatValue] / 100;
            
        } else if ([@"1006" isEqualToString:type]) {
            consumePayToolDic = payToolsArray[i];
            NSDictionary *accountDic = [consumePayToolDic objectForKey:@"account"];
            consumeBalance = [[NSString stringWithFormat:@"%@", [accountDic objectForKey:@"balance"]] floatValue] / 100;
 
        }  else if ([@"1007" isEqualToString:type]) {
            
        }  else if ([@"1008" isEqualToString:type]) {
            
        }  else if ([@"1009" isEqualToString:type]) {
            
        }  else if ([@"1010" isEqualToString:type]) {
            
        }  else if ([@"1011" isEqualToString:type]) {
            bankCardCount++;
            [bankArray addObject:dic];
        }  else if ([@"1012" isEqualToString:type]) {
            bankCardCount++;
            [bankArray addObject:dic];
        }
    }
    
    
    //3 刷新UI
    //3.1 刷新余额Lab控件数据
    if (cashBalance == 0 ) {  //消费余额判空
        cashContentLabel.text = @"0.00";
    } else {
        cashContentLabel.text = [NSString stringWithFormat:@"%.2f",cashBalance];
    }
    if (consumeBalance == 0 ) {  //现金余额判空
        consumeContentLabel.text = @"0.00";
    } else {
        consumeContentLabel.text = [NSString stringWithFormat:@"%.2f", consumeBalance];
    }
    
    //3.2 刷新银行卡/杉德卡 张数Lab数据
    bankContentLabel.text = [NSString stringWithFormat:@"%li张", (long)bankCardCount];
    sandContentLabel.text = [NSString stringWithFormat:@"%li张", (long)sandCardCount];
    
    //3.3 刷新圆饼图
    [_circleView sdCircleViewSetNumberArrayDate:@[[NSString stringWithFormat:@"%.2f",cashBalance],[NSString stringWithFormat:@"%.2f",consumeBalance]]];
   

}

#pragma mark - 手势点击头像
-(void)tapHeadView:(UITapGestureRecognizer*)tap{
    //点击头像选择获取照片方式
    [self chooseHeadPhoto];
}
#pragma mark - 按钮事件处理事情
/**
 *@brief 添加按钮添加事件
 *@return
 */
- (void)buttonActionToDoSomething:(id)sender
{
    UIButton *btn = (UIButton *)sender;
    //实名认证 
    if (([CommParameter sharedInstance].realNameFlag == NO) && (btn.tag == 5 || btn.tag == 6 || btn.tag == 7||btn.tag == 8)) {
        [Tool showDialog:@"您还未实名认证,请先实名!" defulBlock:^{
            //点击确定去实名认证
            RealNameAuthenticationViewController *mRealNameAuthenticationViewController = [[RealNameAuthenticationViewController alloc] init];
            [self.navigationController pushViewController:mRealNameAuthenticationViewController animated:YES];
        }];
        
    }else{
        
    switch (btn.tag) {
        case 3:
        {
            AccountManageViewController *accManageVC = [[AccountManageViewController alloc] init];
            [self.navigationController pushViewController:accManageVC animated:YES];
            
        }
            break;
        case 5:
        {
            if (cashPayToolDic == nil) {
                [Tool showDialog:@"请联系客服" message:@"现金账户开通失败" leftBtnString:@"取消" rightBtnString:@"去电" leftBlock:^{
                    //do nothing
                } rightBlock:^{
                    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"tel:021-962567"]];
                }];
                return;
            }
            RechargeChooseViewController *mRechargeChooseViewController = [[RechargeChooseViewController alloc] init];
            mRechargeChooseViewController.controllerIndex = CASHBALABNCE;
            [self.navigationController pushViewController:mRechargeChooseViewController animated:YES];
        }
            break;
        case 6:
        {
            if (consumePayToolDic==nil) {
                [Tool showDialog:@"请联系客服" message:@"消费账户开通失败" leftBtnString:@"取消" rightBtnString:@"去电" leftBlock:^{
                    //do nothing
                } rightBlock:^{
                    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"tel:021-962567"]];
                }];
                return;
            }
            RechargeChooseViewController *mRechargeChooseViewController = [[RechargeChooseViewController alloc] init];
            mRechargeChooseViewController.controllerIndex = CONSUMBALANCE;
            [self.navigationController pushViewController:mRechargeChooseViewController animated:YES];
        }
            break;
        case 7:
        {
            BankListViewController *mBankListViewController = [[BankListViewController alloc] init];
            [self.navigationController pushViewController:mBankListViewController animated:YES];
        }
            break;
        case 8: 
        {
            SandListViewController *mSandListViewController = [[SandListViewController alloc] init];
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
            SetViewController *mSetViewController = [[SetViewController alloc] init];
            [self.navigationController pushViewController:mSetViewController animated:YES];
        }
            break;
        default:
            break;
    }
    }
   
}


/**
 打开相机或相册选择头像
 */
-(void)chooseHeadPhoto{
    
    //弹框拍照/相册
    [SDAlertControllerUtil showAlertControllerWihtTitle:nil message:@"选择以下方式上传头像" actionArray:@[@"拍照上传",@"相册上传",@"取消"] presentedViewController:self actionBlock:^(NSInteger index) {
        //
        if (index == 0) {
            UIImagePickerController *picker = [[UIImagePickerController alloc] init];
            picker.sourceType = UIImagePickerControllerSourceTypeCamera;
            picker.delegate = self;
            //设置选择后的图片可被编辑
            picker.allowsEditing = YES;
            [self presentViewController:picker animated:YES completion:nil];
        }
        if (index == 1) {
            //[self getImageFromIpc]; //从相机获取相册
            UIImagePickerController *picker = [[UIImagePickerController alloc] init];
            picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
            picker.delegate = self;
            //设置选择后的图片可被编辑
            picker.allowsEditing = YES;
            [self presentViewController:picker animated:YES completion:nil];

        }
    }];
}


 
#pragma mark - 添加label添加事件
/**
 *@brief 添加label添加事件
 *@return
 */
- (void)labelActionToDoSomething
{
    //实名认证
    if ([CommParameter sharedInstance].realNameFlag == NO) {
        [Tool showDialog:@"您还未实名认证,请先实名!" defulBlock:^{
            //点击确定去实名认证
            RealNameAuthenticationViewController *mRealNameAuthenticationViewController = [[RealNameAuthenticationViewController alloc] init];
            [self.navigationController pushViewController:mRealNameAuthenticationViewController animated:YES];
        }];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
#pragma mark - -  照片选择返回<UIImagePickerControllerDelegate>--
// 获取图片后的操作
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info
{
    // 销毁控制器
    [picker dismissViewControllerAnimated:YES completion:nil];
    
    // 获取原始图片
    UIImage *image = info[UIImagePickerControllerEditedImage];
    
    //压缩 64*64
    UIGraphicsBeginImageContext(CGSizeMake(64, 64));
    CGRect thumbnailRect = CGRectZero;
    thumbnailRect.size.width = 64;
    thumbnailRect.size.height = 64;
    [image drawInRect:thumbnailRect];
    UIImage * newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    //数据格式化
    NSData *data = UIImageJPEGRepresentation(newImage, 0.6f);
    data = [GzipUtility gzipData:data];
    
    
    //base64
    base64Str = [Base64Util base64EncodedStringFrom:data];
    
    NSData *dataW = [base64Str dataUsingEncoding:NSUTF8StringEncoding];
    if (dataW.length >4000) {
        [Tool showDialog:@"图片过大,请重新选择"];
        return;
    }

    //上传头像
    [self updataPhoto];
    
   
    
}

/**
 上传头像
 */
- (void)updataPhoto{

    //成功获取图片后 直接上传
    HUD = [SDMBProgressView showSDMBProgressOnlyLoadingINViewImg:self.view];
    [SDRequestHelp shareSDRequest].HUD = HUD;
    [SDRequestHelp shareSDRequest].controller = self;
    [[SDRequestHelp shareSDRequest] dispatchGlobalQuque:^{
        __block BOOL error = NO;
        paynuc.set("tTokenType", "01002001");
        [[SDRequestHelp shareSDRequest] requestWihtFuncName:@"token/getTtoken/v1" errorBlock:^(SDRequestErrorType type) {
            error = YES;
        } successBlock:^{
            
        }];
        if (error) return ;
        
        
        NSMutableDictionary *userInfo = [NSMutableDictionary dictionaryWithCapacity:0];
        [userInfo setValue:base64Str forKey:@"avatar"];
        [userInfo setValue:@"" forKey:@"nick"];
        [userInfo setValue:@"" forKey:@"remainState"];
        NSString *userInfostr = [[PayNucHelper sharedInstance] dictionaryToJson:userInfo];
        paynuc.set("userInfo", [userInfostr UTF8String]);
        [[SDRequestHelp shareSDRequest] requestWihtFuncName:@"user/resetUserBaseInfo/v1" errorBlock:^(SDRequestErrorType type) {
            error = YES;
        } successBlock:^{
            [[SDRequestHelp shareSDRequest] dispatchToMainQueue:^{
                [HUD hidden];
                
                [CommParameter sharedInstance].avatar = base64Str;
                [Tool showDialog:@"头像修改成功"];
                
                //刷新头像
                NSString *str = [CommParameter sharedInstance].avatar;
                NSData *data = [Base64Util dataWithBase64EncodedString:str];
                data = [GzipUtility uncompressZippedData:data];
                UIImage *image = [UIImage imageWithData:data];
                headImageView.image = image;
                
                //沙盒缓存此头像
                [[NSUserDefaults standardUserDefaults] setObject:@{@"data":data} forKey:[NSString stringWithFormat:@"HEAD_AVATAR_DATA%@",[CommParameter sharedInstance].userId]];
            }];
        }];
        if (error) return ;
    }];

}
#pragma mark - scrollerViewDelegate
//只能向上滚动
-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    if (scrollView.contentOffset.y < 0 || scrollView.contentOffset.y == 0 ) {
        scrollView.contentOffset = CGPointMake(0, 0);
    }
    
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [HUD hidden];
}


@end
