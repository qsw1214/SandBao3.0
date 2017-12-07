//
//  RXSPSEntry.h
//  sps2-dev
//
//  Created by Rick Xing on 6/24/13.
//  Copyright (c) 2013 Rick Xing. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol RXSPSDelegate <NSObject>

@required
- (void)RXSPSReturn:(NSString*)jsonData;
@end


@interface RXSPSEntry : UIViewController {
    id <RXSPSDelegate> delegate;
}

@property (nonatomic,assign) id <RXSPSDelegate> delegate;
@property (nonatomic,assign) BOOL isSignMessage;

+ (RXSPSEntry *)sharedInstance;

- (void)CallSps:(NSString *)jsonData;
- (void)ExitSps;

- (void)threadCodeSteps;

- (NSString *)pwd_enc:(NSString *)pwd;

/**
 *@brief 加密用户密码
 *@param userPwd    字符串  用户密码
 *@return NSString
 */
- (NSString *)encryptorUserPwd:(NSString *)userPwd;

/**
 *@brief 加密支付密码
 *@param payPwd    字符串  支付密码
 *@return NSString
 */
- (NSString *)encryptorPayPwd:(NSString *)payPwd;

/**
 *@brief   拼接报文
 *@param busiType    字符串  业务类型
 *@return NSString
 */
- (NSString *)bizUP:(NSString *)busiType;

/**
 *@brief   解析报文
 *@param recvData    字符串  请求返回报文
 *@return NSInteger  0代表成功，1代表失败
 */
- (NSInteger)bizDOWN:(NSString *)recvData;

- (NSString *)sendSignMessage:(NSString *)busiType busiInfo:(NSString *)busiInfo memberID:(NSString *)memberId sid:(NSString *)sid ;

// 充值步骤
- (NSMutableDictionary *)localLoginWithMemId:(NSString *)memId sessionId:(NSString*)sessionId; //1、本地登录 用户ID、sessionId

- (NSMutableDictionary *)requestAccData:(NSString *)accountNum;  //2、账户数据请求 targetsMap

- (NSMutableDictionary *)rechargeCheck:(NSDictionary *)targetsMapDic;  //3、充值检查 //传入充值步骤2中返回的通用/专用账户 信息

- (NSMutableArray *)getPayTools; //4、获取支持的支付方式

- (int)choosePayTool:(int)payToolIndex;//5、选择支付方式 返回值 代表的充值方式

/*int ONLY_PASS = 1;  密码支付快捷支付
 int CARD_PASS = 2;  卡号+密码
 int CARD_TAC = 3;
 int ONLY_CODE = 4; 刮刮卡 类似电话卡
 int UNION_PAY = 5; 银联
 int CMCC_WAP = 6;  移动支付
int CMCC_WAP = 7;  杉德宝通用支付*/
- (NSMutableDictionary *)rechargePreOrder;//6、充值预下单

- (NSMutableDictionary *)preRecharge:(NSString *)rechargeValue cardNoOrPwd:(NSString *)cardNoOrPwd;            //7、预充值

- (void)goPayStep:(NSString *)rechargeCardNo pwdString:(NSString *)rechargePwd currentVC:(UIViewController *)passcurrentVC;

- (NSString *)sandCoinPayWithJson:(NSString *)JsonStr; 

@end
