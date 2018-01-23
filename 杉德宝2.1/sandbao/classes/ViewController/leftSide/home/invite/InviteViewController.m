//
//  InviteViewController.m
//  sandbao
//
//  Created by tianNanYiHao on 2018/1/23.
//  Copyright © 2018年 sand. All rights reserved.
//

#import "InviteViewController.h"

@interface InviteViewController ()

@end

@implementation InviteViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self creaetUI];
}


#pragma mark - 重写父类-baseScrollView设置
- (void)setBaseScrollview{
    [super setBaseScrollview];
    self.baseScrollView.backgroundColor = COLOR_F5F5F5;
    self.baseScrollView.scrollEnabled = NO;
    
}
#pragma mark - 重写父类-导航设置方法
- (void)setNavCoverView{
    [super setNavCoverView];
    self.navCoverView.style = NavCoverStyleWhite;
    self.navCoverView.letfImgStr = @"login_icon_back";
    self.navCoverView.midTitleStr = @"邀请好友";
    
    __weak InviteViewController *weakSelf = self;
    self.navCoverView.leftBlock = ^{
        //归位Home或SpsLunch
        [weakSelf.navigationController popViewControllerAnimated:YES];
    };
    
}
#pragma mark - 重写父类-点击方法集合
- (void)buttonClick:(UIButton *)btn{
    
}


#pragma mark  - UI绘制
- (void)creaetUI{
    
    UIImage *inviteBGimg = [UIImage imageNamed:@"invite_bg"];
    UIImageView *inviteBGView = [Tool createImagView:inviteBGimg];
    
    [self.baseScrollView addSubview:inviteBGView];
    
    [inviteBGView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.baseScrollView);
        make.centerY.equalTo(self.baseScrollView);
        make.size.mas_equalTo(self.baseScrollView.size);
    }];

    UIButton *inviteBtn = [Tool createButton:@"" attributeStr:nil font:nil textColor:nil];
    
    
    
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
