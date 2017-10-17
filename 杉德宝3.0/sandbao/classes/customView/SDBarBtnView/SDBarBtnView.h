//
//  SDBarBtnView.h
//  sandbao
//
//  Created by tianNanYiHao on 2017/10/16.
//  Copyright © 2017年 sand. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SDBarBtnView : UIButton


@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) UIColor *titleColor;
@property (nonatomic, strong) UIColor *btnColor;
@property (nonatomic, assign) CGSize  btnSzie;
@property (nonatomic, strong) UILabel *midLab;


@end
