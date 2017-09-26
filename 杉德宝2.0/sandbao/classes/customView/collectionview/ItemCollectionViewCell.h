//
//  ItemCollectionViewCell.h
//  sandbaocontrol
//
//  Created by tianNanYiHao on 2016/11/2.
//  Copyright © 2016年 sand. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DataModel.h"
#import "ExternStringDefine.h"



@class DataModel;

@interface ItemCollectionViewCell : UICollectionViewCell

@property (nonatomic, strong) DataModel *dataModel;

- (void)resetModel:(DataModel *)dataModel :(NSIndexPath *)indexPath;

@end
