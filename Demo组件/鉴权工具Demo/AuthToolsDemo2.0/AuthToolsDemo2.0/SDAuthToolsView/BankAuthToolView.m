//
//  BankAuthToolView.m
//  AuthToolsDemo2.0
//
//  Created by tianNanYiHao on 2017/10/19.
//  Copyright © 2017年 tianNanYiHao. All rights reserved.
//

#import "BankAuthToolView.h"

@interface BankAuthToolView (){
    
    UIButton *chooseBankBtn;
    UILabel  *chooseBankTitleLab;
    UIImageView *rightMoreImgV;
}

@end

@implementation BankAuthToolView

/**
 创建对象
 
 @param OY Y坐标
 @return 实例
 */
+ (instancetype)createAuthToolViewOY:(CGFloat)OY{
    
    BankAuthToolView *view = [[BankAuthToolView alloc] initWithFrame:CGRectMake(0, OY, 0, 0)];
    return view;
    
}


- (instancetype)initWithFrame:(CGRect)frame{
    if ([super initWithFrame:frame]) {
        
        self.titleLab.text = @"选择银行";
        
        //BankAuthToolView不需要tip,因此在此子类中删除
        [self.tip removeFromSuperview];
        
        //设置选择银行卡按钮的样式
        [self setChooseBtnStyle];

        
    }return self;
    
    
}

- (void)setChooseBtnStyle{
    
    //BankAuthToolView不需要self.textfiled,因此在此子类中删除
    //BankAuthToolView不需要self.textfiled,需要用同样尺寸的button触发选择银卡事件,因此使用 chooseBankBtn 代替
    chooseBankBtn = [[UIButton alloc] init];
    chooseBankBtn.frame = self.textfiled.frame;
    [chooseBankBtn addTarget:self action:@selector(chooseClick:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:chooseBankBtn];
    [self.textfiled removeFromSuperview];
    
    
    //显示银行卡发卡行
    chooseBankTitleLab = [[UILabel alloc] init];
    chooseBankTitleLab.font = [UIFont fontWithName:@"PingFang-SC-Medium" size:14];
    chooseBankTitleLab.textColor = [UIColor colorWithRed:52/255.0 green:51/255.0 blue:57/255.0 alpha:0.7];
    chooseBankTitleLab.text = @"选择卡种及发卡行";
    [chooseBankBtn addSubview:chooseBankTitleLab];
    
    CGSize chooseBankTitleLabSize = [chooseBankTitleLab sizeThatFits:CGSizeZero];
    CGFloat chooseBankTitleLabOY = (chooseBankBtn.frame.size.height - chooseBankTitleLabSize.height)/2;
    chooseBankTitleLab.frame = CGRectMake(0, chooseBankTitleLabOY, chooseBankTitleLabSize.width*2, chooseBankTitleLabSize.height);
    
    
    //显示右边箭头
    UIImage *moreImg = [UIImage imageNamed:@"list_icon_more"];
    rightMoreImgV = [[UIImageView alloc] init];
    rightMoreImgV.image = moreImg;
    [chooseBankBtn addSubview:rightMoreImgV];
    
    CGFloat rightMoreImgVOX = chooseBankBtn.frame.size.width - moreImg.size.width;
    rightMoreImgV.frame = CGRectMake(rightMoreImgVOX, chooseBankTitleLabOY, moreImg.size.width, moreImg.size.height);
    
   
}

- (void)chooseClick:(UIButton*)btn{
    
    [BankPickerView showBankPickView:@[@[@"建设银行",@"工商银行",@"农业银行",@"中国银行",@"华夏银行",@"浦发银行",@"天地银行"],@[@"借记卡",@"信用卡"]] blockBankInfo:^(NSArray *bankInfo) {
    
        if (bankInfo.count > 0) {
            NSString * infoStr = [NSString stringWithFormat:@"%@ - %@",[bankInfo firstObject],[bankInfo lastObject]];
            chooseBankTitleLab.text = infoStr;
            //动态修改 -  chooseBankTitleLab.frame
            CGSize newSize = [chooseBankTitleLab sizeThatFits:CGSizeZero];
            CGRect newFrame = chooseBankTitleLab.frame;
            newFrame.size.width = newSize.width;
            chooseBankTitleLab.frame = newFrame;
        }

    }];
    
}


@end
