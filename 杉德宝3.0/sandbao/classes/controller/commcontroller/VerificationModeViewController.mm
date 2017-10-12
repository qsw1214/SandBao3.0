//
//  VerificationModeViewController.m
//  sandbao
//
//  Created by tianNanYiHao on 2017/1/19.
//  Copyright © 2017年 sand. All rights reserved.
//

#import "VerificationModeViewController.h"


#import "SDLog.h"
#import "PayNucHelper.h"
#import "VerificationViewController.h"


#define navViewColor RGBA(249, 249, 249, 1.0)

#define textFiledColor RGBA(83, 83, 83, 1.0)

#define btnColor RGBA(255, 97, 51, 1.0)

#define viewColor RGBA(255, 255, 255, 1.0)


@interface VerificationModeViewController ()
{
    NavCoverView *navCoverView;
}

@property (nonatomic, assign) CGSize viewSize;
@property (nonatomic, assign) CGFloat textSize;
@property (nonatomic, assign) CGFloat textFieldTextSize;
@property (nonatomic, assign) CGFloat cellHeight;
@property (nonatomic, assign) CGFloat tableViewHeight;


@property (nonatomic, strong) SDMBProgressView *HUD;


@property (nonatomic, strong) UITableView *authGroupsTableView;
@property (nonatomic, strong) NSArray *authGroupsArray;


@end

@implementation VerificationModeViewController

@synthesize viewSize;
@synthesize textSize;
@synthesize textFieldTextSize;
@synthesize cellHeight;
@synthesize tableViewHeight;


@synthesize HUD;


@synthesize authGroupsTableView;

@synthesize authGroupsArray;

@synthesize tokenType;
@synthesize tokenTypeFalg;

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    //
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view setBackgroundColor:RGBA(247, 245, 244, 1.0)];
    viewSize = self.view.bounds.size;
    
    
    

    
    [self settingNavigationBar];
    [self load];
}

#pragma mark - 设置导航栏
/**
 *@brief 设置导航栏
 *@return
 */
- (void)settingNavigationBar
{
    //导航渐变条
    navCoverView = [NavCoverView shareNavCoverView:CGRectMake(0, 0, viewSize.width, controllerTop) title:@"验证列表"];
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

        textFieldTextSize = 14;
        textSize = 16;
        cellHeight = 50;


    
    UIView *titleView = [[UIView alloc] init];
    titleView.backgroundColor = [UIColor clearColor];
    [view addSubview:titleView];
    
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.text = @"选择一种方式进行身份校验";
    titleLabel.textColor = [UIColor grayColor];
    titleLabel.font = [UIFont systemFontOfSize:textFieldTextSize];
    [titleView addSubview:titleLabel];
    
    //还款方式列表
    authGroupsTableView = [[UITableView alloc] init];
    authGroupsTableView.delegate = self;
    authGroupsTableView.dataSource = self;
    authGroupsTableView.scrollEnabled = NO;
    authGroupsTableView.userInteractionEnabled = YES;
    [view addSubview:authGroupsTableView];
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    //设置控件的位置和大小
    CGFloat space = 10.0;
    CGFloat commWidth = viewSize.width - 2 * 10;
    CGSize titleLabelSize = [titleLabel sizeThatFits:CGSizeMake(commWidth, MAXFLOAT)];
    CGFloat titleViewHeight = titleLabelSize.height + 2 * 15;
    
    CGFloat height = viewSize.height - controllerTop - space - titleViewHeight;
    tableViewHeight = authGroupsArray.count * cellHeight;
    if (tableViewHeight > height) {
        authGroupsTableView.scrollEnabled = YES;
        tableViewHeight = height;
    }

    
    [titleView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(navCoverView.mas_bottom).offset(space);
        make.centerX.equalTo(view);
        make.size.mas_equalTo(CGSizeMake(viewSize.width, titleViewHeight));
    }];
    
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(titleView);
        make.size.mas_equalTo(CGSizeMake(commWidth, titleLabelSize.height));
    }];
    
    [authGroupsTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(titleView.mas_bottom).offset(0);
        make.centerX.equalTo(view);
        make.size.mas_equalTo(CGSizeMake(viewSize.width, tableViewHeight));
    }];
}

#pragma mark - 操作tableView
/**
 *@brief 设置组数
 *@return
 */
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return  1;
}
/**
 *@brief 设置行数
 *@return
 */
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return authGroupsArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //获得cell
    static NSString *cellIdentfier = @"cell";
    UITableViewCell *mTableViewCell = [tableView dequeueReusableCellWithIdentifier:cellIdentfier];
    NSDictionary *dic = authGroupsArray[indexPath.row];
    
    //创建cell
    if (mTableViewCell == nil) {
        mTableViewCell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentfier];
    }
    
    mTableViewCell.textLabel.text = [dic objectForKey:@"title"];
    mTableViewCell.textLabel.textColor = RGBA(51, 51, 51, 1.0);
    mTableViewCell.textLabel.font = [UIFont systemFontOfSize:textSize];
    mTableViewCell.textLabel.numberOfLines = 0;
    
    UIImageView *arrowImageView = [[UIImageView alloc] init];
    UIImage *arrowImage = [UIImage imageNamed:@"list_forward.png"];
    arrowImageView.image = arrowImage;
    arrowImageView.bounds = CGRectMake(0, 0, arrowImage.size.width, arrowImage.size.height);
    arrowImageView.contentMode = UIViewContentModeScaleAspectFit;
    mTableViewCell.accessoryView = arrowImageView;
    
    return mTableViewCell;
}

/**
 *@brief 设置改变行的高度
 *@return
 */
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return cellHeight;
}

/**
 *@brief 设置cell之间headerview的高度
 *@return
 */
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0;
}

/**
 *@brief 设置cell之间footerview的高度
 *@return
 */
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0;
}

/**
 *@brief 选中哪一项
 *@return
 */
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    VerificationViewController *mVerificationViewController = [[VerificationViewController alloc] init];
    mVerificationViewController.tokenType = tokenType;
    mVerificationViewController.authGroupDic = authGroupsArray[indexPath.row];
    [self.navigationController pushViewController:mVerificationViewController animated:YES];
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
            
        }
            break;
        case 101:
        {
            //退回到设置页面
            UIViewController *setViewController = self.navigationController.viewControllers[1];
            [self.navigationController popToViewController:setViewController animated:YES];
        }
            break;
        case 102:
        {
            [self.navigationController popToRootViewControllerAnimated:YES];
        }
            break;
        default:
            break;
    }
}


#pragma mark - 业务逻辑

/**
 *@brief 获取验证工具集组
 */
- (void)load
{
    HUD = [SDMBProgressView showSDMBProgressOnlyLoadingINViewImg:self.view];
    [SDRequestHelp shareSDRequest].HUD = HUD;
    [SDRequestHelp shareSDRequest].controller = self;
    [[SDRequestHelp shareSDRequest] dispatchGlobalQuque:^{
        __block BOOL error = NO;
        
        if (tokenTypeFalg == NO) {
            paynuc.set("tTokenType", [tokenType UTF8String]);
            [[SDRequestHelp shareSDRequest] requestWihtFuncName:@"token/getTtoken/v1" errorBlock:^(SDRequestErrorType type) {
                error = YES;
            } successBlock:^{
                
            }];
            if (error) return ;
        }
        
        
        [[SDRequestHelp shareSDRequest] requestWihtFuncName:@"authTool/getAuthGroups/v1" errorBlock:^(SDRequestErrorType type) {
            error = YES;
        } successBlock:^{
            [[SDRequestHelp shareSDRequest] dispatchToMainQueue:^{
                [HUD hidden];
                
                NSString *tempAuthTools = [NSString stringWithUTF8String:paynuc.get("authGroups").c_str()];
                authGroupsArray = [[PayNucHelper sharedInstance] jsonStringToArray:tempAuthTools];
                
                [self addView:self.view];
            }];
        }];
        if (error) return ;
    }];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

@end
