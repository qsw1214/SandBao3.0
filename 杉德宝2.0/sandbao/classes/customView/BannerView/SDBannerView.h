//
//  SDBannerView.h
//  sandbao
//
//  Created by tianNanYiHao on 2017/3/15.
//  Copyright © 2017年 sand. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef enum {
    SDBannerViewOnlyImage = 0, //仅图片模式
    SDBannerViewURLImage,      //网络图片模式
    SDBannerVIewTitleAndImage, //图片文字模式
    
}SDBannerViewStyle;

@protocol  SDBannerViewDelegate <NSObject>

/**
 点击图片代理

 @param index 下标
 */
-(void)sanBannerViewDelegateClick:(NSInteger)index;
@end


@interface SDBannerView : UIView
// 根据确定的rect创建轮播
@property (nonatomic,assign) CGRect rect;
@property (nonatomic,strong) id<SDBannerViewDelegate> delegate;



-(instancetype)initStyle:(SDBannerViewStyle)style imageArray:(NSArray*)imageArray UrlArray:(NSArray*)urlArray titleArray:(NSArray*)titleArray;




@end
