//
//  PayQrcodeViewController.m
//  sandbao
//
//  Created by tianNanYiHao on 2017/12/5.
//  Copyright © 2017年 sand. All rights reserved.
//

#import "PayQrcodeViewController.h"
#import "SDSelectBarView.h"
#import "SDQrcodeView.h"
#import "ScannerViewController.h"
@interface PayQrcodeViewController ()
{
    
}

@property (nonatomic, strong) UIView *collectionQrcodeBaseView;//收款码基础视图
@property (nonatomic, strong) UIView *payQrcodeBaseView;//付款码基础视图

/**
 选择视图
 */
@property (nonatomic, strong) SDSelectBarView *selectBarView;

/**
 收款码视图
 */
@property (nonatomic, strong) SDQrcodeView *collectionQrcodeView;
/**
 付款码视图
 */
@property (nonatomic, strong) SDQrcodeView *payQrcodeView;
@end

@implementation PayQrcodeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self creaetUI];
    
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
    self.navCoverView.rightImgStr = @"searchpage_saoyisao";
    self.navCoverView.midTitleStr = @"收付款";
    
    __weak PayQrcodeViewController *weakSelf = self;
    self.navCoverView.leftBlock = ^{
        [weakSelf.navigationController popViewControllerAnimated:YES];
    };
    self.navCoverView.rightBlock = ^{
        //@"扫一扫"
        ScannerViewController *mScannerViewController = [[ScannerViewController alloc] init];
        [weakSelf.navigationController pushViewController:mScannerViewController animated:YES];
    };
    
}
#pragma mark - 重写父类-点击方法集合
- (void)buttonClick:(UIButton *)btn{
    
    
}


#pragma mark  - UI绘制
- (void)creaetUI{
    
    __weak typeof(self) weakself = self;
    self.selectBarView = [SDSelectBarView showSelectBarView:@[@"收款码",@"付款码"] selectBarBlock:^(NSInteger index) {
        switch (index) {
            case 0:
            {
                if (weakself.payQrcodeBaseView) {
                    [UIView animateWithDuration:0.2 animations:^{
                        weakself.payQrcodeBaseView.alpha = 0;
                    } completion:^(BOOL finished) {
                        [weakself.payQrcodeBaseView removeFromSuperview];
                        //创建 收款码 视图
                        [weakself createCollectionQrView];
                    }];
                }
                
            }
                break;
                
            case 1:
            {
                if (weakself.collectionQrcodeBaseView) {
                    [UIView animateWithDuration:0.2 animations:^{
                        weakself.collectionQrcodeBaseView.alpha = 0;
                    } completion:^(BOOL finished) {
                        [weakself.collectionQrcodeBaseView removeFromSuperview];
                        //创建 付款码 视图
                        [weakself creaetPayQrView];
                    }];
                }
            }
                break;
            default:
                break;
        }
        
    }];
    
    [self.baseScrollView addSubview:self.selectBarView];
    
    //默认展示 收款码
    [self createCollectionQrView];
    
    [self.selectBarView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.baseScrollView.mas_top).offset(UPDOWNSPACE_11);
        make.centerX.equalTo(self.baseScrollView.mas_centerX);
        make.size.mas_equalTo(self.selectBarView.size);
    }];
    
}

- (void)createCollectionQrView{
    
    self.collectionQrcodeBaseView = [[UIView alloc] init];
    self.collectionQrcodeBaseView.backgroundColor = self.baseScrollView.backgroundColor;
    [self.baseScrollView addSubview:self.collectionQrcodeBaseView];
    
    self.collectionQrcodeView = [[SDQrcodeView alloc] initWithFrame:CGRectZero];
    self.collectionQrcodeView.roundRLColor = self.baseScrollView.backgroundColor;
    self.collectionQrcodeView.titleStr = @"个人收钱";
    self.collectionQrcodeView.qrCodeDesStr = @"杉德宝扫一扫,向我付钱";
    self.collectionQrcodeView.qrCodeStr = @"这里是二维码信息字符串";
    [self.collectionQrcodeView createSetMoneyBtnView];
    [self.collectionQrcodeBaseView addSubview:self.collectionQrcodeView];
    
    CGFloat collectionQrcodeBaseViewH = self.collectionQrcodeView.height;
    
    [self.collectionQrcodeBaseView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.selectBarView.mas_bottom).offset(UPDOWNSPACE_10);
        make.centerX.equalTo(self.baseScrollView);
        make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH, collectionQrcodeBaseViewH));
    }];
    
    [self.collectionQrcodeView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.collectionQrcodeBaseView);
        make.centerX.equalTo(self.collectionQrcodeBaseView.mas_centerX);
        make.size.mas_equalTo(self.collectionQrcodeView.size);
    }];
    
}

- (void)creaetPayQrView{
    
    self.payQrcodeBaseView = [[UIView alloc] init];
    self.payQrcodeBaseView.backgroundColor = self.baseScrollView.backgroundColor;
    [self.baseScrollView addSubview:self.payQrcodeBaseView];
    
    self.payQrcodeView = [[SDQrcodeView alloc] initWithFrame:CGRectZero];
    self.payQrcodeView.roundRLColor = self.baseScrollView.backgroundColor;
    self.payQrcodeView.titleStr = @"向商家付款";
    self.payQrcodeView.qrCodeDesStr = @"杉德宝扫一扫,向商家付款";
    self.payQrcodeView.payToolNameStr = @"杉德卡";
    self.payQrcodeView.qrCodeStr = @"这里是二维码信息字符串";
    [self.payQrcodeView createPayToolShowView];
    [self.payQrcodeBaseView addSubview:self.payQrcodeView];
    
    //bottomTip
    UILabel *bottomTipLab = [Tool createLable:@"如付款失败,请尝试其他付款方式" attributeStr:nil font:FONT_12_Regular textColor:COLOR_343339 alignment:NSTextAlignmentCenter];
    [self.payQrcodeBaseView addSubview:bottomTipLab];
    
    
    CGFloat payQrcodeBaseViewH = self.payQrcodeView.height + UPDOWNSPACE_15;
    
    [self.payQrcodeBaseView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.selectBarView.mas_bottom).offset(UPDOWNSPACE_10);
        make.centerX.equalTo(self.baseScrollView);
        make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH, payQrcodeBaseViewH));
    }];
    
    [self.payQrcodeView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.payQrcodeBaseView);
        make.centerX.equalTo(self.payQrcodeBaseView.mas_centerX);
        make.size.mas_equalTo(self.payQrcodeView.size);
    }];
    
    [bottomTipLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.payQrcodeView.mas_bottom).offset(UPDOWNSPACE_15);
        make.centerX.equalTo(self.payQrcodeBaseView);
        make.size.mas_equalTo(bottomTipLab.size);
    }];
}


#pragma mark - 本类公共方法调用

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
