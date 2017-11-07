//
//  VerifyViewController.m
//  sandbao
//
//  Created by tianNanYiHao on 2017/11/7.
//  Copyright © 2017年 sand. All rights reserved.
//

#import "VerifyViewController.h"
#import "PayNucHelper.h"
#import "ChangePayPwdViewController.h"
#import "ChangeLogPwdViewController.h"
@interface VerifyViewController ()
{
    
    
}
@property (nonatomic, strong) NSString *loginpPwdStr;
@property (nonatomic, strong) NSString *paypassPwdStr;
@property (nonatomic, strong) NSString *identityNoStr;
@property (nonatomic, strong) NSString *bankCardNoStr;

@end

@implementation VerifyViewController

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
    self.navCoverView.letfImgStr = @"login_icon_back";
    
    __block VerifyViewController *weakSelf = self;
    self.navCoverView.leftBlock = ^{
        [weakSelf.navigationController popViewControllerAnimated:YES];
    };
    
}
#pragma mark - 重写父类-点击方法集合
- (void)buttonClick:(UIButton *)btn{
    
    if (btn.tag == BTN_TAG_NEXT) {
        if (_loginpPwdStr.length>0 || _paypassPwdStr.length>0 || _identityNoStr.length>0 || _bankCardNoStr.length>0) {
            
            [self setAuthTools];
            
        }else{
            [Tool showDialog:@"请输入正确信息"];
        }
    }
    
}


#pragma mark  - UI绘制
- (void)createUI{

    //titleLab1
    UILabel *titleLab = [Tool createLable:@"请继续验证" attributeStr:nil font:FONT_28_Medium textColor:COLOR_358BEF alignment:NSTextAlignmentCenter];
    [self.baseScrollView addSubview:titleLab];
    
    //titleLab2
    UILabel *titleDesLab = [Tool createLable:@"请继续填写相关校验信息" attributeStr:nil font:FONT_16_Regular textColor:COLOR_343339_7 alignment:NSTextAlignmentCenter];
    [self.baseScrollView addSubview:titleDesLab];
    
    
    UIView *baseAuthToolView = [[UIView alloc] init];
    [self.baseScrollView addSubview:baseAuthToolView];
    
    for (int i = 0; i<self.authToolArr.count; i++) {
        if (![@"sms" isEqualToString:[self.authToolArr[i] objectForKey:@"type"]]) {
            NSString *type = [self.authToolArr[i] objectForKey:@"type"];
            if ([@"loginpass" isEqualToString:type]) {
                //PwdAuthToolView
                PwdAuthToolView *pwdAuthToolView = [PwdAuthToolView createAuthToolViewOY:0];
                pwdAuthToolView.tip.text = @"密码必须包含8-20位的字母数字组合";
                pwdAuthToolView.textfiled.text = SHOWTOTEST(@"qqqqqq111");
                _loginpPwdStr = SHOWTOTEST(@"qqqqqq111");
                pwdAuthToolView.successBlock = ^(NSString *textfieldText) {
                    _loginpPwdStr = textfieldText;
                };
                [baseAuthToolView addSubview:pwdAuthToolView];
                baseAuthToolView.size = pwdAuthToolView.size;
            }
            if ([@"paypass" isEqualToString:type]) {
                //payCodeAuthTool:sixCodeAuthToolView
                SixCodeAuthToolView *payCodeAuthTool = [SixCodeAuthToolView createAuthToolViewOY:0];
                payCodeAuthTool.style = PayCodeAuthTool;
                payCodeAuthTool.successBlock = ^(NSString *textfieldText) {
                    _paypassPwdStr = textfieldText;
                };
                [baseAuthToolView addSubview:payCodeAuthTool];
                 baseAuthToolView.size = payCodeAuthTool.size;
            }
            if ([@"gesture" isEqualToString:type]) {
             
            }
            if ([@"accpass" isEqualToString:type]) {
                
            }
            if ([@"img" isEqualToString:type]) {
                
            }
            if ([@"bankCard" isEqualToString:type]) {
                //cardNoAuthToolView
                CardNoAuthToolView *cardNoAuthToolView = [CardNoAuthToolView createAuthToolViewOY:0];
                cardNoAuthToolView.tip.text = @"请输入有效银行卡卡号";
                cardNoAuthToolView.textfiled.text = SHOWTOTEST(@"6217001210062891245");
                _bankCardNoStr = SHOWTOTEST(@"6217001210062891245");
                cardNoAuthToolView.successBlock = ^(NSString *textfieldText) {
                    _bankCardNoStr = textfieldText;
                };
                [baseAuthToolView addSubview:cardNoAuthToolView];
                baseAuthToolView.size = cardNoAuthToolView.size;
            }
            if ([@"question" isEqualToString:type]) {
                
            }
            if ([@"identity" isEqualToString:type]) {
                //identityAuthToolView
                IdentityAuthToolView *identityAuthToolView = [IdentityAuthToolView createAuthToolViewOY:0];
                identityAuthToolView.tip.text = @"请输入有效身份证件号";
                identityAuthToolView.textfiled.text = SHOWTOTEST(@"320981199001053212");
                _identityNoStr = SHOWTOTEST(@"320981199001053212");
                identityAuthToolView.successBlock = ^(NSString *textfieldText) {
                    _identityNoStr = textfieldText;
                };
                [baseAuthToolView addSubview:identityAuthToolView];
                baseAuthToolView.size = identityAuthToolView.size;
            }
            if ([@"cardCheckCode" isEqualToString:type]) {

            }
            if ([@"creditCard" isEqualToString:type]) {
                
            }
        }
    }
    

    //nextBtn
    UIButton *nextBarbtn = [Tool createBarButton:@"继续" font:FONT_15_Regular titleColor:COLOR_FFFFFF backGroundColor:COLOR_58A5F6 leftSpace:LEFTRIGHTSPACE_40];
    nextBarbtn.tag = BTN_TAG_NEXT;
    [nextBarbtn addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.baseScrollView addSubview:nextBarbtn];
    
    //frame
    [titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.baseScrollView.mas_top).offset(UPDOWNSPACE_64);
        make.centerX.equalTo(self.baseScrollView.mas_centerX);
        make.size.mas_equalTo(titleLab.size);
    }];
    
    [titleDesLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(titleLab.mas_bottom).offset(UPDOWNSPACE_16);
        make.centerX.equalTo(self.baseScrollView.mas_centerX);
        make.size.mas_equalTo(titleDesLab.size);
    }];
    
    [baseAuthToolView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(titleDesLab.mas_bottom).offset(UPDOWNSPACE_36);
        make.centerX.equalTo(self.baseScrollView);
        make.size.mas_equalTo(baseAuthToolView.size);
    }];
    
    [nextBarbtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(baseAuthToolView.mas_bottom).offset(UPDOWNSPACE_40);
        make.centerX.equalTo(self.baseScrollView.mas_centerX);
        make.size.mas_equalTo(nextBarbtn.size);
    }];
    
}

#pragma mark - 业务逻辑
#pragma mark 上送鉴权工具(sms + anything)
- (void)setAuthTools{
    
    self.HUD = [SDMBProgressView showSDMBProgressOnlyLoadingINViewImg:self.view];
    [SDRequestHelp shareSDRequest].HUD = self.HUD;
    [SDRequestHelp shareSDRequest].controller = self;
    [[SDRequestHelp shareSDRequest] dispatchGlobalQuque:^{
        __block BOOL error = NO;

        NSString *authTools = [self assembleRequestString:(NSMutableArray*)self.authToolArr];
        paynuc.set("authTools", [authTools UTF8String]);
        [[SDRequestHelp shareSDRequest] requestWihtFuncName:@"authTool/setAuthTools/v1" errorBlock:^(SDRequestErrorType type) {
            error = YES;
            [[SDRequestHelp shareSDRequest] dispatchToMainQueue:^{
                if (type == respCodeErrorType) {
                    [self.navigationController popViewControllerAnimated:YES];
                }
            }];
        } successBlock:^{
            [[SDRequestHelp shareSDRequest] dispatchToMainQueue:^{
                [self.HUD hidden];
                
                if (self.verifyType == VERIFY_TYPE_CHANGEPATPWD) {
                    ChangePayPwdViewController *changePayPwdVC = [[ChangePayPwdViewController alloc] init];
                    [self.navigationController pushViewController:changePayPwdVC animated:YES];
                }
                if (self.verifyType == VERIFY_TYPE_CHANGELOGPWD) {
                    ChangeLogPwdViewController *changeLogPwdVC = [[ChangeLogPwdViewController alloc] init];
                    [self.navigationController pushViewController:changeLogPwdVC animated:YES];
                }
                
            }];
        }];
        if (error) return ;
    }];

}

/**
 *@brief 配置数据
 *@param arrayParam NSMutableArray 参数：request数组
 *@return NSString
 */
- (NSString *)assembleRequestString:(NSMutableArray *)arrayParam
{
    NSMutableArray *authToolsArray1 = [[NSMutableArray alloc] init];
    
    NSInteger count = [arrayParam count];
    for (int i = 0; i < count; i++) {
        NSMutableDictionary *dic = arrayParam[i];
        NSMutableDictionary *authToolsDic = [NSMutableDictionary dictionaryWithDictionary:dic];
        NSString *type = [dic objectForKey:@"type"];
        
        if ([@"sms" isEqualToString:type]) {
            [authToolsArray1 addObject:authToolsDic];
        }
        if ([@"loginpass" isEqualToString:type]) {
            [authToolsDic removeObjectForKey:@"pass"];
            NSMutableDictionary *loginpassDic = [[NSMutableDictionary alloc] init];
            [loginpassDic setValue:[NSString stringWithUTF8String:paynuc.lgnenc([self.loginpPwdStr UTF8String]).c_str()] forKey:@"password"];
            [loginpassDic setValue:@"" forKey:@"description"];
            [loginpassDic setValue:@"" forKey:@"encryptType"];
            [loginpassDic setValue:@"" forKey:@"regular"];
            [authToolsDic setObject:loginpassDic forKey:@"pass"];
            
            [authToolsArray1 addObject:authToolsDic];
        }
        else if ([@"paypass" isEqualToString:type]) {
            [authToolsDic removeObjectForKey:@"pass"];
            NSMutableDictionary *paypassDic = [[NSMutableDictionary alloc] init];
            [paypassDic setValue:[[PayNucHelper sharedInstance] pinenc:self.paypassPwdStr type:@"paypass"]  forKey:@"password"];
            [paypassDic setValue:@"" forKey:@"description"];
            [paypassDic setValue:@"" forKey:@"encryptType"];
            [paypassDic setValue:@"" forKey:@"regular"];
            [authToolsDic setObject:paypassDic forKey:@"pass"];
            
            [authToolsArray1 addObject:authToolsDic];
        }
        else if ([@"gesture" isEqualToString:type]) {
            
        }
        else if ([@"question" isEqualToString:type]) {
//            NSArray *dataArray = [dic objectForKey:@"question"];
//            [authToolsDic removeObjectForKey:@"question"];
//            NSInteger dataArrayCount = [dataArray count];
//            
//            NSMutableArray *questionArray = [[NSMutableArray alloc] init];
//            
//            //用于过滤其他鉴权textfiled
//            NSMutableArray *questionTextArr = [NSMutableArray arrayWithCapacity:0];
//            for (int i = 0; i<textFieldArray.count; i++) {
//                if ([[textFieldArray[i] placeholder] rangeOfString:@"答案"].location !=NSNotFound) {
//                    [questionTextArr addObject:textFieldArray[i]];
//                }
//            }
//            //设置报文
//            for (int j = 0; j < dataArrayCount; j++) {
//                NSDictionary *dataDic = dataArray[j];
//                questionTextField = questionTextArr[j];
//                
//                NSMutableDictionary *questionDic = [[NSMutableDictionary alloc] init];
//                [questionDic setValue:[dataDic objectForKey:@"question"] forKey:@"question"];
//                [questionDic setValue:[dataDic objectForKey:@"questionNo"] forKey:@"questionNo"];
//                [questionDic setValue:questionTextField.text forKey:@"answer"];
//                [questionArray addObject:questionDic];
//            }
//            
//            [authToolsDic setObject:questionArray forKey:@"question"];
//            
//            [authToolsArray1 addObject:authToolsDic];
            
        }
        else if ([@"identity" isEqualToString:type]) {
            [authToolsDic removeObjectForKey:@"identity"];
            NSMutableDictionary *identityDic = [[NSMutableDictionary alloc] init];
            [identityDic setValue:self.identityNoStr  forKey:@"identityNo"];
            [identityDic setValue:@"01" forKey:@"type"];
            [authToolsDic setObject:identityDic forKey:@"identity"];
            
            [authToolsArray1 addObject:authToolsDic];
        }
        else if ([@"img" isEqualToString:type]) {
            
        }
        else if ([@"bankCard" isEqualToString:type]) {
            [authToolsDic removeObjectForKey:@"bankCard"];
            NSMutableDictionary *bankCardDic = [[NSMutableDictionary alloc] init];
            [bankCardDic setValue:self.bankCardNoStr  forKey:@"bankCardNo"];
            [bankCardDic setValue:@"" forKey:@"openAccountBank"];
            [authToolsDic setObject:bankCardDic forKey:@"bankCard"];
            
            [authToolsArray1 addObject:authToolsDic];
        }else {
            
        }
    }
    
    return [[PayNucHelper sharedInstance] arrayToJSON:authToolsArray1];
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
