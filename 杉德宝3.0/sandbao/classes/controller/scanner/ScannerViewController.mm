//
//  ScannerViewController.m
//  collectionTreasure
//
//  Created by tianNanYiHao on 15/7/9.
//  Copyright (c) 2015年 sand. All rights reserved.
//

//SAND_TN:tn号
//SAND_USER：12434
//SAND_MER：3445
//SAND_AUTH：1234
//SAND_LOGIN_CODE:tToken

#import "ScannerViewController.h"
#import <AVFoundation/AVFoundation.h>

#import "SDScanView.h"

#import "SDLog.h"
#import "PayNucHelper.h"
#import "OrderInfoNatiVeViewController.h"
#import "ScanLogingViewController.h"

#define SCANNER_WIDTH 200.0f

@interface ScannerViewController()<SDScanViewDelegate>
{
    NavCoverView *navCoverView;
    
    
    SDScanView *scanView;
    CGSize viewSize;
    CGFloat screenValue;
    CGFloat scanner_X;
    CGFloat scanner_Y;
    CGRect viewFrame;
    
    UILabel *resultLabel;
    
    NSString *twoCodeContent;
    NSString *oneCodeContent;
}

@property (nonatomic, strong) SDMBProgressView *HUD;



@end

@implementation ScannerViewController

@synthesize HUD;



- (void)viewDidLoad {
    [super viewDidLoad];
    
    viewSize = self.view.frame.size;
    screenValue = [UIScreen mainScreen].brightness;
    [self.view setBackgroundColor:RGBA(248, 248, 248, 1.0)];
    
    
    

    
    
    [self addView:self.view];
    [self settingNavigationBar];
}

#pragma mark - 设置导航栏
/**
 *@brief 设置导航栏
 *@return
 */
- (void)settingNavigationBar
{
    //导航渐变条
    navCoverView = [NavCoverView shareNavCoverView:CGRectMake(0, 0, viewSize.width, controllerTop) title:@"扫一扫"];
    [self.view addSubview:navCoverView];
    
    // 2.设置左边的返回item
    UIImage *leftImage = [UIImage imageNamed:@"back"];
    UIButton *leftBarBtn = [[UIButton alloc] init];
    leftBarBtn.frame = CGRectMake(0, 20 + (40 - leftImage.size.height) / 2, leftImage.size.width, leftImage.size.height);
    leftBarBtn.tag = 101;
    [leftBarBtn setImage:[UIImage imageNamed:@"back"] forState:UIControlStateNormal];
    [leftBarBtn setImage:[UIImage imageNamed:@"back"] forState:UIControlStateHighlighted];
    [leftBarBtn addTarget:self action:@selector(buttonActionToDoSomething:) forControlEvents:UIControlEventTouchUpInside];
    [navCoverView addSubview:leftBarBtn];
    
    // 3.设置右边的返回item
    UIImage *rightImage = [UIImage imageNamed:@""];
    UIButton *rightBarBtn = [[UIButton alloc] init];
    [rightBarBtn setImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
    [rightBarBtn setImage:[UIImage imageNamed:@""] forState:UIControlStateHighlighted];
    rightBarBtn.frame = CGRectMake(viewSize.width - 10 - rightImage.size.width, 20 + (40 - rightImage.size.height) / 2, rightImage.size.width, rightImage.size.height);
    rightBarBtn.tag = 102;
    rightBarBtn.contentMode = UIViewContentModeScaleAspectFit;
    UIBarButtonItem *rightButtonItem = [[UIBarButtonItem alloc] initWithCustomView:rightBarBtn];
    self.navigationItem.rightBarButtonItem = rightButtonItem;
}



/**
 *@brief 创建组件 半透明背景初始化
 *@param view UIView 参数：组件
 *@return
 */
-(void)addView:(UIView *)view
{
    
    //使用前先判断相机权限
    NSString *mediaType = AVMediaTypeVideo;//读取媒体类型
    AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:mediaType];//读取设备授权状态
    if(authStatus == AVAuthorizationStatusRestricted || authStatus == AVAuthorizationStatusDenied){
        NSString *errorStr = @"应用相机权限受限,请在设置中启用";
        [Tool showDialog:errorStr defulBlock:^{
            [self.navigationController popViewControllerAnimated:YES];
        }];
        return;
    }
    
    scanView = [[SDScanView alloc] init];
    scanView.delegate = self;
    [self.view addSubview:scanView];
    
}

#pragma mark - SDScanViewDelegate
-(void)SDScanViewOutputMetadataObjects:(NSArray *)metadataObjs{
    
    AVMetadataMachineReadableCodeObject *obj = [metadataObjs objectAtIndex:0];
    
    [SDLog logTest:obj.stringValue];
    
    //根据返回字符串包含的信息判断哪种二维码
    
    //SAND_TN:tn号
    //SAND_USER：12434
    //SAND_MER：3445
    //SAND_AUTH：1234
    //SAND_LOGIN_CODE:tToken
    
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
        //启动扫码登陆
        [self  presentScanLoginViewcontroller : obj.stringValue];
        //pop一下
        [self.navigationController popViewControllerAnimated:NO];
    }else{
        [Tool showDialog:@"您的二维码有误哦,请确认后再扫" defulBlock:^{
            [self.navigationController popToRootViewControllerAnimated:YES];
        }];
    }
    

}



- (void)presentScanLoginViewcontroller:(NSString *)code{
    ScanLogingViewController *scanLogvc = [[ScanLogingViewController alloc] init];
    scanLogvc.code = code;
    [self presentViewController:scanLogvc animated:YES completion:nil];
}



/**
 *@brief 添加按钮添加事件
 *@param view UIButton 参数：按钮
 *@param view tag 参数：按钮的类型
 *@return
 */
- (void)buttonAction:(id)sender
{
    UIButton *btn = (UIButton *)sender;
    switch (btn.tag) {

        case 101:
        {
            [self.navigationController popViewControllerAnimated:YES];
        }
            break;
            
        default:
            break;
    }
}

#pragma mark - 按钮事件处理事情
/**
 *@brief 添加按钮添加事件
 *@return
 */
- (void)buttonActionToDoSomething:(id)sender
{
    UIButton *btn = (UIButton *)sender;
    switch (btn.tag) {
        case 1:
        {
            
        }
            break;
        case 2:
        {
            
        }
            break;
        case 101:
        {
            [self.navigationController popViewControllerAnimated:YES];
        }
            break;
            
        default:
            break;
    }
}


#pragma mark - 业务逻辑
- (void)TNOrder:(NSString*)TN
{
    OrderInfoNatiVeViewController *mOrderInfoNatiVeViewController = [[OrderInfoNatiVeViewController alloc] init];
    mOrderInfoNatiVeViewController.controllerIndex = SDQRPAY; //设置支付类型为扫码支付
    mOrderInfoNatiVeViewController.TN = TN;
    [self.navigationController pushViewController:mOrderInfoNatiVeViewController animated:YES];
    
}

@end
