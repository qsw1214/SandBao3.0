//
//  SDExpiryPop.m
//  SDpopViewDemo
//
//  Created by tianNanYiHao on 2018/1/29.
//  Copyright © 2018年 tianNanYiHao. All rights reserved.
//

#import "SDExpiryPop.h"



#define AdapterWfloat(f) ((f/375.f)*[UIScreen mainScreen].bounds.size.width)
#define AdapterHfloat(f) ((f/667.f)*[UIScreen mainScreen].bounds.size.height)
#define AdapterFfloat(f) (([[UIScreen mainScreen] bounds].size.height==736.f)?(f):(f*0.8571))

@interface SDExpiryPop()<UIPickerViewDelegate,UIPickerViewDataSource>
{
    NSString *yearStr;
    NSString *monthStr;
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
 整体高度
 */
@property (nonatomic, assign) CGFloat allHeight;


@property (nonatomic, strong) NSArray *dataArray;


@property (nonatomic, copy) SDExpiryPopBlock block;

@end


@implementation SDExpiryPop

+ (void)showExpiryPopView:(SDExpiryPopBlock)block{
    
    SDExpiryPop *pop = [[SDExpiryPop alloc] init];
    pop.allHeight = AdapterHfloat(240);
    pop.frame = CGRectMake(0, [UIScreen mainScreen].bounds.size.height, [UIScreen mainScreen].bounds.size.width, pop.allHeight);
    pop.backgroundColor = [UIColor whiteColor];
    
    pop.block = block;
    
    [pop createPick];
    
    [pop show];
    
    
    
}

- (void)createPick{
    
    UIView *titleView = [[UIView alloc] init];
    titleView.backgroundColor = [UIColor whiteColor];
    titleView.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, self.allHeight/6);
    [self addSubview:titleView];
    
    
    UIButton *cancleBTN = [[UIButton alloc] init];
    [cancleBTN setTitle:@"取消" forState:UIControlStateNormal];
    [cancleBTN setTitleColor:[UIColor colorWithRed:95/255.f green:95/255.f blue:95/255.f alpha:1.f] forState:UIControlStateNormal];
    [cancleBTN addTarget:self action:@selector(cancleClick) forControlEvents:UIControlEventTouchUpInside];
    cancleBTN.frame = CGRectMake(AdapterWfloat(20), 0, [cancleBTN sizeThatFits:CGSizeZero].width, self.allHeight/6);
    [titleView addSubview:cancleBTN];
    
    UIButton *sureBtn = [[UIButton alloc] init];
    [sureBtn setTitle:@"确认" forState:UIControlStateNormal];
    [sureBtn setTitleColor:[UIColor colorWithRed:95/255.f green:95/255.f blue:95/255.f alpha:1.f] forState:UIControlStateNormal];
    [sureBtn addTarget:self action:@selector(sureClick) forControlEvents:UIControlEventTouchUpInside];
    sureBtn.frame = CGRectMake(titleView.frame.size.width - AdapterWfloat(20) - [sureBtn sizeThatFits:CGSizeZero].width, 0, [sureBtn sizeThatFits:CGSizeZero].width, self.allHeight/6);
    [titleView addSubview:sureBtn];
    
    NSMutableArray *yearArr = [NSMutableArray arrayWithCapacity:0];
    for (NSInteger i = 1990; i<2100; i++) {
        NSString *yearStr = [NSString stringWithFormat:@"%ld",(long)i];
        [yearArr addObject:yearStr];
    }
    
    NSMutableArray *monthArr = [NSMutableArray arrayWithCapacity:0];
    for (NSInteger j = 1; j<=12; j++) {
        NSString *monthStr ;
        if (j<10) {
            monthStr = [NSString stringWithFormat:@"0%ld",(long)j];
        }else{
            monthStr = [NSString stringWithFormat:@"%ld",(long)j];
        }
        [monthArr addObject:monthStr];
    }
    
    self.dataArray = @[yearArr,monthArr];
    
    UIPickerView *pickView = [[UIPickerView alloc] initWithFrame:CGRectMake(0, self.allHeight/6, [UIScreen mainScreen].bounds.size.width, self.allHeight*5/6)];
    pickView.backgroundColor = [UIColor colorWithRed:240/255.f green:240/255.f blue:240/255.f alpha:1.f];
    pickView.dataSource = self;
    pickView.delegate = self;
    pickView.showsSelectionIndicator = YES;
    [self addSubview:pickView];
    

}

- (void)show{
    
    UIWindow *window = [[UIApplication sharedApplication].windows firstObject];
    [window addSubview:self.backGroundView];
    
    [self showAnimation:YES];
}

- (void)hidden{
    
    [self showAnimation:NO];
}

- (void)showAnimation:(BOOL)isShow{
    
    if (isShow) {
        
        //1.背景动画
        [UIView animateWithDuration:0.35f animations:^{
            self.maskBlackView.alpha = 0.4f;
            self.frame = CGRectMake(0, [UIScreen mainScreen].bounds.size.height - self.allHeight, [UIScreen mainScreen].bounds.size.width, self.allHeight);
        } completion:^(BOOL finished) {
            
        }];
    }
    if (!isShow) {
        [UIView animateWithDuration:0.35f animations:^{
            self.maskBlackView.alpha = 0.f;
            self.frame = CGRectMake(0, [UIScreen mainScreen].bounds.size.height, [UIScreen mainScreen].bounds.size.width, self.allHeight);
        } completion:^(BOOL finished) {
            [self.backGroundView removeFromSuperview];
            [self.maskBlackView removeFromSuperview];
            [self removeFromSuperview];
        }];
    }
}


-(UIView*)backGroundView{
    
    if (!_backGroundView) {
        _backGroundView = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
        _backGroundView.backgroundColor = [UIColor clearColor];
        
        //背景View 添加 遮罩
        [_backGroundView addSubview:self.maskBlackView];
        //背景View 添加 popView
        [_backGroundView addSubview:self];
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


- (void)cancleClick{
    
    [self hidden];
}

- (void)sureClick{
    
    self.block([self newYM:yearStr month:monthStr]);
    [self hidden];
}

#pragma mark pickViewDatasouce
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    
    return self.dataArray.count;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    
    return [self.dataArray[component] count];
}
#pragma mark pickViewDelegate
- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    
    return self.dataArray[component][row];
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    
    if (component == 0){
        NSArray *yearArr = self.dataArray[0];
        yearStr = [yearArr objectAtIndex:row];
        yearStr = [yearStr substringFromIndex:2];
    }
    if (component == 1){
        NSArray *monthArr = self.dataArray[1];
        monthStr = [monthArr objectAtIndex:row];
    }
    
}


//拼接Expiry
- (NSString *)newYM:(NSString*)year month:(NSString*)month{
    
    if (year.length == 0 && month.length>0) {
        return [NSString stringWithFormat:@"%@%@",month,@"90"];
    }
    if (month.length == 0 && year.length>0) {
        return [NSString stringWithFormat:@"%@%@",@"01",year];
    }
    if (month.length == 0 && year.length == 0) {
        return @"0190";
    }
    return [NSString stringWithFormat:@"%@%@",month,year];
    
}


@end
