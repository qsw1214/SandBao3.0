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
 
    CardNoAuthToolView *cardNoAuthToolView;
    UIButton *nextBarbtn;
    
    NSDictionary *payToolDic;   //支付工具字典
    NSDictionary *userInfoDic;  //用户信息字典
    
    NSArray *appendUIArr;        //保存追加UI的子view
    
    
}
@property (nonatomic, strong) NSString *realNameStr;  //真实姓名
@property (nonatomic, strong) NSString *bankCardNoStr;  //银行卡号
@property (nonatomic, strong) NSString *identityNoStr;  //真实姓名
@property (nonatomic, strong) NSString *bankPhoneNoStr; //银行预留手机号


@end

@implementation RealNameViewController
@synthesize realNameStr;
@synthesize bankCardNoStr;
@synthesize identityNoStr;
@synthesize bankPhoneNoStr;


- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    //清空追加的UI及数据
    [self removeAppendUI];
}

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

#pragma mark - 重写父类-baseScrollView设置
- (void)setBaseScrollview{
    [super setBaseScrollview];
    self.baseScrollView.frame = CGRectMake(0, UPDOWNSPACE_20, SCREEN_WIDTH, SCREEN_HEIGHT-UPDOWNSPACE_20);
    
}
#pragma mark - 重写父类-导航设置方法
- (void)setNavCoverView{
    [super setNavCoverView];
    self.navCoverView.hidden = YES;
    
}
#pragma mark - 重写父类-点击方法集合
- (void)buttonClick:(UIButton *)btn{
    if (btn.tag == BTN_TAG_SHOWBANKLIST) {
        NSLog(@"点击了 支持银行 按钮");
    }
    if (btn.tag == BTN_TAG_NEXT) {
        //下一步 - 实名验证手机号
        if (realNameStr.length>0 && identityNoStr.length>0 && bankCardNoStr.length>0) {
            [self queryCardDetail];
            
        }else{
            [Tool showDialog:@"请输入完整验证信息"];
        }
    }
    if (btn.tag == BTN_TAG_REALNAME) {
        if (realNameStr.length>0 && identityNoStr.length>0 && bankCardNoStr.length>0 && bankPhoneNoStr.length>0) {
            [self getAuthTools];
        }
        else{
            [Tool showDialog:@"请输入完整验证信息"];
        }
    }
}

#pragma mark  - UI绘制
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
    nameAuthToolView.textfiled.text = SHOWTOTEST(@"刘斐斐");
    realNameStr = SHOWTOTEST(@"刘斐斐");
    nameAuthToolView.successBlock = ^(NSString *textfieldText) {
        realNameStr = textfieldText;
    };
    [self.baseScrollView addSubview:nameAuthToolView];
    
    //identityAuthToolView
    IdentityAuthToolView *identityAuthToolView = [IdentityAuthToolView createAuthToolViewOY:0];
    identityAuthToolView.tip.text = @"请输入有效身份证件号";
    identityAuthToolView.textfiled.text = SHOWTOTEST(@"320981199001053212");
    identityNoStr = SHOWTOTEST(@"320981199001053212");
    identityAuthToolView.successBlock = ^(NSString *textfieldText) {
        identityNoStr = textfieldText;
    };
    [self.baseScrollView addSubview:identityAuthToolView];
    
    //cardNoAuthToolView
    cardNoAuthToolView = [CardNoAuthToolView createAuthToolViewOY:0];
    cardNoAuthToolView.tip.text = @"请输入有效银行卡卡号";
    cardNoAuthToolView.textfiled.text = SHOWTOTEST(@"6217001210062891245");
    bankCardNoStr = SHOWTOTEST(@"6217001210062891245");
    cardNoAuthToolView.successBlock = ^(NSString *textfieldText) {
        bankCardNoStr = textfieldText;
    };
    [self.baseScrollView addSubview:cardNoAuthToolView];
    
    
    //nextBtn
    nextBarbtn = [Tool createBarButton:@"继续" font:FONT_15_Regular titleColor:COLOR_FFFFFF backGroundColor:COLOR_58A5F6 leftSpace:LEFTRIGHTSPACE_40];
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
    

    [nextBarbtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(cardNoAuthToolView.mas_bottom).offset(UPDOWNSPACE_15);
        make.centerX.equalTo(self.baseScrollView.mas_centerX);
        make.size.mas_equalTo(nextBarbtn.size);
    }];
    
}

//查询银行卡后,追加UI
- (void)appendUI{
    
    
    //bankAuthToolView
    BankAuthToolView *bankAuthToolView = [BankAuthToolView createAuthToolViewOY:0];
    bankAuthToolView.chooseBankTitleLab.text = [payToolDic objectForKey:@"title"];
    bankAuthToolView.userInteractionEnabled = NO;
    [self.baseScrollView addSubview:bankAuthToolView];

    //bankPhoneNoAuthToolView
    PhoneAuthToolView *bankPhoneNoAuthToolView = [PhoneAuthToolView createAuthToolViewOY:0];
    bankPhoneNoAuthToolView.titleLab.text = @"银行预留手机号";
    bankPhoneNoAuthToolView.tip.text = @"请输入正确的银行预留手机号";
    bankPhoneNoAuthToolView.successBlock = ^(NSString *textfieldText) {
        bankPhoneNoStr = textfieldText;
    };
    [self.baseScrollView addSubview:bankPhoneNoAuthToolView];

    //moreBankListBtn
    UIButton *moreBankListBtn = [Tool createButton:@"支持银行" attributeStr:nil font:FONT_14_Regular textColor:COLOR_343339_7];
    moreBankListBtn.tag = BTN_TAG_SHOWBANKLIST;
    [moreBankListBtn setImage:[UIImage imageNamed:@"general_icon_detail"] forState:UIControlStateNormal];
    CGSize moreBankListBtnSize = [moreBankListBtn sizeThatFits:CGSizeZero];
    [self.baseScrollView addSubview:moreBankListBtn];
    
    [bankAuthToolView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(cardNoAuthToolView.mas_bottom).offset(UPDOWNSPACE_0);
        make.centerX.equalTo(self.baseScrollView);
        make.size.mas_equalTo(bankAuthToolView.size);
    }];

    [bankPhoneNoAuthToolView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(bankAuthToolView.mas_bottom).offset(UPDOWNSPACE_0);
        make.centerX.equalTo(self.baseScrollView);
        make.size.mas_equalTo(bankPhoneNoAuthToolView.size);
    }];

    [moreBankListBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(bankPhoneNoAuthToolView.mas_bottom).offset(UPDOWNSPACE_25);
        make.right.equalTo(bankPhoneNoAuthToolView.mas_right).offset(-LEFTRIGHTSPACE_40);
        make.size.mas_equalTo(moreBankListBtnSize);
    }];
    
    nextBarbtn.tag = BTN_TAG_REALNAME;
    [nextBarbtn mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(moreBankListBtn.mas_bottom).offset(UPDOWNSPACE_25);
        make.centerX.equalTo(self.baseScrollView.mas_centerX);
        make.size.mas_equalTo(nextBarbtn.size);
    }];
    
    
    //重置contentSize
    CGFloat appendViewHeight = bankAuthToolView.height + bankPhoneNoAuthToolView.height + moreBankListBtn.height + UPDOWNSPACE_25 + UPDOWNSPACE_25;
    self.baseScrollView.contentSize = CGSizeMake(self.baseScrollView.contentSize.width, self.baseScrollView.contentSize.height + appendViewHeight);
    
    //保存追加的UI子View
    appendUIArr = @[bankAuthToolView,bankPhoneNoAuthToolView,moreBankListBtn];
    
}

//删除追加的UI及清空数据
- (void)removeAppendUI{
    
    if (appendUIArr.count > 0) {
        //删除追加的UI
        [appendUIArr makeObjectsPerformSelector:@selector(removeFromSuperview)];
        //清空 数组
        appendUIArr = nil;
        //清空 银行卡 及 手机号信息
        bankPhoneNoStr = nil;
        
        //重置约束
        nextBarbtn.tag = BTN_TAG_NEXT;
        [nextBarbtn mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(cardNoAuthToolView.mas_bottom).offset(UPDOWNSPACE_15);
            make.centerX.equalTo(self.baseScrollView.mas_centerX);
            make.size.mas_equalTo(nextBarbtn.size);
        }];
    }
    
}


#pragma mark - 业务逻辑
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
             
        } successBlock:^{
            [[SDRequestHelp shareSDRequest] dispatchToMainQueue:^{
                [self.HUD hidden];
                
                NSString *payTool = [NSString stringWithUTF8String:paynuc.get("payTool").c_str()];
                payToolDic = [[PayNucHelper sharedInstance] jsonStringToDictionary:payTool];

                NSString *userInfo = [NSString stringWithUTF8String:paynuc.get("userInfo").c_str()];
                userInfoDic = [[PayNucHelper sharedInstance] jsonStringToDictionary:userInfo];
                
                NSMutableArray *payTool_authToolsArr = [payToolDic objectForKey:@"authTools"];
                //信用卡
                if (payTool_authToolsArr.count > 0) {
                    //暂不处理
                    [Tool showDialog:@"暂不支持信用卡绑定"];
                }
                //借记卡
                else{
                    //追加UI
                    [self appendUI];
                }
                
            }];
        }];
        if (error) return ;
    }];
    
}


#pragma mark 获取鉴权工具

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
                
                if (tempAuthToolsArray.count>0) {
                    for (int i = 0; i<tempAuthToolsArray.count; i++) {
                        NSDictionary *authToolDic = tempAuthToolsArray[i];
                        if ([[authToolDic objectForKey:@"type"] isEqualToString:@"sms"]) {
                            SmsCheckViewController *smsVC = [[SmsCheckViewController alloc] init];
                            smsVC.payToolDic = payToolDic;
                            smsVC.userInfoDic = userInfoDic;
                            smsVC.phoneNoStr = bankPhoneNoStr;
                            smsVC.identityNoStr = identityNoStr;
                            smsVC.realNameStr = realNameStr;
                            smsVC.bankCardNoStr = bankCardNoStr;
                            smsVC.smsCheckType = SMS_CHECKTYPE_REALNAME;
                            [self.navigationController pushViewController:smsVC animated:YES];
                        }
                    }
                }else{
                    [Tool showDialog:@"下发鉴权工具为空"];
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
