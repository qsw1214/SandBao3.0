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


@interface SandCardViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    //杉德卡数组
    NSMutableArray *sandArray;
    
    CGFloat cellHeight;
}
@property (nonatomic, strong) UILabel *noCardLab;
@property (nonatomic, strong) UIButton *bottomBtn;
@property (nonatomic, strong) UITableView *sandTableView;
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
}


#pragma mark - 重写父类-baseScrollView设置
- (void)setBaseScrollview{
    [super setBaseScrollview];
    
    self.baseScrollView.backgroundColor = COLOR_F5F5F5;
    
}
#pragma mark - 重写父类-导航设置方法
- (void)setNavCoverView{
    [super setNavCoverView];
    self.navCoverView.style = NavCoverStyleWhite;
    self.navCoverView.letfImgStr = @"login_icon_back";
    self.navCoverView.rightTitleStr = @"添加";
    self.navCoverView.midTitleStr = @"杉德卡";
    
    __block SandCardViewController *weakSelf = self;
    self.navCoverView.leftBlock = ^{
        [weakSelf presentLeftMenuViewController:weakSelf.sideMenuViewController];
    };
    
    self.navCoverView.rightBlock = ^{
        AddSandCardViewController *addSandCardVC = [[AddSandCardViewController alloc] init];
        [weakSelf.navigationController pushViewController:addSandCardVC animated:YES];
    };
    
}
#pragma mark - 重写父类-点击方法集合
- (void)buttonClick:(UIButton *)btn{
    
    //绑定杉德卡
    if (btn.tag == BTN_TAG_BINDSANDCARD) {
        
    }
    //解绑
    if (btn.tag == BTN_TAG_UNBINDCARD) {
        [SDBottomPop showBottomPopView:@"解除此杉德卡绑定" cellNameList:@[@"确认解除绑定"] suerBlock:^(NSString *cellName) {
            if ([cellName isEqualToString:@"确认解除绑定"]) {
                
            }
        }];
    }
    
}

#pragma mark  - UI绘制
- (void)createUI{
    
    //noCardLab
    self.noCardLab = [Tool createLable:@"暂无绑定的杉德卡" attributeStr:nil font:FONT_18_Regular textColor:COLOR_343339_7 alignment:NSTextAlignmentCenter];
    [self.baseScrollView addSubview:self.noCardLab];
    
    //bottomBtn
    self.bottomBtn = [Tool createButton:@"添加杉德卡" attributeStr:nil font:FONT_14_Regular textColor:COLOR_FFFFFF];
    self.bottomBtn.backgroundColor = COLOR_58A5F6;
    [self.bottomBtn addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    self.bottomBtn.tag = BTN_TAG_BINDSANDCARD;
    [self.baseScrollView addSubview:self.bottomBtn];
    self.bottomBtn.height += UPDOWNSPACE_23;
    
    //tableview
    self.sandTableView = [[UITableView alloc] init];
    self.sandTableView.delegate = self;
    self.sandTableView.dataSource = self;
    self.sandTableView.scrollEnabled = YES;
    self.sandTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.baseScrollView addSubview:self.sandTableView];
    
    cellHeight = UPDOWNSPACE_122;
    
    [self.noCardLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.baseScrollView.mas_top).offset(UPDOWNSPACE_160);
        make.centerX.equalTo(self.baseScrollView);
        make.size.mas_equalTo(self.noCardLab.size);
    }];
    
    [self.bottomBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.baseScrollView);
        make.top.equalTo(self.baseScrollView.mas_bottom).offset(self.baseScrollView.height - self.bottomBtn.height);
        make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH, self.bottomBtn.height));
    }];
    
    [self.sandTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.baseScrollView);
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
        [self.bottomBtn setTitle:@"解除绑定" forState:UIControlStateNormal];
        self.bottomBtn.tag = BTN_TAG_UNBINDCARD;
        
        //杉德卡列表刷新数据
        [self.sandTableView reloadData];
        [self.sandTableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:YES];
        [self.sandTableView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.baseScrollView);
            make.centerX.equalTo(self.baseScrollView);
            make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH, self.baseScrollView.height - self.bottomBtn.height));
        }];
    }else{
        self.noCardLab.hidden = NO;
        [self.bottomBtn setTitle:@"添加杉德卡" forState:UIControlStateNormal];
        self.bottomBtn.tag = BTN_TAG_BINDSANDCARD;
    }
    
  
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
