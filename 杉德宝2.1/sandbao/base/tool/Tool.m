//
//  Tool.m
//  sandbao
//
//  Created by tianNanYiHao on 2017/5/17.
//  Copyright © 2017年 sand. All rights reserved.
//

#import "Tool.h"
#import <UIKit/UIKit.h>
#import "SDSqlite.h"
#import "SqliteHelper.h"
#import "Base64Util.h"
#import "GzipUtility.h"
#import "LoginViewController.h"
#import "SpsLunchViewController.h"
#import "SDMQTTManager.h"
#define Tool_Rgba(r,g,b,a) [UIColor colorWithRed:r/255.f green:g/255.f blue:b/255.f alpha:a]
@interface Tool(){
    
}

@end


@implementation Tool


#pragma mark - popVc指定返回到某一个具体视图控制器
/**
 popVc指定返回到某一个具体视图控制器

 @param vc 当前视图控制器
 @param vcName 要返回的视图控制器
 */
+ (void)popToPenultimateViewController:(UIViewController*)vc vcName:(NSString*)vcName{
    
    for (int i = 0; vc.navigationController.viewControllers.count; i++) {
        NSString *name = [NSString stringWithUTF8String:object_getClassName(vc.navigationController.viewControllers[i])];
        if ([name isEqualToString:vcName]) {
            [vc.navigationController popToViewController:vc.navigationController.viewControllers[i] animated:YES];
            break;
        }
    }
    [vc.navigationController popToRootViewControllerAnimated:YES];
}




#pragma mark - url跳转
/**
 url跳转

 @param url 地址
 */
+ (void)openUrl:(NSURL*)url{
    
    if (IOS_VERSION_9 || IOS_VERSION_8) {
        [[UIApplication sharedApplication] openURL:url];
    }else{
        [[UIApplication sharedApplication] openURL:url options:@{} completionHandler:nil];
    }
}

#pragma mark - 归位登陆页
/**
 归位登陆页
 
 @param sideMenuViewController sideMenuViewController description
 @param forLogOut 是否用于退出登录
 */
+ (void)setContentViewControllerWithLoginFromSideMentuVIewController:(id)sideMenuViewController forLogOut:(BOOL)forLogOut{
    
    //用于退出登录功能
    if (forLogOut) {
        //0.退出前 当前活跃状态的账户更新数据
        BOOL result = [SDSqlite updateData:[SqliteHelper shareSqliteHelper].sandBaoDB sql:[NSString stringWithFormat:@"update usersconfig set active = '%@', sToken = '%@' where active = '%@'", @"1", @"", @"0"]];
        if (YES) {
            
            //1.清空Commparamater
            [[CommParameter sharedInstance] cleanCommParameter];
            
            //2. 登出->mqtt结束
            [[SDMQTTManager shareMQttManager] closeMQTT];
            
            //3.跳转登陆页面
            LoginViewController *mLoginViewController = [[LoginViewController alloc] init];
            UINavigationController *navLogin = [[UINavigationController alloc] initWithRootViewController:mLoginViewController];
            //类型判断
            NSString *className = [NSString stringWithUTF8String:object_getClassName(sideMenuViewController)];
            //3.1 RESideMenu
            if ([className isEqualToString:@"RESideMenu"]) {
                RESideMenu *object = sideMenuViewController;
                [object setContentViewController:navLogin];
                [object hideMenuViewController];
            }
            //3.2 UIViewController
            else{
                UIViewController *controller = sideMenuViewController;
                RESideMenu *object = controller.sideMenuViewController;
                [object setContentViewController:navLogin];
                [object hideMenuViewController];
                [controller.navigationController popToRootViewControllerAnimated:YES];
            }
        }
    }
    //仅用于进入登录页功能
    else{
        //3.跳转登陆页面
        LoginViewController *mLoginViewController = [[LoginViewController alloc] init];
        UINavigationController *navLogin = [[UINavigationController alloc] initWithRootViewController:mLoginViewController];
        //类型判断
        NSString *className = [NSString stringWithUTF8String:object_getClassName(sideMenuViewController)];
        //3.1 RESideMenu
        if ([className isEqualToString:@"RESideMenu"]) {
            RESideMenu *object = sideMenuViewController;
            [object setContentViewController:navLogin];
            [object hideMenuViewController];
        }
        //3.2 UIViewController
        else{
            UIViewController *controller = sideMenuViewController;
            RESideMenu *object = controller.sideMenuViewController;
            [object setContentViewController:navLogin];
            [object hideMenuViewController];
            [controller.navigationController popToRootViewControllerAnimated:YES];
        }
    }
    

}

#pragma mark - 归位Home页或SpsLunch页
/**
 归位到Home页

 @param sideMenuViewController sideMenuViewController description
 */
+ (void)setContentViewControllerWithHomeOrSpsLunchFromSideMenuViewController:(id)sideMenuViewController{
    
    //1.归位SpsLunch
    if ([CommParameter sharedInstance].urlSchemes.length > 0 || [CommParameter sharedInstance].urlSchemes != nil) {
        NSArray *urlArr = [[CommParameter sharedInstance].urlSchemes  componentsSeparatedByString:@"TN:"];
        urlArr = [[urlArr lastObject] componentsSeparatedByString:@"?"];
        NSString *tn = [urlArr firstObject];
        
        SpsLunchViewController *spsLunchVC = [[SpsLunchViewController alloc] init];
        spsLunchVC.schemeStr = [CommParameter sharedInstance].urlSchemes ;
        spsLunchVC.TN = tn;
        UINavigationController *spsLunchNav = [[UINavigationController alloc] initWithRootViewController:spsLunchVC];
        //类型判断
        NSString *className = [NSString stringWithUTF8String:object_getClassName(sideMenuViewController)];
        //1 RESideMenu
        if ([className isEqualToString:@"RESideMenu"]) {
            RESideMenu *object = sideMenuViewController;
            [object setContentViewController:spsLunchNav];
            [object hideMenuViewController];
        }
        //2 UIViewController
        else{
            UIViewController *controller = sideMenuViewController;
            RESideMenu *object = controller.sideMenuViewController;
            [object setContentViewController:spsLunchNav];
            [object hideMenuViewController];
        }
        //urlScheme清空 (如sToken/异地登陆等情况,用户登出后,不再支持该笔urlSchemes有效)
        [CommParameter sharedInstance].urlSchemes = nil;
    }
    
    //2.归位到HomeNav
    else{
        //类型判断
        NSString *className = [NSString stringWithUTF8String:object_getClassName(sideMenuViewController)];
        //3.1 RESideMenu
        if ([className isEqualToString:@"RESideMenu"]) {
            RESideMenu *object = sideMenuViewController;
            [object setContentViewController:[CommParameter sharedInstance].homeNav];
            [object hideMenuViewController];
        }
        //3.2 UIViewController
        else{
            UIViewController *controller = sideMenuViewController;
            RESideMenu *object = controller.sideMenuViewController;
            [object setContentViewController:[CommParameter sharedInstance].homeNav];
            [object hideMenuViewController];
        }
    }
}


#pragma mark - 支付工具排序
/**
 支付工具排序
 
 @param payTools 排序前支付工具组
 @return 排序后支付工具组
 */
+(NSArray*)orderForPayTools:(NSArray*)payTools{
    //1
    if (payTools.count>0) {
        //获取order的intvalue数组 形式
        NSMutableArray *arrOrder = [NSMutableArray arrayWithCapacity:0];
        for (int i = 0; i<payTools.count; i++) {
            NSInteger integer = [[payTools[i] objectForKey:@"order"] integerValue];
            //防止支付工具中没有order 则返回原来的顺序
            if (integer == 0) {
                return  payTools;
            }
            [arrOrder addObject:@(integer)];
        }
        
        //对order进行排序
        NSArray *resultArrayOrder = [arrOrder sortedArrayUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
            return [obj1 compare:obj2];
        }];
        
        
        //轮询重组(可能有重复)
        NSMutableArray *payToolsNew = [NSMutableArray arrayWithCapacity:0];
        for (int j = 0; j<resultArrayOrder.count; j++) {
            
            NSInteger countNum = [[NSString stringWithFormat:@"%@",resultArrayOrder[j]] integerValue];
            
            for (int a = 0; a<payTools.count; a++) {

                NSInteger orderOld = [[payTools[a] objectForKey:@"order"] integerValue];
                
                if (countNum == orderOld) {
                    [payToolsNew addObject:payTools[a]];
                }
            }
        }
        
        //去重
        NSMutableArray *payToolsNewNorepet = [[NSMutableArray alloc] initWithCapacity:0];
        for (int n = 0; n<payToolsNew.count; n++) {
            NSDictionary *dic = payToolsNew[n];
            //根据唯一的ID号去重
            NSString *ID = [dic objectForKey:@"id"];
            if (![payToolsNewNorepet containsObject:ID]) {
                [payToolsNewNorepet addObject:ID];
            }
        }
        
        //再次重组: 根据 payToolsNewNorepet 对应的下标和ID
        NSMutableArray *payToolsOK = [NSMutableArray arrayWithCapacity:0];
        for (int s = 0; s<payToolsNewNorepet.count; s++) {
            NSString *ID = payToolsNewNorepet[s];
            
            for (NSDictionary *dic in payTools) {
                NSString * IDForNotOrder = dic[@"id"];
                if ([ID isEqualToString:IDForNotOrder]) {
                    [payToolsOK addObject:dic];
                }
            }
        }
        
        
        
        return payToolsOK;
    }
    return nil;
}


#pragma mark - 生成条形码
+ (UIImage *)barCodeImageWithStr:(NSString *)str
{
    // 1.将字符串转换成NSData
    NSData *data = [str dataUsingEncoding:NSUTF8StringEncoding];
    
    // 2.创建条形码滤镜
    CIFilter *filter = [CIFilter filterWithName:@"CICode128BarcodeGenerator"];
    
    // 3.恢复滤镜的默认属性
    [filter setDefaults];
    
    // 4.设置滤镜inputMessage数据
    [filter setValue:data forKey:@"inputMessage"];
    
    // 5.获得滤镜输出的图像
    CIImage *urlImage = [filter outputImage];
    
    // 6.将CIImage 转换为UIImage
    UIImage *image = [UIImage imageWithCIImage:urlImage];
    
    return image;
}

#pragma mark - 生成二维码
+ (UIImage *)twoDimensionCodeWithStr:(NSString *)str size:(CGFloat)size
{
    // 1.将字符串转换成NSData
    NSData *data = [str dataUsingEncoding:NSUTF8StringEncoding];
    
    // 2.创建二维码滤镜
    CIFilter *filter = [CIFilter filterWithName:@"CIQRCodeGenerator"];
    
    // 3.恢复默认
    [filter setDefaults];
    
    // 4.给滤镜设置数据
    [filter setValue:data forKeyPath:@"inputMessage"];
    
    // 5.获取滤镜输出的二维码
    CIImage *outputImage = [filter outputImage];
    
    // 6.此时生成的还是CIImage，可以通过下面方式生成一个固定大小的UIImage
    CGRect extent = CGRectIntegral(outputImage.extent);
    CGFloat scale = MIN(size/CGRectGetWidth(extent), size/CGRectGetHeight(extent));
    
    // 7.创建bitmap;
    size_t width = CGRectGetWidth(extent) * scale;
    size_t height = CGRectGetHeight(extent) * scale;
    CGColorSpaceRef cs = CGColorSpaceCreateDeviceGray();
    CGContextRef bitmapRef = CGBitmapContextCreate(nil, width, height, 8, 0, cs, (CGBitmapInfo)kCGImageAlphaNone);
    CIContext *context = [CIContext contextWithOptions:nil];
    CGImageRef bitmapImage = [context createCGImage:outputImage fromRect:extent];
    CGContextSetInterpolationQuality(bitmapRef, kCGInterpolationNone);
    CGContextScaleCTM(bitmapRef, scale, scale);
    CGContextDrawImage(bitmapRef, extent, bitmapImage);
    
    // 8.保存bitmap到图片
    CGImageRef scaledImage = CGBitmapContextCreateImage(bitmapRef);
    CGContextRelease(bitmapRef);
    CGImageRelease(bitmapImage);
    
    //9.获取原始二维码图片
    UIImage *qrCodeImg = [UIImage imageWithCGImage:scaledImage];
    
    
    //10.添加logo
    UIImage *logoImage = [UIImage imageNamed:@"iconApp"];
    CGSize logoImgSize = CGSizeMake(qrCodeImg.size.width*0.2, qrCodeImg.size.height*0.2);
    
    UIGraphicsBeginImageContextWithOptions(qrCodeImg.size, NO, [[UIScreen mainScreen] scale]);
    [qrCodeImg drawInRect:CGRectMake(0, 0, qrCodeImg.size.width, qrCodeImg.size.height)];
    
    CGRect rect = CGRectMake(qrCodeImg.size.width/2 - logoImgSize.width/2, qrCodeImg.size.height/2-logoImgSize.height/2, logoImgSize.width, logoImgSize.height);
    
    [logoImage drawInRect:rect];
    UIImage *resultingImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return resultingImage;
}

#pragma mark - 分转换为元
+ (NSString*)fenToYuanDict:(NSDictionary*)payToolDic{
    
    NSString *fenStr = [[payToolDic objectForKey:@"account"] objectForKey:@"useableBalance"];
    
    NSInteger fenInteger = [fenStr integerValue];
    
    if (fenInteger == 0) {
        return @"0.00";
    }
    else{
        NSDecimalNumber *yuanDecimalNumber = [[NSDecimalNumber alloc] initWithMantissa:fenInteger exponent:-2 isNegative:NO];
        NSString *yuanStr = [NSString stringWithFormat:@"%@",yuanDecimalNumber];
        return yuanStr;
        
    }
    return @"0.00";
}

#pragma mark - 用户信息获取/刷新
+ (void)refreshUserInfo:(NSString*)userInfoStr{
    
    NSData *userInfoData = [userInfoStr dataUsingEncoding:NSUTF8StringEncoding];
    NSDictionary *userInfoDic = [NSJSONSerialization JSONObjectWithData:userInfoData options:NSJSONReadingMutableLeaves error:nil];
    [CommParameter sharedInstance].userInfo = userInfoStr;
    [CommParameter sharedInstance].avatar = [userInfoDic objectForKey:@"avatar"];
    [CommParameter sharedInstance].userRealName = [userInfoDic objectForKey:@"userRealName"];
    [CommParameter sharedInstance].userName = [userInfoDic objectForKey:@"userName"];
    [CommParameter sharedInstance].phoneNo = [userInfoDic objectForKey:@"phoneNo"];
    [CommParameter sharedInstance].userId = [userInfoDic objectForKey:@"userId"];
    [CommParameter sharedInstance].payPassFlag = [[userInfoDic objectForKey:@"payPassFlag"] boolValue];
    [CommParameter sharedInstance].payForAnotherFlag = [[userInfoDic objectForKey:@"payForAnotherFlag"] boolValue];
    [CommParameter sharedInstance].realNameFlag = [[userInfoDic objectForKey:@"realNameFlag"] boolValue];
    [CommParameter sharedInstance].safeQuestionFlag = [[userInfoDic objectForKey:@"safeQuestionFlag"] boolValue];
    [CommParameter sharedInstance].nick = [userInfoDic objectForKey:@"nick"];
    
}

#pragma mark - 装配我方支付工具
+ (NSDictionary*)getPayToolsInfo:(NSArray*)ownPayToolsArr{
    
    NSMutableDictionary *infoDic = [NSMutableDictionary dictionaryWithCapacity:0];
    
    //银行卡 数组初始化
    NSMutableArray *bankArray = [NSMutableArray arrayWithCapacity:0];
    //杉德卡 数组初始化
    NSMutableArray *sandArray = [NSMutableArray arrayWithCapacity:0];
    //杉德宝钱包账户 初始化
    NSDictionary *sandWalletDic = [[NSDictionary alloc] init];
    //代付凭证 初始化
    NSDictionary *payForAnotherDic = [[NSDictionary alloc] init];
    //积分账户 初始化
    NSDictionary *sandPointDic = [[NSDictionary alloc] init];
    
    
    for (int i = 0; i < ownPayToolsArr.count; i++) {
        NSDictionary *dic = ownPayToolsArr[i];
        NSString *type = [dic objectForKey:@"type"];
        //快捷借记卡
        if ([@"1001" isEqualToString:type]) {
            [bankArray addObject:dic];
        }
        //快捷贷记卡
        else if ([@"1002" isEqualToString:type]) {
            [bankArray addObject:dic];
        }
        //记名卡主账户
        else if ([@"1003" isEqualToString:type]) {
            [sandArray addObject:dic];
        }
        //杉德卡钱包
        else if ([@"1004" isEqualToString:type]) {
            
        }
        //杉德卡钱包账户
        else if ([@"1005" isEqualToString:type]) {
            sandWalletDic = dic;
        }
        //电子记名卡账户
        else if ([@"1006" isEqualToString:type]) {
            
        }
        //久彰宝杉德币账户
        else if ([@"1007" isEqualToString:type]) {
            
        }
        //久彰宝专用账户
        else if ([@"1008" isEqualToString:type]) {
            
        }
        //久彰宝通用账户
        else if ([@"1009" isEqualToString:type]) {
            
        }
        //会员卡账户
        else if ([@"1010" isEqualToString:type]) {
            
        }
        //网银借记卡
        else if ([@"1011" isEqualToString:type]) {
            [bankArray addObject:dic];
        }
        //网银贷记卡
        else if ([@"1012" isEqualToString:type]) {
            [bankArray addObject:dic];
        }
        //代付凭证
        else if ([@"1014" isEqualToString:type]) {
            payForAnotherDic = dic;
        }
        //积分账户
        else if ([@"1015" isEqualToString:type]) {
            sandPointDic = dic;
        }
    }
    
    //银行卡
    [infoDic setObject:bankArray forKey:@"bankArray"];
    //杉德卡
    [infoDic setObject:sandArray forKey:@"sandArray"];
    //钱包账户
    [infoDic setObject:sandWalletDic forKey:@"sandWalletDic"];
    //代付凭证
    [infoDic setObject:payForAnotherDic forKey:@"payForAnotherDic"];
    //杉德积分
    [infoDic setObject:sandPointDic forKey:@"sandPointDic"];
    
    return infoDic;
    
}

#pragma mark - 头像图片转换(avatar的两种形式_1.文件形式的base64_2.网络Url的Base64)
+(UIImage*)avatarImageWith:(NSString*)avatar{
    
    UIImage *image ;
    if (avatar.length == 0) {
        return image = [UIImage imageNamed:@"center_profile_avatar"];
    }
    
    //不能判断avatar字符串原来的格式,所以做两次转换
    NSData *data = [Base64Util dataWithBase64EncodedString:avatar];
    data = [GzipUtility uncompressZippedData:data];
    NSString *string = [Base64Util textFromBase64String:avatar];
    
    //区分头像来源或
    if ([string rangeOfString:@"http"].location !=NSNotFound && string.length>0) {
        //(微博/微信等网络图片
        NSData *imagData = [NSData dataWithContentsOfURL:[NSURL URLWithString:string]];
        image = [UIImage imageWithData:imagData];
    }else{
        //后端返回)
        image = [UIImage imageWithData:data];
    }
    
    return image;
    
}

#pragma mark - 银行icon数据获取
+ (NSArray*)getBankIconInfo:(NSString*)bankName{

    NSArray *arrayInfo = [NSArray new];
    //背景和图标
    UIImage *iconImage;
    UIImage *iconWatermarkImage;
    UIColor *backgroundColor;
    UIColor *backgroundColor2;
    
    NSArray *bankNameArray = @[@"工商银行",@"建设银行",@"农业银行",@"招商银行",@"交通银行",@"中国银行",@"光大银行",@"民生银行",@"兴业银行",@"中信银行",@"广发银行",@"浦发银行",@"平安银行",@"华夏银行",@"宁波银行",@"东亚银行",@"上海银行",@"中国邮储银行",@"南京银行",@"上海农商行",@"渤海银行",@"成都银行",@"北京银行",@"徽商银行",@"天津银行"];
    
    NSArray *bankImageNameArray = @[@"banklist_gs",@"banklist_js",@"banklist_nh",@"banklist_zs",@"banklist_jt",@"banklist_gh",@"banklist_gd",@"banklist_ms",@"banklist_xy",@"banklist_zx",@"banklist_gf",@"banklist_pf",@"banklist_pa",@"banklist_hx",@"banklist_nb",@"banklist_dy",@"banklist_sh",@"banklist_yz",@"banklist_nj",@"banklist_shns",@"banklist_bh",@"banklist_cd",@"banklist_bj",@"banklist_hs",@"banklist_tj"];
    
    for (int i = 0; i<bankNameArray.count; i++) {
        if ([bankName containsString:[bankNameArray[i] substringToIndex:2]]) {
            iconImage = [UIImage imageNamed:bankImageNameArray[i]];
            [iconImage setAccessibilityIdentifier:bankImageNameArray[i]];
            NSString *nameLastObj = [[bankImageNameArray[i] componentsSeparatedByString:@"_"] lastObject];
            NSString *waterMarkname = [NSString stringWithFormat:@"watermark_%@",nameLastObj];
            iconWatermarkImage = [UIImage imageNamed:waterMarkname];
            
            if (i == 0) {
                //红色
                backgroundColor = Tool_Rgba(234, 85, 115, 1.0);backgroundColor2 = Tool_Rgba(158, 14, 14, 1.0);
            }
            if (i == 1) {
                //天空蓝
                backgroundColor = Tool_Rgba(0, 191, 255, 1.0);backgroundColor2 = Tool_Rgba(7, 78, 218, 1.0);
            }
            if (i == 2) {
                //草绿
                backgroundColor = Tool_Rgba(154, 205, 50, 1.0);backgroundColor2 = Tool_Rgba(85, 171, 5, 1.0);
            }
            if (i == 3) {
                //红色
                backgroundColor = Tool_Rgba(234, 85, 115, 1.0);backgroundColor2 = Tool_Rgba(158, 14, 14, 1.0);
            }
            if (i == 4) {
                //天空蓝
                backgroundColor = Tool_Rgba(0, 191, 255, 1.0);backgroundColor2 = Tool_Rgba(7, 78, 218, 1.0);
            }
            if (i == 5) {
                //红色
                backgroundColor = Tool_Rgba(234, 85, 115, 1.0);backgroundColor2 = Tool_Rgba(158, 14, 14, 1.0);
            }
            if (i == 6) {
                //橘黄
                backgroundColor = Tool_Rgba(255, 127, 36, 1.0);backgroundColor2 = Tool_Rgba(255, 201, 38, 1.0);
            }
            if (i == 7) {
                //天空蓝
                backgroundColor = Tool_Rgba(0, 191, 255, 1.0);backgroundColor2 = Tool_Rgba(7, 78, 218, 1.0);
            }
            if (i == 8) {
                //红色
                backgroundColor = Tool_Rgba(234, 85, 115, 1.0);backgroundColor2 = Tool_Rgba(158, 14, 14, 1.0);
            }
            if (i == 9) {
                //红色
                backgroundColor = Tool_Rgba(234, 85, 115, 1.0);backgroundColor2 = Tool_Rgba(158, 14, 14, 1.0);
            }
            if (i == 10) {
                //天空蓝
                backgroundColor = Tool_Rgba(0, 191, 255, 1.0);backgroundColor2 = Tool_Rgba(7, 78, 218, 1.0);
            }
            if (i == 11) {
                //橘黄
                backgroundColor = Tool_Rgba(255, 127, 36, 1.0);backgroundColor2 = Tool_Rgba(255, 201, 38, 1.0);
            }
            if (i == 12) {
                //橘黄
                backgroundColor = Tool_Rgba(255, 127, 36, 1.0);backgroundColor2 = Tool_Rgba(255, 201, 38, 1.0);
            }
            if (i == 13) {
                //橘黄
                backgroundColor = Tool_Rgba(255, 127, 36, 1.0);backgroundColor2 = Tool_Rgba(255, 201, 38, 1.0);
            }
            if (i == 14) {
                //红色
                backgroundColor = Tool_Rgba(234, 85, 115, 1.0);backgroundColor2 = Tool_Rgba(158, 14, 14, 1.0);
            }
            if (i == 15) {
                //橘黄
                backgroundColor = Tool_Rgba(255, 127, 36, 1.0);backgroundColor2 = Tool_Rgba(255, 201, 38, 1.0);
            }
            if (i == 16) {
                //草绿
                backgroundColor = Tool_Rgba(154, 205, 50, 1.0);backgroundColor2 = Tool_Rgba(85, 171, 5, 1.0);
            }
            if (i == 17) {
                //红色
                backgroundColor = Tool_Rgba(234, 85, 115, 1.0);backgroundColor2 = Tool_Rgba(158, 14, 14, 1.0);
            }
            if (i == 18) {
                //天空蓝
                backgroundColor = Tool_Rgba(0, 191, 255, 1.0);backgroundColor2 = Tool_Rgba(7, 78, 218, 1.0);
            }
            if (i == 19) {
                //天空蓝
                backgroundColor = Tool_Rgba(0, 191, 255, 1.0);backgroundColor2 = Tool_Rgba(7, 78, 218, 1.0);
            }
            if (i == 20) {
                //天空蓝
                backgroundColor = Tool_Rgba(0, 191, 255, 1.0);backgroundColor2 = Tool_Rgba(7, 78, 218, 1.0);
            }
            if (i == 21) {
                //红色
                backgroundColor = Tool_Rgba(234, 85, 115, 1.0);backgroundColor2 = Tool_Rgba(158, 14, 14, 1.0);
            }
            if (i == 22) {
                //红色
                backgroundColor = Tool_Rgba(234, 85, 115, 1.0);backgroundColor2 = Tool_Rgba(158, 14, 14, 1.0);
            }
            if (i == 23) {
                //红色
                backgroundColor = Tool_Rgba(234, 85, 115, 1.0);backgroundColor2 = Tool_Rgba(158, 14, 14, 1.0);
            }
            if (i == 24) {
                //天空蓝
                backgroundColor = Tool_Rgba(0, 191, 255, 1.0);backgroundColor2 = Tool_Rgba(7, 78, 218, 1.0);
            }
        }
    }
    if (iconImage && iconWatermarkImage && backgroundColor && backgroundColor2) {
        arrayInfo = @[iconImage,iconWatermarkImage,backgroundColor,backgroundColor2];
        return arrayInfo;
    }else{
        return @[[UIImage imageNamed:@"qvip_pay_imageholder"],[UIImage imageNamed:@"watermask_sand"],Tool_Rgba(0, 191, 255, 1.0),Tool_Rgba(7, 78, 218, 1.0)];
    }
    return @[[UIImage imageNamed:@"qvip_pay_imageholder"],[UIImage imageNamed:@"watermask_sand"],Tool_Rgba(0, 191, 255, 1.0),Tool_Rgba(7, 78, 218, 1.0)];
}

#pragma mark - 获取payList列表不同支付工具描述
+ (NSString *)getbankLimitLabelText:(NSString*)type userblance:(CGFloat)userBalanceFloat{
    if ([@"1001" isEqualToString:type]){
        return @"快捷借记卡";
    }
    else if ([@"1002" isEqualToString:type]) {
        return @"快捷贷记卡";
    }
    else if ([@"1003" isEqualToString:type]) {
        return [NSString stringWithFormat:@"可用余额%.2f元",userBalanceFloat];;
    }
    else if ([@"1004" isEqualToString:type]) {
        return [NSString stringWithFormat:@"可用余额%.2f元",userBalanceFloat];;
    }
    else if ([@"1005" isEqualToString:type]) {
        return [NSString stringWithFormat:@"可用余额%.2f元",userBalanceFloat];;
    }
    else if ([@"1006" isEqualToString:type]) {
        return [NSString stringWithFormat:@"可用余额%.2f元",userBalanceFloat];;
    }
    else if ([@"1007" isEqualToString:type]) {
        return @"久璋宝杉德币账户";
    }
    else if ([@"1008" isEqualToString:type]) {
        return @"久璋宝专用账户";
    }
    else if ([@"1009" isEqualToString:type]) {
        return @"久璋宝通用账户";
    }
    else if ([@"1010" isEqualToString:type]) {
        return @"会员卡账户";
    }
    else if ([@"1011" isEqualToString:type]) {
        return @"网银借记卡";
    }
    else if ([@"1012" isEqualToString:type]) {
        return @"网银贷记卡";
    }
    else if ([@"1014" isEqualToString:type]) {
        return @"代付凭证";
    }
    else{
        return @"   ";
    }
}



#pragma mark - 获取paylist列表icon
+ (NSString *)getIconImageName:(NSString*)type title:(NSString*)title imaUrl:(NSString*)imaUrl{
    if ([@"1001" isEqualToString:type]){
        NSArray *bankInfoArr = [self getBankIconInfo:title];
        return [bankInfoArr[0] accessibilityIdentifier];
    }
    else if ([@"1002" isEqualToString:type]) {
        NSArray *bankInfoArr = [self getBankIconInfo:title];
        return [bankInfoArr[0] accessibilityIdentifier];
    }
    else if ([@"1003" isEqualToString:type]) {
        return @"list_sand_logo";
    }
    else if ([@"1004" isEqualToString:type]) {
        return @"qvip_pay_imageholder";
    }
    else if ([@"1005" isEqualToString:type]) {
        return @"list_cash";
    }
    else if ([@"1006" isEqualToString:type]) {
        return @"list_xiaofei";
    }
    else if ([@"1007" isEqualToString:type]) {
        //return @"久璋宝杉德币账户";
        return @"qvip_pay_imageholder";
    }
    else if ([@"1008" isEqualToString:type]) {
        //return @"久璋宝专用账户";
        return @"qvip_pay_imageholder";
    }
    else if ([@"1009" isEqualToString:type]) {
        //return @"久璋宝通用账户";
        return @"qvip_pay_imageholder";
    }
    else if ([@"1010" isEqualToString:type]) {
        //return @"会员卡账户";
        return @"qvip_pay_imageholder";
    }
    else if ([@"1011" isEqualToString:type]) {
        NSArray *bankInfoArr = [self getBankIconInfo:title];
        return [bankInfoArr[0] accessibilityIdentifier];
    }
    else if ([@"1012" isEqualToString:type]) {
        NSArray *bankInfoArr = [self getBankIconInfo:title];
        return [bankInfoArr[0] accessibilityIdentifier];
    }
    else if ([@"1014" isEqualToString:type]) {
        return @"list_sand_logo";
    }
    else if([@"PAYLIST_BTN_ADDCARD" isEqualToString:type]){ //添加卡按钮
        if ([imaUrl isEqualToString:@"list_yinlian_AddCard"]) {
            return @"list_yinlian_AddCard";
        }else if ([imaUrl isEqualToString:@"list_sand_AddCard"]){
            return @"list_sand_AddCard";
        }
    }
    return @"qvip_pay_imageholder";
}



#pragma mark  - 拼装终端标记域(cgf_tempFp)
+ (NSString*)setCfgTempFpStaticDataFlag:(BOOL)StaticDataFlag DynamicDataFlag:(BOOL)DynamicDataFlag {

    NSDictionary *OS = [NSDictionary dictionary];
    OS = @{
           @"SystemName":[UIDevice deviceVersion],
           @"SystemVersion":[UIDevice phoneVersion]
           };
    NSDictionary *Equipment = [NSDictionary dictionary];
    Equipment = @{
                  @"DeviceName":[UIDevice phoneName],
                  @"IDFV":[UIDevice UUIDString]
                  };
    
    //静态标记域
    NSDictionary *StaticData = [NSDictionary dictionary];
    if (StaticDataFlag) {
        StaticData = @{
                       @"OS":OS,
                       @"Equipment":Equipment
                       };
    }else{
        StaticData = @{
                       @"OS":@"",
                       @"Equipment":@""
                       };
    }

    /////////////////////////////////////////////////////////////////////
    
    NSArray *locatonArray = nil;
    NSString *longitude = nil;
    NSString *latitude = nil;
    if (DynamicDataFlag) {
        locatonArray = [[LocationUtil shareLocationManager] startUpdatingLocation];
        longitude  = [locatonArray firstObject];
        latitude = [locatonArray lastObject];
    }
    NSDictionary *Coordinate = [NSDictionary dictionary];
    Coordinate = @{
                   @"Type":@"GPS",
                   @"Long":longitude==nil?@"":longitude,
                   @"Lat":latitude==nil?@"":latitude
                   };

    //动态标记域
    NSDictionary *DynamicData = [NSDictionary dictionary];
    if ([UIDevice fetchSSIDInfo] != nil) {
        NSDictionary *ssIDdic = [NSDictionary dictionary];
        ssIDdic = (NSDictionary*)[UIDevice fetchSSIDInfo];
        NSData *data = [ssIDdic objectForKey:@"SSIDDATA"];
        NSString *dataStr = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        ssIDdic = @{
                    @"BSSID":[ssIDdic objectForKey:@"BSSID"],
                    @"SSID":[ssIDdic objectForKey:@"SSID"],
                    @"SSIDDATA":dataStr
                    };
        
        DynamicData = @{
                        @"IPAddress":@"",
                        @"Coordinate":Coordinate,
                        @"District":@"",
                        @"SSIDs":@[ssIDdic]
                        };
    }else{
        DynamicData = @{
                        @"IPAddress":@"",
                        @"Coordinate":Coordinate,
                        @"District":@"",
                        @"SSIDs":@""
                        };
    }
    
    /////////////////////////////////////////////////////////////////////
    
    //终端(整体)标记域
    NSDictionary *cfg_termFp = [NSDictionary dictionary];
    cfg_termFp = @{
                   @"Version":@"TRACE-1",
                   @"HostType":@"APP",
                   @"OSType":@"IOS",
                   @"StaticData":StaticData,
                   @"DynamicData":DynamicData
                   };
    
    //转json串
    if (cfg_termFp != nil) {
        NSError *error;
        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:(NSMutableDictionary*)cfg_termFp options:NSJSONWritingPrettyPrinted error:&error];
        NSString *str = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
        return [[str stringByReplacingOccurrencesOfString:@"\n" withString:@""] stringByReplacingOccurrencesOfString:@" " withString:@""];
    }
    
    return @"";
}




#pragma mark - 结束App
+ (void)exitApplication:(UIViewController*)vc {
    //来 加个动画，给用户一个友好的退出界面
    
    [UIView animateWithDuration:0.4 animations:^{
        vc.view.window.alpha = 0;
    } completion:^(BOOL finished) {
        exit(0);
    }];
    
}

#pragma mark - ImageView工厂方法
+ (UIImageView*)createImagView:(UIImage*)image{
    
    UIImageView *imgv = [[UIImageView alloc] init];
    imgv.image = image;
    imgv.frame = CGRectMake(0, 0, image.size.width, image.size.height);
    return imgv;
}

#pragma mark -  textfield工厂方法
+ (UITextField*)createTextField:(NSString*)placehold font:(UIFont*)font textColor:(UIColor*)textColor{
    
    UITextField *textf = [[UITextField alloc] init];
    textf.font = font;
    textf.placeholder = placehold;
    textf.textColor = textColor;
    
    CGSize textfSize  = [textf sizeThatFits:CGSizeZero];
    textf.frame = CGRectMake(0, 0, textfSize.width, textfSize.height);
    
    return textf;
}

#pragma mark -  Label工厂方法
+ (UILabel*)createLable:(NSString*)str attributeStr:(NSMutableAttributedString*)attributeStr font:(UIFont*)font textColor:(UIColor*)textColor alignment:(NSTextAlignment)alignment {
    
    UILabel *label = [[UILabel alloc] init];
    label.textAlignment = (!alignment) ? NSTextAlignmentLeft : alignment;
    label.text = str;
    label.textColor = textColor;
    label.font = font;
    label.numberOfLines = 0;
    label.lineBreakMode = NSLineBreakByTruncatingMiddle; //中间省略,保留头尾
    
    if (attributeStr.length>0) {
        label.attributedText = attributeStr;
    }
    
    CGSize lableSize = [label sizeThatFits:CGSizeZero];
    label.frame = CGRectMake(0, 0, lableSize.width, lableSize.height);
    
    return label;
}

#pragma mark -  Btn工厂方法
+ (UIButton*)createButton:(NSString*)str attributeStr:(NSMutableAttributedString*)attributeStr font:(UIFont*)font textColor:(UIColor*)textColor{
    
    UIButton *btn = [[UIButton alloc] init];
    btn.titleLabel.textAlignment = NSTextAlignmentCenter;
    [btn setTitle:str forState:UIControlStateNormal];
    [btn setTitleColor:textColor forState:UIControlStateNormal];
    btn.titleLabel.font = font;
    if (attributeStr.length>0) {
        [btn setAttributedTitle:attributeStr forState:UIControlStateNormal];
    }
    CGSize btnSize = [btn sizeThatFits:CGSizeZero];
    btn.frame = CGRectMake(0, 0, btnSize.width, btnSize.height);
    return btn;
    
}

@end
