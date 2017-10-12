//
//  SandListViewController.m
//  sandbao
//
//  Created by tianNanYiHao on 2017/3/15.
//  Copyright © 2017年 sand. All rights reserved.
//

#import "SandListViewController.h"
#import "SandItemTableViewCell.h"
#import "BindingSandViewController.h"
#import "SandManageViewController.h"
#import "PayNucHelper.h"

@interface SandListViewController()
{
    NavCoverView *navCoverView;
}

@property (nonatomic, assign) CGSize viewSize;
@property (nonatomic, assign) CGFloat leftRightSpace;
@property (nonatomic, assign) CGFloat textFieldTextSize;
@property (nonatomic, assign) CGFloat btnTextSize;
@property (nonatomic, assign) CGFloat cellHeight;
@property (nonatomic, assign) CGFloat tableViewHeight;


@property (nonatomic, strong) SDMBProgressView *HUD;


@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UITableView *sandTableView;
@property (nonatomic, strong)UIView *noDataView;

@property (nonatomic, strong) NSMutableDictionary *cashPayToolDic;
@property (nonatomic, strong) NSMutableDictionary *consumePayToolDic;

@property (nonatomic, strong) NSMutableArray *bankArray;
@property (nonatomic, strong) NSMutableArray *sandArray;

@end

@implementation SandListViewController

@synthesize viewSize;
@synthesize leftRightSpace;
@synthesize textFieldTextSize;
@synthesize btnTextSize;
@synthesize cellHeight;
@synthesize tableViewHeight;
@synthesize noDataView;


@synthesize HUD;


@synthesize scrollView;
@synthesize sandTableView;

@synthesize cashPayToolDic;
@synthesize consumePayToolDic;
@synthesize bankArray;
@synthesize sandArray;

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    
    [self settingNavigationBar];
    //1.刷新支付工具
    [self ownPayTools];
    
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.view.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
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
                
                //设置各payTool数据
                [self settingData];

            }];
        }];
        if (error) return ;
    }];
    
}
/**
 *@brief  设置数据
 *@return
 */
- (void)settingData
{
    //1 每次设置前数据初始化所有容器类实例
    if (bankArray.count>0) {
        [bankArray removeAllObjects];
    }
    if (sandArray.count>0) {
        [sandArray removeAllObjects];
    }
    NSInteger bankCardCount = 0;
    NSInteger sandCardCount = 0;
    //    cashBalance = 0;
    //    consumeBalance = 0;
    cashPayToolDic = nil;
    consumePayToolDic = nil;
    
    //2 整合数据
    NSArray *payToolsArray = [CommParameter sharedInstance].ownPayToolsArray;
    NSInteger payToolsArrayCount = [payToolsArray count];
    
    for (int i = 0; i < payToolsArrayCount; i++) {
        NSDictionary *dic = payToolsArray[i];
        NSString *type = [dic objectForKey:@"type"];
        
        if ([@"1001" isEqualToString:type]) {
            bankCardCount++;
            [bankArray addObject:dic];
        } else if ([@"1002" isEqualToString:type]) {
            bankCardCount++;
            [bankArray addObject:dic];
        }  else if ([@"1003" isEqualToString:type]) {
            sandCardCount++;
            [sandArray addObject:dic];
        } else if ([@"1004" isEqualToString:type]) {
            sandCardCount++;
        } else if ([@"1005" isEqualToString:type]) {
            cashPayToolDic = payToolsArray[i];
            NSDictionary *accountDic = [cashPayToolDic objectForKey:@"account"];
            //            cashBalance = [[NSString stringWithFormat:@"%@", [accountDic objectForKey:@"balance"]] floatValue] / 100;
            
        } else if ([@"1006" isEqualToString:type]) {
            consumePayToolDic = payToolsArray[i];
            NSDictionary *accountDic = [consumePayToolDic objectForKey:@"account"];
            //            consumeBalance = [[NSString stringWithFormat:@"%@", [accountDic objectForKey:@"balance"]] floatValue] / 100;
            
        }  else if ([@"1007" isEqualToString:type]) {
            
        }  else if ([@"1008" isEqualToString:type]) {
            
        }  else if ([@"1009" isEqualToString:type]) {
            
        }  else if ([@"1010" isEqualToString:type]) {
            
        }  else if ([@"1011" isEqualToString:type]) {
            bankCardCount++;
            [bankArray addObject:dic];
        }  else if ([@"1012" isEqualToString:type]) {
            bankCardCount++;
            [bankArray addObject:dic];
        }
    }
    
    
    //    //3 刷新UI
    //    //3.1 刷新余额Lab控件数据
    //    if (cashBalance == 0 ) {  //消费余额判空
    //        cashContentLabel.text = @"0.00";
    //    } else {
    //        cashContentLabel.text = [NSString stringWithFormat:@"%.2f",cashBalance];
    //    }
    //    if (consumeBalance == 0 ) {  //现金余额判空
    //        consumeContentLabel.text = @"0.00";
    //    } else {
    //        consumeContentLabel.text = [NSString stringWithFormat:@"%.2f", consumeBalance];
    //    }
    
    //3.2 刷新银行卡/杉德卡 张数Lab数据
    //    bankContentLabel.text = [NSString stringWithFormat:@"%li张", (long)bankCardCount];
    //    sandContentLabel.text = [NSString stringWithFormat:@"%li张", (long)sandCardCount];
    
    
    
    //创建UI
    [self addView:self.view];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view setBackgroundColor:RGBA(242, 242, 242, 1.0)];
    viewSize = self.view.bounds.size;
    leftRightSpace = 15;
    
    
    
    
    
    sandArray = [NSMutableArray arrayWithCapacity:0];
    bankArray = [NSMutableArray arrayWithCapacity:0];

}

#pragma mark - 设置导航栏
/**
 *@brief 设置导航栏
 *@return
 */
- (void)settingNavigationBar
{
    //导航渐变条
    navCoverView = [NavCoverView shareNavCoverView:CGRectMake(0, 0, viewSize.width, controllerTop) title:@"杉德卡列表"];
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
    
}

#pragma mark - 创建组件
/**
 *@brief 创建组件
 *@param view UIView 参数：组件
 *@return
 */
-(void)addView:(UIView *)view
{
    CGFloat textSize = 0;
  
        cellHeight = 90;
        textSize = 12;

    
    noDataView = [[UIView alloc] init];
    [noDataView setBackgroundColor:RGBA(234, 234, 234, 1.0)];
    [view addSubview:noDataView];
    
    UIImage *noDataImage = [UIImage imageNamed:@"sk.png"];
    UIImageView *noDataImageView = [[UIImageView alloc] init];
    noDataImageView.image = noDataImage;
    noDataImageView.contentMode = UIViewContentModeScaleAspectFit;
    [noDataView addSubview:noDataImageView];
    
    UILabel *noDataLabel = [[UILabel alloc] init];
    noDataLabel.text = @"还没有绑定银行卡，请添加银行卡。";
    noDataLabel.textColor = RGBA(153, 153, 153, 1.0);
    noDataLabel.font = [UIFont systemFontOfSize:textSize];
    [noDataView addSubview:noDataLabel];
    
    
    sandTableView = [[UITableView alloc] init];
    sandTableView.delegate = self;
    sandTableView.dataSource = self;
    sandTableView.scrollEnabled = YES;
    sandTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [view addSubview:sandTableView];
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    UIImage *addImage = [UIImage imageNamed:@"add_activity"];
    UIButton *addBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [addBtn setImage:addImage forState:UIControlStateNormal];
    addBtn.tag = 201;
    [addBtn addTarget:self action:@selector(buttonActionToDoSomething:) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:addBtn];

    
    //设置控件的位置和大小
    CGFloat tempHeight = viewSize.height - controllerTop;
    CGSize addBtnSize = addImage.size;
    CGFloat addBtnToBottom = 50;
    
    if (sandArray.count <= 0) {
        [noDataView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(navCoverView.mas_bottom).offset(0);
            make.centerX.equalTo(view);
            make.size.mas_equalTo(CGSizeMake(viewSize.width, tempHeight));
        }];
        
        [noDataImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(noDataView).offset((viewSize.height - controllerTop) * 0.27);
            make.centerX.equalTo(noDataView);
        }];
        
        CGSize noDataLabelSize = [noDataLabel.text sizeWithNSStringFont:noDataLabel.font];
        [noDataLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(noDataImageView.mas_bottom).offset(10);
            make.centerX.equalTo(noDataView);
            make.size.mas_equalTo(CGSizeMake(noDataLabelSize.width, noDataLabelSize.height));
        }];
    } else {
        [sandTableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(navCoverView.mas_bottom).offset(0);
            make.centerX.equalTo(view);
            make.size.mas_equalTo(CGSizeMake(viewSize.width, tempHeight));
        }];
    }
    [addBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(view.mas_bottom).offset(-addBtnToBottom);
        make.centerX.equalTo(view.mas_centerX).offset(0);
        make.size.mas_equalTo(addBtnSize);
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
    return sandArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //获得cell
    static NSString *cellIdentfier = @"cell";
    SandItemTableViewCell *mSandItemTableViewCell = [tableView dequeueReusableCellWithIdentifier:cellIdentfier];
    NSDictionary *dic = sandArray[indexPath.row];
    
    //创建cell
    if (mSandItemTableViewCell == nil) {
        mSandItemTableViewCell = [[SandItemTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentfier];
        
        mSandItemTableViewCell.cellHeight = cellHeight;
        mSandItemTableViewCell.viewSize = viewSize;
        mSandItemTableViewCell.dicData = dic;
        
    } else {
        mSandItemTableViewCell.cellHeight = cellHeight;
        mSandItemTableViewCell.viewSize = viewSize;
        mSandItemTableViewCell.dicData = dic;
    }
    mSandItemTableViewCell.selectionStyle = UITableViewCellSelectionStyleNone;
    return mSandItemTableViewCell;
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

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell * cell = [tableView cellForRowAtIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    SandManageViewController *mSandManageViewController = [[SandManageViewController alloc] init];
    mSandManageViewController.payToolDic = sandArray[indexPath.row];
    [self.navigationController pushViewController:mSandManageViewController animated:YES];
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
            [self.navigationController popViewControllerAnimated:YES];
        }
            break;
        case 102:
        {
            
        }
            break;
        case 201:
        {
            BindingSandViewController *mBindingSandViewController = [[BindingSandViewController alloc] init];
            [self.navigationController pushViewController:mBindingSandViewController animated:YES];
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
