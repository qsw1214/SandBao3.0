//
//  ScannerViewController.m
//  sandbao
//
//  Created by tianNanYiHao on 2017/12/7.
//  Copyright © 2017年 sand. All rights reserved.
//

//SAND_TN:tn号
//SAND_USER：12434
//SAND_MER：3445
//SAND_AUTH：1234
//SAND_LOGIN_CODE:tToken

#import "ScannerViewController.h"
#import <AVFoundation/AVFoundation.h>
#import "TnOrderViewController.h"
#import "SDScanView.h"

@interface ScannerViewController ()<SDScanViewDelegate>
{
    SDScanView *scanView;
    UIImageView *bgImgV;
    BOOL isCanScanner; //设备是否可以授权扫码
}
@end

@implementation ScannerViewController


- (void)viewDidAppear:(BOOL)animated{
    
    [super viewDidAppear:animated];

    if (!isCanScanner) {
        [[SDAlertView shareAlert] showDialog:@"相机权限受限" message:@"请在设置中启用" leftBtnString:@"暂不设置" rightBtnString:@"去设置" leftBlock:^{
            [self.navigationController popViewControllerAnimated:YES];
        } rightBlock:^{
            //去设置
            if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]]) {
                [Tool openUrl:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];
            }
            [self.navigationController popViewControllerAnimated:YES];
        }];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self creaetUI];
    
}

#pragma mark - 重写父类-baseScrollView设置
- (void)setBaseScrollview{
    [super setBaseScrollview];
    self.baseScrollView.frame = CGRectMake(0, UPDOWNSPACE_0, SCREEN_WIDTH, SCREEN_HEIGHT - UPDOWNSPACE_0);
    self.baseScrollView.scrollEnabled = NO;
}
#pragma mark - 重写父类-导航设置方法
- (void)setNavCoverView{
    [super setNavCoverView];
    self.navCoverView.style = NavCoverStyleClean;
    self.navCoverView.letfImgStr = @"login_icon_back_white";
    self.navCoverView.midTitleStr = @"扫一扫";
    
    __weak ScannerViewController *weakSelf = self;
    self.navCoverView.leftBlock = ^{
        [weakSelf.navigationController popViewControllerAnimated:YES];
    };
}
#pragma mark - 重写父类-点击方法集合
- (void)buttonClick:(UIButton *)btn{
    
    
}


#pragma mark  - UI绘制
- (void)creaetUI{
    
    isCanScanner = NO;
    bgImgV = [Tool createImagView:[UIImage imageNamed:@"general_page_wrong"]];
    [self.baseScrollView addSubview:bgImgV];
    [bgImgV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.baseScrollView);
        make.centerX.equalTo(self.baseScrollView);
        make.size.mas_equalTo(self.baseScrollView.size);
    }];
    
    //使用前先判断相机权限
    NSString *mediaType = AVMediaTypeVideo;//读取媒体类型
    AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:mediaType];//读取设备授权状态
    if(authStatus == AVAuthorizationStatusRestricted || authStatus == AVAuthorizationStatusDenied){
        
        isCanScanner = NO;

    }else{
        isCanScanner = YES;
        scanView = [[SDScanView alloc] init];
        scanView.delegate = self;
        [self.baseScrollView addSubview:scanView];
        
    }
    
}

#pragma mark SDScanViewDelegate
//根据返回字符串包含的信息判断哪种二维码
//SAND_TN:tn号
//SAND_USER：12434
//SAND_MER：3445
//SAND_AUTH：1234
//SAND_LOGIN_CODE:tToken
-(void)SDScanViewOutputMetadataObjects:(NSArray *)metadataObjs{
    
    AVMetadataMachineReadableCodeObject *obj = [metadataObjs objectAtIndex:0];
    
    NSArray *stringArr = [obj.stringValue componentsSeparatedByString:@":"];
    
    if ([[stringArr firstObject] isEqualToString:@"SAND_TN"]) {
        //启动支付
        [self TNOrder:[stringArr lastObject]];
    }
    else if ([[stringArr firstObject] isEqualToString:@"SAND_USER"]) {
        
    }
    else if ([[stringArr firstObject] isEqualToString:@"SAND_MER"]) {
        
    }
    else if ([[stringArr firstObject] isEqualToString:@"SAND_AUTH"]) {
        
    }
    else if ([[stringArr firstObject] isEqualToString:@"SAND_LOGIN_CODE"]) {
//        //启动扫码登陆
//        [self  presentScanLoginViewcontroller : obj.stringValue];
//        //pop一下
//        [self.navigationController popViewControllerAnimated:NO];
    }else{
        [[SDAlertView shareAlert] showDialog:@"您的二维码有误,请确认后再扫" defulBlock:^{
            [self.navigationController popViewControllerAnimated:YES];
        }];
    }
    
    
}


#pragma mark - 业务逻辑
- (void)TNOrder:(NSString*)TN
{
    TnOrderViewController *sandTNOrderVC  = [[TnOrderViewController alloc] init];
    sandTNOrderVC.TN = TN;
    [self.navigationController pushViewController:sandTNOrderVC animated:YES];
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
