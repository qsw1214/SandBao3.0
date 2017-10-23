//
//  RealNameViewController.m
//  sandbao
//
//  Created by tianNanYiHao on 2017/10/19.
//  Copyright © 2017年 sand. All rights reserved.
//

#import "RealNameViewController.h"
#import "PayNucHelper.h"


#import "SmsCheckViewController.h"

@interface RealNameViewController ()
{
    
}
@property (nonatomic, strong) NSString *realNameStr;  //真实姓名
@property (nonatomic, strong) NSString *bankCardNoStr;  //银行卡号
@property (nonatomic, strong) NSString *identityNoStr;  //真实姓名
@property (nonatomic, strong) NSString *bankPhoneNoStr; //银行预留手机号
@property (nonatomic, strong) NSMutableArray *authToolsArray; //鉴权工具集组

@end

@implementation RealNameViewController
@synthesize realNameStr;
@synthesize bankCardNoStr;
@synthesize identityNoStr;
@synthesize authToolsArray;
@synthesize bankPhoneNoStr;


- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    // 禁用返回手势
    if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.navigationController.interactivePopGestureRecognizer.enabled = NO;
    }
}
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    // 开启返回手势
    if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.navigationController.interactivePopGestureRecognizer.enabled = YES;
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
     [self createUI];
}

#pragma - mark 重写父类-baseScrollView设置
- (void)setBaseScrollview{
    [super setBaseScrollview];
    self.baseScrollView.frame = CGRectMake(0, UPDOWNSPACE_20, SCREEN_WIDTH, SCREEN_HEIGHT-UPDOWNSPACE_20);
    
}
#pragma - mark 重写父类-导航设置方法
- (void)setNavCoverView{
    [super setNavCoverView];
    self.navCoverView.hidden = YES;
    
}
#pragma - mark 重写父类-点击方法集合
- (void)buttonClick:(UIButton *)btn{
    if (btn.tag == BTN_TAG_SHOWBANKLIST) {
        NSLog(@"点击了 支持银行 按钮");
    }
    if (btn.tag == BTN_TAG_NEXT) {
        //下一步 - 实名验证手机号
        if (realNameStr.length>0 && identityNoStr.length>0 && bankCardNoStr.length>0 && bankPhoneNoStr.length>0) {
            SmsCheckViewController *smsVC = [[SmsCheckViewController alloc] init];
            smsVC.phoneNoStr = [CommParameter sharedInstance].userName;
            smsVC.smsCheckType = SMS_CHECKTYPE_REALNAME;
            [self.navigationController pushViewController:smsVC animated:YES];
        }else{
            [Tool showDialog:@"请输入完整验证信息"];
        }
        
    }
    
}

#pragma - mark  UI绘制
- (void)createUI{
    
    //titleLab1
    UILabel *titleLab = [Tool createLable:@"实名认证" attributeStr:nil font:FONT_28_Medium textColor:COLOR_343339 alignment:NSTextAlignmentCenter];
    [self.baseScrollView addSubview:titleLab];
    
    //titleLab2
    UILabel *titleDesLab = [Tool createLable:@"请完成实名认证,体验更多服务" attributeStr:nil font:FONT_16_Regular textColor:COLOR_343339_7 alignment:NSTextAlignmentCenter];
    [self.baseScrollView addSubview:titleDesLab];
    
    
    //nameAuthToolView
    NameAuthToolView *nameAuthToolView = [NameAuthToolView createAuthToolViewOY:0];
    nameAuthToolView.tip.text = @"请输入真实有效姓名";
    __block NameAuthToolView *selfnameAuthToolView = nameAuthToolView;
    nameAuthToolView.successBlock = ^{
        realNameStr = selfnameAuthToolView.textfiled.text;
    };
    nameAuthToolView.errorBlock = ^{
        [selfnameAuthToolView showTip];
    };
    [self.baseScrollView addSubview:nameAuthToolView];
    
    //identityAuthToolView
    IdentityAuthToolView *identityAuthToolView = [IdentityAuthToolView createAuthToolViewOY:0];
    identityAuthToolView.tip.text = @"请输入有效身份证件号";
    __block IdentityAuthToolView *selfIdentityAuthToolView = identityAuthToolView;
    identityAuthToolView.successBlock = ^{
        identityNoStr = selfIdentityAuthToolView.textfiled.text;
    };
    identityAuthToolView.errorBlock = ^{
        [selfIdentityAuthToolView showTip];
    };
    [self.baseScrollView addSubview:identityAuthToolView];
    
    //cardNoAuthToolView
    CardNoAuthToolView *cardNoAuthToolView = [CardNoAuthToolView createAuthToolViewOY:0];
    cardNoAuthToolView.tip.text = @"请输入有效银行卡卡号";
    __block CardNoAuthToolView *selfcardNoAuthToolView = cardNoAuthToolView;
    cardNoAuthToolView.successBlock = ^{
        bankCardNoStr = selfcardNoAuthToolView.textfiled.text;
    };
    cardNoAuthToolView.errorBlock = ^{
        [selfcardNoAuthToolView showTip];
    };
    [self.baseScrollView addSubview:cardNoAuthToolView];
    
    //bankAuthToolView
    BankAuthToolView *bankAuthToolView = [BankAuthToolView createAuthToolViewOY:0];
    [self.baseScrollView addSubview:bankAuthToolView];
    
    //bankPhoneNoAuthToolView
    PhoneAuthToolView *bankPhoneNoAuthToolView = [PhoneAuthToolView createAuthToolViewOY:0];
    bankPhoneNoAuthToolView.titleLab.text = @"银行预留手机号";
    bankPhoneNoAuthToolView.tip.text = @"请输入正确的银行预留手机号";
    __block PhoneAuthToolView *selfPhoneAuthToolView = bankPhoneNoAuthToolView;
    bankPhoneNoAuthToolView.successBlock = ^{
        bankPhoneNoStr = selfPhoneAuthToolView.textfiled.text;
    };
    bankPhoneNoAuthToolView.errorBlock = ^{
        [selfPhoneAuthToolView showTip];
    };
    [self.baseScrollView addSubview:bankPhoneNoAuthToolView];
    
    //moreBankListBtn
    UIButton *moreBankListBtn = [Tool createButton:@"支持银行" attributeStr:nil font:FONT_14_Regular textColor:COLOR_343339_7];
    moreBankListBtn.tag = BTN_TAG_SHOWBANKLIST;
    [moreBankListBtn setImage:[UIImage imageNamed:@"general_icon_detail"] forState:UIControlStateNormal];
    CGSize moreBankListBtnSize = [moreBankListBtn sizeThatFits:CGSizeZero];
    [self.baseScrollView addSubview:moreBankListBtn];
    
    
    
    //nextBtn
    UIButton *nextBarbtn = [Tool createBarButton:@"继续" font:FONT_15_Regular titleColor:COLOR_FFFFFF backGroundColor:COLOR_58A5F6 leftSpace:LEFTRIGHTSPACE_40];
    nextBarbtn.tag = BTN_TAG_NEXT;
    [nextBarbtn addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.baseScrollView addSubview:nextBarbtn];
    
    
    [titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.baseScrollView.mas_top).offset(UPDOWNSPACE_64);
        make.centerX.equalTo(self.baseScrollView.mas_centerX);
        make.size.mas_equalTo(titleLab.size);
    }];
    
    [titleDesLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(titleLab.mas_bottom).offset(UPDOWNSPACE_14);
        make.centerX.equalTo(self.baseScrollView.mas_centerX);
        make.size.mas_equalTo(titleDesLab.size);
    }];
    
    
    [nameAuthToolView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(titleDesLab.mas_bottom).offset(UPDOWNSPACE_58);
        make.centerX.equalTo(self.baseScrollView);
        make.size.mas_equalTo(nameAuthToolView.size);
    }];
    
    [identityAuthToolView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(nameAuthToolView.mas_bottom).offset(UPDOWNSPACE_0);
        make.centerX.equalTo(self.baseScrollView);
        make.size.mas_equalTo(identityAuthToolView.size);
    }];
    
    [cardNoAuthToolView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(identityAuthToolView.mas_bottom).offset(UPDOWNSPACE_0);
        make.centerX.equalTo(self.baseScrollView);
        make.size.mas_equalTo(cardNoAuthToolView.size);
    }];
    
    [bankAuthToolView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(cardNoAuthToolView.mas_bottom).offset(UPDOWNSPACE_0);
        make.centerX.equalTo(self.baseScrollView);
        make.size.mas_equalTo(bankAuthToolView.size);
    }];
    
    [bankPhoneNoAuthToolView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(bankAuthToolView.mas_bottom).offset(UPDOWNSPACE_0);
        make.centerX.equalTo(self.baseScrollView);
        make.size.mas_equalTo(bankAuthToolView.size);
    }];

    [moreBankListBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(bankPhoneNoAuthToolView.mas_bottom).offset(UPDOWNSPACE_25);
        make.right.equalTo(bankPhoneNoAuthToolView.mas_right).offset(-LEFTRIGHTSPACE_40);
        make.size.mas_equalTo(moreBankListBtnSize);
    }];
    
    [nextBarbtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(moreBankListBtn.mas_bottom).offset(UPDOWNSPACE_25);
        make.centerX.equalTo(self.baseScrollView.mas_centerX);
        make.size.mas_equalTo(nextBarbtn.size);
    }];
    
}


#pragma mark 业务逻辑
#pragma mark 查询银行信息
- (void)queryCardDetail
{
    self.HUD = [SDMBProgressView showSDMBProgressOnlyLoadingINViewImg:self.view];
    [SDRequestHelp shareSDRequest].HUD = self.HUD;
    [SDRequestHelp shareSDRequest].controller = self;
    [[SDRequestHelp shareSDRequest] dispatchGlobalQuque:^{
        __block BOOL error = NO;
        paynuc.set("tTokenType", "01001101");
        [[SDRequestHelp shareSDRequest] requestWihtFuncName:@"token/getTtoken/v1" errorBlock:^(SDRequestErrorType type) {
            error = YES;
        } successBlock:^{
            
        }];
        if (error) return ;
        
        NSMutableDictionary *accountDic = [[NSMutableDictionary alloc] init];
        [accountDic setValue:@"03" forKey:@"kind"];
        [accountDic setValue:[NSString stringWithFormat:@"%@", bankCardNoStr] forKey:@"accNo"];
        NSString *account = [[PayNucHelper sharedInstance] dictionaryToJson:accountDic];
        [SDLog logTest:account];
        paynuc.set("account", [account UTF8String]);
        [[SDRequestHelp shareSDRequest] requestWihtFuncName:@"card/queryCardDetail/v1" errorBlock:^(SDRequestErrorType type) {
            error = YES;
            [[SDRequestHelp shareSDRequest] dispatchToMainQueue:^{
                if (type == respCodeErrorType) {
                    [self.navigationController popViewControllerAnimated:YES];
                }
            }];
        } successBlock:^{
            [[SDRequestHelp shareSDRequest] dispatchToMainQueue:^{
                [self.HUD hidden];
                
                NSString *payTool = [NSString stringWithUTF8String:paynuc.get("payTool").c_str()];
                NSDictionary *payToolDic = [[PayNucHelper sharedInstance] jsonStringToDictionary:payTool];
                BOOL fastPayFlag = [[payToolDic objectForKey:@"fastPayFlag"] boolValue];
                
                NSString *userInfo = [NSString stringWithUTF8String:paynuc.get("userInfo").c_str()];
                NSDictionary *userInfoDic = [[PayNucHelper sharedInstance] jsonStringToDictionary:userInfo];
                
                NSMutableDictionary *passDic = [[NSMutableDictionary alloc] init];
                [passDic setObject:userInfoDic forKey:@"userInfo"];
                [passDic setValue:payToolDic forKey:@"payTool"];
                
                [self getAuthTools];

                
            }];
        }];
        if (error) return ;
    }];
    
}


#pragma mark - 获取鉴权工具

/**
 *@brief 获取鉴权工具
 */
- (void)getAuthTools
{
    self.HUD = [SDMBProgressView showSDMBProgressOnlyLoadingINViewImg:self.view];
    [SDRequestHelp shareSDRequest].HUD = self.HUD;
    [SDRequestHelp shareSDRequest].controller = self;
    [[SDRequestHelp shareSDRequest] dispatchGlobalQuque:^{
        __block BOOL error = NO;
        [[SDRequestHelp shareSDRequest] requestWihtFuncName:@"authTool/getAuthTools/v1" errorBlock:^(SDRequestErrorType type) {
            error = YES;
        } successBlock:^{
            [[SDRequestHelp shareSDRequest] dispatchToMainQueue:^{
                [self.HUD hidden];
                
                NSString *tempAuthTools = [NSString stringWithUTF8String:paynuc.get("authTools").c_str()];
                NSArray *tempAuthToolsArray = [[PayNucHelper sharedInstance] jsonStringToArray:tempAuthTools];
                
                //1.取有效的鉴权工具 (贷记卡时,下发的payTools自带一个空鉴权,导致循环添加鉴权工具时,下移个groupViewHight)
                authToolsArray = [NSMutableArray arrayWithCapacity:0];
                for (int i = 0; i<authToolsArray.count; i++) {
                    if (!([[authToolsArray[i] objectForKey:@"type"] length]>0)) {
                        [authToolsArray removeObjectAtIndex:i];
                    }
                }
                for (int i = 0; i < tempAuthToolsArray.count; i++) {
                    [authToolsArray addObject:tempAuthToolsArray[i]];
                }
                
                if ([authToolsArray count] <= 0) {
                    [Tool showDialog:@"获取失败"];
                } else {
                   
                }
                
            }];
        }];
        if (error) return ;
        
    }];
    
}









- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
