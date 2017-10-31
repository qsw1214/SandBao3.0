//
//  SetCellBaseView.h
//  sandbao
//
//  Created by tianNanYiHao on 2017/10/30.
//  Copyright © 2017年 sand. All rights reserved.
//

#import <UIKit/UIKit.h>


typedef void(^SetCellClickBlock)();

/**
 设置页 cell 基础view
 */
@interface SetCellBaseView : UIView



/**
 按钮时间回调
 */
@property (nonatomic, copy) SetCellClickBlock clickBlock;


/**
 标题文字:便于计算宽度
 */
@property (nonatomic, strong) NSString *titleStr;


/**
 标题lab
 */
@property (nonatomic, strong) UILabel *titleLab;


/**
 右边的图片名
 */
@property (nonatomic, strong) NSString *rightImgStr;

/**
 右边图片
 */
@property (nonatomic, strong) UIImageView *rightImgView;


/**
 line
 */
@property (nonatomic, strong) UIView *line;

/**
 覆盖全view的按钮
 */
@property (nonatomic, strong) UIButton *coverBtn;


/**
 左右间距
 */
@property (nonatomic, assign) CGFloat leftRightSpace;

/**
 常用间距(上下)
 */
@property (nonatomic, assign) CGFloat space;


/**
 设置页面cell工厂类方法
 
 @param OY OY点
 @return 实例
 */
+ (instancetype)createSetCellViewOY:(CGFloat)OY;




@end
