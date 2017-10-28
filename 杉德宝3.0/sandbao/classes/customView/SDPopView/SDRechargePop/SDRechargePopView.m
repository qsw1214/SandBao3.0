//
//  SDRechargePopView.m
//  sandbao
//
//  Created by tianNanYiHao on 2017/10/27.
//  Copyright © 2017年 sand. All rights reserved.
//

#import "SDRechargePopView.h"


#define popWidth ([UIScreen mainScreen].bounds.size.width - 50*2)

#define closeBtnRightMargin 20

#define space 10
#define chooseBtnLeftRightSpace 50
#define chooseBtnAllUpSpace  60


@interface SDRechargePopView ()
{
    
}

/**
 透明背景view
 */
@property (nonatomic, strong) UIView *backGroundView;
/**
 遮罩view
 */
@property (nonatomic, strong) UIView *maskBlackView;

/**
 标题
 */
@property (nonatomic, strong) UILabel *titleLab;


/**
 关闭按钮
 */
@property (nonatomic, strong) UIButton *closeBtn;



/**
 标题文字
 */
@property (nonatomic, strong) NSString *titleStr;


/**
 list数组
 */
@property (nonatomic, strong) NSArray  *listArray;
@end


@implementation SDRechargePopView



+ (void)showRechargePopView:(NSString*)title chooseList:(NSArray*)listArray rechargeChooseBlock:(SDRechargePopChooseBlock)block{

    SDRechargePopView *pop = [[SDRechargePopView alloc] initWithFrame:CGRectMake(0, 0, popWidth, 0)];
    
    pop.chooseBlock = block;
    
    pop.alpha = 0.f;
    
    pop.layer.cornerRadius = 5.f;
    
    pop.center = CGPointMake([UIScreen mainScreen].bounds.size.width/2, [UIScreen mainScreen].bounds.size.height/2);
    
    pop.backgroundColor = [UIColor whiteColor];
    
    pop.titleStr = title;
    
    pop.listArray = listArray;
    
    [pop show];
    
}

- (void)showAnimation:(BOOL)isShow{
    
    if (isShow) {
        [UIView animateWithDuration:0.35 animations:^{
            self.maskBlackView.alpha = 0.4f;
            self.alpha = 1.f;
        } completion:^(BOOL finished) {
            
        }];
    }
    if (!isShow) {
        [UIView animateWithDuration:0.35f animations:^{
            self.maskBlackView.alpha = 0.f;
            self.alpha = 0.f;
        } completion:^(BOOL finished) {
            [self.backGroundView removeFromSuperview];
            [self.maskBlackView removeFromSuperview];
            [self removeFromSuperview];
            
        }];
    }
    
    
}


- (void)show{
    
    UIWindow *window = [UIApplication sharedApplication].windows.firstObject;
    [window addSubview:self.backGroundView];
    [self showAnimation:YES];

}

- (void)hidden{
    
     [self showAnimation:NO];
    
}

#pragma mark - lazyLoad

-(UIView*)backGroundView{
    
    if (!_backGroundView) {
        _backGroundView = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
        _backGroundView.backgroundColor = [UIColor clearColor];
        
        //背景View 添加 遮罩
        [_backGroundView addSubview:self.maskBlackView];
        //背景View 添加 popView
        [_backGroundView addSubview:self];
        
        //pop 添加 关闭按钮
        [self addSubview:self.closeBtn];
        //pop 添加 标题
        [self addSubview:self.titleLab];
        
        
        UIImage *imgNol = [UIImage imageNamed:@"SDRechargePop_nol"];
        CGFloat chooseBtnH = space *2 + imgNol.size.height;
        CGFloat chooseBtnW = self.frame.size.width - chooseBtnLeftRightSpace*2;
        CGFloat allchooseBtnH = chooseBtnH * (self.listArray.count);
        CGFloat allchooseBtnSpaceH = allchooseBtnH + space*(self.listArray.count -1);
        CGFloat chooseBtnFirstOY = chooseBtnAllUpSpace;
        for (int i = 0; i<self.listArray.count; i++) {
            
            UIButton *chooseBtn =  [self addChooseBtn:i];
            //pop 添加 选择按钮
            [self addSubview:chooseBtn];
            chooseBtn.frame = CGRectMake(chooseBtnLeftRightSpace, chooseBtnFirstOY+(chooseBtnH+space)*i, chooseBtnW, chooseBtnH);
           
        }
        
        //充值self.height
        
        CGRect tempFrame = self.frame;
        tempFrame.size.height = allchooseBtnSpaceH + 2*chooseBtnAllUpSpace;
        self.frame = tempFrame;
        self.center = CGPointMake([UIScreen mainScreen].bounds.size.width/2, [UIScreen mainScreen].bounds.size.height/2);
        
    }
    return _backGroundView;
    
}

-(UIView*)maskBlackView{
    if (!_maskBlackView) {
        _maskBlackView = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
        _maskBlackView.backgroundColor = [UIColor blackColor];
        _maskBlackView.alpha = 0.f;
        UITapGestureRecognizer *tapGest = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hidden)];
        [_maskBlackView addGestureRecognizer:tapGest];
        
    }
    return _maskBlackView;
}

-(UIButton*)closeBtn{
    if (!_closeBtn) {
        _closeBtn = [[UIButton alloc] init];
        [_closeBtn addTarget:self action:@selector(hidden) forControlEvents:UIControlEventTouchUpInside];
        UIImage *closeImg = [UIImage imageNamed:@"login_list_icon_closed"];
        [_closeBtn setImage:closeImg forState:UIControlStateNormal];
        CGFloat closeBtnW = closeBtnRightMargin*2 + closeImg.size.width;
        CGFloat closeBtnH = closeBtnRightMargin*2 + closeImg.size.height;
        CGFloat closeBtnOY = 0;
        CGFloat closeBtnOX = popWidth - closeBtnW;
        _closeBtn.frame = CGRectMake(closeBtnOX, closeBtnOY, closeBtnW, closeBtnH);
    }
    return _closeBtn;
    
}
- (UILabel*)titleLab{
    
    if (!_titleLab) {
        _titleLab = [[UILabel alloc] init];
        _titleLab.font = [UIFont fontWithName:@"PingFang-SC-Regular" size:14];
        _titleLab.textColor = [UIColor colorWithRed:52/255.0 green:51/255.0 blue:57/255.0 alpha:1/1.0];
        _titleLab.textAlignment = NSTextAlignmentCenter;
        _titleLab.text = self.titleStr;
        CGSize titleLabSize = [_titleLab sizeThatFits:CGSizeZero];
        _titleLab.frame = CGRectMake(0, 30, self.frame.size.width, titleLabSize.height);
        
    }return _titleLab;
    
}


- (UIButton*)addChooseBtn:(NSInteger)index{
    

    UIButton *chooseBtn = [[UIButton alloc] init];
    chooseBtn.tag = 100 + index;
    [chooseBtn addTarget:self action:@selector(chooseClick:) forControlEvents:UIControlEventTouchUpInside];
    //imge
    UIImage *imgNol = [UIImage imageNamed:@"SDRechargePop_nol"];
    UIImage *imgSel = [UIImage imageNamed:@"SDRechargePop_sel"];
    UIImageView *chooseBtnImgeView = [[UIImageView alloc] init];
    chooseBtnImgeView.image = imgNol;
    [chooseBtn addSubview:chooseBtnImgeView];
    
    
    //lable
    UILabel *chooseLab = [[UILabel alloc] init];
    chooseLab.font = [UIFont fontWithName:@"PingFang-SC-Regular" size:10];
    chooseLab.text = self.listArray[index];
    chooseLab.textColor = [UIColor colorWithRed:52/255.0 green:51/255.0 blue:57/255.0 alpha:1/1.0];
    [chooseBtn addSubview:chooseLab];
    
    CGFloat rightSpace = 17.f;
    CGFloat chooseBtnH = space *2 + imgNol.size.height;
    CGSize chooseLabSize = [chooseLab sizeThatFits:CGSizeZero];
    CGFloat chooseLabOX = space + imgNol.size.width + rightSpace;
    CGFloat chooseLabOY = (chooseBtnH - chooseLabSize.height)/2;
    
    chooseBtnImgeView.frame = CGRectMake(space, space, imgNol.size.width, imgNol.size.height);
    chooseLab.frame = CGRectMake(chooseLabOX, chooseLabOY, chooseLabSize.width, chooseLabSize.height);
    
    chooseBtn.layer.cornerRadius = chooseBtnH/2;
    chooseBtn.layer.masksToBounds = YES;
    chooseBtn.layer.borderColor = [UIColor colorWithRed:237/255.0 green:237/255.0 blue:237/255.0 alpha:1/1.0].CGColor;
    chooseBtn.layer.borderWidth = 1.f;

    
    return chooseBtn;
}

- (void)chooseClick:(UIButton*)btn{
    
    NSInteger index = btn.tag - 100;
    NSString *str = self.listArray[index];
    [self hidden];
    
    //延迟0.35 等待动画结束后 回调消息
    [self performSelector:@selector(delayBlockCellName:) withObject:str afterDelay:0.35];
    
    
    
}
- (void)delayBlockCellName:(NSString*)obj{
    
    self.chooseBlock(obj);
    
}
@end
