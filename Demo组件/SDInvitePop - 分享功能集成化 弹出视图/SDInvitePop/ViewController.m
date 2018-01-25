//
//  ViewController.m
//  SDInvitePop
//
//  Created by tianNanYiHao on 2018/1/24.
//  Copyright © 2018年 tianNanYiHao. All rights reserved.
//

#import "ViewController.h"
#import "SDInvitePop.h"
@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    

    
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    
    [SDInvitePop showInvitePopView:@{@"icon":@[@"icon_wechat",@"icon_moments",@"icon_weibo",@"icon_wechat",@"icon_wechat"],
                                     @"title":@[@"微信",@"朋友圈",@"微博",@"icon_wechat信",@"icon_wechat信"]
                                     } cellClickBlock:^(NSString *titleName) {
                                         
                                         NSLog(@"%@",titleName);
                                     }];
    
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
