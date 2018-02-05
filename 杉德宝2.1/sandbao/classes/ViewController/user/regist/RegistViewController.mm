//
//  RegistViewController.m
//  sandbao
//
//  Created by tianNanYiHao on 2017/10/17.
//  Copyright © 2017年 sand. All rights reserved.
//

#import "RegistViewController.h"
#import "PayNucHelper.h"

#import "DefaultWebViewController.h"
#import "SmsCheckViewController.h"
@interface RegistViewController ()
{
    SDBarButton *barButton;
    
}
@property (nonatomic, strong) NSString *phoneNoStr; //手机号
@property (nonatomic, strong) NSString *inviteCodeStr; //邀请码
@property (nonatomic, strong) NSArray *authToolsArray;  //鉴权工具组
@property (nonatomic, strong) NSArray *regAuthToolsArray; //待更新鉴权工具组
@end

@implementation RegistViewController


- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
    //流程每次进入均刷新
    //注册流程开始
    self.authToolsArray = nil;
    self.regAuthToolsArray = nil;
    [self getAuthToolsRegAuthTools];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self createUI];
    
    
    
}
#pragma mark - 重写父类-baseScrollView设置
- (void)setBaseScrollview{
    [super setBaseScrollview];
    
}
#pragma mark - 重写父类-导航设置方法
- (void)setNavCoverView{
    [super setNavCoverView];
    self.navCoverView.letfImgStr = @"login_icon_back";

    __weak RegistViewController *weakSelf = self;
    self.navCoverView.leftBlock = ^{
        [weakSelf.navigationController popViewControllerAnimated:YES];
    };
}
#pragma mark - 重写父类-点击方法集合
- (void)buttonClick:(UIButton *)btn{
    
    if (btn.tag == BTN_TAG_NEXT) {
        //下一步
        if (self.phoneNoStr.length > 0) {
            if (self.authToolsArray.count>0) {
                for (int i = 0; i<self.authToolsArray.count; i++) {
                    NSDictionary *authToolDic = self.authToolsArray[i];
                    if ([[authToolDic objectForKey:@"type"] isEqualToString:@"sms"]) {
                        SmsCheckViewController *smsVC = [[SmsCheckViewController alloc] init];
                        smsVC.phoneNoStr = self.phoneNoStr;
                        smsVC.smsCheckType = SMS_CHECKTYPE_REGIST;
                        smsVC.inviteCodeString = self.inviteCodeStr;
                        [self.navigationController pushViewController:smsVC animated:YES];
                    }else{
                        [Tool showDialog:@"下发鉴权工具有误"];
                    }
                }
            }else{
                [Tool showDialog:@"下发鉴权工具为空"];
            }
        }else{
            [Tool showDialog:@"请输入正确的登陆账号及密码"];
        }
    }
    if (btn.tag == BTN_TAG_LOGIN) {
        //返回- 登录页
        [self.navigationController popViewControllerAnimated:YES];
    }
    if (btn.tag == BTN_TAG_ENTERWEBVC) {
        //进入协议网页
        DefaultWebViewController *webVC = [[DefaultWebViewController alloc] init];
        webVC.requestStr = [NSString stringWithFormat:@"%@%@",AddressHTTP,ot_index];
        [self.navigationController pushViewController:webVC animated:YES];
    }
    
}

#pragma mark  - UI绘制
- (void)createUI{
    __weak typeof(self) weakself = self;
    //titleLab1
    UILabel *titleLab = [Tool createLable:@"输入你的手机号" attributeStr:nil font:FONT_28_Medium textColor:COLOR_343339 alignment:NSTextAlignmentCenter];
    [self.baseScrollView addSubview:titleLab];
    
    
    //PhoneAuthToolView
    PhoneAuthToolView *phoneAuthToolView = [PhoneAuthToolView createAuthToolViewOY:0];
    phoneAuthToolView.titleLab.text = @"你的手机号";
    phoneAuthToolView.textfiled.text = SHOWTOTEST(@"15151474188");
    phoneAuthToolView.textfiled.placeholder = @"输入手机号";
    phoneAuthToolView.tip.text = @"请输入正确手机号";
    phoneAuthToolView.successBlock = ^(NSString *textfieldText) {
        weakself.phoneNoStr = textfieldText;
    };
    [self.baseScrollView addSubview:phoneAuthToolView];
    
    
    InviteAuthToolView *inviteAuthToolView = [InviteAuthToolView createAuthToolViewOY:0];
    inviteAuthToolView.tip.text = @"请输入正确邀请码";
    inviteAuthToolView.successBlock = ^(NSString *textfieldText) {
        weakself.inviteCodeStr = textfieldText;
    };
    [self.baseScrollView addSubview:inviteAuthToolView];
    
    
    //服务协议
    NSMutableAttributedString *serverAttributeStr = [[NSMutableAttributedString alloc] initWithString:@"《杉德宝服务协议》"];
    [serverAttributeStr addAttributes:@{
                                     NSFontAttributeName:FONT_13_Regular,
                                     NSForegroundColorAttributeName:COLOR_358BEF
                                     } range:NSMakeRange(0, 9)];
    UIButton *serverBtn = [Tool createButton:@"" attributeStr:serverAttributeStr font:FONT_13_Regular textColor:COLOR_358BEF];
    serverBtn.tag = BTN_TAG_ENTERWEBVC;
    [serverBtn addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.baseScrollView addSubview:serverBtn];
    
    [serverBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(inviteAuthToolView.mas_bottom).offset(UPDOWNSPACE_0);
        make.right.equalTo(self.view.mas_right).offset(-LEFTRIGHTSPACE_40);
        make.size.mas_equalTo(serverBtn.size);
    }];
    
    //nextBtn
    barButton = [[SDBarButton alloc] init];
    UIView *nextBarbtn = [barButton createBarButton:@"继续" font:FONT_15_Regular titleColor:COLOR_FFFFFF backGroundColor:COLOR_58A5F6 leftSpace:LEFTRIGHTSPACE_40];
    barButton.btn.tag = BTN_TAG_NEXT;
    [barButton.btn addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.baseScrollView addSubview:nextBarbtn];
    
    //comeBackLogBtn
    NSMutableAttributedString *registAttributeStr = [[NSMutableAttributedString alloc] initWithString:@"已有账号, 立即登陆"];
    [registAttributeStr addAttributes:@{
                                        NSFontAttributeName:FONT_14_Regular,
                                        NSForegroundColorAttributeName:COLOR_358BEF
                                        } range:NSMakeRange(6, 4)];
    UIButton *comeBackLogBtn = [Tool createButton:@"" attributeStr:registAttributeStr font:FONT_14_Regular textColor:COLOR_343339_7];
    [comeBackLogBtn addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    comeBackLogBtn.tag = BTN_TAG_LOGIN;
    [self.baseScrollView addSubview:comeBackLogBtn];
    
    
    //frame
    [titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.baseScrollView.mas_top).offset(UPDOWNSPACE_64);
        make.centerX.equalTo(self.baseScrollView.mas_centerX);
        make.size.mas_equalTo(titleLab.size);
    }];
    
    
    [phoneAuthToolView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.baseScrollView.mas_centerX);
        make.top.equalTo(titleLab.mas_bottom).offset(UPDOWNSPACE_89);
        make.size.mas_equalTo(phoneAuthToolView.size);
    }];
    
    [inviteAuthToolView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(phoneAuthToolView.mas_bottom);
        make.centerX.equalTo(self.baseScrollView.mas_centerX);
        make.size.mas_equalTo(inviteAuthToolView.size);
    }];
    
    [nextBarbtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(inviteAuthToolView.mas_bottom).offset(UPDOWNSPACE_40);
        make.centerX.equalTo(self.baseScrollView.mas_centerX);
        make.size.mas_equalTo(nextBarbtn.size);
    }];
    
    [comeBackLogBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(nextBarbtn.mas_bottom).offset(UPDOWNSPACE_47);
        make.centerX.equalTo(self.baseScrollView.mas_centerX);
        make.size.mas_equalTo(comeBackLogBtn.size);
    }];
    
    //装载所有的textfiled
    self.textfiledArr = [NSMutableArray arrayWithArray:@[phoneAuthToolView.textfiled]];
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
#pragma mark 获取鉴权工具(authTools)/待注册鉴权工具(regAuthTools)
- (void)getAuthToolsRegAuthTools
{
    self.HUD = [SDMBProgressView showSDMBProgressOnlyLoadingINViewImg:self.view];
    [SDRequestHelp shareSDRequest].HUD = self.HUD;
    [SDRequestHelp shareSDRequest].controller = self;
    [[SDRequestHelp shareSDRequest] dispatchGlobalQuque:^{
        __block BOOL error = NO;
        
        [[SDRequestHelp shareSDRequest] requestWihtFuncName:@"token/getStoken/v1" errorBlock:^(SDRequestErrorType type) {
            error = YES;
        } successBlock:^{
            
        }];
        if (error) return ;
        
        
        
        paynuc.set("tTokenType", "01000101");
        paynuc.set("cfg_termFp", [[Tool setCfgTempFpStaticDataFlag:NO DynamicDataFlag:YES] UTF8String]);
        [[SDRequestHelp shareSDRequest] requestWihtFuncName:@"token/getTtoken/v1" errorBlock:^(SDRequestErrorType type) {
            error = YES;
        } successBlock:^{
            
        }];
        if (error) return ;
        
        
        [[SDRequestHelp shareSDRequest] requestWihtFuncName:@"authTool/getAuthTools/v1" errorBlock:^(SDRequestErrorType type) {
            error = YES;
        } successBlock:^{
            NSString *authTools = [NSString stringWithUTF8String:paynuc.get("authTools").c_str()];
            //获取鉴权工具集组
            self.authToolsArray = [[PayNucHelper sharedInstance] jsonStringToArray:authTools];
        }];
        if (error) return ;
        
        
        
        [[SDRequestHelp shareSDRequest] requestWihtFuncName:@"authTool/getRegAuthTools/v1" errorBlock:^(SDRequestErrorType type) {
            error = YES;
        } successBlock:^{
            [[SDRequestHelp shareSDRequest] dispatchToMainQueue:^{
                [self.HUD hidden];
                
                NSString *regAuthTools = [NSString stringWithUTF8String:paynuc.get("regAuthTools").c_str()];
                //获取待更新鉴权工具集组
                self.regAuthToolsArray = [[PayNucHelper sharedInstance] jsonStringToArray:regAuthTools];
                
                
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
