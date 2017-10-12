//
//  SandManageViewController.m
//  sandbao
//
//  Created by blue sky on 2017/3/16.
//  Copyright © 2017年 sand. All rights reserved.
//

#import "SandManageViewController.h"
#import "IndicatorView.h"
#import "CustomAlertView.h"

#define lineViewColor [UIColor colorWithRed:(237/255.0) green:(237/255.0) blue:(237/255.0) alpha:1.0]

#define titleColor [UIColor colorWithRed:(174/255.0) green:(174/255.0) blue:(174/255.0) alpha:1.0]

#define textFiledColor [UIColor colorWithRed:(83/255.0) green:(83/255.0) blue:(83/255.0) alpha:1.0]

#define btnColor [UIColor colorWithRed:(255/255.0) green:(97/255.0) blue:(51/255.0) alpha:1.0]

#define viewColor [UIColor colorWithRed:(255/255.0) green:(255/255.0) blue:(255/255.0) alpha:1.0]

@interface SandManageViewController ()
{
    NavCoverView *navCoverView;
}

@property (nonatomic, assign) CGSize viewSize;
@property (nonatomic, assign) CGFloat viewHeight;
@property (nonatomic, assign) CGFloat moveTop;
@property (nonatomic, assign) CGFloat leftRightSpace;
@property (nonatomic, assign) CGFloat textFieldTextSize;
@property (nonatomic, assign) CGFloat btnTextSize;
@property (nonatomic, assign) CGFloat cellHeight;
@property (nonatomic, assign) CGFloat tableViewHeight;


@property (nonatomic, strong) IndicatorView *mIndicatorView;
@property (nonatomic, strong) CustomAlertView *alertView;
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UIView *noDataView;
@property (nonatomic, strong) NSMutableArray *bankArray;

@end

@implementation SandManageViewController

@synthesize viewSize;
@synthesize viewHeight;
@synthesize moveTop;
@synthesize leftRightSpace;
@synthesize textFieldTextSize;
@synthesize btnTextSize;
@synthesize cellHeight;
@synthesize tableViewHeight;

@synthesize mIndicatorView;
@synthesize alertView;
@synthesize scrollView;
@synthesize tableView;
@synthesize noDataView;
@synthesize bankArray;


- (void)viewDidLoad {
    [super viewDidLoad];
//    [self.view setBackgroundColor:[UIColor colorWithRed:(248/255.0) green:(248/255.0) blue:(248/255.0) alpha:1.0]];
//    viewSize = self.view.bounds.size;
//    leftRightSpace = 15;
//    
//    mIndicatorView = [IndicatorView loadingImageViewInView:[self.view.window.subviews objectAtIndex:0] msgTille:@"正在加载中......"];
//    mIndicatorView.center = CGPointMake(viewSize.width * 0.5, viewSize.height * 0.5);
//    [self settingNavigationBar];
//    [self addView:self.view];
    
}

#pragma mark - 设置导航栏
/**
 *@brief 设置导航栏
 *@return
 */
- (void)settingNavigationBar
{
    //导航渐变条
    navCoverView = [NavCoverView shareNavCoverView:CGRectMake(0, 0, viewSize.width, controllerTop) title:@"杉德卡管理"];
    [self.view addSubview:navCoverView];
    
    // 2.设置左边的返回item
    UIImage *leftImage = [UIImage imageNamed:@"back"];
    UIButton *leftBarBtn = [[UIButton alloc] init];
    leftBarBtn.frame = CGRectMake(0, 20 + (40 - leftImage.size.height) / 2, leftImage.size.width, leftImage.size.height);
    leftBarBtn.tag = 101;
    [leftBarBtn setImage:[UIImage imageNamed:@"back"] forState:UIControlStateNormal];
    [leftBarBtn setImage:[UIImage imageNamed:@"back"] forState:UIControlStateHighlighted];
    [leftBarBtn addTarget:self action:@selector(buttonActionToDoSomething:) forControlEvents:UIControlEventTouchUpInside];
    [navCoverView addSubview:leftBarBtn];
    
    // 3.设置右边的返回item
    UIImage *rightImage = [UIImage imageNamed:@""];
    UIButton *rightBarBtn = [[UIButton alloc] init];
    [rightBarBtn setImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
    [rightBarBtn setImage:[UIImage imageNamed:@""] forState:UIControlStateHighlighted];
    rightBarBtn.frame = CGRectMake(viewSize.width - 10 - rightImage.size.width, 20 + (40 - rightImage.size.height) / 2, rightImage.size.width, rightImage.size.height);
    rightBarBtn.tag = 102;
    rightBarBtn.contentMode = UIViewContentModeScaleAspectFit;
    UIBarButtonItem *rightButtonItem = [[UIBarButtonItem alloc] initWithCustomView:rightBarBtn];
    self.navigationItem.rightBarButtonItem = rightButtonItem;
}

#pragma mark - 创建组件
/**
 *@brief 创建组件
 *@param view UIView 参数：组件
 *@return
 */
-(void)addView:(UIView *)view
{
    CGFloat titleSize = 0;
    if (iPhone4 || iPhone5) {
        titleSize = 12;
        textFieldTextSize = 14;
        btnTextSize = 16;
    } else if (iPhone6) {
        titleSize = 14;
        textFieldTextSize = 16;
        btnTextSize = 18;
    } else {
        titleSize = 17;
        textFieldTextSize = 19;
        btnTextSize = 20;
    }
    
    //杉德卡
    UIView *cardView = [[UIView alloc]init];
    cardView.backgroundColor = viewColor;
    [view addSubview:cardView];
    
    UILabel *cardNameLabel = [[UILabel alloc] init];
    cardNameLabel.text = @"记名卡";
    cardNameLabel.textColor = textFiledColor;
    cardNameLabel.font = [UIFont systemFontOfSize:titleSize];
    [cardView addSubview:cardNameLabel];
    
    UILabel *cardNumLabel = [[UILabel alloc] init];
    cardNumLabel.text = @"6053 **** **** 8888";
    cardNumLabel.textColor = textFiledColor;
    cardNumLabel.font = [UIFont systemFontOfSize:titleSize];
    [cardView addSubview:cardNumLabel];
    
    // 线
    UIView *cardLineView = [[UIView alloc]init];
    cardLineView.backgroundColor = viewColor;
    [view addSubview:cardLineView];
    
    //钱
    UIView *moneyView = [[UIView alloc]init];
    moneyView.backgroundColor = viewColor;
    [view addSubview:moneyView];
    
    UIView *sumView = [[UIView alloc]init];
    sumView.backgroundColor = viewColor;
    [moneyView addSubview:sumView];
    
    UILabel *sumTitleLabel = [[UILabel alloc] init];
    sumTitleLabel.text = @"总资产";
    sumTitleLabel.textColor = textFiledColor;
    sumTitleLabel.font = [UIFont systemFontOfSize:titleSize];
    [sumView addSubview:sumTitleLabel];
    
    UILabel *sumMoneyLabel = [[UILabel alloc] init];
    sumMoneyLabel.text = @"10800.00";
    sumMoneyLabel.textColor = textFiledColor;
    sumMoneyLabel.font = [UIFont systemFontOfSize:titleSize];
    [sumView addSubview:sumMoneyLabel];
    
    // 线
    UIView *sumLineView = [[UIView alloc]init];
    sumLineView.backgroundColor = viewColor;
    [view addSubview:sumLineView];
    
    UIView *balanceView = [[UIView alloc]init];
    balanceView.backgroundColor = viewColor;
    [moneyView addSubview:balanceView];
    
    UILabel *balanceTitleLabel = [[UILabel alloc] init];
    balanceTitleLabel.text = @"钱包";
    balanceTitleLabel.textColor = textFiledColor;
    balanceTitleLabel.font = [UIFont systemFontOfSize:titleSize];
    [balanceView addSubview:balanceTitleLabel];
    
    UILabel *balanceMoneyLabel = [[UILabel alloc] init];
    balanceMoneyLabel.text = @"钱包";
    balanceMoneyLabel.textColor = textFiledColor;
    balanceMoneyLabel.font = [UIFont systemFontOfSize:titleSize];
    [balanceView addSubview:balanceMoneyLabel];
    
    // 线
    UIView *balanceLineView = [[UIView alloc]init];
    balanceLineView.backgroundColor = viewColor;
    [view addSubview:balanceLineView];
    
    //按钮
    UIView *btnView = [[UIView alloc]init];
    btnView.backgroundColor = viewColor;
    [view addSubview:btnView];
    
    UIButton *accountBtn = [[UIButton alloc] init];
    accountBtn.tag = 1;
    [accountBtn setTitle:@"主账户交易" forState:UIControlStateNormal];
    [accountBtn setTitleColor:[UIColor colorWithRed:(65/255.0) green:(131/255.0) blue:(215/255.0) alpha:1.0] forState:UIControlStateNormal];
    accountBtn.titleLabel.font = [UIFont systemFontOfSize:btnTextSize];
    [accountBtn addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
    [btnView addSubview:accountBtn];
    
    UIButton *balanceBtn = [[UIButton alloc] init];
    balanceBtn.tag = 2;
    [balanceBtn setTitle:@"钱包交易" forState:UIControlStateNormal];
    [balanceBtn setTitleColor:[UIColor colorWithRed:(186/255.0) green:(186/255.0) blue:(186/255.0) alpha:1.0] forState:UIControlStateNormal];
    balanceBtn.titleLabel.font = [UIFont systemFontOfSize:btnTextSize];
    [balanceBtn addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
    [btnView addSubview:balanceBtn];
    
    // 线
    UIView *btnLineView = [[UIView alloc]init];
    btnLineView.backgroundColor = viewColor;
    [view addSubview:btnLineView];
    
    noDataView = [[UIView alloc] init];
    [noDataView setBackgroundColor:[UIColor colorWithRed:(234/255.0) green:(234/255.0) blue:(234/255.0) alpha:1.0]];
    [view addSubview:noDataView];
    
    UIImage *noDataImage = [UIImage imageNamed:@"sk.png"];
    UIImageView *noDataImageView = [[UIImageView alloc] init];
    noDataImageView.image = noDataImage;
    noDataImageView.contentMode = UIViewContentModeScaleAspectFit;
    [noDataView addSubview:noDataImageView];
    
    UILabel *noDataLabel = [[UILabel alloc] init];
    noDataLabel.text = @"还没有绑定银行卡，请添加银行卡。";
    noDataLabel.textColor = [UIColor colorWithRed:(153/255.0) green:(153/255.0) blue:(153/255.0) alpha:1.0];
    noDataLabel.font = [UIFont systemFontOfSize:titleSize];
    [noDataView addSubview:noDataLabel];
    
    tableView = [[UITableView alloc] init];
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.scrollEnabled = NO;
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [view addSubview:tableView];
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    // 设置控件的位置和大小
    CGFloat space = 5;
    CGFloat commWidth = viewSize.width - leftRightSpace * 2;
    CGFloat lineViewHeight = 1;
    CGFloat top = 20;
    CGFloat upSpace = 10;
    CGFloat middleSpace = 50;
    CGFloat btnLeftRightSpace = 80;
    CGFloat btnLineViewSpace = 10;
    
    CGFloat cardNameLabelWidth = commWidth - leftRightSpace * 2;
    CGSize cardNameLabelSize = [cardNameLabel sizeThatFits:CGSizeMake(cardNameLabelWidth, MAXFLOAT)];
    CGSize cardNumLabelSize = [cardNumLabel sizeThatFits:CGSizeMake(cardNameLabelWidth, MAXFLOAT)];
    
    CGFloat cardViewHeight = cardNameLabelSize.height + space + cardNumLabelSize.height + 2 * upSpace;
    
    CGFloat sumViewWidth = (cardNameLabelWidth - middleSpace) / 2;
    CGSize sumTitleLabelSize = [sumTitleLabel sizeThatFits:CGSizeMake(sumViewWidth, MAXFLOAT)];
    CGSize sumMoneyLabelSize = [sumMoneyLabel sizeThatFits:CGSizeMake(sumViewWidth, MAXFLOAT)];
    CGFloat sumViewHeight = sumTitleLabelSize.height + space + sumMoneyLabelSize.height + 2 * upSpace;
    
    CGSize balanceTitleLabelSize = [balanceTitleLabel sizeThatFits:CGSizeMake(sumViewWidth, MAXFLOAT)];
    CGSize balanceMoneyLabelSize = [balanceMoneyLabel sizeThatFits:CGSizeMake(sumViewWidth, MAXFLOAT)];
    
    CGSize accountBtnSize = [accountBtn.titleLabel.text sizeWithNSStringFont:accountBtn.titleLabel.font];
    CGFloat btnHeight = accountBtnSize.height + 2 * 20;
    
//    tableViewHeight = viewSize.height - controllerTop -
    
    [cardView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(view).offset(top + viewSize.height);
        make.left.equalTo(view).offset(leftRightSpace);
        make.size.mas_equalTo(CGSizeMake(commWidth, cardViewHeight));
    }];
    
    [cardNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(cardView).offset(upSpace);
        make.left.equalTo(cardView).offset(leftRightSpace);
        make.size.mas_equalTo(CGSizeMake(cardNameLabelWidth, cardNumLabelSize.height));
    }];
    
    [cardNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(cardNameLabel.mas_bottom).offset(space);
        make.left.equalTo(cardView).offset(leftRightSpace);
        make.size.mas_equalTo(CGSizeMake(cardNameLabelWidth, cardNumLabelSize.height));
    }];
    
    [cardLineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(cardView.mas_bottom).offset(0);
        make.left.equalTo(view).offset(leftRightSpace * 2);
        make.size.mas_equalTo(CGSizeMake(cardNameLabelWidth, lineViewHeight));
    }];
    
    [moneyView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(cardLineView.mas_bottom).offset(top);
        make.left.equalTo(view).offset(leftRightSpace);
        make.size.mas_equalTo(CGSizeMake(cardNameLabelWidth, sumViewHeight));
    }];
    
    [sumView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(moneyView).offset(leftRightSpace);
        make.center.equalTo(moneyView);
        make.size.mas_equalTo(CGSizeMake(sumViewWidth, sumViewHeight));
    }];
    
    [sumTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(sumView).offset(upSpace);
        make.left.equalTo(sumView).offset(0);
        make.size.mas_equalTo(CGSizeMake(sumViewWidth, sumTitleLabelSize.height));
    }];
    
    [sumMoneyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(sumTitleLabel.mas_bottom).offset(space);
        make.left.equalTo(sumView).offset(0);
        make.size.mas_equalTo(CGSizeMake(sumViewWidth, sumMoneyLabelSize.height));
    }];
    
    [balanceView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(sumView.mas_right).offset(middleSpace);
        make.center.equalTo(moneyView);
        make.size.mas_equalTo(CGSizeMake(sumViewWidth, sumViewHeight));
    }];
    
    [balanceTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(balanceView).offset(upSpace);
        make.left.equalTo(balanceMoneyLabel).offset(0);
        make.size.mas_equalTo(CGSizeMake(sumViewWidth, balanceTitleLabelSize.height));
    }];
    
    [balanceMoneyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(balanceTitleLabel.mas_bottom).offset(space);
        make.left.equalTo(balanceView).offset(0);
        make.size.mas_equalTo(CGSizeMake(sumViewWidth, balanceMoneyLabelSize.height));
    }];
    
    [sumLineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(moneyView.mas_bottom).offset(0);
        make.left.equalTo(view).offset(leftRightSpace * 2);
        make.size.mas_equalTo(CGSizeMake((cardNameLabelWidth - middleSpace) / 2, lineViewHeight));
    }];
    
    [balanceLineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(moneyView.mas_bottom).offset(0);
        make.left.equalTo(sumLineView.mas_bottom).offset(middleSpace);
        make.size.mas_equalTo(CGSizeMake((cardNameLabelWidth - middleSpace) / 2, lineViewHeight));
    }];
    
    [btnLineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(sumLineView.mas_bottom).offset(0);
        make.centerX.equalTo(view);
        make.size.mas_equalTo(CGSizeMake(viewSize.width, btnLineViewSpace));
    }];
    
    [btnView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(btnLineView.mas_bottom).offset(0);
        make.centerX.equalTo(view);
        make.size.mas_equalTo(CGSizeMake(viewSize.width, btnHeight));
    }];
    
    [accountBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(btnView).offset(btnLeftRightSpace);
        make.centerY.equalTo(btnView);
    }];
    
    [balanceBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(btnView).offset(-btnLeftRightSpace);
        make.centerY.equalTo(btnView);
    }];
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

@end
