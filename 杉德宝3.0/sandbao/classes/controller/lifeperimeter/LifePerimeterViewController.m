//
//  LifePerimeterViewController.m
//  sandbao
//
//  Created by tianNanYiHao on 2016/10/31.
//  Copyright © 2016年 sand. All rights reserved.
//

#import "LifePerimeterViewController.h"


#define navbarColor RGBA(242, 242, 242, 1.0)
@interface LifePerimeterViewController ()<UIScrollViewDelegate>

{
    NavCoverView *navCoverView;
    CGFloat titleTextSize;
}
@property (nonatomic, strong) SDMBProgressView *HUD;

@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, assign) CGSize viewSize;

@end

@implementation LifePerimeterViewController
@synthesize HUD;

@synthesize viewSize;

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view setBackgroundColor:[UIColor lightGrayColor]];
    viewSize = self.view.bounds.size;
    [self settingNavigationBar];
    [self addView:self.view];
    
    

    
}

#pragma mark - 设置导航栏
/**
 *@brief 设置导航栏
 *@return
 */
- (void)settingNavigationBar
{
    // 1.标题
    //导航渐变条
    navCoverView = [NavCoverView shareNavCoverView:CGRectMake(0, 0, viewSize.width, controllerTop) title:@"生活周边"];
    [self.view addSubview:navCoverView];
    
}






#pragma mark - 创建组件
/**
 *@brief 创建组件
 *@param view UIView 参数：组件
 *@return
 */
-(void)addView:(UIView *)view
{
    [HUD hidden];

        titleTextSize = 14;



    //创建UIScrollView
    _scrollView = [[UIScrollView alloc] init];
    _scrollView.userInteractionEnabled = YES;
    _scrollView.scrollEnabled = YES;
    _scrollView.delegate = self;
    _scrollView.contentSize = CGSizeMake(viewSize.width, viewSize.height - controllerTop);
    _scrollView.directionalLockEnabled = YES; //只能一个方向滑动
    _scrollView.pagingEnabled = NO; //是否翻页
    _scrollView.showsVerticalScrollIndicator =YES; //垂直方向的滚动指示
    _scrollView.indicatorStyle = UIScrollViewIndicatorStyleWhite;//滚动指示的风格
    _scrollView.showsHorizontalScrollIndicator = NO;//水平方向的滚动指示
    [_scrollView setBackgroundColor:navbarColor];
    [view addSubview:_scrollView];
    self.automaticallyAdjustsScrollViewInsets = NO;

    
    UIImage *centerImg = [UIImage imageNamed:@"construction"];
    UIImageView *centerImgView = [[UIImageView alloc] init];
    centerImgView.image = centerImg;
    [_scrollView addSubview:centerImgView];
    
    UILabel *tipLab = [[UILabel alloc] init];
    tipLab.text = @"功能正在努力开发中...";
    tipLab.textAlignment = NSTextAlignmentCenter;
    tipLab.textColor = RGBA(18, 150, 219, 1.0f);
    [_scrollView addSubview:tipLab];
    
    
    
    
    CGSize tipLabSize = [tipLab.text sizeWithNSStringFont:[UIFont systemFontOfSize:titleTextSize]];
    

    
    [_scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(navCoverView.mas_bottom).offset(0);
        make.centerX.equalTo(view);
        make.size.mas_equalTo(CGSizeMake(viewSize.width, viewSize.height - controllerTop));
    }];
    
    
    [centerImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(_scrollView.mas_centerY);
        make.centerX.equalTo(_scrollView.mas_centerX);
        
    }];
    
    [tipLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(_scrollView.mas_centerX);
        make.top.equalTo(centerImgView.mas_bottom).offset(0);
        make.size.mas_equalTo(CGSizeMake(viewSize.width, tipLabSize.height));
        
    }];




}









- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}





@end
