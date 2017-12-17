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

//启动图 lunch
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
    
    
//    //显示Build版本lab
//    NSString *strVersion = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"] ;
//    NSString *strVersionInfo = [NSString stringWithFormat:@"Build版本号: %@",strVersion];
//    UILabel *versionLab = [Tool createLable:strVersionInfo attributeStr:nil font:FONT_12_Regular textColor:COLOR_343339 alignment:NSTextAlignmentCenter];
//    [self.baseScrollView addSubview:versionLab];
//    [versionLab mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.bottom.equalTo(headImageView.mas_bottom).offset(-UPDOWNSPACE_20);
//        make.centerX.equalTo(headImageView.mas_centerX).offset(0);
//        make.size.mas_equalTo(versionLab.size);
//    }];

    //显示version版本
    NSString *strVersion1 = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"] ;
    //    CFBundleShortVersionString
    //    CFBundleVersion
    NSString *versionLab1Info = [NSString stringWithFormat:@"Version版本号:v@%@",strVersion1];
    UILabel *versionLab1 = [Tool createLable:versionLab1Info attributeStr:nil font:FONT_12_Regular textColor:COLOR_343339 alignment:NSTextAlignmentCenter];
    [self.baseScrollView addSubview:versionLab1];
    [versionLab1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(headImageView.mas_bottom).offset(-UPDOWNSPACE_20);
        make.centerX.equalTo(headImageView.mas_centerX).offset(0);
        make.size.mas_equalTo(versionLab1.size);
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
