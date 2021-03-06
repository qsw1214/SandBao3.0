//
//  TnOrderViewController.m
//  sandbao
//
//  Created by tianNanYiHao on 2017/12/7.
//  Copyright © 2017年 sand. All rights reserved.
//

#import "TnOrderViewController.h"
#import "PayNucHelper.h"

#import "TnOrderCellView.h"
#import "RechargeFinishViewController.h"
#import "VerifyTypeViewController.h"
#import "AddBankCardViewController.h"

typedef void(^OrderInfoPayStateBlock)(NSArray *paramArr);
@interface TnOrderViewController ()<SDPayViewDelegate>
{
    UIView *headView;
    UIView *bodyView;
    
    NSArray *payToolsArray; //从tn获取的支付工具
    
    NSDictionary *orderDic; //订单信息
    
    UILabel *titleLab;//订单大标题
    UILabel *moneyLab;//订单金额
    
    TnOrderCellView *orderTimeCell; //订单时间
    TnOrderCellView *orderNameCell; //订单名
    TnOrderCellView *orderNoCell;   //订单号
    TnOrderCellView *orderPayWayCell; //订单支付方式
    
    NSDictionary *successWorkDic; //支付成功后返回的work
    
    NSDecimalNumber *limitDec;
    
    SDBarButton *barButton;
}
/**
 支付工具控件
 */
@property (nonatomic, strong) SDPayView *payView;

/**
 所选的支付-支付工具
 */
@property (nonatomic, strong) NSMutableDictionary *selectedPayDict;

@end

@implementation TnOrderViewController

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    //清除payView
    if (self.payView) {
        [self.payView hidePayTool];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self create_HeadView];
    [self create_bodyView];
    [self create_PayView];
    [self TNOrder:self.TN];
    
    
}
#pragma mark - 重写父类-baseScrollView设置
- (void)setBaseScrollview{
    [super setBaseScrollview];
}
#pragma mark - 重写父类-导航设置方法
- (void)setNavCoverView{
    [super setNavCoverView];
    self.navCoverView.style = NavCoverStyleWhite;
    self.navCoverView.midTitleStr = @"杉德宝安全支付";
    self.navCoverView.rightTitleStr = @"取消";
    
    __weak TnOrderViewController *weakSelf = self;
    self.navCoverView.rightBlock = ^{
        //正扫返回
        UIViewController *secVC = weakSelf.navigationController.viewControllers[0];
        [weakSelf.navigationController popToViewController:secVC animated:YES];
    };
}
#pragma mark - 重写父类-点击方法集合
- (void)buttonClick:(UIButton *)btn{
    
    if (btn.tag == BTN_TAG_PAY) {
        
        //@"立即付款"
        [self.payView showPayTool];
    }
}

#pragma mark  - UI绘制
- (void)create_HeadView{
    
    headView = [[UIView alloc] init];
    headView.backgroundColor = COLOR_F5F5F5;
    [self.baseScrollView addSubview:headView];
    
    titleLab = [Tool createLable:@"杉德宝-订单编号:" attributeStr:nil font:FONT_15_Medium textColor:COLOR_343339 alignment:NSTextAlignmentCenter];
    [headView addSubview:titleLab];
    
    moneyLab = [Tool createLable:@"¥--" attributeStr:nil font:FONT_36_SFUIT_Rrgular textColor:COLOR_343339 alignment:NSTextAlignmentCenter];
    [headView addSubview:moneyLab];
    
    CGFloat headViewH = UPDOWNSPACE_25 + titleLab.height + UPDOWNSPACE_10 + moneyLab.height + UPDOWNSPACE_25;
    
    [headView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.baseScrollView);
        make.centerX.equalTo(self.baseScrollView);
        make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH, headViewH));
    }];
    
    [titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(headView.mas_top).offset(UPDOWNSPACE_25);
        make.centerX.equalTo(headView);
        make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH, titleLab.height));
    }];
    
    [moneyLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(titleLab.mas_bottom).offset(UPDOWNSPACE_10);
        make.centerX.equalTo(headView);
        make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH, moneyLab.height));
    }];
    
}


- (void)create_bodyView{
    bodyView = [[UIView alloc] init];
    bodyView.backgroundColor = COLOR_FFFFFF;
    [self.baseScrollView addSubview:bodyView];
    
    orderTimeCell = [TnOrderCellView createSetCellViewOY:0];
    orderTimeCell.titleLab.textColor = COLOR_343339_5;
    orderTimeCell.titleStr = @"订单时间";
    orderTimeCell.clickBlock = ^{
        
    };
    orderTimeCell.rightStr = @"----";
    [bodyView addSubview:orderTimeCell];
    
    orderNameCell = [TnOrderCellView createSetCellViewOY:0];
    orderNameCell.titleLab.textColor = COLOR_343339_5;
    orderNameCell.titleStr = @"商户名称";
    orderNameCell.clickBlock = ^{
        
    };
    orderNameCell.rightStr = @"----";
    [bodyView addSubview:orderNameCell];
    
    orderNoCell = [TnOrderCellView createSetCellViewOY:0];
    orderNoCell.titleLab.textColor = COLOR_343339_5;
    orderNoCell.titleStr = @"商户订单号";
    orderNoCell.clickBlock = ^{
        
    };
    orderNoCell.rightStr = @"----";
    [bodyView addSubview:orderNoCell];
    
    orderPayWayCell = [TnOrderCellView createSetCellViewOY:0];
    orderPayWayCell.titleLab.textColor = COLOR_343339_5;
    orderPayWayCell.titleStr = @"支付方式";
    orderPayWayCell.clickBlock = ^{
        
    };
    orderPayWayCell.rightStr = @"----";
    [bodyView addSubview:orderPayWayCell];

    //payBarBtn
    barButton = [[SDBarButton alloc] init];
    UIView *payBarBtn = [barButton createBarButton:@"立即付款" font:FONT_15_Regular titleColor:COLOR_FFFFFF backGroundColor:COLOR_358BEF leftSpace:LEFTRIGHTSPACE_40];
    barButton.btn.tag = BTN_TAG_PAY;
    [barButton.btn addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    [bodyView addSubview:payBarBtn];
    [barButton changeState:YES];
    
    bodyView.height = orderTimeCell.height *4 + UPDOWNSPACE_69 + payBarBtn.height + UPDOWNSPACE_122;
    
    [bodyView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(headView.mas_bottom);
        make.centerX.equalTo(self.baseScrollView);
        make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH, bodyView.height));
    }];
    
    [orderTimeCell mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(bodyView);
        make.centerX.equalTo(bodyView);
        make.size.mas_equalTo(orderTimeCell.size);
    }];
    
    [orderNameCell mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(orderTimeCell.mas_bottom);
        make.centerX.equalTo(bodyView);
        make.size.mas_equalTo(orderNameCell.size);
    }];
    
    [orderNoCell mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(orderNameCell.mas_bottom);
        make.centerX.equalTo(bodyView);
        make.size.mas_equalTo(orderNoCell.size);
    }];

    [orderPayWayCell mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(orderNoCell.mas_bottom);
        make.centerX.equalTo(bodyView);
        make.size.mas_equalTo(orderPayWayCell.size);
    }];
    
    [payBarBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(orderPayWayCell.mas_bottom).offset(UPDOWNSPACE_69);
        make.centerX.equalTo(bodyView);
        make.size.mas_equalTo(payBarBtn.size);
    }];
    
}
- (void)create_PayView{
    self.payView = [SDPayView getPayView];
    self.payView.addCardType = SDPayView_ADDBANKCARD;
    self.payView.delegate = self;
    [[UIApplication sharedApplication].keyWindow addSubview:self.payView];
    
}

#pragma mark - SDPayViewDelegate
- (void)payViewReturnDefulePayToolDic:(NSMutableDictionary *)defulePayToolDic{
    //设置默认支付工具(显示)
    self.selectedPayDict = defulePayToolDic;
    //刷新订单页面信息
    [self resetTnOrderInfo];
}
- (void)payViewSelectPayToolDic:(NSMutableDictionary *)selectPayToolDict{
    
    //设置当前所选支付工具
    self.selectedPayDict = selectPayToolDict;
    
    //刷新页面信息
    [self resetTnOrderInfo];
    
}
- (void)payViewPwd:(NSString *)pwdStr paySuccessView:(SDPaySuccessAnimationView *)successView{
    
    //支付动画开始
    [successView animationStart];
    
    [self pay:pwdStr orderPaySuccessBlock:^(NSArray *paramArr){
        //支付成功
        [successView animationSuccess];
        dispatch_time_t delayTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5f * NSEC_PER_SEC));
        dispatch_after(delayTime, dispatch_get_main_queue(), ^{
            //付款成功!
            RechargeFinishViewController *rechargeFinishVC = [[RechargeFinishViewController alloc] init];
            rechargeFinishVC.transTypeName = @"支付成功";
            rechargeFinishVC.amtMoneyStr = [NSString stringWithFormat:@"%.2f",[[successWorkDic objectForKey:@"transAmt"] floatValue]/100];
            rechargeFinishVC.payOutName = [self.selectedPayDict objectForKey:@"title"];
            rechargeFinishVC.payOutNo = [[self.selectedPayDict objectForKey:@"account"] objectForKey:@"accNo"];
            [self.navigationController pushViewController:rechargeFinishVC animated:YES];
        });
        
    } oederErrorBlock:^(NSArray *paramArr){
        //支付失败- 动画停止
        [successView animationStopClean];
        //支付失败 - 复位到支付订单
        [self.payView payPwdResetToPayOrderView];
        if (paramArr.count>0) {
            [[SDAlertView shareAlert] showDialog:paramArr[0]];
        }else{
            [[SDAlertView shareAlert] showDialog:@"网络连接异常"];
        }
    }];
}

- (void)payViewForgetPwd:(NSString *)type{
    
    if ([type isEqualToString:PAYTOOL_PAYPASS]) {
        //@"修改支付密码"
        VerifyTypeViewController *verifyTypeVC = [[VerifyTypeViewController alloc] init];
        verifyTypeVC.tokenType = @"01000601";
        verifyTypeVC.verifyType = VERIFY_TYPE_CHANGEPATPWD;
        verifyTypeVC.popToRoot = YES;
        verifyTypeVC.phoneNoStr = [CommParameter sharedInstance].phoneNo;
        [self.navigationController pushViewController:verifyTypeVC animated:YES];
    }
    
}

- (void)payViewAddPayToolCard:(NSString *)type{
    
    if ([type isEqualToString:PAYTOOL_PAYPASS]) {
        NSArray *bankCardArr = [self getBankCardPayToolArr];
        if (bankCardArr.count>=3) {
            [[SDAlertView shareAlert] showDialog:@"已绑定3张银行卡,不可继续绑卡"];
        }else{
            AddBankCardViewController *addBankCardVC = [[AddBankCardViewController alloc] init];
            [self.navigationController pushViewController:addBankCardVC animated:YES];
        }
    }
    if ([type isEqualToString:PAYTOOL_ACCPASS]) {
        
    }
}
- (void)payViewPayToolsError:(NSString *)errorInfo{
    [[SDAlertView shareAlert] showDialog:errorInfo defulBlock:^{
        UIViewController *secVC = self.navigationController.viewControllers[1];
        [self.navigationController popToViewController:secVC animated:YES];
    }];
}

#pragma mark - 业务逻辑
#pragma mark 获取支付工具
- (void)TNOrder:(NSString*)TN
{
    self.HUD = [SDMBProgressView showSDMBProgressOnlyLoadingINViewImg:self.view];
    [SDRequestHelp shareSDRequest].HUD = self.HUD;
    [SDRequestHelp shareSDRequest].controller = self;
    [[SDRequestHelp shareSDRequest] dispatchGlobalQuque:^{
        __block BOOL error = NO;
        
        paynuc.set("tTokenType", "04000101");
        [[SDRequestHelp shareSDRequest] requestWihtFuncName:@"token/getTtoken/v1" errorBlock:^(SDRequestErrorType type) {
            error = YES;
        } successBlock:^{
            
        }];
        if (error) return ;
        
        
        NSMutableDictionary *workDic = [[NSMutableDictionary alloc] init];
        [workDic setValue:@"tnPay" forKey:@"type"];
        [workDic setValue:_TN forKey:@"sandTN"];
        NSString *work = [[PayNucHelper sharedInstance] dictionaryToJson:workDic];
        
        paynuc.set("work", [work UTF8String]);
        [[SDRequestHelp shareSDRequest] requestWihtFuncName:@"payTool/getPayToolsForPay/v1" errorBlock:^(SDRequestErrorType type) {
            error = YES;
        } successBlock:^{
            [[SDRequestHelp shareSDRequest] dispatchToMainQueue:^{
                [self.HUD hidden];
                
                NSString *payTools = [NSString stringWithUTF8String:paynuc.get("payTools").c_str()];
                payToolsArray = [[PayNucHelper sharedInstance] jsonStringToArray:payTools];
                NSString *order = [NSString stringWithUTF8String:paynuc.get("order").c_str()];
                orderDic = [[PayNucHelper sharedInstance] jsonStringToDictionary:order];
                //排序
                payToolsArray = [Tool orderForPayTools:payToolsArray];
                
                //支付控件设置列表
                [self.payView setPayTools:payToolsArray];
                //支付控件设置信息
                [self.payView setPayInfo:@[@"付款给扫码订单",moneyLab.text]];
                //支付控件弹出
                [self.payView showPayTool];
            }];
        }];
        if (error) return ;
    }];
}

//刷新订单页面信息
- (void)resetTnOrderInfo{
    
    //大标题
    titleLab.text = [NSString stringWithFormat:@"杉德宝-订单编号:%@",[orderDic objectForKey:@"orderId"]];
    //大金额
    moneyLab.text = [NSString stringWithFormat:@"¥%.2f",[[orderDic objectForKey:@"amount"] floatValue]/100];
    
    //订单时间
    orderTimeCell.rightStr = [NSDate formatTime:1 param:[orderDic objectForKey:@"time"]];
    //订单商户
    orderNameCell.rightStr = [orderDic objectForKey:@"digest"];
    
    NSString *type = [orderDic objectForKey:@"type"];
    NSInteger typeInt = [type integerValue];
    //订单号
    if (typeInt == 1) {
        orderNoCell.rightStr = [NSString stringWithFormat:@"消费-%@",[orderDic objectForKey:@"orderId"]];
    }
    if (typeInt == 2) {
        orderNoCell.rightStr = [NSString stringWithFormat:@"充值-%@",[orderDic objectForKey:@"orderId"]];
    }
    if (typeInt == 3) {
        orderNoCell.rightStr = [NSString stringWithFormat:@"转账-%@",[orderDic objectForKey:@"orderId"]];
    }
    if (typeInt == 4) {
        orderNoCell.rightStr = [NSString stringWithFormat:@"提现-%@",[orderDic objectForKey:@"orderId"]];
    }
    //订单支付方式
    orderPayWayCell.rightStr = [self.selectedPayDict objectForKey:@"title"];
}




#pragma mark 订单支付
- (void)pay:(NSString *)param orderPaySuccessBlock:(OrderInfoPayStateBlock)successBlock oederErrorBlock:(OrderInfoPayStateBlock)errorBlock
{
    self.HUD = [SDMBProgressView showSDMBProgressOnlyLoadingINViewImg:self.view];
    [self.HUD hidden];
    [SDRequestHelp shareSDRequest].HUD = self.HUD;
    [SDRequestHelp shareSDRequest].controller = self;
    [[SDRequestHelp shareSDRequest] dispatchGlobalQuque:^{
        __block BOOL error = NO;
        
        NSString *transAmt = [NSString stringWithFormat:@"%.0f", [[orderDic objectForKey:@"amount"] floatValue]];
        
        NSMutableDictionary *workDic = [[NSMutableDictionary alloc] init];
        [workDic setValue:@"tnPay" forKey:@"type"];
        [workDic setValue:[self.selectedPayDict objectForKey:@"orderId"] forKey:@"merOrderId"];
        [workDic setValue:_TN forKey:@"sandTN"];
        [workDic setValue:@"" forKey:@"thirdParty"];
        [workDic setValue:transAmt forKey:@"transAmt"];
        [workDic setValue:@"" forKey:@"remark"];
        [workDic setValue:@"out" forKey:@"feeType"];
        [workDic setValue:@"" forKey:@"fee"];
        [workDic setValue:@"" forKey:@"feeRate"];
        
        NSString *work = [[PayNucHelper sharedInstance] dictionaryToJson:workDic];
        [SDLog logDebug:work];
        
        NSArray *authToolsArray = [self.selectedPayDict objectForKey:@"authTools"];
        
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
        [self.selectedPayDict setObject:tempAuthToolsArray forKey:@"authTools"];
        
        NSString *payTool = [[PayNucHelper sharedInstance] dictionaryToJson:self.selectedPayDict];

        paynuc.set("work", [work UTF8String]);
        paynuc.set("payTool", [payTool UTF8String]);
        paynuc.set("authTools", [@"[]" UTF8String]);
        [[SDRequestHelp shareSDRequest] closedRespCpdeErrorAutomatic];
        [[SDRequestHelp shareSDRequest] requestWihtFuncName:@"business/pay/v1" errorBlock:^(SDRequestErrorType type) {
            error = YES;
            [[SDRequestHelp shareSDRequest] dispatchToMainQueue:^{
                [[SDRequestHelp shareSDRequest] openRespCpdeErrorAutomatic];
                if (type == frErrorType) {
                    errorBlock(nil);
                }
                if (type == respCodeErrorType) {
                    NSString *respMsg = [NSString stringWithUTF8String:paynuc.get("respMsg").c_str()];
                    errorBlock(@[respMsg]);
                }
            }];
        } successBlock:^{
            [[SDRequestHelp shareSDRequest] dispatchToMainQueue:^{
                [[SDRequestHelp shareSDRequest] openRespCpdeErrorAutomatic];
                [self.HUD hidden];
                NSString *work = [NSString stringWithUTF8String:paynuc.get("work").c_str()];
                successWorkDic = [[PayNucHelper sharedInstance] jsonStringToDictionary:work];
                successBlock(@[workDic,self.selectedPayDict]);
            }];
        }];
    }];
    
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

- (void)dealloc{
    //清除通知
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
