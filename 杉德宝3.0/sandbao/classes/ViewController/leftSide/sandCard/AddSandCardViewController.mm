//
//  AddSandCardViewController.m
//  sandbao
//
//  Created by tianNanYiHao on 2017/11/17.
//  Copyright © 2017年 sand. All rights reserved.
//

#import "AddSandCardViewController.h"
#import "PayNucHelper.h"


@interface AddSandCardViewController ()
{
 
}
@property (nonatomic, strong) NSString *sandCardNoStr;
@property (nonatomic, strong) NSString *sandCardCodeStr;  //校验码
@property (nonatomic, strong) NSString *sandCardCodeCheckStr; //再次输入校验码

@property (nonatomic, strong) UIButton *bottomBtn;

@end

@implementation AddSandCardViewController

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    //绑卡_查询鉴权工具
    [self bingding_getAuthTools];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self createUI];
    
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
    self.navCoverView.midTitleStr = @"添加杉德卡";
    
    __weak AddSandCardViewController *weakSelf = self;
    self.navCoverView.leftBlock = ^{
        [weakSelf.navigationController popViewControllerAnimated:YES];
    };
    
    self.navCoverView.rightBlock = ^{
        
    };
    
}
#pragma mark - 重写父类-点击方法集合
- (void)buttonClick:(UIButton *)btn{
    
    if (btn.tag == BTN_TAG_BINDSANDCARD) {
        if (self.sandCardNoStr.length>0 && self.sandCardCodeStr.length>0 && self.sandCardCodeCheckStr.length>0) {
            
            //两次输入一致
            if ([self.sandCardCodeStr isEqualToString:self.sandCardCodeCheckStr]) {
                //绑定杉德卡
                [self bindingSandCard];
            }
            
        }else{
            [Tool showDialog:@"请完成卡信息填写"];
        }
    }
    
}

#pragma mark  - UI绘制
- (void)createUI{
    
    __weak typeof(self) weakself = self;
    
    //sandCardNoView
    CardNoAuthToolView *sandCardNoView = [CardNoAuthToolView createAuthToolViewOY:0];
    sandCardNoView.backgroundColor = [UIColor whiteColor];
    sandCardNoView.titleLab.text = @"杉德卡卡号";
    sandCardNoView.tip.text = @"请输入正确杉德卡卡号";
    sandCardNoView.textfiled.placeholder = @"请输入杉德卡卡号";
    sandCardNoView.textfiled.text = SHOWTOTEST(@"7280000100004581");
    self.sandCardNoStr = SHOWTOTEST(@"7280000100004581");
    sandCardNoView.successBlock = ^(NSString *textfieldText) {
        weakself.sandCardNoStr = textfieldText;
    };
    [self.baseScrollView addSubview:sandCardNoView];
    
    //sandCardCodeView
    PwdAuthToolView *sandCardCodeView = [PwdAuthToolView createAuthToolViewOY:0];
    sandCardCodeView.type = PwdAuthToolSandPayPwdType;
    sandCardCodeView.backgroundColor = [UIColor whiteColor];
    sandCardCodeView.titleLab.text = @"卡片校验码";
    sandCardCodeView.textfiled.placeholder  = @"请输入卡片校验码";
    sandCardCodeView.tip.text = @"请输入正确的卡片校验码";
    sandCardCodeView.textfiled.text = SHOWTOTEST(@"728060");
    self.sandCardCodeStr = SHOWTOTEST(@"728060");
    sandCardCodeView.successBlock = ^(NSString *textfieldText) {
        weakself.sandCardCodeStr = textfieldText;
    };
    [self.baseScrollView addSubview:sandCardCodeView];
    
    
    //sandCardCodeCheckView
    PwdAuthToolView *sandCardCodeCheckView = [PwdAuthToolView createAuthToolViewOY:0];
    sandCardCodeCheckView.type = PwdAuthToolSandPayPwdType;
    sandCardCodeCheckView.backgroundColor = [UIColor whiteColor];
    sandCardCodeCheckView.titleLab.text = @"确认校验码";
    sandCardCodeCheckView.textfiled.placeholder = @"请输入卡片校验码";
    sandCardCodeCheckView.tip.text = @"请输入正确的卡片校验码";
    sandCardCodeCheckView.textfiled.text = SHOWTOTEST(@"728060");
    self.sandCardCodeCheckStr = SHOWTOTEST(@"728060");
    sandCardCodeCheckView.successBlock = ^(NSString *textfieldText) {
        weakself.sandCardCodeCheckStr = textfieldText;
    };
    [self.baseScrollView addSubview:sandCardCodeCheckView];
    
    
    //bottomBtn
    self.bottomBtn = [Tool createButton:@"绑定" attributeStr:nil font:FONT_14_Regular textColor:COLOR_FFFFFF];
    self.bottomBtn.backgroundColor = COLOR_58A5F6;
    self.bottomBtn.tag = BTN_TAG_BINDSANDCARD;
    [self.bottomBtn addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.bottomBtn];
    self.bottomBtn.height = UPDOWNSPACE_64;
    
    
    
    [sandCardNoView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.baseScrollView.mas_top).offset(UPDOWNSPACE_10);
        make.centerX.equalTo(self.baseScrollView);
        make.size.mas_equalTo(sandCardNoView.size);
    }];
    
    [sandCardCodeView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(sandCardNoView.mas_bottom);
        make.centerX.equalTo(self.baseScrollView);
        make.size.mas_equalTo(sandCardCodeView.size);
    }];
    
    [sandCardCodeCheckView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(sandCardCodeView.mas_bottom);
        make.centerX.equalTo(self.baseScrollView);
        make.size.mas_equalTo(sandCardCodeCheckView.size);
    }];
    
    [self.bottomBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.baseScrollView);
        make.bottom.equalTo(self.view.mas_bottom).offset(UPDOWNSPACE_0);
        make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH, self.bottomBtn.height));
    }];
    
    
}


#pragma mark - 业务逻辑
#pragma mark 绑卡_查询鉴权工具
- (void)bingding_getAuthTools
{
    self.HUD = [SDMBProgressView showSDMBProgressOnlyLoadingINViewImg:self.view];
    [SDRequestHelp shareSDRequest].HUD = self.HUD;
    [SDRequestHelp shareSDRequest].controller = self;
    [[SDRequestHelp shareSDRequest] dispatchGlobalQuque:^{
        __block BOOL error = NO;
        paynuc.set("tTokenType", "01001701");
        paynuc.set("cfg_termFp", [[Tool setCfgTempFp:YES] UTF8String]);
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
                
//                NSString *tempAuthTools = [NSString stringWithUTF8String:paynuc.get("authTools").c_str()];
//                NSArray *tempAuthToolsArray = [[PayNucHelper sharedInstance] jsonStringToArray:tempAuthTools];
                
            }];
        }];
        if (error) return ;
    }];
    
}

#pragma mark - 绑定杉德卡
- (void)bindingSandCard
{
    self.HUD = [SDMBProgressView showSDMBProgressOnlyLoadingINViewImg:self.view];
    [SDRequestHelp shareSDRequest].HUD = self.HUD;
    [SDRequestHelp shareSDRequest].controller = self;
    [[SDRequestHelp shareSDRequest] dispatchGlobalQuque:^{
        __block BOOL error = NO;
        NSMutableArray *authToolsArray1 = [[NSMutableArray alloc] init];
        NSMutableDictionary *authToolDic = [[NSMutableDictionary alloc] init];
        [authToolDic setValue:@"cardCheckCode" forKey:@"type"];
        [authToolDic setValue:self.sandCardCodeStr forKey:@"cardCheckCode"];
        [authToolsArray1 addObject:authToolDic];
        NSString *authTools = [[PayNucHelper sharedInstance] arrayToJSON:authToolsArray1];
        
        paynuc.set("authTools", [authTools UTF8String]);
        
        
        //账户
        NSMutableDictionary *payToolDic = [[NSMutableDictionary alloc] init];
        NSMutableDictionary *accountDic = [[NSMutableDictionary alloc] init];
        [accountDic setValue:self.sandCardNoStr forKey:@"accNo"];
        [accountDic setValue:@"02" forKey:@"kind"];
        [payToolDic setValue:@"1003" forKey:@"type"];
        [payToolDic setObject:accountDic forKey:@"account"];
        
        NSString *payTool = [[PayNucHelper sharedInstance] dictionaryToJson:payToolDic];
        
        paynuc.set("payTool", [payTool UTF8String]);
        paynuc.set("userInfo", [[CommParameter sharedInstance].userInfo UTF8String]);
        paynuc.set("authTools", [authTools UTF8String]);
        [[SDRequestHelp shareSDRequest] requestWihtFuncName:@"card/bandCard/v1" errorBlock:^(SDRequestErrorType type) {
            error = YES;
        } successBlock:^{
            [[SDRequestHelp shareSDRequest] dispatchToMainQueue:^{
                [self.HUD hidden];
                [Tool showDialog:@"绑卡成功" defulBlock:^{
                    [self.navigationController popViewControllerAnimated:YES];
                    
                }];
            }];
        }];
        if (error) return ;
    }];
    
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
