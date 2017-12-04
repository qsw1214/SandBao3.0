//
//  SDMajletView.h
//  sandbao
//
//  Created by tianNanYiHao on 2017/10/31.
//  Copyright © 2017年 sand. All rights reserved.
//

#import <UIKit/UIKit.h>


typedef void(^SDMajletBlock)(NSString *titleName);

@interface SDMajletView : UIView


@property (nonatomic, copy) SDMajletBlock titleNameBlock;


/**
 列数
 */
@property (nonatomic, assign) NSInteger columnNumber;


/**
 间距
 */
@property (nonatomic, assign) NSInteger cellSpace;

/**
 子件数组
 */
@property (nonatomic, strong) NSMutableArray *majletArr;



/**
 MajletView工厂方法-创建collectionView

 @param OY OY
 @return 实例
 */
+ (instancetype)createMajletViewOY:(CGFloat)OY;

@end
