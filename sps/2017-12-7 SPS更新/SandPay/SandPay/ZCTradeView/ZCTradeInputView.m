//
//  ZCTradeInputView.m
//
//  Created by Rainer on 15-7-3.
//  Copyright (c) 2014年 Rainer. All rights reserved.
//

#import "ZCTradeInputView.h"
#import "ZCTradeKeyboard.h"
#import "NSString+Extension.h"

#define ZCTradeInputViewNumCount 6
#define iOS7 ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0 ? YES :NO)
// 快速生成颜色
#define ZCColor(r, g, b) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:1.0]

typedef enum {
    ZCTradeInputViewButtonTypeWithCancle = 10000,
    ZCTradeInputViewButtonTypeWithOk = 20000,
}ZCTradeInputViewButtonType;

@interface ZCTradeInputView ()

/** 数字数组 */
@property (nonatomic, strong) NSMutableArray *nums;
/** 确定按钮 */
@property (nonatomic, weak) UIButton *okBtn;
/** 取消按钮 */
@property (nonatomic, weak) UIButton *cancleBtn;

@end

@implementation ZCTradeInputView

#pragma mark - LazyLoad

- (NSMutableArray *)nums {
    if (_nums == nil) {
        _nums = [NSMutableArray array];
    }
    return _nums;
}

#pragma mark - LifeCircle

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor clearColor];
        /** 注册keyboard通知 */
        [self setupKeyboardNote];
        /** 添加子控件 */
        [self setupSubViews];
    }
    return self;
}

/** 添加子控件 */
- (void)setupSubViews {
    /** 确定按钮 */
    UIButton *okBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self addSubview:okBtn];
    self.okBtn = okBtn;
    [self.okBtn setBackgroundImage:[UIImage imageNamed:@"sandpay.bundle/images/password_ok_up"] forState:UIControlStateNormal];
    [self.okBtn setBackgroundImage:[UIImage imageNamed:@"sandpay.bundle/images/password_ok_down"] forState:UIControlStateHighlighted];
    [self.okBtn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    self.okBtn.tag = ZCTradeInputViewButtonTypeWithOk;
    
    /** 取消按钮 */
    UIButton *cancleBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self addSubview:cancleBtn];
    self.cancleBtn = cancleBtn;
    [self.cancleBtn setBackgroundImage:[UIImage imageNamed:@"sandpay.bundle/images/password_cancel_up"] forState:UIControlStateNormal];
    [self.cancleBtn setBackgroundImage:[UIImage imageNamed:@"sandpay.bundle/images/password_cancel_down"] forState:UIControlStateHighlighted];
    [self.cancleBtn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    self.cancleBtn.tag = ZCTradeInputViewButtonTypeWithCancle;
}

/** 注册keyboard通知 */
- (void)setupKeyboardNote {
    // 删除通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(delete) name:ZCTradeKeyboardDeleteButtonClick object:nil];
    
    // 确定通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(ok) name:ZCTradeKeyboardOkButtonClick object:nil];
    
    // 数字通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(number:) name:ZCTradeKeyboardNumberButtonClick object:nil];
}

#pragma mark - Layout

- (void)layoutSubviews {
    [super layoutSubviews];
    
    /** 取消按钮 */
    self.cancleBtn.width = ZCScreenWidth * 0.409375;
    self.cancleBtn.height = ZCScreenWidth * 0.128125;
    self.cancleBtn.x = ZCScreenWidth * 0.05;
    self.cancleBtn.y = self.height - (ZCScreenWidth * 0.05 + self.cancleBtn.height);
    
    /** 确定按钮 */
    self.okBtn.y = self.cancleBtn.y;
    self.okBtn.width = self.cancleBtn.width;
    self.okBtn.height = self.cancleBtn.height;
    self.okBtn.x = CGRectGetMaxX(self.cancleBtn.frame) + ZCScreenWidth * 0.025;
}

#pragma mark - Private

// 删除
- (void)delete {
    [self.nums removeLastObject];
    [self setNeedsDisplay];
}

// 数字
- (void)number:(NSNotification *)note {
    if (self.nums.count >= ZCTradeInputViewNumCount) return;
    NSDictionary *userInfo = note.userInfo;
    NSNumber *numObj = userInfo[ZCTradeKeyboardNumberKey];
    [self.nums addObject:numObj];
    [self setNeedsDisplay];
}

// 确定
- (void)ok {
    
}

// 按钮点击
- (void)btnClick:(UIButton *)btn {
    if (btn.tag == ZCTradeInputViewButtonTypeWithCancle) {  // 取消按钮点击
        if ([self.delegate respondsToSelector:@selector(tradeInputView:cancleBtnClick:)]) {
            [self.delegate tradeInputView:self cancleBtnClick:btn];
        }
    } else if (btn.tag == ZCTradeInputViewButtonTypeWithOk) {  // 确定按钮点击
        if ([self.delegate respondsToSelector:@selector(tradeInputView:okBtnClick: withDictionary:)]) {
            // 包装通知字典
            NSMutableString *pwd = [NSMutableString string];
            for (int i = 0; i < self.nums.count; i++) {
                NSString *str = [NSString stringWithFormat:@"%@", self.nums[i]];
                [pwd appendString:str];
            }
            NSMutableDictionary *dict = [NSMutableDictionary dictionary];
            dict[ZCTradeInputViewPwdKey] = pwd;
            
            [self.delegate tradeInputView:self okBtnClick:btn withDictionary:dict];
        }
        
//        [[NSNotificationCenter defaultCenter] postNotificationName:ZCTradeInputViewOkButtonClick object:self userInfo:dict];
    } else {
        
    }
}

- (void)drawRect:(CGRect)rect {
    // 画图
    UIImage *bg = [UIImage imageNamed:@"sandpay.bundle/images/pssword_bg"];
    UIImage *field = [UIImage imageNamed:@"sandpay.bundle/images/password_in"];
    
    [bg drawInRect:rect];
    
    CGFloat x = ZCScreenWidth * 0.096875 * 0.5;
    CGFloat y = ZCScreenWidth * 0.40625 * 0.5;
    CGFloat w = ZCScreenWidth * 0.846875;
    CGFloat h = ZCScreenWidth * 0.121875;
    [field drawInRect:CGRectMake(x, y, w, h)];
    
    // 画字
    NSString *title = @"请输入交易密码";
    
    CGSize size = [title sizeWithFont:[UIFont systemFontOfSize:ZCScreenWidth * 0.053125] andMaxSize:CGSizeMake(MAXFLOAT, MAXFLOAT)];
    CGFloat titleW = size.width;
    CGFloat titleH = size.height;
    CGFloat titleX = (self.width - titleW) * 0.5;
    CGFloat titleY = ZCScreenWidth * 0.03125;
    CGRect titleRect = CGRectMake(titleX, titleY, titleW, titleH);
    
    NSMutableDictionary *attr = [NSMutableDictionary dictionary];
    attr[NSFontAttributeName] = [UIFont systemFontOfSize:ZCScreenWidth * 0.053125];
    attr[NSForegroundColorAttributeName] = ZCColor(102, 102, 102);
    
    if (iOS7) {
        [title drawInRect:titleRect withAttributes:attr];
    } else {
        CGContextRef contextRef = UIGraphicsGetCurrentContext();
        CGContextSetFillColorWithColor(contextRef, ZCColor(102, 102, 102).CGColor);
        
        [title drawInRect:titleRect withFont:[UIFont systemFontOfSize:ZCScreenWidth * 0.053125]];
    }
    
    // 画点
    UIImage *pointImage = [UIImage imageNamed:@"sandpay.bundle/images/yuan"];
    CGFloat pointW = ZCScreenWidth * 0.05;
    CGFloat pointH = pointW;
    CGFloat pointY = ZCScreenWidth * 0.24;
    CGFloat pointX;
    CGFloat margin = ZCScreenWidth * 0.0484375;
    CGFloat padding = ZCScreenWidth * 0.045578125;
    for (int i = 0; i < self.nums.count; i++) {
        pointX = margin + padding + i * (pointW + 2 * padding);
        [pointImage drawInRect:CGRectMake(pointX, pointY, pointW, pointH)];
    }
    
    // ok按钮状态
    BOOL statue = NO;
    if (self.nums.count == ZCTradeInputViewNumCount) {
        statue = YES;
    } else {
        statue = NO;
    }
    self.okBtn.enabled = statue;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end