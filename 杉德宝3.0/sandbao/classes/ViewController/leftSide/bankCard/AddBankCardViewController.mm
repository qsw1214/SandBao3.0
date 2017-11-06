//
//  AddBankCardViewController.m
//  sandbao
//
//  Created by tianNanYiHao on 2017/11/6.
//  Copyright © 2017年 sand. All rights reserved.
//

#import "AddBankCardViewController.h"
#import "PayNucHelper.h"
#import "AddBankCardSecViewController.h"
@interface AddBankCardViewController ()
{
     CardNoAuthToolView *cardNoAuthToolView;
     NSString *bankCardNoStr;  //银行卡号
    
    UIButton *nextBarbtn;
    
    NSDictionary *payToolDic;   //支付工具字典
    
    NSDictionary *userInfoDic;  //用户信息字典
    
    NSArray *appendUIArr;        //保存追加UI的子view
}

@end

@implementation AddBankCardViewController

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
    
    
}
#pragma mark - 重写父类-导航设置方法
- (void)setNavCoverView{
    [super setNavCoverView];
    self.navCoverView.style = NavCoverStyleWhite;
    self.navCoverView.letfImgStr = @"login_icon_back";
    self.navCoverView.midTitleStr = @"绑定银行卡";
    __block AddBankCardViewController *weakSelf = self;
    self.navCoverView.leftBlock = ^{
        [weakSelf presentLeftMenuViewController:weakSelf.sideMenuViewController];
    };
    
}
#pragma mark - 重写父类-点击方法集合
- (void)buttonClick:(UIButton *)btn{
    
    if (btn.tag == BTN_TAG_NEXT) {
        if (bankCardNoStr.length>0) {
            
            [self queryCardDetail];
        }
    
    }
    if (btn.tag == BTN_TAG_BINDBANKCARD) {
        AddBankCardSecViewController *addSecVC = [[AddBankCardSecViewController alloc] init];
        addSecVC.payToolDic = payToolDic;
        addSecVC.userInfoDic = userInfoDic;
        [self.navigationController pushViewController:addSecVC animated:YES];
    }

}

#pragma mark  - UI绘制
- (void)createUI{
    
    //titleLab1
    UILabel *titleLab = [Tool createLable:@"绑定银行卡" attributeStr:nil font:FONT_28_Medium textColor:COLOR_343339 alignment:NSTextAlignmentCenter];
    [self.baseScrollView addSubview:titleLab];
    
    //titleLab2
    UILabel *titleDesLab = [Tool createLable:@"请绑定正确银行卡" attributeStr:nil font:FONT_16_Regular textColor:COLOR_343339_7 alignment:NSTextAlignmentCenter];
    [self.baseScrollView addSubview:titleDesLab];

    //cardNoAuthToolView
    cardNoAuthToolView = [CardNoAuthToolView createAuthToolViewOY:0];
    cardNoAuthToolView.tip.text = @"请输入有效银行卡卡号";
    cardNoAuthToolView.textfiled.text = SHOWTOTEST(@"6217001210062891245");
    bankCardNoStr = SHOWTOTEST(@"6217001210062891245");
    cardNoAuthToolView.successBlock = ^(NSString *textfieldText) {
        bankCardNoStr = textfieldText;
    };
    [self.baseScrollView addSubview:cardNoAuthToolView];
    
    
    //nextBtn
    nextBarbtn = [Tool createBarButton:@"继续" font:FONT_15_Regular titleColor:COLOR_FFFFFF backGroundColor:COLOR_58A5F6 leftSpace:LEFTRIGHTSPACE_40];
    nextBarbtn.tag = BTN_TAG_NEXT;
    [nextBarbtn addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
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
  
    
    [cardNoAuthToolView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(titleDesLab.mas_bottom).offset(UPDOWNSPACE_58);
        make.centerX.equalTo(self.baseScrollView.mas_centerX);
        make.size.mas_equalTo(cardNoAuthToolView.size);
    }];
    
    [nextBarbtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(cardNoAuthToolView.mas_bottom).offset(UPDOWNSPACE_15);
        make.centerX.equalTo(self.baseScrollView.mas_centerX);
        make.size.mas_equalTo(nextBarbtn.size);
    }];
}

//查询银行卡后,追加UI
- (void)appendUI{
    
    
    //bankAuthToolView
    BankAuthToolView *bankAuthToolView = [BankAuthToolView createAuthToolViewOY:0];
    bankAuthToolView.chooseBankTitleLab.text = [payToolDic objectForKey:@"title"];
    bankAuthToolView.userInteractionEnabled = NO;
    [self.baseScrollView addSubview:bankAuthToolView];
    
    //moreBankListBtn
    UIButton *moreBankListBtn = [Tool createButton:@"支持银行" attributeStr:nil font:FONT_14_Regular textColor:COLOR_343339_7];
    moreBankListBtn.tag = BTN_TAG_SHOWBANKLIST;
    [moreBankListBtn setImage:[UIImage imageNamed:@"general_icon_detail"] forState:UIControlStateNormal];
    CGSize moreBankListBtnSize = [moreBankListBtn sizeThatFits:CGSizeZero];
    [self.baseScrollView addSubview:moreBankListBtn];
    
    [bankAuthToolView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(cardNoAuthToolView.mas_bottom).offset(UPDOWNSPACE_0);
        make.centerX.equalTo(self.baseScrollView);
        make.size.mas_equalTo(bankAuthToolView.size);
    }];
    
    [moreBankListBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(bankAuthToolView.mas_bottom).offset(UPDOWNSPACE_25);
        make.right.equalTo(bankAuthToolView.mas_right).offset(-LEFTRIGHTSPACE_40);
        make.size.mas_equalTo(moreBankListBtnSize);
    }];
    
    nextBarbtn.tag = BTN_TAG_BINDBANKCARD;
    [nextBarbtn mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(moreBankListBtn.mas_bottom).offset(UPDOWNSPACE_25);
        make.centerX.equalTo(self.baseScrollView.mas_centerX);
        make.size.mas_equalTo(nextBarbtn.size);
    }];
    
    
    //重置contentSize
    CGFloat appendViewHeight = bankAuthToolView.height + moreBankListBtn.height + UPDOWNSPACE_25 + UPDOWNSPACE_25;
    self.baseScrollView.contentSize = CGSizeMake(self.baseScrollView.contentSize.width, self.baseScrollView.contentSize.height + appendViewHeight);
    
    //保存追加的UI子View
    appendUIArr = @[bankAuthToolView,moreBankListBtn];
}


//删除追加的UI及清空数据
- (void)removeAppendUI{
    
    if (appendUIArr.count > 0) {
        //删除追加的UI
        [appendUIArr makeObjectsPerformSelector:@selector(removeFromSuperview)];
        //清空 数组
        appendUIArr = nil;
        
        //重置约束
        nextBarbtn.tag = BTN_TAG_NEXT;
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
    self.HUD = [SDMBProgressView showSDMBProgressOnlyLoadingINViewImg:self.view];
    [SDRequestHelp shareSDRequest].HUD = self.HUD;
    [SDRequestHelp shareSDRequest].controller = self;
    [[SDRequestHelp shareSDRequest] dispatchGlobalQuque:^{
        __block BOOL error = NO;
        paynuc.set("tTokenType", "01001001");
        [[SDRequestHelp shareSDRequest] requestWihtFuncName:@"token/getTtoken/v1" errorBlock:^(SDRequestErrorType type) {
            error = YES;
        } successBlock:^{
            
        }];
        if (error) return ;
        
        NSMutableDictionary *accountDic = [[NSMutableDictionary alloc] init];
        [accountDic setValue:@"03" forKey:@"kind"];
        [accountDic setValue:[NSString stringWithFormat:@"%@", bankCardNoStr] forKey:@"accNo"];
        NSString *account = [[PayNucHelper sharedInstance] dictionaryToJson:accountDic];
        [SDLog logTest:account];
        paynuc.set("account", [account UTF8String]);
        [[SDRequestHelp shareSDRequest] requestWihtFuncName:@"card/queryCardDetail/v1" errorBlock:^(SDRequestErrorType type) {
            error = YES;
            
        } successBlock:^{
            [[SDRequestHelp shareSDRequest] dispatchToMainQueue:^{
                [self.HUD hidden];
                
                NSString *payTool = [NSString stringWithUTF8String:paynuc.get("payTool").c_str()];
                payToolDic = [[PayNucHelper sharedInstance] jsonStringToDictionary:payTool];
                
                NSString *userInfo = [NSString stringWithUTF8String:paynuc.get("userInfo").c_str()];
                userInfoDic = [[PayNucHelper sharedInstance] jsonStringToDictionary:userInfo];
                
                NSMutableArray *payTool_authToolsArr = [payToolDic objectForKey:@"authTools"];
                //信用卡
                if (payTool_authToolsArr.count > 0) {
                    //暂不处理
                    [Tool showDialog:@"暂不支持信用卡绑定"];
                }
                //借记卡
                else{
                    //追加UI
                    [self appendUI];
                }
                
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
