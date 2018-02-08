//
//  LoginViewController.m
//  sandbao
//
//  Created by tianNanYiHao on 2017/10/13.
//  Copyright © 2017年 sand. All rights reserved.
//

#import "LoginViewController.h"
#import "PayNucHelper.h"

#import "ForgetLoginPwdViewController.h"
#import "RegistViewController.h"
#import "SmsCheckViewController.h"
#import "SDMQTTManager.h"



@interface LoginViewController ()
{
    SDBarButton *barButton;
}
@property (nonatomic, strong) NSString * phoneNum;
@property (nonatomic, strong) NSString * loginPwd;
@property (nonatomic, strong) NSMutableArray *authToolsArray;
@end


@implementation LoginViewController



-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    [self load];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    //UI创建
    [self createUI];
    
}
#pragma mark - 重写父类-baseScrollView设置
- (void)setBaseScrollview{
    [super setBaseScrollview];
    self.baseScrollView.scrollEnabled = YES;
    self.baseScrollView.frame = CGRectMake(0, UPDOWNSPACE_20, SCREEN_WIDTH, SCREEN_HEIGHT-UPDOWNSPACE_20);
}

#pragma mark - 重写父类-导航设置方法
- (void)setNavCoverView{
    [super setNavCoverView];
    self.navCoverView.hidden = YES;
}
#pragma mark - 重写父类-点击方法集合
- (void)buttonClick:(UIButton *)btn{
    
    if (btn.tag == BTN_TAG_FORGETPWD) {
        //@"点击了忘记密码"
        ForgetLoginPwdViewController *forgetVC = [[ForgetLoginPwdViewController alloc] init];
        [self.navigationController pushViewController:forgetVC animated:YES];
    }
    if (btn.tag == BTN_TAG_LOGIN) {
        //@"登录"
        if (self.phoneNum.length>0 && self.loginPwd.length>0) {
            [self loginUser];
            //友盟自定义时间统计 - 计数事件
            [MobClick event:UM_Login];
        }else{
            [Tool showDialog:@"请输入正确的登陆账号及密码"];
        }
    }
    if (btn.tag == BTN_TAG_REGIST) {
        //@"注册"
        RegistViewController *regVc = [[RegistViewController alloc] init];
        [self.navigationController pushViewController:regVc animated:YES];
    }
    
}

#pragma mark  - UI绘制
- (void)createUI{
    __weak typeof(self) weakself = self;
    //titleLab1
    UILabel *titleLab = [Tool createLable:@"欢迎回来" attributeStr:nil font:FONT_28_Medium textColor:COLOR_343339 alignment:NSTextAlignmentLeft];
    [self.baseScrollView addSubview:titleLab];
    
    
    //titleLab2
    UILabel *titleDesLab = [Tool createLable:@"继续登录" attributeStr:nil font:FONT_16_Regular textColor:COLOR_343339_7 alignment:NSTextAlignmentLeft];
    [self.baseScrollView addSubview:titleDesLab];
    
    //PhoneAuthToolView
    PhoneAuthToolView *phoneAuthToolView = [PhoneAuthToolView createAuthToolViewOY:0];
    phoneAuthToolView.tip.text = @"请输入能登陆的手机号";
    phoneAuthToolView.textfiled.text = SHOWTOTEST(@"15151474188");
    self.phoneNum = SHOWTOTEST(@"15151474188");;
    phoneAuthToolView.successBlock = ^(NSString *textfieldText) {
        weakself.phoneNum = textfieldText;
    };
    
    [self.baseScrollView addSubview:phoneAuthToolView];
    
    //PwdAuthToolView
    PwdAuthToolView *pwdAuthToolView = [PwdAuthToolView createAuthToolViewOY:0];
    pwdAuthToolView.tip.text = @"密码必须包含8-20位的字母数字组合";
    pwdAuthToolView.textfiled.text = SHOWTOTEST(@"qqqqqq111");
    self.loginPwd = SHOWTOTEST(@"qqqqqq111");
    pwdAuthToolView.successBlock = ^(NSString *textfieldText) {
        weakself.loginPwd = textfieldText;
    };
    [self.baseScrollView addSubview:pwdAuthToolView];
    
    //forgetPwd
    UIButton *forgetBtn = [Tool createButton:@"忘记密码?" attributeStr:nil font:FONT_14_Regular textColor:COLOR_343339_7];
    forgetBtn.tag = BTN_TAG_FORGETPWD;
    [forgetBtn addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.baseScrollView addSubview:forgetBtn];
    
    //logintBtn
    barButton = [[SDBarButton alloc] init];
    UIView *loginBarbtn = [barButton createBarButton:@"登录" font:FONT_15_Regular titleColor:COLOR_FFFFFF backGroundColor:COLOR_58A5F6 leftSpace:LEFTRIGHTSPACE_40];
    barButton.btn.tag = BTN_TAG_LOGIN;
    [barButton.btn addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.baseScrollView addSubview:loginBarbtn];
    
    
    //registBtn
    NSMutableAttributedString *registAttributeStr = [[NSMutableAttributedString alloc] initWithString:@"新用户? 注册"];
    [registAttributeStr addAttributes:@{
                                        NSFontAttributeName:FONT_14_Regular,
                                        NSForegroundColorAttributeName:COLOR_358BEF
                                       } range:NSMakeRange(5, 2)];
    UIButton *registbtn = [Tool createButton:@"" attributeStr:registAttributeStr font:FONT_14_Regular textColor:COLOR_343339_7];
    [registbtn addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    registbtn.tag = BTN_TAG_REGIST;
    [self.baseScrollView addSubview:registbtn];
    
    
    //frame
    [titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.baseScrollView.mas_top).offset(UPDOWNSPACE_112);
        make.left.equalTo(self.baseScrollView.mas_left).offset(LEFTRIGHTSPACE_35);
        make.size.mas_equalTo(titleLab.size);
    }];
    
    [titleDesLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(titleLab.mas_bottom).offset(UPDOWNSPACE_15);
        make.left.equalTo(titleLab);
        make.size.mas_equalTo(titleDesLab.size);
    }];
    
    [phoneAuthToolView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(titleDesLab.mas_bottom).offset(UPDOWNSPACE_58);
        make.centerX.equalTo(self.baseScrollView.mas_centerX);
        make.size.mas_equalTo(phoneAuthToolView.size);
    }];
    
    [pwdAuthToolView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(phoneAuthToolView.mas_bottom).offset(UPDOWNSPACE_0);
        make.centerX.equalTo(self.baseScrollView.mas_centerX);
        make.size.mas_equalTo(pwdAuthToolView.size);
    }];
    
    [forgetBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(pwdAuthToolView.mas_bottom).offset(UPDOWNSPACE_0);
        make.right.equalTo(pwdAuthToolView.mas_right).offset(-LEFTRIGHTSPACE_40);
        make.size.mas_equalTo(forgetBtn.size);
    }];
    
    [loginBarbtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(forgetBtn.mas_bottom).offset(UPDOWNSPACE_20);
        make.centerX.equalTo(self.baseScrollView.mas_centerX);
        make.size.mas_equalTo(loginBarbtn.size);
    }];
    
    [registbtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(loginBarbtn.mas_bottom).offset(UPDOWNSPACE_28);
        make.centerX.equalTo(self.baseScrollView.mas_centerX);
        make.size.mas_equalTo(registbtn.size);
    }];
    
    
    
    //装载所有的textfiled
    self.textfiledArr = [NSMutableArray arrayWithArray:@[phoneAuthToolView.textfiled,pwdAuthToolView.textfiled]];
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
#pragma mark 获取登陆鉴权工具

/**
 *@brief 获取鉴权工具
 *@return NSArray
 */
- (void)load
{
   
}

#pragma mark 用户登陆
/**
 *@brief 用户登录
 */
- (void)loginUser
{
   
}

/**
*@brief 更新用户数据
*/
- (void)updateUserData
{
   
}


/**
 更新我方支付工具_登陆模式下
 */
- (void)ownPayTools_login
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



@end
