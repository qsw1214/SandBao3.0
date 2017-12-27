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


typedef void(^OrderInfoPayStateBlock)(NSArray *paramArr);
@interface PayQrcodeViewController ()<SDSelectBarDelegate,SDPayViewDelegate>
{
    NSArray *payToolsArray; //从tn获取的支付工具
    
    NSDictionary *orderDic; //订单信息
    
    NSString *amountStr; //订单金额(分)
    
    NSDictionary *successWorkDic; //支付成功后返回的work
    
}
@property (nonatomic, strong) NSMutableArray *authCodesArray; //授权码数组
@property (nonatomic, strong) UIView *collectionQrcodeBaseView;//收款码基础视图
@property (nonatomic, strong) UIView *payQrcodeBaseView;//付款码基础视图
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

}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self creaetDefuleUI];
    [self createSelectBar];
    [self create_PayView];
    
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
    self.navCoverView.midTitleStr = @"收付款";
    
    __weak PayQrcodeViewController *weakSelf = self;
    self.navCoverView.leftBlock = ^{
        [weakSelf.navigationController popViewControllerAnimated:YES];
    };
    
}
#pragma mark - 重写父类-点击方法集合
- (void)buttonClick:(UIButton *)btn{
    
    
}


#pragma mark  - UI绘制
//默认绘制收款码UI
- (void)creaetDefuleUI{
    
    //默认展示 收款码
    self.collectionQrcodeBaseView = [[UIView alloc] init];
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
}

//创建切换条UI
- (void)createSelectBar{
    self.selectBarView = [[SDSelectBarView alloc] init];
    self.selectBarView.delegate = self;
    [self.baseScrollView addSubview:self.selectBarView];
    
    [self.selectBarView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.collectionQrcodeBaseView.mas_bottom).offset(UPDOWNSPACE_40);
        make.centerX.equalTo(self.collectionQrcodeBaseView.mas_centerX);
        make.size.mas_equalTo(self.selectBarView.size);
    }];
}
//创建收款码UI
- (void)createCollectionQrView{
    
    self.collectionQrcodeBaseView = [[UIView alloc] init];
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
}
//创建付款码UI
- (void)creaetPayQrView{
    
    NSDictionary *authCodeDic = [self.authCodesArray firstObject];
    NSString *authCode = [authCodeDic objectForKey:@"code"];
    
    self.payQrcodeBaseView = [[UIView alloc] init];
    self.payQrcodeBaseView.backgroundColor = self.baseScrollView.backgroundColor;
    [self.baseScrollView addSubview:self.payQrcodeBaseView];
    
    self.payQrcodeView = [[SDQrcodeView alloc] initWithFrame:CGRectZero];
    self.payQrcodeView.style = PayQrcodeView;
    self.payQrcodeView.roundRLColor = self.baseScrollView.backgroundColor;
    self.payQrcodeView.oneQrCodeStr = authCode;
    self.payQrcodeView.twoQrCodeStr = authCode;
    self.payQrcodeView.payToolNameStr = @"杉德卡";
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
//初始化支付工具(sps)
- (void)create_PayView{
    self.payView = [SDPayView getPayView];
    self.payView.addCardType = SDPayView_ADDBANKCARD;
    self.payView.delegate = self;
    [[UIApplication sharedApplication].keyWindow addSubview:self.payView];
    
}
//注册MQTT推送的反扫启动SPS通知
#pragma mark 注册通知 - MQTT推送反扫TN
- (void)addNotifactionBSC{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showPayToolView:) name:MQTT_NOTICE_BSC_TN object:nil];
}
//从通知获取MQTT推送的TN号,走支付流程
- (void)showPayToolView:(NSNotification*)noti{
    //获取TN号
    self.TN = (NSString*)noti.object;
    //同正扫流程
    [self TNOrder:self.TN];
    
}

#pragma mark SDSelectBarViewDelegate
- (void)selectBarClick:(NSInteger)index{
    if (index == 1) {
        if (self.payQrcodeBaseView) {
            [UIView animateWithDuration:0.2 animations:^{
                self.payQrcodeBaseView.alpha = 0;
                self.selectBarView.alpha = 0;
            } completion:^(BOOL finished) {
                [self.payQrcodeBaseView removeFromSuperview];
                
                //创建 收款码 视图
                [self createCollectionQrView];
                //创建 付款码 视图成功  选择按钮Bar恢复显示
                self.selectBarView.alpha = 1;
            }];
        }
    }
    if (index == 2) {
        if (self.collectionQrcodeBaseView) {
            [UIView animateWithDuration:0.2 animations:^{
                self.selectBarView.alpha = 0;
                self.collectionQrcodeBaseView.alpha = 0;
            } completion:^(BOOL finished) {
                [self.collectionQrcodeBaseView removeFromSuperview];

                if (self.authCodesArray.count == 0) {
                    //点击获取授权码
                    [self getAuthCodes];
                }else{
                    //创建 付款码 视图
                    [self creaetPayQrView];
                    //创建 付款码 视图成功  选择按钮Bar恢复显示
                    self.selectBarView.alpha = 1;
                }
            }];
        }
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
        //支付失败 - 支付控件归位
        [self.payView originPayTool];
        
        if (paramArr.count>0) {
            [Tool showDialog:paramArr[0]];
        }else{
            [Tool showDialog:@"网络连接异常"];
        }
    }];
}

- (void)payViewForgetPwd:(NSString *)type{
    
    if ([type isEqualToString:PAYTOOL_PAYPASS]) {
        
    }
    
}

- (void)payViewAddPayToolCard:(NSString *)type{
    
    if ([type isEqualToString:PAYTOOL_PAYPASS]) {
        
    }
    if ([type isEqualToString:PAYTOOL_ACCPASS]) {
        
    }
}
- (void)payViewPayToolsError:(NSString *)errorInfo{
    [Tool showDialog:errorInfo defulBlock:^{
        
        
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
        [[SDRequestHelp shareSDRequest] requestWihtFuncName:@"token/getTtoken/v1" errorBlock:^(SDRequestErrorType type) {
            error = YES;
        } successBlock:^{
            
        }];
        if (error) return ;
        
        [[SDRequestHelp shareSDRequest] requestWihtFuncName:@"user/getAuthCodes/v1" errorBlock:^(SDRequestErrorType type) {
            error = YES;
        } successBlock:^{
            [[SDRequestHelp shareSDRequest] dispatchToMainQueue:^{
                [self.HUD hidden];
                
                NSString *authCodes = [NSString stringWithUTF8String:paynuc.get("authCodes").c_str()];
                NSArray *tempArray = [[PayNucHelper sharedInstance] jsonStringToArray:authCodes];
                //授权码获取
                self.authCodesArray = [NSMutableArray arrayWithCapacity:0];
                for (int i = 0; i < tempArray.count; i++) {
                    [self.authCodesArray addObject:tempArray[i]];
                }
                //创建 付款码 视图
                [self creaetPayQrView];
                //创建 付款码 视图成功 - 按钮选中Bar恢复显示
                self.selectBarView.alpha = 1;
                
            }];
        }];
        
        if (error) return ;
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
        } successBlock:^{
            [[SDRequestHelp shareSDRequest] dispatchToMainQueue:^{
                [self.HUD hidden];
                
                NSString *payTools = [NSString stringWithUTF8String:paynuc.get("payTools").c_str()];
                payToolsArray = [[PayNucHelper sharedInstance] jsonStringToArray:payTools];
                NSString *order = [NSString stringWithUTF8String:paynuc.get("order").c_str()];
                orderDic = [[PayNucHelper sharedInstance] jsonStringToDictionary:order];
                amountStr = [orderDic objectForKey:@"amount"];
                
                //排序
                payToolsArray = [Tool orderForPayTools:payToolsArray];
                
                
                //支付控件设置列表
                [self.payView setPayTools:payToolsArray];
                //支付控件设置信息
                [self.payView setPayInfo:@[@"付款给商户",[NSString stringWithFormat:@"%.2f",[amountStr floatValue]/100]]];
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

- (void)dealloc{
    //删除通知
    [[NSNotificationCenter defaultCenter] removeObserver:self name:MQTT_NOTICE_BSC_TN object:nil];
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
