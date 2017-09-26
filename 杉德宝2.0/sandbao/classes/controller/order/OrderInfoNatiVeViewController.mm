//
//  OrderInfoNatiVeViewController.m
//  sandbao
//
//  Created by tianNanYiHao on 2017/4/10.
//  Copyright © 2017年 sand. All rights reserved.
//

#import "OrderInfoNatiVeViewController.h"


#import "SDPayView.h"
#import "SDLog.h"
#import "PayNucHelper.h"
#import "BindingSandViewController.h"
#import "RechargeResultViewController.h"
#import "NSDate+time.h"
#import "VerificationModeViewController.h"
#import "SandPwdViewController.h"



#define lineViewColor RGBA(237, 237, 237, 1.0)

#define titleColor RGBA(174, 174, 174, 1.0)

#define textFiledColor RGBA(83, 83, 83, 1.0)

#define btnColor RGBA(255, 97, 51, 1.0)

#define viewColor RGBA(255, 255, 255, 1.0)
typedef void(^OrderInfoPayStateBlock)(NSArray *paramArr);
@interface OrderInfoNatiVeViewController ()<SDPayViewDelegate>
{
    NavCoverView *navCoverView;
    NSMutableArray *payToolsArrayUsableM;  //可用支付工具
    NSMutableArray *payToolsArrayUnusableM; //不可用支付工具
    NSMutableDictionary *currentPayToolDic; //当前选择的支付工具
    
    NSArray *payToolsArray;
    NSDictionary *orderDic;
}

@property (nonatomic, assign) CGSize viewSize;
@property (nonatomic, assign) CGFloat viewHeight;
@property (nonatomic, assign) CGFloat moveTop;
@property (nonatomic, assign) CGFloat leftRightSpace;
@property (nonatomic, assign) CGFloat lineViewHeight;
@property (nonatomic, assign) CGFloat labelTextSize;
@property (nonatomic, assign) CGFloat textFieldTextSize;
@property (nonatomic, assign) CGFloat btnTextSize;
@property (nonatomic ,assign) CGFloat textSize;


@property (nonatomic, strong) SDMBProgressView *HUD;


@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UITextField *moneyTextField;
@property (nonatomic, strong) UILabel *bankNametLabel;
@property (nonatomic, strong) UIButton *button;
@property (nonatomic, strong) UIImageView *iconImageView;
@property (nonatomic, strong) SDPayView *payView;
@property (nonatomic, copy) NSMutableArray *payModeArray;
@property (nonatomic, strong) NSMutableDictionary *payModeDic;
@property (nonatomic,assign) float limitFloat;

@end

@implementation OrderInfoNatiVeViewController

@synthesize viewSize;
@synthesize viewHeight;
@synthesize moveTop;
@synthesize leftRightSpace;
@synthesize lineViewHeight;
@synthesize labelTextSize;
@synthesize textFieldTextSize;
@synthesize btnTextSize;
@synthesize textSize;

@synthesize HUD;
@synthesize payView;

@synthesize scrollView;
@synthesize moneyTextField;
@synthesize bankNametLabel;
@synthesize button;
@synthesize iconImageView;
@synthesize payModeArray;
@synthesize payModeDic;



#pragma mark - 业务逻辑
- (void)TNOrder:(NSString*)TN
{
    HUD = [SDMBProgressView showSDMBProgressOnlyLoadingINViewImg:self.view];
    [SDRequestHelp shareSDRequest].HUD = HUD;
    [SDRequestHelp shareSDRequest].controller = self;
    [[SDRequestHelp shareSDRequest] dispatchGlobalQuque:^{
        __block BOOL error = NO;
        paynuc.set("cfg_httpAddress", [[NSString stringWithFormat:@"%@app/api/",AddressHTTP] UTF8String]);  //朱伟丽
        paynuc.set("tTokenType", "04000101");
        [[SDRequestHelp shareSDRequest] requestWihtFuncName:@"token/getTtoken/v1" errorBlock:^(SDRequestErrorType type) {
            error = YES;
        } successBlock:^{
            
        }];
        if (error) return ;
        
        
        NSMutableDictionary *workDic = [[NSMutableDictionary alloc] init];
        [workDic setValue:@"tnPay" forKey:@"type"];
        [workDic setValue:@"" forKey:@"merOrderId"];
        [workDic setValue:_TN forKey:@"sandTN"];
        [workDic setValue:@"" forKey:@"thirdParty"];
        [workDic setValue:@"" forKey:@"transAmt"];
        [workDic setValue:@"" forKey:@"remark"];
        [workDic setValue:@"" forKey:@"feeType"];
        [workDic setValue:@"" forKey:@"fee"];
        [workDic setValue:@"" forKey:@"feeRate"];
        NSString *work = [[PayNucHelper sharedInstance] dictionaryToJson:workDic];
        [SDLog logDebug:work];
        paynuc.set("cfg_httpAddress", [[NSString stringWithFormat:@"%@app/api/",AddressHTTP] UTF8String]);
        paynuc.set("work", [work UTF8String]);
        [[SDRequestHelp shareSDRequest] requestWihtFuncName:@"payTool/getPayToolsForPay/v1" errorBlock:^(SDRequestErrorType type) {
            error = YES;
        } successBlock:^{
            [[SDRequestHelp shareSDRequest] dispatchToMainQueue:^{
                [HUD hidden];
                
                NSString *payTools = [NSString stringWithUTF8String:paynuc.get("payTools").c_str()];
                payToolsArray = [[PayNucHelper sharedInstance] jsonStringToArray:payTools];
                NSString *order = [NSString stringWithUTF8String:paynuc.get("order").c_str()];
                orderDic = [[PayNucHelper sharedInstance] jsonStringToDictionary:order];
                
                [self setPayTools];
                
                [self addView:self.view];
            }];
        }];
        if (error) return ;
    }];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.view setBackgroundColor:RGBA(247, 245, 244, 1.0)];
    viewSize = self.view.bounds.size;
    leftRightSpace = 15;
    
    payModeArray = [NSMutableArray arrayWithCapacity:0];
    
    [self settingNavigationBar];
    
    //根据订单号生成订单
    [self TNOrder:_TN];
    

}

#pragma mark - 设置导航栏
/**
 *@brief 设置导航栏
 *@return
 */
- (void)settingNavigationBar
{
    //导航渐变条
    navCoverView = [NavCoverView shareNavCoverView:CGRectMake(0, 0, viewSize.width, controllerTop) title:@"订单"];
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
    

        btnTextSize = 13;

    
    //3.设置右边的提交按钮
    UILabel *rightLab = [[UILabel alloc] init];
    rightLab.textColor = [UIColor whiteColor];
    rightLab.textAlignment = NSTextAlignmentRight;
    rightLab.font = [UIFont systemFontOfSize:textSize];
    rightLab.text = @"记录";
    [self.view addSubview:rightLab];
    
    UIButton *rightBarBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    [rightBarBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    rightBarBtn.tag = 102;
    [rightBarBtn addTarget:self action:@selector(buttonActionToDoSomething:) forControlEvents:UIControlEventTouchUpInside];
    CGSize size= [rightLab.text sizeWithNSStringFont:[UIFont systemFontOfSize:textSize]];
    rightBarBtn.contentMode = UIViewContentModeScaleAspectFit;
    [self.view addSubview:rightBarBtn];
    
    [rightLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).offset(20+leftRightSpace);
        make.right.equalTo(self.view.mas_right).offset(-leftRightSpace);
        make.size.mas_equalTo(CGSizeMake(size.width, size.height));
    }];
    
    [rightBarBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).offset(20+leftRightSpace);
        make.right.equalTo(self.view.mas_right).offset(-leftRightSpace);
        make.size.mas_equalTo(CGSizeMake(size.width, size.height));
    }];
    

}

#pragma mark - 创建组件
/**
 *@brief 创建组件
 *@param view UIView 参数：组件
 *@return
 */
-(void)addView:(UIView *)view
{
    
    CGFloat describTextSize;

        labelTextSize = 40;
        textFieldTextSize = 14;
        btnTextSize = 16;
        describTextSize = 11;

    
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
    [scrollView setBackgroundColor:RGBA(255, 255, 255, 1.0)];
    [view addSubview:scrollView];
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    
    
    
    
    //1.订单编号
    UIView *listViewOne = [[UIView alloc] init];
    listViewOne.backgroundColor = [UIColor whiteColor];
    [scrollView addSubview:listViewOne];
    
    UILabel *listTitleLabOne = [[UILabel alloc] init];
    listTitleLabOne.textColor = RGBA(7, 7, 7, 1.0);
    listTitleLabOne.font = [UIFont systemFontOfSize:textFieldTextSize];
    listTitleLabOne.textAlignment = NSTextAlignmentLeft;
    listTitleLabOne.text = @"订单编号";
    [listViewOne addSubview:listTitleLabOne];
    
    UILabel *listDescriLabOne = [[UILabel alloc] init];
    listDescriLabOne.textColor = RGBA(133, 133, 133, 1.0);
    listDescriLabOne.font = [UIFont systemFontOfSize:describTextSize];
    listDescriLabOne.textAlignment = NSTextAlignmentRight;
    listDescriLabOne.text = @"L297347659270103848";
    [listViewOne addSubview:listDescriLabOne];
    
    
    UIView *lineVOne = [[UIView alloc] init];
    lineVOne.backgroundColor = RGBA(223, 223, 223, 1.0);
    [listViewOne addSubview:lineVOne];
    
    
    
    //2.下单时间
    UIView *listViewTwo = [[UIView alloc] init];
    listViewTwo.backgroundColor = [UIColor whiteColor];
    [scrollView addSubview:listViewTwo];
    
    UILabel *listTitleLabTwo = [[UILabel alloc] init];
    listTitleLabTwo.textColor = RGBA(7, 7, 7, 1.0);
    listTitleLabTwo.font = [UIFont systemFontOfSize:textFieldTextSize];
    listTitleLabTwo.textAlignment = NSTextAlignmentLeft;
    listTitleLabTwo.text = @"下单时间";
    [listViewTwo addSubview:listTitleLabTwo];
    
    UILabel *listDescriLabTwo = [[UILabel alloc] init];
    listDescriLabTwo.textColor = RGBA(133, 133, 133, 1.0);
    listDescriLabTwo.font = [UIFont systemFontOfSize:describTextSize];
    listDescriLabTwo.textAlignment = NSTextAlignmentRight;
    listDescriLabTwo.text = @"2017-03-08 10:19:13";
    [listViewTwo addSubview:listDescriLabTwo];
    
    
    UIView *lineVTwo = [[UIView alloc] init];
    lineVTwo.backgroundColor = RGBA(223, 223, 223, 1.0);
    [listViewTwo addSubview:lineVTwo];
    
    
    //3.手机号码
    UIView *listViewThr = [[UIView alloc] init];
    listViewThr.backgroundColor = [UIColor whiteColor];
    [scrollView addSubview:listViewThr];
    
    UILabel *listTitleLabThr = [[UILabel alloc] init];
    listTitleLabThr.textColor = RGBA(7, 7, 7, 1.0);
    listTitleLabThr.font = [UIFont systemFontOfSize:textFieldTextSize];
    listTitleLabThr.textAlignment = NSTextAlignmentLeft;
    listTitleLabThr.text = @"手机号码";
    [listViewThr addSubview:listTitleLabThr];
    
    UILabel *listDescriLabThr = [[UILabel alloc] init];
    listDescriLabThr.textColor = RGBA(133, 133, 133, 1.0);
    listDescriLabThr.font = [UIFont systemFontOfSize:describTextSize];
    listDescriLabThr.textAlignment = NSTextAlignmentRight;
    listDescriLabThr.text = @"15153729876";
    [listViewThr addSubview:listDescriLabThr];
    
    
    UIView *lineVThr = [[UIView alloc] init];
    lineVThr.backgroundColor = RGBA(223, 223, 223, 1.0);
    [listViewThr addSubview:lineVThr];
    
    
    //4.订单金额
    UIView *listViewFour = [[UIView alloc] init];
    listViewFour.backgroundColor = [UIColor whiteColor];
    [scrollView addSubview:listViewFour];
    
    UILabel *listTitleLabFour = [[UILabel alloc] init];
    listTitleLabFour.textColor = RGBA(7, 7, 7, 1.0);
    listTitleLabFour.font = [UIFont systemFontOfSize:textFieldTextSize];
    listTitleLabFour.textAlignment = NSTextAlignmentLeft;
    listTitleLabFour.text = @"订单金额";
    [listViewFour addSubview:listTitleLabFour];
    
    UILabel *listDescriLabFour = [[UILabel alloc] init];
    listDescriLabFour.textColor = RGBA(133, 133, 133, 1.0);
    listDescriLabFour.font = [UIFont systemFontOfSize:describTextSize];
    listDescriLabFour.textAlignment = NSTextAlignmentRight;
    listDescriLabFour.text = @"¥ 50";
    [listViewFour addSubview:listDescriLabFour];
    
    
    UIView *lineVFour = [[UIView alloc] init];
    lineVFour.backgroundColor = RGBA(223, 223, 223, 1.0);
    [listViewFour addSubview:lineVFour];
    
    
    //5.订单状态
    UIView *listViewFiv = [[UIView alloc] init];
    listViewFiv.backgroundColor = [UIColor whiteColor];
    [scrollView addSubview:listViewFiv];
    
    UILabel *listTitleLabFiv = [[UILabel alloc] init];
    listTitleLabFiv.textColor = RGBA(7, 7, 7, 1.0);
    listTitleLabFiv.font = [UIFont systemFontOfSize:textFieldTextSize];
    listTitleLabFiv.textAlignment = NSTextAlignmentLeft;
    listTitleLabFiv.text = @"订单状态";
    [listViewFiv addSubview:listTitleLabFiv];
    
    UILabel *listDescriLabFiv = [[UILabel alloc] init];
    listDescriLabFiv.textColor = RGBA(133, 133, 133, 1.0);
    listDescriLabFiv.font = [UIFont systemFontOfSize:describTextSize];
    listDescriLabFiv.textAlignment = NSTextAlignmentRight;
    listDescriLabFiv.text = @"等待支付";
    [listViewFiv addSubview:listDescriLabFiv];
    
    
    UIView *lineVFiv = [[UIView alloc] init];
    lineVFiv.backgroundColor = RGBA(223, 223, 223, 1.0);
    [listViewFiv addSubview:lineVFiv];
    
    
    
    //确认支付
    UIButton *payBtn = [[UIButton alloc] init];
    payBtn.tag = 201;
    [payBtn setTitle:@"确认支付" forState: UIControlStateNormal];
    [payBtn setTitleColor:RGBA(255, 255, 255, 1.0) forState:UIControlStateNormal];
    payBtn.titleLabel.font = [UIFont systemFontOfSize:btnTextSize];
    [payBtn setBackgroundImage:[UIImage imageWithColor:RGBA(48, 193, 255, 1.0)] forState:UIControlStateNormal];
    [payBtn.layer setMasksToBounds:YES];
    payBtn.layer.cornerRadius = 5.0;
    [payBtn addTarget:self action:@selector(buttonActionToDoSomething:) forControlEvents:UIControlEventTouchUpInside];
    [scrollView addSubview:payBtn];
    
    
    //取消订单
    UIButton *cancleBtn = [[UIButton alloc] init];
    cancleBtn.tag = 202;
    [cancleBtn setTitle:@"取消订单" forState: UIControlStateNormal];
    [cancleBtn setTitleColor:RGBA(255, 255, 255, 1.0) forState:UIControlStateNormal];
    cancleBtn.titleLabel.font = [UIFont systemFontOfSize:btnTextSize];
    [cancleBtn setBackgroundImage:[UIImage imageWithColor:RGBA(96, 224, 178, 1.0)] forState:UIControlStateNormal];
    [cancleBtn.layer setMasksToBounds:YES];
    cancleBtn.layer.cornerRadius = 5.0;
    [cancleBtn addTarget:self action:@selector(buttonActionToDoSomething:) forControlEvents:UIControlEventTouchUpInside];
    [scrollView addSubview:cancleBtn];
    
    
    
    //设置控件的位置和大小
    CGFloat commWidth = viewSize.width - 2 * leftRightSpace;
    CGFloat space = 10;
    CGFloat scrollViewH = viewSize.height - controllerTop;
    CGFloat payModeBtnTop = 30;
    CGFloat textTitleTopSpace = 20;
    
    CGSize textTitleSize = [@"订单编号" sizeWithNSStringFont:[UIFont systemFontOfSize:textFieldTextSize]];
    CGFloat textDescriLabH = [@"订单编号" sizeWithNSStringFont:[UIFont systemFontOfSize:describTextSize]].height;
    CGFloat textDescriSzie = commWidth - textTitleSize.width - space;
    CGFloat listViewH = textTitleSize.height + 2*textTitleTopSpace;
    
    CGSize payBtnSize = CGSizeMake((commWidth-space)/2, textTitleSize.height+2*leftRightSpace);
    
    
    
    [scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(view).offset(controllerTop);
        make.centerX.equalTo(view);
        make.size.mas_equalTo(CGSizeMake(viewSize.width, scrollViewH));
    }];
    
    //1
    [listViewOne mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(scrollView.mas_top).offset(leftRightSpace);
        make.centerX.equalTo(scrollView.mas_centerX);
        make.size.mas_equalTo(CGSizeMake(commWidth, listViewH));
    }];
    
    [listTitleLabOne mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(listViewOne.mas_top).offset(textTitleTopSpace);
        make.left.equalTo(listViewOne.mas_left);
        make.size.mas_equalTo(textTitleSize);
    }];
    
    [listDescriLabOne mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(listViewOne.mas_centerY);
        make.right.equalTo(listViewOne.mas_right);
        make.size.mas_equalTo(CGSizeMake(textDescriSzie, textDescriLabH));
    }];
    
    [lineVOne mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(listViewOne.mas_bottom);
        make.centerX.equalTo(listViewOne.mas_centerX);
        make.size.mas_equalTo(CGSizeMake(commWidth, 1));
    }];
    
    
    //2
    [listViewTwo mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(listViewOne.mas_bottom).offset(0);
        make.centerX.equalTo(scrollView.mas_centerX);
        make.size.mas_equalTo(CGSizeMake(commWidth, listViewH));
    }];
    
    [listTitleLabTwo mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(listViewTwo.mas_top).offset(textTitleTopSpace);
        make.left.equalTo(listViewTwo.mas_left);
        make.size.mas_equalTo(textTitleSize);
    }];
    
    [listDescriLabTwo mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(listViewTwo.mas_centerY);
        make.right.equalTo(listViewTwo.mas_right);
        make.size.mas_equalTo(CGSizeMake(textDescriSzie, textDescriLabH));
    }];
    
    [lineVTwo mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(listViewTwo.mas_bottom);
        make.centerX.equalTo(listViewTwo.mas_centerX);
        make.size.mas_equalTo(CGSizeMake(commWidth, 1));
    }];
    
    
    //3
    [listViewThr mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(listViewTwo.mas_bottom).offset(0);
        make.centerX.equalTo(scrollView.mas_centerX);
        make.size.mas_equalTo(CGSizeMake(commWidth, listViewH));
    }];
    
    [listTitleLabThr mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(listViewThr.mas_top).offset(textTitleTopSpace);
        make.left.equalTo(listViewThr.mas_left);
        make.size.mas_equalTo(textTitleSize);
    }];
    
    [listDescriLabThr mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(listViewThr.mas_centerY);
        make.right.equalTo(listViewThr.mas_right);
        make.size.mas_equalTo(CGSizeMake(textDescriSzie, textDescriLabH));
    }];
    
    [lineVThr mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(listViewThr.mas_bottom);
        make.centerX.equalTo(listViewThr.mas_centerX);
        make.size.mas_equalTo(CGSizeMake(commWidth, 1));
    }];
    
    //4
    [listViewFour mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(listViewThr.mas_bottom).offset(0);
        make.centerX.equalTo(scrollView.mas_centerX);
        make.size.mas_equalTo(CGSizeMake(commWidth, listViewH));
    }];
    
    [listTitleLabFour mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(listViewFour.mas_top).offset(textTitleTopSpace);
        make.left.equalTo(listViewFour.mas_left);
        make.size.mas_equalTo(textTitleSize);
    }];
    
    [listDescriLabFour mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(listViewFour.mas_centerY);
        make.right.equalTo(listViewFour.mas_right);
        make.size.mas_equalTo(CGSizeMake(textDescriSzie, textDescriLabH));
    }];
    
    [lineVFour mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(listViewFour.mas_bottom);
        make.centerX.equalTo(listViewFour.mas_centerX);
        make.size.mas_equalTo(CGSizeMake(commWidth, 1));
    }];
    
    
    //5
    [listViewFiv mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(listViewFour.mas_bottom).offset(0);
        make.centerX.equalTo(scrollView.mas_centerX);
        make.size.mas_equalTo(CGSizeMake(commWidth, listViewH));
    }];
    
    [listTitleLabFiv mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(listViewFiv.mas_top).offset(textTitleTopSpace);
        make.left.equalTo(listViewFiv.mas_left);
        make.size.mas_equalTo(textTitleSize);
    }];
    
    [listDescriLabFiv mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(listViewFiv.mas_centerY);
        make.right.equalTo(listViewFiv.mas_right);
        make.size.mas_equalTo(CGSizeMake(textDescriSzie, textDescriLabH));
    }];
    
    [lineVFiv mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(listViewFiv.mas_bottom);
        make.centerX.equalTo(listViewFiv.mas_centerX);
        make.size.mas_equalTo(CGSizeMake(commWidth, 1));
    }];
    
    
    //确认支付
    [payBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(listViewFiv.mas_bottom).offset(payModeBtnTop);
        make.left.equalTo(scrollView.mas_left).offset(leftRightSpace);
        make.size.mas_equalTo(payBtnSize);
    }];
    
    //取消支付
    [cancleBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(listViewFiv.mas_bottom).offset(payModeBtnTop);
        make.left.equalTo(payBtn.mas_right).offset(space);
        make.size.mas_equalTo(payBtnSize);
    }];
    

    //更新UI数据
    //订单号
    NSString *orderId = [orderDic objectForKey:@"orderId"];
    //订单时间
    NSString *orderTime = [orderDic objectForKey:@"time"];
    orderTime = [NSDate formatTime:1 param:orderTime];
    //手机号
    NSString *orderPhoneNum = [CommParameter sharedInstance].userName;
    //订单金额
    NSNumber *orderMoneyNumber = [orderDic objectForKey:@"amount"];
    NSString *orderMoney = [NSString stringWithFormat:@"¥ %.2f", [orderMoneyNumber floatValue]/100];
    //订单状态
    NSString *orderStatus = [orderDic objectForKey:@"status"];
    if ([orderStatus isEqualToString:@"success"]) {
        orderStatus = @"成功";
    }
    else if ([orderStatus isEqualToString:@"failure"]){
        orderStatus = @"失败";
    }
    else if ([orderStatus isEqualToString:@"pending"]){
        orderStatus = @"未支付";
    }
    
    listDescriLabOne.text = orderId;
    listDescriLabTwo.text = orderTime;
    listDescriLabThr.text = orderPhoneNum;
    listDescriLabFour.text = orderMoney;
    listDescriLabFiv.text = orderStatus;
    
    payView = [SDPayView getPayView];
    payView.delegate = self;
    [self.view addSubview:payView];
    
    
    
}


#pragma mark - 设置支付工具列表
-(void)setPayTools{
    
    
    //排序
    payToolsArray = [Tool orderForPayTools:payToolsArray];
    if ([payToolsArray count] <= 0) {
        [Tool showDialog:@"无可用方式,请绑卡重试" defulBlock:^{
            BindingSandViewController *mBindingSandViewController = [[BindingSandViewController alloc] init];
            [self.navigationController pushViewController:mBindingSandViewController animated:YES];
        }];
    }else{
        //1.过滤用支付工具
        payToolsArrayUsableM = [NSMutableArray arrayWithCapacity:0];
        payToolsArrayUnusableM = [NSMutableArray arrayWithCapacity:0];
        for (int i = 0; i<payToolsArray.count; i++) {
            if ([@"0" isEqualToString:[NSString stringWithFormat:@"%@",[[payToolsArray[i] objectForKey:@"account"] objectForKey:@"useableBalance"]]] || [[payToolsArray[i] objectForKey:@"available"] boolValue]== NO) {
                //不可用支付工具集
                [payToolsArrayUnusableM addObject:payToolsArray[i]];
            }else{
                //可用支付工具集
                [payToolsArrayUsableM addObject:payToolsArray[i]];
            }
        }
        
        //3.设置支付方式列表
        [self initPayMode:payToolsArray];
    }

    
}


/**
 *@brief 初始化支付方式
 */
- (void)initPayMode:(NSArray *)paramArray
{
    
    NSMutableDictionary *bankDic = [[NSMutableDictionary alloc] init];
    [bankDic setValue:@"PAYLTOOL_LIST_ACCPASS" forKey:@"type"];
    [bankDic setValue:@"添加杉德卡支付" forKey:@"title"];
    [bankDic setValue:@"list_sand_AddCard" forKey:@"img"];
    [bankDic setValue:@"" forKey:@"limit"];
    [bankDic setValue:@"2" forKey:@"state"];
    [bankDic setValue:@"true" forKey:@"available"];
    [payToolsArrayUsableM addObject:bankDic];
    
    NSInteger unavailableArrayCount = [payToolsArrayUnusableM count];
    for (int i = 0; i < unavailableArrayCount; i++) {
        [payToolsArrayUsableM addObject:payToolsArrayUnusableM[i]];
    }
    payModeArray = payToolsArrayUsableM;

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
        case 201:
        {
            //订单金额
            NSNumber *orderMoneyNumber = [orderDic objectForKey:@"amount"];
            NSString *orderMoney = [NSString stringWithFormat:@"¥ %.2f", [orderMoneyNumber floatValue]/100];
            [payView setPayInfo:payModeArray moneyStr:orderMoney orderTypeStr:@"扫码付订单"];
            [payView showPayTool];
        }
            break;
        case 202:
        {
            [self.navigationController popToRootViewControllerAnimated:YES];
        }
            break;
        case 101:
        {
            [self.navigationController popToRootViewControllerAnimated:YES];
        }
            break;
        case 102:
        {
            
        }
            break;
        default:
            break;
    }
}
 
#pragma mark - SDPayViewDelegate

- (void)payViewSelectPayToolDic:(NSMutableDictionary *)selectPayToolDict{
    
    payModeDic = [[NSMutableDictionary alloc] initWithDictionary:selectPayToolDict];
    //根据不同支付密码类型选择UI弹出框
    currentPayToolDic = [selectPayToolDict objectForKey:@"authTools"][0];
    
    //1.可用金额作限制
    //订单金额
    float orderMoneyflot = [[orderDic objectForKey:@"amount"] floatValue];
    //limit金额
    _limitFloat = [[PayNucHelper sharedInstance] limitInfo:[selectPayToolDict objectForKey:@"limit"]]/100;
    
    if (orderMoneyflot>_limitFloat) {
        [Tool showDialog:@"您的可使用金额已超限,可继续付款" defulBlock:^{
        }];
        //        return;
    }
 
}

- (void)payViewPwd:(NSString *)pwdStr paySuccessView:(SDPaySuccessAnimationView *)successView{
    
    //支付动画开始
    [successView animationStart];
    
    [self pay:pwdStr orderPaySuccessBlock:^(NSArray *paramArr){
        //支付成功
        [successView animationSuccess];
        dispatch_time_t delayTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5f * NSEC_PER_SEC));
        dispatch_after(delayTime, dispatch_get_main_queue(), ^{
            RechargeResultViewController *mRechargeResultViewController = [[RechargeResultViewController alloc] init];
            mRechargeResultViewController.viewControllerIndex = _controllerIndex;
            mRechargeResultViewController.workDic = paramArr[0];
            mRechargeResultViewController.payToolDic = paramArr[1];
            [self.navigationController pushViewController:mRechargeResultViewController animated:YES];
        });

    } oederErrorBlock:^(NSArray *paramArr){
        //支付失败
        [successView animationStopClean];
        [payView hidPayTool];
    }];
}

- (void)payViewForgetPwd:(NSString *)type{
    
    if ([type isEqualToString:PAYTOOL_PAYPASS]) {
        //修改支付密码
        VerificationModeViewController *mVerificationModeViewController = [[VerificationModeViewController alloc] init];
        mVerificationModeViewController.tokenType = @"01000601";
        [self.navigationController pushViewController:mVerificationModeViewController animated:YES];
    }
    if ([type isEqualToString:PAYTOOL_ACCPASS]) {
        //修改杉德卡密码
        SandPwdViewController *mSandPwdViewController = [[SandPwdViewController alloc] init];
        NSMutableDictionary *accountDic = [currentPayToolDic objectForKey:@"account"];
        mSandPwdViewController.accountDic = accountDic;
        [self.navigationController pushViewController:mSandPwdViewController animated:YES];
        
    }
    
}

- (void)payViewAddPayToolCard:(NSString *)type{
    
    if ([type isEqualToString:PAYTOOL_PAYPASS]) {
        
    }
    if ([type isEqualToString:PAYTOOL_ACCPASS]) {
        BindingSandViewController *mBindingSandViewController = [[BindingSandViewController alloc] init];
        [self.navigationController pushViewController:mBindingSandViewController animated:YES];
    }
}





/**
 *@brief 支付
 *@return
 */
- (void)pay:(NSString *)param orderPaySuccessBlock:(OrderInfoPayStateBlock)successBlock oederErrorBlock:(OrderInfoPayStateBlock)errorBlock
{
    HUD = [SDMBProgressView showSDMBProgressOnlyLoadingINViewImg:self.view];
    [HUD hidden];
    [SDRequestHelp shareSDRequest].HUD = HUD;
    [SDRequestHelp shareSDRequest].controller = self;
    [[SDRequestHelp shareSDRequest] dispatchGlobalQuque:^{
        __block BOOL error = NO;
        
        NSString *transAmt = [NSString stringWithFormat:@"%.0f", [[orderDic objectForKey:@"amount"] floatValue]];
        
        NSMutableDictionary *workDic = [[NSMutableDictionary alloc] init];
        [workDic setValue:@"tnPay" forKey:@"type"];
        [workDic setValue:[orderDic objectForKey:@"orderId"] forKey:@"merOrderId"];
        [workDic setValue:_TN forKey:@"sandTN"];
        [workDic setValue:@"" forKey:@"thirdParty"];
        [workDic setValue:transAmt forKey:@"transAmt"];
        [workDic setValue:@"" forKey:@"remark"];
        [workDic setValue:@"out" forKey:@"feeType"];
        [workDic setValue:@"" forKey:@"fee"];
        [workDic setValue:@"" forKey:@"feeRate"];
        
        NSString *work = [[PayNucHelper sharedInstance] dictionaryToJson:workDic];
        [SDLog logDebug:work];
        
        NSArray *authToolsArray = [payModeDic objectForKey:@"authTools"];
        
        NSMutableArray *tempAuthToolsArray = [[NSMutableArray alloc] init];
        
        
        NSMutableDictionary *dic = authToolsArray[0];
        NSMutableDictionary *authToolsDic = [NSMutableDictionary dictionaryWithDictionary:dic];
        [authToolsDic removeObjectForKey:@"pass"];
        NSMutableDictionary *passDic = [[NSMutableDictionary alloc] init];
        if ([[authToolsDic objectForKey:@"type"] isEqualToString:@"paypass"]){
            [passDic setValue:[[PayNucHelper sharedInstance] pinenc:param type:@"paypass"] forKey:@"password"];
        }
        else if([[authToolsDic objectForKey:@"type"] isEqualToString:@"accpass"]){
            [passDic setValue:[[PayNucHelper sharedInstance] pinenc:param type:@"accpass"] forKey:@"password"];
        }
        [passDic setValue:@"" forKey:@"description"];
        [passDic setValue:@"" forKey:@"encryptType"];
        [passDic setValue:@"" forKey:@"regular"];
        [authToolsDic setObject:passDic forKey:@"pass"];
        [tempAuthToolsArray addObject:authToolsDic];
        [payModeDic setObject:tempAuthToolsArray forKey:@"authTools"];
        
        NSString *payTool = [[PayNucHelper sharedInstance] dictionaryToJson:payModeDic];
        [SDLog logDebug:payTool];
        paynuc.set("work", [work UTF8String]);
        paynuc.set("payTool", [payTool UTF8String]);
        paynuc.set("authTools", [@"[]" UTF8String]);
        [[SDRequestHelp shareSDRequest] requestWihtFuncName:@"business/pay/v1" errorBlock:^(SDRequestErrorType type) {
            error = YES;
            [[SDRequestHelp shareSDRequest] dispatchToMainQueue:^{
                errorBlock(nil);
            }];
        } successBlock:^{
            [[SDRequestHelp shareSDRequest] dispatchToMainQueue:^{
                [HUD hidden];
                NSString *work = [NSString stringWithUTF8String:paynuc.get("work").c_str()];
                NSDictionary *workDic = [[PayNucHelper sharedInstance] jsonStringToDictionary:work];
                successBlock(@[workDic,payModeDic]);
            }];
        }];
    }];
    
}
/**
 *@brief 隐藏键盘
 */
- (void)dismissKeyboard {
    //将视图的Y坐标向上移动offset个单位，以使下面腾出地方用于软键盘的显示
    [scrollView setContentOffset:CGPointMake(0.0f, 0.0f) animated:YES] ;
    [self.view endEditing:YES];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
