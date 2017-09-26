//
//  MqttMsgDetailViewController.m
//  sandbao
//
//  Created by tianNanYiHao on 2017/8/8.
//  Copyright © 2017年 sand. All rights reserved.
//

#import "MqttMsgDetailViewController.h"

#define navbarColor RGBA(242, 242, 242, 1.0)

#define navViewColor RGBA(255, 125, 50, 1.0)

#define lineViewColor RGBA(237, 237, 237, 1.0)

#define titleColor RGBA(174, 174, 174, 1.0)

#define textFiledColor RGBA(83, 83, 83, 1.0)

#define textFiledColordarkBlue RGBA(43, 56, 87, 1.0)

#define textFiledColorBlue  RGBA(65, 131, 215, 1.0)

#define textFiledColorlightGray RGBA(191, 195, 204, 1.0)

#define viewColor RGBA(255, 255, 255, 1.0)

@interface MqttMsgDetailViewController ()
{
    NavCoverView *navCoverView;
    CGSize viewSize;
    CGFloat titleTextSize;
    CGFloat labelTextSize;
    CGFloat lineViewHeight;
    CGFloat leftRightSpace;
    CGFloat space;
    
    UIScrollView *scrollView;
    
    CGFloat textFieldTextSize;
    CGFloat textSize;
}
@end

@implementation MqttMsgDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.layer.cornerRadius = 8.0f;
    self.view.layer.borderWidth = 0.8f;
    self.view.layer.borderColor = titleColor.CGColor;
    
    [self.view setBackgroundColor:RGBA(248, 248, 248, 1.0)];
    viewSize = self.view.bounds.size;
    leftRightSpace = 15;
    lineViewHeight = 1;
    space = 10;
    
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
 //this nothing
}

#pragma mark - 创建组件
/**
 *@brief 创建组件
 *@param view UIView 参数：组件
 *@return
 */
-(void)addView:(UIView *)view
{

        textFieldTextSize = 14;
        textSize = 15;
        

    
    //创建UIScrollView
    scrollView = [[UIScrollView alloc] init];
    scrollView.userInteractionEnabled = YES;
    scrollView.scrollEnabled = YES;
    scrollView.directionalLockEnabled = YES; //只能一个方向滑动
    scrollView.pagingEnabled = NO; //是否翻页
    scrollView.layer.cornerRadius = 8.0f;
    scrollView.showsVerticalScrollIndicator =YES; //垂直方向的滚动指示
    scrollView.indicatorStyle = UIScrollViewIndicatorStyleWhite;//滚动指示的风格
    scrollView.showsHorizontalScrollIndicator = NO;//水平方向的滚动指示
    [scrollView setBackgroundColor:navbarColor];
    scrollView.backgroundColor = [UIColor whiteColor];
    [view addSubview:scrollView];
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    UIImageView *backImagView = [[UIImageView alloc] init];
    backImagView.image = [UIImage imageNamed:@"bg"];
    [scrollView addSubview:backImagView];
    
    
    //msgType
    UILabel *msgTypeLab = [[UILabel alloc] init];
    msgTypeLab.textColor = titleColor;
    msgTypeLab.font = [UIFont systemFontOfSize:textSize];
    msgTypeLab.text = [NSString stringWithFormat:@"消息类型: %@",_msgTypeStr];
    [backImagView addSubview:msgTypeLab];
    
    //msgTime
    UILabel *msgTimeLab = [[UILabel alloc] init];
    msgTimeLab.textColor = textFiledColorBlue;
    msgTimeLab.text = [NSString stringWithFormat:@"推送时间: %@",_msgTImeStr];
    msgTimeLab.font = [UIFont systemFontOfSize:textFieldTextSize];
    [backImagView addSubview:msgTimeLab];
    
    
    //msgDescrep
    UILabel *msgDescrepLab = [[UILabel alloc] init];
    msgDescrepLab.textColor = textFiledColorlightGray;
    msgDescrepLab.font = [UIFont systemFontOfSize:textFieldTextSize];
    msgDescrepLab.text = [NSString stringWithFormat:@"消息内容: %@",_msgDetailStr];
    [backImagView addSubview:msgDescrepLab];
    
    //msgImagView
    UIImageView *msgImgView = [[UIImageView alloc] init];
    msgImgView.image = [UIImage imageNamed:@"home_banner"];
    [backImagView addSubview:msgImgView];
    
    
    CGFloat scrollViewW = self.view.bounds.size.width - 20*2; //此处20 = PresentAnimatedTransitioning
    CGFloat scrollViewH = self.view.bounds.size.height/3; //此处20 = PresentAnimatedTransitioning
    CGSize fitSizeMsgType = [msgTypeLab sizeThatFits:CGSizeMake(scrollViewW - 2*leftRightSpace, MAXFLOAT)];
    CGSize fitsizeMsgTime = [msgTimeLab sizeThatFits:CGSizeMake(scrollViewW - 2*leftRightSpace, MAXFLOAT)];
    
    

    
    [scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(view.mas_left);
        make.top.equalTo(view.mas_top);
        make.size.mas_equalTo(CGSizeMake(scrollViewW, scrollViewH));
    }];

    [backImagView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(scrollView.mas_top);
        make.left.equalTo(scrollView.mas_left);
        make.size.mas_equalTo(CGSizeMake(scrollViewW, scrollViewH));
        
    }];
    
    [msgTypeLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(scrollView.mas_left).offset(leftRightSpace);
        make.top.equalTo(scrollView.mas_top).offset(leftRightSpace);
        make.size.mas_equalTo(fitSizeMsgType);
    }];
    
    [msgTimeLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(msgTypeLab.mas_bottom).offset(space);
        make.left.equalTo(msgTypeLab.mas_left);
        make.size.mas_equalTo(fitsizeMsgTime);
    }];
    
    [msgDescrepLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(msgTimeLab.mas_bottom).offset(space);
        make.left.equalTo(scrollView.mas_left).offset(leftRightSpace);
        make.size.mas_equalTo(fitsizeMsgTime);
        
    }];
    
    [msgImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(backImagView.mas_bottom).offset(-space);
        make.left.equalTo(backImagView.mas_left).offset(leftRightSpace);
        make.size.mas_equalTo(CGSizeMake(scrollViewW - 2*leftRightSpace, scrollViewH/2 - 20));
    }];
    
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
        default:
            break;
    }
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    
    [self dismissViewControllerAnimated:YES completion:NULL];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
