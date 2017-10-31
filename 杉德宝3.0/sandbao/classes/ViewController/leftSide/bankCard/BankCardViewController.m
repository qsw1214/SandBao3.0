//
//  BankCardViewController.m
//  sandbao
//
//  Created by tianNanYiHao on 2017/10/27.
//  Copyright © 2017年 sand. All rights reserved.
//

#import "BankCardViewController.h"

#import "BankItemTableViewCell.h"


@interface BankCardViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    
}
@property (nonatomic, strong) UITableView *bankTableView;
@end

@implementation BankCardViewController

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    // 禁用返回手势
    if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.navigationController.interactivePopGestureRecognizer.enabled = NO;
    }
    //允许RESideMenu的返回手势
    self.sideMenuViewController.panGestureEnabled = YES;
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
    self.navCoverView.midTitleStr = @"银行卡";
    
    __block BankCardViewController *weakSelf = self;
    self.navCoverView.leftBlock = ^{
        [weakSelf presentLeftMenuViewController:weakSelf.sideMenuViewController];
    };
}
#pragma mark - 重写父类-点击方法集合
- (void)buttonClick:(UIButton *)btn{
    

    
    
    
}


#pragma mark - 业务逻辑
- (void)createUI{
    
    self.bankTableView = [[UITableView alloc] init];
    self.bankTableView.delegate = self;
    self.bankTableView.dataSource = self;
    self.bankTableView.scrollEnabled = YES;
    self.bankTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.baseScrollView addSubview:self.bankTableView];
    self.automaticallyAdjustsScrollViewInsets = NO;

}

#pragma mark tableViewDelegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 4;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //获得cell
    static NSString *cellIdentfier = @"cell";
    BankItemTableViewCell *mBankItemTableViewCell = [tableView dequeueReusableCellWithIdentifier:cellIdentfier];
//    NSDictionary *dic = bankArray[indexPath.row];
//    
//    //创建cell
//    if (mBankItemTableViewCell == nil) {
//        mBankItemTableViewCell = [[BankItemTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentfier];
//        
//        mBankItemTableViewCell.cellHeight = cellHeight;
//        mBankItemTableViewCell.viewSize = viewSize;
//        mBankItemTableViewCell.dicData = dic;
//        
//    } else {
//        mBankItemTableViewCell.cellHeight = cellHeight;
//        mBankItemTableViewCell.viewSize = viewSize;
//        mBankItemTableViewCell.dicData = dic;
//    }
    mBankItemTableViewCell.selectionStyle = UITableViewCellSelectionStyleNone;
    return mBankItemTableViewCell;
}

/**
 *@brief 设置改变行的高度
 *@return
 */
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 44;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell * cell = [tableView cellForRowAtIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    
    
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
