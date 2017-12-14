//
//  SpsLunchViewController.m
//  sandbao
//
//  Created by tianNanYiHao on 2017/12/13.
//  Copyright © 2017年 sand. All rights reserved.
//

#import "SpsLunchViewController.h"
#import "PayNucHelper.h"

#import "SandTnOrderViewController.h"
typedef void(^SpsLunchPayBlock)(NSArray *paramArr);
@interface SpsLunchViewController ()<SDPayViewDelegate>
{
    
    NSDictionary *successWorkDic; //支付成功后返回的work
    
    CGFloat limitFloat;
    
    NSMutableArray *payToolsArrayUsableM;  //可用支付工具
    NSMutableArray *payToolsArrayUnusableM; //不可用支付工具
    
    NSDictionary *orderDic; //订单信息
    
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

@implementation SpsLunchViewController

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    //检测是否实名/设置支付密码
    [self checkRealNameOrSetPayPwd];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self createUI];
    
    [self TNOrder:self.TN];
    
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
    self.navCoverView.hidden = YES;
}

#pragma mark - 重写父类-点击方法集合
- (void)buttonClick:(UIButton *)btn{
    
    
}

#pragma mark  - UI绘制
- (void)createUI{
    

}
- (void)create_PayView{
    self.payView = [SDPayView getPayView];
    self.payView.delegate = self;
    [[UIApplication sharedApplication].keyWindow addSubview:self.payView];
    
}

#pragma mark - SDPayViewDelegate
- (void)payViewSelectPayToolDic:(NSMutableDictionary *)selectPayToolDict{
    
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
            //成功回调
            [self payGoBackByisSuccess:YES];
        });
        
    } oederErrorBlock:^(NSArray *paramArr){
        //支付失败
        [successView animationStopClean];
        [self.payView hidPayTool];
        [Tool showDialog:@"支付失败" defulBlock:^{
            [self payGoBackByisSuccess:NO];
        }];
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
            [[SDRequestHelp shareSDRequest] dispatchToMainQueue:^{
                [self payGoBackByisSuccess:NO];
            }];
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
            [[SDRequestHelp shareSDRequest] dispatchToMainQueue:^{
                [self payGoBackByisSuccess:NO];
            }];
        } successBlock:^{
            [[SDRequestHelp shareSDRequest] dispatchToMainQueue:^{
                [self.HUD hidden];
                
                NSString *payTools = [NSString stringWithUTF8String:paynuc.get("payTools").c_str()];
                NSArray *payToolsArray = [[PayNucHelper sharedInstance] jsonStringToArray:payTools];
                NSString *order = [NSString stringWithUTF8String:paynuc.get("order").c_str()];
                orderDic = [[PayNucHelper sharedInstance] jsonStringToDictionary:order];
                //校验支付工具
                [self checkInPayToolsOutPayTools:payToolsArray];
            }];
        }];
        if (error) return ;
    }];
}

//刷新订单页面信息
- (void)resetTnOrderInfo{
    //SPS跳转支付,暂不需要刷新相关显示UI
}

//校验支付工具
- (void)checkInPayToolsOutPayTools:(NSArray*)rechargePayToolsArray{
    
    //检测支付工具
    if (rechargePayToolsArray.count>0) {
        //0.排序
        rechargePayToolsArray = [Tool orderForPayTools:rechargePayToolsArray];
        //1.过滤用支付工具
        payToolsArrayUsableM = [NSMutableArray arrayWithCapacity:0];
        payToolsArrayUnusableM = [NSMutableArray arrayWithCapacity:0];
        for (int i = 0; i<rechargePayToolsArray.count; i++) {
            if ([[rechargePayToolsArray[i] objectForKey:@"available"] boolValue]== NO || [[rechargePayToolsArray[i] objectForKey:@"type"] isEqualToString:@"1014"]) {
                //不可用支付工具集
                [payToolsArrayUnusableM addObject:rechargePayToolsArray[i]];
            }else{
                //可用支付工具集
                [payToolsArrayUsableM addObject:rechargePayToolsArray[i]];
            }
        }
        if (payToolsArrayUsableM.count >0) {
            //2.设置VC默认显示的支付
            self.selectedPayDict = [NSMutableDictionary dictionaryWithDictionary:payToolsArrayUsableM[0]];
            //刷新订单页面信息
            [self resetTnOrderInfo];
            //3.设置支付方式列表
            [self initPayMode:rechargePayToolsArray];
        }else{
            [Tool showDialog:@"无可用支付工具" defulBlock:^{
                [self.navigationController popViewControllerAnimated:YES];
            }];
        }
    }else{
        [Tool showDialog:@"无可用工具下发" defulBlock:^{
            [self.navigationController popViewControllerAnimated:YES];
        }];
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
        
        NSString *transAmt = [NSString stringWithFormat:@"%.0f", [[self.selectedPayDict objectForKey:@"amount"] floatValue]];
        
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
        [[SDRequestHelp shareSDRequest] requestWihtFuncName:@"business/pay/v1" errorBlock:^(SDRequestErrorType type) {
            error = YES;
            [[SDRequestHelp shareSDRequest] dispatchToMainQueue:^{
                errorBlock(nil);
            }];
        } successBlock:^{
            [[SDRequestHelp shareSDRequest] dispatchToMainQueue:^{
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
            
            [Tool showDialog:@"您还未实名" message:@"请实名认证后重试" defulBlock:^{
                
            }];
            return;
        }
        //若检测未设置支付密码,则修改支付密码
        if (![CommParameter sharedInstance].payPassFlag) {
            [Tool showDialog:@"您还未设置支付密码" message:@"请设置完成后重试" defulBlock:^{
                
            }];
            return;
        }
    }
}

#pragma mark 支付完成/取消 回调
- (void)payGoBackByisSuccess:(BOOL)success{
    
    NSArray *array = [self.schemeStr componentsSeparatedByString:@"?"];
    NSString *backURL = [array lastObject];
    backURL = [backURL stringByAppendingString:@"://"];
    if (success) {
        if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:backURL]]) {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@paySussess",backURL]]];
        }
    }else{
        
        if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:backURL]]) {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@notPyaSuccess",backURL]]];
        }
    }
    
    //延迟执行效果
    [self performSelector:@selector(outApp) withObject:nil afterDelay:0.4f];
}
- (void)outApp{
    [Tool exitApplication:self];
    
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
