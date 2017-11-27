//
//  NickNameViewController.m
//  sandbao
//
//  Created by tianNanYiHao on 2017/11/17.
//  Copyright © 2017年 sand. All rights reserved.
//

#import "NickNameViewController.h"
#import "PayNucHelper.h"

@interface NickNameViewController ()
{
    
}
@property (nonatomic, strong) NSString *nickNameStr;
@end

@implementation NickNameViewController

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
    self.navCoverView.midTitleStr = @"昵称修改";
    
    __weak NickNameViewController *weakSelf = self;
    self.navCoverView.leftBlock = ^{
        [weakSelf.navigationController popViewControllerAnimated:YES];
    };
    
    
}

#pragma mark - 重写父类-点击方法集合
- (void)buttonClick:(UIButton *)btn{
    
    [self.baseScrollView endEditing:YES];
    
    if (btn.tag == BTN_TAG_NEXT) {
        if (self.nickNameStr.length>0) {
            
            //修改用户基础信息(昵称)
            [self resetUserBaseInfo];
        }else{
            [Tool showDialog:@"请输入您的昵称信息"];
        }
    }
}


#pragma mark  - UI绘制
- (void)createUI{
    __weak typeof(self) weakself = self;
    //nickNameAuthToolView
    NameAuthToolView *nickNameAuthToolView = [NameAuthToolView createAuthToolViewOY:0];
    nickNameAuthToolView.titleLab.text = @"昵称";
    nickNameAuthToolView.textfiled.placeholder = @"请填写您的昵称";
    nickNameAuthToolView.tip.text = @"请正确输入您的昵称";
    nickNameAuthToolView.successBlock = ^(NSString *textfieldText) {
        weakself.nickNameStr = textfieldText;
    };
    [self.baseScrollView addSubview:nickNameAuthToolView];
    
    //nextBtn
    UIButton *nextBarbtn = [Tool createBarButton:@"提交" font:FONT_15_Regular titleColor:COLOR_FFFFFF backGroundColor:COLOR_58A5F6 leftSpace:LEFTRIGHTSPACE_40];
    nextBarbtn.tag = BTN_TAG_NEXT;
    [nextBarbtn addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.baseScrollView addSubview:nextBarbtn];
    
    [nickNameAuthToolView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.baseScrollView.mas_top).offset(UPDOWNSPACE_30);
        make.centerX.equalTo(self.baseScrollView);
        make.size.mas_equalTo(nickNameAuthToolView.size);
    }];
    
    [nextBarbtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(nickNameAuthToolView.mas_bottom).offset(UPDOWNSPACE_40);
        make.centerX.equalTo(self.baseScrollView.mas_centerX);
        make.size.mas_equalTo(nextBarbtn.size);
    }];
    
    
}





#pragma mark - 业务逻辑
#pragma mark 用户基础信息修改
-(void)resetUserBaseInfo{
    
    self.HUD = [SDMBProgressView showSDMBProgressOnlyLoadingINViewImg:self.view];
    [SDRequestHelp shareSDRequest].HUD = self.HUD;
    [SDRequestHelp shareSDRequest].controller = self;
    [[SDRequestHelp shareSDRequest] dispatchGlobalQuque:^{
        __block BOOL error = NO;
        paynuc.set("tTokenType", "01002001");
        [[SDRequestHelp shareSDRequest] requestWihtFuncName:@"token/getTtoken/v1" errorBlock:^(SDRequestErrorType type) {
            error = YES;
        } successBlock:^{
            
        }];
        if (error) return ;
        
        
        NSMutableDictionary *userInfo = [NSMutableDictionary dictionaryWithCapacity:0];
        [userInfo setValue:self.nickNameStr forKey:@"nick"];
        [userInfo setValue:@"" forKey:@"avatar"];
        [userInfo setValue:@"" forKey:@"remainState"];
        NSString *userInfostr = [[PayNucHelper sharedInstance] dictionaryToJson:userInfo];
        paynuc.set("userInfo", [userInfostr UTF8String]);
        [[SDRequestHelp shareSDRequest] requestWihtFuncName:@"user/resetUserBaseInfo/v1" errorBlock:^(SDRequestErrorType type) {
            error = YES;
        } successBlock:^{
            [[SDRequestHelp shareSDRequest] dispatchToMainQueue:^{
                [self.HUD hidden];
                
                //昵称修改成功 - 通知侧边栏刷新个人信息
                [CommParameter sharedInstance].nick = self.nickNameStr;
                [[NSNotificationCenter defaultCenter] postNotificationName:@"Nick_Name_Changed" object:nil];
                
                [Tool showDialog:@"昵称修改成功" defulBlock:^{
                    [self.navigationController popViewControllerAnimated:YES];
                }];
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
