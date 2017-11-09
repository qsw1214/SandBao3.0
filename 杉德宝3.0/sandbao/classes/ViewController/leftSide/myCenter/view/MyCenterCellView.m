//
//  MyCenterCellView.m
//  sandbao
//
//  Created by tianNanYiHao on 2017/11/2.
//  Copyright © 2017年 sand. All rights reserved.
//

#import "MyCenterCellView.h"

@interface MyCenterCellView (){
    
    UIImageView *headImgView;
    UILabel *nickNameLab;
    UILabel *accountNoLab;
}

@end

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
    CGFloat space = 20;
    CGFloat rightImgeOX = CGRectGetMaxX(self.rightImgView.frame);
    
    if (_cellType == myCenterCellType_Head) {
        
        self.titleLab.text = @"头像";
        UIImage *headImg = [UIImage imageNamed:@"index_avatar"];
        headImgView = [[UIImageView alloc] init];
        headImgView.image = headImg;
        [self insertSubview:headImgView atIndex:1];
        
        CGFloat headImgViewOY = (self.frame.size.height - headImg.size.height)/2;
        CGFloat headImgViewOX = rightImgeOX - headImg.size.width - space;
        headImgView.frame = CGRectMake(headImgViewOX, headImgViewOY, headImg.size.width, headImg.size.height);
        
    }
    if (_cellType == myCenterCellType_Identity) {
        
        self.titleLab.text = @"身份认证";
        nickNameLab = [[UILabel alloc] init];
        nickNameLab.text = @"这里是昵称";
        nickNameLab.textAlignment = NSTextAlignmentRight;
        nickNameLab.font = [UIFont fontWithName:@"PingFangSC-Regular" size:13];
        nickNameLab.textColor = [UIColor colorWithRed:52/255.0 green:51/255.0 blue:57/255.0 alpha:1/1.0];
        [self insertSubview:nickNameLab atIndex:1];
        
        CGSize nickNameLabSize = [nickNameLab sizeThatFits:CGSizeZero];
        
        CGFloat nickNameLabOY = (self.frame.size.height - nickNameLabSize.height)/2;
        CGFloat nickNameLabOX = rightImgeOX - nickNameLabSize.width - space;
        nickNameLab.frame = CGRectMake(nickNameLabOX, nickNameLabOY, nickNameLabSize.width, nickNameLabSize.height);
    }
    if (_cellType == myCenterCellType_Account) {
        
        self.titleLab.text = @"杉德宝账号";
        accountNoLab = [[UILabel alloc] init];
        accountNoLab.text = @"000****0000";
        accountNoLab.textAlignment = NSTextAlignmentRight;
        accountNoLab.font = [UIFont fontWithName:@"PingFangSC-Regular" size:13];
        accountNoLab.textColor = [UIColor colorWithRed:52/255.0 green:51/255.0 blue:57/255.0 alpha:1/1.0];
        [self insertSubview:accountNoLab atIndex:1];
        
        CGSize accountNoLabSize = [accountNoLab sizeThatFits:CGSizeZero];
        
        CGFloat accountNoLabOY = (self.frame.size.height - accountNoLabSize.height)/2;
        CGFloat accountNoLabOX = rightImgeOX - accountNoLabSize.width - space;
        accountNoLab.frame = CGRectMake(accountNoLabOX, accountNoLabOY, accountNoLabSize.width, accountNoLabSize.height);
    }
    if (_cellType == myCenterCellType_ErCode) {
        
        self.titleLab.text = @"我的二维码";
        
    }
    if (_cellType == myCenterCellType_NameHead) {
        
        self.titleLab.text = @"我的发票抬头";
        
    }

}

- (void)setHeadIconImgStr:(NSString *)headIconImgStr{
    
    _headIconImgStr = headIconImgStr;
    headImgView.image = [UIImage imageNamed:_headIconImgStr];
}


- (void)setNickNameStr:(NSString *)nickNameStr{
    _nickNameStr = nickNameStr;
    nickNameLab.text = _nickNameStr;
}



- (void)setAccountNo:(NSString *)accountNo{
    
    _accountNo = accountNo;
    accountNoLab.text = _accountNo;
    
}

@end
