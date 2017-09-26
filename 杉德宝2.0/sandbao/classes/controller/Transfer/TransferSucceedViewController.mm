//
//  Transfer BeginViewController.m
//  sandbao
//
//  Created by tianNanYiHao on 2017/3/23.
//  Copyright © 2017年 sand. All rights reserved.
//

#import "TransferSucceedViewController.h"


#import "SDLog.h"
#import "CommParameter.h"
#import "SDCircleView.h"
#import "PayNucHelper.h"
#import "TransferTableViewCell.h"


#define navbarColor RGBA(242, 242, 242, 1.0)

#define navViewColor RGBA(255, 125, 50, 1.0)

#define lineViewColor RGBA(237, 237, 237, 1.0)

#define titleColor RGBA(174, 174, 174, 1.0)

#define textFiledColor RGBA(83, 83, 83, 1.0)

#define textFiledColordarkBlue RGBA(43, 56, 87, 1.0)

#define textFiledColorBlue  RGBA(65, 131, 215, 1.0)

#define textFiledColorlightGray RGBA(191, 195, 204, 1.0)

#define viewColor RGBA(255, 255, 255, 1.0)
@interface TransferSucceedViewController ()<UITextFieldDelegate>
{
     NavCoverView *navCoverView;
     CGSize viewSize;
     CGFloat titleTextSize;
     CGFloat describeSize;
     CGFloat successSize;
     CGFloat labelTextSize;
     CGFloat lineViewHeight;
     CGFloat leftRightSpace;
     SDCircleView *circleView;
    

    UIScrollView *scrollView;
    NSArray *authToolsArray;
    
    CGFloat textSize;
    CGFloat moneySize;
    
    NSMutableDictionary *workDicGet;

    UIButton *nextBtn;

    UITextField *cashTextfield;
    
    
    NSString *inPayToolstr;
    NSDictionary *outPayTool;
    
}
@property (nonatomic, strong) SDMBProgressView *HUD;

@end


@implementation TransferSucceedViewController
@synthesize HUD;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //转账step1
    [self.view setBackgroundColor:RGBA(248, 248, 248, 1.0)];
    viewSize = self.view.bounds.size;
    leftRightSpace = 15;
    lineViewHeight = 1;
    workDicGet = [NSMutableDictionary dictionaryWithCapacity:0];
    
    self.navigationController.navigationBarHidden = YES;
    
    
    [self addView:self.view];
    [self settingNavigationBar];
    [self ownPayTools];
    
}

#pragma mark - 设置导航栏
/**
 *@brief 设置导航栏
 *@return
 */
- (void)settingNavigationBar
{
    //导航渐变条
    navCoverView = [NavCoverView shareNavCoverView:CGRectMake(0, 0, viewSize.width, controllerTop) title:@"转账成功"];
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
//    [navCoverView addSubview:leftBarBtn];
    
    
    // 3.设置右边的返回item
    UILabel *rightLab = [[UILabel alloc] init];
    rightLab.textColor = [UIColor whiteColor];
    rightLab.textAlignment = NSTextAlignmentRight;
    rightLab.font = [UIFont systemFontOfSize:textSize];
    rightLab.text = @"完成";
    [self.view addSubview:rightLab];
    
    UIButton *rightBarBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    [rightBarBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    rightBarBtn.tag = 102;
    [rightBarBtn addTarget:self action:@selector(buttonActionToDoSomething:) forControlEvents:UIControlEventTouchUpInside];
    CGSize size= [@"完成" sizeWithNSStringFont:[UIFont systemFontOfSize:textSize]];
    rightBarBtn.contentMode = UIViewContentModeScaleAspectFit;
    [self.view addSubview:rightBarBtn];
    
    [rightLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).offset(20+leftRightSpace);
        make.right.equalTo(self.view.mas_right).offset(-leftRightSpace);
        make.size.mas_equalTo(CGSizeMake(size.width, size.height));
    }];
    
    [rightBarBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).offset(20+leftRightSpace);
        make.right.equalTo(self.view.mas_right).offset(-leftRightSpace);
        make.size.mas_equalTo(CGSizeMake(size.width, size.height));
    }];
}



                   
#pragma mark - 创建组件
/**
 *@brief 创建组件
 *@param view UIView 参数：组件
 *@return
 */
-(void)addView:(UIView *)view
{

        describeSize = 11;
        successSize = 16;
        textSize = 14;
        titleTextSize = 14;
        moneySize = 39;


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
    [view addSubview:scrollView];
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    //viewbg
    UIView *bgView = [[UIView alloc] init];
    bgView.backgroundColor = [UIColor whiteColor];
    [scrollView addSubview:bgView];
    
    
    //titleBgView
    UIView *titleBgView = [[UIView alloc] init];
    titleBgView.backgroundColor = [UIColor whiteColor];
    [bgView addSubview:titleBgView];

    //iconImageV
    UIImage *icon = [UIImage imageNamed:@"my_account_profile"];
    UIImageView *imagHeadView = [[UIImageView alloc] init];
    imagHeadView.image = icon;
    [titleBgView addSubview:imagHeadView];
    
    //titleLab
    UILabel *titleLab = [[UILabel alloc] init];
    titleLab.text = _otherPayInfoName;
    titleLab.textColor = [UIColor blackColor];
    titleLab.font = [UIFont systemFontOfSize:titleTextSize];
    [titleBgView addSubview:titleLab];
    
    //describtLab
    UILabel *describtLab = [[UILabel alloc] init];
    describtLab.text = _otherPayDescribeNum;
    describtLab.textColor = titleColor;
    describtLab.font = [UIFont systemFontOfSize:describeSize];
    [titleBgView addSubview:describtLab];

    
    //moneyLab
    UILabel *moneyLab = [[UILabel alloc] init];
    moneyLab.text = _moneyStr;
    moneyLab.textColor = [UIColor blackColor];
    moneyLab.font = [UIFont systemFontOfSize:moneySize];
    [bgView addSubview:moneyLab];
    
    //转账成功 successLab
    UILabel *successLab = [[UILabel alloc] init];
    successLab.text = @"转账成功";
    successLab.textColor = textFiledColorBlue;
    successLab.font = [UIFont systemFontOfSize:successSize];
    [bgView addSubview:successLab];
    
    

    //line
    UIView *line= [[UIView alloc] init];
    line.backgroundColor = [UIColor lightGrayColor];
    [bgView addSubview:line];
    
    
    
    
    
    
    //payInfoBgview
    UIView *payInfoBgview= [[UIView alloc] init];
    payInfoBgview.backgroundColor = [UIColor whiteColor];
    [bgView addSubview:payInfoBgview];
    
    //付款信息 payInfoLab
    UILabel *payInfoLab = [[UILabel alloc] init];
    payInfoLab.text = @"付款信息";
    payInfoLab.textColor = titleColor;
    payInfoLab.font = [UIFont systemFontOfSize:titleTextSize];
    [payInfoBgview addSubview:payInfoLab];
    
    //showPayInfoLab
    UILabel *showPayInfoLab = [[UILabel alloc] init];
    showPayInfoLab.text = _payDescribeStr;
    showPayInfoLab.textColor = titleColor;
    showPayInfoLab.font = [UIFont systemFontOfSize:titleTextSize];
    [payInfoBgview addSubview:showPayInfoLab];
    
    //littleMoneyLab
    UILabel *littleMoneyLab = [[UILabel alloc] init];
    littleMoneyLab.text = [NSString stringWithFormat:@"-%@",_moneyStr];
    littleMoneyLab.textColor = titleColor;
    littleMoneyLab.textAlignment = NSTextAlignmentRight;
    littleMoneyLab.font = [UIFont systemFontOfSize:titleTextSize];
    [payInfoBgview addSubview:littleMoneyLab];
    

    
    
    
    //设置控件的位置和大小
    CGFloat space = 10.0;
    CGFloat topSpace = 28;
    CGFloat bottomSpace = 39.5;
    CGFloat commWidth = viewSize.width - 2 * leftRightSpace;
    
    CGSize titleLabSize = [TransferSucceedViewController labelAutoCalculateRectWith:titleLab.text Font:[UIFont systemFontOfSize:titleTextSize] MaxSize:CGSizeMake(CGFLOAT_MAX, CGFLOAT_MAX)];
    CGSize describtLabSize = [TransferSucceedViewController labelAutoCalculateRectWith:describtLab.text Font:[UIFont systemFontOfSize:describeSize] MaxSize:CGSizeMake(CGFLOAT_MAX, CGFLOAT_MAX)];
    CGSize moneyLabSize = [TransferSucceedViewController labelAutoCalculateRectWith:moneyLab.text Font:[UIFont systemFontOfSize:moneySize] MaxSize:CGSizeMake(CGFLOAT_MAX, CGFLOAT_MAX)];
    CGSize successLabSize = [TransferSucceedViewController labelAutoCalculateRectWith:successLab.text Font:[UIFont systemFontOfSize:successSize] MaxSize:CGSizeMake(CGFLOAT_MAX, CGFLOAT_MAX)];
    CGSize payInfoLabSize = [TransferSucceedViewController labelAutoCalculateRectWith:payInfoLab.text Font:[UIFont systemFontOfSize:titleTextSize] MaxSize:CGSizeMake(CGFLOAT_MAX, CGFLOAT_MAX)];
    CGSize showPayInfoLabSize = [TransferSucceedViewController labelAutoCalculateRectWith:showPayInfoLab.text Font:[UIFont systemFontOfSize:titleTextSize] MaxSize:CGSizeMake(CGFLOAT_MAX, CGFLOAT_MAX)];

    CGFloat littleMoneyLabW = commWidth - space - payInfoLabSize.width - showPayInfoLabSize.width;
    
    CGSize titleBgViewSize = CGSizeMake(icon.size.width+space+titleLabSize.width, icon.size.height);
    
    CGFloat payInfoBgviewH = payInfoLabSize.height+2*leftRightSpace;
    
    CGFloat bgViewH = topSpace + titleBgViewSize.height + topSpace + moneyLabSize.height + space + successLabSize.height + bottomSpace + payInfoBgviewH;
    

    
    
    [scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(view).offset(controllerTop);
        make.left.equalTo(view).offset(0);
        make.size.mas_equalTo(CGSizeMake(viewSize.width, viewSize.height-controllerTop));
    }];
    
    [bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(scrollView).offset(0);
        make.size.mas_equalTo(CGSizeMake(viewSize.width, bgViewH));
    }];
    
    [titleBgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(bgView.mas_top).offset(topSpace);
        make.centerX.equalTo(bgView.mas_centerX).offset(0);
        make.size.mas_equalTo(titleBgViewSize);
    }];
    
    [imagHeadView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(titleBgView).offset(0);
        make.left.equalTo(titleBgView).offset(0);
        make.size.mas_equalTo(CGSizeMake(icon.size.width, icon.size.height));
    }];
    
    [titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(titleBgView).offset(0);
        make.left.equalTo(imagHeadView.mas_right).offset(space);
        make.size.mas_equalTo(titleLabSize);
    }];
    
    [describtLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(imagHeadView.mas_right).offset(space);
        make.bottom.equalTo(imagHeadView.mas_bottom).offset(0);
        make.size.mas_equalTo(describtLabSize);
    }];

    [moneyLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(titleBgView.mas_bottom).offset(bottomSpace);
        make.centerX.equalTo(bgView.mas_centerX).offset(0);
        make.size.mas_equalTo(moneyLabSize);
    }];
    
    [successLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(moneyLab.mas_bottom).offset(space);
        make.centerX.equalTo(bgView.mas_centerX).offset(0);
        make.size.mas_equalTo(successLabSize);
    }];
    
    [payInfoBgview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(successLab.mas_bottom).offset(bottomSpace);
        make.left.equalTo(bgView).offset(0);
        make.size.mas_equalTo(CGSizeMake(viewSize.width, payInfoBgviewH));
    }];
    
    [payInfoLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(payInfoBgview).offset(leftRightSpace);
        make.centerY.equalTo(payInfoBgview.mas_centerY).offset(0);
        make.size.mas_equalTo(payInfoLabSize);
    }];
    
    [showPayInfoLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(payInfoBgview.mas_centerY).offset(0);
        make.left.equalTo(payInfoLab.mas_right).offset(space);
        make.size.mas_equalTo(CGSizeMake(showPayInfoLabSize.width, showPayInfoLabSize.height));
    }];
    
    [littleMoneyLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(payInfoBgview.mas_centerY).offset(0);
        make.right.equalTo(payInfoBgview.mas_right).offset(-leftRightSpace);
        make.size.mas_equalTo(CGSizeMake(littleMoneyLabW, showPayInfoLabSize.height));
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
        case 102:
        {
            [self.navigationController popToRootViewControllerAnimated:YES];
        }
            break;
        case 302:
        {

        }
            break;
        default:
            break;
    }
}
/**
 *@brief 查询信息
 */
- (void)ownPayTools
{
    HUD = [SDMBProgressView showSDMBProgressOnlyLoadingINViewImg:self.view];
    [SDRequestHelp shareSDRequest].HUD = HUD;
    [SDRequestHelp shareSDRequest].controller = self;
    [[SDRequestHelp shareSDRequest] dispatchGlobalQuque:^{
        __block BOOL error = NO;
        paynuc.set("tTokenType", "01001501");
        [[SDRequestHelp shareSDRequest] requestWihtFuncName:@"token/getTtoken/v1" errorBlock:^(SDRequestErrorType type) {
            error = YES;
        } successBlock:^{
            
        }];
        if (error) return ;
        
        
        paynuc.set("payToolKinds", "[]");
        [[SDRequestHelp shareSDRequest] requestWihtFuncName:@"payTool/getOwnPayTools/v1" errorBlock:^(SDRequestErrorType type) {
            error = YES;
        } successBlock:^{
            [[SDRequestHelp shareSDRequest] dispatchToMainQueue:^{
                [HUD hidden];
                
                NSArray *payToolsArray = [[PayNucHelper sharedInstance] jsonStringToArray:[NSString stringWithUTF8String:paynuc.get("payTools").c_str()]];
                //支付工具排序
                payToolsArray = [Tool orderForPayTools:payToolsArray];
                [CommParameter sharedInstance].ownPayToolsArray = payToolsArray;
                
                
                
            }];
        }];
        if (error) return ;
    }];
    
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
