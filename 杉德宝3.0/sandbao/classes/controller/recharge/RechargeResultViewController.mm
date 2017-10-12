//
//  RechargeResultViewController.m
//  sandbao
//
//  Created by tianNanYiHao on 2017/3/27.
//  Copyright © 2017年 sand. All rights reserved.
//

#import "RechargeResultViewController.h"
#import "MyViewController.h"
#import "PayNucHelper.h"
#import "PayNuc.h"


#define lineViewColor RGBA(237, 237, 237, 1.0)

#define titleColor RGBA(174, 174, 174, 1.0)

#define textFiledColor RGBA(83, 83, 83, 1.0)

#define btnColor RGBA(255, 97, 51, 1.0)

#define viewColor RGBA(255, 255, 255, 1.0)

@interface RechargeResultViewController ()
{
    NavCoverView *navCoverView;
}

@property (nonatomic, assign) CGSize viewSize;
@property (nonatomic, assign) CGFloat viewHeight;
@property (nonatomic, assign) CGFloat leftRightSpace;
@property (nonatomic, assign) CGFloat lineViewHeight;
@property (nonatomic, assign) CGFloat labelTextSize;
@property (nonatomic, assign) CGFloat textFieldTextSize;
@property (nonatomic, strong) SDMBProgressView *HUD;
@property (nonatomic, strong) UIScrollView *scrollView;

@end

@implementation RechargeResultViewController

@synthesize viewSize;
@synthesize viewHeight;
@synthesize leftRightSpace;
@synthesize lineViewHeight;
@synthesize labelTextSize;
@synthesize textFieldTextSize;


@synthesize scrollView;
@synthesize HUD;

@synthesize viewControllerIndex;
@synthesize workDic;

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view setBackgroundColor:RGBA(247, 245, 244, 1.0)];
    viewSize = self.view.bounds.size;
    leftRightSpace = 15;
    lineViewHeight = 1;
    
    [self settingNavigationBar];
    [self addView:self.view];
    [self ownPayTools];
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
    
    if (viewControllerIndex == CASHBALABNCE) {
        title = @"现金账户充值成功";
    }else if(viewControllerIndex == CASHBALABNCEDRAW){
        title = @"现金账户提现成功";
    }else if(viewControllerIndex == CONSUMBALANCE){
        title = @"消费账户充值成功";
    }else if (viewControllerIndex == SANDCARDACCOUNT){
        title = @"杉德卡充值成功";
    }else if (viewControllerIndex == SDQRPAY){
        title = @"扫码支付成功";
    }else if (viewControllerIndex == SPSPay){
        title = @"Sps支付成功";
    }
    
    navCoverView = [NavCoverView shareNavCoverView:CGRectMake(0, 0, viewSize.width, controllerTop) title:title];
    [self.view addSubview:navCoverView];
    
    // 2.设置左边的返回item
    UIImage *leftImage = [UIImage imageNamed:@""];
    UIButton *leftBarBtn = [[UIButton alloc] init];
    leftBarBtn.frame = CGRectMake(0, 20 + (40 - leftImage.size.height) / 2, leftImage.size.width, leftImage.size.height);
    leftBarBtn.tag = 101;
    [leftBarBtn setImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
    [leftBarBtn setImage:[UIImage imageNamed:@""] forState:UIControlStateHighlighted];
    [leftBarBtn addTarget:self action:@selector(buttonActionToDoSomething:) forControlEvents:UIControlEventTouchUpInside];
    [navCoverView addSubview:leftBarBtn];
    
    // 3.设置右边的返回item
    UIImage *rightImage = [UIImage imageNamed:@""];
    UIButton *rightBarBtn = [[UIButton alloc] init];
    [rightBarBtn setTitle:@"完成" forState:UIControlStateNormal];
    [rightBarBtn setTitle:@"完成" forState:UIControlStateHighlighted];
    [rightBarBtn setTintColor:[UIColor whiteColor]];
    [rightBarBtn setImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
    [rightBarBtn setImage:[UIImage imageNamed:@""] forState:UIControlStateHighlighted];
    [rightBarBtn addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
    
    CGSize rightBarBtnTitleSize = [rightBarBtn.titleLabel.text sizeWithNSStringFont:rightBarBtn.titleLabel.font];
    rightBarBtn.frame = CGRectMake(viewSize.width - 10 - rightBarBtnTitleSize.width, 20 + (40 - rightBarBtnTitleSize.height) / 2, rightBarBtnTitleSize.width, rightBarBtnTitleSize.height);
    
    rightBarBtn.tag = 102;
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
    CGFloat rechargeResultTextSize = 0;
    

        rechargeResultTextSize = 14;
        labelTextSize = 12;
        textFieldTextSize = 30;

    
    
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
    
    UIView *rechargeResultView = [[UIView alloc] init];
    rechargeResultView.backgroundColor = viewColor;
    [scrollView addSubview:rechargeResultView];
    
    UIImage *typeImage = [UIImage imageNamed:@"wantong_logo.png"];
    UIImageView *typeImageView = [[UIImageView alloc] init];
    typeImageView.image = typeImage;
    typeImageView.layer.masksToBounds = YES;
    typeImageView.layer.cornerRadius = typeImage.size.width / 2;
    typeImageView.contentMode = UIViewContentModeScaleAspectFit;
    [rechargeResultView addSubview:typeImageView];
    
    UILabel *moneyLabel = [[UILabel alloc] init];
    moneyLabel.text = [NSString stringWithFormat:@"%.2f",[[workDic objectForKey:@"transAmt"] floatValue]/100];
    moneyLabel.textColor = textFiledColor;
    moneyLabel.textAlignment = NSTextAlignmentCenter;
    moneyLabel.font = [UIFont systemFontOfSize:textFieldTextSize];
    [rechargeResultView addSubview:moneyLabel];
    
    UILabel *rechargeResultLabel = [[UILabel alloc] init];
    rechargeResultLabel.text = @"交易成功";
    rechargeResultLabel.textColor = RGBA(65, 131, 215, 1.0);
    rechargeResultLabel.textAlignment = NSTextAlignmentCenter;
    rechargeResultLabel.font = [UIFont systemFontOfSize:rechargeResultTextSize];
    [rechargeResultView addSubview:rechargeResultLabel];
    
    UIView *lineView = [[UIView alloc] init];
    lineView.backgroundColor = lineViewColor;
    [rechargeResultView addSubview:lineView];
    
    UIView *payInfoView = [[UIView alloc] init];
    payInfoView.backgroundColor = viewColor;
    [rechargeResultView addSubview:payInfoView];
    
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.text = @"付款信息";
    titleLabel.textColor = textFiledColor;
    titleLabel.font = [UIFont systemFontOfSize:labelTextSize];
    [payInfoView addSubview:titleLabel];
    
    UILabel *contentLabel = [[UILabel alloc] init];
    contentLabel.text = @"杉德宝主账户";
    contentLabel.textColor = titleColor;
    contentLabel.font = [UIFont systemFontOfSize:labelTextSize];
    [payInfoView addSubview:contentLabel];
    contentLabel.text = [NSString stringWithFormat:@"%@(%@)", [_payToolDic objectForKey:@"title"],[[_payToolDic objectForKey:@"account"] objectForKey:@"accNo"]];
    
    
    UILabel *payMoneyLabel = [[UILabel alloc] init];
    payMoneyLabel.text = [NSString stringWithFormat:@"- %.2f",[[workDic objectForKey:@"transAmt"] floatValue]/100];
    payMoneyLabel.textColor = titleColor;
    payMoneyLabel.font = [UIFont systemFontOfSize:labelTextSize];
    [payInfoView addSubview:payMoneyLabel];
    if (viewControllerIndex == CASHBALABNCE) {
        typeImage = [UIImage imageNamed:@"unionpay_logo.png"];
    } else if(viewControllerIndex == CONSUMBALANCE || viewControllerIndex == SANDCARDACCOUNT){
        typeImage = [UIImage imageNamed:@"wantong_logo.png"];
    } else if(viewControllerIndex == SDQRPAY){
        typeImage = [UIImage imageNamed:@"qvip_pay_imageholder"];
    }
    typeImageView.image = typeImage;
    
    //设置控件的大小和位置
    CGFloat commWidth = viewSize.width - 2 * leftRightSpace;
    CGFloat space = 10;
    CGFloat scrollViewH = viewSize.height - controllerTop;
    CGFloat upDownSpace = 15;
    CGFloat typeImageViewTop = 50;
    CGFloat moneyLabelTop = 25;
    CGFloat rechargeResultLabelTop = 15;
    CGFloat lineViewTop = 25;
    
    CGSize moneyLabelSize = [moneyLabel sizeThatFits:CGSizeMake(commWidth, MAXFLOAT)];
    CGSize rechargeResultLabelSize = [rechargeResultLabel sizeThatFits:CGSizeMake(commWidth, MAXFLOAT)];
    
    CGSize titleLabelSize = [titleLabel.text sizeWithNSStringFont:titleLabel.font];
    CGSize payMoneyLabelSize = [payMoneyLabel.text sizeWithNSStringFont:payMoneyLabel.font];
    CGFloat contentLabelWidth = commWidth - titleLabelSize.width - space - payMoneyLabelSize.width - space;
    CGSize contentLabelSize = [contentLabel sizeThatFits:CGSizeMake(contentLabelWidth, MAXFLOAT)];
    
    CGFloat payInfoViewHeight = titleLabelSize.height + 2 * upDownSpace;
    
    CGFloat rechargeResultViewHeight = typeImageViewTop + typeImage.size.height + moneyLabelTop + moneyLabelSize.height + rechargeResultLabelTop + rechargeResultLabelSize.height + lineViewTop + lineViewHeight + payInfoViewHeight;
    
    
    [scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(view).offset(controllerTop);
        make.centerX.equalTo(view);
        make.size.mas_equalTo(CGSizeMake(viewSize.width, scrollViewH));
    }];
    
    [rechargeResultView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(scrollView).offset(0);
        make.left.equalTo(scrollView).offset(0);
        make.size.mas_equalTo(CGSizeMake(viewSize.width, rechargeResultViewHeight));
    }];
    
    [typeImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(rechargeResultView).offset(typeImageViewTop);
        make.centerX.equalTo(rechargeResultView);
    }];
    
    [moneyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(typeImageView.mas_bottom).offset(moneyLabelTop);
        make.centerX.equalTo(rechargeResultView);
        make.size.mas_equalTo(CGSizeMake(commWidth, moneyLabelSize.height));
    }];
    
    [rechargeResultLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(moneyLabel.mas_bottom).offset(rechargeResultLabelTop);
        make.centerX.equalTo(rechargeResultView);
        make.size.mas_equalTo(CGSizeMake(commWidth, rechargeResultLabelSize.height));
    }];
    
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(rechargeResultLabel.mas_bottom).offset(lineViewTop);
        make.centerX.equalTo(rechargeResultView);
        make.size.mas_equalTo(CGSizeMake(commWidth, lineViewHeight));
    }];
    
    [payInfoView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(lineView.mas_bottom).offset(0);
        make.centerX.equalTo(rechargeResultView);
        make.size.mas_equalTo(CGSizeMake(viewSize.width, payInfoViewHeight));
    }];
    
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(payInfoView).offset(leftRightSpace);
        make.centerY.equalTo(payInfoView);
        make.size.mas_equalTo(CGSizeMake(titleLabelSize.width, titleLabelSize.height));
    }];
    
    [contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(titleLabel.mas_right).offset(space);
        make.centerY.equalTo(payInfoView);
        make.size.mas_equalTo(CGSizeMake(contentLabelWidth, contentLabelSize.height));
    }];
    
    [payMoneyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(contentLabel.mas_right).offset(space);
        make.centerY.equalTo(payInfoView);
        make.size.mas_equalTo(CGSizeMake(payMoneyLabelSize.width, payMoneyLabelSize.height));
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
            
        }
            break;
        case 101:
        {
            [self.navigationController popViewControllerAnimated:YES];
        }
            break;
        case 102:
        {
            [self.navigationController popToRootViewControllerAnimated:YES];
        }
            break;
            
        default:
            break;
    }
}
/**
 *@brief 查询信息
 */
- (void)ownPayTools
{
    HUD = [SDMBProgressView showSDMBProgressOnlyLoadingINViewImg:self.view];
    [SDRequestHelp shareSDRequest].HUD = HUD;
    [SDRequestHelp shareSDRequest].controller = self;
    [[SDRequestHelp shareSDRequest] dispatchGlobalQuque:^{
        __block BOOL error = NO;
        paynuc.set("tTokenType", "01001501");
        [[SDRequestHelp shareSDRequest] requestWihtFuncName:@"token/getTtoken/v1" errorBlock:^(SDRequestErrorType type) {
            error = YES;
        } successBlock:^{
            
        }];
        if (error) return ;
        
        
        paynuc.set("payToolKinds", "[]");
        [[SDRequestHelp shareSDRequest] requestWihtFuncName:@"payTool/getOwnPayTools/v1" errorBlock:^(SDRequestErrorType type) {
            error = YES;
        } successBlock:^{
            [[SDRequestHelp shareSDRequest] dispatchToMainQueue:^{
                [HUD hidden];
                
                NSArray *payToolsArray = [[PayNucHelper sharedInstance] jsonStringToArray:[NSString stringWithUTF8String:paynuc.get("payTools").c_str()]];
                //支付工具排序
                payToolsArray = [Tool orderForPayTools:payToolsArray];
                [CommParameter sharedInstance].ownPayToolsArray = payToolsArray;
                
                
                
            }];
        }];
        if (error) return ;
    }];
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

@end
