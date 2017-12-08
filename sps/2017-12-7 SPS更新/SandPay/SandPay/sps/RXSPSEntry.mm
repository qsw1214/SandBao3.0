//
//  RXSPSEntry.m
//  sps2-dev
//
//  Created by Rick Xing on 6/24/13.
//  Copyright (c) 2013 Rick Xing. All rights reserved.
//

#import "RXSPSEntry.h"
#import "RXSPSOperation.h"
#import "RXCheckout.h"
#import "Global.h"
#import "SVProgressHUD_sps.h"
#import "UPPaymentControl.h"
#import <CommonCrypto/CommonDigest.h>
#include "RXSandPayCore.h"
#include "RunCode.h"
#include "RXSPSCode.h"
#include "rx_md5.h"
#include "rx_des.h"
#include "rx_coder_pii.h"
#include "xstring.h"
#include "gv.h"

using namespace sz;

#define BTN_TAG_START   100

@interface RXSPSEntry () {
    RXCheckout* checkout;
    BOOL isFirst;
    UIView* loadingview;
    NSMutableArray *subPayTypes;
    UIButton * payToolsBtns[PayToolsMAX];
    int payMode;
    int ThreadCode;
    UIViewController *currentVC;

}

@property (nonatomic, assign) CGSize viewSize;

@end

@implementation RXSPSEntry
@synthesize delegate,isSignMessage;
@synthesize viewSize;
#define iPhone5 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 1136), [[UIScreen mainScreen] currentMode].size) : NO)
#define IOS7 ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0 ? YES :NO)
static RXSPSEntry *sharedInstance = nil;

+ (RXSPSEntry*)sharedInstance{
    if (sharedInstance == nil) {
        sharedInstance = [[super allocWithZone:NULL] init];
    }
    return sharedInstance;
}

- (id)copyWithZone:(NSZone *)zone {
    return self;
}

- (void)dealloc{
    [loadingview release];
    [checkout release];
    [super dealloc];
}

- (void)cancelButtonClicked:(id)sender{
    
    if (self.presentingViewController) {
        [self dismissViewControllerAnimated:YES completion:nil];
    } else {
        [self.navigationController popViewControllerAnimated:YES];
    }
    NSString *returnString = @"{\"responseCode\":\"100001\",\"rspMsg\":\"交易退出\"}";
    [self.delegate RXSPSReturn:returnString];
 
    
}

/**
 *@brief 加密用户密码
 *@param userPwd    字符串  用户密码
 *@return NSString
 */
- (NSString *)encryptorUserPwd:(NSString *)userPwd
{
    return [NSString stringWithUTF8String:payCore.EncryptUserPass([userPwd UTF8String]).Buffer()];
}

/**
 *@brief 加密支付密码
 *@param payPwd    字符串  支付密码
 *@return NSString
 */
- (NSString *)encryptorPayPwd:(NSString *)payPwd
{
    return [NSString stringWithUTF8String:payCore.EncryptAccPass([payPwd UTF8String]).Buffer()];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.navigationItem.title = @"杉德安全支付";
    
    viewSize = self.view.bounds.size;
    
    [Global set_BridgeDelegate:self];
    
    BOOL isPayment = YES ;
    
    loadingview = [[UIView alloc] initWithFrame:self.view.bounds];
    
    UIBarButtonItem *cancel = [[[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStylePlain target:self action:@selector(cancelButtonClicked:)] autorelease];
    self.navigationItem.backBarButtonItem = [[[UIBarButtonItem alloc] initWithTitle:@"返回" style:UIBarButtonItemStylePlain target:self action:nil] autorelease];
    self.navigationItem.rightBarButtonItem = cancel ;
    [self.navigationController.navigationBar setTintColor:[UIColor orangeColor]];

    NSString *spsbg_960 = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"sandpay.bundle/images/spsbg_960.jpg"];
    UIImageView *backImage = [[UIImageView alloc]initWithFrame:self.view.bounds];
    backImage.image = [UIImage imageWithContentsOfFile:spsbg_960];
    backImage.contentMode = UIViewContentModeScaleToFill;
    [loadingview addSubview:backImage];
    [backImage release];
    
    UIImageView *logoView = [[UIImageView alloc] init];
    logoView.frame = isPayment ? CGRectMake((viewSize.width - 70) / 2, 30, 70, 37):CGRectMake((viewSize.width - 63) / 2, 30, 63, 56);
    NSString *sps_logoPath = isPayment ? [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"sandpay.bundle/images/payment_logo_M.png"]: [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"sandpay.bundle/images/sps_logo.png"];
    logoView.image = [UIImage imageWithContentsOfFile:sps_logoPath ];
    [loadingview addSubview:logoView];
    [logoView release];
    
    UIImageView *titleView = [[UIImageView alloc] initWithFrame:CGRectMake(0,90, viewSize.width, 81)];
    NSString *sps_titlePath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"sandpay.bundle/images/sps_title.png"];
    titleView.image = [UIImage imageWithContentsOfFile:sps_titlePath];
    [loadingview addSubview:titleView];
    [titleView release];
    
    if(isPayment){
        UIImageView *juzhangView = [[UIImageView alloc] init];
        NSString *sps_juzhangPath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"sandpay.bundle/images/payment_logo.png"];
        juzhangView.image = [UIImage imageWithContentsOfFile:sps_juzhangPath];
        [loadingview addSubview:juzhangView];
        
        UILabel *label = [[UILabel alloc]init];
        label.textColor = [UIColor whiteColor];
        label.font = [UIFont boldSystemFontOfSize:15];
        label.text = @"杉德支付网络服务发展有限公司" ;
        label.backgroundColor = [UIColor clearColor];
        [loadingview addSubview:label];
        
        CGFloat juzhangViewW = 46;
        CGFloat juzhangViewH = 23;
        CGFloat juzhangViewOY = [UIScreen mainScreen].bounds.size.height-70;
        
        CGSize labelSize = [label.text sizeWithFont:label.font];
        
        CGFloat labelW = labelSize.width;
        
        CGFloat juzhangViewOX = (viewSize.width - juzhangViewW - 5 - labelW) / 2;
        
        CGFloat labelH = juzhangViewH;
        CGFloat labelOX = juzhangViewOX + juzhangViewW + 5;
        CGFloat labelOY = [UIScreen mainScreen].bounds.size.height-70;
        
        juzhangView.frame = CGRectMake(juzhangViewOX, juzhangViewOY, juzhangViewW, juzhangViewH);
        label.frame = CGRectMake(labelOX, labelOY, labelW, labelH);
        
        [juzhangView release];
        [label release];
    }else{
        UIImageView *juzhangView = [[UIImageView alloc] initWithFrame:CGRectMake(38,[UIScreen mainScreen].bounds.size.height-70,viewSize.width - 2 * 38, 23)];
        NSString *sps_juzhangPath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"sandpay.bundle/images/sps_juzhang.png"];
        juzhangView.image = [UIImage imageWithContentsOfFile:sps_juzhangPath];
        [loadingview addSubview:juzhangView];
        [juzhangView release];
    }
    
    {
        UIActivityIndicatorView* Control = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
        Control.frame = CGRectMake(viewSize.width / 2, 220, 0, 0);
        [Control startAnimating];
        [loadingview addSubview:Control];
        [Control release];
    }
    {
        UILabel* Label = [[UILabel alloc] initWithFrame:CGRectMake(10, 260, viewSize.width - 2 * 10, 24)];
        Label.font = [UIFont fontWithName:@"Verdana" size:20];
        Label.textAlignment = NSTextAlignmentCenter;
        Label.textColor = [UIColor colorWithRed:255 green:250 blue:250 alpha:1];
        Label.backgroundColor = [UIColor clearColor];
        NSMutableString* Label_Text = [[[NSMutableString alloc] init] autorelease];
        [Label_Text appendFormat:@"正在加载数据"];
        Label.text = Label_Text;
        [loadingview addSubview:Label];
        [Label release];
    }
    
    UIImageView *lineView = [[UIImageView alloc] initWithFrame:CGRectMake(0,[UIScreen mainScreen].bounds.size.height-45,viewSize.width,4)];
    NSString *sps_linePath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"sandpay.bundle/images/sps_line.png"];
    lineView.image = [UIImage imageWithContentsOfFile:sps_linePath];
    [loadingview addSubview:lineView];
    [lineView release];
    
    {
        UILabel* Label = [[UILabel alloc] initWithFrame:CGRectMake(10, [UIScreen mainScreen].bounds.size.height-45, viewSize.width - 2 * 10, 24)];
        Label.font = [UIFont fontWithName:@"Verdana" size:14];
        Label.textAlignment = NSTextAlignmentCenter;
        Label.textColor = [UIColor colorWithRed:255 green:250 blue:250 alpha:1];
        Label.backgroundColor = [UIColor clearColor];
        NSMutableString* Label_Text = [[[NSMutableString alloc] init] autorelease];
        [Label_Text appendFormat:@"版权所有"];
        Label.text = Label_Text;
        [loadingview addSubview:Label];
        [Label release];
    }

    [self.view  addSubview:loadingview];
}

- (void)viewWillAppear:(BOOL)animated{
    if(!isFirst){
        [self.navigationController setNavigationBarHidden:YES];
        isFirst = YES ;
    }else{
        [self.navigationController setNavigationBarHidden:NO];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)CallSps:(NSString *)jsonData
{
//    payCore.TestMode();// 测试环境，正式环境要屏蔽
    NSData * order_data = [jsonData dataUsingEncoding:NSUTF8StringEncoding];
    char temp[4096] = {0};
    memcpy(temp, [order_data bytes], [order_data length]);
    
    payCore.SetMerData(temp);
    

    //Loading
    
    RXSPSOperation * operation = [[[RXSPSOperation alloc] init] autorelease];
    operation.delegate = self;
    operation.ThreadCode = SPS_Thread_Code_Loading;
    NSOperationQueue * operationQueue = [[[NSOperationQueue alloc] init] autorelease];
    [operationQueue addOperation:operation];
}

- (void)OperationEnd:(NSNumber*)runCode
{
    RunCode = [runCode intValue];
    NSLog(@"OperationEnd:%d", RunCode);
    if (ThreadCode == SPS_Thread_Code_RechargePay) { //支付成功
        NSLog(@"进入支付回调函数++++");
        
        if(RunCode == RunCode_Ok)
        {
            [SVProgressHUD_sps dismiss];
            if(payMode == 1 || payMode == 2 || payMode == 7)
            {
                
                NSString *returnString = @"{\"responseCode\":\"100000\",\"rspMsg\":\"充值成功\"}";
                [self.delegate RXSPSReturn:returnString];
            }
            
            if(payMode == 5)
            {
                
                NSLog(@"%@", [NSString stringWithUTF8String:payCore.UnionPayTN.Buffer()]);
                // 00 正式 01 测试
                 [[UPPaymentControl defaultControl] startPay:[NSString stringWithUTF8String:payCore.UnionPayTN.Buffer()] fromScheme:@"SandLife" mode:@"00" viewController:currentVC];
                
            }
            if (payMode == 4) {
                NSString *returnString = @"{\"responseCode\":\"100000\",\"rspMsg\":\"充值成功\"}";
                [self.delegate RXSPSReturn:returnString];
            }
            
            
        }
        else if(RunCode == RunCode_PayCore_Error){
            //[SVProgressHUD_sps dismissWithError:[NSString stringWithUTF8String:payCore.respResult.Buffer()]];
             NSString *returnString = [NSString stringWithFormat:@"{\"responseCode\":\"%@\",\"rspMsg\":\"%@\"}",[NSString stringWithUTF8String:payCore.respCode.Buffer()],[NSString stringWithUTF8String:payCore.respResult.Buffer()]];
//            NSString *returnString = @"{\"responseCode\":\"100005\",\"rspMsg\":\"服务器应答错误\"}";
            [self.delegate RXSPSReturn:returnString];
            
        }else if(RunCode == RunCode_Network_Error){
            
            NSString *returnString = @"{\"responseCode\":\"100003\",\"rspMsg\":\"网络通信异常\"}";
            [self.delegate RXSPSReturn:returnString];
            //[SVProgressHUD_sps dismissWithError:@"网络通信异常,请重试!"];
        }else{
            NSString *returnString = @"{\"responseCode\":\"100002\",\"rspMsg\":\"交易异常\"}";
            [self.delegate RXSPSReturn:returnString];
            //[SVProgressHUD_sps dismissWithError:@"处理异常,请重试!"];
        }
        
        ThreadCode = 0;
        
    }
    else {
        if(RunCode == RunCode_Ok)
        {
            [loadingview   removeFromSuperview];
            checkout = [[RXCheckout alloc] init] ;
            checkout.nav = self.navigationController;
            [self.view addSubview:checkout.view];
            [self.navigationController setNavigationBarHidden:NO];
            
        }
        else if (RunCode == RunCode_PayCore_Error)
        {
//            UIAlertView * alertView =[[UIAlertView alloc]
//                                      initWithTitle:@"交易出现如下错误"    //paycore后台逻辑有问题，返回错误的信息，这里手动填写了
//                                      message:[NSString stringWithUTF8String:payCore.respResult.Buffer()]
//                                      delegate:self
//                                      cancelButtonTitle:@"确定"
//                                      otherButtonTitles:nil];
//            [alertView show];
//            [alertView release];
            UIAlertView * alertView =[[UIAlertView alloc]
                                      initWithTitle:@"交易出现如下错误"
                                      message:@"交易出错"
                                      delegate:self
                                      cancelButtonTitle:@"确定"
                                      otherButtonTitles:nil];
            [alertView show];
            [alertView release];

            
        }
        else
        {
//            UIAlertView * alertView =[[UIAlertView alloc]
//                                      initWithTitle:@"操作终止"
//                                      message:[NSString stringWithUTF8String:payCore.respResult.Buffer()]
//                                      delegate:self
//                                      cancelButtonTitle:@"退出"
//                                      otherButtonTitles:nil];
//            [alertView show];
//            [alertView release];
            UIAlertView * alertView =[[UIAlertView alloc]
                                      initWithTitle:@"操作终止"
                                      message:@"出现错误"
                                      delegate:self
                                      cancelButtonTitle:@"退出"
                                      otherButtonTitles:nil];
            [alertView show];
            [alertView release];

        }
    
    }
   
}


- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    switch (buttonIndex) {
        case 0:
        {
            [self ExitSps];
            break;
        }
        default:
            break;
    }
}

- (void)ExitSps
{
    NSMutableString * SPSCode = [[[NSMutableString alloc] init] autorelease];
    NSMutableString * SPSMsg  = [[[NSMutableString alloc] init] autorelease];
    
    switch (RunCode) {
        case RunCode_Ok:
        {
            [SPSCode setString:SPS_OK];
            [SPSMsg setString:SPS_OK_MSG];
            break;
        }
        case RunCode_Network_Error:
        {
            [SPSCode setString:SPS_NET_ERROR];
            [SPSMsg setString:SPS_NET_ERROR_DESC];
            break;
        }
        case RunCode_PayCore_Error:
        {
            [SPSCode setString:SPS_SERVER_RESP_ERROR];
            [SPSMsg setString:SPS_SERVER_RESP_ERROR_DESC];
            break;
        }
        case RunCode_User_Cancel:
        {
            [SPSCode setString:SPS_USER_EXIT];
            [SPSMsg setString:SPS_USER_EXIT_MSG];
            break;
        }
        default:
        {
            [SPSCode setString:SPS_UNKNOWN_ERROR];
            [SPSMsg setString:SPS_UNKNOWN_ERROR_DESC];
            break;
        }
    }
    
    NSString *jsonString = [NSString stringWithFormat:@"{\"responseCode\":\"%@\",\"rspMsg\":\"%@\"}",SPSCode,SPSMsg];
    [self.delegate RXSPSReturn:jsonString];
    
    [self dismissModalViewControllerAnimated:YES];
//    [self.navigationController popViewControllerAnimated:YES];
}


/**
 *@brief   拼接报文
 *@param busiType    字符串  业务类型
 *@return NSString
 */
- (NSString *)bizUP:(NSString *)busiType
{
//    payCore.TestMode();// 测试环境，正式环境要屏蔽
    return [NSString stringWithUTF8String:payCore.Biz_UP([busiType UTF8String]).Buffer()];
}

/**
 *@brief   解析报文
 *@param recvData    字符串  请求返回报文
 *@return NSInteger  0代表成功，1代表失败
 */
- (NSInteger)bizDOWN:(NSString *)recvData
{
    if (payCore.Biz_DOWN([recvData UTF8String]) == RXSandPayCore::HANDLE_OK) {
        return 0;
    } else {
        return 1;
    }
}


- (void)threadCodeSteps
{
    
    //3Steps
//    payCore.TestMode(); //测试环境，正式环境要屏蔽
    RXSPSOperation * operation = [[[RXSPSOperation alloc] init] autorelease];
    operation.delegate = self;
    operation.ThreadCode = SPS_Thread_Code_3Steps;
    NSOperationQueue * operationQueue = [[[NSOperationQueue alloc] init] autorelease];
    [operationQueue addOperation:operation];
}

- (NSString *)sendSignMessage:(NSString *)busiType busiInfo:(NSString *)busiInfo memberID:(NSString *)memberId  sid:(NSString *)sid{
    NSMutableArray *dataArray = [[NSMutableArray alloc]init];
    [dataArray addObject:[NSString stringWithFormat:@"version=%@",[NSString stringWithUTF8String:payCore.version.Buffer()]]];
    [dataArray addObject:[NSString stringWithFormat:@"charset=%@",[NSString stringWithUTF8String:payCore.charset.Buffer()]]];
    [dataArray addObject:[NSString stringWithFormat:@"accessChannelNo=%@",[NSString stringWithUTF8String:payCore.accessChannelNo.Buffer()]]];
    [dataArray addObject:[NSString stringWithFormat:@"accessType=%@",[NSString stringWithUTF8String:payCore.accessType.Buffer()]]];
    [dataArray addObject:[NSString stringWithFormat:@"commType=%@",[NSString stringWithUTF8String:payCore.commType.Buffer()]]];
    [dataArray addObject:[NSString stringWithFormat:@"deviceType=%@",[NSString stringWithUTF8String:payCore.deviceType.Buffer()]]];
    [dataArray addObject:[NSString stringWithFormat:@"deviceInfo=%@",[NSString stringWithUTF8String:payCore.deviceInfo.Buffer()]]];
    [dataArray addObject:[NSString stringWithFormat:@"attachDeviceType=%@",[NSString stringWithUTF8String:payCore.attachDeviceType.Buffer()]]];
    [dataArray addObject:[NSString stringWithFormat:@"attachDeviceInfo=%@",[NSString stringWithUTF8String:payCore.attachDeviceInfo.Buffer()]]];
    
    NSString *clientSecurityInfo = [NSString stringWithFormat:@"clientSecurityInfo={\"memid\":\"%@\",\"sessionid\":\"%@\",\"token\":\"%@\",\"uuid\":\"%@\",\"sid\":\"%@\"}",memberId,[NSString stringWithUTF8String:payCore._sessionid.Buffer()],[NSString stringWithUTF8String:payCore._token.Buffer()],[NSString stringWithUTF8String:payCore._uuid.Buffer()],sid];
    [dataArray addObject:clientSecurityInfo];
    [dataArray addObject:@"apiName="];
    [dataArray addObject:[NSString stringWithFormat: @"busiType=%@",busiType]];
    [dataArray addObject:[NSString stringWithFormat: @"busiInfo=%@",busiInfo]];
    
    NSMutableString *signString = [[NSMutableString alloc]init];
    NSMutableString *request = [[NSMutableString alloc]init];
    [request appendString:@"{"];
    for (NSInteger i=0 ; i<dataArray.count; i++) {
        NSArray  *subs = [[dataArray objectAtIndex:i] componentsSeparatedByString:@"="];
        if(subs.count ==2){
            [signString appendString:[subs objectAtIndex:1]];
            if([[subs objectAtIndex:0] isEqualToString:@"attachDeviceInfo"]||[[subs objectAtIndex:0] isEqualToString:@"busiInfo"]||[[subs objectAtIndex:0] isEqualToString:@"clientSecurityInfo"]||[[subs objectAtIndex:0] isEqualToString:@"deviceInfo"]){
                [request appendString:[NSString stringWithFormat:@"\"%@\":%@",[subs objectAtIndex:0],[subs objectAtIndex:1]]];
            }else{
              [request appendString:[NSString stringWithFormat:@"\"%@\":\"%@\"",[subs objectAtIndex:0],[subs objectAtIndex:1]]];
            }
            
        }else{
            NSLog(@"签名数据异常");
        }
        if(i<dataArray.count-1){
            [signString appendString:@"&"];
        }
        [request appendString:@","];
    }
    
    [request appendString:@"\"signType\":\"SAS\""];
    [request appendString:@","];
    XString recvData;
    NSLog(@"%@",signString);
    recvData = payCore.Biz_Sign([signString UTF8String]);
    [request appendString:[NSString stringWithFormat:@"\"sign\":\"%@\"",[NSString stringWithUTF8String:recvData.Buffer()]]];
    [request appendString:@"}"];
    
    return  request ;
}


- (void)OperationEnd_3Steps:(NSNumber*)runCode
{
    RunCode = [runCode intValue];
    NSLog(@"OperationEnd_3Steps:=======%d", RunCode);
    
    [self ExitSps];
}
#pragma mark 充值过程
//本地登录
- (NSMutableDictionary *)localLoginWithMemId:(NSString *)memId sessionId:(NSString*)sessionId
{
    NSMutableDictionary *returnRecvdataDic = [[NSMutableDictionary alloc] init];

    if (memId && sessionId) {
        
        payCore.lgnType = [@"4" UTF8String];
        payCore._memid =  [memId UTF8String];
        payCore._sid = [sessionId UTF8String];
        
        XString sendData = payCore.Biz_UP([@"00040001" UTF8String]);
        RXSPSOperation * operation = [[[RXSPSOperation alloc] init] autorelease];
        XString  recvdata = [operation Transmit:sendData];
        NSString *recvdataString = [NSString stringWithUTF8String:recvdata.Buffer()];
       
        [returnRecvdataDic setObject:recvdataString forKey:@"receiveData"];
        
        payCore.Biz_DOWN([operation Transmit:sendData]);
        if(operation.ReturnCode ==0){
            
            [returnRecvdataDic setObject:@"0000" forKey:@"rspCode"];
        }
        else {
            [returnRecvdataDic setObject:@"1111" forKey:@"rspCode"];
        }
    }
    
    else {
        [returnRecvdataDic setObject:@"1111" forKey:@"rspCode"];
    }
    return returnRecvdataDic;
}

//2、账户数据请求
- (NSMutableDictionary*)requestAccData:(NSString*)accountNum
{
    
    NSMutableDictionary *responseDic = [[NSMutableDictionary alloc] init];
    
    payCore.b3t10_an = [@"02" UTF8String];
    payCore.b3t10_rechargemid = [accountNum UTF8String];
    XString sendData = payCore.Biz_UP([@"00030010" UTF8String]);
    RXSPSOperation * operation = [[[RXSPSOperation alloc] init] autorelease];
    XString  recvdata = [operation Transmit:sendData];
    
    NSString *recvdataString = [NSString stringWithUTF8String:recvdata.Buffer()];
    [responseDic setObject:recvdataString forKey:@"receiveData"];
    
    payCore.Biz_DOWN(recvdata);
    
    if(operation.ReturnCode ==0){
       [responseDic setObject:@"0000" forKey:@"rspCode"];
    } else {
        [responseDic setObject:@"1111" forKey:@"rspCode"];
    }
    
    return responseDic;
}

//充值检查
- (NSMutableDictionary*)rechargeCheck:(NSDictionary*)targetsMapDic
{
    NSMutableDictionary *returnRecvdataDic = [[NSMutableDictionary alloc] init];
    
    NSString *tgid = [targetsMapDic objectForKey:@"id"];
    NSString *tgmid = [targetsMapDic objectForKey:@"mid"];
    NSString *tgtgid = [targetsMapDic objectForKey:@"targetid"];
    NSString *tgtgtp = [targetsMapDic objectForKey:@"targettype"];
    NSString *tgpid = [targetsMapDic objectForKey:@"payid"];
    NSString *medium = [targetsMapDic objectForKey:@"medium"];
    
    payCore.b3t2_tgid= [tgid UTF8String];
    payCore.b3t2_tgmid= [tgmid UTF8String];
    payCore.b3t2_tgtgid= [tgtgid UTF8String];
    payCore.b3t2_tgtgtp= [tgtgtp UTF8String];
    payCore.b3t2_tgpid= [tgpid UTF8String];
    payCore.b3t2_mediumType= [@"2" UTF8String];
    payCore.b3t2_medium= [medium UTF8String];
    payCore.b3t2_subAccType= [@"4" UTF8String];
    
    XString  sendData = payCore.Biz_UP([@"00030002" UTF8String]);
    RXSPSOperation * operation = [[[RXSPSOperation alloc] init] autorelease];
    
    XString  recvdata = [operation Transmit:sendData];
     NSLog(@"rechargeCheckrecvdata===%@",[NSString stringWithUTF8String:recvdata.Buffer()]);
    
    NSString *recvdataString = [NSString stringWithUTF8String:recvdata.Buffer()];
    
    [returnRecvdataDic setObject:recvdataString forKey:@"receiveData"];
    
    payCore.Biz_DOWN(recvdata);
    if(operation.ReturnCode ==0){
        payCore.SetPayTools();
        [returnRecvdataDic setObject:@"0000" forKey:@"rspCode"];
        
    }
    else {
        [returnRecvdataDic setObject:@"1111" forKey:@"rspCode"];
       
    }
    return returnRecvdataDic;
}


//遍历支付工具
- (NSMutableArray*)getPayTools
{
    subPayTypes = [[NSMutableArray alloc] init];
    int index = 0;
    for(int i = 0; i < payCore.kids_len; i++)
    {
        int num_of_valid_orgids = 0;
        for(int j = 0; j < payCore.kids[i].tids_len; j++)
        {
            for(int k = 0; k < payCore.kids[i].tids[j].orgids_len; k++)
            {
                if(payCore.kids[i].tids[j].orgids[k]._valid)
                {
                    num_of_valid_orgids++;
                }
            }
        }
        
        if(num_of_valid_orgids == 0)
        {
            continue;
        }
        
        
        for(int j = 0; j < payCore.kids[i].tids_len; j++)
        {
            for(int k = 0; k < payCore.kids[i].tids[j].orgids_len; k++)
            {
                if(payCore.kids[i].tids[j].orgids[k]._valid)
                {
                    if(payCore.kids[i].tids[j].orgids[k].cardaccs_len > 0)
                    {
                        for(int l = 0; l < payCore.kids[i].tids[j].orgids[k].cardaccs_len; l++)
                        {
                            ptPaths[index].i = i;
                            ptPaths[index].j = j;
                            ptPaths[index].k = k;
                            ptPaths[index].l = l;
                            //02 A01 B000001
                            
                            NSMutableString* btn_text = [[[NSMutableString alloc] init] autorelease];
                            [btn_text appendFormat:@"%@", [NSString stringWithUTF8String:payCore.kids[i].tids[j].orgids[k].payservcie_description.Buffer()]];
                            if(payCore.kids[i].kid == "02"
                               && payCore.kids[i].tids[j].tid == "A01"
                               && payCore.kids[i].tids[j].orgids[k].orgid == "B0000001"){
                                [btn_text appendFormat:@"(%@****",
                                 [NSString stringWithUTF8String:payCore.kids[i].tids[j].orgids[k].cardaccs[l].medium.Left(4).Buffer()]];
                                [btn_text appendFormat:@"%@)",
                                 [NSString stringWithUTF8String:payCore.kids[i].tids[j].orgids[k].cardaccs[l].medium.Right(4).Buffer()]];
                            }else{
                                //[btn_text appendFormat:@"(余额:%@元)",[NSString stringWithFormat:@"%.2f", [[NSString stringWithUTF8String: payCore.kids[i].tids[j].orgids[k].cardaccs[l].accBal.Buffer()] intValue] / 100.0 ]];
                            }
                            
                            
                            payTools_Text[index] = [btn_text UTF8String];
                            
                            NSArray *subs = [btn_text componentsSeparatedByString:@"手机"];
                            if(subs.count==2){
                                [subPayTypes addObject:[subs objectAtIndex:1]];
                            }else{
                                [subPayTypes addObject:[subs objectAtIndex:0]];
                            }
                            
                            payToolsBtns[index] = [UIButton buttonWithType:UIButtonTypeRoundedRect];
                            //payToolsBtns[index].backgroundColor = [UIColor brownColor];
                            payToolsBtns[index].tag = BTN_TAG_START + index;
                            [payToolsBtns[index] setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
                            [payToolsBtns[index] setTitle:btn_text forState:UIControlStateNormal];
                            [payToolsBtns[index] addTarget:self action:@selector(buttonPayToolClicked:) forControlEvents:UIControlEventTouchUpInside];
                            index++;
                            
                        } // l
                    }
                    else
                    {
                        ptPaths[index].i = i;
                        ptPaths[index].j = j;
                        ptPaths[index].k = k;
                        ptPaths[index].l = -1;
                        
                        
                        if(payCore.kids[i].kid == "02"
                           && payCore.kids[i].tids[j].tid == "A01"
                           && payCore.kids[i].tids[j].orgids[k].orgid == "B0000001"){
                            
                        }else{
                            NSMutableString* btn_text = [[[NSMutableString alloc] init] autorelease];
                            [btn_text appendFormat:@"%@", [NSString stringWithUTF8String:payCore.kids[i].tids[j].orgids[k].payservcie_description.Buffer()]];
                            payTools_Text[index] = [btn_text UTF8String];
                            
                            NSArray *subs = [btn_text componentsSeparatedByString:@"手机"];
                            if(subs.count==2){
                                if([[subs objectAtIndex:1] isEqualToString:@"银联"]){
                                    [subPayTypes addObject:@"银联手机支付"];
                                }else{
                                    [subPayTypes addObject:[subs objectAtIndex:1]];
                                }
                            }else{
                                [subPayTypes addObject:[subs objectAtIndex:0]];
                            }
                            
                            payToolsBtns[index] = [UIButton buttonWithType:UIButtonTypeRoundedRect];
                            //payToolsBtns[index].backgroundColor = [UIColor brownColor];
                            payToolsBtns[index].tag = BTN_TAG_START + index;
                            [payToolsBtns[index] setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
                            [payToolsBtns[index] setTitle:btn_text forState:UIControlStateNormal];
                            [payToolsBtns[index] addTarget:self action:@selector(buttonPayToolClicked:) forControlEvents:UIControlEventTouchUpInside];
                            
                            index++;
                        }
                        
                    }
                }
            } // k
        } // j
    } // i
    
    return subPayTypes;
}


//选择支付方式
- (int)choosePayTool:(int)payToolIndex
{
    
    payTools_Index = payToolIndex;
    payCore.ptPath = ptPaths[payTools_Index]; //从0开始
    payMode = 0;
    
    if (payCore.kids[payCore.ptPath.i].tids[payCore.ptPath.j].tid == "C01"
        || payCore.kids[payCore.ptPath.i].tids[payCore.ptPath.j].tid == "C02"
        || payCore.kids[payCore.ptPath.i].tids[payCore.ptPath.j].tid == "A01")
    {
        XString kid = payCore.kids[payCore.ptPath.i].kid;
    
        if (kid == "00") {
            payMode = 7;
        }
        else {
            payMode = 1;
        }
        
    }
    if(payCore.kids[payCore.ptPath.i].tids[payCore.ptPath.j].tid == "C05"){
        payMode = 4;
    }
    if (payCore.kids[payCore.ptPath.i].tids[payCore.ptPath.j].tid == "C03"
        || payCore.kids[payCore.ptPath.i].tids[payCore.ptPath.j].tid == "C04")
    {
        payMode = 2;
    }
    if (payCore.kids[payCore.ptPath.i].tids[payCore.ptPath.j].tid == "A04")
    {
        payMode = 3;
    }
    if (payCore.kids[payCore.ptPath.i].kid == "09"
        && payCore.kids[payCore.ptPath.i].tids[payCore.ptPath.j].tid == "B01"
        && payCore.kids[payCore.ptPath.i].tids[payCore.ptPath.j].orgids[payCore.ptPath.k].orgid == "A0000002")
    {
        payMode = 6;
    }
    if (payCore.kids[payCore.ptPath.i].kid == "09"
        && payCore.kids[payCore.ptPath.i].tids[payCore.ptPath.j].tid == "B04"
        && payCore.kids[payCore.ptPath.i].tids[payCore.ptPath.j].orgids[payCore.ptPath.k].orgid == "A0000001")
    {
        payMode = 5;
    }
    
    return payMode;
    
}

 //充值预下单
- (NSMutableDictionary*)rechargePreOrder
{
    NSMutableDictionary *returnRecvdataDic = [[NSMutableDictionary alloc] init];
    
    XString kid =  payCore.kids[payCore.ptPath.i].kid;
    XString tid =  payCore.kids[payCore.ptPath.i].tids[payCore.ptPath.j].tid;
    XString oid =  payCore.kids[payCore.ptPath.i].tids[payCore.ptPath.j].orgids[payCore.ptPath.k].orgid;
    
    

    payCore.b3t3_cId = [@"0002" UTF8String];
    payCore.b3t3_kId = kid;
    payCore.b3t3_tId = tid;
    payCore.b3t3_orgId = oid;
    payCore.b3t3_dId = [@"" UTF8String];
    payCore.b3t3_sId = [@"0034" UTF8String];
    
    XString  sendData2 = payCore.Biz_UP([@"00030003" UTF8String]);
    RXSPSOperation * operation = [[[RXSPSOperation alloc] init] autorelease];
    XString  recvdata = [operation Transmit:sendData2];
     NSLog(@"rechargePreOrderrecvdata===%@",[NSString stringWithUTF8String:recvdata.Buffer()]);
    
    NSString *recvdataString = [NSString stringWithUTF8String:recvdata.Buffer()];
    
    [returnRecvdataDic setObject:recvdataString forKey:@"receiveData"];
    
    payCore.Biz_DOWN(recvdata);
    if(operation.ReturnCode ==0){
        [returnRecvdataDic setObject:@"0000" forKey:@"rspCode"];
        
    }
    else {
        [returnRecvdataDic setObject:@"1111" forKey:@"rspCode"];
       
    }
     return returnRecvdataDic;

}
//预充值
- (NSMutableDictionary*)preRecharge:(NSString*)rechargeValue cardNoOrPwd:(NSString*)cardNoOrPwd
{
     NSMutableDictionary *returnRecvdataDic = [[NSMutableDictionary alloc] init];
    
    payCore.b3t1_orderAmt = [rechargeValue UTF8String];
    payCore.b3t1_issueNo = [@"" UTF8String];
    payCore.b3t1_type = [@"02" UTF8String];
    payCore.b3t1_notifyType = [@"0" UTF8String];
    payCore.b3t1_notifyFlag = [@"0" UTF8String];
    XString currentTid = payCore.b3t3_tId;
    NSString *currentTidStr = [NSString stringWithUTF8String:currentTid.Buffer()];
    if (![cardNoOrPwd isEqualToString:@""]) {
        payCore.b3t1_cardNo = [cardNoOrPwd UTF8String];
    }
   
   else if ([currentTidStr isEqualToString:@"C05"]) { //ONLY_CODE 传入的卡号就是密码
       payCore.b3t1_cardNo = [cardNoOrPwd UTF8String];
    }
   else {
       payCore.b3t1_cardNo = [@"" UTF8String];
   }
    
    
    XString  sendData2 = payCore.Biz_UP([@"00030001" UTF8String]);
    RXSPSOperation * operation = [[[RXSPSOperation alloc] init] autorelease];
    XString  recvdata = [operation Transmit:sendData2];
    NSString *recvdataString = [NSString stringWithUTF8String:recvdata.Buffer()];
    
    [returnRecvdataDic setObject:recvdataString forKey:@"receiveData"];
    
    payCore.Biz_DOWN(recvdata);
    if(operation.ReturnCode ==0){
        [returnRecvdataDic setObject:@"0000" forKey:@"rspCode"];
        
    }
    else {
        [returnRecvdataDic setObject:@"1111" forKey:@"rspCode"];
        
    }
    return returnRecvdataDic;
    
}
-(void)UPPayPluginResult:(NSString*)result
{
    if([result compare:@"success"] == NSOrderedSame)
    {
        NSString *returnString = @"{\"responseCode\":\"100000\",\"rspMsg\":\"充值成功\"}";
        [self.delegate RXSPSReturn:returnString];
    }
    
    
}

- (void)goPayStep:(NSString*)rechargeCardNo pwdString:(NSString*)rechargePwd currentVC:(UIViewController*)passcurrentVC
{
     currentVC = passcurrentVC;
    ThreadCode = SPS_Thread_Code_RechargePay;
    if(payMode == 1 || payMode == 2||payMode==4 || payMode == 7)
    {
        //确定acctp
        if(payCore.kids[payCore.ptPath.i].kid == "00")
        {
            if(payCore.kids[payCore.ptPath.i].tids[payCore.ptPath.j].tid == "C01")
            {
                payCore.acctp = "0";
            }
            else if(payCore.kids[payCore.ptPath.i].tids[payCore.ptPath.j].tid == "C02")
            {
                payCore.acctp = "1";
            }
            else if(payCore.kids[payCore.ptPath.i].tids[payCore.ptPath.j].tid == "C03")
            {
                payCore.acctp = "3";
            }
            else if(payCore.kids[payCore.ptPath.i].tids[payCore.ptPath.j].tid == "C04")
            {
                payCore.acctp = "2";
            }
            else if(payCore.kids[payCore.ptPath.i].tids[payCore.ptPath.j].tid == "C05")
            {
                payCore.acctp = "6";
            }
        }
        else if(payCore.kids[payCore.ptPath.i].kid == "02")
        {
            payCore.acctp = "2";
        }
        
        //确定subacctp
        payCore.subacctp = "4";
        
        //确定acc
        if(payMode == 1 || payMode == 7)
        {
            payCore.acc = payCore.kids[payCore.ptPath.i].tids[payCore.ptPath.j].orgids[payCore.ptPath.k].cardaccs[payCore.ptPath.l].medium;
        }
        else if(payMode == 2)
        {
            payCore.acc = [rechargeCardNo UTF8String];
        }
        
        //确定accptp
        payCore.accptp = "0";
        
        //确定accp ONLY_CODE
        if(payMode == 4)
        {
            payCore.accp = [[self sha1:rechargePwd] UTF8String];
        }
        else
        {
            payCore.accp = [rechargePwd UTF8String];
        }
        
        //Pay
        
        RXSPSOperation * operation = [[[RXSPSOperation alloc] init] autorelease];
        operation.delegate = self;
        operation.ThreadCode = SPS_Thread_Code_RechargePay;
        ThreadCode = SPS_Thread_Code_RechargePay;
        NSOperationQueue * operationQueue = [[[NSOperationQueue alloc] init] autorelease];
        [operationQueue addOperation:operation];
        
    }
    
    if(payMode == 5)
    {
        RXSPSOperation * operation = [[[RXSPSOperation alloc] init] autorelease];
        operation.delegate = self;
        operation.ThreadCode = SPS_Thread_Code_UnionPay;
        ThreadCode = SPS_Thread_Code_RechargePay;
        NSOperationQueue * operationQueue = [[[NSOperationQueue alloc] init] autorelease];
        [operationQueue addOperation:operation];
        
    }



}

- (NSString*) sha1:(NSString*)input
{
    const char *cstr = [input cStringUsingEncoding:NSUTF8StringEncoding];
    NSData *data = [NSData dataWithBytes:cstr length:input.length];
    
    uint8_t digest[CC_SHA1_DIGEST_LENGTH];
    
    CC_SHA1(data.bytes, data.length, digest);
    
    NSMutableString* output = [NSMutableString stringWithCapacity:CC_SHA1_DIGEST_LENGTH * 2];
    
    for(int i = 0; i < CC_SHA1_DIGEST_LENGTH; i++)
    {
        [output appendFormat:@"%02x", digest[i]];
    }
    
    return output;
}
- (NSString*)pwd_enc:(NSString*)pwd
{
    XString password = [pwd UTF8String];
    
    BYTE pass_cipher[16] = {0};
    unsigned long pass_cipher_deslen = 0;
    rx_Des_Encipher_Message((BYTE*)(password + "  ").Buffer(), 8, payCore.WORKKEY, pass_cipher, &pass_cipher_deslen);
    rx_Des_Decipher_Message(pass_cipher, 8, payCore.WORKKEY + 8, pass_cipher, &pass_cipher_deslen);
    rx_Des_Encipher_Message(pass_cipher, 8, payCore.WORKKEY, pass_cipher, &pass_cipher_deslen);
    //
    char pass_cipher_hex[32 + 1] = {0};
    unsigned long pass_cipher_hex_len = 0;
    rx_Coder_Byte_To_HexFormatAsc(pass_cipher, 8, pass_cipher_hex, &pass_cipher_hex_len);
    
    
    NSMutableString* ret = [[[NSMutableString alloc] init] autorelease];
    [ret appendFormat:@"%@|%@", [NSString stringWithUTF8String:pass_cipher_hex], [NSString stringWithUTF8String:payCore._uuid.Buffer()]];
    
    return ret;
}

#pragma mark 杉徳币支付的接口方法
- (NSString *)sandCoinPayWithJson:(NSString *)JsonStr{
    NSData * order_data = [JsonStr dataUsingEncoding:NSUTF8StringEncoding];
    char temp[4096] = {0};
    memcpy(temp, [order_data bytes], [order_data length]);

    payCore.SetMerData(temp);
    XString  sendData2 = payCore.Biz_UP([@"00020012" UTF8String]);
    RXSPSOperation * operation = [[[RXSPSOperation alloc] init] autorelease];
    XString  recvdata = [operation Transmit:sendData2];
    NSLog(@"preRechargeRecvdata===%@",[NSString stringWithUTF8String:recvdata.Buffer()]);
    NSInteger returnCode = payCore.Biz_DOWN(recvdata);
    NSString *resStr = @"";
    switch (returnCode) {
        case 0:
             resStr = @"操作成功";
            break;
        case 1:
            resStr = @"处理异常";
            break;
        case 2:
            resStr = @"报文校验错误";
            break;
        case 3:
            resStr = [NSString stringWithUTF8String:payCore.respResult.Buffer()];
            break;
        case 4:
            resStr = @"数据身份校验错误";
            break;
        default:
            break;
    }
    NSString *resStrInfo = [NSString stringWithFormat:@"{\"returnCode\":\"%ld\",\"msg\":\"%@\"}",(long)returnCode,resStr];
    return resStrInfo;
}
@end
