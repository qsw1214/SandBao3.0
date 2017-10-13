//
//  AuthToolBaseView.h
//  AuthToolsDemo2.0
//
//  Created by tianNanYiHao on 2017/10/12.
//  Copyright © 2017年 tianNanYiHao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AuthToolBaseView : UIView


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
 左右间距
 */
@property (nonatomic, assign) CGFloat leftRightSpace;

/**
 常用间距(上下)
 */
@property (nonatomic, assign) CGFloat space;



@end
