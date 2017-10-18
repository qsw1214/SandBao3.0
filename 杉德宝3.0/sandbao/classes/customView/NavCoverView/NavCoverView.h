//
//  NavCoverView.h
//  sandbao
//
//  Created by tianNanYiHao on 2017/3/8.
//  Copyright © 2017年 sand. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 导航左边事件Block
 */
typedef void(^NavCoverLeftActionBlock)(void);

/**
 导航右边事件Block
 */
typedef void(^NavCoverRightActionBalck)(void);

@protocol NavCoverLeftDelegate<NSObject>


@end

/**
 自定义导航样式
 
 - NavCoverStyleWhite: 白色模式
 - NavCoverStyleGradient: 渐变色模式
 */
typedef NS_ENUM(NSInteger,NavCoverViewStyle){
    NavCoverStyleWhite = 0,
    NavCoverStyleGradient
};


@interface NavCoverView : UIView

/**
 中间文字标题
 */
@property (nonatomic, strong) NSString *midTitleStr;


/**
 左边图片名
 */
@property (nonatomic, strong) NSString *letfImgStr;


/**
 右边图片名
 */
@property (nonatomic, strong) NSString *rightImgStr;


/**
 样式
 */
@property (nonatomic, assign) NavCoverViewStyle style;


/**
 回调 - 导航左边事件触发
 */
@property (nonatomic, copy) NavCoverLeftActionBlock leftBlock;

/**
 回调 - 导航右边事件触发
 */
@property (nonatomic, copy) NavCoverRightActionBalck rightBlock;



/**
 获取导航

 @return 实例
 */
+ (NavCoverView*)createNavCorverView;



@end
