//
//  ScannerViewController.h
//  collectionTreasure
//
//  Created by tianNanYiHao on 15/7/9.
//  Copyright (c) 2015年 sand. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ScannerViewControllerDelegate <NSObject>
-(void)scanResult:(NSString *)result;
@end

@interface ScannerViewController : UIViewController

@property (nonatomic,assign) id<ScannerViewControllerDelegate> delegate;

@end
