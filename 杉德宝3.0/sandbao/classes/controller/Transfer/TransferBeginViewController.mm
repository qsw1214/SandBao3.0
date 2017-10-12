//
//  Transfer BeginViewController.m
//  sandbao
//
//  Created by tianNanYiHao on 2017/3/23.
//  Copyright © 2017年 sand. All rights reserved.
//

#import "TransferBeginViewController.h"


#import "SDLog.h"
#import "CommParameter.h"
#import "SDCircleView.h"
#import "PayNucHelper.h"
#import "TransferChooseViewController.h"
#import "SDSqlite.h"
#import "SqliteHelper.h"
#import "AddressBookViewController.h"



#define navbarColor RGBA(242, 242, 242, 1.0)

#define navViewColor RGBA(255, 125, 50, 1.0)

#define lineViewColor RGBA(237, 237, 237, 1.0)

#define titleColor RGBA(174, 174, 174, 1.0)

#define textFiledColor RGBA(83, 83, 83, 1.0)

#define textFiledColordarkBlue RGBA(43, 56, 87, 1.0)

#define textFiledColorBlue  RGBA(65, 131, 215, 1.0)

#define textFiledColorlightGray RGBA(191, 195, 204, 1.0)

#define viewColor RGBA(255, 255, 255, 1.0)
@interface TransferBeginViewController ()<UITextFieldDelegate>
{
     NavCoverView *navCoverView;
     CGSize viewSize;
     CGFloat titleTextSize;
     CGFloat labelTextSize;
     CGFloat lineViewHeight;
     CGFloat leftRightSpace;
     CGFloat space;
     SDCircleView *circleView;
    
    UIScrollView *scrollView;
    
    NSArray *authToolsArrayOne; //getAuthTools 所返回的
    NSArray *authToolsArrayTwo;  //setAuthTools 所返回的
    
    CGFloat textFieldTextSize;
    CGFloat textSize;
    
    NSArray *ownPayToolsArr;   //我方支付工具集
    NSArray *otherPayToolsArr; //他方支付工具集
    NSDictionary *otherUserInfoDic; //他方用户信息
    
    NSMutableArray *typeArrOther;
    NSMutableArray *tyoeArrOwn;
    NSMutableArray *tempPayToolsTypeArr;
    
    
    //UI
    UILabel *barLabOne;
    UILabel *barLabTwo;
    UIButton *btnOne;
    UIButton *btnTwo;
    UITextField *phoneNumTextField;  //
    
    UIView *bgViewOne;
    UIView *bgViewTwo;
    UIButton *nextBtn;
    
}
@property (nonatomic, strong) SDMBProgressView *HUD;


@end


@implementation TransferBeginViewController
@synthesize HUD;


- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    [self load];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    //转账step1
    [self.view setBackgroundColor:RGBA(248, 248, 248, 1.0)];
    viewSize = self.view.bounds.size;
    leftRightSpace = 15;
    lineViewHeight = 1;
    space = 10;
    
    typeArrOther = [NSMutableArray arrayWithCapacity:0];
    tyoeArrOwn = [NSMutableArray arrayWithCapacity:0];
    tempPayToolsTypeArr = [NSMutableArray arrayWithCapacity:0];
    
    

    
    
    self.navigationController.navigationBarHidden = YES;
    [self settingNavigationBar];
    [self addView:self.view];
}
#pragma mark - 点击空白处隐藏键盘
/**
 点击空白处隐藏键盘
 @param touches
 @param event
 */
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self dismissKeyboard];
}
#pragma mark - 设置导航栏
/**
 *@brief 设置导航栏
 *@return
 */
- (void)settingNavigationBar
{
    //导航渐变条
    navCoverView = [NavCoverView shareNavCoverView:CGRectMake(0, 0, viewSize.width, controllerTop) title:@"转账"];
    [self.view addSubview:navCoverView];
    
    // 2.设置左边的返回item
    UIImage *leftImage = [UIImage imageNamed:@"back"];
    UIButton *leftBarBtn = [[UIButton alloc] init];
    leftBarBtn.frame = CGRectMake(0, 20 + (40 - leftImage.size.height) / 2, leftImage.size.width, leftImage.size.height);
    leftBarBtn.tag = 101;
    [leftBarBtn setImage:[UIImage imageNamed:@"back"] forState:UIControlStateNormal];
    [leftBarBtn setImage:[UIImage imageNamed:@"back"] forState:UIControlStateHighlighted];
    leftBarBtn.contentMode = UIViewContentModeScaleAspectFit;
    [leftBarBtn addTarget:self action:@selector(buttonActionToDoSomething:) forControlEvents:UIControlEventTouchUpInside];
    [navCoverView addSubview:leftBarBtn];
    
    
    // 3.设置右边的返回item
    UIImage *rightImage = [UIImage imageNamed:@"record"];
    UIButton *rightBarBtn = [[UIButton alloc] init];
    [rightBarBtn setImage:[UIImage imageNamed:@"record"] forState:UIControlStateNormal];
    [rightBarBtn setImage:[UIImage imageNamed:@"record"] forState:UIControlStateHighlighted];
    rightBarBtn.frame = CGRectMake(viewSize.width - 10 - rightImage.size.width, 20 + (40 - rightImage.size.height) / 2, rightImage.size.width, rightImage.size.height);
    rightBarBtn.tag = 102;
    rightBarBtn.contentMode = UIViewContentModeScaleAspectFit;
    [rightBarBtn addTarget:self action:@selector(buttonActionToDoSomething:) forControlEvents:UIControlEventTouchUpInside];
    [navCoverView addSubview:rightBarBtn];
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
    scrollView.contentSize = CGSizeMake(viewSize.width, viewSize.height - controllerTop);
    scrollView.directionalLockEnabled = YES; //只能一个方向滑动
    scrollView.pagingEnabled = NO; //是否翻页
    scrollView.showsVerticalScrollIndicator =YES; //垂直方向的滚动指示
    scrollView.indicatorStyle = UIScrollViewIndicatorStyleWhite;//滚动指示的风格
    scrollView.showsHorizontalScrollIndicator = NO;//水平方向的滚动指示
    [scrollView setBackgroundColor:navbarColor];
    scrollView.contentSize = CGSizeMake(viewSize.width, viewSize.height*1.5);
    [view addSubview:scrollView];
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    //chooseBtnBar
    UIView *bar = [[UIView alloc] init];
    bar.backgroundColor = [UIColor whiteColor];
    [scrollView addSubview:bar];
    
    barLabOne = [[UILabel alloc] init];
    barLabOne.text = @"账号转账";
    barLabOne.textColor = textFiledColorBlue;
    barLabOne.textAlignment = NSTextAlignmentCenter;
    barLabOne.font = [UIFont systemFontOfSize:textSize];
    [bar addSubview:barLabOne];
    
    btnOne = [[UIButton alloc] init];
    btnOne.selected  = YES;
    [btnOne addTarget:self action:@selector(AccToAccBtn:) forControlEvents:UIControlEventTouchUpInside];
    [bar addSubview:btnOne];
    
    barLabTwo = [[UILabel alloc] init];
    barLabTwo.text = @"扫码转账";
    barLabTwo.textColor = textFiledColorlightGray;
    barLabTwo.textAlignment = NSTextAlignmentCenter;
    barLabTwo.font = [UIFont systemFontOfSize:textSize];
    [bar addSubview:barLabTwo];
    
    btnTwo = [[UIButton alloc] init];
    [btnTwo addTarget:self action:@selector(SaoToAccBtn:) forControlEvents:UIControlEventTouchUpInside];
    [bar addSubview:btnTwo];

    
    //1.BG1
    bgViewOne = [[UIView alloc] init];
    bgViewOne.backgroundColor = navbarColor;
    [scrollView addSubview:bgViewOne];
    
    //1.1 textBgview
    UIView *textBgview = [[UIView alloc] init];
    textBgview.backgroundColor = [UIColor whiteColor];
    [bgViewOne addSubview:textBgview];
    
    //1.1.1 对方账户
    UILabel *otherAccLab = [[UILabel alloc] init];
    otherAccLab.text = @"对方账户";
    otherAccLab.font = [UIFont systemFontOfSize:textSize];
    otherAccLab.textColor = titleColor;
    [textBgview addSubview:otherAccLab];
    
    //1.1.2
    phoneNumTextField = [[UITextField alloc] init];
    phoneNumTextField.placeholder = @"杉德宝账户/手机号";
    phoneNumTextField.font = [UIFont systemFontOfSize:textSize];
    phoneNumTextField.textColor = textFiledColor;
    phoneNumTextField.tag = 1;
    phoneNumTextField.text = SHOWTOTEST(@"13636662403");
    [phoneNumTextField setMinLenght:@"0"];
    [phoneNumTextField setMaxLenght:@"11"];
    phoneNumTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    phoneNumTextField.tintColor = RGBA(199, 199, 199, 1.0);
    [textBgview addSubview:phoneNumTextField];
    
    //1.1.3 phoneBtn
    UIButton *phoneBtn = [[UIButton alloc] init];
    UIImage *phoneImage = [UIImage imageNamed:@"address_list"];
    CGSize phoneImageSize = CGSizeMake(phoneImage.size.width+space, phoneImage.size.height+space);
    [phoneBtn setImage:phoneImage forState:UIControlStateNormal];
    phoneBtn.tag = 301;
    [phoneBtn addTarget:self action:@selector(buttonActionToDoSomething:) forControlEvents:UIControlEventTouchUpInside];
    [textBgview addSubview:phoneBtn];
    
    //1.2 nextBtn
    nextBtn = [[UIButton alloc] init];
    [nextBtn setTag:302];
    [nextBtn setTitle:@"下一步" forState: UIControlStateNormal];
    [nextBtn setTitleColor:RGBA(255, 255, 255, 1.0) forState:UIControlStateNormal];
    nextBtn.titleLabel.font = [UIFont systemFontOfSize:textSize];
    nextBtn.userInteractionEnabled = NO;
    [nextBtn setBackgroundColor:RGBA(206, 209, 216, 1.0)];
    [nextBtn.layer setMasksToBounds:YES];
    nextBtn.layer.cornerRadius = 5.0;
    [nextBtn addTarget:self action:@selector(buttonActionToDoSomething:) forControlEvents:UIControlEventTouchUpInside];
    [bgViewOne addSubview:nextBtn];
    
    //1.3 tip
    UILabel *tipLab = [[UILabel alloc] init];
    tipLab.text = @"实时转入对方账户,无法退款";
    tipLab.font = [UIFont systemFontOfSize:textSize];
    tipLab.textColor = titleColor;
    [bgViewOne addSubview:tipLab];

    
    
    
    //2.BG2
    bgViewTwo = [[UIView alloc] init];
    bgViewTwo.backgroundColor = navbarColor;
    bgViewTwo.hidden = true;
    [scrollView addSubview:bgViewTwo];
    
    //2.1 headIcon
    UIImage *headIconImg = [UIImage imageNamed:@"profile_photo"];
    UIImageView *headIconImgV = [[UIImageView alloc] init];
    headIconImgV.image = headIconImg;
    headIconImgV.layer.cornerRadius = headIconImg.size.width/2;
    headIconImgV.layer.borderColor = RGBA(51, 165, 218, 1.0f).CGColor;
    headIconImgV.layer.borderWidth = 1.0f;
    headIconImgV.layer.masksToBounds = YES;
    
    [bgViewTwo addSubview:headIconImgV];
    //刷新头像数据
    NSString *str = [CommParameter sharedInstance].avatar;
    if (str==nil) {
        headIconImgV.image = [UIImage imageNamed:@"banaba_cot"];
    }else{
        UIImage *headimg = [Tool avatarImageWith:str];
        headIconImgV.image = headimg;
    }

    

    
    
    //2.2 nameTitleLab
    UILabel *nameTitleLab = [[UILabel alloc] init];
    if ([CommParameter sharedInstance].nick.length>0) {
        nameTitleLab.text = [CommParameter sharedInstance].nick;
    }else{
        nameTitleLab.text = @"我的杉德宝";
    }
    nameTitleLab.textColor = [UIColor darkTextColor];
    nameTitleLab.textAlignment = NSTextAlignmentLeft;
    nameTitleLab.font = [UIFont systemFontOfSize:textSize];
    [bgViewTwo addSubview:nameTitleLab];

    
    //2.3 qrcodeimageview
    UIImageView *qRCodeImgV = [[UIImageView alloc] init];
    [bgViewTwo addSubview:qRCodeImgV];
    
    
    
    //2.4 descriptionLab
    UILabel *descriptionLab = [[UILabel alloc] init];
    descriptionLab.text = @"扫一扫桌面上的二维码,即可转账";
    descriptionLab.textColor = titleColor;
    descriptionLab.textAlignment = NSTextAlignmentCenter;
    descriptionLab.font = [UIFont systemFontOfSize:textSize];
    [bgViewTwo addSubview:descriptionLab];
    
    
    
    
    
    
    
    
    CGFloat headImgVToTop = 35.0f;
    CGFloat headImgVToLeft = 42.0f;
    
    CGSize barLabTextSize = [TransferBeginViewController labelAutoCalculateRectWith:barLabOne.text Font:[UIFont systemFontOfSize:textSize] MaxSize:CGSizeMake(MAXFLOAT, MAXFLOAT)];
    CGSize tipLabSize = [TransferBeginViewController labelAutoCalculateRectWith:tipLab.text Font:[UIFont systemFontOfSize:textSize] MaxSize:CGSizeMake(MAXFLOAT, MAXFLOAT)];
    CGFloat barH = barLabTextSize.height + 2*space;
    CGSize bgViewOneSize = CGSizeMake(viewSize.width, viewSize.height - space - barH - controllerTop);
    
    CGSize otherAccLabSize = [TransferBeginViewController labelAutoCalculateRectWith:otherAccLab.text Font:[UIFont systemFontOfSize:textSize] MaxSize:CGSizeMake(MAXFLOAT, MAXFLOAT)];
    CGFloat textBgviewHeight = otherAccLabSize.height + 2*leftRightSpace;
    CGFloat commWidth = viewSize.width - 2 * leftRightSpace;
    CGFloat phoneTextfieldW = commWidth - otherAccLabSize.width - phoneImageSize.width - space;
    
    
    CGSize nameTitleLabSize = [nameTitleLab.text sizeWithNSStringFont:[UIFont systemFontOfSize:textSize]];
    CGSize descriptionLabSize = [descriptionLab.text sizeWithNSStringFont:[UIFont systemFontOfSize:textSize]];
    
    CGFloat nameTitleLabToleft = (viewSize.width - nameTitleLabSize.width - headIconImg.size.width - space)/2;
    CGFloat qrCodeImageVWH = viewSize.width - 2*headImgVToLeft;
    
    
    //生成二维码
    UIImage *qrimg = [Tool twoDimensionCodeWithStr:@"12345678" size:qrCodeImageVWH];
    qRCodeImgV.image = qrimg;
    
    
    
    
    
    
    
    
    
    [scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(view).offset(controllerTop);
        make.left.equalTo(view).offset(0);
        make.size.mas_equalTo(CGSizeMake(viewSize.width, viewSize.height-controllerTop));
    }];
    
    [bar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(navCoverView.mas_bottom).offset(0);
        make.left.equalTo(self.view.mas_left).offset(0);
        make.size.mas_equalTo(CGSizeMake(viewSize.width, barH));
    }];
    
    [barLabOne mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(bar).offset(0);
        make.left.equalTo(bar).offset(0);
        make.size.mas_equalTo(CGSizeMake(viewSize.width/2, barLabTextSize.height));
    }];
    [barLabTwo mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(bar).offset(0);
        make.right.equalTo(bar).offset(0);
        make.size.mas_equalTo(CGSizeMake(viewSize.width/2, barLabTextSize.height));
    }];
    
    [btnOne mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(bar).offset(0);
        make.left.equalTo(bar).offset(0);
        make.size.mas_equalTo(CGSizeMake(viewSize.width/2, barH));
    }];
    
    [btnTwo mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(bar).offset(0);
        make.right.equalTo(bar).offset(0);
        make.size.mas_equalTo(CGSizeMake(viewSize.width/2, barH));
    }];
    
    
    //转账方式 : 账号转账
    [bgViewOne mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(bar.mas_bottom).offset(space);
        make.left.equalTo(view).offset(0);
        make.size.mas_equalTo(bgViewOneSize);
    }];
    
    
    [textBgview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(bgViewOne).offset(0);
        make.left.equalTo(bgViewOne).offset(0);
        make.size.mas_equalTo(CGSizeMake(viewSize.width, textBgviewHeight));
    }];
    
    [otherAccLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(textBgview.mas_left).offset(leftRightSpace);
        make.centerY.equalTo(textBgview.mas_centerY);
        make.size.mas_equalTo(otherAccLabSize);
    }];
    
    [phoneNumTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(otherAccLab.mas_right).offset(space);
        make.centerY.equalTo(textBgview.mas_centerY);
        make.size.mas_equalTo(CGSizeMake(phoneTextfieldW, otherAccLabSize.height));
    }];
    
    [phoneBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(textBgview.mas_centerY);
        make.left.equalTo(phoneNumTextField.mas_right).offset(0);
        make.size.mas_equalTo(CGSizeMake(phoneImageSize.width, phoneImageSize.height));
    }];
    
    [nextBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(bgViewOne).offset(leftRightSpace);
        make.top.equalTo(textBgview.mas_bottom).offset(60);
        make.size.mas_equalTo(CGSizeMake(commWidth, textBgviewHeight));
    }];
    
    [tipLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(nextBtn.mas_bottom).offset(space);
        make.centerX.equalTo(bgViewOne);
        make.size.mas_equalTo(tipLabSize);
    }];
    
    
    
    //转账方式 : 扫码转账
    [bgViewTwo mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(bar.mas_bottom).offset(space);
        make.left.equalTo(view).offset(0);
        make.size.mas_equalTo(bgViewOneSize);
    }];
    
    [headIconImgV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(bgViewTwo.mas_top).offset(headImgVToTop);
        make.left.equalTo(bgViewTwo.mas_left).offset(nameTitleLabToleft);
        make.size.mas_equalTo(headIconImg.size);
    }];
    
    [nameTitleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(headIconImgV.mas_top).offset(space/2);
        make.left.equalTo(headIconImgV.mas_right).offset(space);
        make.size.mas_equalTo(nameTitleLabSize);
        
    }];
    
    [qRCodeImgV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(headIconImgV.mas_bottom).offset(leftRightSpace*2);
        make.left.equalTo(bgViewTwo.mas_left).offset(headImgVToLeft);
        make.size.mas_equalTo(CGSizeMake(qrCodeImageVWH, qrCodeImageVWH));
        
    }];
    
    [descriptionLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(qRCodeImgV.mas_bottom).offset(leftRightSpace*2);
        make.centerX.equalTo(bgViewTwo.mas_centerX);
        make.size.mas_equalTo(descriptionLabSize);
        
    }];

    
    [self setInputResponderChain];
    [self listenNotifier];
}





#pragma mark - 业务逻辑f

/**
 *@brief 鉴权
 */
- (void)load
{
    HUD = [SDMBProgressView showSDMBProgressOnlyLoadingINViewImg:self.view];
    [SDRequestHelp shareSDRequest].HUD = HUD;
    [SDRequestHelp shareSDRequest].controller = self;
    [[SDRequestHelp shareSDRequest] dispatchGlobalQuque:^{
        __block BOOL error = NO;
        paynuc.set("tTokenType", "02000401");
        [[SDRequestHelp shareSDRequest] requestWihtFuncName:@"token/getTtoken/v1" errorBlock:^(SDRequestErrorType type) {
            error = YES;
        } successBlock:^{
            
        }];
        if (error) return ;
        

        [[SDRequestHelp shareSDRequest] requestWihtFuncName:@"authTool/getAuthTools/v1" errorBlock:^(SDRequestErrorType type) {
            error = YES;
        } successBlock:^{
            NSString *tempAuthTools = [NSString stringWithUTF8String:paynuc.get("authTools").c_str()];
            authToolsArrayOne = [[PayNucHelper sharedInstance] jsonStringToArray:tempAuthTools];
        }];
        if (error) return ;

        
        NSString *authToolsStr = [[PayNucHelper sharedInstance] arrayToJSON:(NSMutableArray*)authToolsArrayOne];
        paynuc.set("authTools", [authToolsStr UTF8String]);
        [[SDRequestHelp shareSDRequest] requestWihtFuncName:@"authTool/setAuthTools/v1" errorBlock:^(SDRequestErrorType type) {
            error = YES;
        } successBlock:^{
            [[SDRequestHelp shareSDRequest] dispatchToMainQueue:^{
                [HUD hidden];
                
                NSString *tempAuthTools = [NSString stringWithUTF8String:paynuc.get("authTools").c_str()];
                authToolsArrayTwo = [[PayNucHelper sharedInstance] jsonStringToArray:tempAuthTools];
            }];
        }];
        if (error) return ;
    }];
}



/**
 *@brief 获取他方/我方支付工具
 */
- (void)getOtherAndOwnPayTools{
    HUD = [SDMBProgressView showSDMBProgressOnlyLoadingINViewImg:self.view];
    [SDRequestHelp shareSDRequest].HUD = HUD;
    [SDRequestHelp shareSDRequest].controller = self;
    [[SDRequestHelp shareSDRequest] dispatchGlobalQuque:^{
        __block BOOL error = NO;
        
        NSMutableDictionary *userInfoDic = [[NSMutableDictionary alloc] init];
        [userInfoDic setObject:phoneNumTextField.text forKey:@"userName"];
        paynuc.set("userInfo", [[[PayNucHelper sharedInstance] dictionaryToJson:userInfoDic] UTF8String]);
        NSString *authToolsStr = [[PayNucHelper sharedInstance] arrayToJSON:(NSMutableArray*)authToolsArrayTwo];
        paynuc.set("authTools", [authToolsStr UTF8String]);
        [[SDRequestHelp shareSDRequest] requestWihtFuncName:@"payTool/getOtherPayTools/v1" errorBlock:^(SDRequestErrorType type) {
            error = YES;
        } successBlock:^{
            [[SDRequestHelp shareSDRequest] dispatchToMainQueue:^{
                //获取他方用户信息/支付工具集  (userInfo / payTools)
                NSString *userInfoStr = [NSString stringWithUTF8String:paynuc.get("userInfo").c_str()];
                NSDictionary *userInfoDic = [[PayNucHelper sharedInstance] jsonStringToDictionary:userInfoStr];
                NSString *payToolsStr = [NSString stringWithUTF8String:paynuc.get("payTools").c_str()];
                NSArray *payToolsArr = [[PayNucHelper sharedInstance] jsonStringToArray:payToolsStr];
                //检测发现不能排序
                payToolsArr = [Tool orderForPayTools:payToolsArr];
                otherUserInfoDic = userInfoDic;
                otherPayToolsArr = payToolsArr;
                
                //0.清空
                if (tyoeArrOwn.count>0 || typeArrOther.count>0) {
                    [tyoeArrOwn removeAllObjects];
                    [typeArrOther removeAllObjects];
                }
                for (int i = 0; i<otherPayToolsArr.count; i++) {
                    NSString *typeStr = [otherPayToolsArr[i] objectForKey:@"type"];
                    [typeArrOther addObject:typeStr];
                }

            }];
        }];
        if (error) return ;
        
        
        paynuc.set("payToolKinds", "[]");
        [[SDRequestHelp shareSDRequest] requestWihtFuncName:@"payTool/getOwnPayTools/v1" errorBlock:^(SDRequestErrorType type) {
            error = YES;
        } successBlock:^{
            [[SDRequestHelp shareSDRequest] dispatchToMainQueue:^{
                [HUD hidden];
                
                
                //1.获取我方支付工具集  (payTools)
                NSString *payToolsStr = [NSString stringWithUTF8String:paynuc.get("payTools").c_str()];
                ownPayToolsArr = [[PayNucHelper sharedInstance] jsonStringToArray:payToolsStr];
                //排序
                ownPayToolsArr = [Tool orderForPayTools:ownPayToolsArr];
                for (int i=0; i<ownPayToolsArr.count; i++) {
                    NSString *typeStr = [ownPayToolsArr[i] objectForKey:@"type"];
                    [tyoeArrOwn addObject:typeStr];
                }
                
                //清空交集
                if (tempPayToolsTypeArr.count>0) {
                    [tempPayToolsTypeArr removeAllObjects];
                }
                //2.交集comper  用他方对比我方(数组顺序按照他方支付工具顺序)
                for (int i = 0; i<typeArrOther.count; i++) {
                    NSString *typeOtherStr = typeArrOther[i];
                    
                    for (int j = 0; j<tyoeArrOwn.count; j++) {
                        NSString *typeOwnStr = tyoeArrOwn[j];
                        
                        if ([typeOtherStr isEqualToString:typeOwnStr]) {
                            [tempPayToolsTypeArr addObject:typeOwnStr];
                        }
                        
                    }
                }
                if (tempPayToolsTypeArr.count == 0) {
                    //支付工具交集为0
                    [Tool showDialog:@"暂无可用转账方式" defulBlock:^{
                        [self.navigationController popViewControllerAnimated:YES];
                        return ;
                    }];
                }
                
                //3.获取转入可用支付工具集
                NSMutableArray *inpayToolay = [NSMutableArray arrayWithCapacity:0];
                for (int a = 0; a<otherPayToolsArr.count; a++) {
                    NSString *typeStr = [otherPayToolsArr[a] objectForKey:@"type"];
                    
                    for (int b = 0; b<tempPayToolsTypeArr.count; b++) {
                        NSString *typeYES = tempPayToolsTypeArr[b];
                        if ([typeStr isEqualToString:typeYES]) {
                            NSDictionary *dictPayTools = otherPayToolsArr[a];
                            [inpayToolay addObject:dictPayTools];
                        }
                    }
                }
                //4.获取转出可用支付工具集
                NSMutableArray *outpayToolay = [NSMutableArray arrayWithCapacity:0];
                for (int a = 0; a<ownPayToolsArr.count; a++) {
                    NSString *typeStr = [ownPayToolsArr[a] objectForKey:@"type"];
                    
                    for (int b = 0; b<tempPayToolsTypeArr.count; b++) {
                        NSString *typeYES = tempPayToolsTypeArr[b];
                        if ([typeStr isEqualToString:typeYES]) {
                            NSDictionary *dictPayTools = ownPayToolsArr[a];
                            [outpayToolay addObject:dictPayTools];
                        }
                    }
                }
                
                
                TransferChooseViewController *vc = [[TransferChooseViewController alloc] init];
                vc.otherUserInfoDic = otherUserInfoDic;
                vc.inpayToolsArr = inpayToolay;
                vc.outpayToolsArr = outpayToolay;
                [self.navigationController pushViewController:vc animated:YES];
                

            }];
        }];
        if (error) return ;
    }];

}



#pragma mark - UITextFieldDelegate

/**
 *当用户按下return键或者按回车键，我们注销KeyBoard响应，它会自动调用textFieldDidEndEditing函数
 */
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (textField.returnKeyType == UIReturnKeyDone) {
        [self dismissKeyboard];
    }
    
    return [self setNextResponder:textField] ? NO : YES;
}
/**
 *@brief 设置输入框响应
 *@param UITextField textField 参数：输入框
 *@return Bool
 */
- (BOOL)setNextResponder:(UITextField *)textField {
    
    NSArray *textFields = [self allInputFields];
    NSInteger indexOfInput = [textFields indexOfObject:textField];
    if (indexOfInput != NSNotFound && indexOfInput < textFields.count - 1) {
        UIResponder *next = [textFields objectAtIndex:(NSUInteger)(indexOfInput + 1)];
        if ([next canBecomeFirstResponder]) {
            [next becomeFirstResponder];
            return YES;
        }
    }
    return NO;
}
/**
 *@brief 为所有的输入框设置键盘类型
 */
- (void)setInputResponderChain {
    
    NSArray *textFields = [self allInputFields];
    for (UIResponder *responder in textFields) {
        if ([responder isKindOfClass:[UITextField class]]) {
            UITextField *textField = (UITextField *)responder;
            textField.returnKeyType = UIReturnKeyNext;
            textField.autocorrectionType = UITextAutocorrectionTypeNo;
            textField.delegate = self;
        }
    }
    phoneNumTextField.keyboardType = UIKeyboardTypeNumberPad;
    phoneNumTextField.returnKeyType = UIReturnKeyDone;
    
}
#pragma mark - 把所有的输入框放到数组中
/**
 *@brief 把所有的输入框放到数组中
 *@return NSArray
 */
- (NSArray *)allInputFields {
   return @[phoneNumTextField];
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
            [self.navigationController popViewControllerAnimated:YES];
        }
            break;
        case 102:
        {
            [Tool showDialog:@"哎呀,功能还在开发中..."];
        }
            break;
        case 301:  //左侧phoneBtn
        {
            AddressBookViewController *addressBook = [[AddressBookViewController alloc] init];
            
            //须回到主线程更新UI
            [addressBook getPhoneNumBlock:^(NSString *phoneNumber) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    phoneNumTextField.text = phoneNumber;
                    [self changeBtnBackGround:@"yes" index:1];
                });
            }];
            
            [self.navigationController pushViewController:addressBook animated:YES];
            
        }
            break;
        case 302:  //nextBtn
        {
            [self dismissKeyboard];
            [self verificationInput];
        }
            break;
        default:
            break;
    }
}

/**
 *@brief 输入数据验证
 */
- (void)verificationInput
{
    if (phoneNumTextField.text.length != [phoneNumTextField.maxLenght intValue] || ![NSRegularExpression validateMobile:phoneNumTextField.text] ) {
        return [Tool showDialog:@"输入的手机号码格式不正确，请重新输入。"];
    }
    
    
    //过滤向自己转账
    NSString *userName = [SDSqlite selectStringData:[SqliteHelper shareSqliteHelper].sandBaoDB tableName:@"usersconfig" columnName:@"userName" whereColumnString:@"uid" whereParamString:[CommParameter sharedInstance].userId];
    if ([userName isEqualToString:phoneNumTextField.text]) {
        [Tool showDialog:@"转账对象不能为自己哦!"];
    }else{
        
        [self getOtherAndOwnPayTools];
       
    }

}

#pragma mark - 监听通知
- (void)listenNotifier
{
    if (phoneNumTextField) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFiledEditChanged:) name:UITextFieldTextDidChangeNotification object:phoneNumTextField];
    }
}
- (void)textFiledEditChanged:(NSNotification *)obj
{
    UITextField *textField = (UITextField *)obj.object;
    NSString *content = textField.text;
    
    int maxLenght = [textField.maxLenght intValue];
    NSInteger lenght = content.length;
    
    if(maxLenght > 0) {
        // 键盘输入模式
        NSArray *currentar = [UITextInputMode activeInputModes];
        UITextInputMode *current = [currentar firstObject];
        NSString *lang = [current primaryLanguage];
        // 简体中文输入，包括简体拼音，健体五笔，简体手写
        if ([lang isEqualToString:@"zh-Hans"]) {
            UITextRange *selectedRange = [textField markedTextRange];
            //获取高亮部分
            UITextPosition *position = [textField positionFromPosition:selectedRange.start offset:0];
            // 没有高亮选择的字，则对已输入的文字进行字数统计和限制
            if (!position) {
                if (lenght > maxLenght) {
                    textField.text = [content substringToIndex:maxLenght];
                }
            }
            // 有高亮选择的字符串，则暂不对文字进行统计和限制
        } else {
            if (lenght > maxLenght) {
                textField.text = [content substringToIndex:maxLenght];
            }
        }
        
        if ([NSRegularExpression validateSpecialBlankChar:[content substringWithRange:NSMakeRange(lenght - 1, 1)]]) {
            [self dismissKeyboard];
            //[Tool showDialog:@"不能输入空格符"];
            textField.text = [content substringWithRange:NSMakeRange(0, lenght - 1)];
            return;
        }
        if (textField.tag == 1) {
            if (![NSRegularExpression validatePureNum:[content substringWithRange:NSMakeRange(lenght-1, 1)]]) {
                [self dismissKeyboard];
                [Tool showDialog:@"请输入0-9的数字"];
                textField.text = nil;
            }
        }
    }
    
    [self textFiledEditChanged];
    
}

- (void)textFiledEditChanged
{
    if (phoneNumTextField) {
        if ([@"" isEqualToString:phoneNumTextField.text] || phoneNumTextField.text == nil) {
            return [self changeBtnBackGround:nil index:2];
        }else {
            [self changeBtnBackGround:@"yes" index:1];

        }
    }
}
#pragma mark - 限制键盘输入某些字符
-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    
    if ([textField.placeholder rangeOfString:@"手机号"].location !=NSNotFound) {
        return [self restrictionwithTypeStr:OnlyNumberVerifi string:string];
    }
    if ([textField.placeholder rangeOfString:@"密码"].location !=NSNotFound) {
        return [self restrictionwithTypeStr:OnlyNum_letterVerifi string:string];
    }
    if ([textField.placeholder rangeOfString:@"数字验证码"].location !=NSNotFound) {
        return [self restrictionwithTypeStr:OnlyNumberVerifi string:string];
    }
    return YES;
    
}
-(BOOL)restrictionwithTypeStr:(NSString*)typeStr string:(NSString*)string{
    NSCharacterSet *cs = [[NSCharacterSet characterSetWithCharactersInString:typeStr] invertedSet];
    NSString *filtered = [[string componentsSeparatedByCharactersInSet:cs] componentsJoinedByString:@""];
    if ([string isEqualToString:@""]) { //不过滤回退键
        return YES;
    }
    if ([string isEqualToString:filtered]) {
        return YES;
    }else{
        return NO;  //过滤
    }
}
#pragma mark - 改变按钮背景图片
/**
 *@brief  改变按钮背景图片
 *@param param NSString 参数：字符串
 *@return
 */
- (void)changeBtnBackGround:(NSString *)param index:(int)index
{
    if (index == 1) {
        if (![@"" isEqualToString:param] && param != nil) {
            [nextBtn setTitleColor:RGBA(255, 255, 255, 1.0) forState:UIControlStateNormal];
            nextBtn.userInteractionEnabled = YES;
            [nextBtn setBackgroundColor:RGBA(65, 131, 215, 1.0)];
            nextBtn.userInteractionEnabled = YES;
        }
    }else{
        [nextBtn setTitleColor:RGBA(255, 255, 255, 1.0) forState:UIControlStateNormal];
        [nextBtn setBackgroundColor:RGBA(206, 209, 216, 1.0)];
        nextBtn.userInteractionEnabled = NO;
    }
}


/**
 *@brief 隐藏键盘
 */
- (void)dismissKeyboard {
    //将视图的Y坐标向上移动offset个单位，以使下面腾出地方用于软键盘的显示
    [scrollView setContentOffset:CGPointMake(0.0f, 0.0f) animated:YES] ;
    [self.view endEditing:YES];
}

-(void)AccToAccBtn:(UIButton*)btn{
     [self dismissKeyboard];
    if (btnOne.selected) {
        barLabTwo.textColor = textFiledColorlightGray;
        barLabOne.textColor = textFiledColorBlue;
        btnTwo.selected = NO;
        bgViewTwo.hidden = YES;
    }else{
        barLabTwo.textColor = textFiledColorlightGray;
        barLabOne.textColor = textFiledColorBlue;
        btnOne.selected = YES;
        bgViewOne.hidden = NO;
    }
    
}
-(void)SaoToAccBtn:(UIButton*)btn{
     [self dismissKeyboard];
    [Tool showDialog:@"哎呀,功能还在开发中..."];
    return;
    if (btnTwo.selected) {
        barLabOne.textColor = textFiledColorlightGray;
        barLabTwo.textColor = textFiledColorBlue;
        btnOne.selected = NO;
        bgViewOne.hidden = YES;
    }else{
        barLabOne.textColor = textFiledColorlightGray;
        barLabTwo.textColor = textFiledColorBlue;
        btnTwo.selected = YES;
        bgViewTwo.hidden = NO;
    }
    
}


+ (CGSize)labelAutoCalculateRectWith:(NSString*)text Font:(UIFont*)font MaxSize:(CGSize)maxSize
{
    NSMutableParagraphStyle* paragraphStyle = [[NSMutableParagraphStyle alloc]init];
    paragraphStyle.lineBreakMode=NSLineBreakByWordWrapping;
    NSDictionary* attributes = @{NSFontAttributeName:font,NSParagraphStyleAttributeName:paragraphStyle.copy};
    CGSize labelSize = [text boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading|NSStringDrawingTruncatesLastVisibleLine attributes:attributes context: nil ].size;
    labelSize.height=ceil(labelSize.height);
    labelSize.width=ceil(labelSize.width);
    return  labelSize;
}

@end
