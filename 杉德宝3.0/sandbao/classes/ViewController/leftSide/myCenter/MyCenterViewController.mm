//
//  MyCenterViewController.m
//  sandbao
//
//  Created by tianNanYiHao on 2017/11/2.
//  Copyright © 2017年 sand. All rights reserved.
//

#import "MyCenterViewController.h"
#import "PayNucHelper.h"
#import "MyCenterCellView.h"

#import "SDBottomPop.h"
#import "Base64Util.h"
#import "GzipUtility.h"

#import "IdentityDetailViewController.h"
#import "NickNameViewController.h"

@interface MyCenterViewController ()<UIImagePickerControllerDelegate,UINavigationControllerDelegate>
{
    NSString *base64Str;
    UIImagePickerController *picker;
    
    MyCenterCellView *headCell;
    MyCenterCellView *identityCell;
    MyCenterCellView *accountCell;
    MyCenterCellView *erCodeCell;
    MyCenterCellView *nameHeadCell;
}
@end

@implementation MyCenterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
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
    self.navCoverView.midTitleStr = @"个人信息";
    
    __weak MyCenterViewController *weakSelf = self;
    self.navCoverView.leftBlock = ^{
        [weakSelf presentLeftMenuViewController:weakSelf.sideMenuViewController];
    };
    
    
}

#pragma mark - 重写父类-点击方法集合
- (void)buttonClick:(UIButton *)btn{
    
    if (btn.tag == BTN_TAG_CHANGEHEADIMG) {
        //@"头像"
        [SDBottomPop showBottomPopView:@"更换头像" cellNameList:@[@"拍照上传",@"从相册上传"] suerBlock:^(NSString *cellName) {
            if ([cellName isEqualToString:@"拍照上传"]) {
                picker = [[UIImagePickerController alloc] init];
                picker.sourceType = UIImagePickerControllerSourceTypeCamera;
                picker.delegate = self;
                //设置选择后的图片可被编辑
                picker.allowsEditing = YES;
                [self presentViewController:picker animated:YES completion:nil];
            }
            if ([cellName isEqualToString:@"从相册上传"]) {
                picker = [[UIImagePickerController alloc] init];
                picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
                picker.delegate = self;
                //设置选择后的图片可被编辑
                picker.allowsEditing = YES;
                [self presentViewController:picker animated:YES completion:nil];

            }
        }];
        
    }
    if (btn.tag == BTN_TAG_CHECKIDENTITY) {
        //@"身份认证"
        [SDBottomPop showBottomPopView:@"身份认证" cellNameList:@[@"查看身份信息",@"修改昵称"] suerBlock:^(NSString *cellName) {
            if ([cellName isEqualToString:@"查看身份信息"]) {
                IdentityDetailViewController *identityDetalVC = [[IdentityDetailViewController alloc] init];
                [self.navigationController pushViewController:identityDetalVC animated:YES];
            }
            if ([cellName isEqualToString:@"修改昵称"]) {
                NickNameViewController *nickNameVC = [[NickNameViewController alloc] init];
                [self.navigationController pushViewController:nickNameVC animated:YES];
            }
        }];
    }
    if (btn.tag == BTN_TAG_CHECKACCOUNT) {
        NSLog(@"杉德宝账号");
    }
    if (btn.tag == BTN_TAG_MYERCODE) {
        NSLog(@"我的二维码");
    }
    if (btn.tag == BTN_TAG_MYHEADNAME) {
        NSLog(@"我的发票抬头");
    }
    
}


#pragma mark  - UI绘制
- (void)createUI{
    __weak typeof(self) weakself = self;
    
    headCell = [MyCenterCellView createSetCellViewOY:0];
    headCell.cellType = myCenterCellType_Head;
    headCell.clickBlock = ^{
        UIButton *btn = [UIButton new];
        btn.tag = BTN_TAG_CHANGEHEADIMG;
        [weakself performSelector:@selector(buttonClick:) withObject:btn];
    };
    [self.baseScrollView addSubview:headCell];
    
    identityCell = [MyCenterCellView createSetCellViewOY:0];
    identityCell.cellType = myCenterCellType_Identity;
    identityCell.clickBlock = ^{
        UIButton *btn = [UIButton new];
        btn.tag = BTN_TAG_CHECKIDENTITY;
        [weakself performSelector:@selector(buttonClick:) withObject:btn];
    };
    [self.baseScrollView addSubview:identityCell];
    
    accountCell = [MyCenterCellView createSetCellViewOY:0];
    accountCell.cellType = myCenterCellType_Account;
    accountCell.clickBlock = ^{
        UIButton *btn = [UIButton new];
        btn.tag = BTN_TAG_CHECKACCOUNT;
        [weakself performSelector:@selector(buttonClick:) withObject:btn];
    };
    [self.baseScrollView addSubview:accountCell];
    
    
    erCodeCell = [MyCenterCellView createSetCellViewOY:0];
    erCodeCell.cellType = myCenterCellType_ErCode;
    erCodeCell.clickBlock = ^{
        UIButton *btn = [UIButton new];
        btn.tag = BTN_TAG_MYERCODE;
        [weakself performSelector:@selector(buttonClick:) withObject:btn];
    };
    [self.baseScrollView addSubview:erCodeCell];
    
    nameHeadCell = [MyCenterCellView createSetCellViewOY:0];
    nameHeadCell.cellType = myCenterCellType_NameHead;
    nameHeadCell.clickBlock = ^{
        UIButton *btn = [UIButton new];
        btn.tag = BTN_TAG_MYHEADNAME;
        [weakself performSelector:@selector(buttonClick:) withObject:btn];
    };
    nameHeadCell.line.hidden = YES;
    [self.baseScrollView addSubview:nameHeadCell];
    
    
    
    [headCell mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.baseScrollView.mas_top).offset(UPDOWNSPACE_10);
        make.centerX.equalTo(self.baseScrollView);
        make.size.mas_equalTo(headCell.size);
    }];
    
    [identityCell mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(headCell.mas_bottom).offset(UPDOWNSPACE_0);
        make.centerX.equalTo(self.baseScrollView);
        make.size.mas_equalTo(identityCell.size);
    }];
    
    [accountCell mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(identityCell.mas_bottom).offset(UPDOWNSPACE_0);
        make.centerX.equalTo(self.baseScrollView);
        make.size.mas_equalTo(accountCell.size);
    }];
    
    [erCodeCell mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(accountCell.mas_bottom).offset(UPDOWNSPACE_0);
        make.centerX.equalTo(self.baseScrollView);
        make.size.mas_equalTo(erCodeCell.size);
    }];
    
    [nameHeadCell mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(erCodeCell.mas_bottom).offset(UPDOWNSPACE_0);
        make.centerX.equalTo(self.baseScrollView);
        make.size.mas_equalTo(nameHeadCell.size);
    }];
    
    
    
}

#pragma mark -UIImagePickerControllerDelegate
// 获取图片后的操作
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info
{
    // 获取原始图片
    UIImage *image = info[UIImagePickerControllerEditedImage];
    
    //压缩 64*64
    UIGraphicsBeginImageContext(CGSizeMake(64, 64));
    CGRect thumbnailRect = CGRectZero;
    thumbnailRect.size.width = 64;
    thumbnailRect.size.height = 64;
    [image drawInRect:thumbnailRect];
    UIImage * newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    //数据格式化
    NSData *data = UIImageJPEGRepresentation(newImage, 0.6f);
    data = [GzipUtility gzipData:data];
    
    
    //base64
    base64Str = [Base64Util base64EncodedStringFrom:data];
    
    NSData *dataW = [base64Str dataUsingEncoding:NSUTF8StringEncoding];
    if (dataW.length >4000) {
        [Tool showDialog:@"图片过大,请重新选择"];
        return;
    }
    
    //上传头像
    [self updataPhoto];
    
    
    
}



#pragma mark - 业务逻辑
#pragma mark 上传头像
- (void)updataPhoto{
    
    //成功获取图片后 直接上传
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
        [userInfo setValue:base64Str forKey:@"avatar"];
        [userInfo setValue:@"" forKey:@"nick"];
        [userInfo setValue:@"" forKey:@"remainState"];
        NSString *userInfostr = [[PayNucHelper sharedInstance] dictionaryToJson:userInfo];
        paynuc.set("userInfo", [userInfostr UTF8String]);
        [[SDRequestHelp shareSDRequest] requestWihtFuncName:@"user/resetUserBaseInfo/v1" errorBlock:^(SDRequestErrorType type) {
            error = YES;
        } successBlock:^{
            [[SDRequestHelp shareSDRequest] dispatchToMainQueue:^{
                [self.HUD hidden];
                
                [CommParameter sharedInstance].avatar = base64Str;
                [Tool showDialog:@"头像修改成功"];
                //刷新头像
                NSString *str = [CommParameter sharedInstance].avatar;
                NSData *data = [Base64Util dataWithBase64EncodedString:str];
                data = [GzipUtility uncompressZippedData:data];
                //销毁照片控制器
                [picker dismissViewControllerAnimated:YES completion:^{
                    
                }];
            }];
        }];
        if (error) return ;
    }];
    
}







#pragma mark - 本类公共方法调用
#pragma mark 刷新用户信息
- (void)refreshUI{
    
    //刷新头像数据
    headCell.headIconImg = [Tool avatarImageWith:[CommParameter sharedInstance].avatar];
    
    //昵称数据
    if ([CommParameter sharedInstance].nick.length>0) {
        identityCell.nickNameStr = [CommParameter sharedInstance].nick;
    }else{
       identityCell.nickNameStr = @"设置昵称";
    }
    //账号
    accountCell.accountNo = [CommParameter sharedInstance].userName;
    
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
