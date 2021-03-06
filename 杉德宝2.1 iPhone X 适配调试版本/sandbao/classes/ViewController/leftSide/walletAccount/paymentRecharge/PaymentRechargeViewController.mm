//
//  PaymentRechargeViewController.m
//  sandbao
//
//  Created by tianNanYiHao on 2017/11/1.
//  Copyright © 2017年 sand. All rights reserved.
//

#import "PaymentRechargeViewController.h"
#import "PayNucHelper.h"
#import "RechargeFinishViewController.h"
#import "DefaultWebViewController.h"
#import "PaymentPwdCell.h"
#import<CommonCrypto/CommonDigest.h>

@interface PaymentRechargeViewController ()
{
    SDBarButton *barButton;
    
}
@property (nonatomic, strong) NSString *paymentPwd;
/**
 充值支付工具
 */
@property (nonatomic, strong) NSMutableDictionary *rechargeOutPayToolDic;

/**
 work域
 */
@property (nonatomic, strong) NSDictionary *wordDic;

@end

@implementation PaymentRechargeViewController

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    //获取充值支付工具
    [self getPayTools];
    
}

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
    self.navCoverView.midTitleStr = @"代付凭证充值";
    self.navCoverView.letfImgStr = @"general_icon_back";
    
    
    __weak PaymentRechargeViewController *weakSelf = self;
    self.navCoverView.leftBlock = ^{
        [weakSelf.navigationController popViewControllerAnimated:YES];
    };
    
    
}
#pragma mark - 重写父类-点击方法集合
- (void)buttonClick:(UIButton *)btn{
    
    if (btn.tag == BTN_TAG_RECHARGE) {
        
        if (self.paymentPwd.length>0) {
            [self fee];
        }else{
            [Tool showDialog:@"请输入正确信息"];
        }
    }
    if (btn.tag == BTN_TAG_ENTERWEBVC) {
        DefaultWebViewController *defaultWebVC = [[DefaultWebViewController alloc] init];
        defaultWebVC.requestStr = Payment_ADDRESS;
        [self.navigationController pushViewController:defaultWebVC animated:YES];
    }
    
}


#pragma mark  - UI绘制

- (void)createUI{
    __weak typeof(self) weakself = self;
    PaymentPwdCell *paymentPwdCell = [PaymentPwdCell createPaymentCellViewOY:0];
    paymentPwdCell.tip.text = @"请输入正确代付凭证密码";
    paymentPwdCell.textfield.text = SHOWTOTEST(@"177C98344B3B841F");
    self.paymentPwd = SHOWTOTEST(@"177C98344B3B841F");
    paymentPwdCell.successBlock = ^(NSString *textfieldText) {
        weakself.paymentPwd = textfieldText;
    };
    paymentPwdCell.line.hidden = YES;
    [self.baseScrollView addSubview:paymentPwdCell];

    [paymentPwdCell mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.baseScrollView.mas_top).offset(UPDOWNSPACE_20);
        make.centerX.equalTo(self.baseScrollView);
        make.size.mas_equalTo(paymentPwdCell.size);
    }];
    
    
    //rechargeBtn
    barButton = [[SDBarButton alloc] init];
    UIView *rechargeBtn = [barButton createBarButton:@"充值" font:FONT_15_Regular titleColor:COLOR_FFFFFF backGroundColor:COLOR_58A5F6 leftSpace:LEFTRIGHTSPACE_40];
    barButton.btn.tag = BTN_TAG_RECHARGE;
    [barButton.btn addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.baseScrollView addSubview:rechargeBtn];
    
    [rechargeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(paymentPwdCell.mas_bottom).offset(UPDOWNSPACE_69);
        make.centerX.equalTo(self.baseScrollView.mas_centerX);
        make.size.mas_equalTo(rechargeBtn.size);
    }];
    
    //代付凭证余额查询
    NSMutableAttributedString *paymentCheckStr = [[NSMutableAttributedString alloc] initWithString:@"余额未知? 立即查询"];
    [paymentCheckStr addAttributes:@{
                                        NSFontAttributeName:FONT_13_Regular,
                                        NSForegroundColorAttributeName:COLOR_358BEF
                                        } range:NSMakeRange(8, 2)];
    UIButton *paymenMoneyRequestBtn = [Tool createButton:nil attributeStr:paymentCheckStr font:FONT_13_OpenSan textColor:COLOR_358BEF];
    paymenMoneyRequestBtn.tag = BTN_TAG_ENTERWEBVC;
    [paymenMoneyRequestBtn addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.baseScrollView addSubview:paymenMoneyRequestBtn];
    
    [paymenMoneyRequestBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(rechargeBtn.mas_bottom).offset(UPDOWNSPACE_25);
        make.centerX.equalTo(self.baseScrollView);
        make.size.mas_equalTo(CGSizeMake(paymenMoneyRequestBtn.width*2, paymenMoneyRequestBtn.height*2));
    }];
    
    
    
    //装载所有的textfiled
    self.textfiledArr = [NSMutableArray arrayWithArray:@[paymentPwdCell.textfield]];
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
#pragma mark 查询支付工具
- (void)getPayTools{
    
  
    
}

/**
 校验支付工具
 
 @param rechargePayToolsArray void
 */
- (void)checkInPayToolsOutPayTools:(NSArray*)rechargePayToolsArray{
    
    //检测支付工具
    if (rechargePayToolsArray.count>0) {
        //0.排序
        rechargePayToolsArray = [Tool orderForPayTools:rechargePayToolsArray];
        //1. 取代付凭证支付工具(1014)
        NSDictionary *payToolDic = [Tool getPayToolsInfo:rechargePayToolsArray];
        NSDictionary *payForAnotherDic = [payToolDic objectForKey:@"payForAnotherDic"];
        
        if (![payForAnotherDic objectForKey:@"available"]) {
            [Tool showDialog:@"无可用支付工具" defulBlock:^{
                 [self.navigationController popViewControllerAnimated:YES];
            }];
        }else{
            //获取转出支付工具
            self.rechargeOutPayToolDic = [NSMutableDictionary dictionaryWithDictionary:payForAnotherDic];
        }
    }else{
        [Tool showDialog:@"无可用工具下发" defulBlock:^{
            [self.navigationController popViewControllerAnimated:YES];
        }];
    }
}




#pragma mark 计算手续费fee
/**
 *@brief 手续费
 *@return
 */
- (void)fee
{
   
}


#pragma mark 确认充值
- (void)recharge:(NSString *)param paramDic:(NSDictionary *)paramDic
{
   //
    
}







//sha1加密方式
- (NSString *)sha1:(NSString *)input
{
    //const char *cstr = [input cStringUsingEncoding:NSUTF8StringEncoding];
    //NSData *data = [NSData dataWithBytes:cstr length:input.length];
    
    NSData *data = [input dataUsingEncoding:NSUTF8StringEncoding];
    
    uint8_t digest[CC_SHA1_DIGEST_LENGTH];
    
    CC_SHA1(data.bytes, (unsigned int)data.length, digest);
    
    NSMutableString *output = [NSMutableString stringWithCapacity:CC_SHA1_DIGEST_LENGTH * 2];
    
    for(int i=0; i<CC_SHA1_DIGEST_LENGTH; i++) {
        [output appendFormat:@"%02x", digest[i]];
    }
    
    return output;
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
