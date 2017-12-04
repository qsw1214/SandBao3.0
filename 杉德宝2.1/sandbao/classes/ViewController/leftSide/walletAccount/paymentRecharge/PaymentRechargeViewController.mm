//
//  PaymentRechargeViewController.m
//  sandbao
//
//  Created by tianNanYiHao on 2017/11/1.
//  Copyright © 2017年 sand. All rights reserved.
//

#import "PaymentRechargeViewController.h"
#import "PayNucHelper.h"
#import "RechargeFinishViewController.h"

#import "PaymentPwdCell.h"
#import<CommonCrypto/CommonDigest.h>

@interface PaymentRechargeViewController ()
{
    
    
}
@property (nonatomic, strong) NSString *paymentPwd;
/**
 充值支付工具
 */
@property (nonatomic, strong) NSMutableDictionary *rechargeOutPayToolDic;

/**
 work域
 */
@property (nonatomic, strong) NSDictionary *wordDic;

@end

@implementation PaymentRechargeViewController

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    //获取充值支付工具
    [self getPayTools];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self createUI];
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
    self.navCoverView.midTitleStr = @"代付凭证充值";
    self.navCoverView.letfImgStr = @"general_icon_back";
    
    
    __weak PaymentRechargeViewController *weakSelf = self;
    self.navCoverView.leftBlock = ^{
        [weakSelf.navigationController popViewControllerAnimated:YES];
    };
    
    
}
#pragma mark - 重写父类-点击方法集合
- (void)buttonClick:(UIButton *)btn{
    
    if (btn.tag == BTN_TAG_RECHARGE) {
        
        if (self.paymentPwd.length>0) {
            [self fee];
        }else{
            [Tool showDialog:@"请输入正确信息"];
        }

        
    }
    
}


#pragma mark  - UI绘制

- (void)createUI{
    __weak typeof(self) weakself = self;
    PaymentPwdCell *paymentPwdCell = [PaymentPwdCell createPaymentCellViewOY:0];
    paymentPwdCell.tip.text = @"请输入正确代付凭证密码";
    paymentPwdCell.textfield.text = SHOWTOTEST(@"469686289040E142");
    self.paymentPwd = SHOWTOTEST(@"469686289040E142");
    paymentPwdCell.successBlock = ^(NSString *textfieldText) {
        weakself.paymentPwd = textfieldText;
    };
    paymentPwdCell.line.hidden = YES;
    [self.baseScrollView addSubview:paymentPwdCell];

    [paymentPwdCell mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.baseScrollView.mas_top).offset(UPDOWNSPACE_20);
        make.centerX.equalTo(self.baseScrollView);
        make.size.mas_equalTo(paymentPwdCell.size);
    }];
    
    
    //rechargeBtn
    UIButton *rechargeBtn = [Tool createBarButton:@"充值" font:FONT_15_Regular titleColor:COLOR_FFFFFF backGroundColor:COLOR_358BEF leftSpace:LEFTRIGHTSPACE_40];
    rechargeBtn.tag = BTN_TAG_RECHARGE;
    [rechargeBtn addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.baseScrollView addSubview:rechargeBtn];
    
    [rechargeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(paymentPwdCell.mas_bottom).offset(UPDOWNSPACE_69);
        make.centerX.equalTo(self.baseScrollView.mas_centerX);
        make.size.mas_equalTo(rechargeBtn.size);
    }];
}

#pragma mark - 业务逻辑
#pragma mark 查询支付工具
- (void)getPayTools{
    
    self.HUD = [SDMBProgressView showSDMBProgressOnlyLoadingINViewImg:self.view];
    [SDRequestHelp shareSDRequest].HUD = self.HUD;
    [SDRequestHelp shareSDRequest].controller = self;
    [[SDRequestHelp shareSDRequest] dispatchGlobalQuque:^{
        __block BOOL error = NO;
        
        paynuc.set("tTokenType", [self.tTokenType UTF8String]);
        paynuc.set("cfg_termFp", [[Tool setCfgTempFpStaticDataFlag:NO DynamicDataFlag:YES] UTF8String]);
        [[SDRequestHelp shareSDRequest] requestWihtFuncName:@"token/getTtoken/v1" errorBlock:^(SDRequestErrorType type) {
            error = YES;
        } successBlock:^{
            
        }];
        if (error) return ;
        
        
        NSString *payTool = [[PayNucHelper sharedInstance] dictionaryToJson:self.rechargeInPayToolDic];
        paynuc.set("payTool", [payTool UTF8String]);
        [[SDRequestHelp shareSDRequest] requestWihtFuncName:@"payTool/getPayTools/v1" errorBlock:^(SDRequestErrorType type) {
            error = YES;
            [[SDRequestHelp shareSDRequest] dispatchToMainQueue:^{
                [self.navigationController popViewControllerAnimated:YES];
            }];
        } successBlock:^{
            [[SDRequestHelp shareSDRequest] dispatchToMainQueue:^{
                [self.HUD hidden];
                
                NSString *rechargePayTools = [NSString stringWithUTF8String:paynuc.get("payTools").c_str()];
                NSArray *rechargePayToolsArray = [[PayNucHelper sharedInstance] jsonStringToArray:rechargePayTools];
                //校验支付工具
                [self checkInPayToolsOutPayTools:rechargePayToolsArray];
            }];
        }];
        if (error) return ;
    }];
    
}

/**
 校验支付工具
 
 @param rechargePayToolsArray void
 */
- (void)checkInPayToolsOutPayTools:(NSArray*)rechargePayToolsArray{
    
    //检测支付工具
    if (rechargePayToolsArray.count>0) {
        //0.排序
        rechargePayToolsArray = [Tool orderForPayTools:rechargePayToolsArray];
        //1. 取代付凭证支付工具(1014)
        NSDictionary *payToolDic = [Tool getPayToolsInfo:rechargePayToolsArray];
        NSDictionary *payForAnotherDic = [payToolDic objectForKey:@"payForAnotherDic"];
        
        if (![payForAnotherDic objectForKey:@"available"]) {
            [Tool showDialog:@"无可用支付工具" defulBlock:^{
                 [self.navigationController popViewControllerAnimated:YES];
            }];
        }else{
            //获取转出支付工具
            self.rechargeOutPayToolDic = [NSMutableDictionary dictionaryWithDictionary:payForAnotherDic];
        }
    }else{
        [Tool showDialog:@"无可用工具下发" defulBlock:^{
            [self.navigationController popViewControllerAnimated:YES];
        }];
    }
}




#pragma mark 计算手续费fee
/**
 *@brief 手续费
 *@return
 */
- (void)fee
{
    self.HUD = [SDMBProgressView showSDMBProgressOnlyLoadingINViewImg:self.view];
    [SDRequestHelp shareSDRequest].HUD = self.HUD;
    [SDRequestHelp shareSDRequest].controller = self;
    [[SDRequestHelp shareSDRequest] dispatchGlobalQuque:^{
        __block BOOL error = NO;
        
        NSDictionary *workDic = [[NSDictionary alloc] init];
        workDic = @{
                    @"type":@"recharge",
                    @"transAmt":@"0"
                    };
        NSString *work = [[PayNucHelper sharedInstance] dictionaryToJson:(NSMutableDictionary*)workDic];
        
        NSString *inPayTool = [[PayNucHelper sharedInstance] dictionaryToJson:self.rechargeInPayToolDic];
        
        NSString *outPayTool = [[PayNucHelper sharedInstance] dictionaryToJson:self.rechargeOutPayToolDic];
        
        paynuc.set("work", [work UTF8String]);
        paynuc.set("inPayTool", [inPayTool UTF8String]);
        paynuc.set("outPayTool", [outPayTool UTF8String]);
        paynuc.set("authTools", [@"[]" UTF8String]);
        [[SDRequestHelp shareSDRequest] requestWihtFuncName:@"business/fee/v1" errorBlock:^(SDRequestErrorType type) {
            error = YES;
        } successBlock:^{
            [[SDRequestHelp shareSDRequest] dispatchToMainQueue:^{
                [self.HUD hidden];
                
                NSString *work = [NSString stringWithUTF8String:paynuc.get("work").c_str()];
                self.wordDic = [[PayNucHelper sharedInstance] jsonStringToDictionary:work];
                
                //代付凭证充值
                [self recharge:self.paymentPwd paramDic:self.wordDic ];
                
            }];
        }];
        if (error) return ;
    }];
}


#pragma mark 确认充值
- (void)recharge:(NSString *)param paramDic:(NSDictionary *)paramDic
{
    self.HUD = [SDMBProgressView showSDMBProgressOnlyLoadingINViewImg:self.view];
    [SDRequestHelp shareSDRequest].HUD = self.HUD;
    [SDRequestHelp shareSDRequest].controller = self;
    [[SDRequestHelp shareSDRequest] dispatchGlobalQuque:^{
        __block BOOL error = NO;
        
        
        NSDictionary *workDic = [[NSDictionary alloc] init];
        workDic = @{
                    @"type":@"recharge",
                    @"transAmt":@"0",
                    @"feeType":[paramDic objectForKey:@"feeType"],
                    @"feeRate":[paramDic objectForKey:@"feeRate"]
                    };
        
        NSString *work = [[PayNucHelper sharedInstance] dictionaryToJson:(NSMutableDictionary*)workDic];
        
        NSString *inPayTool = [[PayNucHelper sharedInstance] dictionaryToJson:self.rechargeInPayToolDic];

        NSArray *authToolsArray = [self.rechargeOutPayToolDic objectForKey:@"authTools"];
        
        NSMutableArray *tempAuthToolsArray = [[NSMutableArray alloc] init];
    
        NSMutableDictionary *dic = authToolsArray[0];
        NSMutableDictionary *authToolsDic = [NSMutableDictionary dictionaryWithDictionary:dic];
        [authToolsDic removeObjectForKey:@"pass"];
        NSMutableDictionary *passDic = [[NSMutableDictionary alloc] init];
        if ([[authToolsDic objectForKey:@"type"] isEqualToString:@"sha1pass"]){
            [passDic setValue:[self sha1:param] forKey:@"password"];
        }
        [passDic setValue:@"" forKey:@"description"];
        [passDic setValue:@"sand" forKey:@"encryptType"];
        [passDic setValue:@"" forKey:@"regular"];
        [authToolsDic setObject:passDic forKey:@"pass"];
        [tempAuthToolsArray addObject:authToolsDic];
        [self.rechargeOutPayToolDic setObject:tempAuthToolsArray forKey:@"authTools"];
        
        NSString *outPayTool = [[PayNucHelper sharedInstance] dictionaryToJson:self.rechargeOutPayToolDic];

        
        paynuc.set("work", [work UTF8String]);
        paynuc.set("inPayTool", [inPayTool UTF8String]);
        paynuc.set("outPayTool", [outPayTool UTF8String]);
        
        [[SDRequestHelp shareSDRequest] requestWihtFuncName:@"business/acc2acc/v1" errorBlock:^(SDRequestErrorType type) {
            error = YES;
            [[SDRequestHelp shareSDRequest] dispatchToMainQueue:^{
                
            }];
        } successBlock:^{
            [[SDRequestHelp shareSDRequest] dispatchToMainQueue:^{
                [self.HUD hidden];
                NSString *work = [NSString stringWithUTF8String:paynuc.get("work").c_str()];
                NSDictionary *workDic = [[PayNucHelper sharedInstance] jsonStringToDictionary:work];
                //充值成功
                RechargeFinishViewController *rechargeFinishVC = [[RechargeFinishViewController alloc] init];
                rechargeFinishVC.amtMoneyStr = [NSString stringWithFormat:@"%.2f",[[workDic objectForKey:@"transAmt"] floatValue]/100];
                rechargeFinishVC.payOutName = [self.rechargeOutPayToolDic objectForKey:@"title"];
                [self.navigationController pushViewController:rechargeFinishVC animated:YES];
                
            }];
        }];
        if (error) return ;
    }];
    
}







//sha1加密方式
- (NSString *)sha1:(NSString *)input
{
    //const char *cstr = [input cStringUsingEncoding:NSUTF8StringEncoding];
    //NSData *data = [NSData dataWithBytes:cstr length:input.length];
    
    NSData *data = [input dataUsingEncoding:NSUTF8StringEncoding];
    
    uint8_t digest[CC_SHA1_DIGEST_LENGTH];
    
    CC_SHA1(data.bytes, (unsigned int)data.length, digest);
    
    NSMutableString *output = [NSMutableString stringWithCapacity:CC_SHA1_DIGEST_LENGTH * 2];
    
    for(int i=0; i<CC_SHA1_DIGEST_LENGTH; i++) {
        [output appendFormat:@"%02x", digest[i]];
    }
    
    return output;
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
