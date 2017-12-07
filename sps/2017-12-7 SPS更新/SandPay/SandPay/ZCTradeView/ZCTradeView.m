//
//  ZCTradeView.m
//
//  Created by Rainer on 15-7-3.
//  Copyright (c) 2014年 Rainer. All rights reserved.
//

#import "ZCTradeView.h"
#import "ZCTradeKeyboard.h"
#import "ZCTradeInputView.h"
#import "UIAlertView+Quick.h"

// 自定义Log
#ifdef DEBUG // 调试状态, 打开LOG功能
#define ZCLog(...) NSLog(__VA_ARGS__)
#define ZCFunc ZCLog(@"%s", __func__);
#else // 发布状态, 关闭LOG功能
#define ZCLog(...)
#define ZCFunc
#endif

// 设备判断
/**
 iOS设备宽高比
 4\4s {320, 480}  5s\5c {320, 568}  6 {375, 667}  6+ {414, 736}
 0.66             0.56              0.56          0.56
 */
#define ios7 ([[UIDevice currentDevice].systemVersion doubleValue] >= 7.0)
#define ios8 ([[UIDevice currentDevice].systemVersion doubleValue] >= 8.0)
#define ios6 ([[UIDevice currentDevice].systemVersion doubleValue] >= 6.0 && [[UIDevice currentDevice].systemVersion doubleValue] < 7.0)
#define ios5 ([[UIDevice currentDevice].systemVersion doubleValue] < 6.0)
#define iphone5  ([UIScreen mainScreen].bounds.size.height == 568)
#define iphone6  ([UIScreen mainScreen].bounds.size.height == 667)
#define iphone6Plus  ([UIScreen mainScreen].bounds.size.height == 736)
#define iphone4  ([UIScreen mainScreen].bounds.size.height == 480)
#define ipadMini2  ([UIScreen mainScreen].bounds.size.height == 1024)

@interface ZCTradeView () <UIAlertViewDelegate,ZCTradeInputViewDelegate>

/** 键盘 */
@property (nonatomic, weak) ZCTradeKeyboard *keyboard;
/** 输入框 */
@property (nonatomic, weak) ZCTradeInputView *inputView;
/** 蒙板 */
@property (nonatomic, weak) UIButton *cover;
/** 响应者 */
@property (nonatomic, weak) UITextField *responsder;
/** 键盘状态 */
@property (nonatomic, assign, getter=isKeyboardShow) BOOL keyboardShow;
/** 返回密码 */
@property (nonatomic, copy) NSString *passWord;

@end

@implementation ZCTradeView

#pragma mark - LifeCircle

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:ZCScreenBounds];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        /** 蒙板 */
        [self setupCover];
        /** 键盘 */
        [self setupkeyboard];
        /** 输入框 */
        [self setupInputView];
        /** 响应者 */
        [self setupResponsder];
    }
    return self;
}

/** 蒙板 */
- (void)setupCover {
    UIButton *cover = [UIButton buttonWithType:UIButtonTypeCustom];
    [self addSubview:cover];
    self.cover = cover;
    [self.cover setBackgroundColor:[UIColor blackColor]];
    self.cover.alpha = 0.4;
    [self.cover addTarget:self action:@selector(coverClick) forControlEvents:UIControlEventTouchUpInside];
}

/** 输入框 */
- (void)setupInputView {
    ZCTradeInputView *inputView = [[ZCTradeInputView alloc] init];
    [self addSubview:inputView];
    self.inputView = inputView;
    self.inputView.delegate = self;
}

/** 响应者 */
- (void)setupResponsder {
    UITextField *responsder = [[UITextField alloc] init];
    [self addSubview:responsder];
    self.responsder = responsder;
}

/** 键盘 */
- (void)setupkeyboard {
    ZCTradeKeyboard *keyboard = [[ZCTradeKeyboard alloc] init];
    [self addSubview:keyboard];
    self.keyboard = keyboard;
    
    // 注册确定按钮点击通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardOkClickAction) name:ZCTradeKeyboardOkButtonClick object:nil];
}

#pragma mark - Layout

- (void)layoutSubviews {
    [super layoutSubviews];
    
    /** 蒙板 */
    self.cover.frame = self.bounds;
}

#pragma mark - Private

- (void)coverClick {
    if (self.isKeyboardShow) {  // 键盘是弹出状态
        [self hidenKeyboard:nil];
    } else {  // 键盘是隐藏状态
        [self showKeyboard];
    }
}

/** 键盘弹出 */
- (void)showKeyboard {
    self.keyboardShow = YES;
    
    CGFloat marginTop;
    if (iphone4) {
        marginTop = 42;
    } else if (iphone5) {
        marginTop = 100;
    } else if (iphone6) {
        marginTop = 120;
    } else {
        marginTop = 140;
    }
    
    [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        self.keyboard.transform = CGAffineTransformMakeTranslation(0, -self.keyboard.height);
        self.inputView.transform = CGAffineTransformMakeTranslation(0, marginTop - self.inputView.y);
    } completion:^(BOOL finished) {
        
    }];
}

/** 键盘退下 */
- (void)hidenKeyboard:(void (^)(BOOL finished))completion {
    self.keyboardShow = NO;

    [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        self.keyboard.transform = CGAffineTransformIdentity;
        self.inputView.transform = CGAffineTransformIdentity;
    } completion:completion];
}

/** 键盘的确定按钮点击 */
- (void)keyboardOkClickAction {
    [self hidenKeyboard:nil];
}

#pragma mark - Public Interface

/** 快速创建 */
+ (instancetype)shareTradeView {
    return [[self alloc] init];
}

/** 弹出 */
- (void)show {
    [self showInView:[UIApplication sharedApplication].keyWindow];
}

- (void)showInView:(UIView *)view {
    // 浮现
    [view addSubview:self];
    
    /** 键盘起始frame */
    self.keyboard.x = 0;
    self.keyboard.y = ZCScreenHeight;
    self.keyboard.width = ZCScreenWidth;
    self.keyboard.height = ZCScreenWidth * 0.65;
    
    /** 输入框起始frame */
    self.inputView.height = ZCScreenWidth * 0.5625;
    self.inputView.y = (self.height - self.inputView.height) * 0.5;
    self.inputView.width = ZCScreenWidth * 0.94375;
    self.inputView.x = (ZCScreenWidth - self.inputView.width) * 0.5;
    
    /** 弹出键盘 */
    [self showKeyboard];
}

/**
 隐藏密码框
 */
- (void)hiden {
    [self hidenKeyboard:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:ZCTradeInputViewCancleButtonClick object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - UIAlertViewDelegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    self.inputView.hidden = NO;
    
    if (buttonIndex == 0) {  // 否按钮点击
        [self showKeyboard];
    } else {  // 是按钮点击
        // 清空num数组
        NSMutableArray *nums = [self.inputView valueForKeyPath:@"nums"];
        [nums removeAllObjects];
        [self removeFromSuperview];
        [self.inputView setNeedsDisplay];
        
        if ([self.delegate respondsToSelector:@selector(cancelButtonClickAction)]) {
            [self.delegate cancelButtonClickAction];
        }
    }
}

#pragma mark - ZCTradeInputViewDelegate

/** 确定按钮点击 */
- (void)tradeInputView:(ZCTradeInputView *)tradeInputView okBtnClick:(UIButton *)okBtn withDictionary:(NSDictionary *)dictionarty {
    // 获取密码
    NSString *password = dictionarty[ZCTradeInputViewPwdKey];
    
    // 通知代理\传递密码
    if ([self.delegate respondsToSelector:@selector(finish:)]) {
        [self.delegate finish:password];
    }
    
    // 回调block\传递密码
    if (self.finish) {
        self.finish(password);
    }
}

/** 取消按钮点击 */
- (void)tradeInputView:(ZCTradeInputView *)tradeInputView cancleBtnClick:(UIButton *)cancleBtn {
    [self hidenKeyboard:^(BOOL finished) {
        self.inputView.hidden = YES;
        [UIAlertView showWithTitle:@"是否退出?" message:nil delegate:self cancelButtonTitle:@"否" otherButtonTitles:@"是", nil];
    }];
}


@end