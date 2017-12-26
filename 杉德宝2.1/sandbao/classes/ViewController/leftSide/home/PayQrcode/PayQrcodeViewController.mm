//
//  PayQrcodeViewController.m
//  sandbao
//
//  Created by tianNanYiHao on 2017/12/5.
//  Copyright © 2017年 sand. All rights reserved.
//

#import "PayQrcodeViewController.h"
#import "PayNucHelper.h"

#import "SDSelectBarView.h"
#import "SDQrcodeView.h"

@interface PayQrcodeViewController ()
{
    
}
@property (nonatomic, strong) NSMutableArray *authCodesArray; //授权码数组
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

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];

}

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
    self.navCoverView.midTitleStr = @"收付款";
    
    __weak PayQrcodeViewController *weakSelf = self;
    self.navCoverView.leftBlock = ^{
        [weakSelf.navigationController popViewControllerAnimated:YES];
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
                        
                        if (weakself.authCodesArray.count == 0) {
                            //点击获取授权码
                            [weakself getAuthCodes];
                        }else{
                            //创建 付款码 视图
                            [weakself creaetPayQrView];
                        }
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
    self.collectionQrcodeView.style = CollectionQrcordView;
    self.collectionQrcodeView.roundRLColor = self.baseScrollView.backgroundColor;
    self.collectionQrcodeView.twoQrCodeStr = @"这里是二维码信息字符串";
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
    
    NSDictionary *authCodeDic = [self.authCodesArray firstObject];
    NSString *authCode = [authCodeDic objectForKey:@"code"];
    
    self.payQrcodeBaseView = [[UIView alloc] init];
    self.payQrcodeBaseView.backgroundColor = self.baseScrollView.backgroundColor;
    [self.baseScrollView addSubview:self.payQrcodeBaseView];
    
    self.payQrcodeView = [[SDQrcodeView alloc] initWithFrame:CGRectZero];
    self.payQrcodeView.style = PayQrcodeView;
    self.payQrcodeView.roundRLColor = self.baseScrollView.backgroundColor;
    self.payQrcodeView.oneQrCodeStr = authCode;
    self.payQrcodeView.twoQrCodeStr = authCode;
    self.payQrcodeView.payToolNameStr = @"杉德卡";
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
#pragma mark - 业务逻辑
#pragma mark 获取授权码组
- (void)getAuthCodes
{
    self.HUD = [SDMBProgressView showSDMBProgressOnlyLoadingINViewImg:self.view];
    [SDRequestHelp shareSDRequest].HUD = self.HUD;
    [SDRequestHelp shareSDRequest].controller = self;
    [[SDRequestHelp shareSDRequest] dispatchGlobalQuque:^{
        __block BOOL error = NO;
        paynuc.set("tTokenType", "04000301");
        [[SDRequestHelp shareSDRequest] requestWihtFuncName:@"token/getTtoken/v1" errorBlock:^(SDRequestErrorType type) {
            error = YES;
        } successBlock:^{
            
        }];
        if (error) return ;
        
        [[SDRequestHelp shareSDRequest] requestWihtFuncName:@"user/getAuthCodes/v1" errorBlock:^(SDRequestErrorType type) {
            error = YES;
        } successBlock:^{
            [[SDRequestHelp shareSDRequest] dispatchToMainQueue:^{
                [self.HUD hidden];
                
                NSString *authCodes = [NSString stringWithUTF8String:paynuc.get("authCodes").c_str()];
                NSArray *tempArray = [[PayNucHelper sharedInstance] jsonStringToArray:authCodes];
                //授权码获取
                self.authCodesArray = [NSMutableArray arrayWithCapacity:0];
                for (int i = 0; i < tempArray.count; i++) {
                    [self.authCodesArray addObject:tempArray[i]];
                }
                //创建 付款码 视图
                [self creaetPayQrView];
            }];
        }];
        
        if (error) return ;
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
