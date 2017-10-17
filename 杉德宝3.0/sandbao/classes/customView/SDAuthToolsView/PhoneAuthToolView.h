//
//  PhoneAuthToolView.h
//  AuthToolsDemo2.0
//
//  Created by tianNanYiHao on 2017/10/12.
//  Copyright © 2017年 tianNanYiHao. All rights reserved.
//

#import "AuthToolBaseView.h"

typedef void(^TextFiledErrorBlock)();

@interface PhoneAuthToolView : AuthToolBaseView

@property (nonatomic, copy) TextFiledErrorBlock errorBlock;





@end
