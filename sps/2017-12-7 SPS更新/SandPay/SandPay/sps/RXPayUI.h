//
//  RXPayUI.h
//  sps2-dev
//
//  Created by Rick Xing on 7/2/13.
//  Copyright (c) 2013 Rick Xing. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SandUPPayDelegate.h"

@interface RXPayUI : UIViewController <SandUPPayDelegate ,UITextFieldDelegate> {
    int payMode;
}

@property (nonatomic, strong) UITextField *textCard, *textFieldShortMsg;
@property (nonatomic, strong) UILabel *textPass;

@end
