//
//  RealNameAuthenticationrResultViewController.m
//  sandbao
//
//  Created by tianNanYiHao on 2017/2/9.
//  Copyright © 2017年 sand. All rights reserved.
//

#import "RealNameAuthenticationrResultViewController.h"
#import "SDSuccessAnimationView.h"

#define navbarColor RGBA(255, 255, 255, 1.0)

#define navViewColor RGBA(249, 249, 249, 1.0)

#define titleColor RGBA(174, 174, 174, 1.0)

#define textFiledColor RGBA(83, 83, 83, 1.0)

#define btnColor RGBA(255, 97, 51, 1.0)

#define viewColor RGBA(255, 255, 255, 1.0)

@interface RealNameAuthenticationrResultViewController ()
{
    NavCoverView *navCoverView;
    SDSuccessAnimationView *circleSuccessView;
}

@property (nonatomic, assign) CGSize viewSize;
@property (nonatomic, assign) CGFloat leftRightSpace;
@property (nonatomic, assign) CGFloat textFieldTextSize;
@property (nonatomic, assign) CGFloat btnTextSize;
@property (nonatomic, assign) CGFloat labelTextSize;
@property (nonatomic, assign) CGFloat titleSize;


@property (nonatomic, strong) UIScrollView *scrollView;

@end

@implementation RealNameAuthenticationrResultViewController

@synthesize viewSize;
@synthesize leftRightSpace;
@synthesize textFieldTextSize;
@synthesize btnTextSize;
@synthesize labelTextSize;
@synthesize scrollView;
@synthesize titleSize;

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view setBackgroundColor:RGBA(242, 242, 242, 1.0)];
    viewSize = self.view.bounds.size;
    leftRightSpace = 15;
    
    
    [self addView:self.view];
    [self settingNavigationBar];
}

#pragma mark - 设置导航栏
/**
 *@brief 设置导航栏
 *@return
 */
- (void)settingNavigationBar
{
   
    //导航渐变条
    navCoverView = [NavCoverView shareNavCoverView:CGRectMake(0, 0, viewSize.width, controllerTop) title:@"实名认证"];
//    [self.view addSubview:navCoverView];
    
    
    
}

#pragma mark - 创建组件
/**
 *@brief 创建组件
 *@param view UIView 参数：组件
 *@return
 */
-(void)addView:(UIView *)view
{
        labelTextSize = 17;
        titleSize = 14;
        textFieldTextSize = 27;
        btnTextSize = 15;


    //创建UIScrollView
    scrollView = [[UIScrollView alloc] init];
    scrollView.userInteractionEnabled = YES;
    scrollView.scrollEnabled = YES;
    scrollView.contentSize = CGSizeMake(viewSize.width, viewSize.height - controllerTop);
    scrollView.directionalLockEnabled = YES; //只能一个方向滑动
    scrollView.pagingEnabled = NO; //是否翻页
    scrollView.showsVerticalScrollIndicator =YES; //垂直方向的滚动指示
    scrollView.indicatorStyle = UIScrollViewIndicatorStyleWhite;//滚动指示的风格
    scrollView.showsHorizontalScrollIndicator = NO;//水平方向的滚动指示
    [scrollView setBackgroundColor:RGBA(242, 242, 242, 1.0)];
    [view addSubview:scrollView];
    self.automaticallyAdjustsScrollViewInsets = NO;

    //4.渐变色
    scrollView.frame = CGRectMake(0, 0,viewSize.width, viewSize.height);
    CAGradientLayer *layerRGB = [CAGradientLayer layer];
    layerRGB.frame = scrollView.bounds;
    layerRGB.startPoint = CGPointMake(0, 0);
    layerRGB.endPoint = CGPointMake(0, 1);
    layerRGB.colors = @[(__bridge id)RGBA(96, 224, 178, 1.0).CGColor,(__bridge id)RGBA(29, 204, 140, 1.0).CGColor];
    [scrollView.layer insertSublayer:layerRGB atIndex:0];
    

    // 3.设置右边的返回item
    UILabel *rightLab = [[UILabel alloc] init];
    rightLab.textColor = [UIColor whiteColor];
    rightLab.textAlignment = NSTextAlignmentRight;
    rightLab.font = [UIFont systemFontOfSize:titleSize];
    rightLab.text = @"完成";
    [view addSubview:rightLab];
    
    UIButton *rightBarBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    [rightBarBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    rightBarBtn.tag = 102;
    [rightBarBtn addTarget:self action:@selector(buttonActionToDoSomething:) forControlEvents:UIControlEventTouchUpInside];
    CGSize sizeRight = [@"完成" sizeWithNSStringFont:[UIFont systemFontOfSize:titleSize]];
    rightBarBtn.contentMode = UIViewContentModeScaleAspectFit;
    [view addSubview:rightBarBtn];
    
    [rightLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(view).offset(20+leftRightSpace);
        make.right.equalTo(view.mas_right).offset(-leftRightSpace);
        make.size.mas_equalTo(CGSizeMake(sizeRight.width, sizeRight.height));
    }];
    
    [rightBarBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(view).offset(20+leftRightSpace);
        make.right.equalTo(view.mas_right).offset(-leftRightSpace);
        make.size.mas_equalTo(CGSizeMake(sizeRight.width, sizeRight.height));
    }];
    
    

  
    
    //圆
    UIImage *successImg = [UIImage imageNamed:@"success"];
    circleSuccessView = [SDSuccessAnimationView createCircleSuccessView:CGRectMake(0, 0, successImg.size.width, successImg.size.height)];
    circleSuccessView.circleLineWidth = 6.5f;
    circleSuccessView.lineSuccessColor = RGBA(255, 255, 255, 1);
    [circleSuccessView buildPath];
    [scrollView addSubview:circleSuccessView];
    [circleSuccessView animationStart];
    
    //恭喜
    UILabel *successLab = [[UILabel alloc] init];
    successLab.text = @"恭喜,您已成功认证";
    successLab.textColor = [UIColor whiteColor];
    successLab.textAlignment = NSTextAlignmentCenter;
    [scrollView addSubview:successLab];
    
    
    //描述
    UILabel *successDecLab = [[UILabel alloc] init];
//    successDecLab.text = @"您的消费额度为5000.00元";
    successDecLab.text = @"  ";
    successDecLab.textColor = [UIColor whiteColor];
    successDecLab.textAlignment = NSTextAlignmentCenter;
    [scrollView addSubview:successDecLab];
    
    
    UIView *personBgView = [[UIView alloc] init];
    personBgView.layer.cornerRadius = 5;
    personBgView.layer.masksToBounds = YES;
    personBgView.backgroundColor = [UIColor whiteColor];
    [scrollView addSubview:personBgView];
    
    //personLab
    UILabel *personLab = [[UILabel alloc] init];
    personLab.text = @"进入个人中心";
    personLab.textColor = RGBA(21, 180, 241, 1.0);
    personLab.textAlignment = NSTextAlignmentCenter;
    [personBgView addSubview:personLab];
    
    //personCenterBtn
    UIButton *personCenterBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    [personCenterBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    personCenterBtn.tag = 103;
    [personCenterBtn setBackgroundColor:[UIColor clearColor]];
    [personCenterBtn addTarget:self action:@selector(buttonActionToDoSomething:) forControlEvents:UIControlEventTouchUpInside];
    
    personCenterBtn.contentMode = UIViewContentModeScaleAspectFit;
    [personBgView addSubview:personCenterBtn];
    


    
    //
    CGFloat successImgTopSpace = 90;
    CGSize successLabSize = [successLab.text sizeWithNSStringFont:[UIFont systemFontOfSize:labelTextSize]];
    CGSize successDecLabSize = [successDecLab.text sizeWithNSStringFont:[UIFont systemFontOfSize:labelTextSize]];
    CGSize size = [personLab.text sizeWithNSStringFont:[UIFont systemFontOfSize:btnTextSize]];
    CGFloat successLabTop = 30;
    CGFloat sucessDecLabTop = 68;
    CGFloat personCentBtnTop = 120;
    CGSize personCenterBtnSize = CGSizeMake(size.width+2*leftRightSpace, size.height+2*leftRightSpace);
    
    
    
    [scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(view).offset(0);
        make.centerX.equalTo(view);
        make.size.mas_equalTo(CGSizeMake(viewSize.width, viewSize.height));
    }];
    
    
    [circleSuccessView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(scrollView).offset(successImgTopSpace);
        make.centerX.equalTo(scrollView.mas_centerX);
        make.size.mas_equalTo(CGSizeMake(successImg.size.width, successImg.size.height));
    }];
    
    [successLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(circleSuccessView.mas_bottom).offset(successLabTop);
        make.centerX.equalTo(scrollView);
        make.size.mas_equalTo(successLabSize);
    }];
    
    [successDecLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(successLab.mas_bottom).offset(sucessDecLabTop);
        make.centerX.equalTo(scrollView);
        make.size.mas_equalTo(successDecLabSize);
    }];
    
  
    
    
    
    
    
    [personBgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(successDecLab.mas_bottom).offset(personCentBtnTop);
        make.centerX.equalTo(scrollView);
        make.size.mas_equalTo(personCenterBtnSize);
    }];
    [personLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(personBgView).offset(0);
        make.centerX.equalTo(scrollView);
        make.size.mas_equalTo(personCenterBtnSize);
    }];
    
    [personCenterBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(personBgView).offset(0);
        make.centerX.equalTo(scrollView);
        make.size.mas_equalTo(personCenterBtnSize);
    }];
    
    
    
}

#pragma mark - 添加按钮添加事件
/**
 *@brief 添加按钮添加事件
 *@return
 */
- (void)buttonAction:(id)sender
{
    UIButton *btn = (UIButton *)sender;
    if(btn.tag == 1) {
        [[self class] cancelPreviousPerformRequestsWithTarget:self selector:@selector(buttonActionToDoSomething:) object:sender];
        [self performSelector:@selector(buttonActionToDoSomething:) withObject:sender afterDelay:1];
    } else {
        [[self class] cancelPreviousPerformRequestsWithTarget:self selector:@selector(buttonActionToDoSomething:) object:sender];
        [self performSelector:@selector(buttonActionToDoSomething:) withObject:sender afterDelay:0];
    }
}

#pragma mark - 按钮事件处理事情
/**
 *@brief 添加按钮添加事件
 *@return
 */
- (void)buttonActionToDoSomething:(id)sender
{
    UIButton *btn = (UIButton *)sender;
    switch (btn.tag) {
        case 101:
        {
            
        }
            break;
        case 102:
        {
            if (_isFromSPSrealName == YES) {
                 [self.navigationController popToRootViewControllerAnimated:YES];
            }else{
                [self.navigationController popToRootViewControllerAnimated:YES];
            }
            
        }
            break;
        case 103:
        {
            if (_isFromSPSrealName == YES) {
                [self.navigationController popToRootViewControllerAnimated:YES];
            }else{
                [self.navigationController popToRootViewControllerAnimated:YES];
            }
            
        }
            break;
        default:
            break;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
