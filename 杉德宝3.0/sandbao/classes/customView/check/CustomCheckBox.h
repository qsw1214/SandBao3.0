//
//  CustomCheckBox.h
//  collectionTreasure
//
//  Created by tianNanYiHao on 15/7/2.
//  Copyright (c) 2015年 sand. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol CheckBoxDelegate;

@interface CustomCheckBox : UIView
{
    //显示文字
    NSString *_title;
    //显示文字字体
    UIFont *_font;
    //显示文字颜色
    UIColor *_titleColor;
    //选择图片
    UIImage *_checkImage;
    //不选中图片
    UIImage *_normalImage;
}

-(void)setTitle:(NSString *)newTitle;
-(NSString *)title;

-(void)setFont:(UIFont *)newFont;
-(UIFont *)font;

-(void)setTitleColor:(UIColor *)newTitleColor;
-(UIColor *)titleColor;

-(void)setCheckImage:(UIImage *)newCheckImage;
-(UIImage *)checkImage;

-(void)setNormalImage:(UIImage *)newNormalImage;
-(UIImage *)normalImage;

//是否选中
@property (nonatomic,assign)BOOL checked;
//代理
@property(nonatomic,retain) id<CheckBoxDelegate> delegate;

@end

@protocol CheckBoxDelegate<NSObject>

-(void)onChangeDelegate:(CustomCheckBox *)checkbox isCheck:(BOOL)isCheck;

@end
