//
//  SetCellBaseView.m
//  sandbao
//
//  Created by tianNanYiHao on 2017/10/30.
//  Copyright © 2017年 sand. All rights reserved.
//

#import "SetCellBaseView.h"
#define AdapterFfloat(f) (([[UIScreen mainScreen] bounds].size.height==736.f)?(f):(f*0.8571))
@implementation SetCellBaseView

+ (instancetype)createSetCellViewOY:(CGFloat)OY{
    SetCellBaseView *cell = [[SetCellBaseView alloc] initWithFrame:CGRectZero];
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
    self.titleLab.font = [UIFont fontWithName:@"PingFangSC-Regular" size:AdapterFfloat(13)];
    self.titleLab.textColor = [UIColor colorWithRed:52/255.0 green:51/255.0 blue:57/255.0 alpha:1/1.0];
    [self addSubview:self.titleLab ];
    
    
    //rightimgeVIew
    self.rightImgView = [[UIImageView alloc] init];
    if (self.rightImgStr.length == 0 || !self.rightImgStr) {
        self.rightImgView.frame = CGRectZero;
    }else{
        UIImage *rightImg = [UIImage imageNamed:self.rightImgStr];
        self.rightImgView.image = rightImg;
    }
    [self addSubview:self.rightImgView];
    
    
    //line
    self.line = [[UIView alloc] init];
    self.line.backgroundColor = [UIColor colorWithRed:216/255.0 green:216/255.0 blue:216/255.0 alpha:1/1.0];
    [self addSubview:self.line];
    
    //coverBtn
    self.coverBtn = [[UIButton alloc] init];
    [self.coverBtn addTarget:self action:@selector(click:) forControlEvents:UIControlEventTouchUpInside];
    self.coverBtn.backgroundColor = [UIColor clearColor];
    [self addSubview:self.coverBtn];
    
}

- (void)setTitleStr:(NSString *)titleStr{
    _titleStr = titleStr;
    
    self.leftRightSpace = 40;
    self.space = 25;
    
    self.titleLab.text = _titleStr;
    
    CGSize titleLabSize = [self.titleLab sizeThatFits:CGSizeZero];
    CGFloat allHeight = self.space*2 + titleLabSize.height;
    self.titleLab.frame = CGRectMake(self.leftRightSpace, self.space, [UIScreen mainScreen].bounds.size.width-2*_leftRightSpace, titleLabSize.height);
    self.line.frame = CGRectMake(self.space, allHeight - 1, [UIScreen mainScreen].bounds.size.width - 2*self.space, 1);
    self.coverBtn.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, allHeight);
    self.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, allHeight);
    
    
}


- (void)setRightImgStr:(NSString *)rightImgStr{
    _rightImgStr = rightImgStr;
    
    CGSize imgSize = [UIImage imageNamed:_rightImgStr].size;
    
    self.rightImgView.image = [UIImage imageNamed:_rightImgStr];
    
    CGSize titleLabSize = [self.titleLab sizeThatFits:CGSizeZero];
    CGFloat allHeight = self.space*2 + titleLabSize.height;
    
    CGFloat rightImgViewOX = [UIScreen mainScreen].bounds.size.width - imgSize.width - self.leftRightSpace;
    
    CGFloat rightImgViewOY = (allHeight - imgSize.height)/2;
    
    self.rightImgView.frame = CGRectMake(rightImgViewOX, rightImgViewOY, imgSize.width, imgSize.height);
}

- (void)click:(UIButton*)btn{
    
    self.clickBlock();
    
}

@end
