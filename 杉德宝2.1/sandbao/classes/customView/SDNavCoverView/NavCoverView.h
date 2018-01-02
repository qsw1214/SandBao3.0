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
    NavCoverStyleWhite = 0,  //白色
    NavCoverStyleGradient,   //蓝渐变
    NavCoverStyleClean       //透明
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
 左边图片
 */
@property (nonatomic, strong) UIImage *leftImg;

/**
 左边标题名
 */
@property (nonatomic, strong) NSString *leftTitleStr;


/**
 右边图片名
 */
@property (nonatomic, strong) NSString *rightImgStr;

/**
 右边标题名
 */
@property (nonatomic, strong) NSString *rightTitleStr;


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
 回调 - 导航右边第二个事件触发
 */
@property (nonatomic, copy) NavCoverRightActionBalck rightSecBlock;



/**
 获取导航

 @return 实例
 */
+ (NavCoverView*)createNavCorverView;


/**
 追加一个右边图标

 @param imgName 图片名
 */
- (void)appendRightItem:(NSString*)imgName;


/**
 导航返回事件;
 返回栈底倒数第二层 (若倒数第二层视图控制器是自身,则回退root)
 
 @param vc 当前控制器
 */
- (void)popToPenultimateViewController:(UIViewController*)vc;



@end
