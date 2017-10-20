//
//  PayPwdViewController.m
//  sandbao
//
//  Created by tianNanYiHao on 2017/10/19.
//  Copyright © 2017年 sand. All rights reserved.
//

#import "PayPwdViewController.h"


/**
 记录六位密码的输入状态

 - sixCodeStateNomal: 正常输入(第一次输入)
 - sixCodeStateAgain: 再次输入(第二次输入)
 - SixCodeStateSuccess: 校验成功
 */
typedef NS_ENUM(NSInteger,SixCodeState){
    
    sixCodeStateNomal = 0,
    sixCodeStateAgain ,
    SixCodeStateSuccess
};

@interface PayPwdViewController ()
{
    // 6位密码
    NSString *sixCodeStr;
    
}
@property (nonatomic, assign) SixCodeState sixCodeState;

@end

@implementation PayPwdViewController
@synthesize sixCodeState;


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    
    sixCodeState = sixCodeStateNomal;
    [self createUI];
}


#pragma - mark 重写父类-baseScrollView设置
- (void)setBaseScrollview{
    [super setBaseScrollview];
    
}
#pragma - mark 重写父类-导航设置方法
- (void)setNavCoverView{
    [super setNavCoverView];
    
    self.navCoverView.rightImgStr = nil;
    self.navCoverView.midTitleStr = nil;
    __block UIViewController *weakself = self;
    self.navCoverView.leftBlock = ^{
        [weakself.navigationController popViewControllerAnimated:YES];
    };
    
}
#pragma - mark 重写父类-点击方法集合
- (void)buttonClick:(UIButton *)btn{
    
    if (btn.tag == BTN_TAG_NEXT) {
        
        if (sixCodeState == SixCodeStateSuccess) {
            //验证支付密码成功, dismiss方式返回MainViewController
            [self dismissViewControllerAnimated:YES completion:nil];
            [CommParameter sharedInstance].userId = @"======";
        }
        if (sixCodeState == sixCodeStateAgain || sixCodeState == sixCodeStateNomal) {
            [self.baseScrollView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
            [self createUI];
        }
        
        
        
    }
    
}


#pragma - mark  UI绘制
- (void)createUI{
    
    
    //titleLab1
    UILabel *titleLab = [Tool createLable:@"设置支付密码" attributeStr:nil font:FONT_28_Medium textColor:COLOR_343339 alignment:NSTextAlignmentCenter];
    [self.baseScrollView addSubview:titleLab];
    
    //titleLab2
    UILabel *titleDesLab;
    if (sixCodeState == sixCodeStateNomal) {
        titleDesLab = [Tool createLable:@"输入6位数字支付密码" attributeStr:nil font:FONT_16_Regular textColor:COLOR_343339_7 alignment:NSTextAlignmentCenter];
    }
    if (sixCodeState == sixCodeStateAgain) {
        titleDesLab = [Tool createLable:@"再次输入6位数字支付密码" attributeStr:nil font:FONT_16_Regular textColor:COLOR_343339_7 alignment:NSTextAlignmentCenter];
    }
    [self.baseScrollView addSubview:titleDesLab];
    
    //payCodeAuthTool:sixCodeAuthToolView
    SixCodeAuthToolView *payCodeAuthTool = [SixCodeAuthToolView createAuthToolViewOY:0];
    payCodeAuthTool.style = PayCodeAuthTool;
    payCodeAuthTool.payCodeStrBlock = ^(NSString *codeStr) {
        NSLog(@"返回的支付密码为 : %@",codeStr);
        if (sixCodeStr.length == 0) {
            sixCodeStr = codeStr;
            sixCodeState = sixCodeStateAgain;
        }
        else if (sixCodeStr.length > 0) {
            if ([sixCodeStr isEqualToString:codeStr]) {
                sixCodeState = SixCodeStateSuccess;
            }else{
                sixCodeState = sixCodeStateNomal;
                sixCodeStr = nil;
            }
        }
        
    };
    [self.baseScrollView addSubview:payCodeAuthTool];
    
    
    //nextBtn
    UIButton *nextBarbtn = [Tool createBarButton:@"继续" font:FONT_15_Regular titleColor:COLOR_FFFFFF backGroundColor:COLOR_58A5F6 leftSpace:LEFTRIGHTSPACE_40];
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
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
