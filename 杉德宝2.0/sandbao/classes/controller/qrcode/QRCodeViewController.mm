//
//  QRCodeViewController.m
//  sandbao
//
//  Created by tianNanYiHao on 2017/4/12.
//  Copyright © 2017年 sand. All rights reserved.
//

#import "QRCodeViewController.h"

#import "SDLog.h"
#import "PayNucHelper.h"

#define viewColor RGBA(255, 255, 255, 1.0)

@interface QRCodeViewController ()
{
    NavCoverView *navCoverView;
    CGPoint centerPoint;
}

@property (nonatomic, assign) CGSize viewSize;
@property (nonatomic, assign) BOOL twoCodeImageFlag;
@property (nonatomic, assign) BOOL oneCodeImageFlag;
@property (nonatomic, assign) CGFloat twoCodeImageViewWidth;
@property (nonatomic, assign) CGFloat twoCodeImageViewHeight;
@property (nonatomic, assign) CGFloat oneCodeImageViewWidth;
@property (nonatomic, assign) CGFloat oneCodeImageViewHeight;
@property (nonatomic, assign) CGFloat oneCodeLabelWidth;
@property (nonatomic, assign) CGFloat oneCodeLabelHeight;

@property (nonatomic, strong) SDMBProgressView *HUD;


@property (nonatomic, strong) UIImageView *oneCodeImageView;
@property (nonatomic, strong) UIImageView *twoCodeImageView;
@property (nonatomic, strong) UILabel *oneCodeLabel;
@property (nonatomic, weak) UIButton *refreshBtn;
@property (nonatomic, strong) NSTimer *timer;
@property (nonatomic, strong) UIButton *tempBtn;
@property (nonatomic, copy) NSMutableArray *authCodesArray;
@property (nonatomic, strong) NSDictionary *authCodeDic;

@end

@implementation QRCodeViewController

@synthesize viewSize;
@synthesize twoCodeImageFlag;
@synthesize twoCodeImageViewWidth;
@synthesize twoCodeImageViewHeight;
@synthesize oneCodeImageViewWidth;
@synthesize oneCodeImageViewHeight;
@synthesize oneCodeLabelWidth;
@synthesize oneCodeLabelHeight;

@synthesize HUD;


@synthesize twoCodeImageView;
@synthesize oneCodeImageView;
@synthesize oneCodeLabel;
@synthesize refreshBtn;
@synthesize timer;
@synthesize tempBtn;
@synthesize authCodesArray;
@synthesize authCodeDic;


- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.view setBackgroundColor:viewColor];
    viewSize = self.view.bounds.size;
    
    authCodesArray = [[NSMutableArray alloc] init];
    
    
    

    [self settingNavigationBar];
    [self addView:self.view];
    
    [self load];
    
//    [self readAuthCode];
}

#pragma mark - 设置导航栏
/**
 *@brief 设置导航栏
 *@return
 */
- (void)settingNavigationBar
{
    //导航渐变条
    navCoverView = [NavCoverView shareNavCoverView:CGRectMake(0, 0, viewSize.width, controllerTop) title:@"二维码"];
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

#pragma mark - 私有方法
/**
 *  添加子控件到试图上
 *
 *  @param view 当前试图
 */
- (void)addView:(UIView *)view {
    //生成条形码
    oneCodeImageViewWidth = 300;
    oneCodeImageViewHeight = 75;
    
    //条形码文本
    oneCodeLabelWidth = 300;
    oneCodeLabelHeight = 35;
    
    //生成二维码
    twoCodeImageViewWidth = 250;
    twoCodeImageViewHeight = 250;
    

        oneCodeImageViewWidth = 300;
        oneCodeImageViewHeight = 75;
        oneCodeLabelWidth = 300;
        oneCodeLabelHeight = 35;
        twoCodeImageViewWidth = 250;
        twoCodeImageViewHeight = 250;
    
    
    //生成条形码
    CGFloat oneCodeImageViewOX = (viewSize.width - oneCodeImageViewWidth) / 2;
    CGFloat oneCodeImageViewOY =  100;
    
    //条形码文本
    CGFloat oneCodeLabelOX = (viewSize.width - oneCodeLabelWidth) / 2;
    CGFloat oneCodeLabelOY = oneCodeImageViewOY + oneCodeImageViewHeight  + 10;
    
    //生成二维码
    CGFloat twoCodeImageViewOX = (viewSize.width - twoCodeImageViewWidth) / 2;
    CGFloat twoCodeImageViewOY =  oneCodeLabelOY + oneCodeLabelHeight + 10;
    
    oneCodeImageView = [[UIImageView alloc] init];
    oneCodeImageView.frame = CGRectMake(oneCodeImageViewOX, oneCodeImageViewOY, oneCodeImageViewWidth, oneCodeImageViewHeight);
    UITapGestureRecognizer *oneCodeTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(oneCodeTapShowBigView)];
    UIView *oneCodeTouchV = [[UIView alloc] initWithFrame:oneCodeImageView.frame];
    [oneCodeTouchV addGestureRecognizer:oneCodeTap];
    
    
    oneCodeLabel = [[UILabel alloc] init];
    oneCodeLabel.frame = CGRectMake(oneCodeLabelOX, oneCodeLabelOY, oneCodeLabelWidth, oneCodeLabelHeight);
    oneCodeLabel.font = [UIFont systemFontOfSize:17];
    oneCodeLabel.textColor = [UIColor blackColor];
    oneCodeLabel.textAlignment = NSTextAlignmentCenter;
    
    
    twoCodeImageView = [[UIImageView alloc] init];
    twoCodeImageView.frame = CGRectMake(twoCodeImageViewOX, twoCodeImageViewOY, twoCodeImageViewWidth, twoCodeImageViewHeight);
    twoCodeImageView.backgroundColor = [UIColor clearColor];
    UITapGestureRecognizer  *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(twoCodeImageScaleBigAnimation)];
    UIView *touchV = [[UIView alloc] initWithFrame:twoCodeImageView.frame];
    [touchV addGestureRecognizer:tap];
    
    [view addSubview:twoCodeImageView];
    [view addSubview:oneCodeImageView];
    [view addSubview:touchV];
    [view  addSubview:oneCodeTouchV];
    [view addSubview:oneCodeLabel];
    
    refreshBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [refreshBtn setTitle:@"每分钟自动刷新" forState:UIControlStateNormal];
    [refreshBtn setTitle:@"已更新" forState:UIControlStateHighlighted];
    [refreshBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    [refreshBtn setImage:[UIImage imageNamed:@"jipiaobuchong_37"] forState:UIControlStateNormal];
    refreshBtn.frame = CGRectMake(0, CGRectGetMaxY(twoCodeImageView.frame) - 10, self.view.frame.size.width, 30);
    [refreshBtn addTarget:self action:@selector(refreshAuthCode) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:refreshBtn];
}

/**
 *  获取二维码
 *
 */
- (void)load
{
    HUD = [SDMBProgressView showSDMBProgressOnlyLoadingINViewImg:self.view];
    [SDRequestHelp shareSDRequest].HUD = HUD;
    [SDRequestHelp shareSDRequest].controller = self;
    [[SDRequestHelp shareSDRequest] dispatchGlobalQuque:^{
        __block BOOL error = NO;
        paynuc.set("cfg_httpAddress", [[NSString stringWithFormat:@"%@app/api/",AddressHTTP] UTF8String]);
        paynuc.set("tTokenType", "04000301");
        [[SDRequestHelp shareSDRequest] requestWihtFuncName:@"token/getTtoken/v1" errorBlock:^(SDRequestErrorType type) {
            error = YES;
        } successBlock:^{
            
        }];
        if (error) return ;
        
        
        paynuc.set("cfg_httpAddress", [[NSString stringWithFormat:@"%@app/api/",AddressHTTP] UTF8String]);
        [[SDRequestHelp shareSDRequest] requestWihtFuncName:@"user/getAuthCodes/v1" errorBlock:^(SDRequestErrorType type) {
            error = YES;
        } successBlock:^{
            [[SDRequestHelp shareSDRequest] dispatchToMainQueue:^{
                [HUD hidden];
                
                
                NSString *authCodes = [NSString stringWithUTF8String:paynuc.get("authCodes").c_str()];
                NSArray *tempArray = [[PayNucHelper sharedInstance] jsonStringToArray:authCodes];
                
                NSInteger tempArrayCount = [tempArray count];
                for (int i = 0; i < tempArrayCount; i++) {
                    [authCodesArray addObject:tempArray[i]];
                }
                
                [self readAuthCode];

            }];
        }];
        
        if (error) return ;
    }];

}

/**
 *  从数据库中读取授权码
 */
- (void)readAuthCode {
    timer = [NSTimer scheduledTimerWithTimeInterval:5 target:self selector:@selector(refreshAuthCode) userInfo:nil repeats:YES];
    [self refreshAuthCode];

    
    
}

/**
 *  刷新授权码
 */
- (void)refreshAuthCode {
    authCodeDic = [authCodesArray firstObject];
    if (![@"" isEqualToString:[authCodeDic objectForKey:@"code"]]) {
        
    }
    
    NSString *authCode = [authCodeDic objectForKey:@"code"];
    [SDLog logTest:authCode];
    
    [authCodesArray removeObject:authCodeDic];
    
    if(![@"" isEqualToString:authCode] && authCode != nil){
        
    
        //生成二维码
        twoCodeImageView.image = [Tool twoDimensionCodeWithStr:authCode size:twoCodeImageViewWidth];
        
        if ([[[UIDevice currentDevice] systemVersion] floatValue]<= 7.0f) {
            [Tool showDialog:@"条形码暂不支持您当前系统版本"];
            return;
        }
        //生成条形码
        oneCodeImageView.image = [Tool barCodeImageWithStr:authCode];
        
        
        refreshBtn.enabled = YES;
        
        //条形码文本
        oneCodeLabel.text =[self oneCodeContentFotmat:authCode];
    }else {
        [self load];
        refreshBtn.enabled = NO;
        [timer invalidate];
        timer = nil;
    }
}

/**
 *  拼接字符串(条形码格式)
 *  @param    content   要拼接字符串的数组
 *  @return             返回NSString
 */
- (NSString *)oneCodeContentFotmat:(NSString *)content
{
    NSString *symbol = @"   ";
    NSString *oneContent = [content substringWithRange:NSMakeRange(0, 4)];
    NSString *twoContent = [content substringWithRange:NSMakeRange(4, 4)];
    NSString *threeContent = [content substringWithRange:NSMakeRange(8, 4)];
    NSString *fourContent = [content substringWithRange:NSMakeRange(12, content.length - 12)];
    
    NSMutableString *result = [NSMutableString stringWithFormat:@"%@%@%@%@%@%@%@", oneContent, symbol, twoContent, symbol, threeContent, symbol, fourContent];
    
    return result;
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
        case 1:
        {
            
        }
            break;
        case 2:
        {
            
        }
            break;
        case 101:
        {
            [self.navigationController popViewControllerAnimated:YES];
        }
            break;
            
        default:
            break;
    }
}
 



/**
 条形码 横屏变大/缩小
 */
- (void)oneCodeTapShowBigView{
    if (!_oneCodeImageFlag) {
         [timer setFireDate:[NSDate distantFuture]];
        
        tempBtn = [[UIButton alloc] init];
        tempBtn.frame = CGRectMake(0, 0, viewSize.width, viewSize.height-controllerTop);
        tempBtn.backgroundColor = [UIColor clearColor];
        [tempBtn addTarget:self action:@selector(oneCodeTapShowBigView) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:tempBtn];
        centerPoint = oneCodeImageView.center;
        [UIView animateWithDuration:0.3 animations:^{
            oneCodeImageView.center = CGPointMake([UIScreen mainScreen].bounds.size.width/2, [UIScreen mainScreen].bounds.size.height/2);
            CGAffineTransform transformRotate = CGAffineTransformMakeRotation(M_PI_2);
            oneCodeImageView.transform = CGAffineTransformScale(transformRotate, 1.4, 1.4);
            [tempBtn addSubview:oneCodeImageView];
        } completion:^(BOOL finished) {
            tempBtn.backgroundColor = viewColor;
            _oneCodeImageFlag = YES;
        }];
    }else{
        [UIView animateWithDuration:0.3 animations:^{
            oneCodeImageView.center = centerPoint;
            CGAffineTransform transformRotate = CGAffineTransformMakeRotation(0);
            oneCodeImageView.transform = CGAffineTransformScale(transformRotate, 1.0f, 1.0f);
        } completion:^(BOOL finished) {
            [tempBtn removeFromSuperview];
            [self.view addSubview:oneCodeImageView];
            _oneCodeImageFlag = NO;
            [timer setFireDate:[NSDate date]];
        }];
    }
    
}
/**
 *@brief 二维码放大/缩小
 *@return
 */
- (void)twoCodeImageScaleBigAnimation
{
    if (!twoCodeImageFlag) {
        [timer setFireDate:[NSDate distantFuture]];

        
        tempBtn = [[UIButton alloc] init];
        tempBtn.frame = CGRectMake(0, 0, viewSize.width, viewSize.height-controllerTop);
        tempBtn.backgroundColor = [UIColor clearColor];
        [tempBtn addTarget:self action:@selector(twoCodeImageScaleBigAnimation) forControlEvents:UIControlEventTouchUpInside];
        
        [self.view addSubview:tempBtn];
        centerPoint = twoCodeImageView.center;

        
        [UIView animateWithDuration:0.3 animations:^{
            twoCodeImageView.center = CGPointMake([UIScreen mainScreen].bounds.size.width/2, [UIScreen mainScreen].bounds.size.height/2);
            twoCodeImageView.transform = CGAffineTransformMakeScale(1.2, 1.2);
            [tempBtn addSubview:twoCodeImageView];
            
        }completion:^(BOOL finished) {
            tempBtn.backgroundColor = viewColor;
            twoCodeImageFlag = YES;
        }];
    } else {
        [UIView animateWithDuration:0.3 animations:^{
            twoCodeImageView.center = centerPoint;
            twoCodeImageView.transform = CGAffineTransformMakeScale(1, 1);
        }completion:^(BOOL finished) {
            twoCodeImageFlag = NO;
            [tempBtn removeFromSuperview];
            [self.view addSubview:twoCodeImageView];
            [timer setFireDate:[NSDate date]];
        }];
    }
}



/**
 *  试图销毁完成方法
 *
 *  @param animated
 */
- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    
//    [[UIScreen mainScreen] setBrightness:screenValue];
    [timer invalidate];
    timer = nil;
//    [window removeFromSuperview];
//    window = nil;
//    [session close];
    [self settingNavigationBar];
    
    
    //流程结束 必须重置cfg_httpAddress 地址(返回主Api地址:paynuc工具设计如此)
    paynuc.set("cfg_httpAddress", [[NSString stringWithFormat:@"%@app/api/",AddressHTTP] UTF8String]);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
