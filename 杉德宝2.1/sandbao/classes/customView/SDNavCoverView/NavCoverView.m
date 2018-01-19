//
//  NavCoverView.m
//  sandbao
//
//  Created by tianNanYiHao on 2017/3/8.
//  Copyright © 2017年 sand. All rights reserved.
//

#import "NavCoverView.h"
#define AdapterFfloat(f) (([[UIScreen mainScreen] bounds].size.height==736.f)?(f):(f*0.8571))
@interface NavCoverView (){
    
    UIView *baseView;
    UILabel *labTitle;
    UIButton *leftBtn;
    UIButton *rightBtn;
    
    UIImageView *imgLeftV;
    UIImageView *imgRightV;
    UIImageView *imgRightSecV; //右边第二个图片(从右往左数)
    
    UILabel *labLeft;
    UILabel *labRight;
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
        //默认状态栏白色
        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:YES];
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
    leftSpace = 15;
    baseView = [[UIView alloc] init];
    baseView.frame = CGRectMake(0, 20, self.frame.size.width, 44);
    [self addSubview:baseView];
    
    
    // mid标题
    labTitle = [[UILabel alloc] init];
    labTitle.frame = CGRectMake(15, 20, self.frame.size.width-2*15, 64-20);
    labTitle.font = [UIFont fontWithName:@"PingFangSC-Medium" size:AdapterFfloat(17)];
    labTitle.textAlignment = NSTextAlignmentCenter;
    [baseView addSubview:labTitle];
    
    //左边按钮
    leftBtn = [[UIButton alloc] initWithFrame:CGRectZero];
    [leftBtn addTarget:self action:@selector(clickLeft:) forControlEvents:UIControlEventTouchUpInside];
    imgLeftV = [[UIImageView alloc] init];
    [leftBtn addSubview:imgLeftV];
    
    labLeft = [[UILabel alloc] initWithFrame:CGRectZero];
    labLeft.textAlignment = NSTextAlignmentLeft;
    labLeft.font = [UIFont fontWithName:@"PingFang-SC-Regular" size:AdapterFfloat(15)];
    labLeft.textColor = [UIColor colorWithRed:52/255.0 green:51/255.0 blue:57/255.0 alpha:1/1.0];
    [leftBtn addSubview:labLeft];
    [baseView addSubview:leftBtn];
    
    
    
    //右边的按钮
    rightBtn = [[UIButton alloc] initWithFrame:CGRectZero];
    [rightBtn addTarget:self action:@selector(clickRight:) forControlEvents:UIControlEventTouchUpInside];
    imgRightV = [[UIImageView alloc] init];
    [rightBtn addSubview:imgRightV];
    
    labRight = [[UILabel alloc] initWithFrame:CGRectZero];
    labRight.textAlignment = NSTextAlignmentRight;
    labRight.font =[UIFont fontWithName:@"PingFang-SC-Regular" size:AdapterFfloat(15)];
    labRight.textColor = [UIColor colorWithRed:52/255.0 green:51/255.0 blue:57/255.0 alpha:1/1.0];
    [rightBtn addSubview:labRight];
    
    [baseView addSubview:rightBtn];
    
    
   
}

/**
 追加右边第二个图标

 @param imgName 图标名字
 */
- (void)appendRightItem:(NSString*)imgName{
    //右边第二个图标
    UIImage *rightSecImg =  [UIImage imageNamed:imgName];
    imgRightSecV = [[UIImageView alloc] initWithImage:rightSecImg];
    imgRightSecV.userInteractionEnabled = YES;
    [baseView addSubview:imgRightSecV];

    //添加手势
    UITapGestureRecognizer *gesrec = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clicRightSec:)];
    [imgRightSecV addGestureRecognizer:gesrec];
    
    CGFloat imgRightSecVOX = [UIScreen mainScreen].bounds.size.width - (leftSpace + imgRightV.frame.size.width + rightSecImg.size.width);
    //frame
    imgRightSecV.frame = CGRectMake(imgRightSecVOX, rightBtn.frame.origin.y, imgRightSecV.frame.size.width, imgRightSecV.frame.size.height);
}


/**
 设置导航条样式

 @param style 样式
 */
- (void)setStyle:(NavCoverViewStyle)style{
    
    _style = style;
    
    if (_style == NavCoverStyleWhite) {
        self.backgroundColor = [UIColor whiteColor];
        //修改状态栏黑色
        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault animated:YES];
        
    }
    if (_style == NavCoverStyleGradient) {
        layerRGB.colors = @[(__bridge id)[UIColor colorWithRed:69/255.0 green:145/255.0 blue:241/255.0 alpha:1].CGColor,(__bridge id)[UIColor colorWithRed:108/255.0 green:185/255.0 blue:249/255.0 alpha:1].CGColor];
        //修改状态栏白色
        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:YES];
    }
    if (_style == NavCoverStyleClean) {
        self.backgroundColor = [UIColor clearColor];
        //修改状态栏白色
        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:YES];
    }
    
    
}

/**
 设置中间文字

 @param midTitleStr 文字
 */
- (void)setMidTitleStr:(NSString *)midTitleStr{
    
    if (midTitleStr.length == 0) {
        labTitle.frame = CGRectZero;
        return;
    }else{
        _midTitleStr = midTitleStr;
        
        labTitle.text = midTitleStr;
        
        if (_style == NavCoverStyleWhite) {
            labTitle.textColor = [UIColor colorWithRed:52/255.0 green:51/255.0 blue:57/255.0 alpha:1/1.0];
        }
        if (_style == NavCoverStyleGradient) {
            labTitle.textColor = [UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:1/1.0];
        }
        if (_style == NavCoverStyleClean) {
            labTitle.textColor = [UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:1/1.0];
        }
        
        //frame
        CGSize labTitleSize = [labTitle sizeThatFits:CGSizeZero];
        CGFloat labTitleOY = (baseView.frame.size.height - labTitleSize.height)/2;
        CGFloat labTitleOX = (baseView.frame.size.width - labTitleSize.width)/2;
        labTitle.frame = CGRectMake(labTitleOX, labTitleOY, labTitleSize.width, labTitleSize.height);
    }
}


/**
 设置左边图片名

 @param letfImgStr 字符串
 */
- (void)setLetfImgStr:(NSString *)letfImgStr{
    if (letfImgStr.length == 0 || !letfImgStr) {
        imgLeftV.frame = CGRectZero;
        leftBtn.frame = CGRectZero;
        return;
    }else{
        _letfImgStr = letfImgStr;
        
        imgLeftV.image = [UIImage imageNamed:letfImgStr];

        CGFloat imgLeftVOY = (baseView.frame.size.height - imgLeftV.image.size.height)/2;
        imgLeftV.frame = CGRectMake(leftSpace, imgLeftVOY, imgLeftV.image.size.width, imgLeftV.image.size.height);
        leftBtn.frame = CGRectMake(0, 0, self.frame.size.width/4, baseView.frame.size.height);
    }
    

}

/**
 设置左边图片

 @param leftImg img
 */
- (void)setLeftImg:(UIImage *)leftImg{
    if (!leftImg) {
        imgLeftV.frame = CGRectZero;
        leftBtn.frame = CGRectZero;
        return;
    }else{
        _leftImg = leftImg;
        
        CGSize defulImgSize = CGSizeMake(34, 34); //根据UI给出数据
        
        imgLeftV.image = _leftImg;
        
        imgLeftV.layer.cornerRadius = defulImgSize.height/2;
        imgLeftV.layer.masksToBounds = YES;
        
        CGFloat imgLeftVOY = (baseView.frame.size.height - defulImgSize.height)/2;
        imgLeftV.frame = CGRectMake(leftSpace, imgLeftVOY, defulImgSize.width, defulImgSize.height);
        leftBtn.frame = CGRectMake(0, 0, self.frame.size.width/4, baseView.frame.size.height);
    }
}

- (void)setLeftTitleStr:(NSString *)leftTitleStr{
    if (!leftTitleStr || leftTitleStr.length == 0) {
        labLeft.frame = CGRectZero;
        leftBtn.frame = CGRectZero;
        return;
    }else{
        _leftTitleStr = leftTitleStr;
        
        labLeft.text = leftTitleStr;
        
        CGSize labSize = [labLeft sizeThatFits:CGSizeZero];
        CGFloat labLeftOY = (baseView.frame.size.height - labSize.height)/2;
        labLeft.frame = CGRectMake(leftSpace, labLeftOY, labSize.width, labSize.height);
        leftBtn.frame = CGRectMake(0, 0, self.frame.size.width/4, baseView.frame.size.height);
    }
}


/**
 设置右边图标名

 @param rightImgStr 字符串
 */
- (void)setRightImgStr:(NSString *)rightImgStr{
    
    if (rightImgStr.length == 0 || !rightImgStr) {
        imgRightV.frame = CGRectZero;
        rightBtn.frame = CGRectZero;
        return;
    }else{
        _rightImgStr = rightImgStr;
        
        imgRightV.image = [UIImage imageNamed:rightImgStr];
        
        CGFloat imgRightVOY = (baseView.frame.size.height - imgRightV.image.size.height)/2;
        CGFloat imgRightVOX = (baseView.frame.size.width/4 - leftSpace - imgRightV.image.size.width);
        imgRightV.frame = CGRectMake(imgRightVOX, imgRightVOY, imgRightV.image.size.width, imgRightV.image.size.height);
        
        CGFloat rightBtnOX = baseView.frame.size.width*3/4;
        rightBtn.frame = CGRectMake(rightBtnOX, 0, self.frame.size.width/4, baseView.frame.size.height);
    }
    

}

/**
 设置右边标题

 @param rightTitleStr 标题
 */
- (void)setRightTitleStr:(NSString *)rightTitleStr{
    
    if (rightTitleStr.length == 0 || !rightTitleStr) {
        labRight.frame = CGRectZero;
        rightBtn.frame = CGRectZero;
        return;
    }else{
        _rightTitleStr = rightTitleStr;
        
        labRight.text = rightTitleStr;
        
        CGSize labSize = [labRight sizeThatFits:CGSizeZero];
        CGFloat labLeftOY = (baseView.frame.size.height - labSize.height)/2;
        CGFloat labLeftOX = (baseView.frame.size.width/4 - leftSpace - labSize.width);
        labRight.frame = CGRectMake(labLeftOX, labLeftOY, labSize.width, labSize.height);
        
        CGFloat rightBtnOX = baseView.frame.size.width*3/4;
        rightBtn.frame = CGRectMake(rightBtnOX, 0, self.frame.size.width/4, baseView.frame.size.height);
    }
    
    if (_style == NavCoverStyleWhite) {
        labRight.textColor = [UIColor blackColor];
    }
    if (_style == NavCoverStyleGradient) {
        labRight.textColor = [UIColor whiteColor];
    }
    
}


- (void)clickLeft:(UIButton*)btn{
    _leftBlock();
}
- (void)clickRight:(UIButton*)btn{
    _rightBlock();
    
}
- (void)clicRightSec:(UIButton*)btn{
    _rightSecBlock();
}


#pragma mark -导航控制器 - 返回倒数第二层视图控制器

- (void)popToPenultimateViewController:(UIViewController*)vc{
    
    NSString *currentViewControllerName = [NSString stringWithUTF8String:object_getClassName(vc)];
    
    UIViewController *penultimateVC = vc.navigationController.viewControllers[1];

    NSString *penultimateVCName = [NSString stringWithUTF8String:object_getClassName(penultimateVC)];

    if ([currentViewControllerName isEqualToString:penultimateVCName]) {
        [vc.navigationController popToRootViewControllerAnimated:YES];
    }else{
        [vc.navigationController popToViewController:penultimateVC animated:YES];
    }

}


@end
