//
//  PwdAuthToolView.m
//  AuthToolsDemo2.0
//
//  Created by tianNanYiHao on 2017/10/12.
//  Copyright © 2017年 tianNanYiHao. All rights reserved.
//

#import "PwdAuthToolView.h"

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
    
    UIButton *eyeBtn = [[UIButton alloc] init];
    [eyeBtn setImage:imageEyedeful forState:UIControlStateNormal];
    [eyeBtn setImage:iamgeEyeSelect forState:UIControlStateSelected];
    eyeBtn.selected = NO;
    [eyeBtn addTarget:self action:@selector(click:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:eyeBtn];
    
    //frame
    
    //往上偏移半个space
    CGFloat eyeBtnOY = (self.frame.size.height - imageEyedeful.size.height)/2 - self.space/2;
    //往左便宜半个space
    CGFloat eyeBtnOX = self.frame.size.width - self.leftRightSpace - imageEyedeful.size.width - self.space/2;
    //整体按钮扩大一个space
    eyeBtn.frame = CGRectMake(eyeBtnOX, eyeBtnOY, imageEyedeful.size.width+self.space, imageEyedeful.size.height+self.space);
    
    
}
- (void)click:(UIButton*)btn{
    
    btn.selected = !btn.selected;
    if (!btn.selected) {
        self.textfiled.secureTextEntry = YES;
    }
    else{
        self.textfiled.secureTextEntry = NO;
    }
    
}

#pragma - mark textfiledDelegate
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    
    
    if ([string isEqualToString:@""]) {
        return YES;
    }
    
    if (textField.text.length >20) {
        _errorBlock();
        return NO;
    }
    
    return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField{
    if (textField.text.length<8 && textField.text.length>0) {
        _errorBlock();
    }
}

- (void)textFieldDidBeginEditing:(UITextField *)textField{
    if (textField.text.length>0) {
        //清空
        self.textfiled.text = @"";
    }
}

@end
