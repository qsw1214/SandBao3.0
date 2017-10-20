//
//  Tool.m
//  sandbao
//
//  Created by tianNanYiHao on 2017/5/17.
//  Copyright © 2017年 sand. All rights reserved.
//

#import "Tool.h"
#import <UIKit/UIKit.h>
#import "CustomAlertView.h"
#import "SDSqlite.h"
#import "SqliteHelper.h"
#import "Base64Util.h"
#import "GzipUtility.h"
#import "LoginViewController.h"

#define Rgba(r,g,b,a) [UIColor colorWithRed:r/255.f green:g/255.f blue:b/255.f alpha:a]

@interface Tool(){
    
}


@end


@implementation Tool





#pragma mark - 弹出默认对话框+无事件处理
/**
 弹出(CustomAlertViewStyleDefault)对话框+无事件处理 (一般用于反馈后端resMsg)
 
 @param message 消息
 */
+ (void)showDialog:(NSString *)message{
    
    CustomAlertView* alertView = [[CustomAlertView alloc] initWithTitle:@"提示" message:message buttonTitles:@"确认",nil, nil];
    alertView.alertViewStyle = CustomAlertViewStyleDefault;
    
    [alertView showWithCompletion:^(NSInteger selectIndex) {
        if (selectIndex == 0) {
            // do  nothing
        }
    }];

}




#pragma mark - 弹出默认对话框+默认事件处理
/**
 弹出(CustomAlertViewStyleDefault)对话框+默认事件处理 (一般用于反馈后端resMsg,并需要处理一定事件如sToken失效提示后退出重登陆)
 
 @param message 消息
 @param defulblock 默认事件回调
 */
+ (void)showDialog:(NSString *)message defulBlock:(DefulBtnBlock)defulblock{
    CustomAlertView* alertView = [[CustomAlertView alloc] initWithTitle:@"提示" message:message buttonTitles:@"我知道了",nil, nil];
    alertView.alertViewStyle = CustomAlertViewStyleDefault;
    
    [alertView showWithCompletion:^(NSInteger selectIndex) {
        if (selectIndex == 0) {
            defulblock();
        }
    }];
}


#pragma mark - 弹出带标题对话框+事件处理
/**
  弹出(CustomAlertViewStyleDefault)带标题对话框+事件处理

 @param title 标题
 @param message 消息
 @param leftString 左边文字
 @param rightString 右边文字
 @param leftbtnblock 左按钮回调
 @param rightbtnblock 右按钮回调
 */
+ (void)showDialog:(NSString*)title message:(NSString*)message leftBtnString:(NSString*)leftString rightBtnString:(NSString*)rightString leftBlock:(LeftBtnBlock)leftbtnblock rightBlock:(RightBtnBlock)rightbtnblock{
    
    CustomAlertView* alertView = [[CustomAlertView alloc] initWithTitle:title message:message buttonTitles:leftString,rightString, nil];
    alertView.alertViewStyle = CustomAlertViewStyleDefault;
    
    [alertView showWithCompletion:^(NSInteger selectIndex) {
        if (selectIndex == 0) {
            leftbtnblock();
        }
        else if(selectIndex == 1){
            rightbtnblock();
        }
    }];
    
}


#pragma mark - 跳转登陆页
/**
 跳转登陆页(1.Stoken失效/2.点击退出按钮/3.MQTT异地登陆)
 
 @param viewController 当前控制器
 */
+(void)presetnLoginVC:(UIViewController*)viewController{
    
    //0.退出前 当前活跃状态的账户更新数据
    BOOL result = [SDSqlite updateData:[SqliteHelper shareSqliteHelper].sandBaoDB sql:[NSString stringWithFormat:@"update usersconfig set active = '%@', sToken = '%@' where active = '%@'", @"1", @"", @"0"]];
    if (result) {
        
        //1.清空Commparamater
        [[CommParameter sharedInstance] cleanCommParameter];
        
        //2. 登出->mqtt结束
        [[MqttClientManager shareInstance] close:YES];
        
        //3.跳转登陆页面
        LoginViewController *mLoginViewController = [[LoginViewController alloc] init];
        UINavigationController *navLogin = [[UINavigationController alloc] initWithRootViewController:mLoginViewController];
        [viewController presentViewController:navLogin animated:YES completion:nil];
        //4.原界面返回控制器主vc
        [viewController.navigationController popToRootViewControllerAnimated:NO];
    }else{
        return;
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
            
            NSString *countNum = [NSString stringWithFormat:@"%@",resultArrayOrder[j]];
            
            for (int a = 0; a<payTools.count; a++) {

                NSString *orderOld = [payTools[a] objectForKey:@"order"];
                
                if ([countNum isEqualToString:orderOld]) {
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
    return [UIImage imageWithCGImage:scaledImage];
}

#pragma mark - 头像图片转换(avatar的两种形式_1.文件形式的base64_2.网络Url的Base64)
/**
 头像图片转换
 
 @param avatar 头像base64字符串
 @return 图片img
 */
+(UIImage*)avatarImageWith:(NSString*)avatar{
    
    UIImage *image ;
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
    
    
    //确保有返回
    if (image==nil) {
        image = [UIImage imageNamed:@"banaba_cot"];
    }
    
    return image;
    
}



#pragma mark - 头像缓存获取
+ (UIImage*)headAvatarDataGetWithSQLUid:(NSString*)uid{
    
    NSDictionary *userImageDataDic = [[NSUserDefaults standardUserDefaults] objectForKey:[NSString stringWithFormat:@"HEAD_AVATAR_DATA%@",uid]];
    NSData *userImageData = [userImageDataDic objectForKey:@"data"];
    
    UIImage *headImage;
    
    if (userImageData) {
        headImage = [UIImage imageWithData:userImageData];
    }else{
        headImage = [UIImage imageNamed:@"banaba_cot"];
    }
    
    return headImage;
    
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
                backgroundColor = Rgba(234, 85, 115, 1.0);backgroundColor2 = Rgba(158, 14, 14, 1.0);
            }
            if (i == 1) {
                //天空蓝
                backgroundColor = Rgba(0, 191, 255, 1.0);backgroundColor2 = Rgba(7, 78, 218, 1.0);
            }
            if (i == 2) {
                //草绿
                backgroundColor = Rgba(154, 205, 50, 1.0);backgroundColor2 = Rgba(85, 171, 5, 1.0);
            }
            if (i == 3) {
                //红色
                backgroundColor = Rgba(234, 85, 115, 1.0);backgroundColor2 = Rgba(158, 14, 14, 1.0);
            }
            if (i == 4) {
                //天空蓝
                backgroundColor = Rgba(0, 191, 255, 1.0);backgroundColor2 = Rgba(7, 78, 218, 1.0);
            }
            if (i == 5) {
                //红色
                backgroundColor = Rgba(234, 85, 115, 1.0);backgroundColor2 = Rgba(158, 14, 14, 1.0);
            }
            if (i == 6) {
                //橘黄
                backgroundColor = Rgba(255, 127, 36, 1.0);backgroundColor2 = Rgba(255, 201, 38, 1.0);
            }
            if (i == 7) {
                //天空蓝
                backgroundColor = Rgba(0, 191, 255, 1.0);backgroundColor2 = Rgba(7, 78, 218, 1.0);
            }
            if (i == 8) {
                //红色
                backgroundColor = Rgba(234, 85, 115, 1.0);backgroundColor2 = Rgba(158, 14, 14, 1.0);
            }
            if (i == 9) {
                //红色
                backgroundColor = Rgba(234, 85, 115, 1.0);backgroundColor2 = Rgba(158, 14, 14, 1.0);
            }
            if (i == 10) {
                //天空蓝
                backgroundColor = Rgba(0, 191, 255, 1.0);backgroundColor2 = Rgba(7, 78, 218, 1.0);
            }
            if (i == 11) {
                //橘黄
                backgroundColor = Rgba(255, 127, 36, 1.0);backgroundColor2 = Rgba(255, 201, 38, 1.0);
            }
            if (i == 12) {
                //橘黄
                backgroundColor = Rgba(255, 127, 36, 1.0);backgroundColor2 = Rgba(255, 201, 38, 1.0);
            }
            if (i == 13) {
                //橘黄
                backgroundColor = Rgba(255, 127, 36, 1.0);backgroundColor2 = Rgba(255, 201, 38, 1.0);
            }
            if (i == 14) {
                //红色
                backgroundColor = Rgba(234, 85, 115, 1.0);backgroundColor2 = Rgba(158, 14, 14, 1.0);
            }
            if (i == 15) {
                //橘黄
                backgroundColor = Rgba(255, 127, 36, 1.0);backgroundColor2 = Rgba(255, 201, 38, 1.0);
            }
            if (i == 16) {
                //草绿
                backgroundColor = Rgba(154, 205, 50, 1.0);backgroundColor2 = Rgba(85, 171, 5, 1.0);
            }
            if (i == 17) {
                //红色
                backgroundColor = Rgba(234, 85, 115, 1.0);backgroundColor2 = Rgba(158, 14, 14, 1.0);
            }
            if (i == 18) {
                //天空蓝
                backgroundColor = Rgba(0, 191, 255, 1.0);backgroundColor2 = Rgba(7, 78, 218, 1.0);
            }
            if (i == 19) {
                //天空蓝
                backgroundColor = Rgba(0, 191, 255, 1.0);backgroundColor2 = Rgba(7, 78, 218, 1.0);
            }
            if (i == 20) {
                //天空蓝
                backgroundColor = Rgba(0, 191, 255, 1.0);backgroundColor2 = Rgba(7, 78, 218, 1.0);
            }
            if (i == 21) {
                //红色
                backgroundColor = Rgba(234, 85, 115, 1.0);backgroundColor2 = Rgba(158, 14, 14, 1.0);
            }
            if (i == 22) {
                //红色
                backgroundColor = Rgba(234, 85, 115, 1.0);backgroundColor2 = Rgba(158, 14, 14, 1.0);
            }
            if (i == 23) {
                //红色
                backgroundColor = Rgba(234, 85, 115, 1.0);backgroundColor2 = Rgba(158, 14, 14, 1.0);
            }
            if (i == 24) {
                //天空蓝
                backgroundColor = Rgba(0, 191, 255, 1.0);backgroundColor2 = Rgba(7, 78, 218, 1.0);
            }
        }
    }
    arrayInfo = @[iconImage,iconWatermarkImage,backgroundColor,backgroundColor2];
    return arrayInfo;

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
    else if([@"PAYLIST_BTN_ADDCARD" isEqualToString:type]){ //添加卡按钮
        if ([imaUrl isEqualToString:@"list_yinlian_AddCard"]) {
            return @"list_yinlian_AddCard";
        }else if ([imaUrl isEqualToString:@"list_sand_AddCard"]){
            return @"list_sand_AddCard";
        }
    }
    return @"qvip_pay_imageholder";
}

#pragma mark -  Label工厂方法
+ (UILabel*)createLable:(NSString*)str attributeStr:(NSMutableAttributedString*)attributeStr font:(UIFont*)font textColor:(UIColor*)textColor alignment:(NSTextAlignment)alignment {
    
    UILabel *label = [[UILabel alloc] init];
    label.textAlignment = (!alignment) ? NSTextAlignmentLeft : alignment;
    label.text = str;
    label.textColor = textColor;
    label.font = font;
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

#pragma mark -  BarBtn工厂方法
+ (UIButton*)createBarButton:(NSString*)str font:(UIFont*)font titleColor:(UIColor*)titleColor backGroundColor:(UIColor*)groundColor leftSpace:(CGFloat)space{
    
    UIButton *btn = [[UIButton alloc] init];
    [btn setBackgroundImage:[UIImage imageWithColor:groundColor] forState:UIControlStateNormal];
    [btn setBackgroundImage:[UIImage imageWithColor: [UIColor colorWithRed:53/255.0 green:139/255.0 blue:239/255.0 alpha:1/1.0]] forState:UIControlStateHighlighted];
    btn.layer.cornerRadius = 5.f;
    btn.layer.masksToBounds = YES;
    UILabel *midLab = [[UILabel alloc] init];
    midLab.textAlignment = NSTextAlignmentCenter;
    midLab.textColor = titleColor;
    midLab.font = font;
    midLab.text = str;
    [btn addSubview:midLab];
    
    //frame
    CGFloat upSpace = 20;
    CGSize midLabSize = [midLab sizeThatFits:CGSizeZero];
    
    CGFloat selfWidth = [UIScreen mainScreen].bounds.size.width - 2*space;
    CGFloat selfHeight = upSpace*2 + midLabSize.height;
    btn.frame = CGRectMake(0, 0, selfWidth, selfHeight);
    
    midLab.frame = CGRectMake(0, 0, midLabSize.width, midLabSize.height);
    midLab.center = btn.center;
    
    return btn;
}



@end
