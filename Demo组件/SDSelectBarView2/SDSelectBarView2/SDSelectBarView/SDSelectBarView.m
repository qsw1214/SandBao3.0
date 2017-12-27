//
//  SDSelectBarView.m
//  SDSelectBarView2
//
//  Created by tianNanYiHao on 2017/12/26.
//  Copyright © 2017年 tianNanYiHao. All rights reserved.
//

#import "SDSelectBarView.h"

#define AdapterWfloat(f) ((f/375.f)*[UIScreen mainScreen].bounds.size.width)
#define AdapterHfloat(f) ((f/667.f)*[UIScreen mainScreen].bounds.size.height)
@interface SDSelectBarView()
{
    CGRect selfSize;
    
    CGFloat blueViewH;
    CGFloat blueViewW;
    
    //视图
    UIView *blueView;
    //右渐变图层
    CAGradientLayer *rightGradientLayer;
    //左渐变图层
    CAGradientLayer *leftGradientLayer;
    
    UIButton *leftbtn;
    UIButton *rightBtn;
    
}
@end


@implementation SDSelectBarView


- (instancetype)init{
    if ([super init]) {
        blueViewH = AdapterHfloat(70);
        blueViewW = AdapterWfloat(264);
        self.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, blueViewH);
        self.backgroundColor = [UIColor clearColor];
        [self createUI];
    }
    return self;
}


- (void)createUI{
    
    blueView = [[UIView alloc] init];
    blueView.backgroundColor = [UIColor whiteColor];
    blueView.frame = CGRectMake(0, 0, blueViewW, blueViewH);
    blueView.layer.cornerRadius = blueViewH/2.f;
    blueView.layer.shadowColor = [UIColor blackColor].CGColor;
    blueView.layer.shadowOffset = CGSizeMake(0, 3.f);
    blueView.layer.shadowOpacity = 0.8f;
    blueView.center = self.center;
    [self addSubview:blueView];
    
    
    leftbtn = [[UIButton alloc] init];
    UIImage *leftImg = [UIImage imageNamed:@"fukuanma"];
    UIImage *leftImgSelect = [UIImage imageNamed:@"fukuanma_selected"];
    [leftbtn setBackgroundImage:leftImg forState:UIControlStateNormal];
    [leftbtn setBackgroundImage:leftImgSelect forState:UIControlStateSelected];
    leftbtn.tag = 1;
    leftbtn.selected = NO;
    [leftbtn addTarget:self action:@selector(click:) forControlEvents:UIControlEventTouchUpInside];
    [blueView addSubview:leftbtn];
    
    rightBtn = [[UIButton alloc] init];
    UIImage *rightImg = [UIImage imageNamed:@"shoukuanma"];
    UIImage *rightImgSelect = [UIImage imageNamed:@"shoukuanma_selected"];
    [rightBtn setBackgroundImage:rightImg forState:UIControlStateNormal];
    [rightBtn setBackgroundImage:rightImgSelect forState:UIControlStateSelected];
    rightBtn.tag = 2;
    rightBtn.selected = YES;
    [rightBtn addTarget:self action:@selector(click:) forControlEvents:UIControlEventTouchUpInside];
    [blueView addSubview:rightBtn];
    
    CGFloat leftBtnOX = (blueViewW - AdapterWfloat(53) - (leftImg.size.width+rightImg.size.width))/2.f;
    CGFloat leftBtnOY = (blueViewH - leftImg.size.height)/2.f;
    CGFloat rightBtnOX = leftBtnOX + leftImg.size.width + AdapterWfloat(53);
    
    leftbtn.frame = CGRectMake(leftBtnOX, leftBtnOY, leftImg.size.width, leftImg.size.height);
    rightBtn.frame = CGRectMake(rightBtnOX, leftBtnOY, rightImg.size.width, rightImg.size.height);
    
    
    //默认创建左边按钮选中装填layer
    [self createLeftGradientlayer];
}

- (void)click:(UIButton*)btn{
    
    //点击左边按钮
    if (btn.tag == 1) {
        leftbtn.selected = YES;
        rightBtn.selected = NO;
        rightBtn.userInteractionEnabled = YES;
        leftbtn.userInteractionEnabled = NO;
        if (leftGradientLayer) {
            [leftGradientLayer removeFromSuperlayer];
        }
         [self createLeftGradientlayer];
        if ([_delegate respondsToSelector:@selector(selectBarClick:)]) {
            [_delegate selectBarClick:1];
        }
        
    }
    
    //点击右边按钮
    if (btn.tag == 2) {
        leftbtn.selected = NO;
        rightBtn.selected = YES;
        rightBtn.userInteractionEnabled = NO;
        leftbtn.userInteractionEnabled = YES;
        if (rightGradientLayer) {
            [rightGradientLayer removeFromSuperlayer];
        }
        [self createRightGradientLayer];
        if ([_delegate respondsToSelector:@selector(selectBarClick:)]) {
            [_delegate selectBarClick:2];
        }
    }
    
}


- (void)createRightGradientLayer{
    rightGradientLayer = [CAGradientLayer layer];
    rightGradientLayer.cornerRadius = blueViewH/2;
    rightGradientLayer.frame = CGRectMake(0, 0, blueViewW, blueViewH);
    rightGradientLayer.colors = @[
                                  (__bridge id)[UIColor colorWithRed:108/255.f green:185/255.f blue:249/255.f alpha:1.f].CGColor,
                                  (__bridge id)[UIColor colorWithRed:69/255.f green:145/255.f blue:241/255.f alpha:1.f].CGColor
                                  ];
    rightGradientLayer.startPoint = CGPointMake(1, 0.5f);
    rightGradientLayer.endPoint = CGPointMake(0.f, 0.5f);
    [blueView.layer insertSublayer:rightGradientLayer atIndex:0];
}

- (void)createLeftGradientlayer{
    leftGradientLayer = [CAGradientLayer layer];
    leftGradientLayer.cornerRadius = blueViewH/2;
    leftGradientLayer.frame = CGRectMake(0, 0, blueViewW, blueViewH);
    leftGradientLayer.colors = @[
                                  (__bridge id)[UIColor colorWithRed:108/255.f green:185/255.f blue:249/255.f alpha:1.f].CGColor,
                                  (__bridge id)[UIColor colorWithRed:69/255.f green:145/255.f blue:241/255.f alpha:1.f].CGColor
                                  ];
    leftGradientLayer.startPoint = CGPointMake(0.f, 0.5f);
    leftGradientLayer.endPoint = CGPointMake(1.f, 0.5f);
    [blueView.layer insertSublayer:leftGradientLayer atIndex:0];
}

@end
