//
//  BankItemTableViewCell.h
//  sandbao
//
//  Created by tianNanYiHao on 2017/2/13.
//  Copyright © 2017年 sand. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BankItemTableViewCell : UITableViewCell

//size
@property (nonatomic, assign) CGSize viewSize;

//cell height
@property (nonatomic, assign) CGFloat cellHeight;

//dic
@property (nonatomic, strong) NSDictionary *dicData;



@end
