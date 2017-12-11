//
//  AddBankCardSecViewController.m
//  sandbao
//
//  Created by tianNanYiHao on 2017/11/6.
//  Copyright © 2017年 sand. All rights reserved.
//

#import "AddBankCardSecViewController.h"
#import "PayNucHelper.h"
#import "AddBankCardCell.h"
#import "SmsCheckViewController.h"
typedef NS_ENUM(NSInteger,BankCardType) {
    
    debitCard = 0, //借记卡
    creditCard,    //贷记卡
};
@interface AddBankCardSecViewController ()
{
    
    AddBankCardCell *cardKindCell;
    AddBankCardCell *cardRealNameCell;
    AddBankCardCell *cardIdentityNoCell;
    
    
    
    ValidAuthToolView *validAuthToolView;
    
    CvnAuthToolView *cvnAuthToolView;
    
    BankCardType cardType;
    
}
@property (nonatomic, strong) NSString *bankPhoneNoStr;
@property (nonatomic, strong) NSString *validStr;       //卡有效期
@property (nonatomic, strong) NSString *cvnStr;       //cvn
@end

@implementation AddBankCardSecViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    //检查卡类型
    [self checkCardType];
    
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
    self.navCoverView.midTitleStr = @"填写银行卡信息";
    __weak AddBankCardSecViewController *weakSelf = self;
    self.navCoverView.leftBlock = ^{
        [weakSelf.navigationController popViewControllerAnimated:YES];
    };
    
}
#pragma mark - 重写父类-点击方法集合
- (void)buttonClick:(UIButton *)btn{
    
    if (btn.tag == BTN_TAG_NEXT) {
        
        if (self.bankPhoneNoStr.length>0) {
            [self getAuthTools];
        }else{
            [Tool showDialog:@"请输入银行预留手机号"];
        }
    }
        
}

#pragma mark  - UI绘制
- (void)createUI{
    __weak typeof(self) weakSelf = self;
    
    //titleLab1
    UILabel *titleLab = [Tool createLable:@"填写银行卡信息" attributeStr:nil font:FONT_28_Medium textColor:COLOR_343339 alignment:NSTextAlignmentCenter];
    [self.baseScrollView addSubview:titleLab];
    
    
    //cardKind
    cardKindCell = [AddBankCardCell createSetCellViewOY:0];
    cardKindCell.titleLab.text = @"卡类型";
    cardKindCell.rightStr = [self.payToolDic objectForKey:@"title"];
    [self.baseScrollView addSubview:cardKindCell];
    
    //cardRealNameCell
    cardRealNameCell = [AddBankCardCell createSetCellViewOY:0];
    cardRealNameCell.titleLab.text = @"持卡人姓名";
    cardRealNameCell.rightStr = [self.userInfoDic objectForKey:@"userRealName"];
    [self.baseScrollView addSubview:cardRealNameCell];
    
    //cardIdentityNoCell
    cardIdentityNoCell = [AddBankCardCell createSetCellViewOY:0];
    cardIdentityNoCell.titleLab.text = @"证件号码";
    cardIdentityNoCell.rightStr = [[self.userInfoDic objectForKey:@"identity"] objectForKey:@"identityNo"];
    [self.baseScrollView addSubview:cardIdentityNoCell];
    
    //bankPhoneNoAuthToolView
    PhoneAuthToolView *bankPhoneNoAuthToolView = [PhoneAuthToolView createAuthToolViewOY:0];
    bankPhoneNoAuthToolView.titleLab.text = @"银行预留手机号";
    bankPhoneNoAuthToolView.tip.text = @"请输入正确的银行预留手机号";
    bankPhoneNoAuthToolView.successBlock = ^(NSString *textfieldText) {
        weakSelf.bankPhoneNoStr = textfieldText;
    };
    [self.baseScrollView addSubview:bankPhoneNoAuthToolView];
    
    //信用卡
    if (cardType == creditCard) {
        validAuthToolView = [ValidAuthToolView createAuthToolViewOY:0];
        validAuthToolView.tip.text = @"请输入正确有效期";
        validAuthToolView.successBlock = ^(NSString *textfieldText) {
            weakSelf.validStr = textfieldText;
        };
        [self.baseScrollView addSubview:validAuthToolView];
        
        cvnAuthToolView = [CvnAuthToolView createAuthToolViewOY:0];
        cvnAuthToolView.tip.text = @"请输入正确CVN";
        cvnAuthToolView.successBlock = ^(NSString *textfieldText) {
            weakSelf.cvnStr = textfieldText;
        };
        [self.baseScrollView addSubview:cvnAuthToolView];

    }
    
    
    
    
    //nextBtn
    UIButton *nextBarbtn = [Tool createBarButton:@"继续" font:FONT_15_Regular titleColor:COLOR_FFFFFF backGroundColor:COLOR_58A5F6 leftSpace:LEFTRIGHTSPACE_40];
    nextBarbtn.tag = BTN_TAG_NEXT;
    [nextBarbtn addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.baseScrollView addSubview:nextBarbtn];
    
    [titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.baseScrollView.mas_top).offset(UPDOWNSPACE_69);
        make.centerX.equalTo(self.baseScrollView.mas_centerX);
        make.size.mas_equalTo(titleLab.size);
    }];
    
    
    [cardKindCell mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(titleLab.mas_bottom).offset(UPDOWNSPACE_69);
        make.centerX.equalTo(self.baseScrollView.mas_centerX);
        make.size.mas_equalTo(cardKindCell.size);
    }];
    
    [cardRealNameCell mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(cardKindCell.mas_bottom).offset(UPDOWNSPACE_0);
        make.centerX.equalTo(self.baseScrollView.mas_centerX);
        make.size.mas_equalTo(cardRealNameCell.size);
    }];
    
    [cardIdentityNoCell mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(cardRealNameCell.mas_bottom).offset(UPDOWNSPACE_0);
        make.centerX.equalTo(self.baseScrollView.mas_centerX);
        make.size.mas_equalTo(cardIdentityNoCell.size);
    }];
    
    [bankPhoneNoAuthToolView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(cardIdentityNoCell.mas_bottom).offset(UPDOWNSPACE_25);
        make.centerX.equalTo(self.baseScrollView.mas_centerX);
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
    
    [nextBarbtn mas_makeConstraints:^(MASConstraintMaker *make) {
        if (cardType == creditCard) {
            make.top.equalTo(cvnAuthToolView.mas_bottom).offset(UPDOWNSPACE_50);
        }else{
            make.top.equalTo(bankPhoneNoAuthToolView.mas_bottom).offset(UPDOWNSPACE_50);
        }
        
        make.centerX.equalTo(self.baseScrollView.mas_centerX);
        make.size.mas_equalTo(nextBarbtn.size);
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
                            smsVC.payToolDic = self.payToolDic;
                            smsVC.userInfoDic = self.userInfoDic;
                            smsVC.phoneNoStr = self.bankPhoneNoStr;
                            smsVC.cvnStr = self.cvnStr;
                            smsVC.expiryStr = self.validStr;
                            smsVC.smsCheckType = SMS_CHECKTYPE_ADDBANKCARD;
                            [self.navigationController pushViewController:smsVC animated:YES];
                        }else{
                            [Tool showDialog:@"下发鉴权工具有误"];
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

-(void)checkCardType{
    
    //信用卡
    if ([[self.payToolDic objectForKey:@"authTools"] count]>0){
        cardType = creditCard;
    }
    //借记卡
    else{
        cardType = debitCard;
    }
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
