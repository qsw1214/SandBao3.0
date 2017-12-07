//
//  RXPayUI.m
//  sps2-dev
//
//  Created by Rick Xing on 7/2/13.
//  Copyright (c) 2013 Rick Xing. All rights reserved.
//

#import "RXPayUI.h"
#import <CommonCrypto/CommonDigest.h>
#import "RXSPSOperation.h"
#import "Global.h"
#import "RXSPSEntry.h"
#import "RXCheckout.h"
#import "UPPaymentControl.h"
#import "SVProgressHUD_sps.h"
#import "ZCTradeView.h"
#import "UITextField+CheckLenght.h"
#import "UIScrollView+UITouch.h"

#include "xstring.h"
#include "RXSandPayCore.h"
#include "gv.h"
#include "RunCode.h"

using namespace sz;

id<SandUPPayDelegate> upPayDelegate;

const int ONLY_PASS = 1;
const int CARD_PASS = 2;
const int CARD_TAC = 3;
const int ONLY_CODE = 4;
const int UNION_PAY = 5;
const int CMCC_WAP = 6;

@interface RXPayUI ()<ZCTradeViewDelegate>

@property (nonatomic, strong) ZCTradeView *tradeView;
@property (nonatomic, strong) NSString *payPassword;
@property (nonatomic, strong) UIButton *btnPay, *shortMsgBtn;
@property (nonatomic, strong) UIScrollView *baseScrollView;
@property (nonatomic, strong) NSTimer *timer;
@property (nonatomic, strong) NSString *payAuth_id;


@property (nonatomic, assign) CGSize viewSize;
@property (nonatomic, assign) int timeOut;
@property (nonatomic, assign) int timeCount;
@property (nonatomic, assign) CGFloat payAuth_minamount;
@property (nonatomic, assign) CGFloat payAmt;

@end

@implementation RXPayUI

@synthesize textPass;
@synthesize textCard;
@synthesize textFieldShortMsg;
@synthesize btnPay;
@synthesize baseScrollView;
@synthesize shortMsgBtn;
@synthesize timer;
@synthesize payAuth_id;

@synthesize viewSize;
@synthesize timeOut;
@synthesize timeCount;
@synthesize payAuth_minamount;
@synthesize payAmt;


#pragma mark - 类加载方法
/**
 *  类加载方法
 *
 */
- (void)viewDidLoad {
    [super viewDidLoad];
    
    viewSize = self.view.bounds.size;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFiledEditChanged:) name:UITextFieldTextDidChangeNotification object:textFieldShortMsg];
    
    timeOut = 240;
    
    // 增加键盘弹入弹出通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    
    self.title = @"杉德安全支付";
    
    baseScrollView = [[UIScrollView alloc] initWithFrame:[UIScreen mainScreen].applicationFrame];
    baseScrollView.backgroundColor = [UIColor colorWithRed:242.0/255.0 green:236.0/255.0 blue:231.0/255.0 alpha:1.0];
    
    int subview_top = 15;
    
    payMode = 0;
    
    if (payCore.kids[payCore.ptPath.i].tids[payCore.ptPath.j].tid == "C01"
        || payCore.kids[payCore.ptPath.i].tids[payCore.ptPath.j].tid == "C02"
        || payCore.kids[payCore.ptPath.i].tids[payCore.ptPath.j].tid == "A01")
    {
        payMode = ONLY_PASS;
    }
    
    if(payCore.kids[payCore.ptPath.i].tids[payCore.ptPath.j].tid == "C05")
    {
        payMode = ONLY_CODE;
    }
    
    if (payCore.kids[payCore.ptPath.i].tids[payCore.ptPath.j].tid == "C03"
        || payCore.kids[payCore.ptPath.i].tids[payCore.ptPath.j].tid == "C04")
    {
        payMode = CARD_PASS;
    }
    
    if (payCore.kids[payCore.ptPath.i].tids[payCore.ptPath.j].tid == "A04")
    {
        payMode = CARD_TAC;
    }
    
    if (payCore.kids[payCore.ptPath.i].kid == "09"
        && payCore.kids[payCore.ptPath.i].tids[payCore.ptPath.j].tid == "B01"
        && payCore.kids[payCore.ptPath.i].tids[payCore.ptPath.j].orgids[payCore.ptPath.k].orgid == "A0000002")
    {
        payMode = CMCC_WAP;
    }
    
    if (payCore.kids[payCore.ptPath.i].kid == "09"
        && payCore.kids[payCore.ptPath.i].tids[payCore.ptPath.j].tid == "B04"
        && payCore.kids[payCore.ptPath.i].tids[payCore.ptPath.j].orgids[payCore.ptPath.k].orgid == "A0000001")
    {
        payMode = UNION_PAY;
    }
    
    {
        UILabel* Label = [[UILabel alloc] initWithFrame:CGRectMake(10, subview_top, viewSize.width - 2 * 10, 24)];
        subview_top += 24 + 10;
        Label.font = [UIFont fontWithName:@"Verdana" size:16];
        Label.textAlignment = NSTextAlignmentLeft;
        Label.textColor = [UIColor blackColor];
        Label.backgroundColor = [UIColor clearColor];
        NSMutableString* Label_Text = [[[NSMutableString alloc] init] autorelease];
        [Label_Text appendFormat:@"%@", [NSString stringWithUTF8String: payTools_Text[payTools_Index].Buffer()]];
        
        NSArray *subs = [Label_Text componentsSeparatedByString:@"手机"];
        if(subs.count==2){
           Label.text = [subs objectAtIndex:1] ;
        }else{
            Label.text = Label_Text ;
        }
        
        [baseScrollView addSubview:Label];
    }
    {
        UILabel* Label = [[UILabel alloc] initWithFrame:CGRectMake(10, subview_top, viewSize.width - 2 * 10, 24)];
        subview_top += 40 + 10;
        Label.font = [UIFont fontWithName:@"Verdana" size:16];
        Label.textAlignment = NSTextAlignmentLeft;
        Label.textColor = [UIColor blackColor];
        Label.backgroundColor = [UIColor clearColor];
        NSMutableString* Label_Text = [[[NSMutableString alloc] init] autorelease];
        NSString* amt_str = [NSString stringWithFormat:@"%.2f",
                             [[NSString stringWithUTF8String: payCore.payAmt.Buffer()] intValue] / 100.0 ];
        [Label_Text appendFormat:@"支付总金额:  %@ 元", amt_str];
        Label.text = Label_Text;
        [baseScrollView addSubview:Label];
    }
    
    NSString *backBG = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"sandpay.bundle/images/pay_focus.png"];
    
    
    CGFloat commHeight = 34;
    CGFloat imageviewTop = 0;
    payAuth_id = [NSString stringWithUTF8String:payCore.b2t2_payAuth_id.Buffer()];
    payAuth_minamount = [[NSString stringWithUTF8String:payCore.b2t2_payAuth_minamount.Buffer()] intValue] / 100.0;
    payAmt = [[NSString stringWithUTF8String: payCore.payAmt.Buffer()] intValue] / 100.0;
    
    switch (payMode) {
        case ONLY_PASS:
        {
            {
                if ([@"0001" isEqualToString:payAuth_id] && payAmt > payAuth_minamount) {
                    
                    payCore.b2t3_verifytype = [@"2" UTF8String];
                    
                    shortMsgBtn = [[UIButton alloc] init];
                    NSString *payButtonBG = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"sandpay.bundle/images/sps_nextbutton.png"];
                    [shortMsgBtn setBackgroundImage:[UIImage imageWithContentsOfFile:payButtonBG] forState:UIControlStateNormal];
                    shortMsgBtn.titleLabel.font = [UIFont systemFontOfSize:17];
                    [shortMsgBtn setTitle:@"获取验证码" forState:UIControlStateNormal];
                    [shortMsgBtn addTarget:self action:@selector(buttonShortMsgClicked) forControlEvents:UIControlEventTouchUpInside];
                    [shortMsgBtn setTitleColor:[UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:1] forState:UIControlStateNormal];
                    [baseScrollView addSubview:shortMsgBtn];
                    
                    CGSize shortMsgBtnSize = [shortMsgBtn.titleLabel.text sizeWithFont:shortMsgBtn.titleLabel.font];
                    CGFloat shortMsgBtnW = shortMsgBtnSize.width + 10;
                    CGFloat shortMsgBtnH = 34;
                    CGFloat shortMsgBtnOX = viewSize.width - 20 - shortMsgBtnW;
                    CGFloat shortMsgBtnOY = subview_top;
                    
                    shortMsgBtn.frame = CGRectMake(shortMsgBtnOX, shortMsgBtnOY, shortMsgBtnW, shortMsgBtnH);
                    
                    CGFloat textFieldShortMsgW = viewSize.width - 20 * 2 - shortMsgBtnW - 5 - 10;
                    CGFloat textFieldShortMsgH = shortMsgBtnH;
                    CGFloat textFieldShortMsgOX = 25;
                    CGFloat textFieldShortMsgOY = shortMsgBtnOY;
                    
                    CGFloat shortMsgImageviewW = viewSize.width - 20 * 2 - shortMsgBtnW - 5;
                    
                    UIImageView *shortMsgImageview = [[UIImageView alloc] initWithFrame:CGRectMake(20, textFieldShortMsgOY, shortMsgImageviewW , textFieldShortMsgH)];
                    shortMsgImageview.image = [UIImage imageWithContentsOfFile:backBG];
                    [baseScrollView addSubview:shortMsgImageview];
                    [shortMsgImageview release];
                    
                    textFieldShortMsg = [[UITextField alloc] init];
                    textFieldShortMsg.placeholder = @"请输入验证码";
                    //                textFieldShortMsg.returnKeyType = UIReturnKeyDone;
                    [textFieldShortMsg setMaxLenght:@"6"];
                    textFieldShortMsg.keyboardType = UIKeyboardTypeNumberPad;
                    textFieldShortMsg.font = [UIFont systemFontOfSize:17];
                    [baseScrollView addSubview:textFieldShortMsg];
                    
                    textFieldShortMsg.frame = CGRectMake(textFieldShortMsgOX, textFieldShortMsgOY, textFieldShortMsgW, textFieldShortMsgH);
                    
                    imageviewTop = textFieldShortMsgOY + textFieldShortMsgH;
                }else {
                    payCore.b2t3_verifytype = [@"" UTF8String];
                    imageviewTop = subview_top;
                }
                
                UIImageView *imageview = [[UIImageView alloc] initWithFrame:CGRectMake(20, imageviewTop + 10, viewSize.width - 2 * 20, commHeight)];
                imageview.image = [UIImage imageWithContentsOfFile:backBG];
                [baseScrollView addSubview:imageview];
                [imageview release];
                
                textPass = [[UILabel alloc] initWithFrame:CGRectMake(25, imageviewTop + 10, viewSize.width - 2 * 25, commHeight)];
                textPass.backgroundColor = [UIColor clearColor];
                textPass.text = @"请输入6位密码";
                textPass.font = [UIFont systemFontOfSize:17];
                textPass.userInteractionEnabled = YES;
                
                UIButton *textPassButton = [[UIButton buttonWithType:UIButtonTypeCustom] autorelease];
                textPassButton.frame = textPass.frame;
                textPassButton.backgroundColor = [UIColor clearColor];
                
                [textPassButton addTarget:self action:@selector(showPayPasswordView:) forControlEvents:UIControlEventTouchUpInside];
                
                [baseScrollView addSubview:textPass];
                [baseScrollView addSubview:textPassButton];
                
                subview_top += imageviewTop + 10;
            }

            break;
        }
        case CARD_PASS:
        {
            {
                UIImageView *imageview = [[UIImageView alloc] initWithFrame:CGRectMake(20, subview_top, viewSize.width - 2 * 20, 34)];
                imageview.image = [UIImage imageWithContentsOfFile:backBG];
                [baseScrollView addSubview:imageview];
                [imageview release];
                
                textCard = [[UITextField alloc] initWithFrame:CGRectMake(25, subview_top+4, viewSize.width - 2 * 25, 26)];
                textCard.backgroundColor = [UIColor clearColor];
                textCard.placeholder = @"请输入16位卡号";
                textCard.font = [UIFont systemFontOfSize:17];
//                textCard.keyboardType = UIKeyboardTypeNumberPad;
                [baseScrollView addSubview:textCard];
                
                subview_top += 34;
            }
            {
                if ([@"0001" isEqualToString:payAuth_id] && payAmt > payAuth_minamount) {
                
                    payCore.b2t3_verifytype = [@"2" UTF8String];
                    
                    shortMsgBtn = [[UIButton alloc] init];
                    NSString *payButtonBG = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"sandpay.bundle/images/sps_nextbutton.png"];
                    [shortMsgBtn setBackgroundImage:[UIImage imageWithContentsOfFile:payButtonBG] forState:UIControlStateNormal];
                    shortMsgBtn.titleLabel.font = [UIFont systemFontOfSize:17];
                    [shortMsgBtn setTitle:@"获取验证码" forState:UIControlStateNormal];
                    [shortMsgBtn addTarget:self action:@selector(buttonShortMsgClicked) forControlEvents:UIControlEventTouchUpInside];
                    [shortMsgBtn setTitleColor:[UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:1] forState:UIControlStateNormal];
                    [baseScrollView addSubview:shortMsgBtn];
                    
                    CGSize shortMsgBtnSize = [shortMsgBtn.titleLabel.text sizeWithFont:shortMsgBtn.titleLabel.font];
                    CGFloat shortMsgBtnW = shortMsgBtnSize.width + 10;
                    CGFloat shortMsgBtnH = commHeight;
                    CGFloat shortMsgBtnOX = viewSize.width - 20 - shortMsgBtnW;
                    CGFloat shortMsgBtnOY = subview_top + 10;
                    
                    shortMsgBtn.frame = CGRectMake(shortMsgBtnOX, shortMsgBtnOY, shortMsgBtnW, shortMsgBtnH);
                    
                    CGFloat textFieldShortMsgW = viewSize.width - 20 * 2 - shortMsgBtnW - 5 - 10;
                    CGFloat textFieldShortMsgH = shortMsgBtnH;
                    CGFloat textFieldShortMsgOX = 25;
                    CGFloat textFieldShortMsgOY = shortMsgBtnOY;
                    
                    CGFloat shortMsgImageviewW = viewSize.width - 20 * 2 - shortMsgBtnW - 5;
                    
                    UIImageView *shortMsgImageview = [[UIImageView alloc] initWithFrame:CGRectMake(20, textFieldShortMsgOY, shortMsgImageviewW, textFieldShortMsgH)];
                    shortMsgImageview.image = [UIImage imageWithContentsOfFile:backBG];
                    [baseScrollView addSubview:shortMsgImageview];
                    [shortMsgImageview release];
                    
                    textFieldShortMsg = [[UITextField alloc] init];
                    textFieldShortMsg.placeholder = @"请输入验证码";
                    //                textFieldShortMsg.returnKeyType = UIReturnKeyDone;
                    [textFieldShortMsg setMaxLenght:@"6"];
                    textFieldShortMsg.keyboardType = UIKeyboardTypeNumberPad;
                    textFieldShortMsg.font = [UIFont systemFontOfSize:17];
                    [baseScrollView addSubview:textFieldShortMsg];
                    
                    textFieldShortMsg.frame = CGRectMake(textFieldShortMsgOX, textFieldShortMsgOY, textFieldShortMsgW, textFieldShortMsgH);
                    
                    imageviewTop = textFieldShortMsgOY + textFieldShortMsgH;
                } else {
                    payCore.b2t3_verifytype = [@"" UTF8String];
                    imageviewTop = subview_top;
                }
            
                
                UIImageView *imageview = [[UIImageView alloc] initWithFrame:CGRectMake(20, imageviewTop + 10, viewSize.width - 2 * 20, commHeight)];
                imageview.image = [UIImage imageWithContentsOfFile:backBG];
                [baseScrollView addSubview:imageview];
                [imageview release];
                
                textPass = [[UILabel alloc] initWithFrame:CGRectMake(25, imageviewTop + 10 , viewSize.width - 2 * 25, commHeight)];
                textPass.backgroundColor = [UIColor clearColor];
                textPass.text = @"请输入6位密码";
                textPass.font = [UIFont systemFontOfSize:17];
                textPass.userInteractionEnabled = YES;
                UITapGestureRecognizer *pwdTapGesture = [[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showPayPasswordView:)] autorelease];
                [textPass addGestureRecognizer:pwdTapGesture];
                [baseScrollView addSubview:textPass];
                
                subview_top += imageviewTop + 10;
            }
            
            break;
        }
        case ONLY_CODE:
        {
            payCore.b2t3_verifytype = [@"" UTF8String];
            {
                UIImageView *imageview = [[UIImageView alloc] initWithFrame:CGRectMake(20, subview_top, viewSize.width - 2 * 20, 34)];
                imageview.image = [UIImage imageWithContentsOfFile:backBG];
                [baseScrollView addSubview:imageview];
                [imageview release];
                textCard = [[UITextField alloc] initWithFrame:CGRectMake(25, subview_top+4, viewSize.width - 2 * 25, 26)];
                textCard.backgroundColor = [UIColor clearColor];
                textCard.placeholder = @"请输入16位密码";
                textCard.font = [UIFont systemFontOfSize:17];
//                textCard.keyboardType = UIKeyboardTypeNumberPad;
                [baseScrollView addSubview:textCard];
                subview_top += 24 + 10;
            }
            break;
        }
    }

    btnPay = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    btnPay.frame = CGRectMake(10, 260, viewSize.width - 2 * 10, 36);
    subview_top += 42 + 10;
    btnPay.tag = 5;
    [btnPay setContentHorizontalAlignment:UIControlContentHorizontalAlignmentCenter];
    [btnPay.titleLabel setFont:[UIFont boldSystemFontOfSize:20]];
    [btnPay setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    NSString *payButtonBG = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"sandpay.bundle/images/sps_nextbutton.png"];
    [btnPay setBackgroundImage:[UIImage imageWithContentsOfFile:payButtonBG] forState:UIControlStateNormal];
    [btnPay setTitle:@"确定支付" forState:UIControlStateNormal];
    [btnPay addTarget:self action:@selector(buttonPayClicked:) forControlEvents:UIControlEventTouchUpInside];
    [baseScrollView addSubview:btnPay];
    
    baseScrollView.contentSize = CGSizeMake(viewSize.width, subview_top);
    self.view = baseScrollView;
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:YES];
}

/**
 *@brief 短信码倒计时
 */
- (void)shortMsgCodeCountDown
{
    timer = [NSTimer timerWithTimeInterval:1 target:self selector:@selector(refreshTime) userInfo:nil repeats:YES];
    
    [[NSRunLoop mainRunLoop] addTimer:timer forMode:NSRunLoopCommonModes];
}

/**
 *@brief 短信码倒计时
 */
- (void)refreshTime
{
    timeCount--;
    if (timeCount < 0) {
        [timer invalidate];
        timer = nil;
        [shortMsgBtn setUserInteractionEnabled:YES];
        [shortMsgBtn setTitle:@"重发一次" forState: UIControlStateNormal];
        [shortMsgBtn setTitle:@"重发一次" forState:UIControlStateHighlighted];
    } else {
        NSString *time = [NSString stringWithFormat:@"%d秒", timeCount];
        [shortMsgBtn setUserInteractionEnabled:NO];
        [shortMsgBtn setTitle:time forState: UIControlStateNormal];
    }
}

- (void) buttonShortMsgClicked
{
    textFieldShortMsg.text = @"";
    //timeCount = timeOut;
    timeCount = 60;  //备注:修改短信倒计时为60s / 短信超时时间为240s
    [shortMsgBtn setUserInteractionEnabled:NO];
    payCore.b4t4_phoneNum = payCore.b4t1_mem_phoneNumber;
    payCore.b4t4_timeOut = [[NSString stringWithFormat:@"%i", timeOut] UTF8String];
    payCore.b4t4_bizType = [@"0003" UTF8String];
    RXSPSOperation * operation = [[[RXSPSOperation alloc] init] autorelease];
//    operation.delegate = self;
    operation.ThreadCode = SPS_Thread_Code_shortMsg;
    NSOperationQueue * operationQueue = [[[NSOperationQueue alloc] init] autorelease];
    [operationQueue addOperation:operation];
    
    [self shortMsgCodeCountDown];
}

- (IBAction)buttonPayClicked:(id)sender {
    if(payMode == ONLY_PASS) {
        
        if ([@"0001" isEqualToString:payAuth_id] && payAmt > payAuth_minamount) {
            if (textFieldShortMsg.text.length != 6) {
                UIAlertView * alertView =[[UIAlertView alloc]
                                          initWithTitle:@"提示"
                                          message:@"请输入正确6位短信验证码"
                                          delegate:self
                                          cancelButtonTitle:@"确定"
                                          otherButtonTitles:nil];
                alertView.tag = 0;
                [alertView show];
                [alertView release];
                
                return;
            }
        }
        
        if(textPass.text.length != 6) {
            UIAlertView * alertView =[[UIAlertView alloc]
                                      initWithTitle:@"提示"
                                      message:@"请输入6位密码"
                                      delegate:self
                                      cancelButtonTitle:@"确定"
                                      otherButtonTitles:nil];
            alertView.tag = 0;
            [alertView show];
            [alertView release];
            
            return;
        }
    } else if(payMode == CARD_PASS) {
        if(textCard.text.length != 16) {
            UIAlertView * alertView =[[UIAlertView alloc]
                                      initWithTitle:@"提示"
                                      message:@"请输入16位卡号"
                                      delegate:self
                                      cancelButtonTitle:@"确定"
                                      otherButtonTitles:nil];
            alertView.tag = 0;
            [alertView show];
            [alertView release];
            
            return;
        }
        
        if ([@"0001" isEqualToString:payAuth_id] && payAmt > payAuth_minamount) {
            if (textFieldShortMsg.text.length != 6) {
                UIAlertView * alertView =[[UIAlertView alloc]
                                          initWithTitle:@"提示"
                                          message:@"请输入正确6位短信验证码"
                                          delegate:self
                                          cancelButtonTitle:@"确定"
                                          otherButtonTitles:nil];
                alertView.tag = 0;
                [alertView show];
                [alertView release];
                
                return;
            }
        }
        
        if(textPass.text.length != 6) {
            UIAlertView * alertView =[[UIAlertView alloc]
                                      initWithTitle:@"提示"
                                      message:@"请输入6位密码"
                                      delegate:self
                                      cancelButtonTitle:@"确定"
                                      otherButtonTitles:nil];
            alertView.tag = 0;
            [alertView show];
            [alertView release];
            
            return;
        }
    } else if(payMode == ONLY_CODE) {
        if(textCard.text.length != 16) {
            UIAlertView * alertView =[[UIAlertView alloc]
                                      initWithTitle:@"提示"
                                      message:@"请输入16位密码"
                                      delegate:self
                                      cancelButtonTitle:@"确定"
                                      otherButtonTitles:nil];
            alertView.tag = 0;
            [alertView show];
            [alertView release];
            
            return;
        }
    }
    
    if(payMode == ONLY_PASS || payMode == CARD_PASS||payMode==ONLY_CODE) {
        //确定acctp
        if(payCore.kids[payCore.ptPath.i].kid == "00") {
            if(payCore.kids[payCore.ptPath.i].tids[payCore.ptPath.j].tid == "C01") {
                payCore.acctp = "0";
            } else if(payCore.kids[payCore.ptPath.i].tids[payCore.ptPath.j].tid == "C02") {
                payCore.acctp = "1";
            } else if(payCore.kids[payCore.ptPath.i].tids[payCore.ptPath.j].tid == "C03") {
                payCore.acctp = "3";
            } else if(payCore.kids[payCore.ptPath.i].tids[payCore.ptPath.j].tid == "C05") {
                payCore.acctp = "6";
            }
        } else if(payCore.kids[payCore.ptPath.i].kid == "02") {
            payCore.acctp = "2";
        }

        //确定subacctp
        payCore.subacctp = "4";
        
        //确定acc
        if(payMode == ONLY_PASS) {
            payCore.acc = payCore.kids[payCore.ptPath.i].tids[payCore.ptPath.j].orgids[payCore.ptPath.k].cardaccs[payCore.ptPath.l].medium;
        } else if(payMode == CARD_PASS) {
            payCore.acc = [textCard.text UTF8String];
        }
    
        //确定accptp
        payCore.accptp = "0";
        
        //确定accp
        if(payMode == ONLY_CODE) {
            payCore.accp = [[self sha1:textCard.text] UTF8String];
        } else {
            payCore.accp = [self.payPassword UTF8String];
        }
        
        //手机短信验证
        if (payMode == ONLY_PASS || payMode == CARD_PASS) {
            if ([@"0001" isEqualToString:payAuth_id] && payAmt > payAuth_minamount) {
                payCore.b2t3_verifytype = [@"2" UTF8String];
                payCore.b2t3_verifyid = [[NSString stringWithFormat:@"%@", textFieldShortMsg.text] UTF8String];
            } else {
                payCore.b2t3_verifytype = [@"" UTF8String];
                payCore.b2t3_verifyid = [@"" UTF8String];
            }
            
        } else {
            payCore.b2t3_verifytype = [@"" UTF8String];
            payCore.b2t3_verifyid = [@"" UTF8String];
        }
        
        //Pay
        [SVProgressHUD_sps show];
        RXSPSOperation * operation = [[[RXSPSOperation alloc] init] autorelease];
        operation.delegate = self;
        operation.ThreadCode = SPS_Thread_Code_Pay;
        NSOperationQueue * operationQueue = [[[NSOperationQueue alloc] init] autorelease];
        [operationQueue addOperation:operation];
    }
    
    if(payMode == UNION_PAY) {
        upPayDelegate = self;
        
        RXSPSOperation * operation = [[[RXSPSOperation alloc] init] autorelease];
        operation.delegate = self;
        operation.ThreadCode = SPS_Thread_Code_UnionPay;
        NSOperationQueue * operationQueue = [[[NSOperationQueue alloc] init] autorelease];
        [operationQueue addOperation:operation];

    }
}

- (IBAction)buttonCancelClicked:(id)sender {
//    [self dismissModalViewControllerAnimated:YES];
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)OperationEnd:(NSNumber*)runCode {
    RunCode = [runCode intValue];
    
    if(RunCode == RunCode_Ok) {
        [SVProgressHUD_sps dismiss];
        
        if(payMode == ONLY_PASS || payMode == CARD_PASS || payMode == ONLY_CODE) {
            UIAlertView * alertView =[[UIAlertView alloc]
                                      initWithTitle:@"支付成功"
                                      message:@""
                                      delegate:self
                                      cancelButtonTitle:@"返回商户"
                                      otherButtonTitles:nil];
            alertView.tag = 1;
            [alertView show];
            [alertView release];
        }
        
        if(payMode == UNION_PAY) {
            // 00 正式 01 测试
            [[UPPaymentControl defaultControl] startPay:[NSString stringWithUTF8String:payCore.UnionPayTN.Buffer()] fromScheme:@"SandLife" mode:@"00" viewController:self];
            
        }
    } else if(RunCode == RunCode_PayCore_Error){
        [SVProgressHUD_sps dismissWithError:[NSString stringWithUTF8String:payCore.respResult.Buffer()]];
    } else if(RunCode == RunCode_Network_Error){
        [SVProgressHUD_sps dismissWithError:@"网络通信异常,请重试!"];
    } else{
        [SVProgressHUD_sps dismissWithError:@"处理异常,请重试!"];
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    switch (alertView.tag) {
        case 0: //err
        {
            switch (buttonIndex) {
                case 0:
                {
                    break;
                }
                default:
                    break;
            }
            break;
        }
        case 1: //ok
        {
            switch (buttonIndex) {
                case 0:
                {
//                    [self dismissModalViewControllerAnimated:NO];
                    [self.navigationController popViewControllerAnimated:YES];
                    
                    RunCode = RunCode_Ok;
                    
                    [[Global get_CheckoutDelegate] dismiss];
                    [[Global get_BridgeDelegate] ExitSps];
                    
                    break;
                }
                default:
                    break;
            }
            break;
        }
        default:
            break;
    }
}

//银联代理
- (void)upPayResult:(NSString *)result
{
    if ([result isEqualToString:@"成功"]) {
        //        [self dismissModalViewControllerAnimated:NO];
        //        [self dismissViewControllerAnimated:YES completion:nil];
        [self.navigationController popViewControllerAnimated:YES];
        
        RunCode = RunCode_Ok;
        
        [[Global get_CheckoutDelegate] dismiss];
        [[Global get_BridgeDelegate] ExitSps];
    }
}

- (NSString *)sha1:(NSString *)input {
    const char *cstr = [input cStringUsingEncoding:NSUTF8StringEncoding];
    NSData *data = [NSData dataWithBytes:cstr length:input.length];
    
    uint8_t digest[CC_SHA1_DIGEST_LENGTH];
    
    CC_SHA1(data.bytes, data.length, digest);
    
    NSMutableString* output = [NSMutableString stringWithCapacity:CC_SHA1_DIGEST_LENGTH * 2];
    
    for(int i = 0; i < CC_SHA1_DIGEST_LENGTH; i++) {
        [output appendFormat:@"%02x", digest[i]];
    }
    
    return output;
}

- (void)UPPayPluginResult:(NSString *)result {
    if([result compare:@"success"] == NSOrderedSame) {
        UIAlertView * alertView =[[UIAlertView alloc]
                                  initWithTitle:@"支付成功"
                                  message:@""
                                  delegate:self
                                  cancelButtonTitle:@"返回商户"
                                  otherButtonTitles:nil];
        alertView.tag = 1;
        [alertView show];
        [alertView release];
    }
}

#pragma mark - 密码输入事件
/**
 *  弹出密码输入框
 */
- (void)showPayPasswordView:(UIButton *)textPassButton {
    [self.view endEditing:YES];
    
    self.tradeView = [ZCTradeView shareTradeView];
    self.tradeView.delegate = self;
    [self.tradeView show];
}

/**
 *  密码输入完成代理方法
 */
- (void)finish:(NSString *)password {
    self.payPassword = password;
    
    NSMutableString *screatPassword = [NSMutableString string];
    
    if (password.length > 0) {
        for (int i = 0; i < password.length; i++) {
            [screatPassword appendString:[NSString stringWithFormat:@"%@",@"●"]];
        }
    }
    
    textPass.text = screatPassword;
    textPass.textColor = [UIColor blackColor];
    [self.tradeView hiden];
    
    [self cancelButtonClickAction];
}

/**
 * 取消按钮代理方法
 */
- (void)cancelButtonClickAction {
//    CGRect scrollViewFrame = baseScrollView.frame;
//    
//    scrollViewFrame.origin.y = CGRectGetMaxY(self.navigationController.navigationBar.frame);
//    
//    [UIView animateWithDuration:0.3 animations:^{
//        baseScrollView.frame = scrollViewFrame;
//    }];
//    
//    CGRect payBtnFrame = btnPay.frame;
//    
//    payBtnFrame.origin.y = 260;
//    
//    [UIView animateWithDuration:0.3 animations:^{
//        btnPay.frame = payBtnFrame;
//    }];
}

#pragma mark - 通知事件监听处理

/**
 *  键盘弹出通知事件处理
 */
- (void)keyboardWillShow:(NSNotification *)notification {
    NSDictionary *userInfoDictionary = [notification userInfo];
    
    NSValue *keyboardValue = [userInfoDictionary objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGRect keyboardRect = [keyboardValue CGRectValue];

    if(payMode == ONLY_CODE) {
        
        CGRect payBtnFrame = btnPay.frame;
        
        payBtnFrame.origin.y = self.view.bounds.size.height - keyboardRect.size.height - 100;
        
        [UIView animateWithDuration:0.3 animations:^{
            btnPay.frame = payBtnFrame;
        }];
    }
    
    if (payMode == CARD_PASS) {
        CGRect scrollViewFrame = baseScrollView.frame;
        
        scrollViewFrame.origin.y = -60;
        
        [UIView animateWithDuration:0.3 animations:^{
            baseScrollView.frame = scrollViewFrame;
        }];
        
        CGRect payBtnFrame = btnPay.frame;
        
        payBtnFrame.origin.y = self.view.bounds.size.height - keyboardRect.size.height - 46;
        
        [UIView animateWithDuration:0.3 animations:^{
            btnPay.frame = payBtnFrame;
        }];
    }
}


- (void)textFiledEditChanged:(NSNotification *)obj
{
    UITextField *textField = (UITextField *)obj.object;
    NSString *content = textField.text;
    
    int maxLenght = [textField.maxLenght intValue];
    NSInteger lenght = content.length;
    
    if(maxLenght > 0) {
        // 键盘输入模式
        NSArray *currentar = [UITextInputMode activeInputModes];
        UITextInputMode *current = [currentar firstObject];
        NSString *lang = [current primaryLanguage];
        // 简体中文输入，包括简体拼音，健体五笔，简体手写
        if ([lang isEqualToString:@"zh-Hans"]) {
            UITextRange *selectedRange = [textField markedTextRange];
            //获取高亮部分
            UITextPosition *position = [textField positionFromPosition:selectedRange.start offset:0];
            // 没有高亮选择的字，则对已输入的文字进行字数统计和限制
            if (!position) {
                if (lenght > maxLenght) {
                    textField.text = [content substringToIndex:maxLenght];
                }
            }
            // 有高亮选择的字符串，则暂不对文字进行统计和限制
        } else {
            if (lenght > maxLenght) {
                textField.text = [content substringToIndex:maxLenght];
            }
        }
    }
}

#pragma mark - 内存管理方法
/**
 *  内存警告方法
 *
 */
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

/**
 *  对象销毁方法
 */
- (void)dealloc {
    [super dealloc];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:self];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UITextFieldTextDidChangeNotification object:textFieldShortMsg];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    NSLog(@"你看到了吗");
    [baseScrollView endEditing:YES];
}

@end
