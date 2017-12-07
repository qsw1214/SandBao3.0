//
//  Rwatch.h
//  ItestXC
//
//  Created by Rick Xing on 16/6/3.
//  Copyright © 2016年 SAND. All rights reserved.
//

#ifndef Rwatch_h
#define Rwatch_h

#import <Foundation/Foundation.h>

bool rwatch_TransmitApdu(NSData * apdu, NSMutableData * sw1sw2, NSMutableData * resp_data);
bool rwatch_power_on(void);
bool rwatch_power_off(void);


#endif /* Rwatch_hpp */
