//
//  AddSandCardViewController.m
//  sandbao
//
//  Created by tianNanYiHao on 2017/11/17.
//  Copyright © 2017年 sand. All rights reserved.
//

#import "AddSandCardViewController.h"

@interface AddSandCardViewController ()
{
    NSString *sandCardNoStr;
}
@property (nonatomic, strong) UIButton *bottomBtn;
@end

@implementation AddSandCardViewController

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
    self.navCoverView.letfImgStr = @"login_icon_back";
    self.navCoverView.midTitleStr = @"添加杉德卡";
    
    __block AddSandCardViewController *weakSelf = self;
    self.navCoverView.leftBlock = ^{
        [weakSelf.navigationController popViewControllerAnimated:YES];
    };
    
    self.navCoverView.rightBlock = ^{
        
    };
    
}
#pragma mark - 重写父类-点击方法集合
- (void)buttonClick:(UIButton *)btn{
    
    
}

#pragma mark  - UI绘制
- (void)createUI{
    
    
    //sandCardNoView
    CardNoAuthToolView *sandCardNoView = [CardNoAuthToolView createAuthToolViewOY:0];
    sandCardNoView.titleLab.text = @"杉德卡卡号";
    sandCardNoView.tip.text = @"请输入正确杉德卡卡号";
    sandCardNoView.textfiled.placeholder = @"请输入杉德卡卡号";
    sandCardNoView.successBlock = ^(NSString *textfieldText) {
        sandCardNoStr = textfieldText;
    };
    [self.baseScrollView addSubview:sandCardNoView];
    
    //sandCardCodeView
    
    //sandCardCodeCheckView
    
    
    
    
    
    
    //bottomBtn
    self.bottomBtn = [Tool createButton:@"绑定" attributeStr:nil font:FONT_14_Regular textColor:COLOR_FFFFFF];
    self.bottomBtn.backgroundColor = COLOR_58A5F6;
    self.bottomBtn.tag = BTN_TAG_BINDBANKCARD;
    [self.bottomBtn addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.baseScrollView addSubview:self.bottomBtn];
    self.bottomBtn.height += UPDOWNSPACE_23;
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
