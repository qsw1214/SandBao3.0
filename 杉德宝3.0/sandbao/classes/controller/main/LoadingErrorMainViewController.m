//
//  LoadingErrorMainViewController.m
//  sandbao
//
//  Created by tianNanYiHao on 2017/10/12.
//  Copyright © 2017年 sand. All rights reserved.
//

#import "LoadingErrorMainViewController.h"

@interface LoadingErrorMainViewController ()

@end

@implementation LoadingErrorMainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    //修改状态栏白色
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:NO];
    
    
    UIImage *headImage = [UIImage fullscreenAllIphoneImageWithName:@"loading.png"];
    UIImageView *headImageView = [[UIImageView alloc] init];
    headImageView.contentMode = UIViewContentModeScaleAspectFit;
    headImageView.image = headImage;
    [self.view addSubview:headImageView];
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
    [self.view addSubview:versionLab];
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
    [self.view addSubview:versionLab1];
    [versionLab1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(headImageView.mas_bottom).offset(-40);
        make.centerX.equalTo(headImageView.mas_centerX).offset(0);
        make.size.mas_equalTo(versionLabsize1);
    }];
    
    [self showError];
    
    

}
- (void)showError{
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [Tool showDialog:_errorInfo defulBlock:^{
            [self exitApplication];
        }];
    });
   

}

- (void)exitApplication {
    //来 加个动画，给用户一个友好的退出界面
    [UIView animateWithDuration:0.4 animations:^{
        self.view.window.alpha = 0;
    } completion:^(BOOL finished) {
        exit(0);
    }];
    
}


@end
