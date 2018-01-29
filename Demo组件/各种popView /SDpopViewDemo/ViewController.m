//
//  ViewController.m
//  SDpopViewDemo
//
//  Created by tianNanYiHao on 2017/11/2.
//  Copyright © 2017年 tianNanYiHao. All rights reserved.
//

#import "ViewController.h"

#import "SDSearchPop.h"
#import "SDRechargePopView.h"
#import "SDBottomPop.h"

#import "SDExpiryPop.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    
    
    
}

- (IBAction)searchPopClick:(id)sender {
    
  
    [SDExpiryPop showExpiryPopView:^(NSString *mY) {
       
        NSLog(@"%@",mY);
        
    }];
    
    
}
- (IBAction)rechargePopClick:(id)sender {
    

}
- (IBAction)bottomPopClick:(id)sender {
    
 
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
