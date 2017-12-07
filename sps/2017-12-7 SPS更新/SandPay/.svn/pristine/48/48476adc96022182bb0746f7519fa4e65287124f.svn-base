//
//  DataPickViewController.h
//  SandLiftPreview
//
//  Created by lin peng on 23/08/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol DataPickViewControllerDelgate 

- (void)dataPickSelectIndexArray:(NSArray*)indexArray;

@end

@interface DataPickViewController_sps : UIViewController<UIPickerViewDelegate,UIPickerViewDataSource>{
    UIPickerView *dataPicker;
    UIToolbar *toolbar;
    NSArray *_itemArrays ;
    NSMutableArray *_indexArray ;
}

@property(nonatomic,retain) NSArray *itemArrays ;
@property(nonatomic,assign) id<DataPickViewControllerDelgate>delegate ;
- (void)reSetItemArrays:(NSArray *)itemArrays;
- (void)selectRow:(NSInteger)row inComponent:(NSInteger)component animated:(BOOL)animated;
@end
