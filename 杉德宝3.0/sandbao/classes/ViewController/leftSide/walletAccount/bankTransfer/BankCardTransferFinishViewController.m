//
//  BankCardTransferFinishViewController.m
//  sandbao
//
//  Created by tianNanYiHao on 2017/11/1.
//  Copyright © 2017年 sand. All rights reserved.
//

#import "BankCardTransferFinishViewController.h"

@interface BankCardTransferFinishViewController ()
{
    UIView *stypeOne;
    UIView *stypeTwo;
    
}
@end

@implementation BankCardTransferFinishViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self create_stypeOne];
    [self create_stypeTwo];
    
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
    self.navCoverView.midTitleStr = @"转账结果详情";
    self.navCoverView.rightTitleStr = @"完成";
    
    __weak BankCardTransferFinishViewController *weakSelf = self;
    self.navCoverView.rightBlock = ^{
        [weakSelf.navigationController popToRootViewControllerAnimated:YES];
    };
    
    
}
#pragma mark - 重写父类-点击方法集合
- (void)buttonClick:(UIButton *)btn{

    
}


#pragma mark  - UI绘制
- (void)create_stypeOne{
    
    //stypeOne
    stypeOne = [[UIView alloc] init];
    stypeOne.backgroundColor = [UIColor clearColor];
    [self.baseScrollView addSubview:stypeOne];
    
    
    //iconImg
    UIImage *iconImg = [UIImage imageNamed:@"tranfer_ok_stypeOne"];
    UIImageView *iconImgV = [Tool createImagView:iconImg];
    [stypeOne addSubview:iconImgV];
    
    //titleLab
    UILabel *titleLab = [Tool createLable:@"转账申请已提交,等待银行审核" attributeStr:nil font:FONT_12_Regular textColor:COLOR_343339 alignment:NSTextAlignmentLeft];
    [stypeOne addSubview:titleLab];
    
    //titleDesLab
    NSString *titleDesStr = [NSString stringWithFormat:@"%@(%@)",self.bankTitle,self.bankNo];
    UILabel *titleDesLab = [Tool createLable:titleDesStr attributeStr:nil font:FONT_10_Regular textColor:COLOR_343339_5 alignment:NSTextAlignmentLeft];
    [stypeOne addSubview:titleDesLab];
    
    stypeOne.width = SCREEN_WIDTH;
    stypeOne.height = iconImg.size.height;
    titleLab.width = SCREEN_WIDTH - LEFTRIGHTSPACE_35 - LEFTRIGHTSPACE_25 - iconImg.size.width;
    
    [stypeOne mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.baseScrollView.mas_top).offset(UPDOWNSPACE_30);
        make.left.equalTo(self.baseScrollView.mas_left).offset(LEFTRIGHTSPACE_00);
        make.size.mas_equalTo(CGSizeMake(stypeOne.width, stypeOne.height));
    }];
    
    [iconImgV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(stypeOne.mas_top).offset(UPDOWNSPACE_0);
        make.left.equalTo(stypeOne.mas_left).offset(LEFTRIGHTSPACE_35);
        make.size.mas_equalTo(iconImg.size);
    }];
    
    [titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(stypeOne.mas_top).offset(UPDOWNSPACE_0);
        make.left.equalTo(iconImgV.mas_right).offset(LEFTRIGHTSPACE_25);
        make.size.mas_equalTo(CGSizeMake(titleLab.width, titleLab.height));
    }];
    
    [titleDesLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(stypeOne.mas_bottom).offset(UPDOWNSPACE_0);
        make.left.equalTo(iconImgV.mas_right).offset(LEFTRIGHTSPACE_25);
        make.size.mas_equalTo(CGSizeMake(titleLab.width, titleDesLab.height));
    }];
    
}

- (void)create_stypeTwo{
    
    //stypeOne
    stypeTwo = [[UIView alloc] init];
    stypeTwo.backgroundColor = [UIColor clearColor];
    [self.baseScrollView addSubview:stypeTwo];
    
    //iconImg
    UIImage *iconImg = [UIImage imageNamed:@"tranfer_ok_stypeTwo"];
    UIImageView *iconImgV = [Tool createImagView:iconImg];
    [stypeTwo addSubview:iconImgV];
    
    //titleLab
    UILabel *titleLab = [Tool createLable:@"预计2小时到账" attributeStr:nil font:FONT_12_Regular textColor:COLOR_343339 alignment:NSTextAlignmentLeft];
    [stypeTwo addSubview:titleLab];
    
    //titleDesLab
    UILabel *titleDesLab = [Tool createLable:@"00:00前" attributeStr:nil font:FONT_10_Regular textColor:COLOR_343339_5 alignment:NSTextAlignmentLeft];
    [stypeTwo addSubview:titleDesLab];
    
    stypeTwo.width = SCREEN_WIDTH;
    stypeTwo.height = iconImg.size.height;
    titleLab.width = SCREEN_WIDTH - LEFTRIGHTSPACE_35 - LEFTRIGHTSPACE_25 - iconImg.size.width;
    
    [stypeTwo mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(stypeOne.mas_bottom).offset(UPDOWNSPACE_30);
        make.left.equalTo(self.baseScrollView.mas_left).offset(LEFTRIGHTSPACE_00);
        make.size.mas_equalTo(CGSizeMake(stypeTwo.width, stypeTwo.height));
    }];
    
    [iconImgV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(stypeTwo.mas_top).offset(UPDOWNSPACE_0);
        make.left.equalTo(stypeTwo.mas_left).offset(LEFTRIGHTSPACE_35);
        make.size.mas_equalTo(iconImg.size);
    }];
    
    [titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(stypeTwo.mas_top).offset(UPDOWNSPACE_0);
        make.left.equalTo(iconImgV.mas_right).offset(LEFTRIGHTSPACE_25);
        make.size.mas_equalTo(CGSizeMake(titleLab.width, titleLab.height));
    }];
    
    [titleDesLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(stypeTwo.mas_bottom).offset(UPDOWNSPACE_0);
        make.left.equalTo(iconImgV.mas_right).offset(LEFTRIGHTSPACE_25);
        make.size.mas_equalTo(CGSizeMake(titleLab.width, titleDesLab.height));
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
