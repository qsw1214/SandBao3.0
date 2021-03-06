//
//  SDIvitePopCell.h
//  SDInvitePop
//
//  Created by tianNanYiHao on 2018/1/24.
//  Copyright © 2018年 tianNanYiHao. All rights reserved.
//

#import <UIKit/UIKit.h>


@protocol SDIvitePooCellDelegate<NSObject>

- (void)cellClick:(NSString*)titleName;

@end

@interface SDIvitePopCell : UIView

@property (nonatomic, strong) NSString *titleName;

@property (nonatomic, strong) NSString *iconName;

@property (nonatomic, assign) id<SDIvitePooCellDelegate>delegate;

- (void)createSDIvitePopCell;

@end
