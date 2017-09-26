//
//  ScannerViewController.m
//  collectionTreasure
//
//  Created by blue sky on 15/7/9.
//  Copyright (c) 2015年 sand. All rights reserved.
//

#import "ScannerViewController.h"
#import "ZXMultiFormatWriter.h"
#import "ZXImage.h"
#import "ZXCapture.h"
#import "ZXResult.h"
#import "SDLog.h"

#define SCANNER_WIDTH 200.0f

@interface ScannerViewController()
{
    NavCoverView *navCoverView;
    
    CGSize viewSize;
    CGFloat screenValue;
    CGFloat scanner_X;
    CGFloat scanner_Y;
    CGRect viewFrame;
    
    ZXCapture * capture;
    UILabel *resultLabel;
    UIImageView *lineView;//扫描线
    BOOL willUp;//扫描移动方向
    NSTimer *timer;//扫描线定时器
    NSString *twoCodeContent;
    NSString *oneCodeContent;
}


@end

@implementation ScannerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    viewSize = self.view.frame.size;
    screenValue = [UIScreen mainScreen].brightness;
    
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
    navCoverView = [NavCoverView shareNavCoverView:CGRectMake(0, 0, viewSize.width, controllerTop) title:@"扫一扫"];
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

//扫描线动画
-(void)lineAnimation{
    float y=lineView.frame.origin.y;
    if (y<=scanner_Y) {
        willUp=NO;
    }else if(y>=scanner_Y+SCANNER_WIDTH){
        willUp=YES;
    }
    if(willUp){
        y-=2;
        lineView.frame=CGRectMake(scanner_X, y, SCANNER_WIDTH, 2);
    }else{
        y+=2;
        lineView.frame=CGRectMake(scanner_X, y, SCANNER_WIDTH, 2);
    }
}

/**
 *@brief 创建组件 半透明背景初始化
 *@param view UIView 参数：组件
 *@return
 */
-(void)addView:(UIView *)view
{
    //扫描器初始化
    capture = [[ZXCapture alloc] init];
    capture.camera = capture.back;
    capture.focusMode = AVCaptureFocusModeContinuousAutoFocus;
    capture.layer.frame = self.view.bounds;
    capture.rotation=90.0f;//可以竖屏扫描条形码
    [self.view.layer addSublayer:capture.layer];
    
    //坐标初始化
    CGRect frame=self.view.frame;
    //如果是ipad，横屏，交换坐标
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad){
        viewFrame=CGRectMake(frame.origin.y, frame.origin.x, frame.size.height, frame.size.width);
    }else{
        viewFrame=self.view.frame;
    }
    CGPoint centerPoint=CGPointMake(viewFrame.size.width, viewFrame.size.height);
    //扫描框的x、y坐标
    scanner_X=centerPoint.x / 2-(SCANNER_WIDTH/2);
    scanner_Y= 100;
    
    //半透明背景初始化
    [self initBackgroundView:view];
    //扫描框
    UIImageView *borderView=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"border"]];
    borderView.frame=CGRectMake(scanner_X-5, scanner_Y-5, SCANNER_WIDTH+10, SCANNER_WIDTH+10);
    [view addSubview:borderView];
    //扫描线
    lineView=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"line"]];
    lineView.frame=CGRectMake(scanner_X, scanner_Y, SCANNER_WIDTH, 2);
    [view addSubview:lineView];
    timer=[NSTimer scheduledTimerWithTimeInterval:0.02f target:self selector:@selector(lineAnimation) userInfo:nil repeats:YES];
    
     //
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.text = @"请使用杉徳宝扫一扫顾客付款码收款";
    titleLabel.font = [UIFont systemFontOfSize:17 weight:2];
    titleLabel.textColor = [UIColor colorWithRed:(201/255.0) green:(202/255.0) blue:(204/255.0) alpha:1.0];
    [view addSubview:titleLabel];
    
    UIButton *inputAuthCodeBtn = [[UIButton alloc] init];
    inputAuthCodeBtn.tag = 1;
    [inputAuthCodeBtn setTitle:@"手动收入付款码" forState:UIControlStateNormal];
    inputAuthCodeBtn.titleLabel.font = [UIFont systemFontOfSize:21 weight:2];
    [inputAuthCodeBtn setTintColor:[UIColor colorWithRed:(161/255.0) green:(112/255.0) blue:(1/255.0) alpha:1.0]];
    inputAuthCodeBtn.backgroundColor = [UIColor colorWithRed:(14/255.0) green:(13/255.0) blue:(9/255.0) alpha:0.5];
    [inputAuthCodeBtn.layer setMasksToBounds:YES];
    [inputAuthCodeBtn.layer setCornerRadius:10.0];
    [inputAuthCodeBtn addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:inputAuthCodeBtn];
    
    //菜单
    UIView *menuView =[[UIView alloc] init];
    menuView.backgroundColor=[UIColor colorWithRed:0 green:0 blue:0 alpha:0.6f];
    [self.view addSubview:menuView];
    
    UILabel *titleOneLabel = [[UILabel alloc] init];
    titleOneLabel.text = @"方式一";
    //    titleOneLabel.backgroundColor = [UIColor blackColor];
    titleOneLabel.font = [UIFont systemFontOfSize:14 weight:2];
    titleOneLabel.textColor = [UIColor colorWithRed:(201/255.0) green:(202/255.0) blue:(204/255.0) alpha:1.0];
    [menuView addSubview:titleOneLabel];
    
    UILabel *titleContentOneLabel = [[UILabel alloc] init];
    titleContentOneLabel.text = @"请将顾客的条码放在框内，即可自动完成扫描支付）";
    //    titleContentOneLabel.backgroundColor = [UIColor redColor];
    titleContentOneLabel.font = [UIFont systemFontOfSize:14 weight:2];
    titleContentOneLabel.textColor = [UIColor colorWithRed:(201/255.0) green:(202/255.0) blue:(204/255.0) alpha:1.0];
    //自动折行设置
    titleContentOneLabel.lineBreakMode = UILineBreakModeWordWrap;
    titleContentOneLabel.numberOfLines = 0;
    [menuView addSubview:titleContentOneLabel];
    
    UILabel *titleTwoLabel = [[UILabel alloc] init];
    titleTwoLabel.text = @"方式二";
    //    titleTwoLabel.backgroundColor = [UIColor yellowColor];
    titleTwoLabel.font = [UIFont systemFontOfSize:14 weight:2];
    titleTwoLabel.textColor = [UIColor colorWithRed:(201/255.0) green:(202/255.0) blue:(204/255.0) alpha:1.0];
    [menuView addSubview:titleTwoLabel];
    
    UILabel *titleContentTwoLabel = [[UILabel alloc] init];
    titleContentTwoLabel.text = @"手动完成线下付款";
    //    titleContentTwoLabel.backgroundColor = [UIColor blueColor];
    titleContentTwoLabel.font = [UIFont systemFontOfSize:14 weight:2];
    titleContentTwoLabel.textColor = [UIColor colorWithRed:(201/255.0) green:(202/255.0) blue:(204/255.0) alpha:1.0];
    //自动折行设置
    titleContentTwoLabel.lineBreakMode = UILineBreakModeWordWrap;
    titleContentTwoLabel.numberOfLines = 0;
    [menuView addSubview:titleContentTwoLabel];
    
    //设置组件的位置和大小
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(borderView.mas_bottom).offset(20);
        make.centerX.equalTo(view);
    }];
    
    [inputAuthCodeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(titleLabel.mas_bottom).offset(10);
        make.centerX.equalTo(view);
        make.size.mas_equalTo(CGSizeMake(180, 35));
    }];
    
    [menuView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(view.mas_bottom).offset(0);
        make.left.equalTo(view).offset(0);
        make.size.mas_equalTo(CGSizeMake(view.bounds.size.width, view.bounds.size.width * 0.5));
    }];
    
    CGSize titleOneLabelTextSize = [titleContentOneLabel sizeThatFits:CGSizeMake(viewSize.width - 2 * 20, MAXFLOAT)];
    [titleOneLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(menuView).offset(20);
        make.left.equalTo(view).offset(20);
        make.size.mas_equalTo(CGSizeMake(viewSize.width - 2 * 20, titleOneLabelTextSize.height));
    }];
    
    
    CGSize titleContentOneLabelTextSize = [titleContentOneLabel sizeThatFits:CGSizeMake(viewSize.width - 2 * 20, MAXFLOAT)];
    [titleContentOneLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(titleOneLabel.mas_bottom).offset(0);
        make.left.equalTo(menuView).offset(20);
        make.size.mas_equalTo(CGSizeMake(viewSize.width - 2 * 20, titleContentOneLabelTextSize.height));
    }];
    
    CGSize titleTwoLabelTextSize = [titleContentOneLabel sizeThatFits:CGSizeMake(viewSize.width - 2 * 20, MAXFLOAT)];
    [titleTwoLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(titleContentOneLabel.mas_bottom).offset(0);
        make.left.equalTo(menuView).offset(20);
        make.size.mas_equalTo(CGSizeMake(viewSize.width - 2 * 20, titleTwoLabelTextSize.height));
    }];
    
    CGSize titleContentTwoLabelTextSize = [titleContentTwoLabel sizeThatFits:CGSizeMake(viewSize.width - 2 * 20, MAXFLOAT)];
    [titleContentTwoLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(titleTwoLabel.mas_bottom).offset(0);
        make.left.equalTo(menuView).offset(20);
        make.size.mas_equalTo(CGSizeMake(viewSize.width - 2 * 20, titleContentTwoLabelTextSize.height));
    }];
}

/**
 *@brief 半透明背景初始化
 *@param view UIView 参数：组件
 *@return
 */
- (void)initBackgroundView:(UIView *)view
{
    CGRect scannerFrame=CGRectMake(scanner_X, scanner_Y,SCANNER_WIDTH, SCANNER_WIDTH);
    float x=scannerFrame.origin.x;
    float y=scannerFrame.origin.y;
    float width=scannerFrame.size.width;
    float height=scannerFrame.size.height;
    float mainWidth=viewFrame.size.width;
    float mainHeight=viewFrame.size.height;
    
    UIView *upView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, mainWidth, y)];
    UIView *leftView=[[UIView alloc]initWithFrame:CGRectMake(0, y, x, height)];
    UIView *rightView=[[UIView alloc]initWithFrame:CGRectMake(x+width, y, mainWidth-x-width, height)];
    UIView *downView=[[UIView alloc]initWithFrame:CGRectMake(0, y+height, mainWidth, mainHeight-y-height)];
    
    NSArray *viewArray=[NSArray arrayWithObjects:upView,downView,leftView,rightView, nil];
    for (UIView *mView in viewArray) {
        view.backgroundColor=[UIColor colorWithRed:0 green:0 blue:0 alpha:0.5f];
        [view addSubview:mView];
    }
}

-(void)clear{
    resultLabel.text=@"";
}

//-(void)submit{
//    NSString *codeStr = resultLabel.text;
//    if (codeStr.length==0) {
//        codeStr=@"没有内容";
//    }
//    [self dismissViewControllerAnimated:YES completion:^{
//        [self.delegate scanResult:codeStr];
//    }];
//    
//}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    capture.delegate = self;
    [timer setFireDate:[NSDate distantPast]];
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    capture.delegate = nil;
    [timer setFireDate:[NSDate distantFuture]];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

-(NSUInteger)supportedInterfaceOrientations {
    
    // iPhone only
    if( [[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone )
        return UIInterfaceOrientationMaskPortrait;
    
    // iPad only
    return UIInterfaceOrientationMaskLandscape;
}

// Supported orientations. Customize it for your own needs
// Only valid on iOS 4 / 5. NOT VALID for iOS 6.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // iPhone only
    if( [[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone )
        return UIInterfaceOrientationIsPortrait(interfaceOrientation);
    
    // iPad only
    // iPhone only
    return UIInterfaceOrientationIsLandscape(interfaceOrientation);
}

#pragma mark -ZXCaptureDelegate

-(void)captureResult:(ZXCapture *)capture result:(ZXResult *)result{
    
    [SDLog logDebug:result.text];
    
    [resultLabel performSelectorOnMainThread:@selector(setText:) withObject:result.text waitUntilDone:YES];
}

- (void)popupInputAuthCodeView
{
    UIView *AuthCodeView = [[UIView alloc] init];
    AuthCodeView.frame = CGRectMake(20, viewSize.height / 2, viewSize.height - 2 * 20, 300);
    AuthCodeView.backgroundColor = [UIColor whiteColor];
    AuthCodeView.layer.cornerRadius = 10;
    AuthCodeView.layer.masksToBounds = YES;
    
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.text = @"请输入付款码";
    titleLabel.font = [UIFont systemFontOfSize:21 weight:2];
    titleLabel.textColor = [UIColor colorWithRed:(102/255.0) green:(102/255.0) blue:(102/255.0) alpha:1.0];
    [AuthCodeView addSubview:titleLabel];
    
    UIImageView *authCodeImageView = [[UIImageView alloc] init];
    UIImage *authCodeImage = [UIImage fullscreenAllIphoneImageWithName:@"login_input_ico_identifyingcode.png"];
    authCodeImageView.image = authCodeImage;
    authCodeImageView.contentMode = UIViewContentModeScaleAspectFit;
    [AuthCodeView addSubview:authCodeImageView];
    
    UITextField *authCodeTextFiled = [[UITextField alloc] init];
    authCodeTextFiled.placeholder = @"请输入条形码下方的18位付款码";
    authCodeTextFiled.textColor = [UIColor colorWithRed:(127/255.0) green:(127/255.0) blue:(127/255.0) alpha:1.0];
    authCodeTextFiled.font = [UIFont systemFontOfSize:15];
    [AuthCodeView addSubview:authCodeTextFiled];
    
    UIImageView *imageViewHorizaontal = [[UIImageView alloc] initWithImage:[UIImage fullscreenAllIphoneImageWithName:@"dividing_line.png"]];
    [AuthCodeView addSubview:imageViewHorizaontal];
    
    UIButton *surebtn =[[UIButton alloc] init];
    surebtn.tag = 2;
    [surebtn setTitle:@"收钱" forState:UIControlStateNormal];
    [surebtn setTintColor:[UIColor colorWithRed:(102/255.0) green:(102/255.0) blue:(102/255.0) alpha:1.0]];
    surebtn.titleLabel.font = [UIFont systemFontOfSize:21 weight:2];
    [surebtn setBackgroundImage:[UIImage imageNamed:@"bg_normal.png"] forState:UIControlStateNormal];
    [surebtn setBackgroundImage:[UIImage imageNamed:@"bg_highlighted.png"] forState:UIControlStateHighlighted];
    [surebtn addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
    [AuthCodeView addSubview:surebtn];
    
    UIImageView *imageViewVertical = [[UIImageView alloc] initWithImage:[UIImage fullscreenAllIphoneImageWithName:@"vertical_line.png"]];
    [AuthCodeView addSubview:imageViewVertical];
    
    UIButton *cancelbtn =[[UIButton alloc] init];
    cancelbtn.tag = 3;
    [cancelbtn setTitle:@"收钱" forState:UIControlStateNormal];
    [cancelbtn setTintColor:[UIColor colorWithRed:(102/255.0) green:(102/255.0) blue:(102/255.0) alpha:1.0]];
    cancelbtn.titleLabel.font = [UIFont systemFontOfSize:21 weight:2];
    [cancelbtn setBackgroundImage:[UIImage imageNamed:@"bg_normal.png"] forState:UIControlStateNormal];
    [cancelbtn setBackgroundImage:[UIImage imageNamed:@"bg_highlighted.png"] forState:UIControlStateHighlighted];
    [cancelbtn addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
    [AuthCodeView addSubview:cancelbtn];
    
    
    //设置组件的位置和大小
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(AuthCodeView).offset(20);
        make.centerX.equalTo(AuthCodeView);
    }];
    
    [authCodeImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(titleLabel.mas_bottom).offset(20);
        make.left.equalTo(AuthCodeView).offset(20);
    }];
    
    CGSize authCodeTextFiledTextSize = [authCodeTextFiled sizeThatFits:CGSizeMake(viewSize.width - 2 * 20 - 2 * 20 - 10 - authCodeImage.size.width, MAXFLOAT)];
    [authCodeTextFiled mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(titleLabel.mas_bottom).offset(20);
        make.left.equalTo(authCodeImageView.mas_right).offset(10);
        make.size.mas_equalTo(CGSizeMake(viewSize.width - 2 * 20 - 2 * 20 - 10 - authCodeImage.size.width, authCodeTextFiledTextSize.height));
    }];
    
    [imageViewHorizaontal mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(imageViewVertical.mas_top).offset(-20);
        make.left.equalTo(AuthCodeView).offset(0);
        make.size.mas_equalTo(CGSizeMake(viewSize.width - 2 * 20, 1));
    }];
    
    [imageViewVertical mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(AuthCodeView.mas_bottom).offset(0);
        make.centerX.equalTo(AuthCodeView).offset(0);
        make.size.mas_equalTo(CGSizeMake(1, 60));
    }];
    
    [surebtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(AuthCodeView.mas_bottom).offset(-10);
        make.left.equalTo(AuthCodeView).offset(10);
        make.size.mas_equalTo(CGSizeMake((viewSize.width - 2 * 20) / 2 - 2 * 10, 40));
    }];
    
    [cancelbtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(AuthCodeView.mas_bottom).offset(-10);
        make.left.equalTo(imageViewVertical.mas_right).offset(10);
        make.size.mas_equalTo(CGSizeMake((viewSize.width - 2 * 20) / 2 - 2 * 10, 40));
    }];
}

/**
 *@brief 添加按钮添加事件
 *@param view UIButton 参数：按钮
 *@param view tag 参数：按钮的类型
 *@return
 */
- (void)buttonAction:(id)sender
{
    UIButton *btn = (UIButton *)sender;
    switch (btn.tag) {
        case 1:
        {
            [self.navigationController popViewControllerAnimated:YES];
        }
            break;
        case 2:
        {
            [self.navigationController popViewControllerAnimated:YES];
        }
            break;
        case 3:
        {
            [self.navigationController popViewControllerAnimated:YES];
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


@end
