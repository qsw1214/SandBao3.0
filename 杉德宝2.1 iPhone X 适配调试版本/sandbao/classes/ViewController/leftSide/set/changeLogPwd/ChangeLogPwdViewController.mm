//
//  ChangeLogPwdViewController.m
//  sandbao
//
//  Created by tianNanYiHao on 2017/11/7.
//  Copyright © 2017年 sand. All rights reserved.
//

#import "ChangeLogPwdViewController.h"

#import "PayNucHelper.h"

@interface ChangeLogPwdViewController ()
{
    // reg鉴权工具集组
    NSArray *regAuthToolsArr;
    SDBarButton *barButton;
}
@property (nonatomic, strong) NSString *loginPwdStr;
@end

@implementation ChangeLogPwdViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self createUI];
    
    [self getRegAuthTools];
}




#pragma mark - 重写父类-baseScrollView设置
- (void)setBaseScrollview{
    [super setBaseScrollview];
    
}
#pragma mark - 重写父类-导航设置方法
- (void)setNavCoverView{
    [super setNavCoverView];
    self.navCoverView.letfImgStr = @"login_icon_back";
    
    __weak ChangeLogPwdViewController *weakSelf = self;
    self.navCoverView.leftBlock = ^{
        [Tool popToPenultimateViewController:weakSelf vcName:@"VerifyTypeViewController"];
    };
    
}
#pragma mark - 重写父类-点击方法集合
- (void)buttonClick:(UIButton *)btn{
    
    if (btn.tag == BTN_TAG_NEXT) {
        
        if (self.loginPwdStr.length>0) {
            [self setRegAuthTools];
        }
    }
    
}



#pragma mark  - UI绘制
- (void)createUI{
    
    __weak typeof(self) weakself = self;
    
    //titleLab1
    UILabel *titleLab = [Tool createLable:@"修改登录密码" attributeStr:nil font:FONT_28_Medium textColor:COLOR_343339 alignment:NSTextAlignmentCenter];
    [self.baseScrollView addSubview:titleLab];
    
    //titleLab2
    UILabel *titleDesLab;
    NSString *titleDesStr;
    
    if ([CommParameter sharedInstance].userName.length>0) {
        titleDesStr = [NSString stringWithFormat:@"请为%@设置一个新的登陆密码",[CommParameter sharedInstance].userName];
    }else{
        titleDesStr = @"设置的密码至少包含8-20位字母数字组合";
    }
    titleDesLab = [Tool createLable:titleDesStr attributeStr:nil font:FONT_16_Regular textColor:COLOR_343339_7 alignment:NSTextAlignmentCenter];
    [self.baseScrollView addSubview:titleDesLab];

    //PwdAuthToolView
    PwdAuthToolView *pwdAuthToolView = [PwdAuthToolView createAuthToolViewOY:0];
    pwdAuthToolView.tip.text = @"密码必须包含8-20位的字母数字组合";
    pwdAuthToolView.textfiled.text = SHOWTOTEST(@"qqqqqq111");
    self.loginPwdStr = SHOWTOTEST(@"qqqqqq111");
    pwdAuthToolView.successBlock = ^(NSString *textfieldText) {
        weakself.loginPwdStr = textfieldText;
    };
    [self.baseScrollView addSubview:pwdAuthToolView];
    
    //nextBtn
    barButton = [[SDBarButton alloc] init];
    UIView *nextBarbtn = [barButton createBarButton:@"继续" font:FONT_15_Regular titleColor:COLOR_FFFFFF backGroundColor:COLOR_58A5F6 leftSpace:LEFTRIGHTSPACE_40];
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
    
    [pwdAuthToolView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(titleDesLab.mas_bottom).offset(UPDOWNSPACE_58);
        make.centerX.equalTo(self.baseScrollView);
        make.size.mas_equalTo(pwdAuthToolView.size);
    }];
    

    [nextBarbtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(pwdAuthToolView.mas_bottom).offset(UPDOWNSPACE_40);
        make.centerX.equalTo(self.baseScrollView.mas_centerX);
        make.size.mas_equalTo(nextBarbtn.size);
    }];
    
    //装载所有的textfiled
    self.textfiledArr = [NSMutableArray arrayWithArray:@[pwdAuthToolView.textfiled]];
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
#pragma mark 查询设置登陆密码-鉴权工具
- (void)getRegAuthTools{
}

#pragma mark 提交设置登陆密码-鉴权工具
- (void)setRegAuthTools{
   
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
