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

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    //基础配置 - self.navCoverView
    [self setNavCoverView];
    
    //基础配置 - 禁用RESideMenu的侧滑手势(子类控制器需要开启时,子类自己去修改为YES开启)
    self.sideMenuViewController.panGestureEnabled = NO;
    
    //基础配置 - 友盟页面统计埋点 - 进入页面
    [MobClick beginLogPageView:[NSString stringWithUTF8String:object_getClassName(self)]];
}
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    
    //基础配置 - 友盟页面统计埋点 - 离开页面
    [MobClick endLogPageView:[NSString stringWithUTF8String:object_getClassName(self)]];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    //基础配置 - 禁用系统侧滑返回
    self.navigationController.interactivePopGestureRecognizer.enabled = NO;
    
    //基础配置 - self.navgationController.navgationBar -> hidden
    self.navigationController.navigationBar.hidden = YES;
    
    //基础配置 - self.baseScrollView
    [self setBaseScrollview];
    
}

- (void)setBaseScrollview{
    //配置所有控制器背景色为白色
    self.view.backgroundColor = [UIColor whiteColor];
    
    //配置(适配iOS11)所有baseScrollview子类 不被navgationController下压64
    if (@available(iOS 11.0, *)) {
        self.baseScrollView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    } else {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    
    //配置所有baseScrollview子类 且隐藏自带两个imageView(VerticalScrollIndicator/HorizontalScrollIndicator)
    self.baseScrollView = [[UIScrollView alloc] initWithFrame:CGRectZero];
    self.baseScrollView.showsVerticalScrollIndicator = NO;
    self.baseScrollView.showsHorizontalScrollIndicator = NO;
    
    //配置所有baseScrollview子类 默认能滚动
    self.baseScrollView.scrollEnabled = YES;
    
    //配置所有baseScrollview子类 代理-提供禁止向下滚动方法
    self.baseScrollView.delegate = self;
    
    //配置所有baseScrollview子类 frame
    self.baseScrollView.frame = CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_HEIGHT - 64);
    [self.view addSubview:self.baseScrollView];
}

- (void)setNavCoverView{
    
    //避免重复创建
    if (self.navCoverView) {
        [self.navCoverView removeFromSuperview];
    }
    self.navCoverView = [NavCoverView createNavCorverView];
    self.navCoverView.style = NavCoverStyleWhite;
    self.navCoverView.midTitleStr = nil;
    self.navCoverView.letfImgStr = nil;
    self.navCoverView.leftTitleStr = nil;
    self.navCoverView.rightImgStr = nil;
    self.navCoverView.rightTitleStr = nil;

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
    
    allHeight = lasetObjectViewOY + UPDOWNSPACE_20;
    
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

- (void)dealloc{
    
    NSString *viewControllerName = [NSString stringWithUTF8String:object_getClassName(self)];
    NSLog(@"\n->\n(%@ -- 回收)\n->",viewControllerName);
    
}


@end
