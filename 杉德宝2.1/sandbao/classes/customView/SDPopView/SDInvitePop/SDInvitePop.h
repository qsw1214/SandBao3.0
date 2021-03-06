//
//  SDInvitePop.h
//  SDInvitePop
//
//  Created by tianNanYiHao on 2018/1/24.
//  Copyright © 2018年 tianNanYiHao. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^SDInvitePopBlock)(NSString *titleName);

@interface SDInvitePop : UIView


+ (void)showInvitePopView:(NSDictionary*)infoDict cellClickBlock:(SDInvitePopBlock)block;



@end
