//
//  ViewController.m
//  spsTest
//
//  Created by tianNanYiHao on 2017/12/5.
//  Copyright © 2017年 tianNanYiHao. All rights reserved.
//

#import "ViewController.h"
#import "SDSandSPS.h"
#import "RXSPSEntry.h"



@interface ViewController ()<RXSPSDelegate>

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    
    RXSPSEntry*sps = [RXSPSEntry sharedInstance];
    
    sps.delegate = self ;

    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:sps];
    [self.navigationController presentViewController:navigationController animated:YES completion:nil];

    
    NSString *path = [[NSBundle mainBundle] pathForResource:@"123" ofType:@"json"];
    NSData *data = [NSData dataWithContentsOfFile:path];
    NSString *str = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    
    
    [sps CallSps:str];
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end