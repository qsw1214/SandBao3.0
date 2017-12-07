//
//  DataPickViewController.m
//  SandLiftPreview
//
//  Created by lin peng on 23/08/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "DataPickViewController_sps.h"

@interface DataPickViewController_sps ()

@property (nonatomic, assign) CGSize viewSize;

@end

@implementation DataPickViewController_sps
#define IOS7 ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0 ? YES :NO)
@synthesize delegate;
@synthesize  itemArrays = _itemArrays  ;
@synthesize viewSize;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
       
    }
    return self;
}



- (void)resignKeyBoard:(id)sender{
    [self.delegate dataPickSelectIndexArray:_indexArray];
    [self.view removeFromSuperview];
}

- (void)cancelButtonClikced:(id)sender{
    [self.view removeFromSuperview];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    viewSize = self.view.bounds.size;
    // Do any additional setup after loading the view from its nib.
    _indexArray = [[NSMutableArray alloc] init];
    if(IOS7){
        dataPicker = [[UIPickerView alloc]initWithFrame:CGRectMake(0, viewSize.height -216, viewSize.width, 216)];
        toolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, viewSize.height -216-44, viewSize.width, 44)];
    }else{
        dataPicker = [[UIPickerView alloc]initWithFrame:CGRectMake(0, viewSize.height -216-44-20, viewSize.width, 216)];
        toolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, viewSize.height -216-88-20, viewSize.width, 44)];
    }

    dataPicker.showsSelectionIndicator =YES ;
    dataPicker.delegate = self ;
    dataPicker.dataSource = self ;
    dataPicker.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin|UIViewAutoresizingFlexibleRightMargin|UIViewAutoresizingFlexibleTopMargin;
    dataPicker.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:dataPicker];

    toolbar.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin|UIViewAutoresizingFlexibleRightMargin|UIViewAutoresizingFlexibleTopMargin;
    toolbar.barStyle = UIBarStyleBlackTranslucent;
    
    UIBarButtonItem *spaceBarItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil] ;
    
    UIBarButtonItem *doneBarItem = [[UIBarButtonItem alloc] initWithTitle:@"完成" style:UIBarButtonItemStyleDone target:self action:@selector(resignKeyBoard:)] ;
    
    toolbar.items = [NSArray arrayWithObjects:spaceBarItem, doneBarItem, nil];
    [self.view addSubview:toolbar];
    
    for (NSInteger i=0  ; i < [_itemArrays count]; i++) {
        [_indexArray addObject:[NSNumber numberWithInt:0]];
    }
      
    [dataPicker reloadAllComponents];
}

- (void)reSetItemArrays:(NSArray *)itemArrays{
    self.itemArrays = itemArrays ;
    [_indexArray removeAllObjects];
    for (NSInteger i=0  ; i < [_itemArrays count]; i++) {
        [_indexArray addObject:[NSNumber numberWithInt:0]];
    }
    [dataPicker reloadAllComponents];
 
}


#pragma mark UIPickerViewDelegate
- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    NSArray *titles = [_itemArrays objectAtIndex:component];
    return [titles objectAtIndex:row];
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    [_indexArray replaceObjectAtIndex:component withObject:[NSNumber numberWithInt:row]];
}

- (void)selectRow:(NSInteger)row inComponent:(NSInteger)component animated:(BOOL)animated{
    [_indexArray replaceObjectAtIndex:component withObject:[NSNumber numberWithInt:row]];
    [dataPicker selectRow:row inComponent:component animated:animated];
}

#pragma mark UIPickerViewDataSource
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return [_itemArrays count] ;
}


- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    return [[_itemArrays objectAtIndex:component] count];
}


- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
    

}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
