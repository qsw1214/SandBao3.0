//
//  SandUserTransferViewController.m
//  sandbao
//
//  Created by tianNanYiHao on 2017/10/30.
//  Copyright © 2017年 sand. All rights reserved.
//

#import "SandUserTransferViewController.h"

#import "SandUserTransferSecViewController.h"
#import "SDSearchPop.h"

@interface SandUserTransferViewController ()

@end

@implementation SandUserTransferViewController

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
    
    __block SandUserTransferViewController *selfBlock = self;
    self.navCoverView.leftBlock = ^{
        [selfBlock.navigationController popViewControllerAnimated:YES];
    };
    
    self.navCoverView.rightBlock = ^{
        NSLog(@"打印了搜索按钮");

    };
    
    
}
#pragma mark - 重写父类-点击方法集合
- (void)buttonClick:(UIButton *)btn{
    
    if (btn.tag == BTN_TAG_SEARCH) {
      
        
        [SDSearchPop showSearchPopViewPlaceholder:@"杉德宝账户" textBlock:^(NSString *text) {
            //转账第二步
            SandUserTransferSecViewController *transferSecVC = [[SandUserTransferSecViewController alloc] init];
            [self.navigationController pushViewController:transferSecVC animated:YES];
            
            
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
