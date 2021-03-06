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
    
    UIView *nextBarbtn;
    
    NSDictionary *payToolDic;   //支付工具字典
    
    NSDictionary *userInfoDic;  //用户信息字典
    
    NSDictionary *accountDic;   //支付工具域下账户域字典
    
    NSArray *appendUIArr;        //保存追加UI的子view
    
    SDBarButton *barButton;
}
@property (nonatomic, strong) NSString *bankCardNoStr;  //银行卡号
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
    self.navCoverView.midTitleStr = @"";
    __weak AddBankCardViewController *weakSelf = self;
    self.navCoverView.leftBlock = ^{
        [weakSelf.navigationController popViewControllerAnimated:YES];
    };
    
}
#pragma mark - 重写父类-点击方法集合
- (void)buttonClick:(UIButton *)btn{
    
    if (btn.tag == BTN_TAG_NEXT) {
        if (self.bankCardNoStr.length>0) {
            
            [self queryCardDetail];
        }
    
    }
    if (btn.tag == BTN_TAG_BINDBANKCARD) {
        AddBankCardSecViewController *addSecVC = [[AddBankCardSecViewController alloc] init];
        addSecVC.payToolDic = payToolDic;
        addSecVC.userInfoDic = userInfoDic;
        addSecVC.accountDic = accountDic;
        addSecVC.bankCardNo = self.bankCardNoStr;
        [self.navigationController pushViewController:addSecVC animated:YES];
    }

}

#pragma mark  - UI绘制
- (void)createUI{
    
    __weak typeof(self) weakself = self;
    
    //titleLab1
    UILabel *titleLab = [Tool createLable:@"绑定银行卡" attributeStr:nil font:FONT_28_Medium textColor:COLOR_343339 alignment:NSTextAlignmentCenter];
    [self.baseScrollView addSubview:titleLab];
    
    //titleLab2
    UILabel *titleDesLab = [Tool createLable:@"请绑定正确银行卡" attributeStr:nil font:FONT_16_Regular textColor:COLOR_343339_7 alignment:NSTextAlignmentCenter];
    [self.baseScrollView addSubview:titleDesLab];

    //cardNoAuthToolView
    cardNoAuthToolView = [CardNoAuthToolView createAuthToolViewOY:0];
    cardNoAuthToolView.tip.text = @"请输入有效银行卡卡号";
    cardNoAuthToolView.textfiled.text = SHOWTOTEST(@"6212261001042568540");
    self.bankCardNoStr = SHOWTOTEST(@"6212261001042568540");
    cardNoAuthToolView.successBlock = ^(NSString *textfieldText) {
        weakself.bankCardNoStr = textfieldText;
    };
    [self.baseScrollView addSubview:cardNoAuthToolView];
    
    
    //nextBtn
    barButton = [[SDBarButton alloc] init];
    nextBarbtn = [barButton createBarButton:@"继续" font:FONT_15_Regular titleColor:COLOR_FFFFFF backGroundColor:COLOR_58A5F6 leftSpace:LEFTRIGHTSPACE_40];
    barButton.btn.tag = BTN_TAG_NEXT;
    [barButton.btn addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
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
        make.top.equalTo(cardNoAuthToolView.mas_bottom).offset(UPDOWNSPACE_69);
        make.centerX.equalTo(self.baseScrollView.mas_centerX);
        make.size.mas_equalTo(nextBarbtn.size);
    }];
    //装载所有的textfiled
    self.textfiledArr = [NSMutableArray arrayWithArray:@[cardNoAuthToolView.textfiled]];
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

//查询银行卡后,追加UI
- (void)appendUI{
    
    
    //bankAuthToolView
    BankAuthToolView *bankAuthToolView = [BankAuthToolView createAuthToolViewOY:0];
    bankAuthToolView.titleLab.text = @"该卡所属银行";
    bankAuthToolView.chooseBankTitleLab.text = [payToolDic objectForKey:@"title"];
    bankAuthToolView.userInteractionEnabled = NO;
    [self.baseScrollView addSubview:bankAuthToolView];
    
    [bankAuthToolView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(cardNoAuthToolView.mas_bottom).offset(UPDOWNSPACE_0);
        make.centerX.equalTo(self.baseScrollView);
        make.size.mas_equalTo(bankAuthToolView.size);
    }];
    
    
    barButton.btn.tag = BTN_TAG_BINDBANKCARD;
    [nextBarbtn mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(bankAuthToolView.mas_bottom).offset(UPDOWNSPACE_25);
        make.centerX.equalTo(self.baseScrollView.mas_centerX);
        make.size.mas_equalTo(nextBarbtn.size);
    }];
    
    
    //重置contentSize
    CGFloat appendViewHeight = bankAuthToolView.height + UPDOWNSPACE_25 + UPDOWNSPACE_25;
    self.baseScrollView.contentSize = CGSizeMake(self.baseScrollView.contentSize.width, self.baseScrollView.contentSize.height + appendViewHeight);
    
    //保存追加的UI子View
    appendUIArr = @[bankAuthToolView];
}


//删除追加的UI及清空数据
- (void)removeAppendUI{
    
    if (appendUIArr.count > 0) {
        //删除追加的UI
        [appendUIArr makeObjectsPerformSelector:@selector(removeFromSuperview)];
        //清空 数组
        appendUIArr = nil;
        
        //重置约束
        barButton.btn.tag = BTN_TAG_NEXT;
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
