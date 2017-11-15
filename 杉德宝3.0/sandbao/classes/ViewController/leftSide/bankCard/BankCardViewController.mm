//
//  BankCardViewController.m
//  sandbao
//
//  Created by tianNanYiHao on 2017/10/27.
//  Copyright © 2017年 sand. All rights reserved.
//

#import "BankCardViewController.h"

#import "PayNucHelper.h"
#import "SDPayView.h"
#import "BankItemTableViewCell.h"
#import "SDBottomPop.h"

#import "AddBankCardViewController.h"

typedef void(^BankCardUnBindBlock)(NSArray *paramArr);

@interface BankCardViewController ()<UITableViewDelegate,UITableViewDataSource,SDPayViewDelegate>
{
    //银行卡数组
    NSMutableArray *bankArray;
    //所选的支付工具(银行卡)
    NSDictionary   *selectPayToolDic;
    
    CGFloat cellHeight;
    
    NSString *payPassPwdStr;
    
}
@property (nonatomic, strong) UILabel *noCardLab;
@property (nonatomic, strong) UIButton *bottomBtn;
@property (nonatomic, strong) UITableView *bankTableView;
@property (nonatomic, strong) SDPayView *payView;
@property (nonatomic, strong) NSArray *authTools;
@end

@implementation BankCardViewController

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
    
    [self createUI_PayToolView];
    
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
    self.navCoverView.midTitleStr = @"银行卡";
    
    __block BankCardViewController *weakSelf = self;
    self.navCoverView.leftBlock = ^{
        [weakSelf presentLeftMenuViewController:weakSelf.sideMenuViewController];
    };
    self.navCoverView.rightBlock = ^{
        
        //添加银行卡
        AddBankCardViewController *addVC = [[AddBankCardViewController alloc] init];
        [weakSelf.navigationController pushViewController:addVC animated:YES];
        
    };
}
#pragma mark - 重写父类-点击方法集合
- (void)buttonClick:(UIButton *)btn{
    
    //绑卡
    if (btn.tag == BTN_TAG_BINDBANKCARD) {
        //添加银行卡
        AddBankCardViewController *addVC = [[AddBankCardViewController alloc] init];
        [self.navigationController pushViewController:addVC animated:YES];
    }
    //解绑
    if (btn.tag == BTN_TAG_UNBINDCARD) {
        
        [SDBottomPop showBottomPopView:@"解除绑定后银行服务将不可用" cellNameList:@[@"确认解除绑定"] suerBlock:^(NSString *cellName) {
            if ([cellName isEqualToString:@"确认解除绑定"]) {
                
            }
        }];
        
    }
    
    
    
}


#pragma mark  - UI绘制
- (void)createUI{
    
    
    //noCardLab
    self.noCardLab = [Tool createLable:@"暂无绑定的银行卡" attributeStr:nil font:FONT_18_Regular textColor:COLOR_343339_7 alignment:NSTextAlignmentCenter];
    [self.baseScrollView addSubview:self.noCardLab];
    
    //bottomBtn
    self.bottomBtn = [Tool createButton:@"添加银行卡" attributeStr:nil font:FONT_14_Regular textColor:COLOR_FFFFFF];
    self.bottomBtn.backgroundColor = COLOR_58A5F6;
    self.bottomBtn.tag = BTN_TAG_BINDBANKCARD;
    [self.bottomBtn addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.baseScrollView addSubview:self.bottomBtn];
    self.bottomBtn.height += UPDOWNSPACE_23;
    
    //tableview
    self.bankTableView = [[UITableView alloc] init];
    self.bankTableView.delegate = self;
    self.bankTableView.dataSource = self;
    self.bankTableView.scrollEnabled = YES;
    self.bankTableView.backgroundColor = COLOR_F5F5F5;
    self.bankTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.baseScrollView addSubview:self.bankTableView];
    

    cellHeight = UPDOWNSPACE_160;

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
    
    [self.bankTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.baseScrollView);
        make.centerX.equalTo(self.baseScrollView);
        make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH, 0));
    }];
    

}

- (void)createUI_PayToolView{
    
    self.payView = [SDPayView getPayView];
    self.payView.style = SDPayViewOnlyPwd;
    self.payView.delegate = self;
    [self.view addSubview:self.payView];

}


#pragma mark tableViewDelegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return bankArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return cellHeight;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //获得cell
    static NSString *cellIdentfier = @"cell";
    BankItemTableViewCell *mBankItemTableViewCell = [tableView dequeueReusableCellWithIdentifier:cellIdentfier];
    NSDictionary *dic = bankArray[indexPath.row];
    
    //创建cell
    if (mBankItemTableViewCell == nil) {
        mBankItemTableViewCell = [[BankItemTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentfier];
        
        mBankItemTableViewCell.cellHeight = cellHeight;
        mBankItemTableViewCell.viewSize = SCREEN_SIZE;
        mBankItemTableViewCell.dicData = dic;
        
    } else {
        mBankItemTableViewCell.cellHeight = cellHeight;
        mBankItemTableViewCell.viewSize = SCREEN_SIZE;
        mBankItemTableViewCell.dicData = dic;
    }
    mBankItemTableViewCell.selectionStyle = UITableViewCellSelectionStyleNone;
    return mBankItemTableViewCell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell * cell = [tableView cellForRowAtIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    selectPayToolDic = bankArray[indexPath.row];
    
    [SDBottomPop showBottomPopView:@"解除绑定后银行服务将不可用" cellNameList:@[@"确认解除绑定"] suerBlock:^(NSString *cellName) {
        if ([cellName isEqualToString:@"确认解除绑定"]) {
            [self getAuthTools];
        }
    }];
    
    
}

#pragma mark - SDPayViewDelegate
- (void)payViewPwd:(NSString *)pwdStr paySuccessView:(SDPaySuccessAnimationView *)successView{
    
    //动画开始
    [successView animationStart];
    
    payPassPwdStr = pwdStr;
    
    [self unbandCardbankCradDeleteSuccessed:^(NSArray *paramArr){
        //解绑成功
        [successView animationSuccess];
        dispatch_time_t delayTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5f * NSEC_PER_SEC));
        dispatch_after(delayTime, dispatch_get_main_queue(), ^{
            [Tool showDialog:@"解绑成功" defulBlock:^{
                [self ownPayTools];
            }];
            
            
        });
    } bankCardDelError:^(NSArray *paramArr){
        //解绑失败
        [successView animationStopClean];
        [self.payView hidPayTool];
    }];
    
}
- (void)payViewForgetPwd:(NSString *)type{
    
    if ([type isEqualToString:PAYTOOL_PAYPASS]) {
//        //修改支付密码
//        VerificationModeViewController *mVerificationModeViewController = [[VerificationModeViewController alloc] init];
//        mVerificationModeViewController.tokenType = @"01000601";
//        [self.navigationController pushViewController:mVerificationModeViewController animated:YES];
    }
    if ([type isEqualToString:PAYTOOL_ACCPASS]) {
        //修改杉德卡密码
    }
    
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
    //银行卡 数组初始化
    bankArray = [NSMutableArray arrayWithCapacity:0];
    
    NSDictionary *ownPayToolDic = [Tool getPayToolsInfo:[CommParameter sharedInstance].ownPayToolsArray];
    bankArray = [ownPayToolDic objectForKey:@"bankArray"];
   
    //银行卡列表刷新数据
    [self.bankTableView reloadData];
    
    if (bankArray.count>0) {
        self.noCardLab.hidden = YES;
        [self.bottomBtn setTitle:@"解除绑定" forState:UIControlStateNormal];
        self.bottomBtn.tag = BTN_TAG_UNBINDCARD;
        
        
        [self.bankTableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:YES];
        [self.bankTableView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.baseScrollView);
            make.centerX.equalTo(self.baseScrollView);
            make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH, self.baseScrollView.height - self.bottomBtn.height));
        }];
    }else{
        self.noCardLab.hidden = NO;
        [self.bottomBtn setTitle:@"添加银行卡" forState:UIControlStateNormal];
        self.bottomBtn.tag = BTN_TAG_BINDBANKCARD;
    }
}




#pragma mark - 解绑银行卡_获取鉴权工具
- (void)getAuthTools
{
    self.HUD = [SDMBProgressView showSDMBProgressOnlyLoadingINViewImg:self.view];
    [SDRequestHelp shareSDRequest].HUD = self.HUD;
    [SDRequestHelp shareSDRequest].controller = self;
    [[SDRequestHelp shareSDRequest] dispatchGlobalQuque:^{
        __block BOOL error = NO;
        paynuc.set("tTokenType", "01000901");
        [[SDRequestHelp shareSDRequest] requestWihtFuncName:@"token/getTtoken/v1" errorBlock:^(SDRequestErrorType type) {
            error = YES;
        } successBlock:^{
            
        }];
        if (error) return ;
        
        
        [[SDRequestHelp shareSDRequest] requestWihtFuncName:@"authTool/getAuthTools/v1" errorBlock:^(SDRequestErrorType type) {
            error = YES;
        } successBlock:^{
            [[SDRequestHelp shareSDRequest] dispatchToMainQueue:^{
                
                [self.HUD hidden];
                NSString *tempAuthTools = [NSString stringWithUTF8String:paynuc.get("authTools").c_str()];
                NSArray *tempAuthToolsArray = [[PayNucHelper sharedInstance] jsonStringToArray:tempAuthTools];
                self.authTools = tempAuthToolsArray;
                
                //根据不同支付密码类型选择UI弹出框
                NSMutableDictionary *dic = self.authTools[0];
                [self.payView setPayInfo:@[dic] moneyStr:nil orderTypeStr:nil];
                [self.payView showPayTool];
                
            }];
        }];
        if (error) return ;
    }];
}
#pragma mark 提交鉴权 + 解绑
- (void)unbandCardbankCradDeleteSuccessed:(BankCardUnBindBlock)successBlock bankCardDelError:(BankCardUnBindBlock)errorBlock
{
    self.HUD = [SDMBProgressView showSDMBProgressOnlyLoadingINViewImg:self.view];
    [self.HUD hidden];
    [SDRequestHelp shareSDRequest].HUD = self.HUD;
    [SDRequestHelp shareSDRequest].controller = self;
    [[SDRequestHelp shareSDRequest] dispatchGlobalQuque:^{
        __block BOOL error = NO;
        NSMutableArray *tempAuthToolsArray = [[NSMutableArray alloc] init];
        
        NSMutableDictionary *dic = self.authTools[0];
        NSMutableDictionary *authToolsDic = [NSMutableDictionary dictionaryWithDictionary:dic];
        [authToolsDic removeObjectForKey:@"pass"];
        NSMutableDictionary *passDic = [[NSMutableDictionary alloc] init];
        [passDic setValue:[[PayNucHelper sharedInstance] pinenc:payPassPwdStr type:@"paypass"] forKey:@"password"];
        [passDic setValue:@"" forKey:@"description"];
        [passDic setValue:@"" forKey:@"encryptType"];
        [passDic setValue:@"" forKey:@"regular"];
        [authToolsDic setObject:passDic forKey:@"pass"];
        [tempAuthToolsArray addObject:authToolsDic];
        NSString *authToolS = [[PayNucHelper sharedInstance] arrayToJSON:tempAuthToolsArray];
        paynuc.set("authTools", [authToolS UTF8String]);
        [[SDRequestHelp shareSDRequest] requestWihtFuncName:@"authTool/setAuthTools/v1" errorBlock:^(SDRequestErrorType type) {
            error = YES;
            [[SDRequestHelp shareSDRequest] dispatchToMainQueue:^{
                errorBlock(nil);
            }];
        } successBlock:^{
        }];
        if (error) return ;
        
        
        NSString *payTool = [[PayNucHelper sharedInstance] dictionaryToJson:(NSMutableDictionary*)selectPayToolDic];
        paynuc.set("payTool", [payTool UTF8String]);
        [[SDRequestHelp shareSDRequest] requestWihtFuncName:@"card/unbandCard/v1" errorBlock:^(SDRequestErrorType type) {
            error = YES;
            [[SDRequestHelp shareSDRequest] dispatchToMainQueue:^{
                errorBlock(nil);
            }];
        } successBlock:^{
            [[SDRequestHelp shareSDRequest] dispatchToMainQueue:^{
                [self.HUD hidden];
                successBlock(nil);
                
            }];
        }];
        if (error) return ;
    }];
    
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
