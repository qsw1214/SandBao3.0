//
//  PayPwdViewController.m
//  sandbao
//
//  Created by tianNanYiHao on 2017/10/19.
//  Copyright © 2017年 sand. All rights reserved.
//

#import "PayPwdViewController.h"
#import "PayNucHelper.h"


#define SIX_CODE_STATE_INPUT_FIRST 80001
#define SIX_CODE_STATE_INPUT_AGAIN 80002
#define SIX_CODE_STATE_CHECK_OK    80003

@interface PayPwdViewController ()
{
    //查询待注册鉴权工具
    NSArray *regAuthToolsArr;
    
    SDBarButton *barButton;
}
@property (nonatomic, assign) NSString *sixCodeStr; // 6位密码
@property (nonatomic, assign) NSInteger SIX_CODE_STATE;

@end

@implementation PayPwdViewController



- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    self.SIX_CODE_STATE = SIX_CODE_STATE_INPUT_FIRST;
    
    [self createUI];
    
    [self getRegAuthTools];
}


#pragma mark - 重写父类-baseScrollView设置
- (void)setBaseScrollview{
    [super setBaseScrollview];
    self.baseScrollView.frame = CGRectMake(0, UPDOWNSPACE_20, SCREEN_WIDTH, SCREEN_HEIGHT-UPDOWNSPACE_20);
    
}
#pragma mark - 重写父类-导航设置方法
- (void)setNavCoverView{
    [super setNavCoverView];

}
#pragma mark - 重写父类-点击方法集合
- (void)buttonClick:(UIButton *)btn{
    
    if (btn.tag == BTN_TAG_NEXT) {
        
        if (self.SIX_CODE_STATE == SIX_CODE_STATE_CHECK_OK) {
            //设置支付密码 - 上送鉴权
            [self setRegAuthTools];
        }
        
        if (self.SIX_CODE_STATE == SIX_CODE_STATE_INPUT_AGAIN) {
            [self.baseScrollView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
            [self createUI];
        }
        if (self.SIX_CODE_STATE == SIX_CODE_STATE_INPUT_FIRST) {
            [SDMBProgressView showSDMBProgressNormalINView:self.view lableText:@"两次密码不一致,请重新输入!"];
            [self.baseScrollView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
            [self createUI];
        }
    }
    
}


#pragma mark  - UI绘制
- (void)createUI{
    __weak typeof(self) weakself = self;
    
    //titleLab1
    UILabel *titleLab = [Tool createLable:@"设置支付密码" attributeStr:nil font:FONT_28_Medium textColor:COLOR_343339 alignment:NSTextAlignmentCenter];
    [self.baseScrollView addSubview:titleLab];
    
    //titleLab2
    UILabel *titleDesLab;
    if (self.SIX_CODE_STATE == SIX_CODE_STATE_INPUT_FIRST) {
        titleDesLab = [Tool createLable:@"输入6位数字支付密码" attributeStr:nil font:FONT_16_Regular textColor:COLOR_343339_7 alignment:NSTextAlignmentCenter];
    }
    if (self.SIX_CODE_STATE == SIX_CODE_STATE_INPUT_AGAIN) {
        titleDesLab = [Tool createLable:@"再次输入6位数字支付密码" attributeStr:nil font:FONT_16_Regular textColor:COLOR_343339_7 alignment:NSTextAlignmentCenter];
    }
    [self.baseScrollView addSubview:titleDesLab];
    
    //payCodeAuthTool:sixCodeAuthToolView
    SixCodeAuthToolView *payCodeAuthTool = [SixCodeAuthToolView createAuthToolViewOY:0];
    payCodeAuthTool.style = PayCodeAuthTool;
    payCodeAuthTool.successBlock = ^(NSString *textfieldText) {
        
        if (weakself.sixCodeStr.length == 0) {
            weakself.sixCodeStr = textfieldText;
            weakself.SIX_CODE_STATE = SIX_CODE_STATE_INPUT_AGAIN;
        }
        else if (weakself.sixCodeStr.length > 0) {
            if ([weakself.sixCodeStr isEqualToString:textfieldText]) {
                weakself.SIX_CODE_STATE = SIX_CODE_STATE_CHECK_OK;
            }else{
                weakself.SIX_CODE_STATE = SIX_CODE_STATE_INPUT_FIRST;
                weakself.sixCodeStr = nil;
            }
        }
    };
    [self.baseScrollView addSubview:payCodeAuthTool];
    
    
    //nextBtn
    barButton = [[SDBarButton alloc] init];
    UIView *nextBarbtn = [barButton createBarButton:@"继续" font:FONT_15_Regular titleColor:COLOR_FFFFFF backGroundColor:COLOR_58A5F6 leftSpace:LEFTRIGHTSPACE_40];
    barButton.btn.tag = BTN_TAG_NEXT;
    [barButton.btn addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
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

    [payCodeAuthTool mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(titleDesLab.mas_bottom).offset(UPDOWNSPACE_25);
        make.centerX.equalTo(self.baseScrollView.mas_centerX);
        make.size.mas_equalTo(payCodeAuthTool.size);
    }];
    
    [nextBarbtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(payCodeAuthTool.mas_bottom).offset(UPDOWNSPACE_40);
        make.centerX.equalTo(self.baseScrollView.mas_centerX);
        make.size.mas_equalTo(nextBarbtn.size);
    }];
    
    //装载所有的textfiled
    self.textfiledArr = [NSMutableArray arrayWithArray:@[payCodeAuthTool.noCopyTextfield]];
    for (int i = 0 ; i<self.textfiledArr.count; i++) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFieldChange:) name:UITextFieldTextDidEndEditingNotification object:self.textfiledArr[i]];
    }
}

- (void)textFieldChange:(NSNotification*)noti{
    
    //按钮置灰不可点击
    UITextField *currentTextField = (UITextField*)noti.object;
    if (currentTextField.text.length == 0) {
        [barButton changeState:NO];
    }
    
    //按钮高亮可点击
    NSMutableArray *tempArr = [NSMutableArray arrayWithCapacity:0];
    for (UITextField *t in self.textfiledArr) {
        if ([t.text length]>0) {
            [tempArr addObject:t];
        }
        if (tempArr.count == self.textfiledArr.count) {
            [barButton changeState:YES];
        }
    }
}

#pragma mark - 业务逻辑
#pragma mark 查询设置支付密码-鉴权工具
- (void)getRegAuthTools{
    self.HUD = [SDMBProgressView showSDMBProgressOnlyLoadingINViewImg:self.view];
    [SDRequestHelp shareSDRequest].HUD = self.HUD;
    [SDRequestHelp shareSDRequest].controller = self;
    [[SDRequestHelp shareSDRequest] dispatchGlobalQuque:^{
        __block BOOL error = NO;
        [[SDRequestHelp shareSDRequest] closedRespCpdeErrorAutomatic];
        [[SDRequestHelp shareSDRequest] requestWihtFuncName:@"authTool/getRegAuthTools/v1" errorBlock:^(SDRequestErrorType type) {
            error = YES;
            [[SDRequestHelp shareSDRequest] dispatchToMainQueue:^{
                [[SDRequestHelp shareSDRequest] openRespCpdeErrorAutomatic];
                if (type == frErrorType) {
                    [Tool showDialog:@"网络连接失败" message:@"进入杉德宝完成设置" defulBlock:^{
                        //归位Home或SpsLunch
                        [Tool setContentViewControllerWithHomeOrSpsLunchFromSideMenuViewController:self.sideMenuViewController];
                    }];
                }
                if (type == respCodeErrorType) {
                    [Tool showDialog:@"获取鉴权失败" message:@"进入杉德宝完成设置" defulBlock:^{
                        //归位Home或SpsLunch
                        [Tool setContentViewControllerWithHomeOrSpsLunchFromSideMenuViewController:self.sideMenuViewController];
                    }];
                }
            }];
        } successBlock:^{
            [[SDRequestHelp shareSDRequest] dispatchToMainQueue:^{
                [[SDRequestHelp shareSDRequest] openRespCpdeErrorAutomatic];
                [self.HUD hidden];
                
                NSString *regAuthTools = [NSString stringWithUTF8String:paynuc.get("regAuthTools").c_str()];
                regAuthToolsArr = [[PayNucHelper sharedInstance] jsonStringToArray:regAuthTools];
                
            }];
        }];
        if (error) return ;
    }];
}


#pragma mark 提交设置支付密码-鉴权工具
- (void)setRegAuthTools{
    
    self.HUD = [SDMBProgressView showSDMBProgressOnlyLoadingINViewImg:self.view];
    [SDRequestHelp shareSDRequest].HUD = self.HUD;
    [SDRequestHelp shareSDRequest].controller = self;
    [[SDRequestHelp shareSDRequest] dispatchGlobalQuque:^{
        __block BOOL error = NO;
        
        NSMutableArray *tempArray = [[NSMutableArray alloc] init];
        NSInteger index = 0;
        for (int i = 0; i<regAuthToolsArr.count; i++) {
            NSString *type = @"paypass";
            NSString *typeGet = [regAuthToolsArr[i] objectForKey:@"type"];
            if ([type isEqualToString:typeGet]) {
                index = i;
            }
        }
        
        NSMutableDictionary *authToolDict = regAuthToolsArr[index];
        NSMutableDictionary *authToolsDic = [NSMutableDictionary dictionaryWithDictionary:authToolDict];
        //[authToolsDic removeObjectForKey:@"pass"];
        NSMutableDictionary *passDic = [[NSMutableDictionary alloc] init];
        [passDic setValue:[[PayNucHelper sharedInstance] pinenc:self.sixCodeStr type:@"paypass"] forKey:@"password"];
        [passDic setValue:@"sand" forKey:@"encryptType"];
        [authToolsDic setObject:passDic forKey:@"pass"];
        [tempArray addObject:authToolsDic];
        NSString *regAuthTools = [[PayNucHelper sharedInstance] arrayToJSON:tempArray];
        
        paynuc.set("regAuthTools", [regAuthTools UTF8String]);
        [[SDRequestHelp shareSDRequest] closedRespCpdeErrorAutomatic];
        [[SDRequestHelp shareSDRequest] requestWihtFuncName:@"authTool/setRegAuthTools/v1" errorBlock:^(SDRequestErrorType type) {
            error = YES;
            [[SDRequestHelp shareSDRequest] dispatchToMainQueue:^{
                [[SDRequestHelp shareSDRequest] openRespCpdeErrorAutomatic];
                if (type == frErrorType) {
                     [Tool showDialog:@"网络连接失败" message:@"进入杉德宝完成设置" defulBlock:^{
                        //归位Home或SpsLunch
                        [Tool setContentViewControllerWithHomeOrSpsLunchFromSideMenuViewController:self.sideMenuViewController];
                        
                    }];
                }
                if (type == respCodeErrorType) {
                     [Tool showDialog:@"密码提交失败" message:@"进入杉德宝完成设置" defulBlock:^{
                        //归位Home或SpsLunch
                        [Tool setContentViewControllerWithHomeOrSpsLunchFromSideMenuViewController:self.sideMenuViewController];
                    }];
                }
            }];
        } successBlock:^{
            [[SDRequestHelp shareSDRequest] dispatchToMainQueue:^{
                [[SDRequestHelp shareSDRequest] openRespCpdeErrorAutomatic];
                [self.HUD hidden];
                
                [Tool showDialog:@"支付密码设置成功" defulBlock:^{
                    [CommParameter sharedInstance].payPassFlag = YES;
                    
                    //拉取ownPayTools
                    [self ownPayTools_rigest];
                }];
                
            }];
        }];
        if (error) return ;
    }];
}

/**
 更新我方支付工具_注册模式
 */
- (void)ownPayTools_rigest
{
    self.HUD = [SDMBProgressView showSDMBProgressOnlyLoadingINViewImg:self.view];
    [SDRequestHelp shareSDRequest].self.HUD = self.HUD;
    [SDRequestHelp shareSDRequest].controller = self;
    [[SDRequestHelp shareSDRequest] dispatchGlobalQuque:^{
        __block BOOL error = NO;
        
        paynuc.set("tTokenType", "01001501");
        paynuc.set("cfg_termFp", [[Tool setCfgTempFpStaticDataFlag:NO DynamicDataFlag:YES] UTF8String]);
        [[SDRequestHelp shareSDRequest] requestWihtFuncName:@"token/getTtoken/v1" errorBlock:^(SDRequestErrorType type) {
            error = YES;
            [[SDRequestHelp shareSDRequest] dispatchToMainQueue:^{
                //归位Home或SpsLunch
                [Tool setContentViewControllerWithHomeOrSpsLunchFromSideMenuViewController:self.sideMenuViewController];
            }];
        } successBlock:^{
            
        }];
        if (error) return ;
        
        
        paynuc.set("payToolKinds", "[]");
        [[SDRequestHelp shareSDRequest] requestWihtFuncName:@"payTool/getOwnPayTools/v1" errorBlock:^(SDRequestErrorType type) {
            error = YES;
            [[SDRequestHelp shareSDRequest] dispatchToMainQueue:^{
                //归位Home或SpsLunch
                [Tool setContentViewControllerWithHomeOrSpsLunchFromSideMenuViewController:self.sideMenuViewController];
            }];
        } successBlock:^{
            [[SDRequestHelp shareSDRequest] dispatchToMainQueue:^{
                [self.HUD hidden];
                
                NSArray *payToolsArray = [[PayNucHelper sharedInstance] jsonStringToArray:[NSString stringWithUTF8String:paynuc.get("payTools").c_str()]];
                //根据order 字段排序
                payToolsArray = [Tool orderForPayTools:payToolsArray];
                [CommParameter sharedInstance].ownPayToolsArray = payToolsArray;
                
                //归位Home或SpsLunch
                [Tool setContentViewControllerWithHomeOrSpsLunchFromSideMenuViewController:self.sideMenuViewController];
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
