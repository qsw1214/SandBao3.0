//
//  RXCheckout.m
//  sps2-dev
//
//  Created by Rick Xing on 6/28/13.
//  Copyright (c) 2013 Rick Xing. All rights reserved.
//

#import "RXCheckout.h"
#include "gv.h"
#include "RunCode.h"
#import "Global.h"
#import "RXSPSEntry.h"
#import "RXPayUI.h"
#import "RXSPSOperation.h"
#import "SVProgressHUD_sps.h"


#define BTN_TAG_START   100
#define iPhone5 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 1136), [[UIScreen mainScreen] currentMode].size) : NO)
#define IOS7 ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0 ? YES :NO)
@interface RXCheckout ()

@property (nonatomic, assign) CGSize viewSize;

@end

@implementation RXCheckout
@synthesize nav = _nav ;
@synthesize viewSize;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc{
    [payTypeLB release];
    [datapicker release];
    [titleArray release];
    [subPayTypes release];
    [_tableview release];
    [payToolsBtns[PayToolsMAX] release];
    [super dealloc];
}

- (void)buttonPayToolClicked:(id)sender
{
    [SVProgressHUD_sps show];
    payTools_Index = selectIndex;
    
    payCore.ptPath = ptPaths[payTools_Index];
    
//    NSLog(@"current ptPath=%d|%d|%d|%d|",
//          payCore.ptPath.i, payCore.ptPath.j, payCore.ptPath.k, payCore.ptPath.l);
    
    
    //Exchange
    
    RXSPSOperation * operation = [[[RXSPSOperation alloc] init] autorelease];
    operation.delegate = self;
    operation.ThreadCode = SPS_Thread_Code_Exchange;
    NSOperationQueue * operationQueue = [[[NSOperationQueue alloc] init] autorelease];
    [operationQueue addOperation:operation];
}

- (void)datapickButtonClicked:(id)sender{
    [self.view addSubview:datapicker.view];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    viewSize = self.view.bounds.size;
    [Global set_CheckoutDelegate:self];
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    [self.navigationController.navigationBar setBackgroundColor:[UIColor clearColor]];

    self.view.backgroundColor = [UIColor colorWithRed:242.0/255.0 green:236.0/255.0 blue:231.0/255.0 alpha:1.0];
    
    self.view.frame = CGRectMake(0, 0, viewSize.width, viewSize.height);
    
//    _tableview = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, viewSize.width, 260) style:UITableViewStyleGrouped];
    
//    if (self.presentingViewController) {
//        NSLog(@"presentingViewController");
//        _tableview = [[UITableView alloc] initWithFrame:CGRectMake(0, [[UIApplication sharedApplication] statusBarFrame].size.height, viewSize.width,260 + [[UIApplication sharedApplication] statusBarFrame].size.height) style:UITableViewStyleGrouped];
//    } else {
//        NSLog(@"pushViewController");
//        _tableview = [[UITableView alloc] initWithFrame:CGRectMake(0, [[UIApplication sharedApplication] statusBarFrame].size.height, viewSize.width,260) style:UITableViewStyleGrouped];
//    }
    
//    NSLog(@"self.navigationController.navigationBar.frame.size.height:%f", self.navigationController.navigationBar.frame.size.height);
//    
    if (self.navigationController.topViewController == self) {
        _tableview = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, viewSize.width, 260) style:UITableViewStyleGrouped];
    } else {
        _tableview = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, viewSize.width,260) style:UITableViewStyleGrouped];
    }
    
    _tableview.delegate = self;
    _tableview.dataSource = self;
    _tableview.scrollEnabled = NO ;
    _tableview.backgroundView = nil;
    _tableview.backgroundColor = [UIColor clearColor];

    [self.view addSubview:_tableview];
    
    titleArray = [[NSMutableArray alloc] init];
    [titleArray addObject:[NSString stringWithFormat:@"订单号:%@", [NSString stringWithUTF8String: payCore.order_id.Buffer()]]];
    [titleArray addObject:[NSString stringWithFormat:@"订单日期:%@", [NSString stringWithUTF8String: payCore.order_time.Buffer()]]];
    [titleArray addObject:[NSString stringWithFormat:@"订单金额:%@", [NSString stringWithFormat:@"%.2f元",[[NSString stringWithUTF8String: payCore.order_amount.Buffer()] intValue] / 100.0 ]]];
    [titleArray addObject:[NSString stringWithFormat:@"商户名称:%@", [NSString stringWithUTF8String: payCore.merName.Buffer()]]];
    [titleArray addObject:[NSString stringWithFormat:@"交易号:%@", [NSString stringWithUTF8String: payCore.oId.Buffer()]]];
    
    
    subPayTypes = [[NSMutableArray alloc] init];
    int index = 0;
    for(int i = 0; i < payCore.kids_len; i++)
    {
        NSLog(@"i == %d  payCore.kids_len = %d",i,payCore.kids_len);
        int num_of_valid_orgids = 0;
        for(int j = 0; j < payCore.kids[i].tids_len; j++)
        {
            NSLog(@"j == %d  payCore.kids_len = %d",j,payCore.kids[i].tids_len);
            for(int k = 0; k < payCore.kids[i].tids[j].orgids_len; k++)
            {
                
                NSLog(@"k == %d  payCore.kids[i].tids[j].orgids_len = %d",j,payCore.kids[i].tids[j].orgids_len);
                NSLog(@"valid ====%d",payCore.kids[i].tids[j].orgids[k]._valid);
                if(payCore.kids[i].tids[j].orgids[k]._valid)
                {
                    
                    
                    num_of_valid_orgids++;
                }
            }
        }
        
        if(num_of_valid_orgids == 0)
        {
            continue;
        }
        
        NSLog(@"num_of_valid_orgids ===%d",num_of_valid_orgids);
        
        for(int j = 0; j < payCore.kids[i].tids_len; j++)
        {
            
            for(int k = 0; k < payCore.kids[i].tids[j].orgids_len; k++)
            {
                
                NSLog(@"j==%d  k=== %d   _valid==%d",j,k,payCore.kids[i].tids[j].orgids[k]._valid);
                if(payCore.kids[i].tids[j].orgids[k]._valid)
                {
                    if(payCore.kids[i].tids[j].orgids[k].cardaccs_len > 0)
                    {
                        for(int l = 0; l < payCore.kids[i].tids[j].orgids[k].cardaccs_len; l++)
                        {
                            ptPaths[index].i = i;
                            ptPaths[index].j = j;
                            ptPaths[index].k = k;
                            ptPaths[index].l = l;
                            //02 A01 B000001
                        
                            
                            NSMutableString* btn_text = [[[NSMutableString alloc] init] autorelease];
                            [btn_text appendFormat:@"%@", [NSString stringWithUTF8String:payCore.kids[i].tids[j].orgids[k].payservcie_description.Buffer()]];
                            if(payCore.kids[i].kid == "02"
                               && payCore.kids[i].tids[j].tid == "A01"
                               && payCore.kids[i].tids[j].orgids[k].orgid == "B0000001"){
                                [btn_text appendFormat:@"(***%@)",
                                 [NSString stringWithUTF8String:payCore.kids[i].tids[j].orgids[k].cardaccs[l].medium.Right(4).Buffer()]];
                            }else{
                               [btn_text appendFormat:@"(余额:%@元)",[NSString stringWithFormat:@"%.2f", [[NSString stringWithUTF8String: payCore.kids[i].tids[j].orgids[k].cardaccs[l].accBal.Buffer()] intValue] / 100.0 ]];
                            }
                            

                            payTools_Text[index] = [btn_text UTF8String];
                        
                            NSArray *subs = [btn_text componentsSeparatedByString:@"手机"];
                            if(subs.count==2){
                                [subPayTypes addObject:[subs objectAtIndex:1]];
                            }else{
                                [subPayTypes addObject:[subs objectAtIndex:0]];
                            }
                            
                            payToolsBtns[index] = [UIButton buttonWithType:UIButtonTypeRoundedRect];
                            //payToolsBtns[index].backgroundColor = [UIColor brownColor];
                            payToolsBtns[index].tag = BTN_TAG_START + index;
                            [payToolsBtns[index] setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
                            [payToolsBtns[index] setTitle:btn_text forState:UIControlStateNormal];
                            [payToolsBtns[index] addTarget:self action:@selector(buttonPayToolClicked:) forControlEvents:UIControlEventTouchUpInside];
                            index++;
                            
                        } // l
                    }
                    else
                    {
                        ptPaths[index].i = i;
                        ptPaths[index].j = j;
                        ptPaths[index].k = k;
                        ptPaths[index].l = -1;
                        
//                        NSLog(@"kid== %d  tid== %d  orgid== %d  ",payCore.kids[i].kid, payCore.kids[i].tids[j].tid,payCore.kids[i].tids[j].orgids[k].orgid );
                        if(payCore.kids[i].kid == "02"
                           && payCore.kids[i].tids[j].tid == "A01"
                           && payCore.kids[i].tids[j].orgids[k].orgid == "B0000001"){
                        }else{
                            NSMutableString* btn_text = [[[NSMutableString alloc] init] autorelease];
                            [btn_text appendFormat:@"%@", [NSString stringWithUTF8String:payCore.kids[i].tids[j].orgids[k].payservcie_description.Buffer()]];
                            payTools_Text[index] = [btn_text UTF8String];
                            
                            NSArray *subs = [btn_text componentsSeparatedByString:@"手机"];
                            if(subs.count==2){
                                if([[subs objectAtIndex:1] isEqualToString:@"银联"]){
                                    [subPayTypes addObject:@"银联手机支付"];
                                }else{
                                    [subPayTypes addObject:[subs objectAtIndex:1]];
                                }
                            }else{
                                [subPayTypes addObject:[subs objectAtIndex:0]];
                            }
                            
                            payToolsBtns[index] = [UIButton buttonWithType:UIButtonTypeRoundedRect];
                            //payToolsBtns[index].backgroundColor = [UIColor brownColor];
                            payToolsBtns[index].tag = BTN_TAG_START + index;
                            [payToolsBtns[index] setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
                            [payToolsBtns[index] setTitle:btn_text forState:UIControlStateNormal];
                            [payToolsBtns[index] addTarget:self action:@selector(buttonPayToolClicked:) forControlEvents:UIControlEventTouchUpInside];
                            
                            index++;
                        }
                        
                    }
                }
            } // k
        } // j
    } // i

    UILabel *titleLB = [[UILabel alloc] init] ;
    titleLB.frame = CGRectMake(10, CGRectGetMaxY(_tableview.frame), viewSize.width - 2 * 10, 20) ;
    titleLB.text = @"选择支付方式";
    titleLB.font = [UIFont boldSystemFontOfSize:17];
    titleLB.backgroundColor = [UIColor clearColor];
    [self.view addSubview:titleLB];
    [titleLB release];
    
    UIButton *payTypeButton = [[UIButton alloc]init];
    payTypeButton.frame = CGRectMake(10, CGRectGetMaxY(titleLB.frame) + 10, viewSize.width - 2 * 10, 36);
    NSString *payTypeBG =[[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"sandpay.bundle/images/sps_paybutton.png"];
   [payTypeButton setBackgroundImage:[UIImage imageWithContentsOfFile:payTypeBG] forState:UIControlStateNormal];
    [payTypeButton addTarget:self action:@selector(datapickButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:payTypeButton];
    [payTypeButton release];
    
    payTypeLB = [[UILabel alloc]init];
    payTypeLB.frame = CGRectMake(15, CGRectGetMaxY(titleLB.frame) + 10, viewSize.width - 2 * 10, 36);
    payTypeLB.text = [subPayTypes objectAtIndex:selectIndex] ;
    payTypeLB.font = [UIFont boldSystemFontOfSize:17];
    payTypeLB.textColor = [UIColor blackColor];
    payTypeLB.textAlignment = NSTextAlignmentLeft;
    payTypeLB.backgroundColor = [UIColor clearColor];
    [self.view addSubview:payTypeLB];
    
    UIButton *payButon = [[UIButton alloc]initWithFrame:CGRectMake(10, CGRectGetMaxY(payTypeButton.frame) + 34, viewSize.width - 2 * 10, 36)];
    [payButon setTitle:@"下一步" forState:UIControlStateNormal];
    [payButon setTintColor:[UIColor blackColor]];
    [payButon addTarget:self action:@selector(buttonPayToolClicked:) forControlEvents:UIControlEventTouchUpInside];
    [payButon setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [payButon.titleLabel setFont:[UIFont boldSystemFontOfSize:20]];
    NSString *backBG = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"sandpay.bundle/images/sps_nextbutton.png"];
    [payButon setBackgroundImage:[UIImage imageWithContentsOfFile:backBG] forState:UIControlStateNormal];
    [self.view addSubview:payButon];
    [payButon release];
    
    datapicker = [[DataPickViewController_sps alloc]init];
    datapicker.delegate = self ;
    [datapicker selectRow:0 inComponent:0 animated:YES];
    [datapicker reSetItemArrays:[NSArray arrayWithObjects:subPayTypes, nil]];
}


- (IBAction)buttonCancelClicked:(id)sender
{
    [self dismissModalViewControllerAnimated:NO];
//    [self.navigationController popViewControllerAnimated:YES];
    RunCode = RunCode_User_Cancel;
    [[Global get_BridgeDelegate] ExitSps];
}

-(void)OperationEnd:(NSNumber*)runCode
{
    RunCode = [runCode intValue];
//    NSLog(@"OperationEnd:%d", RunCode);
    
    /*
    if(RunCode == RunCode_Ok)
    {
        [SVProgressHUD_sps dismiss];
        NSLog(@"kid:%s\ntid:%s\norgid:%s\n", payCore.kids[payCore.ptPath.i].kid.Buffer(),
              payCore.kids[payCore.ptPath.i].tids[payCore.ptPath.j].tid.Buffer(),
              payCore.kids[payCore.ptPath.i].tids[payCore.ptPath.j].orgids[payCore.ptPath.k].orgid.Buffer());

        RXPayUI* payui = [[[RXPayUI alloc] init] autorelease];
        [self presentModalViewController:payui animated:YES];
        
    }
    else
    {
        UIAlertView * alertView =[[UIAlertView alloc]
                                  initWithTitle:@"操作终止"
                                  message:[NSString stringWithFormat:@"错误码：%08x", RunCode]
                                  delegate:self
                                  cancelButtonTitle:@"退出"
                                  otherButtonTitles:nil];
        [alertView show];
        [alertView release];
    }*/
    if(RunCode == RunCode_Ok)
    {
        [SVProgressHUD_sps dismiss];
        if(payCore.kids[payCore.ptPath.i].kid == "09"
           && payCore.kids[payCore.ptPath.i].tids[payCore.ptPath.j].tid == "B03"
           && payCore.kids[payCore.ptPath.i].tids[payCore.ptPath.j].orgids[payCore.ptPath.k].orgid == "A0000001")
        {
//            RXUnionPay* payui = [[[RXUnionPay alloc] init] autorelease];
//            [_nav pushViewController:payui animated:YES];
        }
        else
        {
            RXPayUI* payui = [[[RXPayUI alloc] init] autorelease];
            [_nav pushViewController:payui animated:YES];
        }
    }else if(RunCode == RunCode_PayCore_Error){
       [SVProgressHUD_sps dismissWithError:[NSString stringWithUTF8String:payCore.respResult.Buffer()]];
        
    }else if(RunCode == RunCode_Network_Error){
        [SVProgressHUD_sps dismissWithError:@"网络通信异常,请重试!"];
    }else{
        [SVProgressHUD_sps dismissWithError:@"处理异常,请重试!"];
    }
}

- (void)dismiss
{
    [self dismissModalViewControllerAnimated:NO];
//    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark
#pragma tableview datasource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if(section ==0){
        return  titleArray.count;
    }else{
        return 1;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *CellIdentifier = @"CellIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if(cell ==nil){
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier];
    }
    

    NSArray *subs = [[titleArray objectAtIndex:[indexPath row]] componentsSeparatedByString:@":"];
    cell.textLabel.text = [subs objectAtIndex:0];
    cell.detailTextLabel.text = [subs objectAtIndex:1];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.textLabel.textColor = [UIColor blackColor];
    cell.textLabel.font = [UIFont boldSystemFontOfSize:17];
    cell.backgroundColor = [UIColor whiteColor];
    return cell ;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    return @"订单信息";
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 36 ;
}


#pragma mark Data Picker Delegate

- (void)dataPickSelectIndexArray:(NSArray*)indexArray{
    NSInteger index = [[indexArray objectAtIndex:0] intValue];
    selectIndex = index;
    payTypeLB.text = [subPayTypes objectAtIndex:selectIndex];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [_tableview reloadData];
}

@end
