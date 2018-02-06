//
//  AboutUSViewController.m
//  sandbao
//
//  Created by tianNanYiHao on 2017/10/31.
//  Copyright © 2017年 sand. All rights reserved.
//

#import "AboutUSViewController.h"
#import "SetCellView.h"
#import "DefaultWebViewController.h"
@interface AboutUSViewController ()
{
    
    UIView *headView;
    UIView *bodyView;
    
}
@end

@implementation AboutUSViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self create_HeadView];
    [self create_BodyView];
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
    self.navCoverView.midTitleStr = @"关于我们";
    
    __weak AboutUSViewController *weakSelf = self;
    self.navCoverView.leftBlock = ^{
        [weakSelf.navigationController popViewControllerAnimated:YES];
    };
    
}
#pragma mark - 重写父类-点击方法集合
- (void)buttonClick:(UIButton *)btn{
    
    if (btn.tag == BTN_TAG_VERSION) {
        NSLog(@"版本说明");
        DefaultWebViewController *webVC = [[DefaultWebViewController alloc] init];
        webVC.requestStr = [NSString stringWithFormat:@"%@%@",AddressHTTP,ot_help_normal_FAQ];
        [self.navigationController pushViewController:webVC animated:YES];
    }
    if (btn.tag == BTN_TAG_TOSTAR) {
        NSLog(@"去评分");
        [SDMBProgressView showSDMBProgressNormalINView:self.view lableText:@"努力开发中..."];
    }
    if (btn.tag == BTN_TAG_ABOUTSAND) {
        NSLog(@"杉德宝隐私政策");
        [SDMBProgressView showSDMBProgressNormalINView:self.view lableText:@"努力开发中..."];
        
        
    }
    
}


#pragma mark  - UI绘制
- (void)create_HeadView{
    
    
    //headView
    headView = [[UIView alloc] init];
    headView.backgroundColor = COLOR_F5F5F5;
    [self.baseScrollView addSubview:headView];
    
    
    //titleLab
    NSString *strVersion = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"] ;
    NSString *strVersionInfo = [NSString stringWithFormat:@"@杉德宝AppStore版本号: %@",strVersion];
    UILabel *titleLab = [Tool createLable:strVersionInfo attributeStr:nil font:FONT_18_Regular textColor:COLOR_343339 alignment:NSTextAlignmentCenter];
    [self.baseScrollView addSubview:titleLab];
    
    //erCodeImgView
    UIImage *erCodeImg = [UIImage imageNamed:@"set_erCode"];
    
    UIImageView *erCodeImgView = [Tool createImagView:[Tool twoDimensionCodeWithStr:@"https://sdb.sandpay.com.cn" size:erCodeImg.size.height]];
    [self.baseScrollView addSubview:erCodeImgView];
    
    //titlDesLab
    UILabel *titlDesLab = [Tool createLable:@"扫描二维码,您的朋友也可以下载杉德宝" attributeStr:nil font:FONT_12_Regular textColor:COLOR_343339_7 alignment:NSTextAlignmentCenter];
    [self.baseScrollView addSubview:titlDesLab];
    
    headView.height = UPDOWNSPACE_30 * 2 + UPDOWNSPACE_20 * 2 + titleLab.height + erCodeImg.size.height + titlDesLab.height;
    
    [headView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.baseScrollView.mas_top).offset(UPDOWNSPACE_0);
        make.centerX.equalTo(self.baseScrollView.mas_centerX);
        make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH, headView.height));
    }];
    
    [titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(headView.mas_top).offset(UPDOWNSPACE_30);
        make.centerX.equalTo(headView.mas_centerX);
        make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH, titleLab.height));
    }];
    
    [erCodeImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(titleLab.mas_bottom).offset(UPDOWNSPACE_20);
        make.centerX.equalTo(headView.mas_centerX);
        make.size.mas_equalTo(erCodeImg.size);
    }];
    
    [titlDesLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(erCodeImgView.mas_bottom).offset(UPDOWNSPACE_20);
        make.centerX.equalTo(headView.mas_centerX);
        make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH, titlDesLab.height));
    }];
}


- (void)create_BodyView{
    
    __weak typeof(self) weakself = self;
    
    bodyView = [[UIView alloc] init];
    bodyView.backgroundColor = COLOR_FFFFFF;
    [self.baseScrollView addSubview:bodyView];

    
    //versionCell
    SetCellView *versionCell = [SetCellView createSetCellViewOY:0];
    versionCell.titleStr = @"版本说明";
    versionCell.clickBlock = ^{
        UIButton *btn = [UIButton new];
        btn.tag = BTN_TAG_VERSION;
        [weakself performSelector:@selector(buttonClick:) withObject:btn];
    };
    [self.baseScrollView addSubview:versionCell];
    

    //starCell
    SetCellView *starCell = [SetCellView createSetCellViewOY:0];
    starCell.titleStr = @"去评分";
    starCell.clickBlock = ^{
        UIButton *btn = [UIButton new];
        btn.tag = BTN_TAG_TOSTAR;
        [weakself performSelector:@selector(buttonClick:) withObject:btn];
    };
    [self.baseScrollView addSubview:starCell];

    //aboutSandBaoCell
    SetCellView *aboutSandBaoCell = [SetCellView createSetCellViewOY:0];
    aboutSandBaoCell.line.hidden = YES;
    aboutSandBaoCell.titleStr = @"杉德宝隐私政策";
    aboutSandBaoCell.clickBlock = ^{
        UIButton *btn = [UIButton new];
        btn.tag = BTN_TAG_ABOUTSAND;
        [weakself performSelector:@selector(buttonClick:) withObject:btn];
    };
    [self.baseScrollView addSubview:aboutSandBaoCell];
    
    bodyView.height = versionCell.height * 3;
    
    [bodyView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(headView.mas_bottom);
        make.centerX.equalTo(self.baseScrollView.mas_centerX);
        make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH, bodyView.height));
    }];
    
    [versionCell mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(bodyView.mas_top);
        make.centerX.equalTo(bodyView.mas_centerX);
        make.size.mas_equalTo(versionCell.size);
    }];
    
    [starCell mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(versionCell.mas_bottom);
        make.centerX.equalTo(bodyView.mas_centerX);
        make.size.mas_equalTo(starCell.size);
    }];
    
    [aboutSandBaoCell mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(starCell.mas_bottom);
        make.centerX.equalTo(bodyView.mas_centerX);
        make.size.mas_equalTo(aboutSandBaoCell.size);
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
