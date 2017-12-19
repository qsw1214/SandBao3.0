//
//  SixCodeAuthToolView.m
//  AuthToolsDemo2.0
//
//  Created by tianNanYiHao on 2017/10/13.
//  Copyright © 2017年 tianNanYiHao. All rights reserved.
//

#import "SixCodeAuthToolView.h"

#define TIME_OUT 61

@interface SixCodeAuthToolView ()<UITextFieldDelegate>{
    
    NSInteger codeLabCount;
    UIButton *requestSmsBtn;
    dispatch_source_t timer;
}
@property (nonatomic, strong) NSMutableArray *codeLabArr; //保存codeLab的数组
@end

@implementation SixCodeAuthToolView
@synthesize noCopyTextfield;


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
        //短信模式禁止交互
        noCopyTextfield.userInteractionEnabled = NO;
        self.titleLab.text = @"验证码";
        //取缓存中的倒计时
        NSInteger currentTimeOut = [SixCodeAuthToolView getCurrentTimeOut];
        if (currentTimeOut>0) {
            //以当前timeOut 开启GCD定时器
            [self createTimer:currentTimeOut];
        }
        
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
        codeLab.tag = 10000 + i;
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
    
    if (length == 6) {
        //隐藏键盘
        [textfiled resignFirstResponder];
    }
    
    if (length == 0) {
        for (int i  = 0; i<self.codeLabArr.count; i++) {
            UILabel *currentCodelab = (UILabel*)self.codeLabArr[i];
            currentCodelab.text = @"";
        }
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
        
        //字符串回调
        if (textfiled.text.length == 6) {
            //回调短信码
            if (_style == SmsCodeAuthTool) {
                self.successBlock(textfiled.text);
                //回调以后,禁止用户交互
                noCopyTextfield.userInteractionEnabled = NO;
            }
            //回调支付密码
            if (_style == PayCodeAuthTool) {
                self.successBlock(textfiled.text);
            }
        }
        
    }
    
}

- (void)changeBtnSate:(UIButton*)btn{
    
    if (btn.selected == NO) {
        
        btn.selected =  YES;
        
//        //恢复交互
//        noCopyTextfield.userInteractionEnabled = YES;
        
//        //点击发送短信按钮后, 键盘自动弹出
//        [noCopyTextfield becomeFirstResponder];
        
        
        
        //GCD创建计时器
        [self createTimer:0];
        
        //短信码请求事件回调
        self.successRequestBlock(@"");
        
        //清空六个lab
        for (UILabel *subLab in self.codeLabArr) {
            subLab.text = @"";
        }
        //清空 noCopyTextfield
        noCopyTextfield.text = nil;
        
    }
    
    
}





#pragma mark - 定时器 (GCD)
- (void)createTimer:(NSInteger)currentTimeOut {
    
    //设置倒计时时间
    //通过检验发现，方法调用后，timeout会先自动-1，所以如果从15秒开始倒计时timeout应该写16
    //__block 如果修饰指针时，指针相当于弱引用，指针对指向的对象不产生引用计数的影响
    __block NSInteger timeout;
    
    if (currentTimeOut>0) {
        timeout = currentTimeOut;
    }else{
        timeout = TIME_OUT;
    }
    
    
    //获取全局队列
    dispatch_queue_t global = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    
    //创建一个定时器，并将定时器的任务交给全局队列执行(并行，不会造成主线程阻塞)
    timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, global);
    
    // 设置触发的间隔时间
    dispatch_source_set_timer(timer, DISPATCH_TIME_NOW, 1.0 * NSEC_PER_SEC, 0 * NSEC_PER_SEC);
    //1.0 * NSEC_PER_SEC  代表设置定时器触发的时间间隔为1s
    //0 * NSEC_PER_SEC    代表时间允许的误差是 0s
    
    //block内部 如果对当前对象的强引用属性修改 应该使用__weak typeof(self)weakSelf 修饰  避免循环调用
    
    //设置定时器的触发事件
    dispatch_source_set_event_handler(timer, ^{
        
        //倒计时  刷新button上的title ，当倒计时时间为0时，结束倒计时
        
        //1. 每调用一次 时间-1s 存一次当前计时器
        timeout --;
        [[NSUserDefaults standardUserDefaults] setInteger:timeout forKey:@"currentTimeOut"];
        //2.对timeout进行判断时间是停止倒计时，还是修改button的title
        if (timeout <= 0) {
            
            //停止倒计时，button打开交互,状态修改
            
            //关闭定时器
            dispatch_source_cancel(timer);
            
            
            //button上的相关设置
            //注意: button是属于UI，在iOS中多线程处理时，UI控件的操作必须是交给主线程(主队列)
            //在主线程中对button进行修改操作
            dispatch_async(dispatch_get_main_queue(), ^{
                
                [requestSmsBtn setUserInteractionEnabled:YES];
                requestSmsBtn.selected = NO;
                NSMutableAttributedString *atr = [[NSMutableAttributedString alloc] initWithString:@"点我获取短信"];
                [atr addAttributes:@{
                                     NSFontAttributeName:[UIFont fontWithName:@"PingFang-SC-Regular" size:12],
                                     NSForegroundColorAttributeName:[UIColor colorWithRed:242/255.0 green:9/255.0 blue:9/255.0 alpha:1/1.0]
                                     } range:NSMakeRange(2, 2)];
                [requestSmsBtn setAttributedTitle:atr forState:UIControlStateNormal];

            });
        }else {
            
            //处于正在倒计时，在主线程中刷新button上的title，时间-1秒
            dispatch_async(dispatch_get_main_queue(), ^{
                
                [requestSmsBtn setUserInteractionEnabled:NO];
                NSString *time = [NSString stringWithFormat:@"(%ld秒)后可重新发送短信", (long)timeout];
                NSLog(@"-=-=-=-=-=-=-=-=-= -=-=-=  -=-=-= %@",time);
                NSMutableAttributedString *atr = [[NSMutableAttributedString alloc] initWithString:time];
                [atr addAttributes:@{
                                     NSFontAttributeName:[UIFont fontWithName:@"PingFang-SC-Regular" size:12],
                                     NSForegroundColorAttributeName:[UIColor colorWithRed:242/255.0 green:9/255.0 blue:9/255.0 alpha:1/1.0]
                                     } range:NSMakeRange(1, 2)];
                [requestSmsBtn setAttributedTitle:atr forState:UIControlStateNormal];
            });
        }
    });
    
    dispatch_resume(timer);
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

#pragma mark - 停止计时器(当短信输入且验证成功)
-(void)stopTimer{
    
    [[NSUserDefaults standardUserDefaults] setInteger:0 forKey:@"currentTimeOut"];
    if(timer){
        dispatch_source_cancel(timer);
        timer = nil;
    }
}

#pragma mark -设置倒计时时间为零
+ (void)setZeroForCurrentTimeOut{
    [[NSUserDefaults standardUserDefaults] setInteger:0 forKey:@"currentTimeOut"];
}

#pragma mark - 外部调用开启短信倒计时(非按钮事件调用)
- (void)startTimeOut{
    
    [self createTimer:TIME_OUT];
}

#pragma mark - 获取当前存储的currentTimeOut
+ (NSInteger)getCurrentTimeOut{
    
    return [[[NSUserDefaults standardUserDefaults] objectForKey:@"currentTimeOut"] integerValue];
}

@end
