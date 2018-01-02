//
//  ViewController.m
//  ll
//
//  Created by tianNanYiHao on 2017/12/24.
//  Copyright © 2017年 tianNanYiHao. All rights reserved.
//

#import "ViewController.h"

#import "LFFAuthorizationManager.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    
    [[LFFAuthorizationManager defaultManager] requestAddressBookAccess];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
