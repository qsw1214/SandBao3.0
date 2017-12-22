//
//  ViewController.m
//  scan
//
//  Created by tianNanYiHao on 2017/12/22.
//  Copyright © 2017年 tianNanYiHao. All rights reserved.
//

#import "ViewController.h"
#import "SDScanView.h"
#import <AVFoundation/AVFoundation.h>

@interface ViewController ()<SDScanViewDelegate>
{
    SDScanView *scanView;
}
@property (weak, nonatomic) IBOutlet UITextField *lab;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    
    
    scanView = [[SDScanView alloc] init];
    scanView.delegate = self;
    [self.view addSubview:scanView];
    
    
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
        
        scanView.hidden = YES;
        _lab.text = [stringArr lastObject];
        
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

    }
    
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
