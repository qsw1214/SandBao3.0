//
//  SandManageViewController.m
//  sandbao
//
//  Created by tianNanYiHao on 2017/3/17.
//  Copyright © 2017年 sand. All rights reserved.
//

#import "SandManageViewController.h"



#import "SDLog.h"
#import "PayNucHelper.h"
#import "SandListViewController.h"
#import "SandPwdViewController.h"
#import "ConsumeRechargeViewController.h"
#import "WebViewProgressView.h"
#import "SandCardRechargeViewController.h"
#import "SDPayView.h"


#define lineViewColor RGBA(237, 237, 237, 1.0)

#define titleColor RGBA(174, 174, 174, 1.0)

#define textFiledColor RGBA(83, 83, 83, 1.0)

#define btnColor RGBA(255, 97, 51, 1.0)

#define viewColor RGBA(255, 255, 255, 1.0)
typedef void(^SandManageDeletCardStateBlock)(NSArray *paramArr);
@interface SandManageViewController ()<WebViewProgressViewDelegate,SDPayViewDelegate>
{
    NavCoverView *navCoverView;
    NSString *sumBalance;
    NSString *walletBalance;
    NSString *tToken;
}

@property (nonatomic, assign) CGSize viewSize;
@property (nonatomic, assign) CGFloat viewHeight;
@property (nonatomic, assign) CGFloat moveTop;
@property (nonatomic, assign) CGFloat leftRightSpace;
@property (nonatomic, assign) CGFloat textFieldTextSize;
@property (nonatomic, assign) CGFloat btnTextSize;
@property (nonatomic, assign) CGFloat cellHeight;
@property (nonatomic, assign) CGFloat tableViewHeight;
@property (nonatomic, strong) SDPayView *payView;

@property (nonatomic, strong) SDMBProgressView *HUD;


@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UIView *noDataView;
@property (nonatomic, strong) NSMutableArray *bankArray;
@property (nonatomic, strong) NSString *payPassword;
@property (nonatomic, strong) WebViewProgressView *progressView;
@property (nonatomic, strong) UILabel *balanceMoneyLabel;
@property (nonatomic, strong) UILabel *sumMoneyLabel;
@property (nonatomic, strong) NSMutableArray *authToolsArray;

@end

@implementation SandManageViewController

@synthesize payView;
@synthesize viewSize;
@synthesize viewHeight;
@synthesize moveTop;
@synthesize leftRightSpace;
@synthesize textFieldTextSize;
@synthesize btnTextSize;
@synthesize cellHeight;
@synthesize tableViewHeight;

@synthesize HUD;


@synthesize scrollView;
@synthesize tableView;
@synthesize noDataView;
@synthesize bankArray;
@synthesize payPassword;
@synthesize progressView;
@synthesize balanceMoneyLabel;
@synthesize sumMoneyLabel;

@synthesize authToolsArray;

@synthesize payToolDic;


-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self getBalances];
}


/**
 账户余额查询
 */
-(void)getBalances{
    HUD = [SDMBProgressView showSDMBProgressOnlyLoadingINViewImg:self.view];
    [SDRequestHelp shareSDRequest].HUD = HUD;
    [SDRequestHelp shareSDRequest].controller = self;
    [[SDRequestHelp shareSDRequest] dispatchGlobalQuque:^{
        __block BOOL error = NO;
        paynuc.set("tTokenType", "03000401");
        [[SDRequestHelp shareSDRequest] requestWihtFuncName:@"token/getTtoken/v1" errorBlock:^(SDRequestErrorType type) {
            error = YES;
        } successBlock:^{
            
        }];
        if (error) return ;
        
        
        
        NSString *payTools;
        NSMutableArray *payToolsArray = [NSMutableArray arrayWithCapacity:0];
        [payToolsArray addObject:payToolDic];
        payTools = [[PayNucHelper sharedInstance] arrayToJSON:payToolsArray];
        paynuc.set("payTools", [payTools UTF8String]);
        [[SDRequestHelp shareSDRequest] requestWihtFuncName:@"payTool/getBalances/v1" errorBlock:^(SDRequestErrorType type) {
            error = YES;
        } successBlock:^{
            [[SDRequestHelp shareSDRequest] dispatchToMainQueue:^{
                [HUD hidden];
                
                //更新数据 主账户 钱包账户余额
                NSString *payTools = [NSString stringWithUTF8String:paynuc.get("payTools").c_str()];
                NSArray *payToolsArr = [[PayNucHelper sharedInstance] jsonStringToArray:payTools];
                
                //排序
                payToolsArr = [Tool orderForPayTools:payToolsArr];
                if (payToolsArr.count>0) {
                    
                    for (int i = 0; i<payToolsArr.count; i++) {
                        if ([[[payToolsArr[i] objectForKey:@"account"] objectForKey:@"accNo"] isEqualToString:[payToolDic objectForKey:@"accNo"]]) {
                            sumBalance = [[payToolsArr[i] objectForKey:@"account"] objectForKey:@"balance"];
                            walletBalance =[[payToolsArr[i]objectForKey:@"account"] objectForKey:@"walletBalance"];
                            
                            //更新金额
                            sumMoneyLabel.text = [NSString stringWithFormat:@"%.2f",[sumBalance floatValue]/100];
                            balanceMoneyLabel.text = [NSString stringWithFormat:@"%.2f",[walletBalance floatValue]/100];
                        }
                    }
                    
                }
            }];
        }];
        if (error) return ;
    }];

}



- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view setBackgroundColor:RGBA(255, 255, 255, 1.0)];
    viewSize = self.view.bounds.size;
    leftRightSpace = 15;
    
    authToolsArray = [[NSMutableArray alloc] init];

    
    

    
    [self settingNavigationBar];
    [self addView:self.view];
//    [self getTransFlowMoblie];
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
    UIButton *rightBarBtn = [[UIButton alloc] init];
    [rightBarBtn setTitle:@"管理" forState:UIControlStateNormal];
    [rightBarBtn setTitle:@"管理" forState:UIControlStateHighlighted];
    [rightBarBtn setTintColor:[UIColor whiteColor]];
    [rightBarBtn setImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
    [rightBarBtn setImage:[UIImage imageNamed:@""] forState:UIControlStateHighlighted];
    [rightBarBtn addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
    
    CGSize rightBarBtnTitleSize = [rightBarBtn.titleLabel.text sizeWithNSStringFont:rightBarBtn.titleLabel.font];
    rightBarBtn.frame = CGRectMake(viewSize.width - 10 - rightBarBtnTitleSize.width, 20 + (40 - rightBarBtnTitleSize.height) / 2, rightBarBtnTitleSize.width, rightBarBtnTitleSize.height);
    rightBarBtn.tag = 102;
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

        titleSize = 12;
        textFieldTextSize = 20;
        btnTextSize = 16;

    
    //杉德卡
    UIView *cardView = [[UIView alloc]init];
    cardView.backgroundColor = viewColor;
    [view addSubview:cardView];
    
    UILabel *cardNameLabel = [[UILabel alloc] init];
    cardNameLabel.text = [payToolDic objectForKey:@"title"];;
    cardNameLabel.textColor = textFiledColor;
    cardNameLabel.font = [UIFont systemFontOfSize:titleSize];
    [cardView addSubview:cardNameLabel];
    
    UILabel *cardNumLabel = [[UILabel alloc] init];
    NSDictionary *accountDic = [payToolDic objectForKey:@"account"];
    cardNumLabel.text = [NSString stringWithFormat:@"**** **** **** %@", [accountDic objectForKey:@"accNo"]];;
    cardNumLabel.textColor = textFiledColor;
    cardNumLabel.font = [UIFont systemFontOfSize:textFieldTextSize];
    [cardView addSubview:cardNumLabel];
    
    // 线
    UIView *cardLineView = [[UIView alloc]init];
    cardLineView.backgroundColor = lineViewColor;
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
    
    sumMoneyLabel = [[UILabel alloc] init];
    NSString *balanceYuan = [NSString stringWithFormat:@"%.2f",[[[self.payToolDic objectForKey:@"account"] objectForKey:@"balance"] floatValue]/100];
    sumMoneyLabel.text = balanceYuan;
    sumMoneyLabel.textColor = textFiledColor;
    sumMoneyLabel.font = [UIFont systemFontOfSize:textFieldTextSize];
    [sumView addSubview:sumMoneyLabel];
    
    // 线
    UIView *sumLineView = [[UIView alloc]init];
    sumLineView.backgroundColor = lineViewColor;
    [view addSubview:sumLineView];
    
    UIView *balanceView = [[UIView alloc]init];
    balanceView.backgroundColor = viewColor;
    [moneyView addSubview:balanceView];
    
    UILabel *balanceTitleLabel = [[UILabel alloc] init];
    balanceTitleLabel.text = @"钱包";
    balanceTitleLabel.textColor = textFiledColor;
    balanceTitleLabel.font = [UIFont systemFontOfSize:titleSize];
    [balanceView addSubview:balanceTitleLabel];
    
    balanceMoneyLabel = [[UILabel alloc] init];
    NSString *balanceMoneyLabelYuan = [NSString stringWithFormat:@"%.2f",[[[self.payToolDic objectForKey:@"account"] objectForKey:@"walletBalance"] floatValue]/100];
    balanceMoneyLabel.text = balanceMoneyLabelYuan;
    balanceMoneyLabel.textColor = textFiledColor;
    balanceMoneyLabel.font = [UIFont systemFontOfSize:textFieldTextSize];
    [balanceView addSubview:balanceMoneyLabel];
    
    // 线
    UIView *balanceLineView = [[UIView alloc]init];
    balanceLineView.backgroundColor = lineViewColor;
    [view addSubview:balanceLineView];
    
    //按钮
    UIView *btnView = [[UIView alloc]init];
    btnView.backgroundColor = viewColor;
    [view addSubview:btnView];
    
    UIButton *accountBtn = [[UIButton alloc] init];
    accountBtn.tag = 1;
    [accountBtn setTitle:@"主账户交易" forState:UIControlStateNormal];
    [accountBtn setTitleColor:RGBA(65, 131, 215, 1.0) forState:UIControlStateNormal];
    accountBtn.titleLabel.font = [UIFont systemFontOfSize:btnTextSize];
//    [accountBtn addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
    [btnView addSubview:accountBtn];
    
    UIButton *balanceBtn = [[UIButton alloc] init];
    balanceBtn.tag = 2;
    [balanceBtn setTitle:@"钱包交易" forState:UIControlStateNormal];
    [balanceBtn setTitleColor:RGBA(186, 186, 186, 1.0) forState:UIControlStateNormal];
    balanceBtn.titleLabel.font = [UIFont systemFontOfSize:btnTextSize];
//    [balanceBtn addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
    [btnView addSubview:balanceBtn];
    
    // 线
    UIView *btnLineView = [[UIView alloc]init];
    btnLineView.backgroundColor = lineViewColor;
    [view addSubview:btnLineView];
    
    noDataView = [[UIView alloc] init];
    [noDataView setBackgroundColor:RGBA(234, 234, 234, 1.0)];
    [view addSubview:noDataView];
    
    UIImage *noDataImage = [UIImage imageNamed:@"sk.png"];
    UIImageView *noDataImageView = [[UIImageView alloc] init];
    noDataImageView.image = noDataImage;
    noDataImageView.contentMode = UIViewContentModeScaleAspectFit;
    [noDataView addSubview:noDataImageView];
    
    UILabel *noDataLabel = [[UILabel alloc] init];
    noDataLabel.text = @"还没有绑定银行卡，请添加银行卡。";
    noDataLabel.textColor = RGBA(153, 153, 153, 1.0);
    noDataLabel.font = [UIFont systemFontOfSize:titleSize];
    [noDataView addSubview:noDataLabel];
    
//    tableView = [[UITableView alloc] init];
//    tableView.delegate = self;
//    tableView.dataSource = self;
//    tableView.scrollEnabled = NO;
//    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
//    [view addSubview:tableView];
//    self.automaticallyAdjustsScrollViewInsets = NO;
    
    // 设置控件的位置和大小
    CGFloat space = 5;
    CGFloat commWidth = viewSize.width - leftRightSpace * 2;
    CGFloat lineViewHeight = 1;
    CGFloat top = 20;
    CGFloat upSpace = 10;
    CGFloat middleSpace = 50;
    CGFloat btnLeftRightSpace = 50;
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
    
    CGFloat progressViewHeight = viewSize.height - controllerTop - cardViewHeight - lineViewHeight - sumViewHeight - btnLineViewSpace - btnHeight;
    
    //    tableViewHeight = viewSize.height - controllerTop -
    
    [cardView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(view).offset(top + controllerTop);
        make.left.equalTo(view).offset(leftRightSpace);
        make.size.mas_equalTo(CGSizeMake(commWidth, cardViewHeight));
    }];
    
    [cardNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(cardView).offset(upSpace);
        make.left.equalTo(cardView).offset(leftRightSpace);
        make.size.mas_equalTo(CGSizeMake(cardNameLabelWidth, cardNameLabelSize.height));
    }];
    
    [cardNumLabel mas_makeConstraints:^(MASConstraintMaker *make) {
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
        make.centerY.equalTo(moneyView);
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
        make.centerY.equalTo(moneyView);
        make.size.mas_equalTo(CGSizeMake(sumViewWidth, sumViewHeight));
    }];
    
    [balanceMoneyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(balanceTitleLabel.mas_bottom).offset(space);
        make.left.equalTo(balanceView).offset(0);
        make.size.mas_equalTo(CGSizeMake(sumViewWidth, balanceMoneyLabelSize.height));
    }];
    [balanceTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(balanceView).offset(upSpace);
        make.left.equalTo(balanceMoneyLabel).offset(0);
        make.size.mas_equalTo(CGSizeMake(sumViewWidth, balanceTitleLabelSize.height));
    }];
    
 
    
    [sumLineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(moneyView.mas_bottom).offset(0);
        make.left.equalTo(view).offset(leftRightSpace * 2);
        make.size.mas_equalTo(CGSizeMake((cardNameLabelWidth - middleSpace) / 2, lineViewHeight));
    }];
    
    [balanceLineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(moneyView.mas_bottom).offset(0);
        make.left.equalTo(sumLineView.mas_right).offset(middleSpace);
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
    
    
    
    progressView = [[WebViewProgressView alloc] initWithFrame:CGRectMake(0, viewSize.height - progressViewHeight, viewSize.width, progressViewHeight)];
    progressView.delegate = self;
    [view addSubview:progressView];
    self.automaticallyAdjustsScrollViewInsets = NO;
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
    
    payView = [SDPayView getPayView];
    payView.style = SDPayViewOnlyPwd;
    payView.delegate = self;
    [self.view addSubview:payView];
}


/**
 获取杉德卡交易流水toke
 */
- (void)getTransFlowMoblie{

}


#pragma mark --webViewDelegate

//准备加载内容时调用的方法，通过返回值来进行是否加载的设置
- (void)cusWebView:(UIWebView *)webview shouldStartLoadWithURL:(NSURL *)URL
{
    
    
}

//开始加载时调用的方法
- (void)cusWebViewDidStartLoad:(UIWebView *)webview
{
    
}

//结束加载时调用的方法
-(void)cusWebView:(UIWebView *)webview didFinishLoadingURL:(NSURL *)URL
{
    NSLog(@"截取到URL：%@",URL);
}

//加载失败时调用的方法
- (void)cusWebView:(UIWebView *)webview didFailToLoadURL:(NSURL *)URL error:(NSError *)error
{
    
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
        case 201:
        {
            
        }
            break;
        case 202:
        {
            
        }
            break;
        case 203:
        {
            
        }
            break;
        case 301:
        {
            
        }
            break;
        case 302:
        {
            
            
        }
            break;
        case 303:
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
            
            [SDAlertControllerUtil showAlertControllerWihtTitle:nil message:@"管理我的杉德卡" actionArray:@[@"消费余额转入",@"修改此卡密码",@"解绑此卡",@"取消"] presentedViewController:self actionBlock:^(NSInteger index) {
                if (index == 0) {
                    //消费余额转入
                    SandCardRechargeViewController *mSandCardRechargeViewController = [[SandCardRechargeViewController alloc] init];
                    mSandCardRechargeViewController.tTokenType = @"02000101";
                    mSandCardRechargeViewController.controllerIndex = SANDCARDACCOUNT; //
                    mSandCardRechargeViewController.sandCardPayToolDic = payToolDic;
                    [self.navigationController pushViewController:mSandCardRechargeViewController animated:YES];
                }
                if (index == 1) {
                    //修改杉德卡密码
                    SandPwdViewController *mSandPwdViewController = [[SandPwdViewController alloc] init];
                    NSMutableDictionary *accountDic = [payToolDic objectForKey:@"account"];
                    mSandPwdViewController.accountDic = accountDic;
                    [self.navigationController pushViewController:mSandPwdViewController animated:YES];
                }
                if (index == 2) {
                    //杉德卡解绑
                    [self getAuthTools];
                }
            }];
        }
            break;
            
        default:
            break;
    }
}

#pragma mark - 业务逻辑

/**
 *@brief 获取鉴权工具
 */
- (void)getAuthTools
{
    HUD = [SDMBProgressView showSDMBProgressOnlyLoadingINViewImg:self.view];
    [SDRequestHelp shareSDRequest].HUD = HUD;
    [SDRequestHelp shareSDRequest].controller = self;
    [[SDRequestHelp shareSDRequest] dispatchGlobalQuque:^{
        __block BOOL error = NO;
        paynuc.set("tTokenType", "01001801");
        [[SDRequestHelp shareSDRequest] requestWihtFuncName:@"token/getTtoken/v1" errorBlock:^(SDRequestErrorType type) {
            error = YES;
        } successBlock:^{
            
        }];
        if (error) return ;
        
        
        
        [[SDRequestHelp shareSDRequest] requestWihtFuncName:@"authTool/getAuthTools/v1" errorBlock:^(SDRequestErrorType type) {
            error = YES;
        } successBlock:^{
            [[SDRequestHelp shareSDRequest] dispatchToMainQueue:^{
                [HUD hidden];
                
                NSString *tempAuthTools = [NSString stringWithUTF8String:paynuc.get("authTools").c_str()];
                NSArray *tempAuthToolsArray = [[PayNucHelper sharedInstance] jsonStringToArray:tempAuthTools];
                
                for (int i = 0; i < tempAuthToolsArray.count; i++) {
                    [authToolsArray addObject:tempAuthToolsArray[i]];
                }
                
                if ([authToolsArray count] <= 0) {
                    [Tool showDialog:@"获取失败"];
                } else {
                    //根据不同支付密码类型选择UI弹出框
                    NSMutableDictionary *dic = authToolsArray[0];
                    [payView setPayInfo:@[dic] moneyStr:nil orderTypeStr:nil];
                    [payView showPayTool];
                }
            }];
        }];
        if (error) return ;
    }];
}


#pragma mark - SDPayViewDelegate
- (void)payViewPwd:(NSString *)pwdStr paySuccessView:(SDPaySuccessAnimationView *)successView{
    
    //动画开始
    [successView animationStart];
    payPassword = pwdStr;
    [self unbandCardSuccessBlock:^(NSArray *paramArr){
        //解绑成功
        [successView animationSuccess];
        dispatch_time_t delayTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5f * NSEC_PER_SEC));
        dispatch_after(delayTime, dispatch_get_main_queue(), ^{
             [self ownPayTools];
        });
    } errorBlock:^(NSArray *paramArr){
        //解绑失败
        [successView animationStopClean];
        [payView hidPayTool];
    }];
}
- (void)payViewForgetPwd:(NSString *)type{
    
    if ([type isEqualToString:PAYTOOL_PAYPASS]) {
        //修改支付密码
    }
    if ([type isEqualToString:PAYTOOL_ACCPASS]) {
        //修改杉德卡密码
        SandPwdViewController *mSandPwdViewController = [[SandPwdViewController alloc] init];
        NSMutableDictionary *accountDic = [payToolDic objectForKey:@"account"];
        mSandPwdViewController.accountDic = accountDic;
        [self.navigationController pushViewController:mSandPwdViewController animated:YES];

    }
    
}

/**
 *@brief  解绑
 */
- (void)unbandCardSuccessBlock:(SandManageDeletCardStateBlock)successBlock errorBlock:(SandManageDeletCardStateBlock)errorBlock
{
    HUD = [SDMBProgressView showSDMBProgressOnlyLoadingINViewImg:self.view];
    [HUD hidden];
    [SDRequestHelp shareSDRequest].HUD = HUD;
    [SDRequestHelp shareSDRequest].controller = self;
    [[SDRequestHelp shareSDRequest] dispatchGlobalQuque:^{
        __block BOOL error = NO;
        
        NSMutableArray *tempAuthToolsArray = [[NSMutableArray alloc] init];
        NSMutableDictionary *dic = authToolsArray[0];
        NSMutableDictionary *authToolsDic = [NSMutableDictionary dictionaryWithDictionary:dic];
        [authToolsDic removeObjectForKey:@"pass"];
        NSMutableDictionary *passDic = [[NSMutableDictionary alloc] init];
        [passDic setValue:[[PayNucHelper sharedInstance] pinenc:payPassword type:@"accpass"] forKey:@"password"];
        [passDic setValue:@"" forKey:@"description"];
        [passDic setValue:@"" forKey:@"encryptType"];
        [passDic setValue:@"" forKey:@"regular"];
        [authToolsDic setObject:passDic forKey:@"pass"];
        [tempAuthToolsArray addObject:authToolsDic];
        NSString *authTools = [[PayNucHelper sharedInstance] arrayToJSON:tempAuthToolsArray];
        
        [SDLog logTest:authTools];
        
        NSString *payTool = [[PayNucHelper sharedInstance] dictionaryToJson:payToolDic];
        
        [SDLog logTest:payTool];
        
        paynuc.set("payTool", [payTool UTF8String]);
        paynuc.set("authTools", [authTools UTF8String]);
        [[SDRequestHelp shareSDRequest] requestWihtFuncName:@"card/unbandCard/v1" errorBlock:^(SDRequestErrorType type) {
            error = YES;
            [[SDRequestHelp shareSDRequest] dispatchToMainQueue:^{
                errorBlock(nil);
            }];
        } successBlock:^{
            [[SDRequestHelp shareSDRequest] dispatchToMainQueue:^{
                [HUD hidden];
                successBlock(nil);

            }];
        }];
        if (error) return ;
    }];

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
            [[SDRequestHelp shareSDRequest] dispatchToMainQueue:^{
                [Tool showDialog:@"解绑成功" defulBlock:^{
                    [self.navigationController popToRootViewControllerAnimated:YES];
                }];
            }];
        } successBlock:^{
            
        }];
        if (error) return ;
        
        
        paynuc.set("payToolKinds", "[]");
        [[SDRequestHelp shareSDRequest] requestWihtFuncName:@"payTool/getOwnPayTools/v1" errorBlock:^(SDRequestErrorType type) {
            error = YES;
            [[SDRequestHelp shareSDRequest] dispatchToMainQueue:^{
                [Tool showDialog:@"解绑成功" defulBlock:^{
                    [self.navigationController popToRootViewControllerAnimated:YES];
                }];
            }];
        } successBlock:^{
            [[SDRequestHelp shareSDRequest] dispatchToMainQueue:^{
                [HUD hidden];
                
                NSArray *payToolsArray = [[PayNucHelper sharedInstance] jsonStringToArray:[NSString stringWithUTF8String:paynuc.get("payTools").c_str()]];
                //支付工具排序
                payToolsArray = [Tool orderForPayTools:payToolsArray];
                [CommParameter sharedInstance].ownPayToolsArray = payToolsArray;
                [Tool showDialog:@"解绑成功" defulBlock:^{
                    [self.navigationController popToRootViewControllerAnimated:YES];
                }];
            }];
        }];
        if (error) return ;
    }];
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
