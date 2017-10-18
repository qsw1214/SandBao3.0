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
    
    //基础配置 - self.baseScrollView
    [self setBaseScrollview];
    
    //基础配置 - self.navCoverView
    [self setNavCoverView];
}

- (void)setBaseScrollview{
    //配置所有控制器背景色为白色
    self.view.backgroundColor = [UIColor whiteColor];
    
    //配置所有baseScrollview子类 不被navgationController下压64
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    //配置所有baseScrollview子类 且隐藏自带两个imageView(VerticalScrollIndicator/HorizontalScrollIndicator)
    self.baseScrollView = [[UIScrollView alloc] initWithFrame:CGRectZero];
    self.baseScrollView.showsVerticalScrollIndicator = NO;
    self.baseScrollView.showsHorizontalScrollIndicator = NO;
    
    //配置所有baseScrollview子类 默认能滚动
    self.baseScrollView.scrollEnabled = YES;
    
    //配置所有baseScrollview子类 代理-提供禁止向下滚动方法
    self.baseScrollView.delegate = self;
    
    //配置所有baseScrollview子类 frame
    self.baseScrollView.frame = CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_HEIGHT - UPDOWNSPACE_64);
    [self.view addSubview:self.baseScrollView];
}

- (void)setNavCoverView{
    
    self.navCoverView = [NavCoverView createNavCorverView];
    self.navCoverView.style = NavCoverStyleWhite;
    self.navCoverView.midTitleStr = @"可爱的测试标题";
    self.navCoverView.letfImgStr = @"login_icon_back";
    self.navCoverView.rightImgStr = @"login_icon_back";
    
    self.navCoverView.leftBlock = ^{
        NSLog(@"BaseViewController -- navCoverView -- leftBlock");
    };
    self.navCoverView.rightBlock = ^{
        NSLog(@"BaseViewController -- navCoverView -- rightBlock");
    };
    
    [self.view addSubview:self.navCoverView];
    
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];

    //设置baseScrollview滚动区间
    [self setBaseScrollViewContentSize];
    
    //设置baseScrollview归位
    [self setBaseScrollviewContentoffsetOrigin];
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


/**
 页面didAppear时,baseScrollview归位
 */
- (void)setBaseScrollviewContentoffsetOrigin{
    
    if (self.baseScrollView.contentOffset.y > 0 || self.baseScrollView.contentOffset.y == 0 ) {
        [self.baseScrollView setContentOffset:CGPointMake(0, 0) animated:YES];
    }
    
}



#pragma mark - scrollerViewDelegate
//禁止本类及其子类baseScrollview向下滚动
-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    if (scrollView.contentOffset.y < 0 || scrollView.contentOffset.y == 0 ) {
        scrollView.contentOffset = CGPointMake(0, 0);
    }
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}



@end
