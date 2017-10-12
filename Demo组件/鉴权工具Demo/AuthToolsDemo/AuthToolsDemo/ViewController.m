//
//  ViewController.m
//  AuthToolsDemo
//
//  Created by tianNanYiHao on 2017/4/7.
//  Copyright © 2017年 tianNanYiHao. All rights reserved.
//

#import "ViewController.h"
#import "GroupView.h"



#define titleColor [UIColor colorWithRed:(174/255.0) green:(174/255.0) blue:(174/255.0) alpha:1.0]


@interface ViewController ()
{
    CGFloat titleSize;
    CGSize viewSize;
    CGFloat leftRightSpace;
    
}
@property (nonatomic, strong) UITextField *phoneNumTextField;
@property (nonatomic, strong) UITextField *shortMsgTextField;
@property (nonatomic, strong) UITextField *loginPwdTextField;
@property (nonatomic, strong) UITextField *payPwdTextField;
@property (nonatomic, strong) UITextField *IDCardTextField;
@property (nonatomic, strong) UITextField *pictureNumTextField;
@property (nonatomic, strong) UITextField *realNameTextField;
@property (nonatomic, strong) UILabel *bankNameLabel;
@property (nonatomic, strong) UITextField *bankCardTextField;
@property (nonatomic, strong) UITextField *questionTextField;
@property (nonatomic, strong) UITextField *accPwdTextField;
@property (nonatomic, strong) UIButton *shortMsgBtn;
@property (nonatomic, strong) UIButton *loginPwdBtn;
@property (nonatomic, strong) UIButton *pictureBtn;
@property (nonatomic, strong) UILabel *questionTitleLabel;
@property (nonatomic, strong) UIButton *questionBtn;
@property (nonatomic, strong) UILabel *questionlabel;
@property (nonatomic, strong) UITextField *cvnTextField;
@property (nonatomic, strong) UITextField *expiryTextField;





@property (nonatomic,assign) CGFloat shortMsgBtnW;
@property (nonatomic,assign) CGFloat shortMsgBtnH;
@end



@implementation ViewController
@synthesize shortMsgBtnW;
@synthesize shortMsgBtnH;







- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    titleSize = 12;
    viewSize = self.view.bounds.size;
    leftRightSpace = 15;
    
    UIView *authToolsView = [[UIView alloc] init];
    authToolsView.backgroundColor = [UIColor redColor];
    
    authToolsView.frame = CGRectMake(0, 100, viewSize.width, 200) ;
    [self.view addSubview:authToolsView];
    
    CGFloat authToolsViewH = [self addAuthToolsView:authToolsView];
}


/**
 *@brief 添加鉴权工具view
 *@param view UIView 参数：组件
 *@return CGFloat
 */
- (CGFloat)addAuthToolsView:(UIView *)view
{
   CGFloat lineViewHeight = 1;
    CGFloat tempHeight = 0;
    CGFloat allHeight = 0;
    CGFloat groupViewHight = 0;
    CGFloat tempLineViewHeight = 0;
    CGFloat textFieldTag = 0;
    BOOL questionFlag = NO;
    
    NSArray *authToolsArray = @[@"sms",@"",@""];
    
    for (int i = 0; i < authToolsArray.count; i++) {
        NSString *type = authToolsArray[i];
        
        GroupView *groupView = [[GroupView alloc] initWithFrame:self.view.frame];
        groupView.groupViewStyle = GroupViewStyleYes;
        tempHeight = tempHeight + groupViewHight;
        textFieldTag = textFieldTag + 1;
        
        
        
        if ([@"loginpass" isEqualToString:type]) {
            UIView *loginpassView = [[UIView alloc] init];
            loginpassView.backgroundColor = [UIColor colorWithRed:(242/255.0) green:(242/255.0) blue:(242/255.0) alpha:1.0];
            [view addSubview:loginpassView];
            
            NSMutableAttributedString *loginpassTitleInfo = [[NSMutableAttributedString alloc] initWithString:@"输入原登陆密码完成身份验证"];
            [loginpassTitleInfo addAttribute:NSForegroundColorAttributeName value:titleColor range:NSMakeRange(0 , 2)];
            [loginpassTitleInfo addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:(230/255.0) green:(2/255.0) blue:(2/255.0) alpha:1.0] range:NSMakeRange(2, 5)];
            [loginpassTitleInfo addAttribute:NSForegroundColorAttributeName value:titleColor range:NSMakeRange(7, 6)];
            
            UILabel *loginpassTitleLable = [[UILabel alloc] init];
            loginpassTitleLable.attributedText = loginpassTitleInfo;
            loginpassTitleLable.font = [UIFont systemFontOfSize:titleSize];
            [loginpassView addSubview:loginpassTitleLable];
            
            CGFloat loginpassTitleLableWidth = viewSize.width - 2 * 10;
            CGSize loginpassTitleLableSize = [loginpassTitleLable sizeThatFits:CGSizeMake(loginpassTitleLableWidth, MAXFLOAT)];
            
            CGFloat loginpassViewW = viewSize.width;
            CGFloat loginpassViewH = loginpassTitleLableSize.height + 2 * 10;
            CGFloat loginpassViewOX = 0;
            CGFloat loginpassViewOY = allHeight;
            
            loginpassView.frame = CGRectMake(loginpassViewOX, loginpassViewOY, loginpassViewW, loginpassViewH);
            
            CGFloat loginpassTitleLableHeight = loginpassTitleLableSize.height;
            CGFloat loginpassTitleLableOX = 10;
            CGFloat loginpassTitleLableOY = 10;
            
            loginpassTitleLable.frame = CGRectMake(loginpassTitleLableOX, loginpassTitleLableOY, loginpassTitleLableWidth, loginpassTitleLableHeight);
            
            tempHeight = tempHeight + loginpassViewH;
            
            groupViewHight = [groupView loginPwdVerification];
            allHeight = allHeight + groupViewHight + loginpassViewH;
            _loginPwdBtn = groupView.loginPwdVerificationBtn;
            _loginPwdTextField = groupView.loginPwdVerificationTextField;
            
            _loginPwdTextField.tag = textFieldTag;
            _loginPwdBtn.tag = 202;
//            [_loginPwdTextField setMinLenght:@"8"];;
//            [_loginPwdTextField setMaxLenght:@"20"];
            
            [_loginPwdBtn addTarget:self action:@selector(buttonActionToDoSomething:) forControlEvents:UIControlEventTouchUpInside];
            
//            [textFieldArray addObject:loginPwdTextField];
        }
        
        if ([@"paypass" isEqualToString:type]) {
//            payPassTag = YES;
        }
        
        if ([@"gesture" isEqualToString:type]) {
            
        }
        
        if ([@"accpass" isEqualToString:type]) {
            
            UIView *accpassView = [[UIView alloc] init];
            accpassView.backgroundColor = [UIColor colorWithRed:(242/255.0) green:(242/255.0) blue:(242/255.0) alpha:1.0];
            [view addSubview:accpassView];
            
            NSMutableAttributedString *accpassInfo = [[NSMutableAttributedString alloc] initWithString:@"输入原登陆密码完成身份验证"];
            [accpassInfo addAttribute:NSForegroundColorAttributeName value:titleColor range:NSMakeRange(0 , 2)];
            [accpassInfo addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:(230/255.0) green:(2/255.0) blue:(2/255.0) alpha:1.0] range:NSMakeRange(2, 5)];
            [accpassInfo addAttribute:NSForegroundColorAttributeName value:titleColor range:NSMakeRange(7, 6)];
            
            UILabel *accpassTitleLable = [[UILabel alloc] init];
            accpassTitleLable.attributedText = accpassInfo;
            accpassTitleLable.font = [UIFont systemFontOfSize:titleSize];
            [accpassView addSubview:accpassTitleLable];
            
            CGFloat accpassTitleLableWidth = viewSize.width - 2 * 10;
            CGSize accpassTitleLableSize = [accpassTitleLable sizeThatFits:CGSizeMake(accpassTitleLableWidth, MAXFLOAT)];
            
            CGFloat accpassViewW = viewSize.width;
            CGFloat accpassViewH = accpassTitleLableSize.height + 2 * 10;
            CGFloat accpassViewOX = 0;
            CGFloat accpassViewOY = allHeight;
            
            accpassView.frame = CGRectMake(accpassViewOX, accpassViewOY, accpassViewW, accpassViewH);
            
            CGFloat accpassTitleLableHeight = accpassTitleLableSize.height;
            CGFloat accpassTitleLableOX = 10;
            CGFloat accpassTitleLableOY = 10;
            
            accpassTitleLable.frame = CGRectMake(accpassTitleLableOX, accpassTitleLableOY, accpassTitleLableWidth, accpassTitleLableHeight);
            
            tempHeight = tempHeight + accpassViewH;
            
            groupViewHight = [groupView loginPwdVerification];
            allHeight = allHeight + groupViewHight + groupViewHight;
            _accPwdTextField = groupView.loginPwdVerificationTextField;
            _accPwdTextField.tag = textFieldTag;
//            [_accPwdTextField setMinLenght:@"6"];
//            [_accPwdTextField setMaxLenght:@"12"];
            
//            [textFieldArray addObject:accPwdTextField];
        }
        
        if ([@"sms" isEqualToString:type]) {
//            NSDictionary *smsDic = [dic objectForKey:@"sms"];
            
            groupViewHight = [groupView shortMsgAndPhoneNumVerification];
            allHeight = allHeight + groupViewHight;
            _phoneNumTextField = groupView.phoneNumVerificationTextField;
            _shortMsgBtn = groupView.shortMsgVerificationBtn;
            _shortMsgTextField = groupView.shortMsgVerificationTextField;
            
            _shortMsgBtn.tag = 201;
            _phoneNumTextField.tag = textFieldTag;
//            [_phoneNumTextField setMinLenght:@"0"];
//            [_phoneNumTextField setMaxLenght:@"11"];
//            _phoneNumTextField.text = [smsDic objectForKey:@"phoneNo"];
            textFieldTag = textFieldTag + 1;
            _shortMsgTextField.tag = textFieldTag;
//            [_shortMsgTextField setMinLenght:@"0"];
//            [_shortMsgTextField setMaxLenght:@"6"];
            
            [_shortMsgBtn addTarget:self action:@selector(buttonActionToDoSomething:) forControlEvents:UIControlEventTouchUpInside];
            
            CGSize shortMsgBtnSize = _shortMsgBtn.frame.size;
            shortMsgBtnW = shortMsgBtnSize.width;
            shortMsgBtnH = shortMsgBtnSize.height;
            
//            [textFieldArray addObject:phoneNumTextField];
//            [textFieldArray addObject:shortMsgTextField];
        }
        
        if ([@"img" isEqualToString:type]) {
            groupViewHight = [groupView pictureVerification];
            allHeight = allHeight + groupViewHight;
            _pictureBtn = groupView.pictureVerificationBtn;
            _pictureBtn.tag = 203;
            _pictureNumTextField = groupView.pictureVerificationTextField;
            _pictureNumTextField.tag = textFieldTag;
            
//            [textFieldArray addObject:pictureNumTextField];
        }
        
        if ([@"bankCard" isEqualToString:type]) {
//            NSDictionary *bankCardDic = [dic objectForKey:@"bankCard"];
            
            UIView *bankView = [[UIView alloc] init];
            bankView.backgroundColor = [UIColor colorWithRed:(242/255.0) green:(242/255.0) blue:(242/255.0) alpha:1.0];
            [view addSubview:bankView];
            
            
            NSMutableAttributedString *bankTitleInfo = [[NSMutableAttributedString alloc] initWithString:@"请输入与已绑定银行卡信息"];
            [bankTitleInfo addAttribute:NSForegroundColorAttributeName value:titleColor range:NSMakeRange(0 , 4)];
            [bankTitleInfo addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:(230/255.0) green:(2/255.0) blue:(2/255.0) alpha:1.0] range:NSMakeRange(4, 6)];
            [bankTitleInfo addAttribute:NSForegroundColorAttributeName value:titleColor range:NSMakeRange(10, 2)];
            
            UILabel *bankTitleLable = [[UILabel alloc] init];
            bankTitleLable.attributedText = bankTitleInfo;
            bankTitleLable.font = [UIFont systemFontOfSize:titleSize];
            [bankView addSubview:bankTitleLable];
            
            CGFloat bankTitleLableWidth = viewSize.width - 2 * 10;
            CGSize bankTitleLableSize = [bankTitleLable sizeThatFits:CGSizeMake(bankTitleLableWidth, MAXFLOAT)];
            
            CGFloat bankViewW = viewSize.width;
            CGFloat bankViewH = bankTitleLableSize.height + 2 * 10;
            CGFloat bankViewOX = 0;
            CGFloat bankViewOY = allHeight;
            
            bankView.frame = CGRectMake(bankViewOX, bankViewOY, bankViewW, bankViewH);
            
            CGFloat bankTitleLableHeight = bankTitleLableSize.height;
            CGFloat bankTitleLableOX = 10;
            CGFloat bankTitleLableOY = 10;
            
            bankTitleLable.frame = CGRectMake(bankTitleLableOX, bankTitleLableOY, bankTitleLableWidth, bankTitleLableHeight);
            
            tempHeight = tempHeight + bankViewH;
            
            groupViewHight = [groupView bankCardVerification];
            allHeight = allHeight + groupViewHight + bankViewH;
            _bankNameLabel = groupView.bankNameContentVerificationLabel;
//            _bankNameLabel.text = [bankCardDic objectForKey:@"openAccountBank"];
            _bankCardTextField = groupView.bankCardVerificationTextField;
//            [bankCardTextField setMinLenght:@"16"];
//            [bankCardTextField setMaxLenght:@"19"];
            _bankCardTextField.tag = textFieldTag;
            
//            [textFieldArray addObject:bankCardTextField];
        }
        
        if ([@"question" isEqualToString:type]) {
            questionFlag = YES;
//            NSArray *questionArray = [dic objectForKey:@"question"];
            NSInteger questionArrayCount = 3;
            
            for (int j = 0; j < questionArrayCount; j++) {
                
//                NSDictionary *questionDic = questionArray[j];
                
                GroupView *groupView = [[GroupView alloc] initWithFrame:self.view.frame];
                
                textFieldTag = textFieldTag + 1;
                groupViewHight = [groupView miBaoQuestionVerification];
                allHeight = allHeight + groupViewHight;
                _questionTextField = groupView.miBaoAnswerVerificationTextField;
                _questionTextField.tag = textFieldTag;
                _questionTitleLabel = groupView.miBaoTitleLabel;
                _questionlabel = groupView.miBaoTQuestionLabel;
                _questionBtn = groupView.miBaobtn;
                _questionBtn.tag = 301 + j;
//                _questionTitleLabel.text = [NSString stringWithFormat:@"密保问题%@", [questionDic objectForKey:@"questionNo"]];
//                _questionlabel.text = [NSString stringWithFormat:@"%@", [questionDic objectForKey:@"question"]];
                
                
//                viewHeight = groupViewHight;
                
                if (j == 0) {
                    tempHeight = tempHeight;
                } else {
                    tempHeight = tempHeight + groupViewHight;
                }
                groupView.frame = CGRectMake(0, tempHeight, viewSize.width, groupViewHight);
                
                [view addSubview:groupView];
                
//                [textFieldArray addObject:questionTextField];
            }
            
            return allHeight;
        }
        
        if ([@"identity" isEqualToString:type]) {
            UIView *identityView = [[UIView alloc] init];
            identityView.backgroundColor = [UIColor colorWithRed:(242/255.0) green:(242/255.0) blue:(242/255.0) alpha:1.0];
            [view addSubview:identityView];
            
            
            NSMutableAttributedString *identityTitleInfo = [[NSMutableAttributedString alloc] initWithString:@"请输入与注册信息一致的证件号码"];
            [identityTitleInfo addAttribute:NSForegroundColorAttributeName value:titleColor range:NSMakeRange(0 , 4)];
            [identityTitleInfo addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:(230/255.0) green:(2/255.0) blue:(2/255.0) alpha:1.0] range:NSMakeRange(4, 6)];
            [identityTitleInfo addAttribute:NSForegroundColorAttributeName value:titleColor range:NSMakeRange(10, 5)];
            
            UILabel *identityTitleLable = [[UILabel alloc] init];
            identityTitleLable.attributedText = identityTitleInfo;
            identityTitleLable.font = [UIFont systemFontOfSize:titleSize];
            [identityView addSubview:identityTitleLable];
            
            CGFloat identityTitleLableWidth = viewSize.width - 2 * 10;
            CGSize identityTitleLableSize = [identityTitleLable sizeThatFits:CGSizeMake(identityTitleLableWidth, MAXFLOAT)];
            
            CGFloat identityViewW = viewSize.width;
            CGFloat identityViewH = identityTitleLableSize.height + 2 * 10;
            CGFloat identityViewOX = 0;
            CGFloat identityViewOY = allHeight;
            
            identityView.frame = CGRectMake(identityViewOX, identityViewOY, identityViewW, identityViewH);
            
            CGFloat identityTitleLableHeight = identityTitleLableSize.height;
            CGFloat identityTitleLableOX = 10;
            CGFloat identityTitleLableOY = 10;
            
            identityTitleLable.frame = CGRectMake(identityTitleLableOX, identityTitleLableOY, identityTitleLableWidth, identityTitleLableHeight);
            
            tempHeight = tempHeight + identityViewH;
            
            groupViewHight = [groupView realNameAndIDCardVerification];
            allHeight = allHeight + groupViewHight + identityViewH;
            _realNameTextField = groupView.realNameVerificationTextField;
            _realNameTextField.tag = textFieldTag;
            textFieldTag = textFieldTag + 1;
            _IDCardTextField = groupView.IDCardVerificationTextField;
            _IDCardTextField.tag = textFieldTag;
//            [realNameTextField setMinLenght:@"4"];
//            [realNameTextField setMaxLenght:@"12"];
            
//            [IDCardTextField setMinLenght:@"18"];
//            [IDCardTextField setMaxLenght:@"18"];
//            [textFieldArray addObject:realNameTextField];
//            [textFieldArray addObject:IDCardTextField];
        }
        
        if ([@"cardCheckCode" isEqualToString:type]) {
            
        }
        
        if ([@"creditCard" isEqualToString:type]) {
            
        }
        
//        if (i == 0 && questionFlag == NO) {
//            groupView.frame = CGRectMake(0, 0, viewSize.width, groupViewHight);
//        } else {
//            if (i > 0 && i < authToolsArrayCount) {
//                UIView *lineView = [[UIView alloc] init];
//                lineView.frame = CGRectMake(leftRightSpace, tempHeight, viewSize.width - leftRightSpace, lineViewHeight);
//                lineView.backgroundColor = lineViewColor;
//                [view addSubview:lineView];
//                tempHeight = tempHeight + lineViewHeight;
//                tempLineViewHeight =  tempLineViewHeight + lineViewHeight;
//            }
//            
//            groupView.frame = CGRectMake(0, tempHeight, viewSize.width, groupViewHight);
//        }
        
        
        [view addSubview:groupView];
        
        
        
        
        
        
        //        if ([@"paypass" isEqualToString:type]) {
        //
        //            groupViewHight = [groupView loginPwdVerification];
        //            allHeight = allHeight + groupViewHight;
        //            //            payPwdTextField = groupView.loginPwdVerificationTextField;
        //        }
        //
        //        if ([@"gesture" isEqualToString:type]) {
        //
        //            groupViewHight = [groupView shortMsgAndPhoneNumVerification];
        //            allHeight = allHeight + groupViewHight;
        //
        //        }
        
        
    }
    
    return allHeight + tempLineViewHeight;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
