//
//  InviteViewController.m
//  sandbao
//
//  Created by tianNanYiHao on 2018/1/23.
//  Copyright © 2018年 sand. All rights reserved.
//

#import "InviteViewController.h"
#import "WXApi.h"
#import <TencentOpenAPI/TencentOAuth.h>
#import <TencentOpenAPI/QQApiInterface.h>

#import "WXApiObject.h"
#import "PayNucHelper.h"
#import "SDInvitePop.h"

@interface InviteViewController ()<WXApiDelegate,TencentSessionDelegate>

@end

@implementation InviteViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self creaetUI];
}


#pragma mark - 重写父类-baseScrollView设置
- (void)setBaseScrollview{
    [super setBaseScrollview];
    self.baseScrollView.backgroundColor = COLOR_F5F5F5;
    self.baseScrollView.scrollEnabled = NO;
    
}
#pragma mark - 重写父类-导航设置方法
- (void)setNavCoverView{
    [super setNavCoverView];
    self.navCoverView.style = NavCoverStyleWhite;
    self.navCoverView.letfImgStr = @"login_icon_back";
    self.navCoverView.midTitleStr = @"邀请好友";
    
    __weak InviteViewController *weakSelf = self;
    self.navCoverView.leftBlock = ^{
        //归位Home或SpsLunch
        [weakSelf.navigationController popViewControllerAnimated:YES];
    };
    
}
#pragma mark - 重写父类-点击方法集合
- (void)buttonClick:(UIButton *)btn{
    if (btn.tag == BTN_TAG_JUSTCLICK) {
        
        
        NSDictionary *userInfoDic = [[PayNucHelper sharedInstance] jsonStringToDictionary:[CommParameter sharedInstance].userInfo];
        NSString *inviteCode = [userInfoDic objectForKey:@"inviteCode"];
        
        NSDictionary *inviteInfo = @{@"icon":@[@"icon_wechat",@"icon_moments",@"icon_qq",@"icon_weibo"],
                                     @"title":@[@"微信",@"朋友圈",@"腾讯QQ",@"微博"]
                                     };
        [SDInvitePop showInvitePopView:inviteInfo cellClickBlock:^(NSString *titleName) {
            
            if ([titleName isEqualToString:@"微信"]) {
                
                WXMediaMessage *message = [WXMediaMessage message];
                message.title = @"邀请好友注册,立马赚积分";
                message.description = @"恭喜您获取杉德邀请码!点击打开网页获取邀请码,下载杉德宝App并注册,您将获得高达50积分奖励!";
                [message setThumbImage:[UIImage imageNamed:@"icon"]];
                WXWebpageObject *ext = [WXWebpageObject object];
                ext.webpageUrl = @"http://www.sandlife.com.cn";
                message.mediaObject = ext;
                
                SendMessageToWXReq* req = [[SendMessageToWXReq alloc] init];
                req.text = inviteCode;
                req.bText = NO;
                req.message = message;
                req.scene = WXSceneSession;
                BOOL sendSuccess =  [WXApi sendReq:req];
                if (!sendSuccess) {
                    [Tool showDialog:@"请安装微信"];
                }
            }
            if ([titleName isEqualToString:@"朋友圈"]) {
                WXMediaMessage *message = [WXMediaMessage message];
                message.title = @"邀请好友注册,立马赚积分";
                message.description = @"恭喜您获取杉德邀请码!点击打开网页获取邀请码,下载杉德宝App并注册,您将获得高达50积分奖励!";
                [message setThumbImage:[UIImage imageNamed:@"icon"]];
                
                WXWebpageObject *ext = [WXWebpageObject object];
                ext.webpageUrl = @"http://www.sandlife.com.cn";
                message.mediaObject = ext;
                
                SendMessageToWXReq* req = [[SendMessageToWXReq alloc] init];
                req.text = inviteCode;
                req.bText = NO;
                req.message = message;
                req.scene = WXSceneTimeline;
                BOOL sendSuccess =  [WXApi sendReq:req];
                if (!sendSuccess) {
                    [Tool showDialog:@"请安装微信"];
                }
            }
            if ([titleName isEqualToString:@"腾讯QQ"]) {

                TencentOAuth *oauth = [[TencentOAuth alloc] initWithAppId:Tencent_APPID andDelegate:self];
                
                QQApiURLObject *urlObject = [[QQApiURLObject alloc] initWithURL:[NSURL URLWithString:@"http://www.sandlife.com.cn"] title:@"邀请好友注册,立马赚积分" description:@"恭喜您获取杉德邀请码!点击打开网页获取邀请码,下载杉德宝App并注册,您将获得高达50积分奖励!" previewImageData:UIImageJPEGRepresentation([UIImage imageNamed:@"icon"], 0.5f) targetContentType:QQApiURLTargetTypeNews];
                
                SendMessageToQQReq *req = [SendMessageToQQReq reqWithContent:urlObject];
                // 分享给好友
                [QQApiInterface sendReq:req];
            }
            
            if ([titleName isEqualToString:@"微博"]) {
                [Tool showDialog:@"暂不支持微博分享"];
            }
            
        }];
    }
}


#pragma mark  - UI绘制
- (void)creaetUI{
    
    //背景
    UIImage *inviteBGimg = [UIImage imageNamed:@"invite_bg"];
    UIImageView *inviteBGView = [Tool createImagView:inviteBGimg];
    inviteBGView.userInteractionEnabled = YES;
    [self.baseScrollView addSubview:inviteBGView];
    
    [inviteBGView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.baseScrollView);
        make.centerY.equalTo(self.baseScrollView);
        make.size.mas_equalTo(self.baseScrollView.size);
    }];

    //二维码
    CGFloat qrSpace = 20;
    NSDictionary *userInfoDic = [[PayNucHelper sharedInstance] jsonStringToDictionary:[CommParameter sharedInstance].userInfo];
    UIImage *qrimg_BG = [UIImage imageNamed:@"bg_kuang"];
    
    CGSize qrImg_BGSize = CGSizeMake(qrimg_BG.size.width*0.9, qrimg_BG.size.height*0.9);
    
    UIImage *qrImg = [Tool twoDimensionCodeWithStr:[userInfoDic objectForKey:@"inviteCode"] size:qrImg_BGSize.width-qrSpace];
    
    UIImageView *qrCodeView_BG = [[UIImageView alloc] init];
    qrCodeView_BG.image = qrimg_BG;
    [inviteBGView addSubview:qrCodeView_BG];
    
    UIImageView *qrCodeImg = [[UIImageView alloc] init];
    qrCodeImg.image = qrImg;
    [inviteBGView addSubview:qrCodeImg];

    CGFloat qrCodeViewOY = UPDOWNSPACE_174;
    
    [qrCodeView_BG mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.baseScrollView.mas_top).offset(qrCodeViewOY);
        make.centerX.equalTo(self.baseScrollView);
        make.size.mas_equalTo(CGSizeMake(qrImg_BGSize.width, qrImg_BGSize.height));
    }];
    
    [qrCodeImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.baseScrollView.mas_top).offset(qrCodeViewOY+qrSpace/2);
        make.centerX.equalTo(self.baseScrollView);
        make.size.mas_equalTo(CGSizeMake(qrImg.size.width, qrImg.size.height));
    }];
    
    
    //透明按钮 - 分享
    UIButton *inviteBtn = [Tool createButton:@"" attributeStr:nil font:nil textColor:nil];
    inviteBtn.backgroundColor = [UIColor clearColor];
    inviteBtn.alpha = 0.4f;
    inviteBtn.frame = CGRectMake(0, 0, SCREEN_WIDTH, UPDOWNSPACE_112);
    inviteBtn.tag = BTN_TAG_JUSTCLICK;
    [inviteBtn addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    [inviteBGView addSubview:inviteBtn];
    
    [inviteBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(inviteBGView.mas_bottom).offset(-UPDOWNSPACE_58);
        make.centerX.equalTo(inviteBGView);
        make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH, UPDOWNSPACE_160));
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
