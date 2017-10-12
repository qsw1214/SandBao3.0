//
//  MqttMsgViewController.m
//  sandbao
//
//  Created by tianNanYiHao on 2017/7/27.
//  Copyright © 2017年 sand. All rights reserved.
//

#import "MqttMsgViewController.h"
#import "MqttMsgTableViewCell.h"

#import "SDLog.h"
#import "CommParameter.h"
#import "SDSqlite.h"
#import "SqliteHelper.h"
#import "PayNucHelper.h"
#import "MqttMsgDetailViewController.h"
#import "PresentAnimatedTransitioning.h"
#import "DismissAnimatedTransitioning.h"


#define navbarColor RGBA(242, 242, 242, 1.0)

#define navViewColor RGBA(255, 125, 50, 1.0)

#define lineViewColor RGBA(237, 237, 237, 1.0)

#define titleColor RGBA(174, 174, 174, 1.0)

#define textFiledColor RGBA(83, 83, 83, 1.0)

#define textFiledColordarkBlue RGBA(43, 56, 87, 1.0)

#define textFiledColorBlue  RGBA(65, 131, 215, 1.0)

#define textFiledColorlightGray RGBA(191, 195, 204, 1.0)

#define viewColor RGBA(255, 255, 255, 1.0)


#define cellH 64.5f


@interface MqttMsgViewController ()<UITableViewDelegate,UITableViewDataSource,SDPopviewDelegate,UIViewControllerTransitioningDelegate>
{
    NavCoverView *navCoverView;
    MqttMsgTableViewCell *cell;
    CGSize viewSize;
    CGFloat titleTextSize;
    CGFloat labelTextSize;
    CGFloat lineViewHeight;
    CGFloat leftRightSpace;
    CGFloat space;
    
    UIScrollView *scrollView;
    
    CGFloat textFieldTextSize;
    CGFloat textSize;
    UITableView *tableVie;
    
    
    

}
@property (nonatomic, strong) NSMutableArray *mqttMsgArray; //倒序后的原始数据数组(未按照msgtype&msglevel分类)
@property (nonatomic, strong) NSMutableArray *tempArray;    //按照msgtype&level分类的临时存储数组
@property (nonatomic, strong) SDPopview *sdPopView;
@property (nonatomic, strong) SDPopViewConfig *sdpopViewconfig;
@end

@implementation MqttMsgViewController
@synthesize tempArray;
@synthesize sdPopView;
@synthesize sdpopViewconfig;


#pragma mark - UIViewControllerTransitioningDelegate
- (id<UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented presentingController:(UIViewController *)presenting sourceController:(UIViewController *)source{
    return [PresentAnimatedTransitioning new];
}

-(id<UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed{
    return [DismissAnimatedTransitioning new];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //转账step1
    [self.view setBackgroundColor:RGBA(248, 248, 248, 1.0)];
    viewSize = self.view.bounds.size;
    leftRightSpace = 15;
    lineViewHeight = 1;
    space = 10;
    
    _mqttMsgArray = [NSMutableArray arrayWithCapacity:0];
    _mqttMsgArray = [self getMQttlistArray];
    
    [self addsdPopView];
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
    navCoverView = [NavCoverView shareNavCoverView:CGRectMake(0, 0, viewSize.width, controllerTop) title:@"我的消息"];
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
    UIImage *rightImage = [UIImage imageNamed:@"msgeShow"];
    CGSize newImageSize = CGSizeMake(rightImage.size.width+space, rightImage.size.height+space);
    UIButton *rightBarBtn = [[UIButton alloc] init];
    [rightBarBtn setImage:[UIImage imageNamed:@"msgeShow"] forState:UIControlStateNormal];
    [rightBarBtn setImage:[UIImage imageNamed:@"msgeShow"] forState:UIControlStateHighlighted];
    rightBarBtn.frame = CGRectMake(viewSize.width - 10 - newImageSize.width, 20 + (40 - newImageSize.height) / 2, newImageSize.width, newImageSize.height);
    rightBarBtn.tag = 102;
    rightBarBtn.contentMode = UIViewContentModeScaleAspectFit;
    [rightBarBtn addTarget:self action:@selector(buttonActionToDoSomething:) forControlEvents:UIControlEventTouchUpInside];
    [navCoverView addSubview:rightBarBtn];
}


/**
 获取最新mqttMsgArray
 从数据库获取后做倒叙处理
 */
- (NSMutableArray*)getMQttlistArray{
    
    NSMutableArray *mqttlistArray = [SDSqlite selectWhereData:[SqliteHelper shareSqliteHelper].sandBaoDB tableName:@"mqttlist" columnArray:MQTTLIST_ARR whereColumnString:@"uid" whereParamString:[CommParameter sharedInstance].userId];
    NSMutableArray *mqttlistArrayNew = [NSMutableArray arrayWithCapacity:0];
    for (int i = (int)mqttlistArray.count-1; i>=0; i--) {
        [mqttlistArrayNew addObject:mqttlistArray[i]];
    }
    return mqttlistArrayNew;
}

/**
 配置弹出config
 */
- (void)addsdPopView{
    
    sdpopViewconfig  = [[SDPopViewConfig alloc] init];
    sdpopViewconfig.triAngelWidth = 8;
    sdpopViewconfig.triAngelHeight = 6;
    sdpopViewconfig.containerViewCornerRadius = 5;
    sdpopViewconfig.roundMargin = 4;
    sdpopViewconfig.layerBackGroundColor = RGBA(64, 131, 215, 1.0);
    sdpopViewconfig.defaultRowHeight = 3*leftRightSpace;
    sdpopViewconfig.tableBackgroundColor = RGBA(247, 247, 247, 1.0);
    sdpopViewconfig.separatorColor = [UIColor blackColor];
    sdpopViewconfig.textColor = [UIColor blackColor];
    sdpopViewconfig.textAlignment = NSTextAlignmentLeft;
    sdpopViewconfig.font = [UIFont systemFontOfSize:textSize];
    sdpopViewconfig.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
 
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
    scrollView.contentSize = CGSizeMake(viewSize.width, viewSize.height - controllerTop);
    [view addSubview:scrollView];
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    
    tableVie = [[UITableView alloc] init];
    tableVie.delegate = self;
    tableVie.dataSource = self;
    [scrollView addSubview:tableVie];
    
    
    //默认显示交易消息记录
    tempArray = [NSMutableArray arrayWithCapacity:0];
    //msgTyep = 100001 && msgLevel = 0
    for (int i = 0; i<_mqttMsgArray.count; i++) {
        NSString *msgLaevl = [[self mqttinfo:_mqttMsgArray[i]] firstObject];
        NSString *msgType = [self mqttinfo:_mqttMsgArray[i]][1];
        if ([msgLaevl intValue] == 0 && [msgType isEqualToString:@"100001"]) {
            [tempArray addObject:_mqttMsgArray[i]];
        }
    }
     CGFloat tableViewH = [self regetTableviewHeight];
    
    [scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(view).offset(controllerTop);
        make.left.equalTo(view).offset(0);
        make.size.mas_equalTo(CGSizeMake(viewSize.width, viewSize.height-controllerTop));
    }];
    [tableVie mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(scrollView).offset(0);
        make.centerX.equalTo(scrollView.mas_centerX);
        make.size.mas_equalTo(CGSizeMake(viewSize.width, tableViewH));
    }];
    
    
}


/**
 mqtt从json串中取出
 */
- (NSArray*)mqttinfo:(NSDictionary*)dict{
    
    NSString *msgJsonStr = [dict objectForKey:@"msg"];
    NSDictionary *mqttmsgDic = [[PayNucHelper sharedInstance] jsonStringToDictionary:msgJsonStr];
    NSString *msglevel = [mqttmsgDic objectForKey:@"msgLevel"];
    NSString *msgType = [mqttmsgDic objectForKey:@"msgType"];
    
    NSString *msgTime = [[mqttmsgDic objectForKey:@"data"] objectForKey:@"msgTime"];
    NSString *msgTitle = [[mqttmsgDic objectForKey:@"data"] objectForKey:@"msgTitle"];

    //msgData
    NSDictionary *msgDataDict = [[PayNucHelper sharedInstance] jsonStringToDictionary:[[mqttmsgDic objectForKey:@"data"] objectForKey:@"msgData"]];
    
    return @[msglevel,msgType,msgDataDict,msgTime,msgTitle];
    
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
            NSArray *arr = @[@{@"name":@"交易消息",@"icon":@""},
                             @{@"name":@"登陆消息",@"icon":@""}
                             ];
            
            sdPopView = [[SDPopview alloc] initWithBounds:CGRectMake(0, 0, 100, sdpopViewconfig.defaultRowHeight *arr.count) titleInfo:arr config:sdpopViewconfig];
            sdPopView.delegate = self;
            
            [sdPopView showFrom:btn alignStyle:SDPopViewStyleRight];
        }
            break;
        default:
            break;
    }
}


#pragma mark- SDPopViewDelegate
- (void)popOverView:(SDPopview *)pView didClickMenuIndex:(NSInteger)index{
    
    //交易相关消息记录
    if (index == 0) {
        if (tempArray.count>0) {
            [tempArray removeAllObjects];
        }
        //msgTyep = 100001 && msgLevel = 0
        for (int i = 0; i<_mqttMsgArray.count; i++) {
            NSString *msgLaevl = [[self mqttinfo:_mqttMsgArray[i]] firstObject];
            NSString *msgType = [self mqttinfo:_mqttMsgArray[i]][1];
            if ([msgLaevl intValue] == 0 && [msgType isEqualToString:@"100001"]) {
                [tempArray addObject:_mqttMsgArray[i]];
            }
        }
        [tableVie reloadData];
        CGFloat tableViewH = [self regetTableviewHeight];
        [self resetTableviewHeiht:tableViewH];
    }
    
    //异地登陆消息记录
    if (index == 1) {
        if (tempArray.count>0) {
            [tempArray removeAllObjects];
        }
        //msgTyep = 100001 && msgLevel = 0
        for (int i = 0; i<_mqttMsgArray.count; i++) {
            NSString *msgLaevl = [[self mqttinfo:_mqttMsgArray[i]] firstObject];
            NSString *msgType = [self mqttinfo:_mqttMsgArray[i]][1];
            if ([msgLaevl intValue] == 2 && [msgType isEqualToString:@"300001"]) {
                [tempArray addObject:_mqttMsgArray[i]];
            }
        }
        [tableVie reloadData];
        CGFloat tableViewH = [self regetTableviewHeight];
        [self resetTableviewHeiht:tableViewH];
        
        
    }
    

}

/**
 获取tableview高度
 */
- (CGFloat)regetTableviewHeight{
    CGFloat tableViewH = tempArray.count * cellH;
    if (tableViewH > (viewSize.height-controllerTop)) {
        tableViewH = viewSize.height - controllerTop;
        tableVie.scrollEnabled = YES;
    }else{
        tableViewH = tempArray.count * cellH;
        tableVie.scrollEnabled = NO;
    }
    return tableViewH;
}

/**
 重置tableview高度
 */
- (void)resetTableviewHeiht:(CGFloat)tableViewH{
    CGRect sizeRect = tableVie.bounds;
    sizeRect = CGRectMake(0, 0, sizeRect.size.width, tableViewH);
    tableVie.bounds = sizeRect;
    tableVie.frame = CGRectMake(0, 0, sizeRect.size.width, sizeRect.size.height);
}


#pragma mark -  tableviewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return tempArray.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return cellH;
}
- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *idd = @"MqttMsgTableViewCell";
    cell = (MqttMsgTableViewCell*)[tableView dequeueReusableCellWithIdentifier:idd];
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"MqttMsgTableViewCell" owner:self options:nil] firstObject];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    NSDictionary *dic = tempArray[indexPath.row];
    NSArray *arr = [self mqttinfo:dic];
    cell.msgLevel = [arr[0] integerValue];
    cell.readOrno = [dic objectForKey:@"isRead"];
    cell.msgTitleStr  = arr[4];
    cell.msgDetailStr = [arr[2] objectForKey:@"msg"];
    cell.msgTimeStr = arr[3];
    
    return cell;
    
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    //1.UI更新
    MqttMsgTableViewCell *celsl = [tableVie cellForRowAtIndexPath:indexPath];
    
    //3._mqttMsgArray数组更新
    _mqttMsgArray = [self getMQttlistArray];
    
    //4 present
    MqttMsgDetailViewController *detailVC = [[MqttMsgDetailViewController alloc] init];
    detailVC.msgTypeStr = celsl.msgTitleStr;
    detailVC.msgDetailStr = celsl.msgDetailStr;
    detailVC.msgTImeStr = celsl.msgTimeStr;
    detailVC.transitioningDelegate = self;
    detailVC.modalPresentationStyle = UIModalPresentationCustom;
    [self presentViewController:detailVC animated:YES completion:NULL];
    celsl.readOrno = @"1";
    
    //2.数据库更新
    NSString *indexCount = [tempArray[indexPath.row] objectForKey:@"indexCount"];
    BOOL updataSuccess = [SDSqlite updateData:[SqliteHelper shareSqliteHelper].sandBaoDB sql:[NSString stringWithFormat:@"update mqttlist set isRead = '1' where uid = '%@' and indexCount = '%@'",[CommParameter sharedInstance].userId,indexCount]];
    if (!updataSuccess) {
        return;
    }
   
    

    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
