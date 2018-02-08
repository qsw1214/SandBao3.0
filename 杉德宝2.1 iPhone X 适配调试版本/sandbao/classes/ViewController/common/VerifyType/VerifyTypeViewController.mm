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
    
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    //请求鉴权工具集组
    [self getAuthCroups];
    
    [self createUI];
    
   
}

#pragma mark - 重写父类-baseScrollView设置
- (void)setBaseScrollview{
    [super setBaseScrollview];
    
}
#pragma mark - 重写父类-导航设置方法
- (void)setNavCoverView{
    [super setNavCoverView];
    
    //未设置过支付密码
    if ([CommParameter sharedInstance].payPassFlag == NO) {
        //从首页跳转进入的修改支付密码
        if (self.setPayPassFromeHomeNav) {
            self.navCoverView.letfImgStr = @"login_icon_back";
            __weak VerifyTypeViewController *weakSelf = self;
            self.navCoverView.leftBlock = ^{
                [Tool showDialog:@"您还未设置支付密码" message:@"是否放弃设置" leftBtnString:@"继续设置" rightBtnString:@"退出杉德宝" leftBlock:^{
                    //do no thing
                } rightBlock:^{
                    [Tool setContentViewControllerWithLoginFromSideMentuVIewController:weakSelf forLogOut:YES];
                }];
            };
        }
        //非首页跳转进入的修改支付密码
        else if (self.needGoBackIcon) {
            self.navCoverView.letfImgStr = @"login_icon_back";
            __weak VerifyTypeViewController *weakSelf = self;
            self.navCoverView.leftBlock = ^{
                [weakSelf.navigationController popViewControllerAnimated:YES];
            };
        }else{
            self.navCoverView.hidden = YES;
        }
        
    }
    //已设置过支付密码
    else{
        self.navCoverView.letfImgStr = @"login_icon_back";
        __weak VerifyTypeViewController *weakSelf = self;
        if (self.popToRoot) {
            self.navCoverView.leftBlock = ^{
                [weakSelf.navigationController popToRootViewControllerAnimated:YES];
            };
        }else{
            self.navCoverView.leftBlock = ^{
                [weakSelf.navigationController popViewControllerAnimated:YES];
            };
        }
        
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
    
    //过滤仅短信验证方式!
    if ([[self.authGroupTypeDic objectForKey:@"title"] isEqualToString:@"短信验证"]) {
        [Tool showDialog:@"推荐短信+N校验方式,确保账户安全!"];
    }else{
        //根据所选鉴权方式_获取鉴权工具
        [self getAuthToolsfForAuthGroup];
    }
    
    
    
}


#pragma mark - 业务逻辑
#pragma mark 查询鉴权工具集组
- (void)getAuthCroups{
    
   
    
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
