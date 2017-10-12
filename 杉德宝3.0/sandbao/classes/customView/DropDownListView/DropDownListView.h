//
//  DropDownListView.h
//  sandbao
//
//  Created by tianNanYiHao on 2017/3/2.
//  Copyright © 2017年 sand. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol DropDownListViewDelegate

/**
 *@brief 选择内容
 *@param param NSString 参数：选择内容
 *
 */
- (void)selectRowContent:(NSString *) param;

/**
 *@brief 删除内容
 *@param param NSString 参数：删除索引
 *
 */
- (void)deleteRowContent:(NSInteger) param;

@end

@interface DropDownListView : UIView

@property (nonatomic, retain) id <DropDownListViewDelegate> delegate;


/**
 *@brief 隐藏列表
 *
 */
- (void)hideDropDown;

/**
 *@brief 初始化
 *@param view UIView 参数：点击的控件
 *@param arr NSArray 参数：列表内容
 *
 */
- (id)initWithShowDropDown:(UIView *)view :(NSArray *)arr;

/**
 *@brief 添加
 *@param param NSDictionary 参数：添加内容字典
 *
 */
- (void)addRow:(NSDictionary *)param;

/**
 *@brief 删除
 *@param param NSString 参数：删除索引
 *
 */
- (void)deleteRow:(NSInteger)param;

@end
