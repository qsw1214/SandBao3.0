//
//  BaseViewController.m
//  sandbao
//
//  Created by tianNanYiHao on 2017/10/14.
//  Copyright © 2017年 sand. All rights reserved.
//

#import "BaseViewController.h"

@interface BaseViewController ()

@end

@implementation BaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //配置所有控制器背景色为白色
    self.view.backgroundColor = [UIColor whiteColor];
    
    //配置所有ScrollviewView子类不被navgationController下压64
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    //配置baseScrollview 且隐藏自带两个imageView(VerticalScrollIndicator/HorizontalScrollIndicator)
    self.baseScrollView = [[UIScrollView alloc] initWithFrame:CGRectZero];
    self.baseScrollView.showsVerticalScrollIndicator = NO;
    self.baseScrollView.showsHorizontalScrollIndicator = NO;
    [self.view addSubview:self.baseScrollView];
    
    //约束
    [self.baseScrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(0);
        make.top.equalTo (self.view.mas_top).offset(UPDOWNSPACE_64);
        make.size.mas_equalTo(CGSizeMake(SCREEN_SIZE.width, SCREEN_SIZE.height -  UPDOWNSPACE_64));
    }];
    
}

- (void)viewDidAppear:(BOOL)animated{
    
    [super viewDidAppear:animated];
    
     [self setBaseScrollViewContentSize];
    
}


/**
 设置baseScrollview的滚动区间
 */
- (void)setBaseScrollViewContentSize{
    
    CGFloat allHeight = 0.f;
    
    UIView *lasetObjectView = self.baseScrollView.subviews.lastObject;
    
    CGFloat lasetObjectViewOY = CGRectGetMaxY(lasetObjectView.frame);
    
    allHeight = lasetObjectViewOY;
    
    if (allHeight < SCREEN_HEIGHT - UPDOWNSPACE_64) {
        self.baseScrollView.contentSize = CGSizeMake(SCREEN_WIDTH, SCREEN_HEIGHT - UPDOWNSPACE_64);
    }else{
        self.baseScrollView.contentSize = CGSizeMake(SCREEN_WIDTH, allHeight);
    }
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}



@end
