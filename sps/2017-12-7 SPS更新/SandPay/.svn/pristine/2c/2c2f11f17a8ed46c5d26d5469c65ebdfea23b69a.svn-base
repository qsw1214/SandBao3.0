//
//  ZCTradeKeyboard.m
//
//  Created by Rainer on 15-7-3.
//  Copyright (c) 2014年 Rainer. All rights reserved.
//

#import "ZCTradeKeyboard.h"
#import "ZCAudioTool.h"

#define ZCKeyboardBtnCount 12

@interface ZCTradeKeyboard ()

// 所有数字按钮的数组
@property (nonatomic, strong) NSMutableArray *controlBtnArray;
@property (nonatomic, strong) NSMutableSet *numberBtnSet;

@end

@implementation ZCTradeKeyboard

#pragma mark - LifeCircle

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor whiteColor];
        /** 添加所有按键 */
        [self setupAllBtns];
    }
    return self;
}

/** 添加所有按键 */
- (void)setupAllBtns {
    for (int i = 0; i < ZCKeyboardBtnCount; i++) {
        // 创建按钮
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        
        // 按钮音效监听
        [btn addTarget:self action:@selector(playTock) forControlEvents:UIControlEventTouchDown];
        // 按钮公共属性
        [btn setBackgroundImage:[UIImage imageNamed:@"sandpay.bundle/images/number_bg"] forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
        
        if (i == 9) {  // 确定按钮
            [btn setTitle:@"隐藏" forState:UIControlStateNormal];
            btn.titleLabel.font = [UIFont systemFontOfSize:ZCScreenWidth * 0.046875];
            [btn addTarget:self action:@selector(okBtnClick) forControlEvents:UIControlEventTouchUpInside];
            [self.controlBtnArray addObject:btn];
        } else if (i == 10) {  // 0 按钮
            [btn setTitle:@"0" forState:UIControlStateNormal];
            btn.titleLabel.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:ZCScreenWidth * 0.06875];
            btn.tag = 0;
            [btn addTarget:self action:@selector(numBtnClick:) forControlEvents:UIControlEventTouchUpInside];
            [self.numberBtnSet addObject:btn];
        } else if (i == 11) {  // 删除按钮
            [btn setTitle:@"删除" forState:UIControlStateNormal];
            btn.titleLabel.font = [UIFont systemFontOfSize:ZCScreenWidth * 0.046875];
            [btn addTarget:self action:@selector(deleteBtnClick) forControlEvents:UIControlEventTouchUpInside];
            [self.controlBtnArray addObject:btn];
        } else {  // 其他数字按钮
            [btn setTitle:[NSString stringWithFormat:@"%d", i + 1] forState:UIControlStateNormal];
            btn.titleLabel.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:ZCScreenWidth * 0.06875];
            btn.tag = i + 1;
            [btn addTarget:self action:@selector(numBtnClick:) forControlEvents:UIControlEventTouchUpInside];
            [self.numberBtnSet addObject:btn];
        }
    }
    
    [self sortButtonArray];
}

/**
 *  重新排序生成数字键顺序
 */
- (void)sortButtonArray {
    NSMutableArray *allBtnArray = [NSMutableArray arrayWithCapacity:ZCKeyboardBtnCount];
    
    [allBtnArray addObjectsFromArray:[self.numberBtnSet allObjects]];
    
    [self.controlBtnArray enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        if (0 == idx) {
            [allBtnArray insertObject:obj atIndex:9];
        } else {
            [allBtnArray addObject:obj];
        }
    }];
    
    [allBtnArray enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        UIButton *btn = (UIButton *)obj;
        
        [self addSubview:btn];
    }];
}

#pragma mark - Layout

- (void)layoutSubviews {
    [super layoutSubviews];
    
    // 定义总列数
    NSInteger totalCol = 3;
    
    // 定义间距
    CGFloat pad = ZCScreenWidth * 0.015625;
    
    // 定义x y w h
    CGFloat x;
    CGFloat y;
    CGFloat w = ZCScreenWidth * 0.3125;
    CGFloat h = ZCScreenWidth * 0.14375;
    
    // 列数 行数
    NSInteger row;
    NSInteger col;
    for (int i = 0; i < ZCKeyboardBtnCount; i++) {
        row = i / totalCol;
        col = i % totalCol;
        x = pad + col * (w + pad);
        y = row * (h + pad) + pad;
        UIButton *btn = self.subviews[i];
        btn.frame = CGRectMake(x, y, w, h);
    }
}

#pragma mark - Private

/** 删除按钮点击 */
- (void)deleteBtnClick {
    if ([self.delegate respondsToSelector:@selector(tradeKeyboardDeleteBtnClick)]) {
        [self.delegate tradeKeyboardDeleteBtnClick];
    }
    [[NSNotificationCenter defaultCenter] postNotificationName:ZCTradeKeyboardDeleteButtonClick object:self];
}

/** 确定按钮点击 */
- (void)okBtnClick {
    if ([self.delegate respondsToSelector:@selector(tradeKeyboardOkBtnClick)]) {
        [self.delegate tradeKeyboardOkBtnClick];
    }
    [[NSNotificationCenter defaultCenter] postNotificationName:ZCTradeKeyboardOkButtonClick object:self];
}

/** 数字按钮点击 */
- (void)numBtnClick:(UIButton *)numBtn {
    if ([self.delegate respondsToSelector:@selector(tradeKeyboard:numBtnClick:)]) {
        [self.delegate tradeKeyboard:self numBtnClick:numBtn.tag];
    }
    NSMutableDictionary *userInfo = [NSMutableDictionary dictionary];
    userInfo[ZCTradeKeyboardNumberKey] = @(numBtn.tag);
    [[NSNotificationCenter defaultCenter] postNotificationName:ZCTradeKeyboardNumberButtonClick object:self userInfo:userInfo];
}

/** 播放系统音效 */
- (void)playTock {
    ZCAudioTool *tool = [[ZCAudioTool alloc] initSystemSoundWithName:@"Tock" SoundType:@"caf"];
    [tool play];
}

#pragma mark - LazyLoad

- (NSMutableArray *)controlBtnArray {
    if (nil == _controlBtnArray) {
        _controlBtnArray = [NSMutableArray array];
    }
    return _controlBtnArray;
}

- (NSMutableSet *)numberBtnSet {
    if (nil == _numberBtnSet) {
        _numberBtnSet = [NSMutableSet set];
    }
    return _numberBtnSet;
}

@end