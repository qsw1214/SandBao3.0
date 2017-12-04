//
//  BankPickerView.m
//  AuthToolsDemo2.0
//
//  Created by tianNanYiHao on 2017/10/19.
//  Copyright © 2017年 tianNanYiHao. All rights reserved.
//


#import "BankPickerView.h"

#define BankScreenW [UIScreen mainScreen].bounds.size.width
#define BankScreenH [UIScreen mainScreen].bounds.size.height
#define bankPickerViewDuration 0.4f
@interface BankPickerView ()<UIPickerViewDelegate, UIPickerViewDataSource>
{
    NSArray *infoArray;
    
}

@property (nonatomic, strong) UIView *bgView;
@property (nonatomic, strong) UIView *maskBGView;
@property (nonatomic, strong) UIView *bankTooBar;
@property (nonatomic, copy)   BankInfoBlock infoBlock;
@property (nonatomic, strong) NSArray *datas;
@end

@implementation BankPickerView


+ (void)showBankPickView:(NSArray*)data blockBankInfo:(BankInfoBlock)blockBankInfo{
    
    BankPickerView *bankPickView = [[BankPickerView alloc] initWithFrame:CGRectMake(0, BankScreenH, BankScreenW, 250)];
    bankPickView.backgroundColor = [UIColor whiteColor];
    bankPickView.infoBlock = blockBankInfo;
    bankPickView.dataSource = bankPickView;
    bankPickView.delegate   = bankPickView;
    bankPickView.datas = data;
    
    [bankPickView show];
}

- (void)show{
    [self bankPickViewanimationShow:YES];
    UIWindow *window = [[UIApplication sharedApplication].windows firstObject];
    [window addSubview:self.bgView];
}

#pragma mark - 代理
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return self.datas.count;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return [self.datas[component] count];
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    return self.datas[component][row];
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{

    NSInteger offset1 = [pickerView selectedRowInComponent:0];
    NSInteger offset2 = [pickerView selectedRowInComponent:1];
    
    NSArray *bankArray = [self.datas firstObject];
    NSArray *cardArray = [self.datas lastObject];
    
    if (bankArray == nil || cardArray == nil) {
        return;
    }else{
       infoArray = @[[bankArray objectAtIndex:offset1],[cardArray objectAtIndex:offset2]]; 
    }
    
    
    
}



#pragma - mark lazyAdd

- (UIView *)bgView{
    if (!_bgView) {
        _bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, BankScreenW, BankScreenH)];
        _bgView.backgroundColor = [UIColor clearColor];
        [_bgView addSubview:self.maskBGView];
        [_bgView addSubview:self];
        [_bgView addSubview:self.bankTooBar];
        
        //手势关闭
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(closeClick)];
        [_bgView addGestureRecognizer:tapGesture];
        
    }
    return _bgView;
}

- (UIView *)maskBGView{
    if (!_maskBGView) {
        _maskBGView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, BankScreenW, BankScreenH)];
        _maskBGView.backgroundColor = [UIColor blackColor];
        _maskBGView.alpha = 0.f;
        [self maskBGViewanimationShow:YES];
    }
    return _maskBGView;
    
}

- (UIView *)bankTooBar{
    
    if (!_bankTooBar) {
        _bankTooBar = [[UIView alloc] initWithFrame:CGRectMake(0, BankScreenH, BankScreenW, 40)];
        _bankTooBar.backgroundColor = [UIColor colorWithRed:251/255.0 green:249/255.0 blue:254/255.0 alpha:1/1.0];
        
        UIButton *finishBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        [finishBtn setTitle:@"完成" forState:UIControlStateNormal];
        finishBtn.frame = CGRectMake(BankScreenW-60, 0, 60, _bankTooBar.bounds.size.height);
        [finishBtn setTitleColor:[UIColor colorWithRed:53/255.0 green:139/255.0 blue:239/255.0 alpha:1/1.0] forState:UIControlStateNormal];
        finishBtn.titleLabel.font =  [UIFont fontWithName:@"PingFangSC-Regular" size:15];
        [finishBtn addTarget:self action:@selector(okClick:) forControlEvents:UIControlEventTouchUpInside];
        [_bankTooBar addSubview:finishBtn];
        
        UIButton *cancelBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        [cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
        cancelBtn.frame = CGRectMake(0, 0, 60, _bankTooBar.bounds.size.height);
        [cancelBtn setTitleColor:[UIColor colorWithRed:53/255.0 green:139/255.0 blue:239/255.0 alpha:1/1.0] forState:UIControlStateNormal];
        cancelBtn.titleLabel.font =  [UIFont fontWithName:@"PingFangSC-Regular" size:15];
        [cancelBtn addTarget:self action:@selector(closeClick) forControlEvents:UIControlEventTouchUpInside];
        [_bankTooBar addSubview:cancelBtn];
        
        UIView *lineView = [[UIView alloc] init];
        lineView.backgroundColor = [UIColor colorWithRed:223/255.0 green:223/255.0 blue:223/255.0 alpha:1/1.0];
        lineView.frame = CGRectMake(0, 40-1, BankScreenW, 1);
        [_bankTooBar addSubview:lineView];
        [self bankTooBaranimationShow:YES];
        
    }return _bankTooBar;
    
}

//完成
- (void)okClick:(UIButton*)btn{
    
    if (self.infoBlock) {
        if (self.datas.count) {
            self.infoBlock(infoArray);
        }
    }
    
    [self closeClick];
}

//取消
- (void)closeClick{
    
    [self maskBGViewanimationShow:NO];
    [self bankTooBaranimationShow:NO];
    [self bankPickViewanimationShow:NO];
}

#pragma  - mark Animation ---- UIVIew

/**
 背景动画
 
 @param isShow 是否显示
 */
- (void)maskBGViewanimationShow:(BOOL)isShow{
    
    if (isShow) {
        [UIView animateWithDuration:bankPickerViewDuration animations:^{
            _maskBGView.alpha = 0.4f;
        }];
    }
    else{
        [UIView animateWithDuration:bankPickerViewDuration animations:^{
            _maskBGView.alpha = 0;
        } completion:^(BOOL finished) {
            [self.maskBGView removeFromSuperview];
            self.maskBGView = nil;
            [self.bgView removeFromSuperview];
            self.bgView = nil;
        }];
    }
}

/**
 工具条动画
 
 @param isShow 是否显示
 */
- (void)bankTooBaranimationShow:(BOOL)isShow{
    
    if (isShow) {
        [UIView animateWithDuration:bankPickerViewDuration animations:^{
            _bankTooBar.frame = CGRectMake(0, BankScreenH-self.bounds.size.height-40, BankScreenW, 40);
        }];
    }else{
        [UIView animateWithDuration:bankPickerViewDuration animations:^{
            _bankTooBar.frame = CGRectMake(0, BankScreenH, BankScreenW, 40);
        } completion:^(BOOL finished) {
            [self.bankTooBar removeFromSuperview];
            self.bankTooBar = nil;
        }];
    }
}

/**
 pickerView动画
 
 @param isShow 是否显示
 */
- (void)bankPickViewanimationShow:(BOOL)isShow{
    if (isShow) {
        [UIView animateWithDuration:bankPickerViewDuration animations:^{
            self.frame = CGRectMake(0, BankScreenH - 250, BankScreenW, 250);
        }];
    }else{
        [UIView animateWithDuration:bankPickerViewDuration animations:^{
            self.frame = CGRectMake(0, BankScreenH, BankScreenW, 250);
        } completion:^(BOOL finished) {
            [self removeFromSuperview];
        }];
    }
}







@end
