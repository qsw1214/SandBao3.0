//
//  PaymentBaseCellView.m
//  sandbao
//
//  Created by tianNanYiHao on 2017/10/29.
//  Copyright © 2017年 sand. All rights reserved.
//

#import "PaymentBaseCellView.h"


@implementation PaymentBaseCellView



- (instancetype)initWithFrame:(CGRect)frame{
    
    if ([super initWithFrame:frame]) {
        [self createUI];
    }
    return self;
}

- (void)createUI{
    
    self.backgroundColor = [UIColor whiteColor];
    
    //titleLab
    self.titleLab = [[UILabel alloc] init];
    self.titleLab.text = @"代付凭证号";
    self.textfield.textAlignment = NSTextAlignmentLeft;
    self.titleLab.font = [UIFont fontWithName:@"PingFangSC-Regular" size:13];
    self.titleLab.textColor = [UIColor colorWithRed:52/255.0 green:51/255.0 blue:57/255.0 alpha:1/1.0];
    [self addSubview:self.titleLab ];
    
    //textFiled
    self.textfield = [[UITextField alloc] init];
    self.textfield.placeholder = @"输入代付凭证号";
    self.textfield.font = [UIFont fontWithName:@"PingFangSC-Regular" size:13];
    self.textfield.textAlignment = NSTextAlignmentRight;
    self.textfield.textColor = [UIColor colorWithRed:52/255.0 green:51/255.0 blue:57/255.0 alpha:1/1.0];

    
    self.textfield.delegate = self;
    self.textfield.clearButtonMode = UITextFieldViewModeWhileEditing;
    self.textfield.textColor =  [UIColor colorWithRed:52/255.0 green:51/255.0 blue:57/255.0 alpha:1/0.4];
    [self addSubview:self.textfield];
    
    //line
    self.line = [[UIView alloc] init];
    self.line.backgroundColor = [UIColor colorWithRed:216/255.0 green:216/255.0 blue:216/255.0 alpha:1/1.0];
    [self addSubview:self.line];
    
    self.leftRightSpace = 35;
    self.space = 25;
    
    CGSize titleLabSize = [self.titleLab sizeThatFits:CGSizeZero];
    CGSize textfieldSize = [self.textfield sizeThatFits:CGSizeZero];
    CGFloat textfieldOX = self.leftRightSpace + titleLabSize.width;
    
    CGFloat allHeight = self.space*2 + titleLabSize.height;
    
    textfieldSize.width = [UIScreen mainScreen].bounds.size.width - textfieldOX - self.leftRightSpace;
    
    
    self.titleLab.frame = CGRectMake(self.leftRightSpace, self.space, titleLabSize.width, titleLabSize.height);
    self.textfield.frame = CGRectMake(textfieldOX, 0, textfieldSize.width, allHeight);
    self.line.frame = CGRectMake(self.space, allHeight - 1, [UIScreen mainScreen].bounds.size.width - 2*self.space, 1);

    self.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, allHeight);
    
    
    
    
    
}



@end
