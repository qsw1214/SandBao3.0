//
//  MyCenterCellView.h
//  sandbao
//
//  Created by tianNanYiHao on 2017/11/2.
//  Copyright © 2017年 sand. All rights reserved.
//

#import "SetCellBaseView.h"

typedef NS_ENUM(NSInteger,MyCenterCellType){
    
    myCenterCellType_Head = 1,  //头像
    myCenterCellType_Identity, //身份认证
    myCenterCellType_Account,  //杉德宝账户
    myCenterCellType_ErCode,   //我的二维码
    myCenterCellType_NameHead, //公司抬头
};

@interface MyCenterCellView : SetCellBaseView

@property (nonatomic, assign) MyCenterCellType cellType;


@end
