//
//  UserHongbaoViewController.m
//  sandbao
//
//  Created by tianNanYiHao on 2017/11/1.
//  Copyright © 2017年 sand. All rights reserved.
//

#import "UserHongbaoViewController.h"
#import "PayNucHelper.h"
#import "UserTransferFinishViewController.h"

typedef void(^TransferPayStateBlock)(NSArray *paramArr);
@interface UserHongbaoViewController ()<UITextFieldDelegate,SDPayViewDelegate>
{
    UIView *headView;
    UIView *bodyView;
    
    UITextField *moneyTextfield;
    
    CGFloat limitFloat;
}
/**
 work域
 */
@property (nonatomic, strong) NSDictionary *wordDic;

/**
 支付工具控件
 */
@property (nonatomic, strong) SDPayView *payView;
@end

@implementation UserHongbaoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self create_HeadView];
    [self create_BodyView];
    [self create_PayView];
    
}




#pragma mark - 重写父类-baseScrollView设置
- (void)setBaseScrollview{
    [super setBaseScrollview];
    
}
#pragma mark - 重写父类-导航设置方法
- (void)setNavCoverView{
    [super setNavCoverView];
    self.navCoverView.style = NavCoverStyleWhite;
    self.navCoverView.midTitleStr = @"发红包";
    self.navCoverView.letfImgStr = @"general_icon_back";
    
    __weak UserHongbaoViewController *weakSelf = self;
    self.navCoverView.leftBlock = ^{
        [weakSelf.navigationController popViewControllerAnimated:YES];
    };
    
    
}
#pragma mark - 重写父类-点击方法集合
- (void)buttonClick:(UIButton *)btn{
    
    [self.baseScrollView endEditing:YES];
    
    //转账!
    if (btn.tag == BTN_TAG_TRANSFER) {
        
        if ([moneyTextfield.text floatValue]>0 && [moneyTextfield.text floatValue] <= limitFloat) {
            [self fee];
        }else{
            [Tool showDialog:@"请输入转账金额"];
        }
        
    }
}


#pragma mark  - UI绘制
- (void)create_HeadView{
    
    headView = [[UIView alloc] init];
    headView.backgroundColor = COLOR_FFFFFF;
    [self.baseScrollView addSubview:headView];
    
    //iconImgView
    UIImage *iconimg = [UIImage imageNamed:@"transfer_headIcon"];
    UIImageView *headIconImgeView = [Tool createImagView:iconimg];
    headIconImgeView.layer.cornerRadius = iconimg.size.height/2;
    headIconImgeView.layer.masksToBounds = YES;
    NSString *avatarImgStr = [self.userInfoDic objectForKey:@"avatar"];
    if (avatarImgStr.length>0) {
        headIconImgeView.image = [Tool avatarImageWith:avatarImgStr];
    }
    [self.baseScrollView addSubview:headIconImgeView];
    
    //accountNoLab
    NSString *accountNoStr = [NSString stringWithFormat:@"杉德宝账号:%@",[self.userInfoDic objectForKey:@"userName"]];
    UILabel *accountNoLab = [Tool createLable:accountNoStr attributeStr:nil font:FONT_14_Regular textColor:COLOR_343339 alignment:NSTextAlignmentCenter];
    [self.baseScrollView addSubview:accountNoLab];
    
    //realNameLab
    NSString *realNameStr = [NSString stringWithFormat:@"真实姓名:%@",[self.userInfoDic objectForKey:@"userRealName"]];
    UILabel *realNameLab = [Tool createLable:realNameStr attributeStr:nil font:FONT_12_Regular textColor:COLOR_343339_5 alignment:NSTextAlignmentCenter];
    [self.baseScrollView addSubview:realNameLab];

    
    headView.height = UPDOWNSPACE_20 + iconimg.size.height + UPDOWNSPACE_11 + accountNoLab.height + UPDOWNSPACE_10 + realNameLab.height + UPDOWNSPACE_58;
    
    [headView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.baseScrollView.mas_top).offset(UPDOWNSPACE_01);
        make.centerX.equalTo(self.baseScrollView.mas_centerX);
        make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH, headView.height));
    }];
    
    
    [headIconImgeView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(headView.mas_top).offset(UPDOWNSPACE_20);
        make.centerX.equalTo(headView.mas_centerX);
        make.size.mas_equalTo(iconimg.size);
    }];
    
    [accountNoLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(headIconImgeView.mas_bottom).offset(UPDOWNSPACE_11);
        make.centerX.equalTo(headView.mas_centerX);
        make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH, accountNoLab.height));
    }];
    
    [realNameLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(accountNoLab.mas_bottom).offset(UPDOWNSPACE_10);
        make.centerX.equalTo(headView.mas_centerX);
        make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH, realNameLab.height));
    }];
    
    
}

- (void)create_BodyView{
    
    //获取limit信息 - (转账limit-限制转出账户可转出金额)
    limitFloat = [[PayNucHelper sharedInstance] limitInfo:[self.outPayToolDic objectForKey:@"limit"]]/100;
    
    //bodyView
    bodyView = [[UIView alloc] init];
    bodyView.backgroundColor = COLOR_FFFFFF;
    [self.baseScrollView addSubview:bodyView];
    
    
    //moneyTextfield
    moneyTextfield = [Tool createTextField:@"0.00" font:FONT_14_SFUIT_Rrgular textColor:COLOR_343339];
    moneyTextfield.layer.borderColor = COLOR_358BEF.CGColor;
    moneyTextfield.layer.borderWidth = 1.f;
    moneyTextfield.layer.cornerRadius = 5.f;
    moneyTextfield.layer.masksToBounds = YES;
    moneyTextfield.keyboardType = UIKeyboardTypeDecimalPad;
    moneyTextfield.clearButtonMode = UITextFieldViewModeWhileEditing;
    moneyTextfield.delegate = self;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFiledEditChanged:) name:UITextFieldTextDidChangeNotification object:moneyTextfield];
    //设置左边视图的宽度(占位)
    moneyTextfield.leftView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, LEFTRIGHTSPACE_20, 0)];
    //设置显示模式为永远显示(默认不显示 必须设置 否则没有效果)
    moneyTextfield.leftViewMode = UITextFieldViewModeAlways;
    [bodyView addSubview:moneyTextfield];

    //transferBtn
    UIButton *transferBtn = [Tool createButton:@"转" attributeStr:nil font:FONT_36_SFUIT_Rrgular textColor:COLOR_FFFFFF];
    transferBtn.tag = BTN_TAG_TRANSFER;
    transferBtn.backgroundColor = COLOR_358BEF;
    transferBtn.layer.cornerRadius = 5.f;
    transferBtn.layer.masksToBounds = YES;
    [transferBtn addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    [bodyView addSubview:transferBtn];

    //limitTipLab
    NSString *limitStr = [NSString stringWithFormat:@"最高可发:%.2f元红包",limitFloat];
    UILabel *limitTipLab = [Tool createLable:limitStr attributeStr:nil font:FONT_12_Regular textColor:COLOR_343339_5 alignment:NSTextAlignmentLeft];
    [bodyView addSubview:limitTipLab];
    
    
    
    moneyTextfield.height += UPDOWNSPACE_16*2;
    
    transferBtn.height = moneyTextfield.height;
    
    moneyTextfield.width = SCREEN_WIDTH - LEFTRIGHTSPACE_30*2 - transferBtn.height - LEFTRIGHTSPACE_04;
    
    transferBtn.width = moneyTextfield.height;
    
    bodyView.height = moneyTextfield.height + UPDOWNSPACE_16 + limitTipLab.height;
    
    
    
    
    [bodyView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(headView.mas_bottom);
        make.centerX.equalTo(self.baseScrollView.mas_centerX);
        make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH, bodyView.height));
    }];
    
    [moneyTextfield mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(bodyView.mas_top);
        make.left.equalTo(bodyView.mas_left).offset(LEFTRIGHTSPACE_30);
        make.size.mas_equalTo(CGSizeMake(moneyTextfield.width, moneyTextfield.height));
    }];
    
    [transferBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(moneyTextfield.mas_top);
        make.right.mas_equalTo(bodyView.mas_right).offset(-LEFTRIGHTSPACE_30);
        make.size.mas_equalTo(CGSizeMake(transferBtn.width, transferBtn.height));
    }];
    
    [limitTipLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(moneyTextfield.mas_bottom).offset(UPDOWNSPACE_16);
        make.left.equalTo(bodyView.mas_left).offset(LEFTRIGHTSPACE_35);
        make.size.mas_equalTo(limitTipLab.size);
    }];
    
}

- (void)create_PayView{
    self.payView = [SDPayView getPayView];
    self.payView.style = SDPayViewOnlyPwd;
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


#pragma mark - SDPayViewDelegate
- (void)payViewPwd:(NSString *)pwdStr paySuccessView:(SDPaySuccessAnimationView *)successView{
    
    //支付动画开始
    [successView animationStart];
    
    [self pay:pwdStr transferPaySuccessBlock:^(NSArray *paramArr){
        //支付成功
        [successView animationSuccess];
        dispatch_time_t delayTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5f * NSEC_PER_SEC));
        dispatch_after(delayTime, dispatch_get_main_queue(), ^{
            
            //转账成功
            UserTransferFinishViewController *transferFinishVC = [[UserTransferFinishViewController alloc] init];
            transferFinishVC.amtStr = moneyTextfield.text;
            transferFinishVC.titleStr = @"红包派送成功";
            [self.navigationController pushViewController:transferFinishVC animated:YES];
        });
    } transferPayErrorBlock:^(NSArray *paramArr){
        //支付失败
        [successView animationStopClean];
        [self.payView originPayTool];
        if (paramArr.count>0) {
            [Tool showDialog:paramArr[0] defulBlock:^{
                [self.payView hidPayTool];
                [self.navigationController popToRootViewControllerAnimated:YES];
            }];
        }else{
            [Tool showDialog:@"网络连接异常" defulBlock:^{
                [self.payView hidPayTool];
                [self.navigationController popToRootViewControllerAnimated:YES];
            }];
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
#pragma mark fee手续费
-(void)fee{
    
    //work
    self.HUD = [SDMBProgressView showSDMBProgressOnlyLoadingINViewImg:self.view];
    [SDRequestHelp shareSDRequest].HUD = self.HUD;
    [SDRequestHelp shareSDRequest].controller = self;
    [[SDRequestHelp shareSDRequest] dispatchGlobalQuque:^{
        __block BOOL error = NO;
        //1.费率
        //work
        NSMutableDictionary *workDic = [[NSMutableDictionary alloc] initWithCapacity:0];
        [workDic setObject:@"transfer" forKey:@"type"];
        NSInteger cashFen = [moneyTextfield.text floatValue]*100;
        [workDic setObject:[NSString stringWithFormat:@"%ld",(long)cashFen] forKey:@"transAmt"];  //转一元
        NSString *workStr = [[PayNucHelper sharedInstance] dictionaryToJson:workDic];
        paynuc.set("work", [workStr UTF8String]);
        
        //inpayTool
        NSString  *inPayToolstr = [[PayNucHelper sharedInstance] dictionaryToJson:(NSMutableDictionary*)self.inPayToolDic];
        paynuc.set("inPayTool", [inPayToolstr UTF8String]);
        
        //outpayTool
        NSString *outPayToolStr = [[PayNucHelper sharedInstance] dictionaryToJson:(NSMutableDictionary*)self.outPayToolDic];
        paynuc.set("outPayTool", [outPayToolStr UTF8String]);
        
        [[SDRequestHelp shareSDRequest] requestWihtFuncName:@"business/fee/v1" errorBlock:^(SDRequestErrorType type) {
            error = YES;
        } successBlock:^{
            [[SDRequestHelp shareSDRequest] dispatchToMainQueue:^{
                [self.HUD hidden];
                
                //接受手续费
                NSString *workStr = [NSString stringWithUTF8String:paynuc.get("work").c_str()];
                NSDictionary *workDictI = [[PayNucHelper sharedInstance] jsonStringToDictionary:workStr];
                self.wordDic = [[NSMutableDictionary alloc] initWithDictionary:workDictI];
                
                [self.payView showPayTool];
                
            }];
        }];
        if (error) return ;
    }];
}

#pragma mark 转账
-(void)pay:(NSString *)param transferPaySuccessBlock:(TransferPayStateBlock)successblock transferPayErrorBlock:(TransferPayStateBlock)errorblock{
    
    self.HUD = [SDMBProgressView showSDMBProgressOnlyLoadingINViewImg:self.view];
    [self.HUD hidden];
    [SDRequestHelp shareSDRequest].HUD = self.HUD;
    [SDRequestHelp shareSDRequest].controller = self;
    [[SDRequestHelp shareSDRequest] dispatchGlobalQuque:^{
        __block BOOL error = NO;
        //2.支付
        //work
        //本地计算fee
        NSString *feerate =  [self.wordDic objectForKey:@"feeRate"];
        NSInteger feerateValue = [feerate integerValue];
        CGFloat   feerateFloat =  feerateValue/100;
        NSInteger cashFen = [moneyTextfield.text floatValue]*100;
        NSInteger feeFloat =  cashFen * feerateFloat;
        NSString *feeLocalStr = [NSString stringWithFormat:@"%ld",feeFloat];
        NSMutableDictionary *workDicGet = [NSMutableDictionary dictionaryWithDictionary:self.wordDic];
        [workDicGet removeObjectForKey:@"fee"];
        [workDicGet setObject:feeLocalStr forKey:@"fee"];
        [workDicGet setObject:@"transfer" forKey:@"type"];
        
        [workDicGet setObject:[NSString stringWithFormat:@"%ld",(long)cashFen] forKey:@"transAmt"];  //转一元
        NSString *workStrGet = [[PayNucHelper sharedInstance] dictionaryToJson:workDicGet];
        paynuc.set("work", [workStrGet UTF8String]);
        
        //inPayTool
        NSString  *inPayToolstr = [[PayNucHelper sharedInstance] dictionaryToJson:(NSMutableDictionary*)self.inPayToolDic];
        paynuc.set("inPayTool", [inPayToolstr UTF8String]);
        
        
        //outPayTool
        //获取对应outPayTool的authTools 填充密码
        NSArray *authTools = [_outPayToolDic objectForKey:@"authTools"];
        NSDictionary *authToolsDic = authTools[0];
        NSDictionary *passDic = [authToolsDic objectForKey:@"pass"];
        NSMutableDictionary *authToolDicM = [[NSMutableDictionary alloc] initWithDictionary:authToolsDic];
        [authToolDicM removeObjectForKey:@"pass"];
        NSMutableDictionary *passDicM = [[NSMutableDictionary alloc] initWithDictionary:passDic];
        [passDicM removeObjectForKey:@"password"];
        [passDicM removeObjectForKey:@"encryptType"];
        [passDicM setObject:@"sand" forKey:@"encryptType"];
        if ([[authToolsDic objectForKey:@"type"] isEqualToString:@"paypass"]){
            [passDicM setValue:[[PayNucHelper sharedInstance] pinenc:param type:@"paypass"] forKey:@"password"];
        }
        else if([[authToolsDic objectForKey:@"type"] isEqualToString:@"accpass"]){
            [passDicM setValue:[[PayNucHelper sharedInstance] pinenc:param type:@"accpass"] forKey:@"password"];
        }
        [authToolDicM setObject:passDicM forKey:@"pass"];
        NSMutableArray *atuhToolsM = [[NSMutableArray alloc] initWithArray:authTools];
        [atuhToolsM removeObjectAtIndex:0];
        [atuhToolsM addObject:authToolDicM];
        
        NSMutableDictionary *outPayToolM = [[NSMutableDictionary alloc] initWithDictionary:self.outPayToolDic];
        [outPayToolM removeObjectForKey:@"authTools"];
        [outPayToolM setObject:atuhToolsM forKey:@"authTools"];
        NSString *outPayToolStrAcc2Acc = [[PayNucHelper sharedInstance] dictionaryToJson:outPayToolM];
        paynuc.set("outPayTool", [outPayToolStrAcc2Acc UTF8String]);
        [[SDRequestHelp shareSDRequest] closedRespCpdeErrorAutomatic];
        [[SDRequestHelp shareSDRequest] requestWihtFuncName:@"business/acc2acc/v1" errorBlock:^(SDRequestErrorType type) {
            error = YES;
            [[SDRequestHelp shareSDRequest] dispatchToMainQueue:^{
                [[SDRequestHelp shareSDRequest] openRespCpdeErrorAutomatic];
                if (type == frErrorType) {
                    errorblock(nil);
                }
                if (type == respCodeErrorType) {
                    NSString *respMsg = [NSString stringWithUTF8String:paynuc.get("respMsg").c_str()];
                    errorblock(@[respMsg]);
                }
            }];
        } successBlock:^{
            [[SDRequestHelp shareSDRequest] dispatchToMainQueue:^{
                [[SDRequestHelp shareSDRequest] openRespCpdeErrorAutomatic];
                [self.HUD hidden];
                successblock(@[@(cashFen)]);
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
