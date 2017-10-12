//
//  RechargeChooseViewController.m
//  sandbao
//
//  Created by blue sky on 2017/3/29.
//  Copyright © 2017年 sand. All rights reserved.
//

#import "RechargeChooseViewController.h"
#import "CashRechargeViewController.h"
#import "ConsumeRechargeViewController.h"
#import "GradualView.h"
#import "IndicatorView.h"

#import "TransDetailsh5ViewController.h"
#import "SandListViewController.h"
#import "CashWithDrawViewController.h"




#define lineViewColor RGBA(237, 237, 237, 1.0)

#define titleColor RGBA(174, 174, 174, 1.0)

#define textFiledColor RGBA(83, 83, 83, 1.0)

#define viewColor RGBA(255, 255, 255, 1.0)

@interface RechargeChooseViewController ()
{
    NavCoverView *navCoverView;
    NSString *imageStr;
}

@property (nonatomic, assign) CGSize viewSize;
@property (nonatomic, assign) CGFloat leftRightSpace;
@property (nonatomic, assign) CGFloat lineViewHeight;
@property (nonatomic, assign) CGFloat labelTextSize;
@property (nonatomic, assign) CGFloat textFieldTextSize;
@property (nonatomic, strong) IndicatorView *mIndicatorView;

@property (nonatomic, strong) UIScrollView *scrollView;

@end

@implementation RechargeChooseViewController

@synthesize viewSize;
@synthesize leftRightSpace;
@synthesize lineViewHeight;
@synthesize labelTextSize;
@synthesize textFieldTextSize;
@synthesize mIndicatorView;

@synthesize scrollView;

@synthesize controllerIndex;
@synthesize payToolDic;
@synthesize payToolarray;


- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view setBackgroundColor:RGBA(247, 245, 244, 1.0)];
    viewSize = self.view.bounds.size;
    leftRightSpace = 15;
    lineViewHeight = 1;
    
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
    NSString *title;
    if (controllerIndex == 0) {
        title = @"现金余额";
        imageStr = @"tixian";
    } else {
        title = @"消费余额";
        imageStr = @"zhuanru";
    }
    
    navCoverView = [NavCoverView shareNavCoverView:CGRectMake(0, 0, viewSize.width, controllerTop) title:title];
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
    UIImage *rightImage = [UIImage imageNamed:@"icon_details"];
    UIButton *rightBarBtn = [[UIButton alloc] init];
    [rightBarBtn setImage:[UIImage imageNamed:@"icon_details"] forState:UIControlStateNormal];
    [rightBarBtn setImage:[UIImage imageNamed:@"icon_details"] forState:UIControlStateHighlighted];
    rightBarBtn.frame = CGRectMake(viewSize.width - 10 - rightImage.size.width, 20 + (40 - rightImage.size.height) / 2, rightImage.size.width, rightImage.size.height);
    rightBarBtn.tag = 102;
    [rightBarBtn addTarget:self action:@selector(buttonActionToDoSomething:) forControlEvents:UIControlEventTouchUpInside];
    rightBarBtn.contentMode = UIViewContentModeScaleAspectFit;
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
    CGFloat titleSize = 0;
    CGFloat moneySize = 0;
    
    if (iPhone4 || iPhone5) {
        titleSize = 11;
        moneySize = 21;
        textFieldTextSize = 15;
        labelTextSize = 12;
    } else if (iPhone6) {
        titleSize = 13;
        moneySize = 23;
        textFieldTextSize = 17;
        labelTextSize = 14;
    } else {
        titleSize = 16;
        moneySize = 26;
        textFieldTextSize = 20;
        labelTextSize = 17;
    }
    
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
    [scrollView setBackgroundColor:RGBA(239, 239, 244, 1.0)];
    [view addSubview:scrollView];
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    //余额区
    GradualView *qCoreView = [[GradualView alloc] init];
    [scrollView addSubview:qCoreView];
    
    UILabel *moneyTitleLabel = [[UILabel alloc] init];
    moneyTitleLabel.text = @"余额";
    moneyTitleLabel.textColor = [UIColor whiteColor];
    moneyTitleLabel.font = [UIFont systemFontOfSize:titleSize];
    [qCoreView addSubview:moneyTitleLabel];
    
    UILabel *moneyLabel = [[UILabel alloc] init];
    moneyLabel.textColor = [UIColor whiteColor];
    moneyLabel.font = [UIFont systemFontOfSize:moneySize];
    [qCoreView addSubview:moneyLabel];
    
    UIView *chooseView = [[UIView alloc] init];
    chooseView.backgroundColor = viewColor;
    [scrollView addSubview:chooseView];
    
    //充值
    UIButton *rechargeBtn = [[UIButton alloc] init];
    rechargeBtn.tag = 1;
    [rechargeBtn setBackgroundImage:[UIImage imageWithColor:[UIColor whiteColor]] forState:UIControlStateNormal];
    [rechargeBtn setBackgroundImage:[UIImage imageWithColor:[UIColor lightGrayColor]] forState:UIControlStateHighlighted];
    [rechargeBtn addTarget:self action:@selector(buttonActionToDoSomething:) forControlEvents:UIControlEventTouchUpInside];
    [chooseView addSubview:rechargeBtn];
    
    UIImage *rechargeImage = [UIImage imageNamed:@"chongzhi.png"];
    UIImageView *rechargeImageView = [[UIImageView alloc] init];
    rechargeImageView.image = rechargeImage;
    rechargeImageView.contentMode = UIViewContentModeScaleAspectFit;
    [rechargeBtn addSubview:rechargeImageView];
    
    UILabel *rechargeLabel = [[UILabel alloc] init];
    rechargeLabel.text = @"充值";
    rechargeLabel.textColor = textFiledColor;
    rechargeLabel.font = [UIFont systemFontOfSize:textFieldTextSize];
    [rechargeBtn addSubview:rechargeLabel];
    
    UIImage *rechargeArrowImage = [UIImage imageNamed:@"list_forward.png"];
    UIImageView *rechargeArrowImageView = [[UIImageView alloc] init];
    rechargeArrowImageView.image = rechargeArrowImage;
    rechargeArrowImageView.contentMode = UIViewContentModeScaleAspectFit;
    [rechargeBtn addSubview:rechargeArrowImageView];
    
    UIView *lineView = [[UIView alloc] init];
    lineView.backgroundColor = lineViewColor;
    [scrollView addSubview:lineView];
    
    UIButton *shifttoBtn = [[UIButton alloc] init];
    shifttoBtn.tag = 2;
    [shifttoBtn setBackgroundImage:[UIImage imageWithColor:[UIColor whiteColor]] forState:UIControlStateNormal];
    [shifttoBtn setBackgroundImage:[UIImage imageWithColor:[UIColor lightGrayColor]] forState:UIControlStateHighlighted];
    [shifttoBtn addTarget:self action:@selector(buttonActionToDoSomething:) forControlEvents:UIControlEventTouchUpInside];
    [chooseView addSubview:shifttoBtn];
    
    
    UIImage *shifttoImage = [UIImage imageNamed:imageStr];
    UIImageView *shifttoImageView = [[UIImageView alloc] init];
    shifttoImageView.image = shifttoImage;
    shifttoImageView.contentMode = UIViewContentModeScaleAspectFit;
    [shifttoBtn addSubview:shifttoImageView];
    
    UILabel *shifttoLabel = [[UILabel alloc] init];
    shifttoLabel.text = @"转入记名卡";
    shifttoLabel.textColor = textFiledColor;
    shifttoLabel.font = [UIFont systemFontOfSize:textFieldTextSize];
    [shifttoBtn addSubview:shifttoLabel];
    
    UIImage *shifttoArrowImage = [UIImage imageNamed:@"list_forward.png"];
    UIImageView *shifttoArrowImageView = [[UIImageView alloc] init];
    shifttoArrowImageView.image = shifttoArrowImage;
    shifttoArrowImageView.contentMode = UIViewContentModeScaleAspectFit;
    [shifttoBtn addSubview:shifttoArrowImageView];
    
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.text = @"温馨提示：可在支持商超账户支付商品购买任意商品";
    titleLabel.textColor = titleColor;
    titleLabel.font = [UIFont systemFontOfSize:labelTextSize];
    [scrollView addSubview:titleLabel];
    
    //设置数据
    NSDictionary *accountDic = [payToolDic objectForKey:@"account"];
    moneyLabel.text = [NSString stringWithFormat:@"%@%.2f", @"¥", [[accountDic objectForKey:@"balance"] floatValue] / 100];
    
    if (controllerIndex == 0) {
        shifttoLabel.text = @"提现";
        titleLabel.text = @"温馨提示：支持实名认证银行卡的资金流转";
    } else {
        shifttoLabel.text = @"转入记名卡";
        titleLabel.text = @"温馨提示：可在支持商超账户支付商品购买任意商品";
    }
    
    //设置控件的位置和大小
    CGFloat commWidth = viewSize.width - 2 * leftRightSpace;
    CGFloat space = 10;
    CGFloat upDownSpace = 15;
    CGFloat scrollViewH = viewSize.height - controllerTop;
    CGFloat moneyTitleLabelTop = 15;
    CGFloat moneyLabelBottom = 30;
    
    CGSize moneyTitleLabelSize = [moneyTitleLabel sizeThatFits:CGSizeMake(commWidth, MAXFLOAT)];
    CGSize moneyLabelSize = [moneyLabel sizeThatFits:CGSizeMake(commWidth, MAXFLOAT)];
    
    CGFloat qCoreViewlHeight = moneyTitleLabelTop + moneyTitleLabelSize.height + upDownSpace + moneyLabelSize.height + moneyLabelBottom;
    
    CGFloat labelWidth = commWidth - rechargeImage.size.width - space - rechargeArrowImage.size.width -space;
    CGSize rechargeLabelSize = [rechargeLabel sizeThatFits:CGSizeMake(labelWidth, MAXFLOAT)];
    CGSize shifttoLabelSize = [shifttoLabel sizeThatFits:CGSizeMake(labelWidth, MAXFLOAT)];
    
    CGFloat btnHeight = rechargeImage.size.width + 2 * 15;
    
    CGFloat chooseViewHeight = btnHeight * 2 + lineViewHeight;
    
    CGSize titleLabelSize = [titleLabel sizeThatFits:CGSizeMake(commWidth, MAXFLOAT)];
    
    qCoreView.rect = CGRectMake(0, 0, viewSize.width, qCoreViewlHeight);
    
    [scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(view).offset(controllerTop);
        make.centerX.equalTo(view);
        make.size.mas_equalTo(CGSizeMake(viewSize.width, scrollViewH));
    }];
    
    [qCoreView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(scrollView).offset(0);
        make.left.equalTo(scrollView).offset(0);
        make.size.mas_equalTo(CGSizeMake(viewSize.width, qCoreViewlHeight));
    }];
    
    [moneyTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(qCoreView).offset(moneyTitleLabelTop);
        make.left.equalTo(qCoreView).offset(leftRightSpace);
        make.size.mas_equalTo(CGSizeMake(commWidth, moneyTitleLabelSize.height));
    }];
    
    [moneyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(moneyTitleLabel.mas_bottom).offset(upDownSpace);
        make.left.equalTo(qCoreView).offset(leftRightSpace);
        make.size.mas_equalTo(CGSizeMake(commWidth, moneyLabelSize.height));
    }];
    
    [chooseView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(qCoreView.mas_bottom).offset(0);
        make.left.equalTo(qCoreView).offset(0);
        make.size.mas_equalTo(CGSizeMake(viewSize.width, chooseViewHeight));
    }];
    
    [rechargeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(chooseView).offset(0);
        make.centerX.equalTo(chooseView);
        make.size.mas_equalTo(CGSizeMake(commWidth, btnHeight));
    }];
    
    [rechargeImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(rechargeBtn).offset(0);
        make.centerY.equalTo(rechargeBtn);
    }];
    
    [rechargeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(rechargeImageView.mas_right).offset(space);
        make.centerY.equalTo(rechargeBtn);
        make.size.mas_equalTo(CGSizeMake(labelWidth, rechargeLabelSize.height));
    }];
    
    [rechargeArrowImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(rechargeLabel.mas_right).offset(space);
        make.centerY.equalTo(rechargeBtn);
    }];
    
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(rechargeBtn.mas_bottom).offset(0);
        make.left.equalTo(chooseView).offset(leftRightSpace);
        make.size.mas_equalTo(CGSizeMake(viewSize.width - leftRightSpace, lineViewHeight));
    }];
    
    [shifttoBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(lineView.mas_bottom).offset(0);
        make.centerX.equalTo(chooseView);
        make.size.mas_equalTo(CGSizeMake(commWidth, btnHeight));
    }];
    
    [shifttoImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(shifttoBtn).offset(0);
        make.centerY.equalTo(shifttoBtn);
    }];
    
    [shifttoLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(shifttoImageView.mas_right).offset(space);
        make.centerY.equalTo(shifttoBtn);
        make.size.mas_equalTo(CGSizeMake(labelWidth, shifttoLabelSize.height));
    }];
    
    [shifttoArrowImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(shifttoLabel.mas_right).offset(space);
        make.centerY.equalTo(shifttoBtn);
    }];
    
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(chooseView.mas_bottom).offset(30);
        make.left.equalTo(scrollView).offset(leftRightSpace);
        make.size.mas_equalTo(CGSizeMake(commWidth, titleLabelSize.height));
    }];
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
    } else {
        [[self class] cancelPreviousPerformRequestsWithTarget:self selector:@selector(buttonActionToDoSomething:) object:sender];
        [self performSelector:@selector(buttonActionToDoSomething:) withObject:sender afterDelay:0];
    }
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
            if (controllerIndex == CASHBALABNCE) {
                //现金余额充值
                CashRechargeViewController *mCashRechargeViewController = [[CashRechargeViewController alloc] init];
                mCashRechargeViewController.tTokenType = @"02000101";
                mCashRechargeViewController.cashPayToolDic = payToolDic;
                mCashRechargeViewController.controllerIndex = CASHBALABNCE;
                [self.navigationController pushViewController:mCashRechargeViewController animated:YES];
            } else if (controllerIndex == CONSUMBALANCE){
                //消费余额充值
                ConsumeRechargeViewController *mConsumeRechargeViewController = [[ConsumeRechargeViewController alloc] init];
                mConsumeRechargeViewController.consumePayToolDic = payToolDic;
                mConsumeRechargeViewController.tTokenType = @"02000101";
                mConsumeRechargeViewController.controllerIndex = CONSUMBALANCE;
                [self.navigationController pushViewController:mConsumeRechargeViewController animated:YES];
            }
        }
            break;
        case 2:
        {
            if (controllerIndex == CASHBALABNCE) {
                //现金余额提现
                CashWithDrawViewController *mCashWithDrawViewController = [[CashWithDrawViewController alloc] init];
                mCashWithDrawViewController.tTokenType = @"02000201";
                mCashWithDrawViewController.cashPayToolDic = payToolDic;
                if ([[[payToolDic objectForKey:@"account"] objectForKey:@"useableBalance"] floatValue]/100 == 0) {
                    [Tool showDialog:@"您的可提现余额不足!"];
                    return;
                }
                [self.navigationController pushViewController:mCashWithDrawViewController animated:YES];
            }
            else if (controllerIndex == CONSUMBALANCE){
                //杉德卡主账户充值
                SandListViewController *mSandListViewController = [[SandListViewController alloc] init];
                mSandListViewController.sandArray = payToolarray;
                [self.navigationController pushViewController:mSandListViewController animated:YES];
            }
        }
            break;
        case 101:
        {
            [self.navigationController popViewControllerAnimated:YES];
        }
            break;
        case 102:
        {
            TransDetailsh5ViewController *tranDetai = [[TransDetailsh5ViewController alloc] init];
            if (controllerIndex == CASHBALABNCE) {
                tranDetai.codeType = CASH_CODE; //现金账户
                tranDetai.idStr = [payToolDic objectForKey:@"id"];
                tranDetai.titleName = @"现金账户明细";
            }else  if (controllerIndex == CONSUMBALANCE){
                tranDetai.codeType = CONSUME_CODE; //消费账户
                tranDetai.idStr = [payToolDic objectForKey:@"id"];
                tranDetai.titleName = @"消费账户明细";
            }
            [self.navigationController pushViewController:tranDetai animated:YES];
        }
            break;
        default:
            break;
    }
}
 
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
