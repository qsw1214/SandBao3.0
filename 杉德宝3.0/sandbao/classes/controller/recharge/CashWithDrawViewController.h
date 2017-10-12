//
//  CashWithDrawViewController.h
//  sandbao
//
//  Created by tianNanYiHao on 2017/3/9.
//  Copyright © 2017年 sand. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SDPayView.h"

@interface CashWithDrawViewController : UIViewController<SDPayViewDelegate>

@property (nonatomic, strong) NSString *tTokenType;
@property (nonatomic, strong) NSMutableDictionary *cashPayToolDic;

@end
