//
//  SDBannerView.m
//  sandbao
//
//  Created by tianNanYiHao on 2017/3/15.
//  Copyright © 2017年 sand. All rights reserved.
//

#import "SDBannerView.h"
#import "SDCycleScrollView.h"
@interface SDBannerView()<SDCycleScrollViewDelegate>{
    SDCycleScrollView *sdCycleScrollview;
    NSArray *imageArrayP;
    NSArray *urlArrayP;
    NSArray *titleArrayP;
    SDBannerViewStyle bannerStyle;
    
}@end

@implementation SDBannerView

-(instancetype)initStyle:(SDBannerViewStyle)style imageArray:(NSArray*)imageArray UrlArray:(NSArray*)urlArray titleArray:(NSArray*)titleArray{
    
    bannerStyle = style;
    if (self = [super init]) {
        
        //仅图片模式
        if (imageArray.count>0 && urlArray.count==0 && titleArray.count == 0 && style == SDBannerViewOnlyImage) {
            imageArrayP = [NSArray arrayWithArray:imageArray];
        }
        //网络加载图片模式
        if (imageArray.count==0 && urlArray.count>0 && titleArray.count == 0 && style ==SDBannerViewURLImage) {
            urlArrayP =[NSArray arrayWithArray:urlArray];
        }
        //图片文字模式
        if (imageArray.count>0 && urlArray.count==0 && titleArray.count > 0 && style ==SDBannerVIewTitleAndImage) {
            imageArrayP = [NSArray arrayWithArray:imageArray];
            titleArrayP = [NSArray arrayWithArray:titleArray];
        }
        
    }
    return self;
}


-(void)setRect:(CGRect)rect{
    _rect = rect;
    
    if (bannerStyle == SDBannerViewOnlyImage) {
        sdCycleScrollview = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, 0, _rect.size.width, _rect.size.height) imagesGroup:imageArrayP];
        sdCycleScrollview.infiniteLoop = YES;
        sdCycleScrollview.delegate = self;
        sdCycleScrollview.pageControlStyle = SDCycleScrollViewPageContolAlimentCenter;
        [self addSubview:sdCycleScrollview];
    }
    
    if (bannerStyle == SDBannerViewURLImage) {
        sdCycleScrollview = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, 0, _rect.size.width, _rect.size.height) imageURLStringsGroup:urlArrayP];
        sdCycleScrollview.infiniteLoop = YES;
        sdCycleScrollview.delegate = self;
        sdCycleScrollview.pageControlStyle = SDCycleScrollViewPageContolAlimentCenter;
        sdCycleScrollview.placeholderImage = [UIImage imageNamed:@"loading.png"];
        [self addSubview:sdCycleScrollview];
    }
    
    if (bannerStyle == SDBannerVIewTitleAndImage) {
        sdCycleScrollview = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, 0, _rect.size.width, _rect.size.height) imagesGroup:imageArrayP];
        sdCycleScrollview.infiniteLoop = YES;
        sdCycleScrollview.delegate = self;
        sdCycleScrollview.titlesGroup = titleArrayP;
        sdCycleScrollview.pageControlStyle = SDCycleScrollViewPageContolAlimentCenter;
        [self addSubview:sdCycleScrollview];
    }
    
    
}




#pragma mark - delegate
-(void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index{
    
    if ([_delegate respondsToSelector:@selector(sanBannerViewDelegateClick:)]) {
        [_delegate sanBannerViewDelegateClick:index];
    }
    
}

@end
