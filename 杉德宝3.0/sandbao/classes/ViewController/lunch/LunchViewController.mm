//
//  LunchViewController.m
//  sandbao
//
//  Created by tianNanYiHao on 2017/11/3.
//  Copyright © 2017年 sand. All rights reserved.
//

#import "LunchViewController.h"

#import "PayNucHelper.h"
#import "NSObject+NSLocalNotification.h"
#import "SqliteHelper.h"
#import "SDSqlite.h"
#import "SDDrowNoticeView.h"
#import "LoginViewController.h"

@interface LunchViewController ()
{
    
}
@end

@implementation LunchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self setBaseInfo];
}

#pragma mark - 重写父类-baseScrollView设置
- (void)setBaseScrollview{
    [super setBaseScrollview];
    self.baseScrollView.frame = [UIScreen mainScreen].bounds;
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
- (void)setBaseInfo{

    
    UIImage *headImage = [UIImage fullscreenAllIphoneImageWithName:@"loading.png"];
    UIImageView *headImageView = [[UIImageView alloc] init];
    headImageView.contentMode = UIViewContentModeScaleAspectFit;
    headImageView.image = headImage;
    [self.baseScrollView addSubview:headImageView];
    [headImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.view);
    }];
    
    //显示Build版本lab
    UILabel *versionLab = [[UILabel alloc] init];
    NSString *strVersion = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"] ;
    versionLab.text = [NSString stringWithFormat:@"Build版本号: %@",strVersion];
    versionLab.textAlignment = NSTextAlignmentCenter;
    CGSize versionLabsize = CGSizeMake(SCREEN_SIZE.width - 2*15, 15);
    versionLab.textColor = [UIColor whiteColor];
    [self.baseScrollView addSubview:versionLab];
    [versionLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(headImageView.mas_bottom).offset(-20);
        make.centerX.equalTo(headImageView.mas_centerX).offset(0);
        make.size.mas_equalTo(versionLabsize);
    }];
    
    //显示version版本
    UILabel *versionLab1 = [[UILabel alloc] init];
    NSString *strVersion1 = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"] ;
    //    CFBundleShortVersionString
    //    CFBundleVersion
    versionLab1.text = [NSString stringWithFormat:@"@Version版本号: %@",strVersion1];
    versionLab1.textAlignment = NSTextAlignmentCenter;
    versionLab1.font = [UIFont systemFontOfSize:11];
    CGSize versionLabsize1 = CGSizeMake(SCREEN_SIZE.width - 2*15, 15);
    versionLab1.textColor = [UIColor lightGrayColor];
    [self.baseScrollView addSubview:versionLab1];
    [versionLab1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(headImageView.mas_bottom).offset(-40);
        make.centerX.equalTo(headImageView.mas_centerX).offset(0);
        make.size.mas_equalTo(versionLabsize1);
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
