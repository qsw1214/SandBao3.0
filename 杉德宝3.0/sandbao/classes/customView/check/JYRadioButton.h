//
//  JYRadioButton.h
//  sand_mobile_mask
//
//  Created by tianNanYiHao on 14-9-17.
//  Copyright (c) 2014年 sand. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol JYRadioButtonDelegate;

@interface JYRadioButton : UIButton {
    NSString *_groupId;
    BOOL _checked;
    id<JYRadioButtonDelegate> _delegate;
}

@property(nonatomic)id<JYRadioButtonDelegate> delegate;
@property(nonatomic, copy, readonly)NSString *groupId;
@property(nonatomic, assign)BOOL checked;

- (id)initWithDelegate:(id)delegate groupId:(NSString*)groupId;

@end

@protocol JYRadioButtonDelegate <NSObject>

@optional

- (void)didSelectedRadioButton:(JYRadioButton *)radio groupId:(NSString *)groupId;

@end
