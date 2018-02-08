//
//  SpsLunchViewController.m
//  sandbao
//
//  Created by tianNanYiHao on 2017/12/13.
//  Copyright © 2017年 sand. All rights reserved.
//

#import "SpsLunchViewController.h"
#import "PayNucHelper.h"
#import "SpsLoadingView.h"
#import "TnOrderViewController.h"
#import "RealNameViewController.h"
#import "VerifyTypeViewController.h"
#import "AddBankCardViewController.h"
//sps支付状态枚举
typedef NS_ENUM(NSInteger,SPS_PAY_STATE){
    SPS_PAY_SUCCESS = 1,
    SPS_PAY_CANCLE,
    SPS_PAY_ERROR
};


typedef void(^SpsLunchPayBlock)(NSArray *paramArr);
@interface SpsLunchViewController ()<SDPayViewDelegate>
{
    
    UIView *headView;
    NSArray *payToolsArray; //从tn获取的支付工具
    NSDictionary *successWorkDic; //支付成功后返回的work
    
    NSDecimalNumber *limitDec;
    NSDictionary *orderDic; //订单信息
    // 跳转忘记密码的标识
    BOOL forgetPwdPush;
}
/**
 支付工具控件
 */
@property (nonatomic, strong) SDPayView *payView;

/**
 所选的支付-支付工具
 */
@property (nonatomic, strong) NSMutableDictionary *selectedPayDict;

/**
 loading加载动画
 */
@property (nonatomic, strong) SpsLoadingView *spsLoadingView;

@end

@implementation SpsLunchViewController

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
     //实名/设置支付密码后,需返回到SPSLunch页(即本类,但此时 URLSchemes值已经被 setController方法清空,等设置支付密码完成后,不能重新进入SpsLunch,因此,在跳转设置支付密码时,要把 urlSchemes字符串重新赋值,)
    
    //检测是否实名/设置支付密码
    [self checkRealNameOrSetPayPwd];
    

    
    
}
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    
    //除 跳转忘记密码页面外, 其他情况均删除支付工具
    if (forgetPwdPush) {
        forgetPwdPush = NO;
    }else{
        //只要消失,删除sps
        //清除payView
        if (self.payView) {
            [self.payView hidePayTool];
        }
        forgetPwdPush = NO;
    }
    
    
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self createUI];
    [self create_PayView];
    
}
#pragma mark - 重写父类-baseScrollView设置
- (void)setBaseScrollview{
    [super setBaseScrollview];
    self.baseScrollView.frame = [UIScreen mainScreen].bounds;
    self.baseScrollView.backgroundColor = COLOR_232B3F;
}
#pragma mark - 重写父类-导航设置方法
- (void)setNavCoverView{
    [super setNavCoverView];
    self.navCoverView.style = NavCoverStyleGradient;
    self.navCoverView.hidden = YES;
}

#pragma mark - 重写父类-点击方法集合
- (void)buttonClick:(UIButton *)btn{
    
    
}

#pragma mark  - UI绘制
- (void)createUI{
    
    //创建背景
    UIImageView *backGroundImgView = [Tool createImagView:[UIImage imageNamed:@"loading_bg"]];
    [self.baseScrollView addSubview:backGroundImgView];
    
    [backGroundImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.baseScrollView);
        make.centerX.equalTo(self.baseScrollView);
        make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH, SCREEN_HEIGHT));
    }];
    
    //loadingIcon
    UIImage *loadIcon = [UIImage imageNamed:@"icon_loading"];
    self.spsLoadingView = [[SpsLoadingView alloc] initWithFrame:CGRectMake(0, 0, loadIcon.size.height, loadIcon.size.height)];
    self.spsLoadingView.iconImgStr = @"icon_loading";
    [self.baseScrollView addSubview:self.spsLoadingView];
    [self.spsLoadingView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.baseScrollView.mas_centerX);
        make.top.equalTo(self.baseScrollView.mas_top).offset(UPDOWNSPACE_64 + UPDOWNSPACE_40);
        make.size.mas_equalTo(self.spsLoadingView.size);
    }];
    
    
    
    headView = [[UIView alloc] init];
    headView.alpha = 0.f;
    [self.baseScrollView addSubview:headView];
    
    UIImageView *headImgView = [Tool createImagView:nil];
    headImgView.size = CGSizeMake(LEFTRIGHTSPACE_80, LEFTRIGHTSPACE_80);
    
    headImgView.layer.borderColor = [UIColor whiteColor].CGColor;
    headImgView.layer.borderWidth = 2.f;
    headImgView.image = [Tool avatarImageWith:[CommParameter sharedInstance].avatar];
    headImgView.layer.cornerRadius = headImgView.width/2;
    headImgView.layer.masksToBounds = YES;
    [headView addSubview:headImgView];
    
    UILabel *phoneNumLab = [Tool createLable:[CommParameter sharedInstance].userName attributeStr:nil font:FONT_15_Medium textColor:COLOR_F5F5F5 alignment:NSTextAlignmentCenter];
    [headView addSubview:phoneNumLab];
    headView.size = CGSizeMake(phoneNumLab.width, phoneNumLab.height+headImgView.height);
    headView.frame = CGRectMake((SCREEN_WIDTH - headView.width)/2, SCREEN_HEIGHT/2, headView.width, headView.height);
    
    [headImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(headView.mas_top);
        make.centerX.equalTo(headView.mas_centerX);
        make.size.mas_equalTo(headImgView.size);
    }];
    
    [phoneNumLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(headImgView.mas_bottom);
        make.centerX.equalTo(headView.mas_centerX);
        make.size.mas_equalTo(phoneNumLab.size);
    }];
    
}
- (void)create_PayView{
    
    //删除重复的sps
    if (self.payView) {
        [self.payView removeFromSuperview];
    }
    
    self.payView = [SDPayView getPayView];
    self.payView.addCardType = SDPayView_ADDBANKCARD;
    self.payView.delegate = self;
    [[UIApplication sharedApplication].keyWindow addSubview:self.payView];
}

#pragma mark - SDPayViewDelegate
- (void)payViewReturnDefulePayToolDic:(NSMutableDictionary *)defulePayToolDic{
    //设置默认支付工具
    self.selectedPayDict = defulePayToolDic;
    //刷新页面信息
    [self resetTnOrderInfo];
    
}

- (void)payViewSelectPayToolDic:(NSMutableDictionary *)selectPayToolDict{
    //设置当前所选支付工具
    self.selectedPayDict = selectPayToolDict;
    //刷新页面信息
    [self resetTnOrderInfo];
}
//点击关闭sps的回调
- (void)payViewClickCloseBtn{
    [self payGoBackByisSuccess:SPS_PAY_CANCLE];
}
- (void)payViewPwd:(NSString *)pwdStr paySuccessView:(SDPaySuccessAnimationView *)successView{
    
    //支付动画开始
    [successView animationStart];
    
    [self pay:pwdStr orderPaySuccessBlock:^(NSArray *paramArr){
        //支付成功
        [successView animationSuccess];
        dispatch_time_t delayTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5f * NSEC_PER_SEC));
        dispatch_after(delayTime, dispatch_get_main_queue(), ^{
            //支付成功 - 刷新支付工具(无论刷新成功失败-给第三方App均返回支付成功)
            [self ownPayTools];
        });
    } oederErrorBlock:^(NSArray *paramArr){
        //支付失败- 动画停止
        [successView animationStopClean];
        //支付失败 - 复位到支付订单
        [self.payView payPwdResetToPayOrderView];
        
        if (paramArr.count>0) {
            //spsLunch页特例:交易异常后,仅提示用户,且返回sps订单金额页,不进行退出操作,退出由用户触发
            [Tool showDialog:paramArr[0]];
        }else{
            [Tool showDialog:@"网络连接异常" message:@"返回商户" defulBlock:^{
                [self payGoBackByisSuccess:SPS_PAY_ERROR];
            }];
        }
    }];
}

- (void)payViewForgetPwd:(NSString *)type{
    
    if ([type isEqualToString:PAYTOOL_PAYPASS]) {
        
        //点击忘记密码push离开Spslunch页面后,不删除payView
        forgetPwdPush = YES;
        
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
            [Tool showDialog:@"已绑定3张银行卡,不可继续绑卡"];
        }else{
            AddBankCardViewController *addBankCardVC = [[AddBankCardViewController alloc] init];
            [self.navigationController pushViewController:addBankCardVC animated:YES];
        }
    }
    if ([type isEqualToString:PAYTOOL_ACCPASS]) {
        
    }
}
- (void)payViewPayToolsError:(NSString *)errorInfo{
    [Tool showDialog:errorInfo message:@"返回商户" defulBlock:^{
        [self payGoBackByisSuccess:SPS_PAY_ERROR];
    }];
}

#pragma mark - 业务逻辑
#pragma mark 获取支付工具
- (void)TNOrder:(NSString*)TN
{
    [self.spsLoadingView startCircleAnimation];
    self.HUD = [SDMBProgressView showSDMBProgressOnlyLoadingINViewImg:self.view];
    self.HUD.hidden = YES;
//    [SDRequestHelp shareSDRequest].HUD = self.HUD;
    [SDRequestHelp shareSDRequest].controller = self;
    [[SDRequestHelp shareSDRequest] dispatchGlobalQuque:^{
        __block BOOL error = NO;
        
        paynuc.set("tTokenType", "04000101");
        [[SDRequestHelp shareSDRequest] closedRespCpdeErrorAutomatic];
        [[SDRequestHelp shareSDRequest] requestWihtFuncName:@"token/getTtoken/v1" errorBlock:^(SDRequestErrorType type) {
            error = YES;
            [[SDRequestHelp shareSDRequest] dispatchToMainQueue:^{
                [[SDRequestHelp shareSDRequest] openRespCpdeErrorAutomatic];
                if (type == frErrorType) {
                    [Tool showDialog:@"网络出现异常" message:@"返回商户" defulBlock:^{
                        [self payGoBackByisSuccess:SPS_PAY_ERROR];
                    }];
                }
                if (type == respCodeErrorType) {
                    NSString *respMsg = [NSString stringWithUTF8String:paynuc.get("respMsg").c_str()];
                    [Tool showDialog:respMsg message:@"返回商户" defulBlock:^{
                        [self payGoBackByisSuccess:SPS_PAY_ERROR];
                    }];
                }
            }];
        } successBlock:^{
            [[SDRequestHelp shareSDRequest] dispatchToMainQueue:^{
                [[SDRequestHelp shareSDRequest] openRespCpdeErrorAutomatic];
            }];
        }];
        if (error) return ;
        
        
        NSMutableDictionary *workDic = [[NSMutableDictionary alloc] init];
        [workDic setValue:@"tnPay" forKey:@"type"];
        [workDic setValue:self.TN forKey:@"sandTN"];
        NSString *work = [[PayNucHelper sharedInstance] dictionaryToJson:workDic];
        
        paynuc.set("work", [work UTF8String]);
         [[SDRequestHelp shareSDRequest] closedRespCpdeErrorAutomatic];
        [[SDRequestHelp shareSDRequest] requestWihtFuncName:@"payTool/getPayToolsForPay/v1" errorBlock:^(SDRequestErrorType type) {
            error = YES;
            [[SDRequestHelp shareSDRequest] dispatchToMainQueue:^{
                [[SDRequestHelp shareSDRequest] openRespCpdeErrorAutomatic];
                if (type == frErrorType) {
                    [Tool showDialog:@"网络出现异常" message:@"返回商户" defulBlock:^{
                        [self payGoBackByisSuccess:SPS_PAY_ERROR];
                    }];
                }
                if (type == respCodeErrorType) {
                    NSString *respMsg = [NSString stringWithUTF8String:paynuc.get("respMsg").c_str()];
                    [Tool showDialog:respMsg message:@"返回商户" defulBlock:^{
                        [self payGoBackByisSuccess:SPS_PAY_ERROR];
                    }];
                }
            }];
        } successBlock:^{
            [[SDRequestHelp shareSDRequest] dispatchToMainQueue:^{
                [[SDRequestHelp shareSDRequest] openRespCpdeErrorAutomatic];
                [self.HUD hidden];
                [self.spsLoadingView stopCircleAnimation];
                [self headViewAnimation];
                
                NSString *payTools = [NSString stringWithUTF8String:paynuc.get("payTools").c_str()];
                payToolsArray = [[PayNucHelper sharedInstance] jsonStringToArray:payTools];
                NSString *order = [NSString stringWithUTF8String:paynuc.get("order").c_str()];
                orderDic = [[PayNucHelper sharedInstance] jsonStringToDictionary:order];
                //0.排序
                payToolsArray = [Tool orderForPayTools:payToolsArray];
                
                //支付控件设置列表
                [self.payView setPayTools:payToolsArray];
                //支付控件设置信息
                [self.payView setPayInfo:@[@"付款给商户",[NSString stringWithFormat:@"¥%.2f",[[orderDic objectForKey:@"amount"] floatValue]/100]]];
                //支付控件弹出
                [self.payView showPayTool];
            }];
        }];
        if (error) return ;
    }];
}

//刷新订单页面信息
- (void)resetTnOrderInfo{
    //SPS跳转支付,暂不需要刷新相关显示UI
}

#pragma mark 订单支付
- (void)pay:(NSString *)param orderPaySuccessBlock:(SpsLunchPayBlock)successBlock oederErrorBlock:(SpsLunchPayBlock)errorBlock
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
#pragma mark 检测是否实名或设置支付密码
- (void)checkRealNameOrSetPayPwd{
    
    //在已登陆情况下,检测用户是否实名/是否设置支付密码
    if ([CommParameter sharedInstance].userInfo.length>0)
    {
        //若检测未实名,进行实名
        if (![CommParameter sharedInstance].realNameFlag) {
            [Tool showDialog:@"请进行认证" message:@"检测到您还未实名认证" leftBtnString:@"去实名" rightBtnString:@"退出支付" leftBlock:^{
                RealNameViewController *realName = [[RealNameViewController alloc] init];
                UINavigationController *realNameNav = [[UINavigationController alloc] initWithRootViewController:realName];
                [self.sideMenuViewController setContentViewController:realNameNav];
                
                // [CommParameter sharedInstance].urlSchemes 续签
                [CommParameter sharedInstance].urlSchemes = self.schemeStr;
            } rightBlock:^{
                [self payGoBackByisSuccess:SPS_PAY_CANCLE];
            }];
            return;
        }
        //若检测未设置支付密码,则修改支付密码
        if (![CommParameter sharedInstance].payPassFlag) {
            [Tool showDialog:@"请进行设置" message:@"检测到您还未设置支付密码" leftBtnString:@"去设置" rightBtnString:@"退出支付" leftBlock:^{
                //由于设置支付密码挂在实名流程之下(不能单独设置),因此单独设置支付密码必须走 修改支付密码流程
                VerifyTypeViewController *verifyTypeVC = [[VerifyTypeViewController alloc] init];
                verifyTypeVC.tokenType = @"01000601";
                verifyTypeVC.verifyType = VERIFY_TYPE_CHANGEPATPWD;
                verifyTypeVC.setPayPassFromeHomeNav = YES;
                verifyTypeVC.phoneNoStr = [CommParameter sharedInstance].phoneNo;
                UINavigationController *verifyTypeNav = [[UINavigationController alloc] initWithRootViewController:verifyTypeVC];
                [self.sideMenuViewController setContentViewController:verifyTypeNav];
                
                // [CommParameter sharedInstance].urlSchemes 续签
                [CommParameter sharedInstance].urlSchemes = self.schemeStr;
            } rightBlock:^{
                [self payGoBackByisSuccess:SPS_PAY_CANCLE];
            }];
            return;
        }
        
        
        //确保实名+有支付密码后,方可请求订单
        [self TNOrder:self.TN];
    }
}
#pragma mark 头像上滑动画
- (void)headViewAnimation{
    
    [UIView animateWithDuration:0.5f animations:^{
        headView.frame = CGRectMake((SCREEN_WIDTH - headView.width)/2, UPDOWNSPACE_64, headView.width, headView.height);
        headView.alpha = 1.f;
    } completion:^(BOOL finished) {
        
    }];
}

#pragma mark 支付完成/取消 回调
- (void)payGoBackByisSuccess:(SPS_PAY_STATE)payState{
    
    NSArray *array = [self.schemeStr componentsSeparatedByString:@"?"];
    NSString *backURL = [array lastObject];
    backURL = [backURL stringByAppendingString:@"://"];
    if (payState == SPS_PAY_SUCCESS) {
        if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:backURL]]) {
            [Tool openUrl:[NSURL URLWithString:[NSString stringWithFormat:@"%@0000?%@",backURL,self.TN]]];
        }
    }
    if (payState == SPS_PAY_CANCLE) {
        if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:backURL]]) {
            [Tool openUrl:[NSURL URLWithString:[NSString stringWithFormat:@"%@0001?%@",backURL,self.TN]]];
        }
    }
    if (payState == SPS_PAY_ERROR) {
        if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:backURL]]) {
            [Tool openUrl:[NSURL URLWithString:[NSString stringWithFormat:@"%@0002?%@",backURL,self.TN]]];
        }
    }
    //延迟执行效果
    [self performSelector:@selector(outSps) withObject:nil afterDelay:0.4f];
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
        [[SDRequestHelp shareSDRequest] closedRespCpdeErrorAutomatic];
        paynuc.set("cfg_termFp", [[Tool setCfgTempFpStaticDataFlag:NO DynamicDataFlag:YES] UTF8String]);
        [[SDRequestHelp shareSDRequest] requestWihtFuncName:@"token/getTtoken/v1" errorBlock:^(SDRequestErrorType type) {
            error = YES;
            [[SDRequestHelp shareSDRequest] dispatchToMainQueue:^{
                [[SDRequestHelp shareSDRequest] openRespCpdeErrorAutomatic];
                //查询支付工具失败也回调成功
                [Tool showDialog:@"支付成功" message:@"点击返回商户" defulBlock:^{
                    [self payGoBackByisSuccess:SPS_PAY_SUCCESS];
                }];
            }];
        } successBlock:^{
            [[SDRequestHelp shareSDRequest] openRespCpdeErrorAutomatic];
        }];
        if (error) return ;
        
        paynuc.set("payToolKinds", "[]");
        [[SDRequestHelp shareSDRequest] closedRespCpdeErrorAutomatic];
        [[SDRequestHelp shareSDRequest] requestWihtFuncName:@"payTool/getOwnPayTools/v1" errorBlock:^(SDRequestErrorType type) {
            error = YES;
            [[SDRequestHelp shareSDRequest] dispatchToMainQueue:^{
                [[SDRequestHelp shareSDRequest] openRespCpdeErrorAutomatic];
                //查询支付工具失败也回调成功
                [Tool showDialog:@"支付成功" message:@"点击返回商户" defulBlock:^{
                    [self payGoBackByisSuccess:SPS_PAY_SUCCESS];
                }];
            }];
        } successBlock:^{
            [[SDRequestHelp shareSDRequest] dispatchToMainQueue:^{
                [[SDRequestHelp shareSDRequest] openRespCpdeErrorAutomatic];
                [self.HUD hidden];
                
                NSArray *payToolsArray = [[PayNucHelper sharedInstance] jsonStringToArray:[NSString stringWithUTF8String:paynuc.get("payTools").c_str()]];
                //支付工具排序
                payToolsArray = [Tool orderForPayTools:payToolsArray];
                [CommParameter sharedInstance].ownPayToolsArray = payToolsArray;
                
                //成功回调
                [Tool showDialog:@"支付成功" message:@"点击返回商户" defulBlock:^{
                    [self payGoBackByisSuccess:SPS_PAY_SUCCESS];
                }];
            }];
        }];
        if (error) return ;
    }];
}

- (void)outSps{
    //sps启动支付成功/失败 urlScheme清空
    [CommParameter sharedInstance].urlSchemes = nil;
    //归位Home或SpsLunch
    [Tool setContentViewControllerWithHomeOrSpsLunchFromSideMenuViewController:self.sideMenuViewController];
    
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
