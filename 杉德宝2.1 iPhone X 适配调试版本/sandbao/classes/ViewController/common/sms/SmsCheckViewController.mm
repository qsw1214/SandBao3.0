//
//  SmsCheckViewController.m
//  sandbao
//
//  Created by tianNanYiHao on 2017/10/18.
//  Copyright © 2017年 sand. All rights reserved.
//

#import "SmsCheckViewController.h"
#import "PayNucHelper.h"

#import "LogpwdViewController.h"
#import "PayPwdViewController.h"
#import "VerifyViewController.h"


@interface SmsCheckViewController ()
{
    SixCodeAuthToolView *smsCodeAuthToolView;
}

@end

@implementation SmsCheckViewController

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    //页面结束 - 停止短信倒计时 - 此方法临时 - 用于解除全局短信限制
    [smsCodeAuthToolView stopTimer];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self createUI];
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
    //如果倒计时已经为零,则允许自动触发短信发送
    if ( [SixCodeAuthToolView getCurrentTimeOut] == 0) {
        //获取短信验证码
        [self shortMsg];
        //短信开始倒计时
        [smsCodeAuthToolView startTimeOut];
    }
}
#pragma mark - 重写父类-baseScrollView设置
- (void)setBaseScrollview{
    [super setBaseScrollview];
    
}
#pragma mark - 重写父类-导航设置方法
- (void)setNavCoverView{
    [super setNavCoverView];
    self.navCoverView.letfImgStr = @"login_icon_back";

    __weak SmsCheckViewController *weakSelf = self;
    self.navCoverView.leftBlock = ^{
        [weakSelf.navCoverView popToPenultimateViewController:weakSelf];
    };
}
#pragma mark - 重写父类-点击方法集合
- (void)buttonClick:(UIButton *)btn{
    
    
    
}

#pragma mark  - UI绘制
- (void)createUI{
    __weak typeof(self) weakself = self;
    //titleLab1
    UILabel *titleLab = [Tool createLable:@"验证手机" attributeStr:nil font:FONT_28_Medium textColor:COLOR_358BEF alignment:NSTextAlignmentCenter];
    [self.baseScrollView addSubview:titleLab];
    
    //titleLab2
    UILabel *titleDesLab = [Tool createLable:@"短信验证码将会发送到" attributeStr:nil font:FONT_16_Regular textColor:COLOR_343339_7 alignment:NSTextAlignmentCenter];
    [self.baseScrollView addSubview:titleDesLab];

    //titleLab3
    UILabel *titlePhoneNoLab = [Tool createLable:self.phoneNoStr attributeStr:nil font:FONT_20_Medium textColor:COLOR_666666 alignment:NSTextAlignmentCenter];
    [self.baseScrollView addSubview:titlePhoneNoLab];
    
    
    //smsCodeAuth:sixCodeAuth
    smsCodeAuthToolView = [SixCodeAuthToolView createAuthToolViewOY:0];
    smsCodeAuthToolView.style = SmsCodeAuthTool;
    smsCodeAuthToolView.successBlock = ^(NSString *textfieldText) {
        
        switch (weakself.smsCheckType) {
            case SMS_CHECKTYPE_LOGINT:
            {
                //输入短信成功后,进入登录流程
                weakself.smsCodeString = textfieldText;
                [weakself loginUser];
                
            }
                break;
            case SMS_CHECKTYPE_REGIST:
            {
                //输入短信成功后, checkUser检测用户
                weakself.smsCodeString = textfieldText;
                [weakself checkUser];
            }
                break;
            case SMS_CHECKTYPE_REALNAME:
            {
                //输入短信成功后,进行实名认证
                weakself.smsCodeString = textfieldText;
                [weakself realUserName];
            }
                break;
            case SMS_CHECKTYPE_ADDBANKCARD:
            {
                //输入短信成功后,addBankCard绑卡流程
                weakself.smsCodeString = textfieldText;
                [weakself addBankCard];
            }
                break;
            case SMS_CHECKTYPE_VERIFYTYPE:
            {
                //输入短信成功后,跳转verifyVC进行进一步鉴权工具填写
                weakself.smsCodeString = textfieldText;
                [weakself pushToVerifyViewController];
                
            }
                break;
            default:
                break;
        }
        
    };
    smsCodeAuthToolView.successRequestBlock = ^(NSString *textfieldText) {
        //触发 - 获取短信码请求
        [weakself shortMsg];
    };
    [self.baseScrollView addSubview:smsCodeAuthToolView];
    
    
    
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
    
    [titlePhoneNoLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(titleDesLab.mas_bottom).offset(UPDOWNSPACE_11);
        make.centerX.equalTo(self.baseScrollView.mas_centerX);
        make.size.mas_equalTo(titlePhoneNoLab.size);
    }];
    
    [smsCodeAuthToolView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(titlePhoneNoLab.mas_bottom).offset(UPDOWNSPACE_43);
        make.centerX.equalTo(self.baseScrollView.mas_centerX);
        make.size.mas_equalTo(smsCodeAuthToolView.size);
    }];

    
}



#pragma mark - =-=-=-=-=-=  公共业务逻辑   =-=-=-=-=-=
#pragma mark  获取短信验证码

- (void)shortMsg
{
    
}


#pragma mark - =-=-=-=-=-=  用户登录模式  =-=-=-=-=-=

#pragma mark 用户登录
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

#pragma mark - =-=-=-=-=-=  用户注册模式   =-=-=-=-=-=
#pragma mark 校验用户
- (void)checkUser{
    
  

}


#pragma mark - =-=-=-=-=-=  用户实名模式   =-=-=-=-=-=-
#pragma mark 用户实名
/**
 *@brief 实名
 */
- (void)realUserName
{
   
}

#pragma mark - =-=-=-=-=-=  用户绑银行卡  =-=-=-=-=-=-
#pragma mark 用户绑银行卡

- (void)addBankCard{
    
    
}
/**
 更新我方支付工具_绑卡
 */
- (void)ownPayTools_addBakcCard
{
}

#pragma mark - =-=-=-=-=-=  修改支付/登陆密码  =-=-=-=-=-=-
- (void)pushToVerifyViewController{
    
    //组装sms
    NSMutableArray *authToolsArr;
    for (int i = 0; i<self.verifyAuthToolsArr.count; i++) {
        if ([@"sms" isEqualToString:[self.verifyAuthToolsArr[i] objectForKey:@"type"]]) {
            
            NSMutableDictionary *authToolDic = [NSMutableDictionary dictionaryWithDictionary: self.verifyAuthToolsArr[i]];
            NSMutableDictionary *smsDic = [NSMutableDictionary dictionaryWithDictionary:[authToolDic objectForKey:@"sms"]];
            [smsDic setValue:self.smsCodeString forKey:@"code"];
            [authToolDic setValue:smsDic forKey:@"sms"];
            
            authToolsArr = [NSMutableArray arrayWithArray:self.verifyAuthToolsArr];
            [authToolsArr removeObjectAtIndex:i];
            [authToolsArr insertObject:authToolDic atIndex:i];
        }
    }
    
    VerifyViewController *verifyVC = [[VerifyViewController alloc] init];
    verifyVC.authToolArr = authToolsArr;
    verifyVC.smsCodeAuthToolView = smsCodeAuthToolView;
    verifyVC.verifyType = self.verifyType;
    [self.navigationController pushViewController:verifyVC animated:YES];
    
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
