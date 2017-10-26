//
//  LeftSideMenuViewController.m
//  sandbao
//
//  Created by tianNanYiHao on 2017/10/26.
//  Copyright © 2017年 sand. All rights reserved.
//

#import "LeftSideMenuViewController.h"

@interface LeftSideMenuViewController ()
{
    
    
}
@end

@implementation LeftSideMenuViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self createUI];
}


#pragma mark - 重写父类-baseScrollView设置
- (void)setBaseScrollview{
    [super setBaseScrollview];
    
    //重置frame.width
    CGFloat leftSideWidth = SCREEN_WIDTH * (1-0.258);
    self.baseScrollView.frame = CGRectMake(0, 0, leftSideWidth, SCREEN_HEIGHT);
    
    
}
#pragma mark - 重写父类-导航设置方法
- (void)setNavCoverView{
    [super setNavCoverView];
    self.navCoverView.hidden = YES;
}
#pragma mark - 重写父类-点击方法集合
- (void)buttonClick:(UIButton *)btn{
    
    
}

#pragma mark  - UI绘制
- (void)createUI{

    //HeadView
    UIView *headView = [[UIView alloc] init];
    headView.backgroundColor = COLOR_358BEF;
    [self.baseScrollView addSubview:headView];
    
    
    UIImage *headImg = [UIImage imageNamed:@"center_profile_avatar"];
    
    UIImageView *headImgView = [Tool createImagView:headImg];
    [headView addSubview:headImgView];
    
    UILabel *titleLab = [Tool createLable:@"1515****388" attributeStr:nil font:FONT_13_OpenSan textColor:COLOR_343339 alignment:NSTextAlignmentCenter];
    [headView addSubview:titleLab];
    
    UIImage *realNameImg = [UIImage imageNamed:@"center_profile_card"];
    UIImageView *realNameImgView = [Tool createImagView:realNameImg];
    [headView addSubview:realNameImgView];
    
    UILabel *realNameLab = [Tool createLable:@"" attributeStr:nil font:FONT_08_Regular textColor:COLOR_FF5D31 alignment:NSTextAlignmentCenter];
    [headView addSubview:realNameLab];
    
    UIButton *couponBtn = [Tool createButton:@"" attributeStr:nil font:FONT_08_Regular textColor:COLOR_FFFFFF];
    [headView addSubview:couponBtn];
    
    UIButton *accountBtn = [Tool createButton:@"" attributeStr:nil font:FONT_08_Regular textColor:COLOR_58A5F6];
    [headView addSubview:accountBtn];
    
    UIButton *rightArrowBtn = [Tool createButton:@"" attributeStr:nil font:nil textColor:nil];
    [rightArrowBtn setBackgroundImage:[UIImage imageNamed:@"center_profile_arror_right"] forState:UIControlStateNormal];
    [headView addSubview:rightArrowBtn];
    
    
    [headView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.baseScrollView.mas_top).offset(UPDOWNSPACE_64);
        make.left.equalTo(self.baseScrollView.mas_left).offset(0);
        make.size.mas_equalTo(CGSizeMake(self.baseScrollView.width, headImg.size.height));
    }];
    
    [headImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(headView.mas_top).offset(UPDOWNSPACE_0);
        make.left.equalTo(self.baseScrollView.mas_left).offset(LEFTRIGHTSPACE_20);
        make.size.mas_equalTo(headImgView.size);
    }];
    
    [titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(headView.mas_top).offset(UPDOWNSPACE_0);
        make.left.equalTo(self.baseScrollView.mas_left).offset(LEFTRIGHTSPACE_20);
        make.size.mas_equalTo(headImgView.size);
    }];
    
    
    
    
    
    
    
    
    
    
    
    
    //tableView
    UITableView *tableView = [[UITableView alloc] init];
    [self.baseScrollView addSubview:tableView];
    
    
    //logOutView
    UIView *logOutView = [[UIView alloc] init];
    [self.baseScrollView addSubview:logOutView];
    
    
    
    
    
    
    
    
    

}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
@end
