//
//  AddBankCardCell.m
//  sandbao
//
//  Created by tianNanYiHao on 2017/11/6.
//  Copyright © 2017年 sand. All rights reserved.
//

#import "AddBankCardCell.h"

@implementation AddBankCardCell


+(instancetype)createSetCellViewOY:(CGFloat)OY{
    
    AddBankCardCell *cell = [[AddBankCardCell alloc] initWithFrame:CGRectMake(0, OY, 0, 0)];;
    
    return cell;
}


- (instancetype)initWithFrame:(CGRect)frame{
    
    if ([super initWithFrame:frame]) {
        self.backgroundColor = [UIColor whiteColor];
        self.titleStr = @"这里是标题";
        
        self.titleLab.font =  [UIFont fontWithName:@"PingFangSC-Medium" size:14];
        self.titleLab.textColor =  [UIColor colorWithRed:52/255.0 green:51/255.0 blue:57/255.0 alpha:1/1.0];
        
        self.rightLab = [[UILabel alloc] init];
        self.rightLab.textColor =  [UIColor colorWithRed:52/255.0 green:51/255.0 blue:57/255.0 alpha:0.7f];
        self.rightLab.textAlignment = NSTextAlignmentRight;
        self.rightLab.font =  [UIFont fontWithName:@"PingFangSC-Medium" size:14];
        
        [self addSubview:self.rightLab];
        
        
        //由于不需要点击事件, 因此删除透明覆盖按钮
        [self.coverBtn removeFromSuperview];
        
    }
    return self;
    
}


- (void)setRightStr:(NSString *)rightStr{
    
    _rightStr = rightStr;
    
    self.rightLab.text = _rightStr;
    CGSize sizeRightLab = [self.rightLab sizeThatFits:CGSizeZero];
    
    
    CGFloat rightOY = (self.frame.size.height - sizeRightLab.height)/2;
    
    CGFloat rightLabW = [UIScreen mainScreen].bounds.size.width - 2*self.leftRightSpace;
    
    self.rightLab.frame = CGRectMake(self.leftRightSpace, rightOY, rightLabW, sizeRightLab.height);
    
    
    //重置Line属性
    CGRect lineFrame = self.line.frame;
    lineFrame = CGRectMake(self.leftRightSpace, self.frame.size.height - 0.5f, [UIScreen mainScreen].bounds.size.width-2*self.leftRightSpace, 0.5f);
    self.line.frame = lineFrame;
    
    self.line.backgroundColor =  [UIColor colorWithRed:216/255.0 green:216/255.0 blue:216/255.0 alpha:1/1.0];

    
}
@end
