//
//  ConsumeRechargeViewController.h
//  sandbao
//
//  Created by tianNanYiHao on 2017/3/27.
//  Copyright © 2017年 sand. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SDPayView.h"

@interface ConsumeRechargeViewController : UIViewController<SDPayViewDelegate>


@property (nonatomic, strong) NSString *tTokenType;
@property (nonatomic, strong) NSMutableDictionary *consumePayToolDic;
@property (nonatomic, assign) NSInteger controllerIndex;
@end
