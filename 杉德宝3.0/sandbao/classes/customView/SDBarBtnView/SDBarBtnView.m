//
//  SDBarBtnView.m
//  sandbao
//
//  Created by tianNanYiHao on 2017/10/16.
//  Copyright © 2017年 sand. All rights reserved.
//

#import "SDBarBtnView.h"

@interface SDBarBtnView (){
    
}

@end

@implementation SDBarBtnView
@synthesize midLab;


- (instancetype)init{
    if ([super init]) {
        [self bulidBarBtnView];
    }return self;
}


- (void)bulidBarBtnView{
    
    //midLab
    midLab = [[UILabel alloc] init];
    [self addSubview:midLab];
}

- (void)setBtnSzie:(CGSize)btnSzie{
    _btnSzie = btnSzie;
    CGSize midLabSize = [midLab sizeThatFits:CGSizeZero];
    
    CGFloat spaceLeftRight = (btnSzie.width - midLabSize.width)/2;
    CGFloat spaceUpDown    = (btnSzie.height - midLabSize.height)/2;
    
    midLab.frame = CGRectMake(spaceLeftRight, spaceUpDown, midLabSize.width, midLabSize.height);

}


- (void)setTitle:(NSString *)title{
    _title = title;
    midLab.text = _title;
    midLab.textAlignment = NSTextAlignmentCenter;
    
}

- (void)setTitleColor:(UIColor *)titleColor{
    _titleColor = titleColor;
    midLab.textColor = _titleColor;
    
}

- (void)setBtnColor:(UIColor *)btnColor{
    _btnColor = btnColor;
    [self setBackgroundColor:_btnColor];
}


@end
