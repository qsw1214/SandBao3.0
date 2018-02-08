//
//  ErrorLunchViewController.m
//  sandbao
//
//  Created by tianNanYiHao on 2017/10/12.
//  Copyright © 2017年 sand. All rights reserved.
//

#import "ErrorLunchViewController.h"
//启动图 - 启动失败
@interface ErrorLunchViewController ()

@end

@implementation ErrorLunchViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self setBaseInfo];
    [self showError];
    
    

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

- (void)setBaseInfo{
    //修改状态栏白色
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:NO];
    
    
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
- (void)showError{
    
    dispatch_async(dispatch_get_main_queue(), ^{
        // 网络权限受限
        if (self.errorType == 0) {
            [Tool showDialog:@"网络权限受限,您可以" message:@"检查网络连接情况或允许杉德宝使用网络" sureTitle:@"去解决" defualtBlcok:^{
                [Tool openUrl:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];
                [Tool exitApplication:self];
            }];
        }
        // 请求异常
        if (self.errorType == 1) {
            [Tool showDialog:_errorInfo defulBlock:^{
                [Tool exitApplication:self];
            }];
        }
    });
}


@end
