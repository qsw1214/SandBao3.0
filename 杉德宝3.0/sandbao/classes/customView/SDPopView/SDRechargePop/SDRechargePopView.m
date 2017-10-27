//
//  SDRechargePopView.m
//  sandbao
//
//  Created by tianNanYiHao on 2017/10/27.
//  Copyright © 2017年 sand. All rights reserved.
//

#import "SDRechargePopView.h"


#define popWidth [UIScreen mainScreen].bounds.size.width - 50*2

@interface SDRechargePopView ()
{
    
}
@property (nonatomic, strong) UIView *bgView;
@end


@implementation SDRechargePopView



+ (void)showRechargePopView:(NSString*)title chooseList:(NSArray*)listArray{
    
    
    SDRechargePopView *pop = [[SDRechargePopView alloc] initWithFrame:CGRectMake(50, 0, popWidth, popWidth)];

    [pop show];
    
}


- (void)show{
    
    UIWindow *window = [UIApplication sharedApplication].windows.firstObject;
    [window addSubview:self.bgView];
    
}

-(UIView*)bgView{
    
    
    if (!_bgView) {
        _bgView = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
        _bgView.backgroundColor = [UIColor blueColor];
        
    }
    return _bgView;
    
}



@end
