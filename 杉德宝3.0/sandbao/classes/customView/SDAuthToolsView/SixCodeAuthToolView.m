//
//  SixCodeAuthToolView.m
//  AuthToolsDemo2.0
//
//  Created by tianNanYiHao on 2017/10/13.
//  Copyright © 2017年 tianNanYiHao. All rights reserved.
//

#import "SixCodeAuthToolView.h"
#import "NoCopyTextField.h"

@interface SixCodeAuthToolView ()<UITextFieldDelegate>{
    
    NSInteger codeLabCount;
    NSTimer *timer;
    NSTimeInterval timeOut;
    NSInteger timeCount;
    UIButton *requestSmsBtn;
    NoCopyTextField *noCopyTextfield;
    
}
@property (nonatomic, strong) NSMutableArray *codeLabArr; //保存codeLab的数组
@end

@implementation SixCodeAuthToolView

/**
 创建对象
 
 @param OY Y坐标
 @return 实例
 */
+ (instancetype)createAuthToolViewOY:(CGFloat)OY{
    
    SixCodeAuthToolView *view = [[SixCodeAuthToolView alloc] initWithFrame:CGRectMake(0, OY, 0, 0)];
    return view;
    
}

- (instancetype)initWithFrame:(CGRect)frame{
    
    if ([super initWithFrame:frame]) {
        //sixCode不需要tip,因此在此子类中删除
        [self.tip removeFromSuperview];
        
        //sixCode中需禁止父类的textfied的黏贴复制功能,因此使用 noCopyTextfield 来替换 self.textfied,从而禁止用户粘贴复制
        noCopyTextfield = [[NoCopyTextField alloc] init];
        noCopyTextfield.frame = self.textfiled.frame;
        [self addSubview:noCopyTextfield];
        [self.textfiled removeFromSuperview];
        
        noCopyTextfield.placeholder = @"";
        noCopyTextfield.clearButtonMode = UITextFieldViewModeNever;
        noCopyTextfield.delegate = self;
        noCopyTextfield.backgroundColor = [UIColor clearColor];
        noCopyTextfield.textColor = [UIColor clearColor];
        noCopyTextfield.tintColor = [UIColor clearColor];
        noCopyTextfield.autocapitalizationType = UITextAutocapitalizationTypeNone;
        noCopyTextfield.keyboardType = UIKeyboardTypeNumberPad;
        [noCopyTextfield addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
        
        self.lineV.hidden = YES;
        
        
    }return self;
    
}

- (void)setStyle:(CodeAuthToolStyle)style{
    
    _style = style;
    
    if (_style == SmsCodeAuthTool) {
        self.titleLab.text = @"验证码";
        
    }
    if (_style == PayCodeAuthTool) {
        self.titleLab.text = @"支付密码";
        
    }
    [self addUI];
}

- (void)addUI{
    
    //参数预设
    codeLabCount = 6;
    
    CGFloat space = 10;
    CGFloat spaceAll = (codeLabCount-1) * space;
    
    CGFloat sixCodeLabAllWidth = noCopyTextfield.frame.size.width - spaceAll;
    CGFloat sixCodeLabHeight   = noCopyTextfield.frame.size.height;
    
    CGFloat codeLabWidth = sixCodeLabAllWidth/6.f;
    CGFloat codeLabHeight = sixCodeLabHeight;
    CGFloat codeLabOY    = self.titleLab.frame.size.height;
    
    //清空数组
    if (self.codeLabArr.count>0) {
        [self.codeLabArr removeAllObjects];
    }
    
    //UI创建
    for (int i = 0; i < codeLabCount; i++) {
        //lab
        UILabel *codeLab = [[UILabel alloc] init];
        codeLab.textAlignment = NSTextAlignmentCenter;
        codeLab.frame = CGRectMake(i*codeLabWidth+self.leftRightSpace+i*space, codeLabOY, codeLabWidth, codeLabHeight);
        [self.codeLabArr addObject:codeLab];
        [self addSubview:codeLab];
        
        //bottomLine
        UIView *bottomLineV = [[UIView alloc] init];
        bottomLineV.backgroundColor = [UIColor colorWithRed:216/255.0 green:216/255.0 blue:216/255.0 alpha:1/1.0];
        bottomLineV.frame = CGRectMake(codeLab.frame.origin.x, codeLab.frame.size.height+codeLabOY, codeLab.frame.size.width, 1.f);
        [self addSubview:bottomLineV];
    }
    
#pragma - mark ====================== 根据style类型是否追加底部短信发送按钮 ===========================
    //根据style类型是否追加底部短信发送按钮
    if (_style == SmsCodeAuthTool) {
        requestSmsBtn = [[UIButton alloc] init];
        requestSmsBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
        requestSmsBtn.titleLabel.font =  [UIFont fontWithName:@"PingFang-SC-Regular" size:12];
        requestSmsBtn.titleLabel.textColor = [UIColor colorWithRed:102/255.0 green:102/255.0 blue:102/255.0 alpha:1/1.0];
        [requestSmsBtn addTarget:self action:@selector(changeBtnSate:) forControlEvents:UIControlEventTouchUpInside];
        NSMutableAttributedString *atr = [[NSMutableAttributedString alloc] initWithString:@"点我获取短信"];
        [atr addAttributes:@{
                             NSFontAttributeName:[UIFont fontWithName:@"PingFang-SC-Regular" size:12],
                             NSForegroundColorAttributeName:[UIColor colorWithRed:53/255.0 green:139/255.0 blue:239/255.0 alpha:1/1.0]
                             } range:NSMakeRange(2, 2)];
        [requestSmsBtn setAttributedTitle:atr forState:UIControlStateNormal];
        requestSmsBtn.selected = NO;
        [self addSubview:requestSmsBtn];
        
        CGFloat requestBtnOX = self.leftRightSpace;
        CGFloat requestBtnOY = codeLabHeight + codeLabOY;
        CGSize requestBtnSize = [requestSmsBtn sizeThatFits:CGSizeZero];
        requestSmsBtn.frame = CGRectMake(requestBtnOX, requestBtnOY, noCopyTextfield.frame.size.width, requestBtnSize.height + 4*self.space);
        
        //重置frame
        CGRect rectFrame = self.frame;
        rectFrame.size.height = requestSmsBtn.frame.size.height + requestBtnOY;
        self.frame = rectFrame;
        
        
    }
    
    
}

- (void)textFieldDidChange:(UITextField*)textfiled{
    
    NSInteger length = textfiled.text.length;
    
    if (length == 0) {
        UILabel *currentCodelab = (UILabel*)self.codeLabArr[length];
        currentCodelab.text = @"";
    }else{
        UILabel *currentCodelab = (UILabel*)self.codeLabArr[length-1];
        if (_style == SmsCodeAuthTool) {
            currentCodelab.text = [NSString stringWithFormat:@"%C", [textfiled.text characterAtIndex:length-1]];
        }
        if (_style == PayCodeAuthTool) {
            currentCodelab.font = [UIFont systemFontOfSize:30];
            currentCodelab.text = @"•";
        }
        if (length < codeLabCount) {
            UILabel *currentCodelab = (UILabel*)self.codeLabArr[length];
            currentCodelab.text = @"";
        }
        
        //短信码字符串回调
        if (textfiled.text.length == 6) {
            self.smsCodeStrBlock(textfiled.text);
        }
        
    }
    
}

- (void)changeBtnSate:(UIButton*)btn{
    
    if (btn.selected == NO) {
        btn.selected =  YES;
        timeCount = 60;
        [self shortMsgCodeCountDown];
        //短信码请求事件回调
        self.smsRequestBlock();
    }
    
    
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
        [requestSmsBtn setUserInteractionEnabled:YES];
        requestSmsBtn.selected = NO;
        NSMutableAttributedString *atr = [[NSMutableAttributedString alloc] initWithString:@"点我重新发送一次短信"];
        [atr addAttributes:@{
                             NSFontAttributeName:[UIFont fontWithName:@"PingFang-SC-Regular" size:12],
                             NSForegroundColorAttributeName:[UIColor colorWithRed:53/255.0 green:139/255.0 blue:239/255.0 alpha:1/1.0]
                             } range:NSMakeRange(2, 4)];
        [requestSmsBtn setAttributedTitle:atr forState:UIControlStateNormal];
        
        
    } else {
        [requestSmsBtn setUserInteractionEnabled:NO];
        
        NSString *time = [NSString stringWithFormat:@"(%ld秒)后可重新发送短信", (long)timeCount];
        NSMutableAttributedString *atr = [[NSMutableAttributedString alloc] initWithString:time];
        [atr addAttributes:@{
                             NSFontAttributeName:[UIFont fontWithName:@"PingFang-SC-Regular" size:12],
                             NSForegroundColorAttributeName:[UIColor colorWithRed:53/255.0 green:139/255.0 blue:239/255.0 alpha:1/1.0]
                             } range:NSMakeRange(1, 2)];
        [requestSmsBtn setAttributedTitle:atr forState:UIControlStateNormal];
    }
}

#pragma - mark textfiledDelegate

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    
    if (string.length == 0) {
        return YES;
    }else if (textField.text.length >= codeLabCount){
        return NO;
    }
    
    else{
        return YES;
    }
}

#pragma - mark layzeLoad
- (NSMutableArray*)codeLabArr{
    
    if (!_codeLabArr) {
        _codeLabArr = [NSMutableArray arrayWithCapacity:0];
    }
    return _codeLabArr;
    
    
}
@end
