//
//  PaymentActiveViewController.m
//  sandbao
//
//  Created by tianNanYiHao on 2017/10/29.
//  Copyright © 2017年 sand. All rights reserved.
//


#import "PaymentActiveViewController.h"
#import "PayNucHelper.h"
#import "RechargeFinishViewController.h"


#import "PaymentNoCell.h"
#import "PaymentCodeCell.h"
#import "PaymentPwdCell.h"


/**
 代付凭证充值
 */
@interface PaymentActiveViewController ()
{
    
    SDBarButton *barButton;
}
@property (nonatomic, strong) NSString *paymentNo;
@property (nonatomic, strong) NSString *paymenCode;
@end

@implementation PaymentActiveViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self createUI];
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
    self.navCoverView.midTitleStr = @"代付凭证激活";
    self.navCoverView.letfImgStr = @"general_icon_back";
    
    
    __weak PaymentActiveViewController *weakSelf = self;
    self.navCoverView.leftBlock = ^{
        [weakSelf.navigationController popViewControllerAnimated:YES];
    };
    
    
}
#pragma mark - 重写父类-点击方法集合
- (void)buttonClick:(UIButton *)btn{
    
    if (btn.tag == BTN_TAG_PAYMENTACTIVE) {
        if (self.paymentNo.length>0 && self.paymenCode.length>0) {
            //激活代付凭证权限
            [self getBalances];
        }else{
            [Tool showDialog:@"请输入正确信息"];
        }
    }
    
}


#pragma mark  - UI绘制

- (void)createUI{
    __weak typeof(self) weakself = self;
    PaymentNoCell *paymentNoCell = [PaymentNoCell createPaymentCellViewOY:0];
    paymentNoCell.tip.text = @"请输入正确代付凭证号";
    paymentNoCell.textfield.text = SHOWTOTEST(@"6662000700000132");
    self.paymentNo = SHOWTOTEST(@"6662000700000132");
    paymentNoCell.successBlock = ^(NSString *textfieldText) {
        weakself.paymentNo = textfieldText;
    };
    [self.baseScrollView addSubview:paymentNoCell];
    
    PaymentCodeCell *paymenCodeCell = [PaymentCodeCell createPaymentCellViewOY:0];
    paymenCodeCell.tip.text = @"请输入正确代付凭证校验码";
    paymenCodeCell.textfield.text = SHOWTOTEST(@"095536");
    self.paymenCode = SHOWTOTEST(@"095536");
    paymenCodeCell.line.hidden = YES;
    paymenCodeCell.successBlock = ^(NSString *textfieldText) {
        weakself.paymenCode = textfieldText;
    };
    [self.baseScrollView addSubview:paymenCodeCell];
    
//    PaymentPwdCell *paymentPwdCell = [PaymentPwdCell createPaymentCellViewOY:0];
//    paymentPwdCell.line.hidden = YES;
//    [self.baseScrollView addSubview:paymentPwdCell];
    
    //rechargeBarBtn
    barButton = [[SDBarButton alloc] init];
    UIView *rechargeBarBtn = [barButton createBarButton:@"激活" font:FONT_15_Regular titleColor:COLOR_FFFFFF backGroundColor:COLOR_58A5F6 leftSpace:LEFTRIGHTSPACE_40];
    barButton.btn.tag = BTN_TAG_PAYMENTACTIVE;
    [barButton.btn addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.baseScrollView addSubview:rechargeBarBtn];
    
    [paymentNoCell mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.baseScrollView.mas_top).offset(UPDOWNSPACE_20);
        make.centerX.equalTo(self.baseScrollView);
        make.size.mas_equalTo(paymentNoCell.size);
    }];
    
    [paymenCodeCell mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(paymentNoCell.mas_bottom);
        make.centerX.equalTo(self.baseScrollView);
        make.size.mas_equalTo(paymenCodeCell.size);
    }];
    
    [rechargeBarBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(paymenCodeCell.mas_bottom).offset(UPDOWNSPACE_69);
        make.centerX.equalTo(self.baseScrollView.mas_centerX);
        make.size.mas_equalTo(rechargeBarBtn.size);
    }];
    
    //装载所有的textfiled
    self.textfiledArr = [NSMutableArray arrayWithArray:@[paymentNoCell.textfield,paymenCodeCell.textfield]];
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
#pragma mark 账户余额查询(目前用于激活代付凭证)
-(void)getBalances{
    self.HUD = [SDMBProgressView showSDMBProgressOnlyLoadingINViewImg:self.view];
    [SDRequestHelp shareSDRequest].HUD = self.HUD;
    [SDRequestHelp shareSDRequest].controller = self;
    [[SDRequestHelp shareSDRequest] dispatchGlobalQuque:^{
        __block BOOL error = NO;
        paynuc.set("tTokenType", "03000401");
        paynuc.set("cfg_termFp", [[Tool setCfgTempFpStaticDataFlag:NO DynamicDataFlag:YES] UTF8String]);
        [[SDRequestHelp shareSDRequest] requestWihtFuncName:@"token/getTtoken/v1" errorBlock:^(SDRequestErrorType type) {
            error = YES;
        } successBlock:^{
            
        }];
        if (error) return ;
        
        //此处需要手动拼装支付工具报文
        NSDictionary *account = [NSDictionary dictionary];
        account = @{
                    @"accNo":self.paymentNo
                    };
        
        NSDictionary *authTool = [NSDictionary dictionary];
        authTool = @{
                     @"type":@"cardCheckCode",
                     @"cardCheckCode":self.paymenCode
                     };
        NSDictionary *payTool = [NSDictionary dictionary];
        payTool = @{
                    @"type":@"1014",
                    @"account":account,
                    @"authTools":@[authTool]
                    };
        
        NSString *payTools = [[PayNucHelper sharedInstance] arrayToJSON:(NSMutableArray*)@[payTool]];
        paynuc.set("payTools", [payTools UTF8String]);
        [[SDRequestHelp shareSDRequest] requestWihtFuncName:@"payTool/getBalances/v1" errorBlock:^(SDRequestErrorType type) {
            error = YES;
        } successBlock:^{
            [[SDRequestHelp shareSDRequest] dispatchToMainQueue:^{
                [self.HUD hidden];
                
                //激活成功
                [Tool showDialog:@"代付凭证激活成功" defulBlock:^{
                    //代付凭证标识置为YES
                    [CommParameter sharedInstance].payForAnotherFlag = YES;
                    [self.navigationController popViewControllerAnimated:YES];
                }];
                
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
