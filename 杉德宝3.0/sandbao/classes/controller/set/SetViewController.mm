//
//  SetViewController.m
//  sandbao
//
//  Created by tianNanYiHao on 2017/2/14.
//  Copyright © 2017年 sand. All rights reserved.
//

#import "SetViewController.h"
#import "VerificationModeViewController.h"
#import "MiBaoSetViewController.h"
#import "LoginViewController.h"

#import "PayNucHelper.h"
#import "SDLog.h"


#import "CommParameter.h"
#import "VerifiNewPhoneViewController.h"
#import "SDSqlite.h"
#import "SqliteHelper.h"
#import "PayWayInOrderViewController.h"
#import "AboutUSViewController.h"
#import "AccountManageViewController.h"
#import "Base64Util.h"
#import "FAQwebViewController.h"
#import "MyViewController.h"
#import "RealNameAuthenticationViewController.h"



#define navbarColor RGBA(255, 255, 255, 1.0)

#define navViewColor RGBA(249, 249, 249, 1.0)

#define lineViewColor RGBA(237, 237, 237, 1.0)

#define titleColor RGBA(174, 174, 174, 1.0)

#define textFiledColor RGBA(83, 83, 83, 1.0)

#define btnColor RGBA(255, 97, 51, 1.0)

#define viewColor RGBA(255, 255, 255, 1.0)

@interface SetViewController ()

{
    NavCoverView *navCoverView;
}

@property (nonatomic, assign) CGSize viewSize;
@property (nonatomic, assign) CGFloat viewTop;
@property (nonatomic, assign) CGFloat textSize;
@property (nonatomic, assign) CGFloat tableViewTop;
@property (nonatomic, assign) CGFloat leftRightSpace;
@property (nonatomic, assign) CGFloat header;
@property (nonatomic, assign) CGFloat footer;
@property (nonatomic, assign) CGFloat cellHeight;
@property (nonatomic, assign) CGFloat tableViewHeight;
@property (nonatomic, assign) BOOL changeBtnImageFlag;

@property (nonatomic, strong) SDMBProgressView *HUD;

@property (nonatomic, strong) NSArray *myArray;
@property (nonatomic, strong) UITableView *myTableView;
@property (nonatomic, strong) UIButton *gesturePwdBtn;


@end

@implementation SetViewController

@synthesize viewSize;
@synthesize viewTop;
@synthesize textSize;
@synthesize tableViewTop;
@synthesize leftRightSpace;
@synthesize header;
@synthesize footer;
@synthesize cellHeight;
@synthesize tableViewHeight;
@synthesize changeBtnImageFlag;

@synthesize HUD;

@synthesize myArray;
@synthesize myTableView;
@synthesize gesturePwdBtn;


-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    [self tableViewData];
    //
}
- (void)viewDidLoad {
    [super viewDidLoad];
    changeBtnImageFlag = YES;
    viewSize = self.view.bounds.size;
    
    [self.view setBackgroundColor:RGBA(242, 242, 242, 1.0)];
    
    
    

    
    
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
    navCoverView = [NavCoverView shareNavCoverView:CGRectMake(0, 0, viewSize.width, controllerTop) title:@"设置"];
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

#pragma mark - 创建组件
/**
 *@brief 创建组件
 *@param view UIView 参数：组件
 *@return
 */
-(void)addView:(UIView *)view
{
    viewTop = 64;
    tableViewTop = 0;
    header = 10;
    footer = 0.1;

    
        cellHeight = 55;
        textSize = 15;

    
    
    //列表
    myTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, 0, 0) style:UITableViewStylePlain];
    myTableView.delegate = self;
    myTableView.dataSource = self;
    myTableView.scrollEnabled = NO;
    myTableView.sectionHeaderHeight = header;
    myTableView.sectionFooterHeight = footer;
    [view addSubview:myTableView];
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    //退出登录按钮
    UIButton *exitBtn = [[UIButton alloc] init];
    [exitBtn setTag:1];
    [exitBtn setBackgroundColor:RGBA(255, 255, 255, 1.0)];
    [exitBtn setTitleColor:RGBA(65, 131, 215, 1.0) forState:UIControlStateNormal];
    [exitBtn setTitle:@"退出登录" forState: UIControlStateNormal];
    exitBtn.titleLabel.font = [UIFont systemFontOfSize:textSize+1];
    [exitBtn addTarget:self action:@selector(buttonActionToDoSomething:) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:exitBtn];
    
    //设置控件的位置和大小
    CGFloat lineViewHeight = 1;
    CGFloat exitBtnHeight = cellHeight;
    
    
    tableViewHeight = cellHeight*myArray.count;
    if (tableViewHeight > (viewSize.height - viewTop - exitBtnHeight - header)) {
        myTableView.scrollEnabled = YES;
        tableViewHeight = viewSize.height - tableViewTop - viewTop - lineViewHeight - exitBtnHeight - header;
    }

    
    
    [myTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(navCoverView.mas_bottom).offset(0);
        make.centerX.equalTo(view);
        make.size.mas_equalTo(CGSizeMake(viewSize.width, tableViewHeight));
    }];
    
    [exitBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(myTableView.mas_bottom).offset(header);
        make.centerX.equalTo(view);
        make.size.mas_equalTo(CGSizeMake(viewSize.width, exitBtnHeight));
        
    }];
}

#pragma mark - 操作tableView
/**
 *@brief 设置组数
 *@return
 */
//- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
//{
//    return  myArray.count;
//}
/**
 *@brief 设置行数
 *@return
 */
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
//    dataArray = myArray[section];
    return myArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //获得cell
    static NSString *cellIdentfier = @"cell";
    UITableViewCell *myTableViewCell = [tableView dequeueReusableCellWithIdentifier:cellIdentfier];
    
    NSDictionary *dic = myArray[indexPath.row];
    
    //创建cell
    if (myTableViewCell == nil) {
        myTableViewCell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentfier];
        
        myTableViewCell.textLabel.text = [dic objectForKey:@"title"];
        
    } else {
        
        myTableViewCell.textLabel.text = [dic objectForKey:@"title"];
    }
    
    myTableViewCell.textLabel.textColor = RGBA(28, 28, 28, 1.0);
    myTableViewCell.textLabel.font = [UIFont systemFontOfSize:textSize];
    
    if ([@"账户管理" isEqualToString:[dic objectForKey:@"title"]]) {
        
        
        UIImage *arrowImage = [UIImage imageNamed:@"list_forward"];
        //  my_account_profile
        UIImage *headImage = [UIImage imageNamed:@"banaba_cot_little"];

        UIButton *headBtn = [[UIButton alloc] init];
        headBtn.tag = 1;
        headBtn.layer.cornerRadius = headImage.size.width/2;
        headBtn.layer.masksToBounds = YES;
        headBtn.layer.borderColor = RGBA(51, 165, 218, 1.0f).CGColor;
        headBtn.layer.borderWidth = 1.0f;
        [headBtn setImage:headImage forState:UIControlStateNormal];
        headBtn.contentMode = UIViewContentModeScaleAspectFit;
        
        //刷新头像数据
        NSString *str = [CommParameter sharedInstance].avatar;
        if (str==nil) {
            [headBtn setImage:[UIImage imageNamed:@"banaba_cot_little"] forState:UIControlStateNormal]; //没数据则默认图
        }else{
            //填充头像
            UIImage *headimg = [Tool avatarImageWith:str];
            [headBtn setImage:headimg forState:UIControlStateNormal];
        }

        //设置文字边框
        headBtn.frame = CGRectMake(viewSize.width - 2 * 10 - headImage.size.width - arrowImage.size.width, (cellHeight - headImage.size.height) / 2, headImage.size.width, headImage.size.height);
        [myTableViewCell.contentView addSubview:headBtn];// airlinesLabel;
        
        UIImageView *arrowImageView = [[UIImageView alloc] init];
        arrowImageView.image = arrowImage;
        arrowImageView.bounds = CGRectMake(0, 0, arrowImage.size.width, arrowImage.size.height);
        arrowImageView.contentMode = UIViewContentModeScaleAspectFit;
        myTableViewCell.accessoryView = arrowImageView;
    } else if ([@"手势密码" isEqualToString:[dic objectForKey:@"title"]]) {
//        UIImage *gestureImage = [UIImage imageNamed:@"mine_set_password_open.png"];
//        gesturePwdBtn = [[UIButton alloc] init];
//        gesturePwdBtn.tag = 1;
//        [gesturePwdBtn setImage:gestureImage forState:UIControlStateNormal];
//        gesturePwdBtn.contentMode = UIViewContentModeScaleAspectFit;
//        [gesturePwdBtn addTarget:self action:@selector(buttonActionToDoSomething:) forControlEvents:UIControlEventTouchUpInside];
//        gesturePwdBtn.bounds = CGRectMake(0, 0, gestureImage.size.width, gestureImage.size.height);
//        myTableViewCell.accessoryView = gesturePwdBtn;
    } else if ([@"手机号1" isEqualToString:[dic objectForKey:@"title"]]) {
//        UILabel *inviteCodeLabel = [[UILabel alloc] init];
//        inviteCodeLabel.backgroundColor = [UIColor clearColor];
//        inviteCodeLabel.text = @"123456";
//        inviteCodeLabel.textColor = RGBA(153, 153, 153, 1.0);
//        inviteCodeLabel.font = [UIFont systemFontOfSize:textSize];
//        inviteCodeLabel.textAlignment = NSTextAlignmentRight;
//        //设置文字边框
//        CGSize inviteCodeLabelSize = [inviteCodeLabel.text sizeWithAttributes:@{NSFontAttributeName:inviteCodeLabel.font}];
//        inviteCodeLabel.bounds = CGRectMake(0, 0, inviteCodeLabelSize.width, inviteCodeLabelSize.height);
//        myTableViewCell.accessoryView = inviteCodeLabel;
    } else if ([@"手机号" isEqualToString:[dic objectForKey:@"title"]]) {
        
        UIImage *arrowImage = [UIImage imageNamed:@"list_forward"];
        
        UILabel *airlinesLabel = [[UILabel alloc] init];
        airlinesLabel.backgroundColor = [UIColor clearColor];
        airlinesLabel.text = [NSString phoneNumFormat:[CommParameter sharedInstance].phoneNo];
        airlinesLabel.textColor = RGBA(153, 153, 153, 1.0);
        airlinesLabel.font = [UIFont systemFontOfSize:textSize];
        airlinesLabel.textAlignment = NSTextAlignmentRight;
        //设置文字边框
        CGSize textLabelSize = [myTableViewCell.textLabel.text sizeWithNSStringFont:myTableViewCell.textLabel.font];
        CGFloat airlinesLabelWidth = viewSize.width - 2 * 10 - textLabelSize.width - 2 * 10 - arrowImage.size.width;
        CGSize airlinesLabelSize = [airlinesLabel sizeThatFits:CGSizeMake(airlinesLabelWidth, MAXFLOAT)];
        airlinesLabel.frame = CGRectMake(textLabelSize.width + 2 * 10, (cellHeight - airlinesLabelSize.height) / 2, airlinesLabelWidth, airlinesLabelSize.height);
        [myTableViewCell.contentView addSubview:airlinesLabel];// airlinesLabel;
        
        UIImageView *arrowImageView = [[UIImageView alloc] init];
        arrowImageView.image = arrowImage;
        arrowImageView.bounds = CGRectMake(0, 0, arrowImage.size.width, arrowImage.size.height);
        arrowImageView.contentMode = UIViewContentModeScaleAspectFit;
        myTableViewCell.accessoryView = arrowImageView;
    }else if ([@"客服中心" isEqualToString:[dic objectForKey:@"title"]]){
        UIImage *arrowImage = [UIImage imageNamed:@"list_forward"];
        UILabel *airlinesLabel = [[UILabel alloc] init];
        airlinesLabel.text = @"021-962567";
        airlinesLabel.backgroundColor = [UIColor clearColor];
        airlinesLabel.textColor = RGBA(153, 153, 153, 1.0);
        airlinesLabel.font = [UIFont systemFontOfSize:textSize];
        airlinesLabel.textAlignment = NSTextAlignmentRight;
        //设置文字边框
        CGSize textLabelSize = [myTableViewCell.textLabel.text sizeWithNSStringFont:myTableViewCell.textLabel.font];
        CGFloat airlinesLabelWidth = viewSize.width - 2 * 10 - textLabelSize.width - 2 * 10 - arrowImage.size.width;
        CGSize airlinesLabelSize = [airlinesLabel sizeThatFits:CGSizeMake(airlinesLabelWidth, MAXFLOAT)];
        airlinesLabel.frame = CGRectMake(textLabelSize.width + 2 * 10, (cellHeight - airlinesLabelSize.height) / 2, airlinesLabelWidth, airlinesLabelSize.height);
        [myTableViewCell.contentView addSubview:airlinesLabel];// airlinesLabel;
        
        UIImageView *arrowImageView = [[UIImageView alloc] init];
        arrowImageView.image = arrowImage;
        arrowImageView.bounds = CGRectMake(0, 0, arrowImage.size.width, arrowImage.size.height);
        arrowImageView.contentMode = UIViewContentModeScaleAspectFit;
        myTableViewCell.accessoryView = arrowImageView;

    }
    
    else {
        UIImageView *arrowImageView = [[UIImageView alloc] init];
        UIImage *arrowImage = [UIImage imageNamed:@"list_forward"];
        arrowImageView.image = arrowImage;
        arrowImageView.bounds = CGRectMake(0, 0, arrowImage.size.width, arrowImage.size.height);
        arrowImageView.contentMode = UIViewContentModeScaleAspectFit;
        myTableViewCell.accessoryView = arrowImageView;
    }
//    myTableViewCell.selectionStyle = UITableViewCellSelectionStyleNone;
    return myTableViewCell;
}

/**
 *@brief 设置改变行的高度
 *@return
 */
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return cellHeight;
}

/**
 *@brief 选中哪一项
 *@return
 */
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [myTableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.row == 0) {
        //账户管理
        AccountManageViewController *accManageVC = [[AccountManageViewController alloc] init];
        [self.navigationController pushViewController:accManageVC animated:YES];
 
    }
    if (indexPath.row == 1) {
        //实名认证
        if ([CommParameter sharedInstance].realNameFlag == NO) {
            [Tool showDialog:@"您还未实名认证,请先实名!" defulBlock:^{
                //点击确定去实名认证
                RealNameAuthenticationViewController *mRealNameAuthenticationViewController = [[RealNameAuthenticationViewController alloc] init];
                [self.navigationController pushViewController:mRealNameAuthenticationViewController animated:YES];
            }];
            return;
        }
        //支付设置
        PayWayInOrderViewController *payWayVC = [[PayWayInOrderViewController alloc] init];
        [self.navigationController pushViewController:payWayVC animated:YES];

    }
    if (indexPath.row == 2) {
        //登陆密码
        VerificationModeViewController *mVerificationModeViewController = [[VerificationModeViewController alloc] init];
        mVerificationModeViewController.tokenType = @"01000501";
        [self.navigationController pushViewController:mVerificationModeViewController animated:YES];

    }
    if (indexPath.row == 3) {
        //支付密码
        VerificationModeViewController *mVerificationModeViewController = [[VerificationModeViewController alloc] init];
        mVerificationModeViewController.tokenType = @"01000601";
        [self.navigationController pushViewController:mVerificationModeViewController animated:YES];
    }
    if (indexPath.row == 4) {
        //更换手机号
        VerifiNewPhoneViewController *cVerificationVC = [[VerifiNewPhoneViewController alloc] init];
        cVerificationVC.tokenType = @"01001201";
        [self.navigationController pushViewController:cVerificationVC animated:YES];

    }
    
    if ([CommParameter sharedInstance].safeQuestionFlag == NO){
        
        if (indexPath.row == 5) {
            //设置密保
            VerificationModeViewController *mVerificationModeViewController = [[VerificationModeViewController alloc] init];
            mVerificationModeViewController.tokenType = @"01000701";
            [self.navigationController pushViewController:mVerificationModeViewController animated:YES];
        }
        if (indexPath.row == 6) {
            //客服电话
            [Tool showDialog:@"温馨提示" message:@"是否帮您呼叫:021-962567" leftBtnString:@"去打电话" rightBtnString:@"再想想" leftBlock:^{
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"tel:021-962567"]];
            } rightBlock:^{
                // do no thing ;
            }];
            
        }
        if (indexPath.row == 7) {
            //关于我们
            AboutUSViewController *aboutUSVc = [[AboutUSViewController alloc] initWithNibName:@"AboutUSViewController" bundle:nil];
            [self.navigationController pushViewController:aboutUSVc animated:YES];
        }
        if (indexPath.row == 8) {
            //帮助中心
            FAQwebViewController *vc = [[FAQwebViewController alloc] init];
            vc.titleName = @"帮助中心";
            vc.urlstr =  [NSString stringWithFormat:@"%@%@",AddressHTTP,ot_help_normal_FAQ];
            [self.navigationController pushViewController:vc animated:YES];
        }
    }else if([CommParameter sharedInstance].safeQuestionFlag == YES){
        if (indexPath.row == 5) {
            //客服电话
            [Tool showDialog:@"温馨提示" message:@"是否帮您呼叫:021-962567" leftBtnString:@"去打电话" rightBtnString:@"再想想" leftBlock:^{
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"tel:021-962567"]];
            } rightBlock:^{
                // do no thing ;
            }];
        }
        if (indexPath.row == 6) {
            //关于我们
            AboutUSViewController *aboutUSVc = [[AboutUSViewController alloc] initWithNibName:@"AboutUSViewController" bundle:nil];
            [self.navigationController pushViewController:aboutUSVc animated:YES];
        }
        if (indexPath.row == 7) {
            //帮助中心
            FAQwebViewController *vc = [[FAQwebViewController alloc] init];
            vc.titleName = @"帮助中心";
            vc.urlstr = [NSString stringWithFormat:@"%@%@",AddressHTTP,ot_help_normal_FAQ];
            [self.navigationController pushViewController:vc animated:YES];
        }
    }
}

#pragma mark - 改变按钮图片
/**
 *@brief 改变按钮图片
 *@return
 */
- (void)changeBtnImage
{
    if (changeBtnImageFlag == YES) {
        [gesturePwdBtn setImage:[UIImage imageNamed:@"mine_set_password_open.png"] forState:UIControlStateNormal];
        changeBtnImageFlag = NO;
    } else {
        [gesturePwdBtn setImage:[UIImage imageNamed:@"mine_set_password_close.png"] forState:UIControlStateNormal];
        changeBtnImageFlag = YES;
    }
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
        case 1:
        {
            [Tool showDialog:@"温馨提示" message:@"您确认要退出吗?" leftBtnString:@"退出" rightBtnString:@"再想想" leftBlock:^{
                 [self loginOut];
            } rightBlock:^{
                // do no thing ;
            }];
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




#pragma mark - 设置tableView数据
/**
 *@brief 设置tableView数据
 *@return
 */
-(void)tableViewData
{
    //获取更多界面数据
    NSURL *moreUrl = [[NSBundle mainBundle] URLForResource:@"set" withExtension:@"plist"];
    NSArray *arr = [NSDictionary dictionaryWithContentsOfURL:moreUrl][@"zh_CN"];
    myArray = arr[0];
    
    //设置密保成功->删除设置密保
    if ([CommParameter sharedInstance].safeQuestionFlag == YES) {
        NSMutableArray *myArrayM = [NSMutableArray arrayWithArray:myArray];
        [myArrayM removeObjectAtIndex:5];
        myArray = (NSArray*)myArrayM;
    }
    
    [self addView:self.view];
}

/**
 *@brief 登出
 */
- (void)loginOut
{
    HUD = [SDMBProgressView showSDMBProgressOnlyLoadingINViewImg:self.view];
    [SDRequestHelp shareSDRequest].HUD = HUD;
    [SDRequestHelp shareSDRequest].controller = self;
    [[SDRequestHelp shareSDRequest] dispatchGlobalQuque:^{
        __block BOOL error = NO;
        paynuc.set("tTokenType", "01000301");
        [[SDRequestHelp shareSDRequest] requestWihtFuncName:@"token/getTtoken/v1" errorBlock:^(SDRequestErrorType type) {
            error = YES;
        } successBlock:^{
            
        }];
        if (error) return ;
        

        [[SDRequestHelp shareSDRequest] requestWihtFuncName:@"user/logout/v1" errorBlock:^(SDRequestErrorType type) {
            error = YES;
        } successBlock:^{
            [[SDRequestHelp shareSDRequest] dispatchToMainQueue:^{
                [HUD hidden];
                //退出到登录界面
                [Tool presetnLoginVC:self];
            }];
        }];
        if (error) return ;
        
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
