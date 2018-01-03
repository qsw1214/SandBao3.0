//
//  AuthToolBaseView.h
//  AuthToolsDemo2.0
//
//  Created by tianNanYiHao on 2017/10/12.
//  Copyright © 2017年 tianNanYiHao. All rights reserved.
//

#import <UIKit/UIKit.h>
#define AdapterWfloat(f) ((f/375.f)*[UIScreen mainScreen].bounds.size.width)
#define AdapterHfloat(f) ((f/667.f)*[UIScreen mainScreen].bounds.size.height)
#define AdapterFfloat(f) (([[UIScreen mainScreen] bounds].size.height==736.f)?(f):(f*0.8571))
@interface AuthToolBaseView : UIView<UITextFieldDelegate>


/**
 标题
 */
@property (nonatomic, strong) UILabel *titleLab;

/**
 文本输入框
 */
@property (nonatomic, strong) UITextField *textfiled;

/**
 底部line
 */
@property (nonatomic, strong) UIView *lineV;

/**
 红色Tip
 */
@property (nonatomic, strong) UILabel *tip;


/**
 左右间距
 */
@property (nonatomic, assign) CGFloat leftRightSpace;

/**
 常用间距(上下)
 */
@property (nonatomic, assign) CGFloat space;


/**
 根据OY点创建authToolView
 -- 该方法用于子类重写使用 --
 @param OY y点值
 @return 实例
 */
+ (instancetype)createAuthToolViewOY:(CGFloat)OY;



/**
 红色提示动画
 */
- (void)showTip;



@end
