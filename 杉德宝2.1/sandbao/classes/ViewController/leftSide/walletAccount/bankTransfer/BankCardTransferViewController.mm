//
//  BankCardTransferViewController.m
//  sandbao
//
//  Created by tianNanYiHao on 2017/10/30.
//  Copyright © 2017年 sand. All rights reserved.
//

#import "BankCardTransferViewController.h"
#import "PayNucHelper.h"
#import "BankCardTransferFinishViewController.h"
#import "VerifyTypeViewController.h"
#import "AddBankCardViewController.h"


typedef void(^WalletTransferStateBlock)(NSArray *paramArr);

@interface BankCardTransferViewController ()<SDPayViewDelegate,UITextFieldDelegate>
{
    
    UIView *headView;
    UIView *tipView;
    UIView *bodyView;
    
    NSString *moneyStr;
    
    UIImageView *bankIconImgView;
    UILabel *bankNameLab;
    UILabel *bankNumLab;
    UITextField *moneyTextfield;
    
    NSArray *rechargePayToolsArray; //获取下发支付工具组
    
    NSDecimalNumber *limitDec;
    
    SDBarButton *barButton;
}
/**
 转入支付工具(提现)
 */
@property (nonatomic, strong) NSMutableDictionary *transferInPayToolDic;

/**
 work域
 */
@property (nonatomic, strong) NSDictionary *wordDic;

/**
 支付工具控件
 */
@property (nonatomic, strong) SDPayView *payView;

@end

@implementation BankCardTransferViewController

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    //获取充值支付工具
    [self getPayTools];
    
}
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    //清除payView
    if (self.payView) {
        [self.payView hidePayTool];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self create_HeadView];
    [self create_TipView];
    [self create_BodyView];
    [self create_NextBarBtn];
    [self create_PayView];
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
    self.navCoverView.midTitleStr = @"转账到个人银行卡";
    self.navCoverView.letfImgStr = @"general_icon_back";
    
    __weak BankCardTransferViewController *weakSelf = self;
    self.navCoverView.leftBlock = ^{
        [weakSelf.navigationController popViewControllerAnimated:YES];
    };
    
    
}
#pragma mark - 重写父类-点击方法集合
- (void)buttonClick:(UIButton *)btn{
    
    if (btn.tag == BTN_TAG_TRANSFER) {
        if ([moneyTextfield.text floatValue]>0) {
            
            NSComparisonResult res = [[NSDecimalNumber decimalNumberWithString:moneyTextfield.text] compare:limitDec];
            if ([moneyTextfield.text length]>0 && res<=0) {
                //金额赋值(分)
                moneyStr = moneyTextfield.text;
                //支付控件设置信息
                [self.payView setPayInfo:@[@"提现到个人银行卡",[NSString stringWithFormat:@"¥%@",moneyStr]]];
                
                [self fee];
            }else{
                [[SDAlertView shareAlert] showDialog:@"金额超限!"];
            }
        }else{
            [[SDAlertView shareAlert] showDialog:@"请输入正确金额"];
        }
    }
    if (btn.tag == BTN_TAG_SHOWALLMONEY) {
        [barButton changeState:YES];
        moneyTextfield.text = [self limitCompareWallet];
    }
}


#pragma mark  - UI绘制
- (void)create_HeadView{
    //headView
    headView = [[UIView alloc] init];
    headView.backgroundColor = COLOR_FFFFFF;
    [self.baseScrollView addSubview:headView];
    
    //bankIconBackGroundView
    UIImage *bankIconImag = [UIImage imageNamed:@"unknow_BankCard"];
    UIView *bankIconBackGroundView = [[UIView alloc] init];
    bankIconBackGroundView.backgroundColor = COLOR_EFEFF4;
    [headView addSubview:bankIconBackGroundView];
    
    //bankIcon
    bankIconImgView = [Tool createImagView:bankIconImag];
    [bankIconBackGroundView addSubview:bankIconImgView];
    
    //bankName
    bankNameLab = [Tool createLable:@"银行卡号" attributeStr:nil font:FONT_13_Regular textColor:COLOR_343339 alignment:NSTextAlignmentLeft];
    [headView addSubview:bankNameLab];
    
    //bankNum
    bankNumLab = [Tool createLable:@"尾号(银行卡后四位尾号)" attributeStr:nil font:FONT_13_Regular textColor:COLOR_343339_5 alignment:NSTextAlignmentLeft];
    [headView addSubview:bankNumLab];
    
    bankIconBackGroundView.size = CGSizeMake(bankIconImag.size.width + LEFTRIGHTSPACE_09*2, bankIconImag.size.height + LEFTRIGHTSPACE_09*2);
    bankIconBackGroundView.layer.cornerRadius = bankIconBackGroundView.size.width/2;
    bankIconBackGroundView.layer.masksToBounds = YES;
    
    headView.height = bankIconBackGroundView.height + UPDOWNSPACE_16*2;
    CGFloat bankNameLabW = SCREEN_WIDTH - bankIconBackGroundView.width - LEFTRIGHTSPACE_35 - LEFTRIGHTSPACE_09;
    
    
    [headView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.baseScrollView.mas_bottom).offset(UPDOWNSPACE_10);
        make.centerX.equalTo(self.baseScrollView);
        make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH, headView.height));
    }];
    
    [bankIconBackGroundView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(headView.mas_top).offset(UPDOWNSPACE_16);
        make.left.equalTo(headView.mas_left).offset(LEFTRIGHTSPACE_35);
        make.size.mas_equalTo(bankIconBackGroundView.size);
    }];
    
    [bankIconImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(bankIconBackGroundView.mas_centerX);
        make.centerY.equalTo(bankIconBackGroundView.mas_centerY);
        make.size.mas_equalTo(bankIconImgView.size);
    }];
    
    [bankNameLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(bankIconBackGroundView.mas_top).offset(UPDOWNSPACE_05);
        make.left.equalTo(bankIconBackGroundView.mas_right).offset(LEFTRIGHTSPACE_09);
        make.size.mas_equalTo(CGSizeMake(bankNameLabW, bankNameLab.height));
    }];
    
    [bankNumLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(bankIconBackGroundView.mas_bottom).offset(-UPDOWNSPACE_05);
        make.left.equalTo(bankIconBackGroundView.mas_right).offset(LEFTRIGHTSPACE_09);
        make.size.mas_equalTo(CGSizeMake(bankNameLabW, bankNumLab.height));
    }];
    
}

//提示View
- (void)create_TipView{
    
    tipView = [[UIView alloc] init];
    tipView.backgroundColor = COLOR_F5F5F5;
    [self.baseScrollView addSubview:tipView];
    
    //tipLab
    [self limitCompareWallet];
    UILabel *tipLab = [Tool createLable:[NSString stringWithFormat:@"最多可对该卡转账:%@元",limitDec] attributeStr:nil font:FONT_11_Regular textColor:COLOR_343339_5 alignment:NSTextAlignmentLeft];
    [tipView addSubview:tipLab];
    
    tipView.height = tipLab.height + UPDOWNSPACE_15*2;
    CGFloat tipLabW = SCREEN_WIDTH - LEFTRIGHTSPACE_35;
    
    [tipView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.baseScrollView);
        make.top.equalTo(headView.mas_bottom);
        make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH, tipView.height));
    }];
    
    [tipLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(tipView.mas_centerY);
        make.left.equalTo(tipView.mas_left).offset(LEFTRIGHTSPACE_35);
        make.size.mas_equalTo(CGSizeMake(tipLabW, tipLab.height));
    }];
    
    
}

- (void)create_BodyView{
    
    bodyView = [[UIView alloc] init];
    bodyView.backgroundColor = COLOR_FFFFFF;
    [self.baseScrollView addSubview:bodyView];
    
    
    //rechargeMoneyLab
    UILabel *rechargeMoneyLab = [Tool createLable:@"转账金额" attributeStr:nil font:FONT_13_Regular textColor:COLOR_343339 alignment:NSTextAlignmentLeft];
    [bodyView addSubview:rechargeMoneyLab];
    
    //rmbLab
    UILabel *rmbLab = [Tool createLable:@"¥" attributeStr:nil font:FONT_24_Medium textColor:COLOR_343339 alignment:NSTextAlignmentLeft];
    [bodyView addSubview:rmbLab];
    
    //moneyTextfield
    moneyTextfield = [Tool createTextField:@"0.00" font:FONT_36_SFUIT_Rrgular textColor:COLOR_343339_5];
    moneyTextfield.keyboardType = UIKeyboardTypeDecimalPad;
    moneyTextfield.clearButtonMode = UITextFieldViewModeWhileEditing;
    moneyTextfield.height += UPDOWNSPACE_30*2;
    moneyTextfield.width = SCREEN_WIDTH - LEFTRIGHTSPACE_55;
    moneyTextfield.delegate = self;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFiledEditChanged:) name:UITextFieldTextDidChangeNotification object:moneyTextfield];
    [bodyView addSubview:moneyTextfield];
    
    //line
    UIView *line = [[UIView alloc] init];
    line.backgroundColor = COLOR_A1A2A5_3;
    line.size = CGSizeMake(SCREEN_WIDTH - 2*LEFTRIGHTSPACE_20, 1);
    [bodyView addSubview:line];
    
    //bottomTipLab
    NSString *allWalletMoney = [self limitCompareWallet];
    allWalletMoney = [NSString stringWithFormat:@"可全部转入银行卡的金额为:¥%@",allWalletMoney];
    UILabel *bottomTipLab = [Tool createLable:allWalletMoney attributeStr:nil font:FONT_11_Regular textColor:COLOR_343339_5 alignment:NSTextAlignmentLeft];
    [bodyView addSubview:bottomTipLab];
    
    //bottomBtn
    UIButton *bottomBtn = [Tool createButton:@"全部转账" attributeStr:nil font:FONT_13_Regular textColor:COLOR_FF5D31];
    bottomBtn.tag = BTN_TAG_SHOWALLMONEY;
    [bottomBtn addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    bottomBtn.size = CGSizeMake(bottomBtn.width, bottomBtn.height + UPDOWNSPACE_25);
    [bodyView addSubview:bottomBtn];
    
    
    CGFloat bodyViewH = UPDOWNSPACE_20 + rechargeMoneyLab.height + moneyTextfield.height + UPDOWNSPACE_25 + bottomTipLab.height + UPDOWNSPACE_25;
    
    [bodyView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(tipView.mas_bottom);
        make.centerX.equalTo(self.baseScrollView);
        make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH, bodyViewH));
    }];
    
    [rechargeMoneyLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(bodyView.mas_top).offset(UPDOWNSPACE_20);
        make.left.equalTo(bodyView.mas_left).offset(LEFTRIGHTSPACE_35);
        make.size.mas_equalTo(rechargeMoneyLab.size);
    }];
    
    [moneyTextfield mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(rechargeMoneyLab.mas_bottom).offset(UPDOWNSPACE_0);
        make.left.equalTo(bodyView.mas_left).offset(LEFTRIGHTSPACE_55);
        make.size.mas_equalTo(CGSizeMake(moneyTextfield.width, moneyTextfield.height));
    }];
    
    [rmbLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(moneyTextfield.mas_centerY);
        make.left.equalTo(bodyView.mas_left).offset(LEFTRIGHTSPACE_35);
        make.size.mas_equalTo(rmbLab.size);
    }];
    
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(moneyTextfield.mas_bottom);
        make.left.equalTo(bodyView.mas_left).offset(LEFTRIGHTSPACE_20);
        make.size.mas_equalTo(line.size);
    }];
    
    [bottomTipLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(line.mas_bottom).offset(UPDOWNSPACE_25);
        make.left.equalTo(bodyView.mas_left).offset(LEFTRIGHTSPACE_35);
        make.size.mas_equalTo(bottomTipLab.size);
    }];
    
    [bottomBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(bottomTipLab.mas_centerY);
        make.right.equalTo(bodyView.mas_right).offset(-LEFTRIGHTSPACE_20);
        make.size.mas_equalTo(bottomBtn.size);
    }];
    
    
    //装载所有的textfiled
    self.textfiledArr = [NSMutableArray arrayWithArray:@[moneyTextfield]];
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
- (void)create_NextBarBtn{
    //rechargeBtn
    barButton = [[SDBarButton alloc] init];
    UIView *rechargeBtn = [barButton createBarButton:@"两个工作日到账,确认转账" font:FONT_15_Regular titleColor:COLOR_FFFFFF backGroundColor:COLOR_58A5F6 leftSpace:LEFTRIGHTSPACE_40];
    barButton.btn.tag = BTN_TAG_TRANSFER;
    [barButton.btn addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.baseScrollView addSubview:rechargeBtn];
    
    [rechargeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(bodyView.mas_bottom).offset(UPDOWNSPACE_69);
        make.centerX.equalTo(self.baseScrollView.mas_centerX);
        make.size.mas_equalTo(rechargeBtn.size);
    }];
    
}
- (void)create_PayView{
    self.payView = [SDPayView getPayView];
    self.payView.addCardType = SDPayView_ADDBANKCARD;
    self.payView.delegate = self;
    [[UIApplication sharedApplication].keyWindow addSubview:self.payView];
}
#pragma mark - Notifaction - 金额输入框值监听
- (void)textFiledEditChanged:(NSNotification *)obj
{
    UITextField *textField = (UITextField *)obj.object;
    NSString *content = textField.text;
    
    
    textField.placeholder = @"0.0";
    //金额输入控制
    //输入"." 变"0."
    if ([content length]>0&&[[content substringToIndex:1] isEqualToString:@"."]) {
        textField.text = @"0.";
    }
    //两个".." 变"."
    if ([content componentsSeparatedByString:@"."].count>2) {
        textField.text = [content substringToIndex:content.length - 1];
    }
    //两个"0"  变"0."
    if ([content isEqualToString:@"00"]) {
        textField.text = @"0.";
    }
    //输入"0X" 变"0."
    if ([content floatValue]>1 && [[content substringToIndex:1] isEqualToString:@"0"]) {
        textField.text = @"0.";
    }
    
}
#pragma mark - textfieldDelegate
#pragma mark 限制键盘输入某些字符
-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    
    if ([textField.placeholder rangeOfString:@"0.0"].location !=NSNotFound) {
        return [self limitPayMoneyDot:textField shouldChangeCharactersInRange:range replacementString:string dotPreBits:6 dotAfterBits:2];
    }
    
    return YES;
    
}
/**
 *  付款金额限制代码
 *
 *  @param textField    当前textField
 *  @param range        range
 *  @param string       string
 *  @param dotPreBits   小数点前整数位数
 *  @param dotAfterBits 小数点后位数
 *
 *  @return shouldChangeCharactersInRange 代理方法中 可以限制金额格式
 */
#define myDotNumbers     @"0123456789.\n"
#define myNumbers          @"0123456789\n"
- (BOOL) limitPayMoneyDot:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string dotPreBits:(int)dotPreBits dotAfterBits:(int)dotAfterBits

{
    if ([string isEqualToString:@"\n"]||[string isEqualToString:@""])
    { //按下return
        return YES;
    }
    
    
    NSCharacterSet *cs;
    NSUInteger nDotLoc = [textField.text rangeOfString:@"."].location;
    if (NSNotFound == nDotLoc && 0 != range.location) {
        cs = [[NSCharacterSet characterSetWithCharactersInString:myNumbers]invertedSet];
        if ([string isEqualToString:@"."]) {
            return YES;
        }
        if (textField.text.length>=dotPreBits) {  //小数点前面6位
            return NO;
        }
    }
    else {
        cs = [[NSCharacterSet characterSetWithCharactersInString:myDotNumbers] invertedSet];
        if (textField.text.length>=9) {
            return  NO;
        }
    }
    NSString *filtered = [[string componentsSeparatedByCharactersInSet:cs] componentsJoinedByString:@""];
    BOOL basicTest = [string isEqualToString:filtered];
    if (!basicTest) {
        return NO;
    }
    if (NSNotFound != nDotLoc && range.location > nDotLoc +dotAfterBits) {//小数点后面两位
        return NO;
    }
    return YES;
}


#pragma mark  - SDPayViewDelegate
- (void)payViewReturnDefulePayToolDic:(NSMutableDictionary *)defulePayToolDic{
    //设置默认支付工具
    self.transferInPayToolDic = defulePayToolDic;
    //刷新页面信息
    [self resetBankNameLabelAndIconImageView];
    
}
- (void)payViewSelectPayToolDic:(NSMutableDictionary *)selectPayToolDict{
    //设置当前所选支付工具
    self.transferInPayToolDic = selectPayToolDict;

    //刷新页面信息
    [self resetBankNameLabelAndIconImageView];
}

- (void)payViewPwd:(NSString *)pwdStr paySuccessView:(SDPaySuccessAnimationView *)successView{
    
    //支付动画开始
    [successView animationStart];
    
    [self recharge:pwdStr paramDic:self.wordDic rechargeSuccessBlock:^(NSArray *paramArr){
        //支付成功
        [successView animationSuccess];
        dispatch_time_t delayTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5f * NSEC_PER_SEC));
        dispatch_after(delayTime, dispatch_get_main_queue(), ^{
            //提现成功
            BankCardTransferFinishViewController *bankCardTransferFinishVC = [[BankCardTransferFinishViewController alloc] init];
            bankCardTransferFinishVC.bankTitle = bankNameLab.text;
            bankCardTransferFinishVC.bankNo = bankNumLab.text;
            [self.navigationController pushViewController:bankCardTransferFinishVC animated:YES];
        });
    } rechagreErrorBlock:^(NSArray *paramArr){
        //支付失败 - 动画停止
        [successView animationStopClean];
        //支付失败 - 复位到支付订单
        [self.payView payPwdResetToPayOrderView];
        if (paramArr.count>0) {
            [[SDAlertView shareAlert] showDialog:paramArr[0] defulBlock:^{
                //支付失败 - 复位支付工具且删除
                [self.payView resetPayToolHidden];
                [self.navigationController popToRootViewControllerAnimated:YES];
            }];
        }else{
            [[SDAlertView shareAlert] showDialog:@"网络连接异常" defulBlock:^{
                //支付失败 - 复位支付工具且删除
                [self.payView resetPayToolHidden];
                [self.navigationController popToRootViewControllerAnimated:YES];
            }];
        }
    }];
    
}

- (void)payViewForgetPwd:(NSString *)type{
    
    if ([type isEqualToString:PAYTOOL_PAYPASS]) {
        //@"修改支付密码"
        VerifyTypeViewController *verifyTypeVC = [[VerifyTypeViewController alloc] init];
        verifyTypeVC.tokenType = @"01000601";
        verifyTypeVC.verifyType = VERIFY_TYPE_CHANGEPATPWD;
        verifyTypeVC.popToRoot = YES;
        verifyTypeVC.phoneNoStr = [CommParameter sharedInstance].phoneNo;
        [self.navigationController pushViewController:verifyTypeVC animated:YES];
    }

}

- (void)payViewAddPayToolCard:(NSString *)type{
    
    if ([type isEqualToString:PAYTOOL_PAYPASS]) {
        NSArray *bankCardArr = [self getBankCardPayToolArr];
        if (bankCardArr.count>=3) {
            [[SDAlertView shareAlert] showDialog:@"已绑定3张银行卡,不可继续绑卡"];
        }else{
            AddBankCardViewController *addBankCardVC = [[AddBankCardViewController alloc] init];
            [self.navigationController pushViewController:addBankCardVC animated:YES];
        }
    }
    if ([type isEqualToString:PAYTOOL_ACCPASS]) {
        
    }
}
- (void)payViewPayToolsError:(NSString *)errorInfo{
    
    if ([errorInfo isEqualToString:@"无可用支付工具"]) {
        [[SDAlertView shareAlert] showDialog:@"无可用银行卡" message:@"请绑定新银行卡" leftBtnString:@"取消" rightBtnString:@"去绑卡" leftBlock:^{
            [self.navigationController popViewControllerAnimated:YES];
        } rightBlock:^{
            AddBankCardViewController *addBankCardVC = [[AddBankCardViewController alloc] init];
            [self.navigationController pushViewController:addBankCardVC animated:YES];
        }];
    }
    if ([errorInfo isEqualToString:@"无支付工具下发"]) {
        [[SDAlertView shareAlert] showDialog:@"未绑定银行卡" message:@"请绑定新银行卡" leftBtnString:@"取消" rightBtnString:@"去绑卡" leftBlock:^{
            [self.navigationController popViewControllerAnimated:YES];
        } rightBlock:^{
            AddBankCardViewController *addBankCardVC = [[AddBankCardViewController alloc] init];
            [self.navigationController pushViewController:addBankCardVC animated:YES];
        }];
    }
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
        
        
        NSString *payTool = [[PayNucHelper sharedInstance] dictionaryToJson:self.transferOutPayToolDic];
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
                //排序
                rechargePayToolsArray = [Tool orderForPayTools:rechargePayToolsArray];
                //支付控件设置列表
                [self.payView setPayTools:rechargePayToolsArray];
            }];
        }];
        if (error) return ;
    }];
    
}


/**
 重置文字和icon图片
 */
- (void)resetBankNameLabelAndIconImageView{
    
    NSString *accNo  = [[self.transferInPayToolDic objectForKey:@"account"] objectForKey:@"accNo"];
    NSString *title = [self.transferInPayToolDic objectForKey:@"title"];
    NSString *lastfournumber = accNo.length>=4?lastfournumber = [accNo substringFromIndex:accNo.length-4]:lastfournumber = @"暂无显示";
    
    bankNameLab.text = [NSString stringWithFormat:@"%@",title];
    bankNumLab.text = [NSString stringWithFormat:@"尾号%@",lastfournumber];
    NSString *imgName = [Tool getIconImageName:[self.transferInPayToolDic objectForKey:@"type"] title:title imaUrl:nil];
    bankIconImgView.image = [UIImage imageNamed:imgName];
}


#pragma mark 计算手续费fee
- (void)fee
{
    
    self.HUD = [SDMBProgressView showSDMBProgressOnlyLoadingINViewImg:self.view];
    [SDRequestHelp shareSDRequest].HUD = self.HUD;
    [SDRequestHelp shareSDRequest].controller = self;
    [[SDRequestHelp shareSDRequest] dispatchGlobalQuque:^{
        __block BOOL error = NO;
        NSString *transAmt = [NSString stringWithFormat:@"%.0f", [moneyStr floatValue] * 100];
        
        NSDictionary *workDic = [[NSDictionary alloc] init];
        workDic = @{
                    @"type":@"withdraw",
                    @"transAmt":transAmt
                    };
        
        NSString *work = [[PayNucHelper sharedInstance] dictionaryToJson:(NSMutableDictionary*)workDic];
        NSString *outPayTool = [[PayNucHelper sharedInstance] dictionaryToJson:self.transferOutPayToolDic];
        NSString *inPayTool = [[PayNucHelper sharedInstance] dictionaryToJson:self.transferInPayToolDic];
        
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
                
                //支付控件弹出
                [self.payView showPayTool];
            }];
        }];
        if (error) return ;
    }];
    
}

#pragma mark 确认转账
- (void)recharge:(NSString *)param paramDic:(NSDictionary *)paramDic rechargeSuccessBlock:(WalletTransferStateBlock)successBlock rechagreErrorBlock:(WalletTransferStateBlock)errorBlock
{
    self.HUD = [SDMBProgressView showSDMBProgressOnlyLoadingINViewImg:self.view];
    [self.HUD hidden];
    [SDRequestHelp shareSDRequest].HUD = self.HUD;
    [SDRequestHelp shareSDRequest].controller = self;
    [[SDRequestHelp shareSDRequest] dispatchGlobalQuque:^{
        __block BOOL error = NO;
        NSString *transAmt = [NSString stringWithFormat:@"%.0f", [moneyStr floatValue] * 100];
        
        NSMutableDictionary *workDic = [NSMutableDictionary dictionaryWithDictionary:paramDic];
        [workDic setValue:transAmt forKey:@"transAmt"];
        [workDic setValue:[paramDic objectForKey:@"feeType"] forKey:@"feeType"];
        [workDic setValue:[paramDic objectForKey:@"feeRate"] forKey:@"feeRate"];
        NSString *work = [[PayNucHelper sharedInstance] dictionaryToJson:(NSMutableDictionary*)workDic];
        
        NSString *inPayTool = [[PayNucHelper sharedInstance] dictionaryToJson:self.transferInPayToolDic];
        
        NSMutableDictionary *outPayToolDic = [NSMutableDictionary dictionaryWithDictionary:self.transferOutPayToolDic];
        NSArray *authToolsArray = [outPayToolDic objectForKey:@"authTools"];
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
        [passDic setValue:@"sand" forKey:@"encryptType"];
        [passDic setValue:@"" forKey:@"regular"];
        [authToolsDic setObject:passDic forKey:@"pass"];
        [tempAuthToolsArray addObject:authToolsDic];
        [outPayToolDic setObject:tempAuthToolsArray forKey:@"authTools"];
        NSString *outPayTool = [[PayNucHelper sharedInstance] dictionaryToJson:outPayToolDic];
        
        
        paynuc.set("work", [work UTF8String]);
        paynuc.set("inPayTool", [inPayTool UTF8String]);
        paynuc.set("outPayTool", [outPayTool UTF8String]);
        [[SDRequestHelp shareSDRequest] closedRespCpdeErrorAutomatic];
        [[SDRequestHelp shareSDRequest] requestWihtFuncName:@"business/acc2acc/v1" errorBlock:^(SDRequestErrorType type) {
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
            [[SDRequestHelp shareSDRequest]dispatchToMainQueue:^{
                [[SDRequestHelp shareSDRequest] openRespCpdeErrorAutomatic];
                [self.HUD hidden];
                NSString *work = [NSString stringWithUTF8String:paynuc.get("work").c_str()];
                NSDictionary *workDic = [[PayNucHelper sharedInstance] jsonStringToDictionary:work];
                successBlock(@[workDic,outPayToolDic]);
            }];
        }];
        if (error) return ;
    }];
}

#pragma mark - 公共方法
#pragma mark 获取用户绑定的银行卡数量
/**获取用户绑定的银行卡数量*/
- (NSArray*)getBankCardPayToolArr
{
    NSDictionary *ownPayToolDic = [Tool getPayToolsInfo:[CommParameter sharedInstance].ownPayToolsArray];
    NSArray *bankCardPayTooArr = [NSMutableArray arrayWithCapacity:0];
    bankCardPayTooArr = [ownPayToolDic objectForKey:@"bankArray"];
    return bankCardPayTooArr;
}

//*比较limit与钱包余额*/
- (NSString*)limitCompareWallet{
    //获取limit信息 - (提现limit-限制转出账户可转出金额)
    limitDec = [[PayNucHelper sharedInstance] limitInfo:[self.transferOutPayToolDic objectForKey:@"limit"]];
    
    NSString *showMoney = @"";
    float wallectMoney = [[Tool fenToYuanDict:self.transferOutPayToolDic] floatValue];
    float limitMoney = [[NSString stringWithFormat:@"%@",limitDec] floatValue];
    if (wallectMoney>limitMoney) {
        showMoney = [NSString stringWithFormat:@"%@",limitDec];
    }else{
        showMoney = [Tool fenToYuanDict:self.transferOutPayToolDic];
    }
    return showMoney;
}

- (void)dealloc{
    //清除通知
    [[NSNotificationCenter defaultCenter] removeObserver:self];
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
