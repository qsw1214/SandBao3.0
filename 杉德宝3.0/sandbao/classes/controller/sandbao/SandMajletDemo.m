//
//  SandMajletDemo.m
//  sandbao
//
//  Created by tianNanYiHao on 2017/4/7.
//  Copyright © 2017年 sand. All rights reserved.
//

#import "SandMajletDemo.h"
#import "SDLog.h"

@implementation SandMajletDemo


- (void)Pay:(NSString *)TN
{
    [self.delegate SandMajletIndex:0 paramString:TN];
    [SDLog logTest:@"aaaaaaaa"];
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
