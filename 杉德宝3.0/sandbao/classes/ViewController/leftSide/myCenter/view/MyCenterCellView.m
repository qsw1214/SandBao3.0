//
//  MyCenterCellView.m
//  sandbao
//
//  Created by tianNanYiHao on 2017/11/2.
//  Copyright © 2017年 sand. All rights reserved.
//

#import "MyCenterCellView.h"

@implementation MyCenterCellView


+ (instancetype)createSetCellViewOY:(CGFloat)OY{
    MyCenterCellView *cell = [[MyCenterCellView alloc] initWithFrame:CGRectMake(0, OY, 0, 0)];
    return cell;
}

- (instancetype)initWithFrame:(CGRect)frame{
    
    if ([super initWithFrame:frame]) {
        self.backgroundColor = [UIColor whiteColor];
        self.titleStr = @"这里是标题";
        self.rightImgStr = @"center_profile_arror_right";
    }
    return self;
    
}

- (void)setCellType:(MyCenterCellType)cellType{
    
    _cellType = cellType;
    
    if (_cellType == myCenterCellType_Head) {
        
        self.titleLab.text = @"头像";
        
    }
    if (_cellType == myCenterCellType_Identity) {
        
        self.titleLab.text = @"身份认证";
        
    }
    if (_cellType == myCenterCellType_Account) {
        
        self.titleLab.text = @"杉德宝账号";
        
    }
    if (_cellType == myCenterCellType_ErCode) {
        
        self.titleLab.text = @"我的二维码";
        
    }
    if (_cellType == myCenterCellType_NameHead) {
        
        self.titleLab.text = @"我的发票抬头";
        
    }

    
    
}


@end
