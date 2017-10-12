//
//  VerificationViewController.h
//  sandbao
//
//  Created by tianNanYiHao on 2017/1/19.
//  Copyright © 2017年 sand. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SDPayView.h"

@interface VerificationViewController : UIViewController<SDPayViewDelegate>

@property (nonatomic, strong) NSString *tokenType;
@property (nonatomic, strong) NSMutableDictionary *authGroupDic;

@end
