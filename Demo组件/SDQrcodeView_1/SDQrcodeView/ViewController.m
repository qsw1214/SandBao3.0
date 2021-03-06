//
//  ViewController.m
//  SDQrcodeView
//
//  Created by tianNanYiHao on 2017/12/5.
//  Copyright © 2017年 tianNanYiHao. All rights reserved.
//

#import "ViewController.h"
#import "SDQrcodeView.h"
@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    self.view.backgroundColor = [UIColor lightGrayColor];
    
    
    
    //1,
    [self ONE];
    
    //2.
//    [self TWO];
    
    //3
//    [self THREE];

    
    
}

- (void)THREE{
    
    SDQrcodeView *sdQrcodeView = [[SDQrcodeView alloc] initWithFrame:CGRectZero];
    sdQrcodeView.roundRLColor = self.view.backgroundColor;
    sdQrcodeView.titleStr = @"向商家付款";
    sdQrcodeView.qrCodeDesStr = @"杉德宝扫一扫,向商家付款";
    [sdQrcodeView createSetMoneyBtnView];
    sdQrcodeView.frame = CGRectMake(([UIScreen mainScreen].bounds.size.width - sdQrcodeView.frame.size.width)/2, 100, sdQrcodeView.frame.size.width, sdQrcodeView.frame.size.height);
    
    [self.view addSubview:sdQrcodeView];
    
}

- (void)TWO{
    
    SDQrcodeView *sdQrcodeView = [[SDQrcodeView alloc] initWithFrame:CGRectZero];
    sdQrcodeView.roundRLColor = self.view.backgroundColor;
    sdQrcodeView.titleStr = @"向商家付款";
    sdQrcodeView.qrCodeDesStr = @"杉德宝扫一扫,向商家付款";
    [sdQrcodeView createBottomEmptyView];
    sdQrcodeView.frame = CGRectMake(([UIScreen mainScreen].bounds.size.width - sdQrcodeView.frame.size.width)/2, 100, sdQrcodeView.frame.size.width, sdQrcodeView.frame.size.height);
    
    [self.view addSubview:sdQrcodeView];
    
}

- (void)ONE{
    
    SDQrcodeView *sdQrcodeView = [[SDQrcodeView alloc] initWithFrame:CGRectZero];
    sdQrcodeView.roundRLColor = self.view.backgroundColor;
    sdQrcodeView.titleStr = @"向商家付款";
    sdQrcodeView.qrCodeDesStr = @"杉德宝扫一扫,向商家付款";
    sdQrcodeView.payToolNameStr = @"杉德卡";
    [sdQrcodeView createPayToolShowView];
    sdQrcodeView.frame = CGRectMake(([UIScreen mainScreen].bounds.size.width - sdQrcodeView.frame.size.width)/2, 100, sdQrcodeView.frame.size.width, sdQrcodeView.frame.size.height);
    
    [self.view addSubview:sdQrcodeView];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
