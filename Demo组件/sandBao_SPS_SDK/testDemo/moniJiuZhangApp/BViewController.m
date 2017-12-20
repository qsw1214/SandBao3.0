//
//  BViewController.m
//  moniJiuZhangApp
//
//  Created by tianNanYiHao on 2017/7/17.
//  Copyright © 2017年 tianNanYiHao. All rights reserved.
//

#import "BViewController.h"
#import "SpsDock.h"
#import "AppDelegate.h"
@interface BViewController ()<SpsDockDelegate>
@property (weak, nonatomic) IBOutlet UITextField *lab;

@end

@implementation BViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.title = @"😁  订单页";
    self.view.backgroundColor = [UIColor whiteColor];
    _lab.text = _tn;
    
    
}


- (IBAction)pay:(id)sender {
    
    [SpsDock sharedInstance].delegate = self;
    [[SpsDock sharedInstance] callSps:_tn];
    
}
#pragma SpsSDKDelegate
- (void)spsReturn:(NSString *)tn state:(NSString *)state{
    UIAlertView *view = [[UIAlertView alloc] initWithTitle:state message:tn delegate:self cancelButtonTitle:@"好的" otherButtonTitles:nil, nil];
    [view show];
}


@end
