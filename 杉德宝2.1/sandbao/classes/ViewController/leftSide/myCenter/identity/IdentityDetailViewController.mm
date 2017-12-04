//
//  IdentityDetailViewController.m
//  sandbao
//
//  Created by tianNanYiHao on 2017/11/16.
//  Copyright © 2017年 sand. All rights reserved.
//

#import "IdentityDetailViewController.h"
#import "PayNucHelper.h"
#import "IdentityDetailCellView.h"

@interface IdentityDetailViewController ()
{
    UIView *headView;
    UIView *bodyView;
    UIView *bottomView;
    
}
@end

@implementation IdentityDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    [self create_HeadView];
    [self create_BodyView];
    [self create_BottomView];
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
    self.navCoverView.midTitleStr = @"身份信息";
    
    __weak IdentityDetailViewController *weakSelf = self;
    self.navCoverView.leftBlock = ^{
        [weakSelf.navigationController popViewControllerAnimated:YES];
    };
    
    
}

#pragma mark - 重写父类-点击方法集合
- (void)buttonClick:(UIButton *)btn{
   
    
}


#pragma mark  - UI绘制
- (void)create_HeadView{
    
    headView = [[UIView alloc] init];
    headView.backgroundColor = COLOR_F5F5F5;
    [self.baseScrollView addSubview:headView];
    
    //iconImgView
    UIImage *iconimg = [UIImage imageNamed:@"transfer_headIcon"];
    UIImageView *headIconImgeView = [Tool createImagView:iconimg];
    headIconImgeView.layer.cornerRadius = iconimg.size.height/2;
    headIconImgeView.layer.masksToBounds = YES;
    NSString *avatarImgStr = [CommParameter sharedInstance].avatar;
    if (avatarImgStr.length>0) {
        headIconImgeView.image = [Tool avatarImageWith:avatarImgStr];
    }
    [self.baseScrollView addSubview:headIconImgeView];
    
    //validatedIconView
    UIImage *validateImg = [UIImage imageNamed:@"validateIcon"];
    UIImageView *validatedIconView = [Tool createImagView:validateImg];
    [self.baseScrollView addSubview:validatedIconView];
    
    
    //accountNoLab
    NSString *accountNoStr = [CommParameter sharedInstance].userName;
    UILabel *accountNoLab = [Tool createLable:accountNoStr attributeStr:nil font:FONT_14_Regular textColor:COLOR_343339 alignment:NSTextAlignmentCenter];
    [self.baseScrollView addSubview:accountNoLab];
    
    //realNameLab
    NSString *realNameStr = [CommParameter sharedInstance].nick;
    if (!(realNameStr.length>0)) {
        realNameStr = @"请设置您的昵称";
    }
    UILabel *realNameLab = [Tool createLable:realNameStr attributeStr:nil font:FONT_12_Regular textColor:COLOR_343339_5 alignment:NSTextAlignmentCenter];
    [self.baseScrollView addSubview:realNameLab];
    
    headView.height = UPDOWNSPACE_20 + iconimg.size.height + UPDOWNSPACE_14 + accountNoLab.height + UPDOWNSPACE_10 + realNameLab.height + UPDOWNSPACE_25;
    
    
    [headView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.baseScrollView.mas_top).offset(UPDOWNSPACE_10);
        make.centerX.equalTo(self.baseScrollView.mas_centerX);
        make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH, headView.height));
    }];
    
    
    [headIconImgeView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(headView.mas_top).offset(UPDOWNSPACE_20);
        make.centerX.equalTo(headView.mas_centerX);
        make.size.mas_equalTo(iconimg.size);
    }];
    
    [validatedIconView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(headIconImgeView.mas_bottom);
        make.right.equalTo(headIconImgeView.mas_right);
        make.size.mas_equalTo(validatedIconView.size);
    }];
    
    [accountNoLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(headIconImgeView.mas_bottom).offset(UPDOWNSPACE_14);
        make.centerX.equalTo(headView.mas_centerX);
        make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH, accountNoLab.height));
    }];
    
    [realNameLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(accountNoLab.mas_bottom).offset(UPDOWNSPACE_10);
        make.centerX.equalTo(headView.mas_centerX);
        make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH, realNameLab.height));
    }];
    

}

- (void)create_BodyView{
    
    bodyView = [[UIView alloc] init];
    bodyView.backgroundColor = COLOR_FFFFFF;
    [self.baseScrollView addSubview:bodyView];
    
    //realNameCell
    
    IdentityDetailCellView *realNameCell = [IdentityDetailCellView createSetCellViewOY:0];
    realNameCell.titleStr = @"姓名";
    realNameCell.rightStr = [CommParameter sharedInstance].userRealName;
    realNameCell.clickBlock = ^{
        
    };
    [bodyView addSubview:realNameCell];
    
    //sexCell
    IdentityDetailCellView *sexCell = [IdentityDetailCellView createSetCellViewOY:0];
    sexCell.titleStr = @"性别";
    sexCell.rightStr = @"-";
    sexCell.clickBlock = ^{
        
    };
    [bodyView addSubview:sexCell];
    
    //indentityTypeCell
    IdentityDetailCellView *indentityTypeCell = [IdentityDetailCellView createSetCellViewOY:0];
    indentityTypeCell.titleStr = @"证件类型";
    indentityTypeCell.rightStr = @"身份证";
    indentityTypeCell.clickBlock = ^{
        
    };
    [bodyView addSubview:indentityTypeCell];
    
    //identityNoCell
    NSDictionary *userInfoDic = [[PayNucHelper sharedInstance] jsonStringToDictionary:[CommParameter sharedInstance].userInfo];
    IdentityDetailCellView *identityNoCell = [IdentityDetailCellView createSetCellViewOY:0];
    identityNoCell.titleStr = @"证件号码";
    identityNoCell.rightStr = [[userInfoDic objectForKey:@"identity"] objectForKey:@"identityNo"];
    identityNoCell.clickBlock = ^{
        
    };
    [bodyView addSubview:identityNoCell];
    
    //addressCell
    IdentityDetailCellView *addressCell = [IdentityDetailCellView createSetCellViewOY:0];
    addressCell.rightImgStr = @"center_profile_arror_right";
    addressCell.titleStr = @"详细地址";
    addressCell.rightStr = @"火星福尔吉斯区32号";
    addressCell.line.hidden = YES;
    addressCell.clickBlock = ^{
        
    };
    [bodyView addSubview:addressCell];
    
    
    bodyView.height = realNameCell.height + sexCell.height + indentityTypeCell.height + identityNoCell.height + addressCell.height;
    
    
    [bodyView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(headView.mas_bottom);
        make.centerX.equalTo(self.baseScrollView);
        make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH, bodyView.height));
    }];
    
    [realNameCell mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(bodyView.mas_top);
        make.centerX.equalTo(bodyView.mas_centerX);
        make.size.mas_equalTo(realNameCell.size);
    }];
    
    [sexCell mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(realNameCell.mas_bottom);
        make.centerX.equalTo(bodyView.mas_centerX);
        make.size.mas_equalTo(sexCell.size);
    }];
    
    [indentityTypeCell mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(sexCell.mas_bottom);
        make.centerX.equalTo(bodyView.mas_centerX);
        make.size.mas_equalTo(indentityTypeCell.size);
    }];
    
    [identityNoCell mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(indentityTypeCell.mas_bottom);
        make.centerX.equalTo(bodyView.mas_centerX);
        make.size.mas_equalTo(identityNoCell.size);
    }];
    
    
    [addressCell mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(identityNoCell.mas_bottom);
        make.centerX.equalTo(bodyView.mas_centerX);
        make.size.mas_equalTo(addressCell.size);
    }];
    
    
}

- (void)create_BottomView{
    
    bottomView = [[UIView alloc] init];
    bottomView.backgroundColor = COLOR_F5F5F5;
    [self.baseScrollView addSubview:bottomView];
    
    UILabel *bottomTipLab = [Tool createLable:@"杉德宝保障您的信息安全" attributeStr:nil font:FONT_10_Regular textColor:COLOR_343339_5 alignment:NSTextAlignmentCenter];
    [bottomView addSubview:bottomTipLab];
    
    bottomView.height = UPDOWNSPACE_64 + bottomTipLab.height + UPDOWNSPACE_30;
    
    [bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(bodyView.mas_bottom);
        make.centerX.equalTo(self.baseScrollView);
        make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH, bottomView.height));
    }];
    
    [bottomTipLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(bottomView.mas_top).offset(UPDOWNSPACE_64);
        make.centerX.equalTo(self.baseScrollView);
        make.size.mas_equalTo(bottomTipLab.size);
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
