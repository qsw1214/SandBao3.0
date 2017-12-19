//
//  SandCardDetailViewController.m
//  sandbao
//
//  Created by tianNanYiHao on 2017/11/21.
//  Copyright © 2017年 sand. All rights reserved.
//

#import "SandCardDetailViewController.h"
#import "PayNucHelper.h"

#import "GradualView.h"
typedef void(^SandCardStateBlock)(NSArray *paramArr);
@interface SandCardDetailViewController ()<SDPayViewDelegate>
{
    GradualView *headView;
    
    NSString *accPassword; //accPass字符串
}
/**
 支付工具控件
 */
@property (nonatomic, strong) SDPayView *payView;
@end

@implementation SandCardDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self create_HeadView];
    [self create_BodyView];
    [self create_PayView];
    
}


#pragma mark - 重写父类-baseScrollView设置
- (void)setBaseScrollview{
    [super setBaseScrollview];
    
}
#pragma mark - 重写父类-导航设置方法
- (void)setNavCoverView{
    [super setNavCoverView];
    self.navCoverView.style = NavCoverStyleWhite;
    self.navCoverView.letfImgStr = @"login_icon_back";
    self.navCoverView.midTitleStr = @"杉德卡详情";
    
    __weak SandCardDetailViewController *weakSelf = self;
    self.navCoverView.leftBlock = ^{
        [weakSelf.navigationController popViewControllerAnimated:YES];
    };
    
}
#pragma mark - 重写父类-点击方法集合
- (void)buttonClick:(UIButton *)btn{
    
    //web跳转
    if (btn.tag == BTN_TAG_ENTERWEBVC) {
        
    }
    //解绑卡
    if (btn.tag == BTN_TAG_UNBINDCARD) {
        [self unbingding_getAuthTools];
    }
}

#pragma mark  - UI绘制

- (void)create_HeadView{
    
    //headView
    headView = [[GradualView alloc] init];
    [headView setRect:CGRectMake(LEFTRIGHTSPACE_00, UPDOWNSPACE_0, SCREEN_WIDTH, UPDOWNSPACE_197)];
    [self.baseScrollView addSubview:headView];
    
    [headView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.baseScrollView.mas_top);
        make.left.equalTo(self.baseScrollView.mas_left);
        make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH, UPDOWNSPACE_197));
    }];
    
    //balanceLab
    UILabel *balanceLab = [Tool createLable:@"余额" attributeStr:nil font:FONT_16_PingFangSC_Light textColor:COLOR_FFFFFF alignment:NSTextAlignmentCenter];
    [headView addSubview:balanceLab];
    
    //moneyLab
    UILabel *moneyLab = [Tool createLable:@"¥256.90" attributeStr:nil font:FONT_50_SFUDisplay_Regular textColor:COLOR_FFFFFF alignment:NSTextAlignmentCenter];
    [headView addSubview:moneyLab];
    
    //dataLab
    UILabel *dataLab = [Tool createLable:@"有效期: 2011.9.10-2019.9.10" attributeStr:nil font:FONT_10_PingFangSC_Light textColor:COLOR_FFFFFF alignment:NSTextAlignmentCenter];
    [headView addSubview:dataLab];
    
    [balanceLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(headView.mas_top).offset(UPDOWNSPACE_34);
        make.centerX.equalTo(headView);
        make.size.mas_equalTo(balanceLab.size);
    }];
    
    [moneyLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(balanceLab.mas_bottom).offset(UPDOWNSPACE_05);
        make.centerX.equalTo(headView);
        make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH, moneyLab.height));
    }];
    
    [dataLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(moneyLab.mas_bottom).offset(UPDOWNSPACE_16);
        make.centerX.equalTo(headView);
        make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH, dataLab.height));
    }];
    
}

- (void)create_BodyView{
    
    
    //cardDetailLab
    UILabel *cardDetailLab = [Tool createLable:@"卡片详情" attributeStr:nil font:FONT_12_Regular textColor:COLOR_343339 alignment:NSTextAlignmentCenter];
    [headView addSubview:cardDetailLab];
    
    //detailView
    UIView *detailView = [[UIView alloc] init];
    detailView.backgroundColor = COLOR_FFFFFF;
    detailView.layer.borderColor = COLOR_343339_5.CGColor;
    detailView.layer.borderWidth = 0.5f;
    [self.baseScrollView addSubview:detailView];
    
    //cardInstructionLab
    UILabel *cardInstructionLab = [Tool createLable:@"卡片使用说明" attributeStr:nil font:FONT_12_Regular textColor:COLOR_343339 alignment:NSTextAlignmentCenter];
    [self.baseScrollView addSubview:cardInstructionLab];
    
    //cardWebBtn
    UIButton *cardWebBtn = [Tool createButton:@"http://www.sandlife.com.cn" attributeStr:nil font:FONT_12_Regular textColor:COLOR_FF5D31];
    cardWebBtn.tag = BTN_TAG_ENTERWEBVC;
    [cardWebBtn addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.baseScrollView addSubview:cardWebBtn];
    
    //line
    UIView *line = [[UIView alloc] init];
    line.backgroundColor = COLOR_A1A2A5_3;
    line.size = CGSizeMake(SCREEN_WIDTH - 2*LEFTRIGHTSPACE_45, 1);
    [self.baseScrollView addSubview:line];
    
    
    //carQrCodeLab
    UILabel *carQrCodeLab = [Tool createLable:@"卡片二维码" attributeStr:nil font:FONT_12_Regular textColor:COLOR_343339 alignment:NSTextAlignmentCenter];
    [self.baseScrollView addSubview:carQrCodeLab];
    
    UIImage *qrImg = [UIImage imageNamed:@"set_erCode"];
    UIImageView *qrCodeImgView = [Tool createImagView:qrImg];
    [self.baseScrollView addSubview:qrCodeImgView];
    
    //unBingdingBtn
    UIButton *unBingdingBtn = [Tool createBarButton:@"解绑" font:FONT_15_Regular titleColor:COLOR_FFFFFF backGroundColor:COLOR_58A5F6 leftSpace:LEFTRIGHTSPACE_40];
    unBingdingBtn.tag = BTN_TAG_UNBINDCARD;
    [unBingdingBtn addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.baseScrollView addSubview:unBingdingBtn];
    
    
    
    [cardDetailLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(headView.mas_bottom).offset(UPDOWNSPACE_30);
        make.centerX.equalTo(self.baseScrollView);
        make.size.mas_equalTo(cardDetailLab.size);
    }];
    
    [detailView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(cardDetailLab.mas_bottom).offset(UPDOWNSPACE_14);
        make.left.equalTo(self.baseScrollView.mas_left).offset(LEFTRIGHTSPACE_45);
        make.size.mas_equalTo(CGSizeMake(LEFTRIGHTSPACE_286, UPDOWNSPACE_100));
    }];
    
    [cardInstructionLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(detailView.mas_bottom).offset(UPDOWNSPACE_16);
        make.centerX.equalTo(self.baseScrollView);
        make.size.mas_equalTo(cardInstructionLab.size);
    }];
   
    [cardWebBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(cardInstructionLab.mas_bottom).offset(UPDOWNSPACE_25);
        make.centerX.equalTo(self.baseScrollView);
        make.size.mas_equalTo(cardWebBtn.size);
    }];
    
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(cardWebBtn.mas_bottom).offset(UPDOWNSPACE_0);
        make.centerX.equalTo(self.baseScrollView);
        make.size.mas_equalTo(line.size);
    }];
    
    
    [carQrCodeLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(cardWebBtn.mas_bottom).offset(UPDOWNSPACE_20);
        make.centerX.equalTo(self.baseScrollView);
        make.size.mas_equalTo(carQrCodeLab.size);
    }];
    
    [qrCodeImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(carQrCodeLab.mas_bottom).offset(UPDOWNSPACE_20);
        make.centerX.equalTo(self.baseScrollView);
        make.size.mas_equalTo(qrCodeImgView.size);
    }];
    
    [unBingdingBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(qrCodeImgView.mas_bottom).offset(UPDOWNSPACE_30);
        make.centerX.equalTo(self.baseScrollView);
        make.size.mas_equalTo(unBingdingBtn.size);
    }];
}

-(void)create_PayView{
    
    self.payView = [SDPayView getPayView];
    self.payView.style = SDPayViewOnlyPwd;
    self.payView.delegate = self;
    [[UIApplication sharedApplication].keyWindow addSubview:self.payView];
    
    
}

#pragma mark - SDPayViewDelegate
- (void)payViewPwd:(NSString *)pwdStr paySuccessView:(SDPaySuccessAnimationView *)successView{
    
    //动画开始
    [successView animationStart];
    accPassword = pwdStr;
    [self unbandCardSuccessBlock:^(NSArray *paramArr){
        //解绑成功
        [successView animationSuccess];
        dispatch_time_t delayTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5f * NSEC_PER_SEC));
        dispatch_after(delayTime, dispatch_get_main_queue(), ^{
            
        });
    } errorBlock:^(NSArray *paramArr){
        //解绑失败
        [successView animationStopClean];
        [self.payView hidPayTool];
        [Tool showDialog:@"解绑失败"];
    }];
}

- (void)payViewForgetPwd:(NSString *)type{
    
    if ([type isEqualToString:PAYTOOL_PAYPASS]) {
        //修改支付密码
    }
    if ([type isEqualToString:PAYTOOL_ACCPASS]) {
        //修改杉德卡密码
    }
    
}

#pragma mark - 业务逻辑
#pragma mark 解绑_查询鉴权工具
- (void)unbingding_getAuthTools
{
    self.HUD = [SDMBProgressView showSDMBProgressOnlyLoadingINViewImg:self.view];
    [SDRequestHelp shareSDRequest].HUD = self.HUD;
    [SDRequestHelp shareSDRequest].controller = self;
    [[SDRequestHelp shareSDRequest] dispatchGlobalQuque:^{
        __block BOOL error = NO;
        paynuc.set("tTokenType", "01001801");
        paynuc.set("cfg_termFp", [[Tool setCfgTempFpStaticDataFlag:NO DynamicDataFlag:YES] UTF8String]);
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
                
                //弹出密码框
                [self.payView setPayInfo:tempAuthToolsArray moneyStr:nil orderTypeStr:nil];
                [self.payView showPayTool];
                
            }];
        }];
        if (error) return ;
    }];
}


#pragma mark 解绑杉德卡
- (void)unbandCardSuccessBlock:(SandCardStateBlock)successBlock errorBlock:(SandCardStateBlock)errorBlock
{
    self.HUD = [SDMBProgressView showSDMBProgressOnlyLoadingINViewImg:self.view];
    [self.HUD hidden];
    [SDRequestHelp shareSDRequest].HUD = self.HUD;
    [SDRequestHelp shareSDRequest].controller = self;
    [[SDRequestHelp shareSDRequest] dispatchGlobalQuque:^{
        __block BOOL error = NO;
        
        NSMutableArray *tempAuthToolsArray = [[NSMutableArray alloc] init];
        NSMutableDictionary *authToolsDic = [NSMutableDictionary dictionaryWithCapacity:0];
        NSMutableDictionary *passDic = [[NSMutableDictionary alloc] init];
        [passDic setValue:[[PayNucHelper sharedInstance] pinenc:accPassword type:@"accpass"] forKey:@"password"];
        [passDic setValue:@"" forKey:@"description"];
        [passDic setValue:@"" forKey:@"encryptType"];
        [passDic setValue:@"" forKey:@"regular"];
        [authToolsDic setObject:passDic forKey:@"pass"];
        [authToolsDic setObject:@"accpass" forKey:@"type"];
        [tempAuthToolsArray addObject:authToolsDic];
        
        NSString *authTools = [[PayNucHelper sharedInstance] arrayToJSON:tempAuthToolsArray];
        
        NSString *payTool = [[PayNucHelper sharedInstance] dictionaryToJson:(NSMutableDictionary*)self.payToolDic];
        
        paynuc.set("payTool", [payTool UTF8String]);
        paynuc.set("authTools", [authTools UTF8String]);
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



@end
