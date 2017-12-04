//
//  SandItemTableViewCell.h
//  sandbao
//
//  Created by tianNanYiHao on 2017/3/15.
//  Copyright © 2017年 sand. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SandItemTableViewCell : UITableViewCell

//size
@property (nonatomic, assign) CGSize viewSize;

//cell height
@property (nonatomic, assign) CGFloat cellHeight;

//dic
@property (nonatomic, strong) NSDictionary *dicData;

@end
