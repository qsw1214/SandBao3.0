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
    UIImageView *imgLeftV;
    UIImageView *imgRightV;
    CGFloat leftSpace;
    //渐变色
    CAGradientLayer *layerRGB;
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
        [self createUI];
    }return self;
    
}

- (void)createUI{
    
    //创建并添加渐变layer
    layerRGB = [CAGradientLayer layer];
    layerRGB.frame = self.frame;
    layerRGB.startPoint = CGPointMake(0, 0);
    layerRGB.endPoint = CGPointMake(1, 0);
    [self.layer addSublayer:layerRGB];
    
    
    //创建并添加baseView
    leftSpace = 25;
    baseView = [[UIView alloc] init];
    baseView.frame = CGRectMake(0, 20, self.frame.size.width, 44);
    [self addSubview:baseView];
    
    
    // mid标题
    labTitle = [[UILabel alloc] init];
    labTitle.frame = CGRectMake(15, 20, self.frame.size.width-2*15, 64-20);
    labTitle.text = @"测试测试测试";
    labTitle.font = [UIFont fontWithName:@"PingFang-SC-Regular" size:15];
    labTitle.textAlignment = NSTextAlignmentCenter;
    [baseView addSubview:labTitle];
    
    //左边按钮
    leftBtn = [[UIButton alloc] init];
    [leftBtn addTarget:self action:@selector(clickLeft:) forControlEvents:UIControlEventTouchUpInside];
    UIImage *imgleft = [UIImage imageNamed:@""];
    imgLeftV = [[UIImageView alloc] initWithImage:imgleft];
    [baseView addSubview:leftBtn];
    [leftBtn addSubview:imgLeftV];
    
    
    //右边的按钮
    rightBtn = [[UIButton alloc] init];
    [rightBtn addTarget:self action:@selector(clickRight:) forControlEvents:UIControlEventTouchUpInside];
    UIImage *imgRight = [UIImage imageNamed:@""];
    imgRightV = [[UIImageView alloc] initWithImage:imgRight];
    [baseView addSubview:rightBtn];
    [rightBtn addSubview:imgRightV];
    
   
}

- (void)setStyle:(NavCoverViewStyle)style{
    
    _style = style;
    
    if (_style == NavCoverStyleWhite) {
        self.backgroundColor = [UIColor whiteColor];
        
    }
    if (_style == NavCoverStyleGradient) {
        layerRGB.colors = @[(__bridge id)[UIColor colorWithRed:69/255.0 green:145/255.0 blue:241/255.0 alpha:1].CGColor,(__bridge id)[UIColor colorWithRed:108/255.0 green:185/255.0 blue:249/255.0 alpha:1].CGColor];
        
    }
    
    
}

- (void)setMidTitleStr:(NSString *)midTitleStr{
    
    _midTitleStr = midTitleStr;
    
    labTitle.text = midTitleStr;
    
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
    
    _letfImgStr = letfImgStr;
    
    imgLeftV.image = [UIImage imageNamed:letfImgStr];
   
    CGFloat imgLeftVOY = (baseView.frame.size.height - imgLeftV.image.size.height)/2;
    imgLeftV.frame = CGRectMake(leftSpace, imgLeftVOY, imgLeftV.image.size.width, imgLeftV.image.size.height);
    leftBtn.frame = CGRectMake(0, 0, self.frame.size.width/4, baseView.frame.size.height);

}

- (void)setRightImgStr:(NSString *)rightImgStr{
    
    _rightImgStr = rightImgStr;
    
    imgRightV.image = [UIImage imageNamed:rightImgStr];
    
    CGFloat imgRightVOY = (baseView.frame.size.height - imgRightV.image.size.height)/2;
    CGFloat imgRightVOX = (baseView.frame.size.width/4 - leftSpace - imgRightV.image.size.width);
    imgRightV.frame = CGRectMake(imgRightVOX, imgRightVOY, imgRightV.image.size.width, imgRightV.image.size.height);
    
    CGFloat rightBtnOX = baseView.frame.size.width*3/4;
    rightBtn.frame = CGRectMake(rightBtnOX, 0, self.frame.size.width/4, baseView.frame.size.height);

}

- (void)clickLeft:(UIButton*)btn{
    _leftBlock();
}
- (void)clickRight:(UIButton*)btn{
    _rightBlock();
    
}







@end
