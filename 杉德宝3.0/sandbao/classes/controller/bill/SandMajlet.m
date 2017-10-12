//
//  SandMajlet.m
//  sandbao
//
//  Created by tianNanYiHao on 2017/4/13.
//  Copyright © 2017年 sand. All rights reserved.
//

#import "SandMajlet.h"
#import "SDLog.h"

@implementation SandMajlet

- (void)Pay:(NSString *)TN
{
    [self.delegate SandMajletIndex:0 paramString:TN];
    [SDLog logDebug:TN];
}

- (void)Jump:(NSString *)param
{
    
}

- (void)JumpWithBarMenu:(NSString *)param1 param2:(NSString *)param2
{

}

- (void)SetBarMenu:(NSString *)barMenu{
    
    [self.delegate SandMajletIndex:3 paramString:barMenu];
    [SDLog logDebug:barMenu];
    
}

@end
