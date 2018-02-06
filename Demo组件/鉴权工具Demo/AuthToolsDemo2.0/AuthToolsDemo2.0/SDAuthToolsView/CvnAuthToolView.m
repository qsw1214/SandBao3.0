//
//  CvnAuthToolView.m
//  AuthToolsDemo2.0
//
//  Created by tianNanYiHao on 2017/11/8.
//  Copyright © 2017年 tianNanYiHao. All rights reserved.
//

#import "CvnAuthToolView.h"


@implementation CvnAuthToolView

/**
 创建对象
 
 @param OY Y坐标
 @return 实例
 */
+ (instancetype)createAuthToolViewOY:(CGFloat)OY{
    
    CvnAuthToolView *view = [[CvnAuthToolView alloc] initWithFrame:CGRectMake(0, OY, 0, 0)];
    return view;
    
}

- (instancetype)initWithFrame:(CGRect)frame{
    
    if ([super initWithFrame:frame]) {
        self.titleLab.text = @"CVN";
        self.textfiled.placeholder = @"输入卡片背面签名处后三位校验码";
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
    //超过3长度不能再输入且警告提示
    if (textField.text.length >=3 && ![string isEqualToString:@""]) {
        [self showTip];
        return NO;
    }
    
    //实时获取输入的框内的text,校验后返回
    NSString *currentText = [textField.text stringByReplacingCharactersInRange:range withString:string];
    if (currentText.length <= 3) {
        if (currentText.length > 0) {
            _successBlock(currentText);
        }
    }
    
    return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField{
    if (textField.text.length > 3) {
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
