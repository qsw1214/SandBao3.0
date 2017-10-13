//
//  SixCodeAuthToolView.m
//  AuthToolsDemo2.0
//
//  Created by tianNanYiHao on 2017/10/13.
//  Copyright © 2017年 tianNanYiHao. All rights reserved.
//

#import "SixCodeAuthToolView.h"

@interface SixCodeAuthToolView ()<UITextFieldDelegate>{
    
    NSInteger codeLabCount;
    
}
@property (nonatomic, strong) NSMutableArray *codeLabArr; //保存codeLab的数组
@end

@implementation SixCodeAuthToolView



- (instancetype)initWithFrame:(CGRect)frame{
    
    if ([super initWithFrame:frame]) {
        
        self.style = SmsCodeAuthTool;
        
        self.textfiled.placeholder = @"";
        self.textfiled.clearButtonMode = UITextFieldViewModeNever;
        self.textfiled.delegate = self;
        self.textfiled.backgroundColor = [UIColor clearColor];
        self.textfiled.textColor = [UIColor clearColor];
        self.textfiled.tintColor = [UIColor clearColor];
        self.textfiled.autocapitalizationType = UITextAutocapitalizationTypeNone;
        self.textfiled.keyboardType = UIKeyboardTypeNumberPad;
        [self.textfiled addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
        
        self.lineV.hidden = YES;
        
        
    }return self;
    
}

- (void)setStyle:(CodeAuthToolStyle)style{
    
    _style = style;
    
    if (_style == SmsCodeAuthTool) {
        self.titleLab.text = @"验证码";
        [self addUI];
    }
    if (_style == PayCodeAuthTool) {
        self.titleLab.text = @"";
        [self addUI];
    }

}

- (void)addUI{
    
    //参数预设
    codeLabCount = 6;
    
    CGFloat space = 10;
    CGFloat spaceAll = (codeLabCount-1) * space;
    
    CGFloat sixCodeLabAllWidth = self.textfiled.frame.size.width - spaceAll;
    CGFloat sixCodeLabHeight   = self.textfiled.frame.size.height;
    
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
        
        //保存codeStr
        if (textfiled.text.length == 6) {
            _codeStrBlock(textfiled.text);
        }
        
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
