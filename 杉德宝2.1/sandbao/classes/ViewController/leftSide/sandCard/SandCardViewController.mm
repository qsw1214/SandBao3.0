//
//  SandCardViewController.m
//  sandbao
//
//  Created by tianNanYiHao on 2017/10/27.
//  Copyright © 2017年 sand. All rights reserved.
//

#import "SandCardViewController.h"
#import "PayNucHelper.h"
#import "SDBottomPop.h"

#import "SandItemTableViewCell.h"
#import "AddSandCardViewController.h"
#import "SandCardDetailViewController.h"
#import "CardBaseTableView.h"
#import "SDSelectBarTwoView.h"


@interface SandCardViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    //杉德卡数组
    NSMutableArray *sandArray;
    
    CGFloat cellHeight;
    
    SDSelectBarTwoView *selectBarView;
    
}
@property (nonatomic, strong) UILabel *noCardLab;
@property (nonatomic, strong) CardBaseTableView *sandTableView;
@end

@implementation SandCardViewController

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    //允许RESideMenu的返回手势
    self.sideMenuViewController.panGestureEnabled = YES;
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
    //1.刷新支付工具
    [self ownPayTools];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self createUI];
    [self createSandCardList];
}


#pragma mark - 重写父类-baseScrollView设置
- (void)setBaseScrollview{
    [super setBaseScrollview];
    self.baseScrollView.scrollEnabled = NO;
    self.baseScrollView.delegate = self;
    self.baseScrollView.backgroundColor = COLOR_F5F5F5;
    
}
#pragma mark - 重写父类-导航设置方法
- (void)setNavCoverView{
    [super setNavCoverView];
    self.navCoverView.style = NavCoverStyleWhite;
    self.navCoverView.letfImgStr = @"login_icon_back";
    self.navCoverView.midTitleStr = @"杉德卡";
    self.navCoverView.rightTitleStr = @"添加";
    
    
    __weak SandCardViewController *weakSelf = self;
    self.navCoverView.leftBlock = ^{
        //归位Home或SpsLunch
        [Tool setContentViewControllerWithHomeOrSpsLunchFromSideMenuViewController:weakSelf.sideMenuViewController];
    };
    self.navCoverView.rightBlock = ^{
        //绑定杉德卡
        AddSandCardViewController *addSandCardVC = [[AddSandCardViewController alloc] init];
        [weakSelf.navigationController pushViewController:addSandCardVC animated:YES];
    };
}
#pragma mark - 重写父类-点击方法集合
- (void)buttonClick:(UIButton *)btn{
    
   
}

#pragma mark  - UI绘制
- (void)createUI{
    
    //noCardLab
    self.noCardLab = [Tool createLable:@"暂无绑定的杉德卡" attributeStr:nil font:FONT_18_Regular textColor:COLOR_343339_7 alignment:NSTextAlignmentCenter];
    [self.baseScrollView addSubview:self.noCardLab];
    
    
    selectBarView = [SDSelectBarTwoView showSelectBarView:@[@"卡包",@"券包"] selectBarBlock:^(NSInteger index) {
        //卡包
        if (index == 0) {
             self.sandTableView.hidden = NO;
        }
        //券包
        if (index == 1) {
            self.sandTableView.hidden = YES;
        }
    }];
    [self.baseScrollView addSubview:selectBarView];
    
   
    [self.noCardLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.baseScrollView.mas_top).offset(UPDOWNSPACE_160);
        make.centerX.equalTo(self.baseScrollView);
        make.size.mas_equalTo(self.noCardLab.size);
    }];
    
    [selectBarView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.baseScrollView.mas_top).offset(UPDOWNSPACE_11);
        make.centerX.equalTo(self.baseScrollView);
        make.size.mas_equalTo(selectBarView.size);
    }];
    


}

- (void)createSandCardList{
    
    //tableview
    cellHeight = UPDOWNSPACE_122;
    self.sandTableView = [[CardBaseTableView alloc] init];
    self.sandTableView.cellHeight = cellHeight;
    self.sandTableView.backgroundColor = COLOR_F5F5F5;
    self.sandTableView.delegate = self;
    self.sandTableView.dataSource = self;
    self.sandTableView.scrollEnabled = YES;
    self.sandTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.baseScrollView addSubview:self.sandTableView];
    
    
    __weak typeof(self) weakself = self;
    MJRefreshGifHeader *header = [MJRefreshGifHeader headerWithRefreshingBlock:^{
        [weakself ownPayTools];
    }];
    [header setImages:@[[UIImage imageNamed:@"refresh"]] forState:MJRefreshStateIdle];
    [header setImages:@[[UIImage imageNamed:@"refresh_nomal"]] forState:MJRefreshStatePulling];
    NSMutableArray *imgArr = [NSMutableArray arrayWithCapacity:0];
    for (int i = 1; i<=8; i++) {
        NSString *imgName = [NSString stringWithFormat:@"refresh_Refreshing%d",i];
        UIImage *img = [UIImage imageNamed:imgName];
        [imgArr addObject:img];
    }
    [header setImages:imgArr forState:MJRefreshStateRefreshing];
    self.sandTableView.mj_header = header;
    
    
    [self.sandTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(selectBarView.mas_bottom).offset(UPDOWNSPACE_20);
        make.centerX.equalTo(self.baseScrollView);
        make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH, 0));
    }];
    
}


#pragma mark - tableViewDelegate
/**
 *@brief 设置行数
 *@return
 */
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return sandArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return cellHeight;
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
        mSandItemTableViewCell.viewSize = SCREEN_SIZE;
        mSandItemTableViewCell.dicData = dic;
        
    } else {
        mSandItemTableViewCell.cellHeight = cellHeight;
        mSandItemTableViewCell.viewSize = SCREEN_SIZE;
        mSandItemTableViewCell.dicData = dic;
    }
    mSandItemTableViewCell.selectionStyle = UITableViewCellSelectionStyleNone;
    return mSandItemTableViewCell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell * cell = [tableView cellForRowAtIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    
    SandCardDetailViewController *sandCardDetailVC = [[SandCardDetailViewController alloc] init];
    
    sandCardDetailVC.payToolDic = sandArray[indexPath.row];
    
    [self.navigationController pushViewController:sandCardDetailVC animated:YES];
    
}





#pragma mark - 业务逻辑
#pragma mark 查询我方支付工具鉴权工具
/**
 *@brief 查询我方支付工具
 */
- (void)ownPayTools
{
    //不允许RESideMenu的返回手势
    self.sideMenuViewController.panGestureEnabled = NO;
    
    self.HUD = [SDMBProgressView showSDMBProgressOnlyLoadingINViewImg:self.view];
    [SDRequestHelp shareSDRequest].HUD = self.HUD;
    [SDRequestHelp shareSDRequest].controller = self;
    [[SDRequestHelp shareSDRequest] dispatchGlobalQuque:^{
        __block BOOL error = NO;
        paynuc.set("tTokenType", "01001501");
        paynuc.set("cfg_termFp", [[Tool setCfgTempFpStaticDataFlag:NO DynamicDataFlag:YES] UTF8String]);
        [[SDRequestHelp shareSDRequest] requestWihtFuncName:@"token/getTtoken/v1" errorBlock:^(SDRequestErrorType type) {
            error = YES;
            //允许RESideMenu的返回手势
            self.sideMenuViewController.panGestureEnabled = YES;
        } successBlock:^{
            
        }];
        if (error) return ;
        
        
        paynuc.set("payToolKinds", "[]");
        [[SDRequestHelp shareSDRequest] requestWihtFuncName:@"payTool/getOwnPayTools/v1" errorBlock:^(SDRequestErrorType type) {
            error = YES;
            //允许RESideMenu的返回手势
            self.sideMenuViewController.panGestureEnabled = YES;
        } successBlock:^{
            [[SDRequestHelp shareSDRequest] dispatchToMainQueue:^{
                [self.HUD hidden];
                
                //允许RESideMenu的返回手势
                self.sideMenuViewController.panGestureEnabled = YES;
                
                NSArray *payToolsArray = [[PayNucHelper sharedInstance] jsonStringToArray:[NSString stringWithUTF8String:paynuc.get("payTools").c_str()]];
                //支付工具排序
                payToolsArray = [Tool orderForPayTools:payToolsArray];
                [CommParameter sharedInstance].ownPayToolsArray = payToolsArray;
                
                //设置支付工具
                [self settingData];
                //下拉刷新结束
                [self.sandTableView.mj_header endRefreshing];
                
            }];
        }];
        if (error) return ;
    }];
    
}


/**
 *@brief  设置支付工具
 *@return
 */
- (void)settingData
{
    //杉德卡 数组初始化
    sandArray = [NSMutableArray arrayWithCapacity:0];
    
    NSDictionary *ownPayToolDic = [Tool getPayToolsInfo:[CommParameter sharedInstance].ownPayToolsArray];
    sandArray = [ownPayToolDic objectForKey:@"sandArray"];
    
    
    if (sandArray.count>0) {
        self.noCardLab.hidden = YES;
        
        //杉德卡列表刷新数据
        [self.sandTableView reloadData];
        [self.sandTableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:YES];
        [self.sandTableView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(selectBarView.mas_bottom).offset(UPDOWNSPACE_20);
            make.centerX.equalTo(self.baseScrollView);
            make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH, self.baseScrollView.height - self.sandTableView.y));
        }];
    }else{
        self.noCardLab.hidden = NO;
    }
}


//scrollorView代理 - 屏蔽父类方法即可, 不需具体实现
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
