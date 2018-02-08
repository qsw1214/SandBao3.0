//
//  IdentityAuthToolView.m
//  AuthToolsDemo2.0
//
//  Created by tianNanYiHao on 2017/10/12.
//  Copyright © 2017年 tianNanYiHao. All rights reserved.
//

#import "IdentityAuthToolView.h"

@implementation IdentityAuthToolView

/**
 创建对象
 
 @param OY Y坐标
 @return 实例
 */
+ (instancetype)createAuthToolViewOY:(CGFloat)OY{
    
    IdentityAuthToolView *view = [[IdentityAuthToolView alloc] initWithFrame:CGRectMake(0, OY, 0, 0)];
    return view;
    
}

- (instancetype)initWithFrame:(CGRect)frame{
    
    if ([super initWithFrame:frame]) {
        self.titleLab.text = @"证件号码";
        self.textfiled.placeholder = @"输入证件号码";
        self.textfiled.delegate = self;
        
    }return self;
    
}


#define IDCardVerifi @"0987654321Xx"
#pragma - mark textfiledDelegate
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    
    //禁止输入空格且警告
    if ([string isEqualToString:@" "]) {
        [self showTip];
        return NO;
    }
    //超过18长度不能再输入且警告提示
    if (textField.text.length >=18 && ![string isEqualToString:@""]) {
        [self showTip];
        return NO;
    }
    ////限制身份证键盘输入
    if (![self restrictionwithTypeStr:IDCardVerifi string:string]) {
        [self showTip];
        return NO;
    }
    
    //实时获取输入的框内的text,校验后返回
    NSString *currentText = [textField.text stringByReplacingCharactersInRange:range withString:string];
    if (currentText.length >= 15 && currentText.length <= 18) {
        if ([self validateIdentityCard:currentText] && currentText.length > 0) {
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
    
    if (((![self validateIdentityCard:textField.text]) || !(textField.text.length>=15 && textField.text.length<=18)) && (textField.text.length>0)) {
        [self deleteErrorTextAnimation:textField];
        [self showTip];
    }else if([self validateIdentityCard:textField.text] && textField.text>0){
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

/**
 *@brief 身份证号
 *@param identityCard 字符串 参数：身份证号
 *@return 返回BOOL
 */
- (BOOL)validateIdentityCard:(NSString *)identityCard {
    identityCard = [identityCard stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    NSInteger length =0;
    if (!identityCard) {
        return NO;
    }else {
        length = identityCard.length;
        
        if (length !=15 && length !=18) {
            return NO;
        }
    }
    // 省份代码
    NSArray *areasArray =@[@"11",@"12", @"13",@"14", @"15",@"21", @"22",@"23", @"31",@"32", @"33",@"34", @"35",@"36", @"37",@"41", @"42",@"43", @"44",@"45", @"46",@"50", @"51",@"52", @"53",@"54", @"61",@"62", @"63",@"64", @"65",@"71", @"81",@"82", @"91"];
    
    NSString *valueStart2 = [identityCard substringToIndex:2];
    BOOL areaFlag =NO;
    for (NSString *areaCode in areasArray) {
        if ([areaCode isEqualToString:valueStart2]) {
            areaFlag =YES;
            break;
        }
    }
    
    if (!areaFlag) {
        return NO;
    }
    
    
    NSRegularExpression *regularExpression;
    NSUInteger numberofMatch;
    
    int year =0;
    switch (length) {
        case 15:
            year = [identityCard substringWithRange:NSMakeRange(6,2)].intValue +1900;
            
            if (year %4 ==0 || (year %100 ==0 && year %4 ==0)) {
                
                regularExpression = [[NSRegularExpression alloc]initWithPattern:@"^[1-9][0-9]{5}[0-9]{2}((01|03|05|07|08|10|12)(0[1-9]|[1-2][0-9]|3[0-1])|(04|06|09|11)(0[1-9]|[1-2][0-9]|30)|02(0[1-9]|[1-2][0-9]))[0-9]{3}$"
                                                                        options:NSRegularExpressionCaseInsensitive
                                                                          error:nil];//测试出生日期的合法性
            }else {
                regularExpression = [[NSRegularExpression alloc]initWithPattern:@"^[1-9][0-9]{5}[0-9]{2}((01|03|05|07|08|10|12)(0[1-9]|[1-2][0-9]|3[0-1])|(04|06|09|11)(0[1-9]|[1-2][0-9]|30)|02(0[1-9]|1[0-9]|2[0-8]))[0-9]{3}$"
                                                                        options:NSRegularExpressionCaseInsensitive
                                                                          error:nil];//测试出生日期的合法性
            }
            numberofMatch = [regularExpression numberOfMatchesInString:identityCard
                                                               options:NSMatchingReportProgress
                                                                 range:NSMakeRange(0, identityCard.length)];
            
            if(numberofMatch >0) {
                return YES;
            }else {
                return NO;
            }
        case 18:
            
            year = [identityCard substringWithRange:NSMakeRange(6,4)].intValue;
            if (year %4 ==0 || (year %100 ==0 && year %4 ==0)) {
                
                regularExpression = [[NSRegularExpression alloc]initWithPattern:@"^[1-9][0-9]{5}19[0-9]{2}((01|03|05|07|08|10|12)(0[1-9]|[1-2][0-9]|3[0-1])|(04|06|09|11)(0[1-9]|[1-2][0-9]|30)|02(0[1-9]|[1-2][0-9]))[0-9]{3}[0-9Xx]$"
                                                                        options:NSRegularExpressionCaseInsensitive
                                                                          error:nil];//测试出生日期的合法性
            }else {
                regularExpression = [[NSRegularExpression alloc]initWithPattern:@"^[1-9][0-9]{5}19[0-9]{2}((01|03|05|07|08|10|12)(0[1-9]|[1-2][0-9]|3[0-1])|(04|06|09|11)(0[1-9]|[1-2][0-9]|30)|02(0[1-9]|1[0-9]|2[0-8]))[0-9]{3}[0-9Xx]$"
                                                                        options:NSRegularExpressionCaseInsensitive
                                                                          error:nil];//测试出生日期的合法性
            }
            numberofMatch = [regularExpression numberOfMatchesInString:identityCard
                                                               options:NSMatchingReportProgress
                                                                 range:NSMakeRange(0, identityCard.length)];
            
            if(numberofMatch >0) {
                int S = ([identityCard substringWithRange:NSMakeRange(0,1)].intValue + [identityCard substringWithRange:NSMakeRange(10,1)].intValue) *7 + ([identityCard substringWithRange:NSMakeRange(1,1)].intValue + [identityCard substringWithRange:NSMakeRange(11,1)].intValue) *9 + ([identityCard substringWithRange:NSMakeRange(2,1)].intValue + [identityCard substringWithRange:NSMakeRange(12,1)].intValue) *10 + ([identityCard substringWithRange:NSMakeRange(3,1)].intValue + [identityCard substringWithRange:NSMakeRange(13,1)].intValue) *5 + ([identityCard substringWithRange:NSMakeRange(4,1)].intValue + [identityCard substringWithRange:NSMakeRange(14,1)].intValue) *8 + ([identityCard substringWithRange:NSMakeRange(5,1)].intValue + [identityCard substringWithRange:NSMakeRange(15,1)].intValue) *4 + ([identityCard substringWithRange:NSMakeRange(6,1)].intValue + [identityCard substringWithRange:NSMakeRange(16,1)].intValue) *2 + [identityCard substringWithRange:NSMakeRange(7,1)].intValue *1 + [identityCard substringWithRange:NSMakeRange(8,1)].intValue *6 + [identityCard substringWithRange:NSMakeRange(9,1)].intValue *3;
                int Y = S %11;
                NSString *M =@"F";
                NSString *JYM =@"10X98765432";
                M = [JYM substringWithRange:NSMakeRange(Y,1)];// 判断校验位
                if ([M isEqualToString:[identityCard substringWithRange:NSMakeRange(17,1)]]) {
                    return YES;// 检测ID的校验位
                }else {
                    return NO;
                }
                
            }else {
                return NO;
            }
        default:
            return NO;
    }
}

@end
