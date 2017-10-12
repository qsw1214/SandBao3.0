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


@interface MqttMsgViewController ()<UITableViewDelegate,UITableViewDataSource,SDPopviewDelegate>
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
    UITableView *tableVie;
    NSMutableArray *tempArray;
    
    
    

}
@property (nonatomic, strong) SDPopview *sdPopView;
@property (nonatomic, strong) SDPopViewConfig *sdpopViewconfig;
@end

@implementation MqttMsgViewController

@synthesize sdPopView;
@synthesize sdpopViewconfig;


- (void)viewDidLoad {
    [super viewDidLoad];
    
    //转账step1
    [self.view setBackgroundColor:RGBA(248, 248, 248, 1.0)];
    viewSize = self.view.bounds.size;
    leftRightSpace = 15;
    lineViewHeight = 1;
    space = 10;
    
    
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
    if (iPhone4 || iPhone5) {
        textFieldTextSize = 14;
        textSize = 15;
        
    } else if (iPhone6) {
        textFieldTextSize = 16;
        textSize = 17;
        
    } else {
        textFieldTextSize = 16;
        textSize = 17;
        
    }
    
    
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
        if ([[_mqttMsgArray[i] objectForKey:@"msgLevel"] intValue] == 0 && [[_mqttMsgArray[i] objectForKey:@"msgType"] isEqualToString:@"100001"]) {
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
            if ([[_mqttMsgArray[i] objectForKey:@"msgLevel"] intValue] == 0 && [[_mqttMsgArray[i] objectForKey:@"msgType"] isEqualToString:@"100001"]) {
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
            if ([[_mqttMsgArray[i] objectForKey:@"msgLevel"] intValue] == 2 && [[_mqttMsgArray[i] objectForKey:@"msgType"] isEqualToString:@"300001"]) {
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
    MqttMsgTableViewCell *cell = (MqttMsgTableViewCell*)[tableView dequeueReusableCellWithIdentifier:idd];
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"MqttMsgTableViewCell" owner:self options:nil] firstObject];
    }
    
    NSDictionary *dic = tempArray[indexPath.row];
    NSData *jsonData = [[[dic objectForKey:@"data"] objectForKey:@"msgData"] dataUsingEncoding:NSUTF8StringEncoding];
    NSDictionary *msgDataDict = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableLeaves error:nil];
    NSString *msgStr = [msgDataDict objectForKey:@"msg"];
    NSString *msgTime = [[dic objectForKey:@"data"] objectForKey:@"msgTime"];
    
    cell.msgLevel = [[dic objectForKey:@"msgLevel"] integerValue];
    cell.msgTitleStr  = [[dic objectForKey:@"data"] objectForKey:@"msgTitle"];
    cell.msgDetailStr = msgStr;
    cell.msgTimeStr = msgTime;
    
    return cell;
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
