//
//  VerifyTypeViewController.m
//  sandbao
//
//  Created by tianNanYiHao on 2017/11/6.
//  Copyright © 2017年 sand. All rights reserved.
//

#import "VerifyTypeViewController.h"
#import "PayNucHelper.h"
#import "SmsCheckViewController.h"

@interface VerifyTypeViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    UILabel *titleLab;
    
    UITableView *authGroupsTableView;
    
    CGFloat cellHeight;
}


/**
 鉴权工具集组
 */
@property (nonatomic, strong) NSArray *authGroupTypeArr;
/**
 鉴权工具集组_某一鉴权类型字典
 */
@property (nonatomic, strong) NSDictionary *authGroupTypeDic;
@end

@implementation VerifyTypeViewController

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    //请求鉴权工具集组
     [self getAuthCroups];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self createUI];
    
   
}

#pragma mark - 重写父类-baseScrollView设置
- (void)setBaseScrollview{
    [super setBaseScrollview];
    
}
#pragma mark - 重写父类-导航设置方法
- (void)setNavCoverView{
    [super setNavCoverView];
    
    if ([CommParameter sharedInstance].payPassFlag == NO) {
        self.navCoverView.hidden = YES;
    }else{
        self.navCoverView.letfImgStr = @"login_icon_back";
        __weak VerifyTypeViewController *weakSelf = self;
        self.navCoverView.leftBlock = ^{
            [weakSelf.navigationController popViewControllerAnimated:YES];
        };
    }
    
}
#pragma mark - 重写父类-点击方法集合
- (void)buttonClick:(UIButton *)btn{
    
    
}


#pragma mark  - UI绘制
- (void)createUI{

    //titleLab1
    titleLab = [Tool createLable:@"选择验证方式" attributeStr:nil font:FONT_28_Medium textColor:COLOR_343339 alignment:NSTextAlignmentCenter];
    [self.baseScrollView addSubview:titleLab];
    
    
    //还款方式列表
    authGroupsTableView = [[UITableView alloc] init];
    authGroupsTableView.backgroundColor = [UIColor whiteColor];
    authGroupsTableView.delegate = self;
    authGroupsTableView.dataSource = self;
    authGroupsTableView.scrollEnabled = NO;
    authGroupsTableView.userInteractionEnabled = YES;
    [self.baseScrollView addSubview:authGroupsTableView];
    
    cellHeight = 60;
    
    [titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.baseScrollView.mas_top).offset(UPDOWNSPACE_64);
        make.centerX.equalTo(self.baseScrollView.mas_centerX);
        make.size.mas_equalTo(titleLab.size);
    }];
    
    [authGroupsTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(titleLab.mas_bottom).offset(UPDOWNSPACE_20);
        make.centerX.equalTo(self.baseScrollView);
        make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH-LEFTRIGHTSPACE_25, UPDOWNSPACE_0));
    }];

}

#pragma mark 操作tableView


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.authGroupTypeArr.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return cellHeight;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //获得cell
    static NSString *cellIdentfier = @"cell";
    UITableViewCell *mTableViewCell = [tableView dequeueReusableCellWithIdentifier:cellIdentfier];
    NSDictionary *dic = self.authGroupTypeArr[indexPath.row];
    
    //创建cell
    if (mTableViewCell == nil) {
        mTableViewCell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentfier];
    }
    
    mTableViewCell.textLabel.text = [dic objectForKey:@"title"];
    mTableViewCell.textLabel.textColor = COLOR_343339_7;
    mTableViewCell.textLabel.font = FONT_20_Medium;
    mTableViewCell.textLabel.numberOfLines = 0;
    
    UIImageView *arrowImageView = [[UIImageView alloc] init];
    UIImage *arrowImage = [UIImage imageNamed:@"list_forward.png"];
    arrowImageView.image = arrowImage;
    arrowImageView.bounds = CGRectMake(0, 0, arrowImage.size.width, arrowImage.size.height);
    arrowImageView.contentMode = UIViewContentModeScaleAspectFit;
    mTableViewCell.accessoryView = arrowImageView;
    
    mTableViewCell.selectionStyle = UITableViewCellSelectionStyleNone;
    return mTableViewCell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    self.authGroupTypeDic = self.authGroupTypeArr[indexPath.row];
    //根据所选鉴权方式_获取鉴权工具
    [self getAuthToolsfForAuthGroup];
    
    
}


#pragma mark - 业务逻辑
#pragma mark 查询鉴权工具集组
- (void)getAuthCroups{
    
    self.HUD = [SDMBProgressView showSDMBProgressOnlyLoadingINViewImg:self.view];
    [SDRequestHelp shareSDRequest].HUD = self.HUD;
    [SDRequestHelp shareSDRequest].controller = self;
    [[SDRequestHelp shareSDRequest] dispatchGlobalQuque:^{
        __block BOOL error = NO;
        
        //忘记登录密码 - 流程
        if (self.verifyType == VERIFY_TYPE_FORGETLOGPWD) {
            [[SDRequestHelp shareSDRequest] requestWihtFuncName:@"authTool/getAuthGroups/v1" errorBlock:^(SDRequestErrorType type) {
                error = YES;
            } successBlock:^{
                [[SDRequestHelp shareSDRequest] dispatchToMainQueue:^{
                    [self.HUD hidden];
                    
                    NSString *tempAuthTools = [NSString stringWithUTF8String:paynuc.get("authGroups").c_str()];
                    self.authGroupTypeArr = [[PayNucHelper sharedInstance] jsonStringToArray:tempAuthTools];
                    //刷新UI
                    [self tableviewRefrush];
                }];
            }];
            if (error) return ;
        }
        
        //修改支付/登录密码 - 流程
        else{
            paynuc.set("tTokenType", [self.tokenType UTF8String]);
            paynuc.set("cfg_termFp", [[Tool setCfgTempFpStaticDataFlag:NO DynamicDataFlag:YES] UTF8String]);
            [[SDRequestHelp shareSDRequest] requestWihtFuncName:@"token/getTtoken/v1" errorBlock:^(SDRequestErrorType type) {
                error = YES;
            } successBlock:^{
                
            }];
            if (error) return ;
            
            [[SDRequestHelp shareSDRequest] requestWihtFuncName:@"authTool/getAuthGroups/v1" errorBlock:^(SDRequestErrorType type) {
                error = YES;
            } successBlock:^{
                [[SDRequestHelp shareSDRequest] dispatchToMainQueue:^{
                    [self.HUD hidden];
                    
                    NSString *tempAuthTools = [NSString stringWithUTF8String:paynuc.get("authGroups").c_str()];
                    self.authGroupTypeArr = [[PayNucHelper sharedInstance] jsonStringToArray:tempAuthTools];
                    //刷新UI
                    [self tableviewRefrush];
                }];
            }];
            if (error) return ;
        }
    }];
    
    
    
}
- (void)tableviewRefrush{
    
    [authGroupsTableView reloadData];
    
    CGFloat tableViewHeight = cellHeight * self.authGroupTypeArr.count;
    [authGroupsTableView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(titleLab.mas_bottom).offset(UPDOWNSPACE_20);
        make.centerX.equalTo(self.baseScrollView);
        make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH-LEFTRIGHTSPACE_25, tableViewHeight));
    }];
    
}


#pragma mark 请求鉴权工具下发(根据鉴权类型)
- (void)getAuthToolsfForAuthGroup
{
    self.HUD = [SDMBProgressView showSDMBProgressOnlyLoadingINViewImg:self.view];
    [SDRequestHelp shareSDRequest].HUD = self.HUD;
    [SDRequestHelp shareSDRequest].controller = self;
    [[SDRequestHelp shareSDRequest] dispatchGlobalQuque:^{
        __block BOOL error = NO;
        
        NSString *authGroupType = [[PayNucHelper sharedInstance] dictionaryToJson:(NSMutableDictionary*)self.authGroupTypeDic];
        paynuc.set("authGroup",[authGroupType UTF8String]);
        [[SDRequestHelp shareSDRequest] requestWihtFuncName:@"authTool/getAuthToolsForAuthGroup/v1" errorBlock:^(SDRequestErrorType type) {
            error = YES;
        } successBlock:^{
            [[SDRequestHelp shareSDRequest] dispatchToMainQueue:^{
                [self.HUD hidden];
                NSString *tempAuthTools = [NSString stringWithUTF8String:paynuc.get("authTools").c_str()];
                NSArray *tempAuthToolsArray = [[PayNucHelper sharedInstance] jsonStringToArray:tempAuthTools];
                if (tempAuthToolsArray.count>0) {
                    for (int i = 0; i<tempAuthToolsArray.count; i++) {
                        NSDictionary *authToolDic = tempAuthToolsArray[i];
                        if ([[authToolDic objectForKey:@"type"] isEqualToString:@"sms"]) {
                            SmsCheckViewController *smsVC = [[SmsCheckViewController alloc] init];
                            smsVC.verifyAuthToolsArr = tempAuthToolsArray;
                            smsVC.smsCheckType = SMS_CHECKTYPE_VERIFYTYPE;
                            smsVC.verifyType = self.verifyType;
                            smsVC.phoneNoStr = self.phoneNoStr;
                            [self.navigationController pushViewController:smsVC animated:YES];
                        }
                    }
                }else{
                    [Tool showDialog:@"下发鉴权工具为空"];
                }
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
