//
//  ViewController.m
//  SDAlertView
//
//  Created by tianNanYiHao on 2018/2/11.
//  Copyright © 2018年 tianNanYiHao. All rights reserved.
//

#import "ViewController.h"
#import "SDAlertView.h"
@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    [[SDAlertView shareAlert] showDialog:@"提示" message:@"这里是消息消息\n这里是消息内容" leftBtnString:@"确定" rightBtnString:@"取消" leftBlock:^{
        
    } rightBlock:^{
        
    }];
    
//    [self performSelector:@selector(ddd) withObject:nil afterDelay:10.f];
    
}

- (void)ddd{
    [[SDAlertView shareAlert] hideDialogAnimation:NO];
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    
    
   
    
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
