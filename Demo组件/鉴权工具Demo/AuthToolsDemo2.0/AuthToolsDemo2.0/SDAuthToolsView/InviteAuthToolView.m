//
//  InviteAuthToolView.m
//  sandbao
//
//  Created by tianNanYiHao on 2018/1/24.
//  Copyright © 2018年 sand. All rights reserved.
//

#import "InviteAuthToolView.h"

@implementation InviteAuthToolView


/**
 创建对象
 
 @param OY Y坐标
 @return 实例
 */
+ (instancetype)createAuthToolViewOY:(CGFloat)OY{
    
    InviteAuthToolView *view = [[InviteAuthToolView alloc] initWithFrame:CGRectMake(0, OY, 0, 0)];
    return view;
    
}

- (instancetype)initWithFrame:(CGRect)frame{
    
    if ([super initWithFrame:frame]) {
        self.titleLab.text = @"好友邀请码(非必填项)";
        self.textfiled.placeholder = @"输入邀请码";
        self.textfiled.keyboardType = UIKeyboardTypeDefault;
        
    }return self;
    
}

#define InviteCodeVerifi @"123456789QWERTYUPLKJHGFDSAZXCVBNMqwertyuipkjhgfdsazxcvbnm"
#pragma - mark textfiledDelegate
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    
    //禁止输入空格且警告
    if ([string isEqualToString:@" "]) {
        [self showTip];
        return NO;
    }
    //超过6
    if (textField.text.length >=6 && ![string isEqualToString:@""]) {
        [self showTip];
        return NO;
    }
    ////限制邀请码特殊字符输入
    if (![self restrictionwithTypeStr:InviteCodeVerifi string:string]) {
        [self showTip];
        return NO;
    }
    
    //实时获取输入的框内的text,校验后返回
    NSString *currentText = [textField.text stringByReplacingCharactersInRange:range withString:string];
    if (currentText.length <=6) {
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
    
    if ((textField.text.length<6) && (textField.text.length>0)) {
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
