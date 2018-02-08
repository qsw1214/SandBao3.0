//
//  ForgetLoginPwdViewController.m
//  sandbao
//
//  Created by tianNanYiHao on 2017/11/10.
//  Copyright © 2017年 sand. All rights reserved.
//

#import "ForgetLoginPwdViewController.h"
#import "PayNucHelper.h"

#import "VerifyTypeViewController.h"

@interface ForgetLoginPwdViewController ()
{
    SDBarButton *barButton;
}
@property (nonatomic, strong) NSString * phoneNum;
@end

@implementation ForgetLoginPwdViewController


- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    //申请虚拟sToken/tToken/获取鉴权
    [self getStokenAndtTokenAndgetAuthTools];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self createUI];
}

#pragma mark - 重写父类-baseScrollView设置
- (void)setBaseScrollview{
    [super setBaseScrollview];
    self.baseScrollView.scrollEnabled = YES;
}

#pragma mark - 重写父类-导航设置方法
- (void)setNavCoverView{
    [super setNavCoverView];
    self.navCoverView.style = NavCoverStyleWhite;
    self.navCoverView.letfImgStr = @"general_icon_back";

    __weak ForgetLoginPwdViewController *weakSelf = self;
    self.navCoverView.leftBlock = ^{
        [weakSelf.navigationController popViewControllerAnimated:YES];
    };
    
    
}
#pragma mark - 重写父类-点击方法集合
- (void)buttonClick:(UIButton *)btn{
    if (btn.tag == BTN_TAG_NEXT) {
        if (self.phoneNum.length>0) {
            //@"忘记登录密码"
            //上送鉴权工具 + 校验用户
            [self setAuthToolsAndCheckUser];
        }
    }
}

#pragma mark  - UI绘制
- (void)createUI{
    __weak typeof(self) weakself = self;
    //titleLab1
    UILabel *titleLab = [Tool createLable:@"输入要找回密码的账号" attributeStr:nil font:FONT_28_Medium textColor:COLOR_343339 alignment:NSTextAlignmentCenter];
    [self.baseScrollView addSubview:titleLab];
    
    //PhoneAuthToolView
    PhoneAuthToolView *phoneAuthToolView = [PhoneAuthToolView createAuthToolViewOY:0];
    phoneAuthToolView.titleLab.text = @"你的手机号";
    phoneAuthToolView.tip.text = @"请输入格式正确的手机号";
    phoneAuthToolView.textfiled.text = SHOWTOTEST(@"15151474188");
    self.phoneNum = SHOWTOTEST(@"15151474188");;
    phoneAuthToolView.successBlock = ^(NSString *textfieldText) {
        weakself.phoneNum = textfieldText;
    };
    [self.baseScrollView addSubview:phoneAuthToolView];
    
    //nextBtn
    barButton = [[SDBarButton alloc] init];
    UIView *nextBarbtn = [barButton createBarButton:@"继续" font:FONT_15_Regular titleColor:COLOR_FFFFFF backGroundColor:COLOR_58A5F6 leftSpace:LEFTRIGHTSPACE_40];
    barButton.btn.tag = BTN_TAG_NEXT;
    [barButton.btn addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.baseScrollView addSubview:nextBarbtn];
    
    //frame
    [titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.baseScrollView.mas_top).offset(UPDOWNSPACE_69);
        make.centerX.equalTo(self.baseScrollView);
        make.size.mas_equalTo(titleLab.size);
    }];
    
    [phoneAuthToolView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(titleLab.mas_bottom).offset(UPDOWNSPACE_89);
        make.centerX.equalTo(self.baseScrollView.mas_centerX);
        make.size.mas_equalTo(phoneAuthToolView.size);
    }];
    
    [nextBarbtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(phoneAuthToolView.mas_bottom).offset(UPDOWNSPACE_69);
        make.centerX.equalTo(self.baseScrollView.mas_centerX);
        make.size.mas_equalTo(nextBarbtn.size);
    }];
    
    
    //装载所有的textfiled
    self.textfiledArr = [NSMutableArray arrayWithArray:@[phoneAuthToolView.textfiled]];
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
#pragma mark 申请虚拟sToken / tToken /获取鉴权
- (void)getStokenAndtTokenAndgetAuthTools{
   
}
#pragma mark 上送鉴权工具 + 校验用户
- (void)setAuthToolsAndCheckUser{
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
