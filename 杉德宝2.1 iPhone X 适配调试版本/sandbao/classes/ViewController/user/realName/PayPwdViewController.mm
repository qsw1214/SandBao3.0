//
//  PayPwdViewController.m
//  sandbao
//
//  Created by tianNanYiHao on 2017/10/19.
//  Copyright © 2017年 sand. All rights reserved.
//

#import "PayPwdViewController.h"
#import "PayNucHelper.h"


#define SIX_CODE_STATE_INPUT_FIRST 80001
#define SIX_CODE_STATE_INPUT_AGAIN 80002
#define SIX_CODE_STATE_CHECK_OK    80003

@interface PayPwdViewController ()
{
    //查询待注册鉴权工具
    NSArray *regAuthToolsArr;
    
    SDBarButton *barButton;
}
@property (nonatomic, assign) NSString *sixCodeStr; // 6位密码
@property (nonatomic, assign) NSInteger SIX_CODE_STATE;

@end

@implementation PayPwdViewController



- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    self.SIX_CODE_STATE = SIX_CODE_STATE_INPUT_FIRST;
    
    [self createUI];
    
    [self getRegAuthTools];
}


#pragma mark - 重写父类-baseScrollView设置
- (void)setBaseScrollview{
    [super setBaseScrollview];
    self.baseScrollView.frame = CGRectMake(0, UPDOWNSPACE_20, SCREEN_WIDTH, SCREEN_HEIGHT-UPDOWNSPACE_20);
    
}
#pragma mark - 重写父类-导航设置方法
- (void)setNavCoverView{
    [super setNavCoverView];

}
#pragma mark - 重写父类-点击方法集合
- (void)buttonClick:(UIButton *)btn{
    
    if (btn.tag == BTN_TAG_NEXT) {
        
        if (self.SIX_CODE_STATE == SIX_CODE_STATE_CHECK_OK) {
            //设置支付密码 - 上送鉴权
            [self setRegAuthTools];
        }
        
        if (self.SIX_CODE_STATE == SIX_CODE_STATE_INPUT_AGAIN) {
            [self.baseScrollView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
            [self createUI];
        }
        if (self.SIX_CODE_STATE == SIX_CODE_STATE_INPUT_FIRST) {
            [SDMBProgressView showSDMBProgressNormalINView:self.view lableText:@"两次密码不一致,请重新输入!"];
            [self.baseScrollView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
            [self createUI];
        }
    }
    
}


#pragma mark  - UI绘制
- (void)createUI{
    __weak typeof(self) weakself = self;
    
    //titleLab1
    UILabel *titleLab = [Tool createLable:@"设置支付密码" attributeStr:nil font:FONT_28_Medium textColor:COLOR_343339 alignment:NSTextAlignmentCenter];
    [self.baseScrollView addSubview:titleLab];
    
    //titleLab2
    UILabel *titleDesLab;
    if (self.SIX_CODE_STATE == SIX_CODE_STATE_INPUT_FIRST) {
        titleDesLab = [Tool createLable:@"输入6位数字支付密码" attributeStr:nil font:FONT_16_Regular textColor:COLOR_343339_7 alignment:NSTextAlignmentCenter];
    }
    if (self.SIX_CODE_STATE == SIX_CODE_STATE_INPUT_AGAIN) {
        titleDesLab = [Tool createLable:@"再次输入6位数字支付密码" attributeStr:nil font:FONT_16_Regular textColor:COLOR_343339_7 alignment:NSTextAlignmentCenter];
    }
    [self.baseScrollView addSubview:titleDesLab];
    
    //payCodeAuthTool:sixCodeAuthToolView
    SixCodeAuthToolView *payCodeAuthTool = [SixCodeAuthToolView createAuthToolViewOY:0];
    payCodeAuthTool.style = PayCodeAuthTool;
    payCodeAuthTool.successBlock = ^(NSString *textfieldText) {
        
        if (weakself.sixCodeStr.length == 0) {
            weakself.sixCodeStr = textfieldText;
            weakself.SIX_CODE_STATE = SIX_CODE_STATE_INPUT_AGAIN;
        }
        else if (weakself.sixCodeStr.length > 0) {
            if ([weakself.sixCodeStr isEqualToString:textfieldText]) {
                weakself.SIX_CODE_STATE = SIX_CODE_STATE_CHECK_OK;
            }else{
                weakself.SIX_CODE_STATE = SIX_CODE_STATE_INPUT_FIRST;
                weakself.sixCodeStr = nil;
            }
        }
    };
    [self.baseScrollView addSubview:payCodeAuthTool];
    
    
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

    [payCodeAuthTool mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(titleDesLab.mas_bottom).offset(UPDOWNSPACE_25);
        make.centerX.equalTo(self.baseScrollView.mas_centerX);
        make.size.mas_equalTo(payCodeAuthTool.size);
    }];
    
    [nextBarbtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(payCodeAuthTool.mas_bottom).offset(UPDOWNSPACE_40);
        make.centerX.equalTo(self.baseScrollView.mas_centerX);
        make.size.mas_equalTo(nextBarbtn.size);
    }];
    
    //装载所有的textfiled
    self.textfiledArr = [NSMutableArray arrayWithArray:@[payCodeAuthTool.noCopyTextfield]];
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
#pragma mark 查询设置支付密码-鉴权工具
- (void)getRegAuthTools{
   
}


#pragma mark 提交设置支付密码-鉴权工具
- (void)setRegAuthTools{
    
   
}

/**
 更新我方支付工具_注册模式
 */
- (void)ownPayTools_rigest
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
