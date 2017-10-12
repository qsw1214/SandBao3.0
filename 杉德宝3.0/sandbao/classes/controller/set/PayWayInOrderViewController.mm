//
//  PayWayInOrderViewController.m
//  sandbao
//
//  Created by tianNanYiHao on 2017/4/13.
//  Copyright © 2017年 sand. All rights reserved.
//

#import "PayWayInOrderViewController.h"
#import "MiBaoSetViewController.h"
#import "LoginViewController.h"

#import "PayNucHelper.h"
#import "SDLog.h"


#import "CommParameter.h"
#import "VerifiNewPhoneViewController.h"
#import "SDSqlite.h"
#import "SqliteHelper.h"
#import "AboutUSViewController.h"

#define navbarColor RGBA(255, 255, 255, 1.0)

#define navViewColor RGBA(249, 249, 249, 1.0)

#define lineViewColor RGBA(237, 237, 237, 1.0)

#define titleColor RGBA(174, 174, 174, 1.0)

#define textFiledColor RGBA(83, 83, 83, 1.0)

#define btnColor RGBA(255, 97, 51, 1.0)

#define viewColor RGBA(255, 255, 255, 1.0)
@interface PayWayInOrderViewController ()<UITableViewDelegate,UITableViewDataSource>
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
@property (nonatomic, assign) CGFloat titleLabSize;

@property (nonatomic, assign) CGFloat cellHeight;
@property (nonatomic, assign) CGFloat tableViewHeight;
@property (nonatomic, assign) BOOL changeBtnImageFlag;
@property (nonatomic, assign) BOOL successAgain;

@property (nonatomic, strong) SDMBProgressView *HUD;

@property (nonatomic, strong) NSMutableArray *payInorderArray;
@property (nonatomic, strong) UITableView *payInOrderTableview;
@property (nonatomic, strong) UIButton *gesturePwdBtn;

@property (nonatomic, strong) UISwitch *switchView;
@property (nonatomic, strong) UIView *headerView;
@property (nonatomic, strong) UILabel *tipLab;
@property (nonatomic, strong) UIScrollView *scrollView;



@end

@implementation PayWayInOrderViewController
@synthesize scrollView;
@synthesize viewSize;
@synthesize viewTop;
@synthesize textSize;
@synthesize titleLabSize;
@synthesize tableViewTop;
@synthesize leftRightSpace;
@synthesize header;
@synthesize footer;
@synthesize cellHeight;
@synthesize tableViewHeight;
@synthesize changeBtnImageFlag;
@synthesize headerView;
@synthesize HUD;

@synthesize tipLab;

@synthesize payInOrderTableview;
@synthesize gesturePwdBtn;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    viewSize = self.view.bounds.size;
    leftRightSpace = 15;
    
    [self.view setBackgroundColor:RGBA(242, 242, 242, 1.0)];
    
    
    

    
    _payInorderArray = [NSMutableArray arrayWithCapacity:0];
    [self settingNavigationBar];
    _successAgain = NO; //流程第一次开始
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
    navCoverView = [NavCoverView shareNavCoverView:CGRectMake(0, 0, viewSize.width, controllerTop) title:@"付款方式排序"];
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
    
    
    

        textSize = 14;


    //3.设置右边的提交按钮
    UILabel *rightLab = [[UILabel alloc] init];
    rightLab.textColor = [UIColor whiteColor];
    rightLab.textAlignment = NSTextAlignmentRight;
    rightLab.font = [UIFont systemFontOfSize:textSize];
    rightLab.text = @"提交";
    [self.view addSubview:rightLab];
    
    UIButton *rightBarBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    [rightBarBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    rightBarBtn.tag = 102;
    [rightBarBtn addTarget:self action:@selector(buttonActionToDoSomething:) forControlEvents:UIControlEventTouchUpInside];
    CGSize size= [rightLab.text sizeWithNSStringFont:[UIFont systemFontOfSize:textSize]];
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


/**
 *@brief 加载支付工具顺序调整
 */
- (void)load
{
    HUD = [SDMBProgressView showSDMBProgressOnlyLoadingINViewImg:self.view];
    [SDRequestHelp shareSDRequest].HUD = HUD;
    [SDRequestHelp shareSDRequest].controller = self;
    [[SDRequestHelp shareSDRequest] dispatchGlobalQuque:^{
        __block BOOL error = NO;
        paynuc.set("tTokenType", "01002301");
        [[SDRequestHelp shareSDRequest] requestWihtFuncName:@"token/getTtoken/v1" errorBlock:^(SDRequestErrorType type) {
            error = YES;
        } successBlock:^{
            
        }];
        if (error) return ;
        
        //获取支付工具
        paynuc.set("payToolKinds", "[]");
        [[SDRequestHelp shareSDRequest] requestWihtFuncName:@"payTool/getOwnPayTools/v1" errorBlock:^(SDRequestErrorType type) {
            error = YES;
        } successBlock:^{
            [[SDRequestHelp shareSDRequest] dispatchToMainQueue:^{
                [HUD hidden];
                
                NSArray *payToolsArray = [[PayNucHelper sharedInstance] jsonStringToArray:[NSString stringWithUTF8String:paynuc.get("payTools").c_str()]];
                
                //根据order 字段排序
                payToolsArray = [Tool orderForPayTools:payToolsArray];
                [CommParameter sharedInstance].ownPayToolsArray = payToolsArray;
                
                _payInorderArray = [NSMutableArray arrayWithArray:payToolsArray];
                //流程第一次走,创建UI (提交过后流程再次开启不需创建UI)
                if (_successAgain == NO) {
                    [self addView:self.view];
                }
                
                //设置滚动区间
                scrollView.contentSize = CGSizeMake(viewSize.width, (cellHeight*_payInorderArray.count)*1.3);
            }];
        }];
        if (error) return ;
    }];

}

-(void)addView:(UIView *)view
{
    viewTop = 64;
    tableViewTop = 0;
    header = 10;
    footer = 0.1;
    

        cellHeight = 40;
        textSize = 13;
        titleLabSize = 16;

    
    //创建UIScrollView
    //创建UIScrollView
    scrollView = [[UIScrollView alloc] init];
    scrollView.userInteractionEnabled = YES;
    scrollView.scrollEnabled = YES;
    scrollView.directionalLockEnabled = YES; //只能一个方向滑动
    scrollView.pagingEnabled = NO; //是否翻页
    scrollView.showsVerticalScrollIndicator =YES; //垂直方向的滚动指示
    scrollView.indicatorStyle = UIScrollViewIndicatorStyleWhite;//滚动指示的风格
    scrollView.showsHorizontalScrollIndicator = NO;//水平方向的滚动指示
    [scrollView setBackgroundColor:RGBA(255, 255, 255, 1.0)];
    [view addSubview:scrollView];
    self.automaticallyAdjustsScrollViewInsets = NO;

    
    //系统自动选择区
//    //switchView
//    UIView *switchBgview = [[UIView alloc] init];
//    [scrollView addSubview:switchBgview];
//    switchBgview.backgroundColor = [UIColor whiteColor];
//    
//    UILabel *switchLab = [[UILabel alloc] init];
//    switchLab.text = @"系统自动选择";
//    switchLab.textColor = textFiledColor;
//    switchLab.textAlignment = NSTextAlignmentLeft;
//    switchLab.font = [UIFont systemFontOfSize:titleLabSize];
//    [switchBgview addSubview:switchLab];

    
//    _switchView = [[UISwitch alloc] init];
//    [switchBgview addSubview:_switchView];
//    [_switchView addTarget:self action:@selector(startChange:) forControlEvents:UIControlEventValueChanged];
    
    tipLab = [[UILabel alloc] init];
    tipLab.text = @"系统将根据下面排列顺序依次扣款,按住下面的文字拖动即可";
    tipLab.textColor = textFiledColor;
    tipLab.numberOfLines = 0;
    tipLab.textAlignment = NSTextAlignmentLeft;
    tipLab.adjustsFontSizeToFitWidth = true;
    tipLab.font = [UIFont systemFontOfSize:textSize];
    [view addSubview:tipLab];
    
    
    //
    headerView = [[UIView alloc] init];
    [view addSubview:headerView];
    headerView.backgroundColor = [UIColor whiteColor];
    
    UILabel *headerLab = [[UILabel alloc] init];
    headerLab.text = @"支付方式";
    headerLab.textColor = textFiledColor;
    headerLab.textAlignment = NSTextAlignmentLeft;
    headerLab.font = [UIFont systemFontOfSize:titleLabSize];
    [headerView addSubview:headerLab];

    
    
    
    
    //列表
    payInOrderTableview = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, 0, 0) style:UITableViewStylePlain];
    payInOrderTableview.delegate = self;
    payInOrderTableview.scrollEnabled = YES;
    payInOrderTableview.dataSource = self;
    payInOrderTableview.sectionHeaderHeight = header;
    payInOrderTableview.sectionFooterHeight = footer;
    [payInOrderTableview setEditing:YES];
    [view addSubview:payInOrderTableview];
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    
    //设置控件的位置和大小
//    CGSize switchLabSize = [switchLab.text sizeWithNSStringFont:[UIFont systemFontOfSize:titleLabSize]];
    CGSize tipLabSize = [tipLab.text sizeWithNSStringFont:[UIFont systemFontOfSize:textSize]];
    CGSize headerLabSize = [headerLab.text sizeWithNSStringFont:[UIFont systemFontOfSize:titleLabSize]];
//    CGFloat switchBgViewH = switchLabSize.height + 2*leftRightSpace;
    
    
    tableViewHeight = cellHeight*_payInorderArray.count;
    
    
    [scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(view).offset(controllerTop);
        make.centerX.equalTo(self.view);
        make.size.mas_equalTo(CGSizeMake(viewSize.width, viewSize.height - controllerTop));
    }];
    
    
//    [switchBgview mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(scrollView).offset(0);
//        make.centerX.equalTo(scrollView).offset(0);
//        make.size.mas_equalTo(CGSizeMake(viewSize.width, switchBgViewH));
//    }];
//    [switchLab mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.equalTo(switchBgview).offset(leftRightSpace);
//        make.centerY.equalTo(switchBgview.mas_centerY).offset(0);
//        make.size.mas_equalTo(switchLabSize);
//    }];
//    [_switchView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.centerY.equalTo(switchBgview.mas_centerY).offset(0);
//        make.right.equalTo(switchBgview.mas_right).offset(-leftRightSpace);
//        make.size.mas_equalTo(CGSizeMake(40, switchLabSize.height));
//    }];
    
    [tipLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(scrollView.mas_top).offset(leftRightSpace);
        make.centerX.equalTo(scrollView.mas_centerX).offset(0);
        make.size.mas_equalTo(CGSizeMake(viewSize.width-2*leftRightSpace, tipLabSize.height*2));
    }];
    
    [headerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(tipLab.mas_bottom).offset(leftRightSpace);
        make.centerX.equalTo(view).offset(0);
        make.size.mas_equalTo(CGSizeMake(viewSize.width, leftRightSpace*2));
    }];
    [headerLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(headerView.mas_centerY).offset(0);
        make.left.equalTo(headerView).offset(leftRightSpace);
        make.size.mas_equalTo(headerLabSize);
    }];
    
    [payInOrderTableview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(headerView.mas_bottom).offset(0);
        make.centerX.equalTo(view);
        make.size.mas_equalTo(CGSizeMake(viewSize.width, tableViewHeight));
    }];
    
    
    
}

-(void)startChange:(UISwitch*)sender{
    
    if (sender.on) {
        headerView.hidden = YES;
        payInOrderTableview.hidden = YES;
        tipLab.hidden = YES;
    }else{
        headerView.hidden = NO;
        payInOrderTableview.hidden = NO;
        tipLab.hidden = NO;
    }
}


/**
 提交支付工具顺序修改
 */
- (void)setPayToolsOrder{
    HUD = [SDMBProgressView showSDMBProgressOnlyLoadingINViewImg:self.view];
    [SDRequestHelp shareSDRequest].HUD = HUD;
    [SDRequestHelp shareSDRequest].controller = self;
    [[SDRequestHelp shareSDRequest] dispatchGlobalQuque:^{
        __block BOOL error = NO;
        //4 order派逊赋值
        NSMutableArray *payInorderArrayNew = [NSMutableArray arrayWithCapacity:0];
        for (int i = 0; i<_payInorderArray.count; i++) {
            NSDictionary *payToolDic = _payInorderArray[i];
            NSMutableDictionary *payToolDicM = [NSMutableDictionary dictionaryWithDictionary:payToolDic];
            [payToolDicM removeObjectForKey:@"order"];
            [payToolDicM setValue:[NSString stringWithFormat:@"%@",@(i+1)] forKey:@"order"];
            [payInorderArrayNew addObject:payToolDicM];
        }
        //
        _payInorderArray = payInorderArrayNew;
        
        NSString *payToolsNew = [[PayNucHelper sharedInstance] arrayToJSON:_payInorderArray];
        //获取支付工具
        paynuc.set("payTools", [payToolsNew UTF8String]);
        [[SDRequestHelp shareSDRequest] requestWihtFuncName:@"payTool/setOwnPayToolOrder/v1" errorBlock:^(SDRequestErrorType type) {
            error = YES;
        } successBlock:^{
            [[SDRequestHelp shareSDRequest] dispatchToMainQueue:^{
                [HUD hidden];
                
                NSArray *payToolsArray = [[PayNucHelper sharedInstance] jsonStringToArray:[NSString stringWithUTF8String:paynuc.get("payTools").c_str()]];
                
                //根据order 字段排序
                payToolsArray = [Tool orderForPayTools:payToolsArray];
                [CommParameter sharedInstance].ownPayToolsArray = payToolsArray;
                
                _payInorderArray = [NSMutableArray arrayWithArray:payToolsArray];
                [payInOrderTableview reloadData];
                
                [Tool showDialog:@"顺序调整成功" defulBlock:^{
                    _successAgain = YES;
                    //流程再次开始 以便再提提交
                    [self load];
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
            [self.navigationController popViewControllerAnimated:YES];
        }
            break;
        case 102:
        {
            [self setPayToolsOrder];
        }
            break;
        case 201:
        {
            
        }
            break;
        default:
            break;
    }
}
 

#pragma mark tableviewDelegate
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _payInorderArray.count;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return cellHeight;
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *str = @"str";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:str];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:str];
    }
    cell.imageView.frame = CGRectZero;
    NSString *title =  [_payInorderArray[indexPath.row] objectForKey:@"title"];
    
    if ([[_payInorderArray[indexPath.row] objectForKey:@"type"] isEqualToString:@"1005"] || [[_payInorderArray[indexPath.row] objectForKey:@"type"] isEqualToString:@"1006"]) {
        cell.textLabel.text = [NSString stringWithFormat:@"%@",title];
    }else{
        NSString *accNo = [[_payInorderArray[indexPath.row] objectForKey:@"account"] objectForKey:@"accNo"];
        cell.textLabel.text = [NSString stringWithFormat:@"%@ (%@)",title,accNo];
    }
    cell.textLabel.textColor = RGBA(28, 28, 28, 1.0);
  
    return cell;
}


#pragma mark 选择编辑模式，添加模式很少用,默认是删除
-(UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewCellEditingStyleNone;
}


#pragma mark 排序 当移动了某一行时候会调用
//编辑状态下，只要实现这个方法，就能实现拖动排序
-(void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath *)destinationIndexPath
{
    
    //1.取出拖动的单条数据
    NSDictionary *payToolFromDic = _payInorderArray[sourceIndexPath.row];
    //2.删除此条
    [_payInorderArray removeObject:payToolFromDic];
    
    //3.此条数据插入新位置;
    [_payInorderArray insertObject:payToolFromDic atIndex:destinationIndexPath.row];

}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
