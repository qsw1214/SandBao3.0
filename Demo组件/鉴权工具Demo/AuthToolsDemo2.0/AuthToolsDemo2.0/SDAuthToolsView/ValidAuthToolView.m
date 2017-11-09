//
//  ValidAuthToolView.m
//  AuthToolsDemo2.0
//
//  Created by tianNanYiHao on 2017/11/8.
//  Copyright © 2017年 tianNanYiHao. All rights reserved.
//

#import "ValidAuthToolView.h"

@implementation ValidAuthToolView


/**
 创建对象
 
 @param OY Y坐标
 @return 实例
 */
+ (instancetype)createAuthToolViewOY:(CGFloat)OY{
    
    ValidAuthToolView *view = [[ValidAuthToolView alloc] initWithFrame:CGRectMake(0, OY, 0, 0)];
    return view;
    
}

- (instancetype)initWithFrame:(CGRect)frame{
    
    if ([super initWithFrame:frame]) {
        self.titleLab.text = @"有效期";
        self.textfiled.placeholder = @"输入卡片有效期";
        self.textfiled.keyboardType = UIKeyboardTypeNumberPad;
        
    }return self;
    
}

#pragma - mark textfiledDelegate
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    
    //禁止输入空格且警告
    if ([string isEqualToString:@" "]) {
        [self showTip];
        return NO;
    }
    //超过4长度不能再输入且警告提示
    if (textField.text.length >=4 && ![string isEqualToString:@""]) {
        [self showTip];
        return NO;
    }
    
    //实时获取输入的框内的text,校验后返回
    NSString *currentText = [textField.text stringByReplacingCharactersInRange:range withString:string];
    if (currentText.length <= 4) {
        if (currentText.length > 0) {
            _successBlock(currentText);
        }
    }
    
    return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField{
    if (textField.text.length > 4) {
        [self deleteErrorTextAnimation:textField];
        [self showTip];
    }
    if (textField.text.length > 0) {
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
