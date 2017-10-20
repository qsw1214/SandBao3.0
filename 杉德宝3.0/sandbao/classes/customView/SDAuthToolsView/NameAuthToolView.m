//
//  NameAuthToolView.m
//  AuthToolsDemo2.0
//
//  Created by tianNanYiHao on 2017/10/12.
//  Copyright © 2017年 tianNanYiHao. All rights reserved.
//

#import "NameAuthToolView.h"

@implementation NameAuthToolView

/**
 创建对象
 
 @param OY Y坐标
 @return 实例
 */
+ (instancetype)createAuthToolViewOY:(CGFloat)OY{
    
    NameAuthToolView *view = [[NameAuthToolView alloc] initWithFrame:CGRectMake(0, OY, 0, 0)];
    return view;
    
}

- (instancetype)initWithFrame:(CGRect)frame{
    
    if ([super initWithFrame:frame]) {
        self.titleLab.text = @"真实姓名";
        self.textfiled.placeholder = @"输入真实姓名";
        self.textfiled.autocorrectionType = UITextAutocorrectionTypeNo; //不自动纠错
        self.textfiled.delegate = self;
        
    }return self;
    
}



#define OnlyChineseCharacterVerifi @"0123456789./*-+~!@#$%^&()_+-=,./;'[]{}:<>?`，。、？！‘“：；【】{}·~！……——“”<>《》%﹪。？！、；#＠～:,!?.*|……·＊－＝﹤︳`∕"
#pragma - mark textfiledDelegate
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    
    //禁止输入空格且警告
    if ([string isEqualToString:@" "]) {
        _errorBlock();
        return NO;
    }
    //超过6长度不能再输入且警告提示
    if (textField.text.length >6 && ![string isEqualToString:@""]) {
        _errorBlock();
        return NO;
    }
    ////限制输入字母数字特殊字符
    if (![self restrictionwithChineseCharTypeStr:OnlyChineseCharacterVerifi string:string]) {
        _errorBlock();
        return NO;
    }
    
    return YES;
}
-(BOOL)restrictionwithChineseCharTypeStr:(NSString*)typeStr string:(NSString*)string{
    NSCharacterSet *cs = [[NSCharacterSet characterSetWithCharactersInString:typeStr] invertedSet];
    NSString *filtered = [[string componentsSeparatedByCharactersInSet:cs] componentsJoinedByString:@""];
    if ([string isEqualToString:@""]) { //不过滤回退键
        return YES;
    }
    if ([string isEqualToString:filtered]) {
        return NO; //过滤
    }else{
        return YES;
    }
}

- (void)textFieldDidEndEditing:(UITextField *)textField{
    
    if (!(textField.text.length>=2 && textField.text.length<=6) && (textField.text.length>0)) {
        [self deleteErrorTextAnimation:textField];
        _errorBlock();
    }else if(textField.text>0){
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
