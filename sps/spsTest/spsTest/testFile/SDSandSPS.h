//
//  SDSandSPS.h
//  SandLife
//
//  Created by WeiWei on 16/9/8.
//  Copyright © 2016年 Sand. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface SDSandSPS : NSObject

// YES 三步认证通过
@property (nonatomic, assign) BOOL __block isSpsPass;

- (void)SpsNetWork;

+ (SDSandSPS*)instance;
@end
