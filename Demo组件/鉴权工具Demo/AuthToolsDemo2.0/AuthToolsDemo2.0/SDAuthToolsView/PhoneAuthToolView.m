//
//  PhoneAuthToolView.m
//  AuthToolsDemo2.0
//
//  Created by tianNanYiHao on 2017/10/12.
//  Copyright © 2017年 tianNanYiHao. All rights reserved.
//

#import "PhoneAuthToolView.h"

@implementation PhoneAuthToolView

/**
 创建对象
 
 @param OY Y坐标
 @return 实例
 */
+ (instancetype)createAuthToolViewOY:(CGFloat)OY{
    
    PhoneAuthToolView *view = [[PhoneAuthToolView alloc] initWithFrame:CGRectMake(0, OY, 0, 0)];
    return view;
    
}


- (instancetype)initWithFrame:(CGRect)frame{
    
    if ([super initWithFrame:frame]) {
        self.titleLab.text = @"账号";
        self.textfiled.placeholder = @"输入手机号";
        self.textfiled.keyboardType = UIKeyboardTypeNumberPad;
        
    }return self;
    
}



#define OnlyNumberVerifi @"0987654321"
#pragma - mark textfiledDelegate
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    
    //禁止输入空格且警告
    if ([string isEqualToString:@" "]) {
        _errorBlock();
        return NO;
    }
    //超过11长度不能再输入且警告提示
    if (textField.text.length >=11 && ![string isEqualToString:@""]) {
        _errorBlock();
        return NO;
    }
    //限制输入纯数字
    if (![self restrictionwithTypeStr:OnlyNumberVerifi string:string]) {
        _errorBlock();
        return NO;
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
    //手机号正则校验
    if ((![self validateMobile:textField.text]) && (textField.text.length > 0)) {
        [self deleteErrorTextAnimation:textField];
        _errorBlock();
    }
    if ([self validateMobile:textField.text] && textField.text.length > 0) {
        _successBlock();
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
 *@brief 手机号码验证  手机号以13,14,15,17,18开头，八个 \d 数字字符
 *@param mobile 字符串 参数：手机号码验证
 *@return 返回BOOL
 */
- (BOOL) validateMobile:(NSString *)mobile
{
    //手机号以13,14,15,17,18开头，八个 \d 数字字符
    NSString *phoneRegex = @"^((13[0-9])|(15[^4,\\D])|(17[0-9])|(18[0,0-9]))\\d{8}$";
    //    NSString *phoneRegex = @"^((10[0-9])|(11[0-9])|(12[0-9])|(13[0-9])|(14[^4,\\D])|(15[^4,\\D])|(16[0-9])|(17[0-9])|(18[0,0-9])|(19[0-9]))\\d{8}$";
    NSPredicate *phoneTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",phoneRegex];
    return [phoneTest evaluateWithObject:mobile];
}



@end
