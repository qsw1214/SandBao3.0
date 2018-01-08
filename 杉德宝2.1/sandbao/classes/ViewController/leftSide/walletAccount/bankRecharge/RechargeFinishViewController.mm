//
//  RechargeFinishViewController.m
//  sandbao
//
//  Created by tianNanYiHao on 2017/10/28.
//  Copyright © 2017年 sand. All rights reserved.
//

#import "RechargeFinishViewController.h"
#import "PayNucHelper.h"

@interface RechargeFinishViewController ()
{
    UIView *headView;
    UIView *bodyView;
}
@end

@implementation RechargeFinishViewController

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    self.sideMenuViewController.panGestureEnabled = NO;
    self.baseScrollView.pagingEnabled = NO;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
    
    [self create_HeadView];
    [self create_BodyView];
    
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
    self.navCoverView.midTitleStr = self.transTypeName;
    self.navCoverView.rightTitleStr = @"完成";
    
    __weak RechargeFinishViewController *weakSelf = self;
    self.navCoverView.rightBlock = ^{
        //1.刷新支付工具
        [weakSelf ownPayTools];
    };
    
}
#pragma mark - 重写父类-点击方法集合
- (void)buttonClick:(UIButton *)btn{
    
    
    
}


#pragma mark  - UI绘制

- (void)create_HeadView{
    //headView
    headView = [[UIView alloc] init];
    headView.backgroundColor = COLOR_FFFFFF;
    [self.baseScrollView addSubview:headView];
    
    //titleLab
    UILabel *titleLab = [Tool createLable:@"杉德宝" attributeStr:nil font:FONT_15_Regular textColor:COLOR_343339 alignment:NSTextAlignmentCenter];
    [headView addSubview:titleLab];
    
    //moneyLab
    NSString *addMoneyStr = [NSString stringWithFormat:@"%@",self.amtMoneyStr];
    UILabel *moneyLab = [Tool createLable:addMoneyStr attributeStr:nil font:FONT_28_SFUIT_Rrgular textColor:COLOR_000000 alignment:NSTextAlignmentCenter];
    [headView addSubview:moneyLab];
    
    //rechargeFinishLab
    UILabel *rechargeFinishLab = [Tool createLable:self.transTypeName attributeStr:nil font:FONT_14_Regular textColor:COLOR_343339_7 alignment:NSTextAlignmentCenter];
    [headView addSubview:rechargeFinishLab];
    
    headView.width = SCREEN_WIDTH;
    headView.height = UPDOWNSPACE_25 + titleLab.height + UPDOWNSPACE_20 +  moneyLab.height + UPDOWNSPACE_15 + rechargeFinishLab.height + UPDOWNSPACE_43;
    
    [headView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.baseScrollView.mas_top).offset(UPDOWNSPACE_20);
        make.centerX.equalTo(self.baseScrollView);
        make.size.mas_equalTo(CGSizeMake(headView.width, headView.height));
    }];
    
    [titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(headView.mas_top).offset(UPDOWNSPACE_25);
        make.centerX.equalTo(headView);
        make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH, titleLab.height));
    }];
    
    [moneyLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(titleLab.mas_bottom).offset(UPDOWNSPACE_20);
        make.centerX.equalTo(headView);
        make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH, moneyLab.height));
    }];
    
    [rechargeFinishLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(moneyLab.mas_bottom).offset(UPDOWNSPACE_15);
        make.centerX.equalTo(headView);
        make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH, rechargeFinishLab.height));
    }];
    
}

- (void)create_BodyView{
    //bodyView
    bodyView = [[UIView alloc] init];
    bodyView.backgroundColor = COLOR_FFFFFF;
    [self.baseScrollView addSubview:bodyView];
    
    //payObjectLab
    UILabel *payObjectLab = [Tool createLable:@"付款方" attributeStr:nil font:FONT_13_Regular textColor:COLOR_343339_7 alignment:NSTextAlignmentLeft];
    [bodyView addSubview:payObjectLab];
    
    //payObjectDetLab
    UILabel *payObjectDetLab = [Tool createLable:self.payOutName attributeStr:nil font:FONT_13_Regular textColor:COLOR_343339 alignment:NSTextAlignmentRight];
    [bodyView addSubview:payObjectDetLab];
    
    //line
    UIView *line = [[UIView alloc] init];
    line.backgroundColor = COLOR_A1A2A5_3;
    line.size = CGSizeMake(SCREEN_WIDTH - 2*LEFTRIGHTSPACE_20, 1);
    [bodyView addSubview:line];
    
    UILabel *payInfoLab;
    UILabel *payInfoLabDesLab;
    UIView *lineTwo;
    if (self.payOutNo.length>0) {
        //payInfoLab
        payInfoLab = [Tool createLable:@"扣款信息" attributeStr:nil font:FONT_13_Regular textColor:COLOR_343339_7 alignment:NSTextAlignmentLeft];
        [bodyView addSubview:payInfoLab];

        //payInfoLabDesLab
        payInfoLabDesLab = [Tool createLable:self.payOutNo attributeStr:nil font:FONT_13_Regular textColor:COLOR_343339 alignment:NSTextAlignmentRight];
        [bodyView addSubview:payInfoLabDesLab];
        
        //line
        lineTwo = [[UIView alloc] init];
        lineTwo.backgroundColor = COLOR_A1A2A5_3;
        lineTwo.size = CGSizeMake(SCREEN_WIDTH - 2*LEFTRIGHTSPACE_20, 1);
        [bodyView addSubview:lineTwo];
    }
   
    //payMoneyLab
    UILabel *payMoneyLab = [Tool createLable:@"扣款金额" attributeStr:nil font:FONT_13_Regular textColor:COLOR_343339_7 alignment:NSTextAlignmentLeft];
    [bodyView addSubview:payMoneyLab];
    
    //payMoneyDetLab
    NSString *minusMoneyStr = [NSString stringWithFormat:@"- %@",self.amtMoneyStr];
    UILabel *payMoneyDetLab = [Tool createLable:minusMoneyStr attributeStr:nil font:FONT_13_Regular textColor:COLOR_343339 alignment:NSTextAlignmentRight];
    [bodyView addSubview:payMoneyDetLab];
    
    
    payObjectDetLab.width = SCREEN_WIDTH - LEFTRIGHTSPACE_35 - payObjectLab.width - LEFTRIGHTSPACE_35;
    payMoneyDetLab.width = SCREEN_WIDTH - LEFTRIGHTSPACE_35 - payMoneyLab.width - LEFTRIGHTSPACE_35;
    
    if (self.payOutNo.length>0) {
        bodyView.height = (UPDOWNSPACE_25 + payObjectLab.height + UPDOWNSPACE_25)*3;
    }else{
        bodyView.height = (UPDOWNSPACE_25 + payObjectLab.height + UPDOWNSPACE_25)*2;
    }
    
    
    [bodyView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(headView.mas_bottom).offset(UPDOWNSPACE_0);
        make.left.equalTo(self.baseScrollView.mas_left);
        make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH, bodyView.height));
    }];
    
    [payObjectLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(bodyView.mas_top).offset(UPDOWNSPACE_25);
        make.left.equalTo(bodyView.mas_left).offset(LEFTRIGHTSPACE_35);
        make.size.mas_equalTo(payObjectLab.size);
    }];
    
    [payObjectDetLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(bodyView.mas_top).offset(UPDOWNSPACE_25);
        make.left.equalTo(payObjectLab.mas_right).offset(LEFTRIGHTSPACE_00);
        make.size.mas_equalTo(CGSizeMake(payObjectDetLab.width, payObjectDetLab.height));
    }];
    
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(payObjectLab.mas_bottom).offset(UPDOWNSPACE_25);
        make.left.equalTo(bodyView.mas_left).offset(LEFTRIGHTSPACE_20);
        make.size.mas_equalTo(line.size);
    }];
    
    if (self.payOutNo.length>0) {
        [payInfoLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(line.mas_bottom).offset(UPDOWNSPACE_25);
            make.left.equalTo(bodyView.mas_left).offset(LEFTRIGHTSPACE_35);
            make.size.mas_equalTo(payInfoLab.size);
        }];
        
        [payInfoLabDesLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(line.mas_bottom).offset(UPDOWNSPACE_25);
            make.left.equalTo(payInfoLab.mas_right).offset(LEFTRIGHTSPACE_00);
            make.size.mas_equalTo(CGSizeMake(payMoneyDetLab.width, payMoneyDetLab.height));
        }];
        
        [lineTwo mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(payInfoLab.mas_bottom).offset(UPDOWNSPACE_25);
            make.left.equalTo(bodyView.mas_left).offset(LEFTRIGHTSPACE_20);
            make.size.mas_equalTo(line.size);
        }];
    }
    [payMoneyLab mas_makeConstraints:^(MASConstraintMaker *make) {
        if (self.payOutNo.length>0) {
            make.top.equalTo(lineTwo.mas_bottom).offset(UPDOWNSPACE_25);
        }else{
           make.top.equalTo(line.mas_bottom).offset(UPDOWNSPACE_25);
        }
        make.left.equalTo(bodyView.mas_left).offset(LEFTRIGHTSPACE_35);
        make.size.mas_equalTo(payMoneyLab.size);
    }];
   
    [payMoneyDetLab mas_makeConstraints:^(MASConstraintMaker *make) {
        if (self.payOutNo.length>0) {
             make.top.equalTo(lineTwo.mas_bottom).offset(UPDOWNSPACE_25);
        }else{
             make.top.equalTo(line.mas_bottom).offset(UPDOWNSPACE_25);
        }
        make.left.equalTo(payMoneyLab.mas_right).offset(LEFTRIGHTSPACE_00);
        make.size.mas_equalTo(CGSizeMake(payMoneyDetLab.width, payMoneyDetLab.height));
    }];
}

#pragma mark - 业务逻辑
#pragma mark 查询我方支付工具鉴权工具
/**
 *@brief 查询我方支付工具
 */
- (void)ownPayTools
{
    self.HUD = [SDMBProgressView showSDMBProgressOnlyLoadingINViewImg:self.view];
    [SDRequestHelp shareSDRequest].HUD = self.HUD;
    [SDRequestHelp shareSDRequest].controller = self;
    [[SDRequestHelp shareSDRequest] dispatchGlobalQuque:^{
        __block BOOL error = NO;
        paynuc.set("tTokenType", "01001501");
        paynuc.set("cfg_termFp", [[Tool setCfgTempFpStaticDataFlag:NO DynamicDataFlag:YES] UTF8String]);
        [[SDRequestHelp shareSDRequest] requestWihtFuncName:@"token/getTtoken/v1" errorBlock:^(SDRequestErrorType type) {
            error = YES;
        } successBlock:^{
            
        }];
        if (error) return ;
        
        paynuc.set("payToolKinds", "[]");
        [[SDRequestHelp shareSDRequest] requestWihtFuncName:@"payTool/getOwnPayTools/v1" errorBlock:^(SDRequestErrorType type) {
            error = YES;
        } successBlock:^{
            [[SDRequestHelp shareSDRequest] dispatchToMainQueue:^{
                [self.HUD hidden];
                
                NSArray *payToolsArray = [[PayNucHelper sharedInstance] jsonStringToArray:[NSString stringWithUTF8String:paynuc.get("payTools").c_str()]];
                //支付工具排序
                payToolsArray = [Tool orderForPayTools:payToolsArray];
                [CommParameter sharedInstance].ownPayToolsArray = payToolsArray;
                [self.navigationController popToRootViewControllerAnimated:YES];
                
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
