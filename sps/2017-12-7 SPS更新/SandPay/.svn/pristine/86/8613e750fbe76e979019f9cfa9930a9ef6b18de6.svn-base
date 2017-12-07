//
//  RXSPSOperation.h
//  sps2-dev
//
//  Created by Rick Xing on 6/24/13.
//  Copyright (c) 2013 Rick Xing. All rights reserved.
//

#import <Foundation/Foundation.h>
#include "xhead.h"
#include "xstring.h"
using namespace sz;
#define SPS_Thread_Code_Loading             1
#define SPS_Thread_Code_Exchange            2
#define SPS_Thread_Code_Pay                 3
#define SPS_Thread_Code_3Steps              4
#define SPS_Thread_Code_UnionPay            5
#define SPS_Thread_Code_RechargePay         6
#define SPS_Thread_Code_shortMsg            7

@interface RXSPSOperation : NSOperation
{
    id delegate;
    int ThreadCode;
    int ReturnCode;
}
@property (retain) id delegate;
@property int ThreadCode;
@property int ReturnCode;

- (XString)Transmit:(XString)data;
@end
