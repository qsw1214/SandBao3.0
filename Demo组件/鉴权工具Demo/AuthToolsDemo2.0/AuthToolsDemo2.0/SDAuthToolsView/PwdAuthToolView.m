//
//  PwdAuthToolView.m
//  AuthToolsDemo2.0
//
//  Created by tianNanYiHao on 2017/10/12.
//  Copyright © 2017年 tianNanYiHao. All rights reserved.
//

#import "PwdAuthToolView.h"

@interface PwdAuthToolView (){
    UIButton *eyeBtn;
}

@end

@implementation PwdAuthToolView

/**
 创建对象
 
 @param OY Y坐标
 @return 实例
 */
+ (instancetype)createAuthToolViewOY:(CGFloat)OY{
    
    PwdAuthToolView *view = [[PwdAuthToolView alloc] initWithFrame:CGRectMake(0, OY, 0, 0)];
    return view;
    
}

- (instancetype)initWithFrame:(CGRect)frame{
    
    if ([super initWithFrame:frame]) {
        self.titleLab.text = @"密码";
        self.textfiled.placeholder = @"输入登陆密码";
        self.textfiled.clearButtonMode = UITextFieldViewModeNever;
        //默认类型 == 登陆密码 类型
        self.type = PwdAuthToolLoginPwdType;
        [self addUI];
    }return self;
    
}

- (void)addUI{
    
    //pwd
    self.textfiled.secureTextEntry = YES;
    self.textfiled.delegate = self;
    self.textfiled.keyboardType = UIKeyboardTypeDefault;
    
    
    //btnEye
    
    UIImage *imageEyedeful = [UIImage imageNamed:@"login_icon_eye_default"];
    UIImage *iamgeEyeSelect = [UIImage imageNamed:@"login_icon_eye_lighted"];
    
    eyeBtn = [[UIButton alloc] init];
    [eyeBtn setImage:imageEyedeful forState:UIControlStateNormal];
    [eyeBtn setImage:iamgeEyeSelect forState:UIControlStateSelected];
    eyeBtn.selected = NO;
    [eyeBtn addTarget:self action:@selector(click:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:eyeBtn];
    
    //frame
    
    //往上偏移半个space
    CGFloat eyeBtnOY = self.titleLab.frame.size.height + ((self.textfiled.frame.size.height - imageEyedeful.size.height)/2 - self.space/2);
    //往左便宜半个space
    CGFloat eyeBtnOX = self.frame.size.width - self.leftRightSpace - imageEyedeful.size.width - self.space/2;
    //整体按钮扩大一个space
    eyeBtn.frame = CGRectMake(eyeBtnOX, eyeBtnOY, imageEyedeful.size.width+self.space, imageEyedeful.size.height+self.space);
    
    
}

- (void)setType:(PwdAuthToolViewType)type{
    _type = type;
    self.textfiled.keyboardType = UIKeyboardTypeNumberPad;
    eyeBtn.hidden = YES;
}

- (void)click:(UIButton*)btn{
    
    btn.selected = !btn.selected;
    self.textfiled.secureTextEntry = !self.textfiled.secureTextEntry;

    //解决切换明密文后, textfiled文字后缀有空格问题
    NSString* text = self.textfiled.text;
    self.textfiled.text = @" ";
    self.textfiled.text = text;
    
}


#define OnlyNum_letterVerifi @"ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789"
#pragma - mark textfiledDelegate
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    
    //禁止输入空格且警告
    if ([string isEqualToString:@" "]) {
        [self showTip];
        return NO;
    }
    //登录密码模式
    if (self.type == PwdAuthToolLoginPwdType) {
        //超过20长度不能再输入且警告提示
        if (textField.text.length >=20 && ![string isEqualToString:@""]) {
            [self showTip];
            return NO;
        }
        //限制输入纯数字纯字母
        if (![self restrictionwithTypeStr:OnlyNum_letterVerifi string:string]) {
            [self showTip];
            return NO;
        }
        
        //实时获取输入的框内的text,校验后返回
        NSString *currentText = [textField.text stringByReplacingCharactersInRange:range withString:string];
        if (currentText.length >= 8 && currentText.length <= 20) {
            if ([self validatePasswordNumAndLetter:currentText] && currentText.length > 0) {
                _successBlock(currentText);
            }
        }
    }
    //杉德卡密码模式
    if (self.type == PwdAuthToolSandPayPwdType) {
        //超过6长度不能再输入且警告提示
        if (textField.text.length >=6 && ![string isEqualToString:@""]) {
            [self showTip];
            return NO;
        }
        
        //实时获取输入的框内的text,校验后返回
        NSString *currentText = [textField.text stringByReplacingCharactersInRange:range withString:string];
        if (currentText.length == 6) {
            _successBlock(currentText);
        }
    }
    
    
    
    return YES;
}
-(BOOL)restrictionwithTypeStr:(NSString*)typeStr string:(NSString*)string{
    NSCharacterSet *cs = [[NSCharacterSet characterSetWithCharactersInString:typeStr] invertedSet];
    NSString *filtered = [[string componentsSeparatedByCharactersInSet:cs] componentsJoinedByString:@""];
    if ([string isEqualToString:@""]) { //不过滤回退键
        return YES;
    }
    if ([string isEqualToString:filtered]) {
        return YES;
    }else{
        return NO;  //过滤
    }
}


- (void)textFieldDidEndEditing:(UITextField *)textField{
    //登录密码模式
    if (self.type == PwdAuthToolLoginPwdType) {
        if (((![self validatePasswordNumAndLetter:textField.text]) || !(textField.text.length>=8 && textField.text.length<=20)) && (textField.text.length>0)) {
            [self deleteErrorTextAnimation:textField];
            [self showTip];
        }else if([self validatePasswordNumAndLetter:textField.text] && textField.text>0){
            //回调
            _successBlock(textField.text);
        }
    }
    //杉德卡密码模式
    if (self.type == PwdAuthToolSandPayPwdType) {
        if ((!(textField.text.length == 6)) && (textField.text.length>0)) {
            [self deleteErrorTextAnimation:textField];
            [self showTip];
        }else if(textField.text>0){
            //回调
            _successBlock(textField.text);
        }
    }
    
}


- (void)textFieldDidBeginEditing:(UITextField *)textField{
    if (textField.text.length>0) {
        //清空
        self.textfiled.text = @"";
    }
    
    
}


/**
 动画 - textfiled错误删除动画
 
 @param textField textfiled
 */
- (void)deleteErrorTextAnimation:(UITextField*)textField{
    
    [UIView animateWithDuration:1.5f delay:0.5f options:UIViewAnimationOptionCurveEaseInOut|UIViewKeyframeAnimationOptionAllowUserInteraction animations:^{
        textField.alpha = 0.f;
    } completion:^(BOOL finished) {
        textField.alpha = 1.f;
        textField.text = @"";
    }];
}

/**
 *@brief 数字和字母组合密码
 *@param passWord 字符串 参数：密码
 *@return 返回BOOL
 */
- (BOOL)validatePasswordNumAndLetter:(NSString *)passWord
{
    NSString *passWordRegex = @"^(?![0-9]+$)(?![a-zA-Z]+$)[a-zA-Z0-9]+$";
    NSPredicate *passWordPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",passWordRegex];
    return [passWordPredicate evaluateWithObject:passWord];
}

@end
