//
//  PaymentNoCell.m
//  sandbao
//
//  Created by tianNanYiHao on 2017/10/29.
//  Copyright © 2017年 sand. All rights reserved.
//

#import "PaymentNoCell.h"

/**
 代付凭证号
 */
@implementation PaymentNoCell


+(instancetype)createPaymentCellViewOY:(CGFloat)OY{
    
    PaymentNoCell *cell = [[PaymentNoCell alloc] initWithFrame:CGRectMake(0, OY, 0, 0)];
    return cell;
}

- (instancetype)initWithFrame:(CGRect)frame{
    
    if ([super initWithFrame:frame]) {
        
        self.titleStr = @"代付凭证序列号";
        self.textfield.placeholder = @"请输入代付凭证号";
        self.textfield.keyboardType = UIKeyboardTypeNumberPad;
        self.textfield.delegate = self;
        
    }return self;
}

#define OnlyNumberVerifi @"0987654321"
#pragma - mark textfiledDelegate
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    
    //禁止输入空格且警告
    if ([string isEqualToString:@" "]) {
        [self showTip];
        return NO;
    }
    //超过16长度不能再输入且警告提示
    if (textField.text.length >=20 && ![string isEqualToString:@""]) {
        [self showTip];
        return NO;
    }
    //限制输入纯数字
    if (![self restrictionwithTypeStr:OnlyNumberVerifi string:string]) {
        [self showTip];
        return NO;
    }
    
    //实时获取输入的框内的text,校验后返回
    NSString *currentText = [textField.text stringByReplacingCharactersInRange:range withString:string];
    if (currentText.length >= 16 && currentText.length <= 20) {
        if (currentText.length > 0) {
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
    
    if (!(textField.text.length>=16 && textField.text.length<=20) && (textField.text.length>0)) {
        [self deleteErrorTextAnimation:textField];
        [self showTip];
    }else if(textField.text>0){
        _successBlock(textField.text);
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



@end
