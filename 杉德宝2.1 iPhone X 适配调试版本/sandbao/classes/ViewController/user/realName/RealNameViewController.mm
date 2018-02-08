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

typedef NS_ENUM(NSInteger,BankCardType) {
    
    debitCard = 0, //借记卡
    creditCard,    //贷记卡
    
};


@interface RealNameViewController ()
{
    
    //记录原有的视图高度
    CGFloat originalViewHeight;
    //记录增加的视图的高度
    CGFloat appendViewHeight;
 
    CardNoAuthToolView *cardNoAuthToolView;
    BankAuthToolView *bankAuthToolView;
    ValidAuthToolView *validAuthToolView;
    CvnAuthToolView *cvnAuthToolView;
    
    UIView *nextBarbtn;
    
    NSDictionary *payToolDic;   //支付工具字典
    
    NSDictionary *userInfoDic;  //用户信息字典
    
    NSArray *appendUIArr;        //保存追加UI的子vie
    
    
}
@property (nonatomic, strong) NSString *realNameStr;  //真实姓名
@property (nonatomic, strong) NSString *bankCardNoStr;  //银行卡号
@property (nonatomic, strong) NSString *identityNoStr;  //真实姓名
@property (nonatomic, strong) NSString *bankPhoneNoStr; //银行预留手机号
@property (nonatomic, strong) NSString *validStr;       //卡有效期
@property (nonatomic, strong) NSString *cvnStr;       //cvn
@property (nonatomic, strong) SDBarButton *barButton;

@end

@implementation RealNameViewController

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];

    //记录未追加视图前的滚动视图高度
    originalViewHeight = SCREEN_HEIGHT;
    
    
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    //清空追加的UI及数据
    [self removeAppendUI];
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
    self.navCoverView.letfImgStr = @"login_icon_back";
    __weak RealNameViewController *weakSelf = self;
    self.navCoverView.leftBlock = ^{
        [Tool showDialog:@"您还未实名" message:@"是否放弃实名" leftBtnString:@"继续实名" rightBtnString:@"退出杉德宝" leftBlock:^{
            //do no thing
        } rightBlock:^{
            [Tool setContentViewControllerWithLoginFromSideMentuVIewController:weakSelf forLogOut:YES];
        }];
    };
}
#pragma mark - 重写父类-点击方法集合
- (void)buttonClick:(UIButton *)btn{
    if (btn.tag == BTN_TAG_NEXT) {
        //下一步 - 实名验证手机号
        if (self.realNameStr.length>0 && self.identityNoStr.length>0 && self.bankCardNoStr.length>0) {
            [self queryCardDetail];
        }else{
            [Tool showDialog:@"请输入完整验证信息"];
        }
    }
    if (btn.tag == BTN_TAG_REALNAME) {
        if (self.validStr.length>0 ) {
            if (self.realNameStr.length>0 && self.identityNoStr.length>0 && self.bankCardNoStr.length>0 && self.bankPhoneNoStr.length>0 && self.validStr.length>0 && self.cvnStr.length>0) {
                [self getAuthTools];
            }else{
               [Tool showDialog:@"请输入完整验证信息"];
            }
        }else{
            if (self.realNameStr.length>0 && self.identityNoStr.length>0 && self.bankCardNoStr.length>0 && self.bankPhoneNoStr.length>0) {
                [self getAuthTools];
            }
            else{
                [Tool showDialog:@"请输入完整验证信息"];
            }
        }
    }
}

#pragma mark  - UI绘制
- (void)createUI{
    __weak typeof(self) weakself = self;
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
    self.realNameStr = SHOWTOTEST(@"刘斐斐");
    nameAuthToolView.successBlock = ^(NSString *textfieldText) {
        weakself.realNameStr = textfieldText;
    };
    [self.baseScrollView addSubview:nameAuthToolView];
    
    //identityAuthToolView
    IdentityAuthToolView *identityAuthToolView = [IdentityAuthToolView createAuthToolViewOY:0];
    identityAuthToolView.tip.text = @"请输入有效身份证件号";
    identityAuthToolView.textfiled.text = SHOWTOTEST(@"320981199001053212");
    self.identityNoStr = SHOWTOTEST(@"320981199001053212");
    identityAuthToolView.successBlock = ^(NSString *textfieldText) {
        weakself.identityNoStr = textfieldText;
    };
    [self.baseScrollView addSubview:identityAuthToolView];
    
    //cardNoAuthToolView
    cardNoAuthToolView = [CardNoAuthToolView createAuthToolViewOY:0];
    cardNoAuthToolView.tip.text = @"请输入有效银行卡卡号";
    cardNoAuthToolView.textfiled.text = SHOWTOTEST(@"6225768740054778");//6225768740054778 // w 6212261001042568540
    self.bankCardNoStr = SHOWTOTEST(@"6225768740054778");
    cardNoAuthToolView.successBlock = ^(NSString *textfieldText) {
        weakself.bankCardNoStr = textfieldText;
        //删除追加的UI
        [weakself removeAppendUI];
    };
    [self.baseScrollView addSubview:cardNoAuthToolView];
    
    
    //nextBtn
    self.barButton = [[SDBarButton alloc] init];
    nextBarbtn = [self.barButton createBarButton:@"继续" font:FONT_15_Regular titleColor:COLOR_FFFFFF backGroundColor:COLOR_58A5F6 leftSpace:LEFTRIGHTSPACE_40];
    self.barButton.btn.tag = BTN_TAG_NEXT;
    [self.barButton.btn addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
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

    //装载所有的textfiled
    self.textfiledArr = [NSMutableArray arrayWithArray:@[nameAuthToolView.textfiled,identityAuthToolView.textfiled,cardNoAuthToolView.textfiled]];
    for (int i = 0 ; i<self.textfiledArr.count; i++) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFieldChange:) name:UITextFieldTextDidEndEditingNotification object:self.textfiledArr[i]];
    }
    
    
}

- (void)textFieldChange:(NSNotification*)noti{
    
    //按钮置灰不可点击
    UITextField *currentTextField = (UITextField*)noti.object;
    if (currentTextField.text.length == 0) {
        [self.barButton changeState:NO];
    }
    
    //按钮高亮可点击
    NSMutableArray *tempArr = [NSMutableArray arrayWithCapacity:0];
    for (UITextField *t in self.textfiledArr) {
        if ([t.text length]>0) {
            [tempArr addObject:t];
        }
        if (tempArr.count == self.textfiledArr.count) {
            [self.barButton changeState:YES];
        }
    }
}
//查询银行卡后,追加UI
- (void)appendUI:(BankCardType)cardType{
    __weak typeof(self) weakself = self;
    
    [self.barButton changeState:NO];
    
    //bankAuthToolView
    bankAuthToolView = [BankAuthToolView createAuthToolViewOY:0];
    bankAuthToolView.titleLab.text = @"该卡所属银行";
    bankAuthToolView.chooseBankTitleLab.text = [payToolDic objectForKey:@"title"];
    bankAuthToolView.userInteractionEnabled = NO;
    [self.baseScrollView addSubview:bankAuthToolView];

    //bankPhoneNoAuthToolView
    PhoneAuthToolView *bankPhoneNoAuthToolView = [PhoneAuthToolView createAuthToolViewOY:0];
    bankPhoneNoAuthToolView.titleLab.text = @"银行预留手机号";
    bankPhoneNoAuthToolView.tip.text = @"请输入正确的银行预留手机号";
    bankPhoneNoAuthToolView.successBlock = ^(NSString *textfieldText) {
        weakself.bankPhoneNoStr = textfieldText;
    };
    [self.baseScrollView addSubview:bankPhoneNoAuthToolView];
    
    [self.textfiledArr addObject:bankPhoneNoAuthToolView.textfiled];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFieldChange:) name:UITextFieldTextDidEndEditingNotification object:bankPhoneNoAuthToolView.textfiled];
    
    //如果是信用卡 - 创建信用卡相关视图
    if (cardType == creditCard) {
        validAuthToolView = [ValidAuthToolView createAuthToolViewOY:0];
        validAuthToolView.tip.text = @"请输入正确有效期";
        validAuthToolView.successBlock = ^(NSString *textfieldText) {
            weakself.validStr = textfieldText;
            [weakself.barButton changeState:YES];
        };
        [self.baseScrollView addSubview:validAuthToolView];
        [self.textfiledArr addObject:validAuthToolView.textfiled];
        //有效期由于特殊输入方式(pickerView,故不参与监听)
        
        cvnAuthToolView = [CvnAuthToolView createAuthToolViewOY:0];
        cvnAuthToolView.tip.text = @"请输入正确CVN";
        cvnAuthToolView.successBlock = ^(NSString *textfieldText) {
            weakself.cvnStr = textfieldText;
        };
        [self.baseScrollView addSubview:cvnAuthToolView];
        [self.textfiledArr addObject:cvnAuthToolView.textfiled];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFieldChange:) name:UITextFieldTextDidEndEditingNotification object:cvnAuthToolView.textfiled];
    }
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
    
    if (cardType == creditCard) {
        [validAuthToolView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(bankPhoneNoAuthToolView.mas_bottom).offset(UPDOWNSPACE_0);
            make.centerX.equalTo(self.baseScrollView);
            make.size.mas_equalTo(validAuthToolView.size);
        }];
        [cvnAuthToolView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(validAuthToolView.mas_bottom).offset(UPDOWNSPACE_0);
            make.centerX.equalTo(self.baseScrollView);
            make.size.mas_equalTo(cvnAuthToolView.size);
        }];
    }
    
    self.barButton.btn.tag = BTN_TAG_REALNAME;
    [nextBarbtn mas_remakeConstraints:^(MASConstraintMaker *make) {
        if (cardType == creditCard) {
            make.top.equalTo(cvnAuthToolView.mas_bottom).offset(UPDOWNSPACE_25);
        }else{
            make.top.equalTo(bankPhoneNoAuthToolView.mas_bottom).offset(UPDOWNSPACE_25);
        }
        make.centerX.equalTo(self.baseScrollView.mas_centerX);
        make.size.mas_equalTo(nextBarbtn.size);
    }];
    
    
    
    if (cardType == creditCard) {
        //重置contentSize
        appendViewHeight = bankAuthToolView.height + bankPhoneNoAuthToolView.height + validAuthToolView.height + cvnAuthToolView.height + UPDOWNSPACE_25 + UPDOWNSPACE_25;
        //保存追加的UI子View
        appendUIArr = @[bankAuthToolView,bankPhoneNoAuthToolView,validAuthToolView,cvnAuthToolView];
    }else{
        //重置contentSize
        appendViewHeight = bankAuthToolView.height + bankPhoneNoAuthToolView.height + UPDOWNSPACE_25 + UPDOWNSPACE_25;
        //保存追加的UI子View
        appendUIArr = @[bankAuthToolView,bankPhoneNoAuthToolView];
    }
    self.baseScrollView.contentSize = CGSizeMake(self.baseScrollView.contentSize.width, self.baseScrollView.contentSize.height + appendViewHeight);
}

//删除追加的UI及清空数据
- (void)removeAppendUI{
    
    if (appendUIArr.count > 0) {
        //删除追加的UI
        [appendUIArr makeObjectsPerformSelector:@selector(removeFromSuperview)];
        //清空 数组
        appendUIArr = nil;
        
        //重置contentSize
        self.baseScrollView.contentSize = CGSizeMake(self.baseScrollView.contentSize.width, originalViewHeight);
        
        //重置约束
        self.barButton.btn.tag = BTN_TAG_NEXT;
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
   
    
}


#pragma mark 获取鉴权工具

/**
 *@brief 获取鉴权工具
 */
- (void)getAuthTools
{
   
    
}

#pragma mark - (上送实名认证四要素给后端)
- (void)setRealNameForUpdataInfo{
    
    
    
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
