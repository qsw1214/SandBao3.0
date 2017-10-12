//
//  ScanLogingViewController.m
//  sandbao
//
//  Created by tianNanYiHao on 2017/6/9.
//  Copyright © 2017年 sand. All rights reserved.
//

#import "ScanLogingViewController.h"

#import "SDScanView.h"

#import "SDLog.h"
#import "PayNucHelper.h"
#import "OrderInfoNatiVeViewController.h"

#define navbarColor RGBA(242, 242, 242, 1.0)

#define navViewColor RGBA(255, 125, 50, 1.0)

#define lineViewColor RGBA(237, 237, 237, 1.0)

#define titleColor RGBA(174, 174, 174, 1.0)

#define textFiledColor RGBA(83, 83, 83, 1.0)

#define textFiledColordarkBlue RGBA(43, 56, 87, 1.0)

#define textFiledColorBlue  RGBA(65, 131, 215, 1.0)

#define textFiledColorlightGray RGBA(191, 195, 204, 1.0)

#define viewColor RGBA(255, 255, 255, 1.0)
@interface ScanLogingViewController ()
{
    NavCoverView *navCoverView;
    
    CGSize viewSize;
    CGFloat titleTextSize;
    CGFloat labelTextSize;
    CGFloat lineViewHeight;
    CGFloat leftRightSpace;
    CGFloat space;
    CGFloat screenValue;
    CGFloat scanner_X;
    CGFloat scanner_Y;
    CGRect viewFrame;
    
    UILabel *resultLabel;
    
    NSString *twoCodeContent;
    NSString *oneCodeContent;
    
    CGFloat textSize;
    UIScrollView *scrollView;

}
@property (nonatomic, strong) SDMBProgressView *HUD;

@end

@implementation ScanLogingViewController
@synthesize HUD;




- (void)viewDidLoad {
    [super viewDidLoad];
    leftRightSpace = 15;
    lineViewHeight = 1;
    space = 10;
    viewSize = self.view.frame.size;
    screenValue = [UIScreen mainScreen].brightness;
    [self.view setBackgroundColor:RGBA(248, 248, 248, 1.0)];
    
    
    

    
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
    //导航渐变条
    navCoverView = [NavCoverView shareNavCoverView:CGRectMake(0, 0, viewSize.width, controllerTop) title:@"确认登陆"];
    [self.view addSubview:navCoverView];
    
    // 2.设置左边的返回item
    UIImage *leftImage = [UIImage imageNamed:@"back"];
    UIButton *leftBarBtn = [[UIButton alloc] init];
    leftBarBtn.frame = CGRectMake(0, 20 + (40 - leftImage.size.height) / 2, leftImage.size.width, leftImage.size.height);
    leftBarBtn.tag = 101;
    [leftBarBtn setImage:[UIImage imageNamed:@"back"] forState:UIControlStateNormal];
    [leftBarBtn setImage:[UIImage imageNamed:@"back"] forState:UIControlStateHighlighted];
    [leftBarBtn addTarget:self action:@selector(buttonActionToDoSomething:) forControlEvents:UIControlEventTouchUpInside];
    [navCoverView addSubview:leftBarBtn];
    
    // 3.设置右边的返回item
    UIImage *rightImage = [UIImage imageNamed:@""];
    UIButton *rightBarBtn = [[UIButton alloc] init];
    [rightBarBtn setImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
    [rightBarBtn setImage:[UIImage imageNamed:@""] forState:UIControlStateHighlighted];
    rightBarBtn.frame = CGRectMake(viewSize.width - 10 - rightImage.size.width, 20 + (40 - rightImage.size.height) / 2, rightImage.size.width, rightImage.size.height);
    rightBarBtn.tag = 102;
    rightBarBtn.contentMode = UIViewContentModeScaleAspectFit;
    UIBarButtonItem *rightButtonItem = [[UIBarButtonItem alloc] initWithCustomView:rightBarBtn];
    self.navigationItem.rightBarButtonItem = rightButtonItem;
}



/**
 *@brief 创建组件 半透明背景初始化
 *@param view UIView 参数：组件
 *@return
 */
-(void)addView:(UIView *)view
{
 
        textSize = 15;
        

    
    //创建UIScrollView
    scrollView = [[UIScrollView alloc] init];
    scrollView.userInteractionEnabled = YES;
    scrollView.scrollEnabled = NO;
    scrollView.contentSize = CGSizeMake(viewSize.width, viewSize.height - controllerTop);
    scrollView.directionalLockEnabled = YES; //只能一个方向滑动
    scrollView.pagingEnabled = NO; //是否翻页
    scrollView.showsVerticalScrollIndicator =YES; //垂直方向的滚动指示
    scrollView.indicatorStyle = UIScrollViewIndicatorStyleWhite;//滚动指示的风格
    scrollView.showsHorizontalScrollIndicator = NO;//水平方向的滚动指示
    [scrollView setBackgroundColor:navbarColor];
    scrollView.contentSize = CGSizeMake(viewSize.width, viewSize.height);
    [view addSubview:scrollView];
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    
    //添加pc图标
    UIImage *pcImage = [UIImage imageNamed:@"files_none"];
    UIImageView *pcimageView = [[UIImageView alloc] init];
    pcimageView.image = pcImage;
    [scrollView addSubview:pcimageView];
    
    
    //lab标题
    //1.1.1 对方账户
    UILabel *suerLogLab = [[UILabel alloc] init];
    suerLogLab.text = @"杉德宝Web客户端登陆确认";
    suerLogLab.font = [UIFont systemFontOfSize:textSize];
    suerLogLab.textColor = RGBA(133,133,133, 1);
    [scrollView addSubview:suerLogLab];
    
    
    //登陆按钮

    UIButton *sureLogBtn = [[UIButton alloc] init];
    [sureLogBtn setTag:301];
    [sureLogBtn setTitle:@"登 陆" forState: UIControlStateNormal];
    [sureLogBtn setTitleColor:RGBA(65, 131, 213, 1) forState:UIControlStateNormal];
    sureLogBtn.titleLabel.font = [UIFont systemFontOfSize:textSize];
    sureLogBtn.layer.borderColor = RGBA(65, 131, 213, 1).CGColor;
    sureLogBtn.layer.borderWidth = 1.0f;
    [sureLogBtn setBackgroundColor:RGBA(255, 255, 255, 1)];
    [sureLogBtn.layer setMasksToBounds:YES];
    sureLogBtn.layer.cornerRadius = 5.0;
    [sureLogBtn addTarget:self action:@selector(buttonActionToDoSomething:) forControlEvents:UIControlEventTouchUpInside];
    [scrollView addSubview:sureLogBtn];
    

    //取消登陆按钮
    UIButton *cancelLogBtn = [[UIButton alloc] init];
    [cancelLogBtn setTag:302];
    [cancelLogBtn setTitle:@"取消登陆" forState: UIControlStateNormal];
    [cancelLogBtn setTitleColor:RGBA(136, 136, 136, 1.0) forState:UIControlStateNormal];
    cancelLogBtn.titleLabel.font = [UIFont systemFontOfSize:textSize];
    [cancelLogBtn setBackgroundColor:[UIColor clearColor]];
    [cancelLogBtn addTarget:self action:@selector(buttonActionToDoSomething:) forControlEvents:UIControlEventTouchUpInside];
    [scrollView addSubview:cancelLogBtn];
    
    
    CGSize sureLogBtnSzie = [sureLogBtn.titleLabel.text sizeWithNSStringFont:[UIFont systemFontOfSize:textSize]];
    CGSize sureLogLabSize = [suerLogLab.text sizeWithNSStringFont:[UIFont systemFontOfSize:textSize]];
    CGSize cancelLogBtnSize = [cancelLogBtn.titleLabel.text sizeWithNSStringFont:[UIFont systemFontOfSize:textSize]];
    CGFloat sureLogbtnH = sureLogBtnSzie.height + 2*space;
    CGFloat sureLogbtnW = sureLogBtnSzie.width + 8*leftRightSpace;
    
    CGFloat cancelLogbtnH = cancelLogBtnSize.height + 2*space;
    CGFloat cancelLogbtnW = cancelLogBtnSize.width + 4*leftRightSpace;
    
    CGFloat sureLogSpaceToScrollerViewH = (viewSize.height - controllerTop) - (cancelLogbtnH + sureLogbtnH + space) - leftRightSpace;
    
    
    
    [scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(view).offset(controllerTop);
        make.left.equalTo(view).offset(0);
        make.size.mas_equalTo(CGSizeMake(viewSize.width, viewSize.height-controllerTop));
    }];
    
    
    
    [pcimageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(scrollView.mas_top).offset(controllerTop);
        make.centerX.equalTo(scrollView.mas_centerX).offset(0);
        make.size.mas_equalTo(pcImage.size);
    }];
    
    
    [suerLogLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(pcimageView.mas_bottom).offset(leftRightSpace);
        make.centerX.equalTo(pcimageView.mas_centerX).offset(0);
        make.size.mas_equalTo(sureLogLabSize);
        
    }];
    
    [sureLogBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(scrollView.mas_top).offset(sureLogSpaceToScrollerViewH);
        make.centerX.equalTo(scrollView.mas_centerX).offset(0);
        make.size.mas_equalTo(CGSizeMake(sureLogbtnW, sureLogbtnH));
    }];
    
    [cancelLogBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(sureLogBtn.mas_bottom).offset(space);
        make.centerX.equalTo(sureLogBtn.mas_centerX).offset(0);
        make.size.mas_equalTo(CGSizeMake(cancelLogbtnW, cancelLogbtnH));
    }];
    
}




/**
 点击确认按钮授权登陆
 */
- (void)scanLogin{
    
    HUD = [SDMBProgressView showSDMBProgressOnlyLoadingINViewImg:self.view];
    [SDRequestHelp shareSDRequest].HUD = HUD;
    [SDRequestHelp shareSDRequest].controller = self;
    [[SDRequestHelp shareSDRequest] dispatchGlobalQuque:^{
        __block BOOL error = NO;
        paynuc.set("tTokenType", "01002501");
        [[SDRequestHelp shareSDRequest] requestWihtFuncName:@"token/getTtoken/v1" errorBlock:^(SDRequestErrorType type) {
            error = YES;
        } successBlock:^{
            
        }];
        if (error) return ;

        
        
        //期间域送空];
        NSMutableDictionary *periodDic = [NSMutableDictionary dictionaryWithCapacity:0];
        [periodDic setValue:@"" forKey:@"begin"];
        [periodDic setValue:@"" forKey:@"end"];
        [periodDic setValue:@"" forKey:@"span"];
        [periodDic setValue:@"" forKey:@"spanUnit"];
        
        NSMutableDictionary *loginCodeDic = [NSMutableDictionary dictionaryWithCapacity:0];
        [loginCodeDic setValue:periodDic forKey:@"period"];
        [loginCodeDic setValue:_code forKey:@"code"];
        
        NSString *loginCodestr = [[PayNucHelper sharedInstance] dictionaryToJson:loginCodeDic];
        paynuc.set("loginCode", [loginCodestr UTF8String]);
        [[SDRequestHelp shareSDRequest] requestWihtFuncName:@"user/setLoginCode/v1" errorBlock:^(SDRequestErrorType type) {
            error = YES;
        } successBlock:^{
            [[SDRequestHelp shareSDRequest] dispatchToMainQueue:^{
                [HUD hidden];
                
                NSString *respMsg = [NSString stringWithUTF8String:paynuc.get("respMsg").c_str()];
                [Tool showDialog:respMsg defulBlock:^{
                    [self dismissViewControllerAnimated:YES completion:nil];
                }];
            }];
        }];
        if (error) return ;
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
            [self dismissViewControllerAnimated:YES completion:nil];
        }
            break;
        case 301:
        {
            //点击确认按钮授权登陆
            [self scanLogin];
        }
            break;
        case 302:
        {
            [self dismissViewControllerAnimated:YES completion:nil];
        }
            break;
        default:
            break;
    }
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
