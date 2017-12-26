//
//  ViewController.m
//  SDQrcodeViewTwo
//
//  Created by tianNanYiHao on 2017/12/23.
//  Copyright © 2017年 tianNanYiHao. All rights reserved.
//

#import "ViewController.h"
#import "SDQrcodeView.h"
@interface ViewController ()
{
    SDQrcodeView *sdQrcodeView;
}
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.

    
    self.view.backgroundColor = [UIColor lightGrayColor];
    
    //1,
    [self ONE];

}
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    
    
}
- (void)ONE{
    
    sdQrcodeView = [[SDQrcodeView alloc] initWithFrame:CGRectZero];
    sdQrcodeView.style = PayQrcodeView;
    sdQrcodeView.roundRLColor = self.view.backgroundColor;
    sdQrcodeView.oneQrCodeStr = @"asfdsafd";
    sdQrcodeView.twoQrCodeStr = @"813129131212312";
    sdQrcodeView.payToolNameStr = @"杉德卡";
    sdQrcodeView.frame = CGRectMake(([UIScreen mainScreen].bounds.size.width - sdQrcodeView.frame.size.width)/2, 100, sdQrcodeView.frame.size.width, sdQrcodeView.frame.size.height);
    
    [self.view addSubview:sdQrcodeView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
