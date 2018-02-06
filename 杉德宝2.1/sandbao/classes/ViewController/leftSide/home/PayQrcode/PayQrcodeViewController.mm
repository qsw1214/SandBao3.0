//
//  PayQrcodeViewController.m
//  sandbao
//
//  Created by tianNanYiHao on 2017/12/5.
//  Copyright © 2017年 sand. All rights reserved.
//

#import "PayQrcodeViewController.h"
#import "PayNucHelper.h"

#import "SDSelectBarView.h"
#import "SDQrcodeView.h"
#import "RechargeFinishViewController.h"
#import "VerifyTypeViewController.h"


typedef void(^OrderInfoPayStateBlock)(NSArray *paramArr);
@interface PayQrcodeViewController ()<SDSelectBarDelegate,SDPayViewDelegate>
{
    NSArray *payToolsArray; //从tn获取的支付工具
    
    NSDictionary *orderDic; //订单信息
    
    NSDictionary *successWorkDic; //支付成功后返回的work
    
    //本类实例是否存在,界定推送结果后是否展示
    //(用于防止在其他页面弹出反扫的支付控件)
    BOOL isSelfSave;
    
}
@property (nonatomic, strong) NSMutableArray *authCodesArray; //授权码数组
@property (nonatomic, strong) NSMutableArray *no_authCodesArray;//废弃授权码数组
@property (nonatomic, strong) NSDictionary   *authCodeDic;    //授权码串字典
@property (nonatomic, strong) UIView *collectionQrcodeBaseView;//收款码基础视图
@property (nonatomic, strong) UIView *payQrcodeBaseView;//付款码基础视图

/**
 定时器
 */
@property (nonatomic, strong) NSTimer *timer;
/**
 TN
 */
@property (nonatomic, strong) NSString *TN;
/**
 所选的支付-支付工具
 */
@property (nonatomic, strong) NSMutableDictionary *selectedPayDict;

/**
 支付工具控件
 */
@property (nonatomic, strong) SDPayView *payView;

/**
 选择视图
 */
@property (nonatomic, strong) SDSelectBarView *selectBarView;

/**
 收款码视图
 */
@property (nonatomic, strong) SDQrcodeView *collectionQrcodeView;
/**
 付款码视图
 */
@property (nonatomic, strong) SDQrcodeView *payQrcodeView;
@end

@implementation PayQrcodeViewController

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    //回到页面
    isSelfSave = YES;
    if (self.payQrcodeView) {
        //- 开启定时器
        [self startTimer];
    }
}
- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    isSelfSave = NO;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
    [self creaetDefuleUI];
    [self createSelectBar];
    [self create_PayView];
    
    //默认展示付款码 - 请求付款码
    [self getAuthCodes];
    
    //增加B扫C,反扫结果监听
    [self addNotifactionBSC];
    
}
#pragma mark - 重写父类-baseScrollView设置
- (void)setBaseScrollview{
    [super setBaseScrollview];
    self.baseScrollView.backgroundColor = COLOR_F5F5F5;
}
#pragma mark - 重写父类-导航设置方法
- (void)setNavCoverView{
    [super setNavCoverView];
    self.navCoverView.style = NavCoverStyleWhite;
    self.navCoverView.letfImgStr = @"login_icon_back";
    self.navCoverView.rightImgStr = @"general_icon_more";
    self.navCoverView.midTitleStr = @"收付款";
    
    __weak PayQrcodeViewController *weakSelf = self;
    self.navCoverView.leftBlock = ^{
        
        //预防性删除定时器
        [weakSelf cleanTimer];
        [weakSelf.navigationController popViewControllerAnimated:YES];
    };
    self.navCoverView.rightBlock = ^{
        //刷新授权码
        [weakSelf readNewAuthCode];
    };
}
#pragma mark - 重写父类-点击方法集合
- (void)buttonClick:(UIButton *)btn{
    
    
    
}


#pragma mark  - UI绘制
//默认绘制收款码UI
- (void)creaetDefuleUI{
    
    //默认展示 付款码
    [self creaetPayQrView];

}

//创建切换条UI
- (void)createSelectBar{
    self.selectBarView = [[SDSelectBarView alloc] init];
    self.selectBarView.delegate = self;
    [self.baseScrollView addSubview:self.selectBarView];
    
    [self.selectBarView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.payQrcodeBaseView.mas_bottom).offset(UPDOWNSPACE_40);
        make.centerX.equalTo(self.payQrcodeBaseView.mas_centerX);
        make.size.mas_equalTo(self.selectBarView.size);
    }];
}
//初始化支付工具(sps)
- (void)create_PayView{
    self.payView = [SDPayView getPayView];
    self.payView.addCardType = SDPayView_ADDBANKCARD;
    self.payView.delegate = self;
    [[UIApplication sharedApplication].keyWindow addSubview:self.payView];
    
}

#pragma mark SDSelectBarViewDelegate
- (void)selectBarClick:(NSInteger)index{
    //点击 授权码按钮
    if (index == 1) {
        //定时器继续
        [self startTimer];
        
        if (self.authCodesArray.count == 0) {
            //点击获取授权码
            [self getAuthCodes];
        }else{
            //创建 付款码 视图 - (这里不隐藏而是重新创建是为了后期有可能UI做变化)
            [self creaetPayQrView];
        }
    }
    //点击收款码按钮
    if (index == 2) {
        //定时器暂停
        [self stopTimer];

        //创建 收款码 视图 - (这里不隐藏而是重新创建是为了后期有可能UI做变化)
        [self createCollectionQrView];
        
        [SDMBProgressView showSDMBProgressNormalINView:self.view lableText:@"努力开发中..."];
    }
}

//创建付款码UI
//创建好付款码视图,但授权码值不赋值 - 在定时器刷新时读取授权码
- (void)creaetPayQrView{
    
    //防止重复创建收款码/付款码UI
    if (self.collectionQrcodeBaseView || self.payQrcodeBaseView) {
        [self.payQrcodeBaseView removeFromSuperview];
        [self.collectionQrcodeBaseView removeFromSuperview];
    }
    
    self.payQrcodeBaseView = [[UIView alloc] init];
    self.payQrcodeBaseView.backgroundColor = [UIColor redColor];
    self.payQrcodeBaseView.backgroundColor = self.baseScrollView.backgroundColor;
    [self.baseScrollView addSubview:self.payQrcodeBaseView];
    
    self.payQrcodeView = [[SDQrcodeView alloc] initWithFrame:CGRectZero];
    self.payQrcodeView.style = PayQrcodeView;
    self.payQrcodeView.roundRLColor = self.baseScrollView.backgroundColor;
    self.payQrcodeView.oneQrCodeStr = nil;
    self.payQrcodeView.twoQrCodeStr = nil;
    [self.payQrcodeBaseView addSubview:self.payQrcodeView];
    
    //bottomTip
    UILabel *bottomTipLab = [Tool createLable:@"如付款失败,请尝试其他付款方式" attributeStr:nil font:FONT_12_Regular textColor:COLOR_343339 alignment:NSTextAlignmentCenter];
    [self.payQrcodeBaseView addSubview:bottomTipLab];
    
    
    CGFloat payQrcodeBaseViewH = self.payQrcodeView.height + UPDOWNSPACE_15;
    
    [self.payQrcodeBaseView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.baseScrollView.mas_top).offset(UPDOWNSPACE_40);
        make.centerX.equalTo(self.baseScrollView.mas_centerX);
        make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH, payQrcodeBaseViewH));
    }];
    
    [self.payQrcodeView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.payQrcodeBaseView);
        make.centerX.equalTo(self.payQrcodeBaseView.mas_centerX);
        make.size.mas_equalTo(self.payQrcodeView.size);
    }];
    
    [bottomTipLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.payQrcodeView.mas_bottom).offset(UPDOWNSPACE_15);
        make.centerX.equalTo(self.payQrcodeBaseView);
        make.size.mas_equalTo(bottomTipLab.size);
    }];
    
    
    //重置SelectBarView的约束
    [self.selectBarView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.payQrcodeBaseView.mas_bottom).offset(UPDOWNSPACE_40);
        make.centerX.equalTo(self.baseScrollView);
        make.size.mas_equalTo(self.selectBarView.size);
    }];
}

//创建收款码UI
- (void)createCollectionQrView{
    
    //防止重复创建收款码/付款码UI
    if (self.collectionQrcodeBaseView || self.payQrcodeBaseView) {
        [self.payQrcodeBaseView removeFromSuperview];
        [self.collectionQrcodeBaseView removeFromSuperview];
    }
    /*
    self.collectionQrcodeBaseView = [[UIView alloc] init];
    self.collectionQrcodeBaseView.backgroundColor = [UIColor greenColor];
    self.collectionQrcodeBaseView.backgroundColor = self.baseScrollView.backgroundColor;
    [self.baseScrollView addSubview:self.collectionQrcodeBaseView];
    
    self.collectionQrcodeView = [[SDQrcodeView alloc] initWithFrame:CGRectZero];
    self.collectionQrcodeView.style = CollectionQrcordView;
    self.collectionQrcodeView.roundRLColor = self.baseScrollView.backgroundColor;
    self.collectionQrcodeView.twoQrCodeStr = @"这里是二维码信息字符串";
    [self.collectionQrcodeBaseView addSubview:self.collectionQrcodeView];
    
    CGFloat collectionQrcodeBaseViewH = self.collectionQrcodeView.height;

    [self.collectionQrcodeBaseView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.baseScrollView.mas_top).offset(UPDOWNSPACE_40);
        make.centerX.equalTo(self.baseScrollView.mas_centerX);
        make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH, collectionQrcodeBaseViewH));
    }];
    
    [self.collectionQrcodeView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.collectionQrcodeBaseView);
        make.centerX.equalTo(self.collectionQrcodeBaseView.mas_centerX);
        make.size.mas_equalTo(self.collectionQrcodeView.size);
    }];
    

    //重置SelectBarView的约束
    [self.selectBarView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.collectionQrcodeBaseView.mas_bottom).offset(UPDOWNSPACE_40);
        make.centerX.equalTo(self.collectionQrcodeBaseView.mas_centerX);
        make.size.mas_equalTo(self.selectBarView.size);
    }];
    */
    
    //重置SelectBarView的约束 - 固定高于底部bottom50 (上面注释部分解开后, 此约束删除即可)
    [self.selectBarView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.baseScrollView.mas_top).offset(self.baseScrollView.height - self.selectBarView.height - UPDOWNSPACE_40);
        make.centerX.equalTo(self.baseScrollView);
        make.size.mas_equalTo(self.selectBarView.size);
    }];
}

//注册MQTT推送的反扫启动SPS通知
#pragma mark 注册通知 - MQTT推送反扫TN
- (void)addNotifactionBSC{
    //注册有密反扫通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showPayToolViewPwd:) name:MQTT_NOTICE_BSC_TN_PWD object:nil];
    //注册无密反扫通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showPayToolView:) name:MQTT_NOTICE_BSC_TN object:nil];
}
//从通知获取MQTT推送的TN号,走支付流程
- (void)showPayToolViewPwd:(NSNotification*)noti{
    if (isSelfSave) {
        //拿到通知后,立即暂停刷新
        [self stopTimer];
        
        //拿到通知后,关闭放大的图片
        [self.payQrcodeView hiddenBigQrcodeView];
        
        //获取TN号
        self.TN = (NSString*)noti.object;
        //同正扫流程
        [self TNOrder:self.TN];
    }
    
}
//从通知获取MQTT推送的TN号,走无密通知
- (void)showPayToolView:(NSNotification*)noti{
    
    if (isSelfSave) {
        //拿到通知后,立即暂停刷新
        [self stopTimer];
        
        //拿到通知后,关闭放大的图片
        [self.payQrcodeView hiddenBigQrcodeView];
        
        NSString *str = (NSString*)noti.object;
        NSArray *strArr = [str componentsSeparatedByString:@"+"];
        NSString *respMsg = [strArr firstObject];
        NSString *msg = [strArr lastObject];
        
        [Tool showDialog:msg message:respMsg defulBlock:^{
            
            //更新金额
            [self ownPayTools];
            
            //无密 - 付款成功!
            //        RechargeFinishViewController *rechargeFinishVC = [[RechargeFinishViewController alloc] init];
            //        rechargeFinishVC.transTypeName = @"支付成功";
            //        rechargeFinishVC.amtMoneyStr = [NSString stringWithFormat:@"%.2f",[[successWorkDic objectForKey:@"transAmt"] floatValue]/100];
            //        rechargeFinishVC.payOutName = [self.selectedPayDict objectForKey:@"title"];
            //        rechargeFinishVC.payOutNo = [[self.selectedPayDict objectForKey:@"account"] objectForKey:@"accNo"];
            //        [self.navigationController pushViewController:rechargeFinishVC animated:YES];
        }];
    }
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
        //支付失败 - 动画停止
        [successView animationStopClean];
        //支付失败 - 复位到支付订单
        [self.payView payPwdResetToPayOrderView];
        
        if (paramArr.count>0) {
            [Tool showDialog:paramArr[0]];
        }else{
            [Tool showDialog:@"网络连接异常"];
        }
    }];
}

- (void)payViewClickCloseBtn{
    //支付控件触发关闭
    //定时器开启
    [self startTimer];
    
}

- (void)payViewForgetPwd:(NSString *)type{
    //定时器已在支付控件弹出时 - 暂停
    if ([type isEqualToString:PAYTOOL_PAYPASS]) {
        //@"修改支付密码"
        VerifyTypeViewController *verifyTypeVC = [[VerifyTypeViewController alloc] init];
        verifyTypeVC.tokenType = @"01000601";
        verifyTypeVC.verifyType = VERIFY_TYPE_CHANGEPATPWD;
        verifyTypeVC.phoneNoStr = [CommParameter sharedInstance].phoneNo;
        [self.navigationController pushViewController:verifyTypeVC animated:YES];
    }
    
}

- (void)payViewAddPayToolCard:(NSString *)type{
    
    if ([type isEqualToString:PAYTOOL_PAYPASS]) {
        [self.payView hidPayToolInPayListView];
        [self.sideMenuViewController setContentViewController:[CommParameter sharedInstance].bankCardNav];
    }
    if ([type isEqualToString:PAYTOOL_ACCPASS]) {
        
    }
}
- (void)payViewPayToolsError:(NSString *)errorInfo{
    [Tool showDialog:errorInfo defulBlock:^{
        
        //复位支付工具且删除
        [self.payView resetPayToolHidden];
        
        //定时器继续
        [self startTimer];
    }];
}



#pragma mark - 业务逻辑
#pragma mark 获取授权码组
- (void)getAuthCodes
{
    self.HUD = [SDMBProgressView showSDMBProgressOnlyLoadingINViewImg:self.view];
    [SDRequestHelp shareSDRequest].HUD = self.HUD;
    [SDRequestHelp shareSDRequest].controller = self;
    [[SDRequestHelp shareSDRequest] dispatchGlobalQuque:^{
        __block BOOL error = NO;
        paynuc.set("tTokenType", "04000301");
        [[SDRequestHelp shareSDRequest] closedRespCpdeErrorAutomatic];
        [[SDRequestHelp shareSDRequest] requestWihtFuncName:@"token/getTtoken/v1" errorBlock:^(SDRequestErrorType type) {
            error = YES;
            [[SDRequestHelp shareSDRequest] dispatchToMainQueue:^{
                [[SDRequestHelp shareSDRequest] openRespCpdeErrorAutomatic];
                if (type == frErrorType) {
                    [Tool showDialog:@"啊哦" message:@"获取授权码失败" sureTitle:@"我知道了" defualtBlcok:^{
                        [self.navigationController popViewControllerAnimated:YES];
                    }];
                }
                if (type == respCodeErrorType) {
                    [Tool showDialog:@"啊哦" message:@"获取授权码失败" sureTitle:@"我知道了" defualtBlcok:^{
                        [self.navigationController popViewControllerAnimated:YES];
                    }];
                }
            }];
        } successBlock:^{
            [[SDRequestHelp shareSDRequest] dispatchToMainQueue:^{
                [[SDRequestHelp shareSDRequest] openRespCpdeErrorAutomatic];
            }];
        }];
        if (error) return ;
        
        
        [[SDRequestHelp shareSDRequest] closedRespCpdeErrorAutomatic];
        [[SDRequestHelp shareSDRequest] requestWihtFuncName:@"user/getAuthCodes/v1" errorBlock:^(SDRequestErrorType type) {
            error = YES;
            [[SDRequestHelp shareSDRequest] dispatchToMainQueue:^{
                [[SDRequestHelp shareSDRequest] openRespCpdeErrorAutomatic];
                if (type == frErrorType) {
                    [Tool showDialog:@"啊哦" message:@"获取授权码失败" sureTitle:@"我知道了" defualtBlcok:^{
                        [self.navigationController popViewControllerAnimated:YES];
                    }];
                }
                if (type == respCodeErrorType) {
                    [Tool showDialog:@"啊哦" message:@"获取授权码失败" sureTitle:@"我知道了" defualtBlcok:^{
                        [self.navigationController popViewControllerAnimated:YES];
                    }];
                }
            }];
        } successBlock:^{
            [[SDRequestHelp shareSDRequest] openRespCpdeErrorAutomatic];
            [[SDRequestHelp shareSDRequest] dispatchToMainQueue:^{
                [self.HUD hidden];
                
                NSString *authCodes = [NSString stringWithUTF8String:paynuc.get("authCodes").c_str()];
                NSArray *tempArray = [[PayNucHelper sharedInstance] jsonStringToArray:authCodes];
                //授权码获取
                self.authCodesArray = [NSMutableArray arrayWithCapacity:0];
                self.no_authCodesArray = [NSMutableArray arrayWithCapacity:0];
                for (int i = 0; i < tempArray.count; i++) {
                    [self.authCodesArray addObject:tempArray[i]];
                }
                //定时刷新 授权码
                [self refreshAuthCode];
            }];
        }];
        if (error) return ;
    }];
}

#pragma mark 作废授权码
- (void)reportAuthCode:(NSString*)authCode{
    
    //作废授权码,不需要关心其结果,只做上送
    [[SDRequestHelp shareSDRequest] dispatchGlobalQuque:^{
        NSDictionary *authCodeDic = @{@"code":authCode};
        NSString *authCodeStr = [[PayNucHelper sharedInstance] dictionaryToJson:(NSMutableDictionary*)authCodeDic];
        paynuc.set("authCode", [authCodeStr UTF8String]);
        paynuc.func("user/reportAuthCode/v1");
    }];
}

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
            [[SDRequestHelp shareSDRequest] dispatchToMainQueue:^{
               //获取支付工具失败,恢复定时器刷新
                [self startTimer];
            }];
        } successBlock:^{
            
        }];
        if (error) return ;
        
        
        NSMutableDictionary *workDic = [[NSMutableDictionary alloc] init];
        [workDic setValue:@"tnPay" forKey:@"type"];
        [workDic setValue:TN forKey:@"sandTN"];
        NSString *work = [[PayNucHelper sharedInstance] dictionaryToJson:workDic];
        
        paynuc.set("work", [work UTF8String]);
        [[SDRequestHelp shareSDRequest] requestWihtFuncName:@"payTool/getPayToolsForPay/v1" errorBlock:^(SDRequestErrorType type) {
            error = YES;
            [[SDRequestHelp shareSDRequest] dispatchToMainQueue:^{
                [self startTimer];
            }];
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
                [self.payView setPayInfo:@[@"付款给商户",[NSString stringWithFormat:@"%.2f",[[orderDic objectForKey:@"amount"] floatValue]/100]]];
                //支付控件弹出
                [self.payView showPayTool];
            }];
        }];
        if (error) return ;
    }];
}

//刷新订单页面信息
- (void)resetTnOrderInfo{
    //由于是反扫,故不需要在页面上展示订单信息
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
        [workDic setValue:self.TN forKey:@"sandTN"];
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
#pragma mark 定时刷新授权码
- (void)refreshAuthCode{
    
    //由于定时器间隔x秒后执行readNewAuthCode  获取的第一个授权码需手动执行
    [self readNewAuthCode];
    
    //定时一分钟刷新授权码
    self.timer = [NSTimer timerWithTimeInterval:60.f target:self selector:@selector(readNewAuthCode) userInfo:nil repeats:YES];
    [[NSRunLoop currentRunLoop] addTimer:self.timer forMode:NSRunLoopCommonModes];
    
}
//每隔一分钟读取新授权码
- (void)readNewAuthCode{
    NSLog(@"************************* 我被调用 ***************************");
    
    //定时器只要重新启动 - 必然会执行 readNewAuthCode() 该方法一次 :需注意
    
    if (self.no_authCodesArray.count>0 && self.authCodeDic) {
        //存储旧授权码
        [self.no_authCodesArray addObject:self.authCodeDic];
        //作废旧授权码
        [self reportAuthCode:[self.authCodeDic objectForKey:@"code"]];
    }
    
    if (self.no_authCodesArray.count == 0 && self.authCodeDic) {
        //第一个授权码存储
        [self.no_authCodesArray addObject:self.authCodeDic];
        //第一个授权码作废
        [self reportAuthCode:[self.authCodeDic objectForKey:@"code"]];
    }
    
    //当有授权码余量
    if (self.authCodesArray.count>0) {
        //永远取余量授权码组第一个
        self.authCodeDic = [self.authCodesArray firstObject];
        //取一个授权码展示,从数组里删除该使用中的授权码
        [self.authCodesArray removeObject:self.authCodeDic];
        
        //设置条形码/二维码
        NSString *qrCodeStr = [self.authCodeDic objectForKey:@"code"];
        if (qrCodeStr&&qrCodeStr.length>0) {
            self.payQrcodeView.oneQrCodeStr = qrCodeStr;
            self.payQrcodeView.twoQrCodeStr = qrCodeStr;
        }
    }else{
        //timer清除
        [self cleanTimer];
        //如果余量不足,则重新申请新授权码下发
        [self getAuthCodes];
    }
}

#pragma mark 查询我方支付工具鉴权工具
/**
 *@brief 查询我方支付工具
 */
- (void)ownPayTools
{
    self.HUD = [SDMBProgressView showSDMBProgressOnlyLoadingINViewImg:self.view];
    [SDRequestHelp shareSDRequest].HUD = self.HUD;
    [SDRequestHelp shareSDRequest].controller = self;
    [[SDRequestHelp shareSDRequest] dispatchGlobalQuque:^{
        __block BOOL error = NO;
        paynuc.set("tTokenType", "01001501");
        paynuc.set("cfg_termFp", [[Tool setCfgTempFpStaticDataFlag:NO DynamicDataFlag:YES] UTF8String]);
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
                [self.HUD hidden];
                
                NSArray *payToolsArray = [[PayNucHelper sharedInstance] jsonStringToArray:[NSString stringWithUTF8String:paynuc.get("payTools").c_str()]];
                //支付工具排序
                payToolsArray = [Tool orderForPayTools:payToolsArray];
                [CommParameter sharedInstance].ownPayToolsArray = payToolsArray;
                [self.navigationController popToRootViewControllerAnimated:YES];
                
            }];
        }];
        if (error) return ;
    }];
}

//继续定时器
- (void)startTimer{
    if (self.timer) {
        [self.timer setFireDate:[NSDate distantPast]];
    }
}

//暂停定时器
- (void)stopTimer{
    if (self.timer) {
        [self.timer setFireDate:[NSDate distantFuture]];
    }
}

//清除定时器
- (void)cleanTimer{
    if (self.timer) {
        [self.timer invalidate];
        self.timer = nil;
    }
}

- (void)dealloc{
    //删除通知
    [[NSNotificationCenter defaultCenter] removeObserver:self name:MQTT_NOTICE_BSC_TN_PWD object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:MQTT_NOTICE_BSC_TN object:nil];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    //预防性删除定时器
    [self cleanTimer];
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
