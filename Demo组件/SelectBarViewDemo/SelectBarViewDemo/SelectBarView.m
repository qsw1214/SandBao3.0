//
//  SelectBarView.m
//  SelectBarViewDemo
//
//  Created by tianNanYiHao on 2017/9/25.
//  Copyright © 2017年 tianNanYiHao. All rights reserved.
//

#import "SelectBarView.h"

@interface SelectBarView()
{
    CALayer *coverLayer;
}
@end

@implementation SelectBarView



- (void)setTitleArr:(NSArray *)titleArr{
    _titleArr = titleArr;
    coverLayer = [CALayer layer];
    [self createUI];
}

- (void)createUI{
    
    CGFloat titleAllWidth = 0;
    
    //1.titleBaseView
    UIView *titleBaseView = [[UIView alloc] init];
    [self addSubview:titleBaseView];
    
    //2.btn
    CGFloat titleWidth;
    CGFloat titleHeight = 0.0;
    for (int i = 0; i<_titleArr.count; i++) {
        CGSize titleSize = [_titleArr[i] sizeWithAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:18]
                                                        }];
        titleWidth = titleSize.width;
        titleHeight = titleSize.height;
        //最小宽度判断
        if (titleWidth<100) {
            titleWidth = 100;
        }else{
            titleWidth += 15;
        }
        
        titleAllWidth += titleWidth;
        UIButton *btn = [[UIButton alloc] init];
        [btn setTitle:_titleArr[i] forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [titleBaseView addSubview:btn];
        btn.frame = CGRectMake(titleAllWidth-titleWidth, 0, titleWidth, titleHeight+30);
        btn.tag = i+1;
        [btn addTarget:self action:@selector(onClick:) forControlEvents:UIControlEventTouchUpInside];
        
        if (i == 0) {
            coverLayer.frame = CGRectMake(titleAllWidth-titleWidth, 0, titleWidth, titleHeight+30);
            coverLayer.cornerRadius = titleHeight/2+30/2;
            coverLayer.backgroundColor = [UIColor blueColor].CGColor;
            [btn.layer addSublayer:coverLayer];
        }
    }
    NSLog(@"%f",titleAllWidth);
    
    titleBaseView.frame = CGRectMake(0, 0, titleAllWidth, titleHeight+30);
    
    self.frame = CGRectMake(20, 100, titleAllWidth, titleHeight+30);
    //超出
    if (self.frame.size.width - 20*2 < titleAllWidth) {
        
    }
    //不超出
    {
        
    }
}

- (void)onClick:(UIButton*)btn{
    
    NSLog(@"%@",[NSString stringWithFormat:@"%@",btn.currentTitle]);
    coverLayer.frame = btn.frame;
    
}

@end
