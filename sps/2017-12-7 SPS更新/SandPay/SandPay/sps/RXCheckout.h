//
//  RXCheckout.h
//  sps2-dev
//
//  Created by Rick Xing on 6/28/13.
//  Copyright (c) 2013 Rick Xing. All rights reserved.
//

#import <UIKit/UIKit.h>

#include "xstring.h"
using namespace sz;

#include "gv.h"
#import "DataPickViewController_sps.h"

@interface RXCheckout : UIViewController<DataPickViewControllerDelgate,UITableViewDataSource,UITableViewDelegate>
{
    UIButton * payToolsBtns[PayToolsMAX];
    UILabel *payTypeLB ;
    DataPickViewController_sps *datapicker;
    NSMutableArray *titleArray;
    NSMutableArray *subPayTypes;
    NSInteger selectIndex ;
    UITableView *_tableview;
}
@property(nonatomic,strong) UINavigationController *nav ;
- (void)dismiss;

@end
