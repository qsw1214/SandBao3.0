//
//  ControlView.m
//  SandControlDemo
//
//  Created by tianNanYiHao on 2017/9/25.
//  Copyright © 2017年 tianNanYiHao. All rights reserved.
//

#import "ControlView.h"


@interface ControlView()
{
    
}
@end

@implementation ControlView



- (instancetype)initWithFrame:(CGRect)frame{
    if ([super initWithFrame:frame]) {
        
        
        UIBezierPath *path = [UIBezierPath bezierPath];
        [path moveToPoint:CGPointMake(20, 25)];
        [path addLineToPoint:CGPointMake(self.frame.size.width-20, 25)];
        [path addLineToPoint:CGPointMake(self.frame.size.width-20, self.frame.size.height+25.f)];
        [path addLineToPoint:CGPointMake(20, self.frame.size.height+25.f)];
        self.layer.shadowPath = path.CGPath;
        self.layer.shadowOpacity = 0.8f;
        self.layer.shadowColor = [UIColor lightGrayColor].CGColor;
        self.layer.shadowRadius = 20.f;
        [self createUI];
    }
    return self;
}

- (void)createUI{
    
    UIView *contentView = [[UIView alloc] init];
    contentView.backgroundColor = [UIColor whiteColor];
    [self addSubview:contentView];
    
    
    UIView *btnBarView = [[UIView alloc] init];
    btnBarView.backgroundColor = [UIColor clearColor];
    [self addSubview:btnBarView];
    
    UIButton *btn = [[UIButton alloc] init];
    btn.backgroundColor = [UIColor colorWithRed:69/255.0f green:183/255.f blue:254/255.f alpha:1.f];
    [btn setTitle:@"查询" forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(onClick:) forControlEvents:UIControlEventTouchUpInside];
    [btnBarView addSubview:btn];
    
    
    
    //frameSet
    contentView.frame = CGRectMake(20, 0, self.frame.size.width-40, self.frame.size.height-18);
    btnBarView.frame = CGRectMake(10, self.frame.size.height-63, self.frame.size.width-20, 63);
    btn.frame = CGRectMake(self.frame.size.width/2-10, 0, self.frame.size.width/2-10, 63);
    
    
    
    
    
}

- (void)onClick:(UIButton*)btn{
    NSLog(@"clicked");
}

@end
