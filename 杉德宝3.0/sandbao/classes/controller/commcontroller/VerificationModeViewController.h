//
//  VerificationModeViewController.h
//  sandbao
//
//  Created by tianNanYiHao on 2017/1/19.
//  Copyright © 2017年 sand. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface VerificationModeViewController : UIViewController<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) NSString *tokenType;
@property (nonatomic, assign) BOOL tokenTypeFalg;

@end
