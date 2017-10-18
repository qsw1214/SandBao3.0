//
//  NavCoverView.m
//  sandbao
//
//  Created by tianNanYiHao on 2017/3/8.
//  Copyright © 2017年 sand. All rights reserved.
//

#import "NavCoverView.h"

@interface NavCoverView (){
    
    UIView *baseView;
    UILabel *labTitle;
    UIButton *leftBtn;
    UIButton *rightBtn;
    CGFloat leftSpace;
}

@end

@implementation NavCoverView

+ (NavCoverView*)createNavCorverView{
    NavCoverView *nav = [[NavCoverView alloc] init];
    return nav;
}


- (instancetype)init{
    
    if ([super init]) {
        self.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 64);
        self.backgroundColor = [UIColor whiteColor];
    }return self;
    
}

- (void)setStyle:(NavCoverViewStyle)style{
    _style = style;
    [self setBackgroundStyle];
    
    //创建baseView
    leftSpace = 25;
    baseView = [[UIView alloc] init];
    baseView.frame = CGRectMake(0, 20, self.frame.size.width, 44);
    [self addSubview:baseView];
}




- (void)setMidTitleStr:(NSString *)midTitleStr{
    
    // 标题
    labTitle = [[UILabel alloc] init];
    labTitle.frame = CGRectMake(15, 20, self.frame.size.width-2*15, 64-20);
    labTitle.text = midTitleStr;
    labTitle.font = [UIFont fontWithName:@"PingFang-SC-Regular" size:15];
    labTitle.textAlignment = NSTextAlignmentCenter;
    
    [baseView addSubview:labTitle];
    
    if (_style == NavCoverStyleWhite) {
        labTitle.textColor = [UIColor colorWithRed:52/255.0 green:51/255.0 blue:57/255.0 alpha:1/1.0];
    }
    if (_style == NavCoverStyleGradient) {
        labTitle.textColor = [UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:1/1.0];
    }
    //frame
    CGSize labTitleSize = [labTitle sizeThatFits:CGSizeZero];
    CGFloat labTitleOY = (baseView.frame.size.height - labTitleSize.height)/2;
    CGFloat labTitleOX = (baseView.frame.size.width - labTitleSize.width)/2;
    labTitle.frame = CGRectMake(labTitleOX, labTitleOY, labTitleSize.width, labTitleSize.height);
    
}

- (void)setLetfImgStr:(NSString *)letfImgStr{
    
    leftBtn = [[UIButton alloc] init];
    [leftBtn addTarget:self action:@selector(clickLeft:) forControlEvents:UIControlEventTouchUpInside];
    UIImage *img = [UIImage imageNamed:letfImgStr];
    UIImageView *imgV = [[UIImageView alloc] initWithImage:img];
    [baseView addSubview:leftBtn];
    [leftBtn addSubview:imgV];
    
    CGFloat imgVOY = (baseView.frame.size.height - img.size.height)/2;
    imgV.frame = CGRectMake(leftSpace, imgVOY, img.size.width, img.size.height);
    leftBtn.frame = CGRectMake(0, 0, self.frame.size.width/4, baseView.frame.size.height);
}

- (void)setRightImgStr:(NSString *)rightImgStr{
    rightBtn = [[UIButton alloc] init];
    [rightBtn addTarget:self action:@selector(clickRight:) forControlEvents:UIControlEventTouchUpInside];
    UIImage *img = [UIImage imageNamed:rightImgStr];
    UIImageView *imgV = [[UIImageView alloc] initWithImage:img];
    [baseView addSubview:rightBtn];
    [rightBtn addSubview:imgV];
    
    CGFloat imgVOY = (baseView.frame.size.height - img.size.height)/2;
    CGFloat imgVOX = (baseView.frame.size.width/4 - leftSpace - img.size.width);
    imgV.frame = CGRectMake(imgVOX, imgVOY, img.size.width, img.size.height);
    
    CGFloat rightBtnOX = baseView.frame.size.width*3/4;
    rightBtn.frame = CGRectMake(rightBtnOX, 0, self.frame.size.width/4, baseView.frame.size.height);
    
    
}


/**
 根据style-设置背景样式
 */
- (void)setBackgroundStyle{
    
    if (_style == NavCoverStyleWhite) {
        self.backgroundColor = [UIColor whiteColor];
        
    }
    
    if (_style == NavCoverStyleGradient) {
        //渐变色
        CAGradientLayer *layerRGB = [CAGradientLayer layer];
        layerRGB.frame = self.frame;
        layerRGB.startPoint = CGPointMake(0, 0);
        layerRGB.endPoint = CGPointMake(1, 0);
        layerRGB.colors = @[(__bridge id)[UIColor colorWithRed:69/255.0 green:145/255.0 blue:241/255.0 alpha:1].CGColor,(__bridge id)[UIColor colorWithRed:108/255.0 green:185/255.0 blue:249/255.0 alpha:1].CGColor];
        [self.layer addSublayer:layerRGB];

    }
    
}


- (void)clickLeft:(UIButton*)btn{
    _leftBlock();
}
- (void)clickRight:(UIButton*)btn{
    _rightBlock();
    
}







@end
