//
//  JYCheckBox.h
//  sand_mobile_mask
//
//  Created by tianNanYiHao on 14-9-17.
//  Copyright (c) 2014年 sand. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol JYCheckBoxDelegate;

@interface JYCheckBox : UIButton {
    id<JYCheckBoxDelegate> _delegate;
    BOOL _checked;
    id _userInfo;
}

@property(nonatomic)id<JYCheckBoxDelegate> delegate;
@property(nonatomic, assign)BOOL checked;
@property(nonatomic, retain)id userInfo;

- (id)initWithDelegate:(id)delegate;

@end

@protocol JYCheckBoxDelegate <NSObject>

@optional

- (void)didSelectedCheckBox:(JYCheckBox *)checkbox checked:(BOOL)checked;

@end
