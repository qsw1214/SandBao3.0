//
//  SandCardDetailViewController.m
//  sandbao
//
//  Created by tianNanYiHao on 2017/11/21.
//  Copyright © 2017年 sand. All rights reserved.
//

#import "SandCardDetailViewController.h"
#import "PayNucHelper.h"

#import "GradualView.h"
#import "DetailsWebViewController.h"

typedef void(^SandCardStateBlock)(NSArray *paramArr);
@interface SandCardDetailViewController ()<SDPayViewDelegate>
{
    GradualView *headView;
    
    UILabel *moneyLab; //余额
    
    UILabel *cardNoLab; //卡号
    
    NSString *payPassword; //Pass字符串
    
    SDBarButton *barButton;
    
    NSDictionary *authToolDic;
}
/**
 支付工具控件
 */
@property (nonatomic, strong) SDPayView *payView;

@property (nonatomic, strong) NSString *sandCardPayToolID; //记名卡账户ID
@end

@implementation SandCardDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self create_HeadView];
    [self create_BodyView];
    [self create_PayView];
    
    
    [self getBalances];
    
}


#pragma mark - 重写父类-baseScrollView设置
- (void)setBaseScrollview{
    [super setBaseScrollview];
    
}
#pragma mark - 重写父类-导航设置方法
- (void)setNavCoverView{
    [super setNavCoverView];
    self.navCoverView.style = NavCoverStyleWhite;
    self.navCoverView.letfImgStr = @"login_icon_back";
    self.navCoverView.midTitleStr = @"杉德卡详情";
    self.navCoverView.rightTitleStr = @"明细";
    
    __weak SandCardDetailViewController *weakSelf = self;
    self.navCoverView.leftBlock = ^{
        [weakSelf.navigationController popViewControllerAnimated:YES];
    };
    self.navCoverView.rightBlock = ^{
        DetailsWebViewController *webViewVC = [[DetailsWebViewController alloc] init];
        webViewVC.payToolID = weakSelf.sandCardPayToolID;
        webViewVC.code = CONSUME_CODE;
        [weakSelf.navigationController pushViewController:webViewVC animated:YES];
    };
    
    
}
#pragma mark - 重写父类-点击方法集合
- (void)buttonClick:(UIButton *)btn{
    
    //web跳转
    if (btn.tag == BTN_TAG_ENTERWEBVC) {
        
    }
    //解绑卡
    if (btn.tag == BTN_TAG_UNBINDCARD) {
        [self unbingding_getAuthTools];
    }
}

#pragma mark  - UI绘制

- (void)create_HeadView{
    
    //headView
    headView = [[GradualView alloc] init];
    headView.colorStyle = GradualColorBlue;
    [headView setRect:CGRectMake(LEFTRIGHTSPACE_00, UPDOWNSPACE_0, SCREEN_WIDTH, UPDOWNSPACE_197)];
    [self.baseScrollView addSubview:headView];
    
    [headView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.baseScrollView.mas_top);
        make.left.equalTo(self.baseScrollView.mas_left);
        make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH, UPDOWNSPACE_197));
    }];
    
    //balanceLab
    UILabel *balanceLab = [Tool createLable:@"余额" attributeStr:nil font:FONT_16_PingFangSC_Light textColor:COLOR_FFFFFF alignment:NSTextAlignmentCenter];
    [headView addSubview:balanceLab];
    
    //moneyLab
    moneyLab = [Tool createLable:@"¥0.00" attributeStr:nil font:FONT_50_SFUDisplay_Regular textColor:COLOR_FFFFFF alignment:NSTextAlignmentCenter];
    [headView addSubview:moneyLab];
    
    //dataLab
    UILabel *dataLab = [Tool createLable:@"有效期: 2011.9.10-2019.9.10" attributeStr:nil font:FONT_10_PingFangSC_Light textColor:COLOR_FFFFFF alignment:NSTextAlignmentCenter];
    [headView addSubview:dataLab];
    
    [balanceLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(headView.mas_top).offset(UPDOWNSPACE_34);
        make.centerX.equalTo(headView);
        make.size.mas_equalTo(balanceLab.size);
    }];
    
    [moneyLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(balanceLab.mas_bottom).offset(UPDOWNSPACE_05);
        make.centerX.equalTo(headView);
        make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH, moneyLab.height));
    }];
    
    [dataLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(moneyLab.mas_bottom).offset(UPDOWNSPACE_16);
        make.centerX.equalTo(headView);
        make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH, dataLab.height));
    }];
    
}

- (void)create_BodyView{
    
    //cardDetailLab
    UILabel *cardDetailLab = [Tool createLable:@"卡片详情" attributeStr:nil font:FONT_12_Regular textColor:COLOR_343339 alignment:NSTextAlignmentCenter];
    [headView addSubview:cardDetailLab];

    //detailView
    UIView *detailView = [[UIView alloc] init];
    detailView.backgroundColor = COLOR_FFFFFF;
    detailView.layer.borderColor = COLOR_D8D8D8.CGColor;
    detailView.layer.borderWidth = 0.5f;
    [self.baseScrollView addSubview:detailView];
    
    //杉德logo
    UILabel *sandName = [Tool createLable:@"杉德" attributeStr:nil font:FONT_36_SFUIT_Rrgular textColor:COLOR_666666 alignment:NSTextAlignmentCenter];
    sandName.layer.borderColor = COLOR_D8D8D8.CGColor;
    sandName.layer.borderWidth = 0.5f;
    [detailView addSubview:sandName];
    
    //cardNo
    UIView *cardNoView = [[UIView alloc] init];
    cardNoView.backgroundColor = [UIColor whiteColor];
    [detailView addSubview:cardNoView];
    
    UILabel *cardNoDesLab = [Tool createLable:@"卡片号:" attributeStr:nil font:FONT_10_PingFangSC_Light textColor:COLOR_343339_5 alignment:NSTextAlignmentCenter];
    [cardNoView addSubview:cardNoDesLab];
    
    cardNoLab = [Tool createLable:@"**** **** **** ****  " attributeStr:nil font:FONT_20_Regular textColor:COLOR_343339 alignment:NSTextAlignmentCenter];
    cardNoLab.textAlignment = NSTextAlignmentRight;
    [cardNoView addSubview:cardNoLab];
    
    //unBingdingBtn
    barButton = [[SDBarButton alloc] init];
    UIView *unBingdingBtn = [barButton createBarButton:@"解绑" font:FONT_15_Regular titleColor:COLOR_FFFFFF backGroundColor:COLOR_58A5F6 leftSpace:LEFTRIGHTSPACE_40];
    barButton.btn.tag = BTN_TAG_UNBINDCARD;
    [barButton.btn addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.baseScrollView addSubview:unBingdingBtn];
    [barButton changeState:YES];
    
    CGFloat detailViewW = LEFTRIGHTSPACE_286;
    CGFloat detailViewH = UPDOWNSPACE_100;
    CGFloat cardNoViewSpace = (detailViewW - (cardNoDesLab.width + LEFTRIGHTSPACE_04 + cardNoLab.width))/2;
    
    [cardDetailLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(headView.mas_bottom).offset(UPDOWNSPACE_30);
        make.centerX.equalTo(self.baseScrollView);
        make.size.mas_equalTo(cardDetailLab.size);
    }];

    [detailView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(cardDetailLab.mas_bottom).offset(UPDOWNSPACE_14);
        make.left.equalTo(self.baseScrollView.mas_left).offset(LEFTRIGHTSPACE_45);
        make.size.mas_equalTo(CGSizeMake(detailViewW, detailViewH));
    }];
    
    [sandName mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(detailView.mas_top);
        make.centerX.mas_equalTo(detailView.mas_centerX);
        make.size.mas_equalTo(CGSizeMake(detailViewW, detailViewH/2));
    }];
    
    [cardNoView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(sandName.mas_bottom);
        make.centerX.equalTo(sandName);
        make.size.mas_equalTo(CGSizeMake(detailViewW, detailViewH/2));
    }];
    
    [cardNoDesLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(cardNoView);
        make.left.equalTo(cardNoView.mas_left).offset(cardNoViewSpace);
        make.size.mas_equalTo(CGSizeMake(LEFTRIGHTSPACE_35, cardNoDesLab.height));
    }];
    
    [cardNoLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(cardNoView);
        make.right.equalTo(cardNoView.mas_right).offset(-cardNoViewSpace);
        make.size.mas_equalTo(cardNoLab.size);
    }];
    
    [unBingdingBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(detailView.mas_bottom).offset(UPDOWNSPACE_69);
        make.centerX.equalTo(self.baseScrollView);
        make.size.mas_equalTo(unBingdingBtn.size);
    }];
}

-(void)create_PayView{
    
    self.payView = [SDPayView getPayView];
    self.payView.style = SDPayViewOnlyPwd;
    self.payView.delegate = self;
    [[UIApplication sharedApplication].keyWindow addSubview:self.payView];
    
    
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
            
            [Tool showDialog:@"解绑成功" defulBlock:^{
                [self.navigationController popViewControllerAnimated:YES];
            }];
            
        });
    } errorBlock:^(NSArray *paramArr){
        //支付失败 - 动画停止
        [successView animationStopClean];
        //支付失败 - 隐藏支付工具
        [self.payView hidPayToolInPayPwdView];
        
        if (paramArr.count>0) {
            [Tool showDialog:paramArr[0]];
        }
    }];
}

- (void)payViewForgetPwd:(NSString *)type{
    
    if ([type isEqualToString:PAYTOOL_PAYPASS]) {
        //修改支付密码
        
    }
    if ([type isEqualToString:PAYTOOL_ACCPASS]) {
        //修改杉德卡密码
    }
    
}

#pragma mark - 业务逻辑

#pragma mark - 卡账户余额查询
-(void)getBalances{
    self.HUD = [SDMBProgressView showSDMBProgressOnlyLoadingINViewImg:self.view];
    [SDRequestHelp shareSDRequest].HUD = self.HUD;
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
        [payToolsArray addObject:self.payToolDic];
        payTools = [[PayNucHelper sharedInstance] arrayToJSON:payToolsArray];
        paynuc.set("payTools", [payTools UTF8String]);
        [[SDRequestHelp shareSDRequest] requestWihtFuncName:@"payTool/getBalances/v1" errorBlock:^(SDRequestErrorType type) {
            error = YES;
        } successBlock:^{
            [[SDRequestHelp shareSDRequest] dispatchToMainQueue:^{
                [self.HUD hidden];
                
                //更新数据 主账户 钱包账户余额
                NSString *payTools = [NSString stringWithUTF8String:paynuc.get("payTools").c_str()];
                NSArray *payToolsArr = [[PayNucHelper sharedInstance] jsonStringToArray:payTools];
                
                //排序
                payToolsArr = [Tool orderForPayTools:payToolsArr];
                if (payToolsArr.count>0) {
                    NSDictionary *payToolDic = payToolsArr[0];
                    
                    moneyLab.text = [Tool fenToYuanDict:payToolDic];
                    self.sandCardPayToolID = [payToolDic objectForKey:@"id"];
                    cardNoLab.text = [NSString stringWithFormat:@"**** **** **** %@",[[payToolDic objectForKey:@"account"] objectForKey:@"accNo"]];
                }
            }];
        }];
        if (error) return ;
    }];
    
}




#pragma mark 解绑_查询鉴权工具
- (void)unbingding_getAuthTools
{
    self.HUD = [SDMBProgressView showSDMBProgressOnlyLoadingINViewImg:self.view];
    [SDRequestHelp shareSDRequest].HUD = self.HUD;
    [SDRequestHelp shareSDRequest].controller = self;
    [[SDRequestHelp shareSDRequest] dispatchGlobalQuque:^{
        __block BOOL error = NO;
        paynuc.set("tTokenType", "01001801");
        paynuc.set("cfg_termFp", [[Tool setCfgTempFpStaticDataFlag:NO DynamicDataFlag:YES] UTF8String]);
        [[SDRequestHelp shareSDRequest] requestWihtFuncName:@"token/getTtoken/v1" errorBlock:^(SDRequestErrorType type) {
            error = YES;
        } successBlock:^{
            
        }];
        if (error) return ;
        
        
        
        [[SDRequestHelp shareSDRequest] requestWihtFuncName:@"authTool/getAuthTools/v1" errorBlock:^(SDRequestErrorType type) {
            error = YES;
        } successBlock:^{
            [[SDRequestHelp shareSDRequest] dispatchToMainQueue:^{
                [self.HUD hidden];
                
                NSString *tempAuthTools = [NSString stringWithUTF8String:paynuc.get("authTools").c_str()];
                NSArray *tempAuthToolsArray = [[PayNucHelper sharedInstance] jsonStringToArray:tempAuthTools];
                
                authToolDic = tempAuthToolsArray[0];
                
                //支付控件设置列表
                [self.payView setPayTools:tempAuthToolsArray];
                //支付控件弹出
                [self.payView showPayTool];
                
            }];
        }];
        if (error) return ;
    }];
}


#pragma mark 解绑杉德卡
- (void)unbandCardSuccessBlock:(SandCardStateBlock)successBlock errorBlock:(SandCardStateBlock)errorBlock
{
    self.HUD = [SDMBProgressView showSDMBProgressOnlyLoadingINViewImg:self.view];
    [self.HUD hidden];
    [SDRequestHelp shareSDRequest].HUD = self.HUD;
    [SDRequestHelp shareSDRequest].controller = self;
    [[SDRequestHelp shareSDRequest] dispatchGlobalQuque:^{
        __block BOOL error = NO;
        
        NSMutableArray *tempAuthToolsArray = [[NSMutableArray alloc] init];
        NSMutableDictionary *authToolsDic = [NSMutableDictionary dictionaryWithDictionary:authToolDic];
        [authToolsDic removeObjectForKey:@"pass"];
        NSMutableDictionary *passDic = [[NSMutableDictionary alloc] init];
        [passDic setValue:[[PayNucHelper sharedInstance] pinenc:payPassword type:@"paypass"] forKey:@"password"];
        [passDic setValue:@"" forKey:@"description"];
        [passDic setValue:@"" forKey:@"encryptType"];
        [passDic setValue:@"" forKey:@"regular"];
        [authToolsDic setObject:passDic forKey:@"pass"];
        [tempAuthToolsArray addObject:authToolsDic];
        NSString *authTools = [[PayNucHelper sharedInstance] arrayToJSON:tempAuthToolsArray];
        
        NSString *payTool = [[PayNucHelper sharedInstance] dictionaryToJson:(NSMutableDictionary*)self.payToolDic];
        
        paynuc.set("payTool", [payTool UTF8String]);
        paynuc.set("authTools", [authTools UTF8String]);
        [[SDRequestHelp shareSDRequest] closedRespCpdeErrorAutomatic];
        [[SDRequestHelp shareSDRequest] requestWihtFuncName:@"card/unbandCard/v1" errorBlock:^(SDRequestErrorType type) {
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
                successBlock(nil);
            }];
        }];
        if (error) return ;
    }];
    
}



- (void)dealloc{
    //清除通知
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
