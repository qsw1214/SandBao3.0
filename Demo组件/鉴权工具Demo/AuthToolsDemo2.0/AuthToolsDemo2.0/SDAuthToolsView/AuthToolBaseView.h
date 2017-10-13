//
//  AuthToolBaseView.h
//  AuthToolsDemo2.0
//
//  Created by tianNanYiHao on 2017/10/12.
//  Copyright © 2017年 tianNanYiHao. All rights reserved.
//

#import <UIKit/UIKit.h>

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
 红色提示动画
 */
- (void)showTip;



@end
