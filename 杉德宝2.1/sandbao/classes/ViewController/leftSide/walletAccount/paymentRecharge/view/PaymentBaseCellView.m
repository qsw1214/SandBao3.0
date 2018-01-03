//
//  PaymentBaseCellView.m
//  sandbao
//
//  Created by tianNanYiHao on 2017/10/29.
//  Copyright © 2017年 sand. All rights reserved.
//

#import "PaymentBaseCellView.h"

#define AdapterFfloat(f) (([[UIScreen mainScreen] bounds].size.height==736.f)?(f):(f*0.8571))
/**
 代付凭证cell : 基础view
 */
@implementation PaymentBaseCellView

/**
 类方法实例化
 */
+(instancetype)createPaymentCellViewOY:(CGFloat)OY{
    
    PaymentBaseCellView *cell = [[PaymentBaseCellView alloc] initWithFrame:CGRectZero];
    return cell;
}

- (instancetype)initWithFrame:(CGRect)frame{
    
    if ([super initWithFrame:frame]) {
        
        self.titleStr = @"这里是标题文字";
        [self createUI];
    }
    return self;
}

- (void)createUI{
    
    self.backgroundColor = [UIColor whiteColor];
    
    //titleLab
    self.titleLab = [[UILabel alloc] init];
    self.textfield.textAlignment = NSTextAlignmentLeft;
    self.titleLab.font = [UIFont fontWithName:@"PingFangSC-Regular" size:AdapterFfloat(13)];
    self.titleLab.textColor = [UIColor colorWithRed:52/255.0 green:51/255.0 blue:57/255.0 alpha:1/1.0];
    [self addSubview:self.titleLab ];
    
    //textFiled
    self.textfield = [[UITextField alloc] init];
    self.textfield.placeholder = @"这里是输入框预设文字";
    self.textfield.font = [UIFont fontWithName:@"PingFangSC-Regular" size:AdapterFfloat(13)];
    self.textfield.textColor = [UIColor colorWithRed:52/255.0 green:51/255.0 blue:57/255.0 alpha:1/1.0];

    
    self.textfield.delegate = self;
    self.textfield.clearButtonMode = UITextFieldViewModeWhileEditing;
    self.textfield.textColor =  [UIColor colorWithRed:52/255.0 green:51/255.0 blue:57/255.0 alpha:1/0.4];
    [self addSubview:self.textfield];
    
    //line
    self.line = [[UIView alloc] init];
    self.line.backgroundColor = [UIColor colorWithRed:216/255.0 green:216/255.0 blue:216/255.0 alpha:1/1.0];
    [self addSubview:self.line];
    
    //内置红色tip
    self.tip = [[UILabel alloc] init];
    self.tip.text = @"这里是红色提示!";
    self.tip.font = [UIFont fontWithName:@"PingFang-SC-Regular" size:AdapterFfloat(13)];
    self.tip.textColor = [UIColor colorWithRed:242/255.0 green:9/255.0 blue:9/255.0 alpha:1/1.0];
    self.tip.alpha = 0.f;
    [self addSubview:self.tip];
    
    
}


- (void)setTitleStr:(NSString *)titleStr{
    
    _titleStr = titleStr;
    self.titleLab.text = _titleStr;
    
    self.leftRightSpace = 35;
    self.space = 30;
    
    CGSize titleLabSize = [self.titleLab sizeThatFits:CGSizeZero];
    CGSize textfieldSize = [self.textfield sizeThatFits:CGSizeZero];
    CGFloat tipH = [self.tip sizeThatFits:CGSizeZero].height;

    CGFloat textfieldOY = titleLabSize.height + self.space;
    CGFloat textfieldOX = self.leftRightSpace;
    CGFloat textfieldHeight = textfieldSize.height + self.space ;
    textfieldSize.width = [UIScreen mainScreen].bounds.size.width - textfieldOX - self.leftRightSpace;
    CGFloat allHeight = titleLabSize.height + textfieldHeight + self.space;
    CGFloat lineOY = allHeight - 1;
    CGFloat tipOY = allHeight;
    
    self.titleLab.frame = CGRectMake(self.leftRightSpace, self.space, titleLabSize.width, titleLabSize.height);
    self.textfield.frame = CGRectMake(textfieldOX, textfieldOY, textfieldSize.width, textfieldHeight);
    self.line.frame = CGRectMake(self.space, lineOY, [UIScreen mainScreen].bounds.size.width - 2*self.space, 1);
    self.tip.frame = CGRectMake(self.leftRightSpace, tipOY, [UIScreen mainScreen].bounds.size.width-self.leftRightSpace*2, tipH);
    allHeight = (tipH) + allHeight;
    self.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, allHeight);

}

- (void)showTip{
    
    self.tip.alpha = 1.f;
    CABasicAnimation *shakeAnimation = [CABasicAnimation animationWithKeyPath:@"transform.translation.x"];
    shakeAnimation.fromValue = @(-5);
    shakeAnimation.toValue = @(5);
    shakeAnimation.duration = 0.1f;
    shakeAnimation.autoreverses = YES;
    shakeAnimation.repeatCount = 3;
    [self.tip.layer addAnimation:shakeAnimation forKey:@"shakeAnimation"];
    
    
    [UIView animateWithDuration:2.0f delay:0.0f options:UIViewAnimationOptionCurveEaseInOut animations:^{
        self.tip.alpha = 0.f;
    } completion:^(BOOL finished) {
        
    }];
    
}


@end
