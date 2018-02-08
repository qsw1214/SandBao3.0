//
//  UserTransferBeginViewController.m
//  sandbao
//
//  Created by tianNanYiHao on 2017/10/30.
//  Copyright © 2017年 sand. All rights reserved.
//

#import "UserTransferBeginViewController.h"
#import "PayNucHelper.h"
#import "UserTransferPageViewController.h"
#import "SDSearchPop.h"

@interface UserTransferBeginViewController ()
{
    NSArray *authToolsArr;
}
@property (nonatomic, strong) NSString *otherPhoneNoStr;  //搜索的用户号
@property (nonatomic, strong) NSDictionary *otherUserInfoDic; //他方用户信息
@property (nonatomic, strong) NSArray *otherPayToolsArr;      //他方支付工具组
@property (nonatomic, strong) NSArray *ownPayToolsArr;        //我方支付工具组
@end

@implementation UserTransferBeginViewController

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    //查询且鉴权工具
    [self getAuthTools];
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
    self.navCoverView.midTitleStr = @"搜索用户";
    self.navCoverView.letfImgStr = @"general_icon_back";
    self.navCoverView.rightImgStr = @"searchpage_saoyisao";
    
    __weak UserTransferBeginViewController *weakSelf = self;
    self.navCoverView.leftBlock = ^{
        [weakSelf.navigationController popViewControllerAnimated:YES];
    };
    
    self.navCoverView.rightBlock = ^{
        //@"搜索"
        [SDMBProgressView showSDMBProgressNormalINView:weakSelf.baseScrollView lableText:@"努力开发中..."];
    };
    
    
}
#pragma mark - 重写父类-点击方法集合
- (void)buttonClick:(UIButton *)btn{
    
    if (btn.tag == BTN_TAG_SEARCH) {
        
        [SDSearchPop showSearchPopViewPlaceholder:@"杉德宝账户" textBlock:^(NSString *text) {
            if (![NSRegularExpression validateMobile:text]) {
                return [Tool showDialog:@"输入的手机号码格式不正确，请重新输入。"];
            }
            if ([text isEqualToString:[CommParameter sharedInstance].userName]) {
                 [Tool showDialog:@"转账对象不能为自己哦!"];
                return;
            }
            self.otherPhoneNoStr = text;
            //查询他方支付工具
            [self getOtherAndOwnPayTools];
        }];
    }
    
    
    
}


#pragma mark  - UI绘制

- (void)createUI{
    
    //searchBtn
    UIButton *searchUserBtn = [Tool createButton:@"" attributeStr:nil font:nil textColor:nil];
    searchUserBtn.backgroundColor = COLOR_FFFFFF;
    searchUserBtn.tag = BTN_TAG_SEARCH;
    [searchUserBtn addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.baseScrollView addSubview:searchUserBtn];
    
    //searchImgV
    UIImage *searchImg = [UIImage imageNamed:@"searchpage_icon_search_blue"];
    UIImageView *searchImgView = [Tool createImagView:searchImg];
    [self.baseScrollView addSubview:searchImgView];
    
    //searchLab
    UILabel *searchLab = [Tool createLable:@"杉德宝账户" attributeStr:nil font:FONT_15_Regular textColor:COLOR_343339_5 alignment:NSTextAlignmentLeft];
    [self.baseScrollView addSubview:searchLab];
    
    searchUserBtn.height = searchImg.size.height + UPDOWNSPACE_10*2;
    searchUserBtn.width = SCREEN_WIDTH;
    searchLab.width = SCREEN_WIDTH -  (LEFTRIGHTSPACE_25 + searchImg.size.width + LEFTRIGHTSPACE_20);
    
    
    [searchUserBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.baseScrollView.mas_top).offset(UPDOWNSPACE_20);
        make.centerX.equalTo(self.baseScrollView.mas_centerX);
        make.size.mas_equalTo(CGSizeMake(searchUserBtn.width, searchUserBtn.height));
    }];
    
    [searchImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(searchUserBtn.mas_top).offset(UPDOWNSPACE_10);
        make.left.equalTo(searchUserBtn.mas_left).offset(LEFTRIGHTSPACE_25);
        make.size.mas_equalTo(searchImg.size);
    }];
    
    [searchLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(searchUserBtn.mas_top).offset(UPDOWNSPACE_10);
        make.left.equalTo(searchImgView.mas_right).offset(LEFTRIGHTSPACE_20);
        make.size.mas_equalTo(CGSizeMake(searchLab.width, searchLab.height));
    }];
    
    
}


#pragma mark - 业务逻辑
#pragma mark 查询鉴权工具
- (void)getAuthTools{
    
   
}


#pragma mark 查询他方/我方支付工具
- (void)getOtherAndOwnPayTools{
    
   
}


/**
 检查他方支付工具/我方支付工具是否可用

 @param otherPayToolsArray 他方支付工具
 @param ownPayToolsArray 我方支付工具
 @return 结果
 */
- (BOOL)checkCanTransferByOtherPayTools:(NSArray*)otherPayToolsArray ownPayTools:(NSArray*)ownPayToolsArray{
    
    NSDictionary *ownPayToolDic =  [Tool getPayToolsInfo:ownPayToolsArray];
    NSDictionary *ownSandWalletDic = [ownPayToolDic objectForKey:@"sandWalletDic"];
    
    NSDictionary *otherPayToolDic = [Tool getPayToolsInfo:otherPayToolsArray];
    NSDictionary *otherSandWalletDic = [otherPayToolDic objectForKey:@"sandWalletDic"];
    
    if (ownSandWalletDic.count == 0 || ![[ownSandWalletDic objectForKey:@"available"] boolValue]) {
//        [Tool showDialog:@"我方无可用支付工具"];
//        return NO;
    }
    if (otherSandWalletDic.count == 0 || ![[otherSandWalletDic objectForKey:@"available"] boolValue] ) {
        [Tool showDialog:@"对方无可用支付工具"];
        return NO;
    }
    return YES;
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
