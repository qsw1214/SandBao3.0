//
//  Rwatch.cpp
//  ItestXC
//
//  Created by Rick Xing on 16/6/3.
//  Copyright © 2016年 SAND. All rights reserved.
//

#include "Rwatch.h"
#include "RXBluetooth_38901.h"
#include <memory.h>

#import <Foundation/Foundation.h>


int rwatch_timeout_ms = 10000;

bool rwatch_TransmitApdu(NSData * apdu, NSMutableData * sw1sw2, NSMutableData * resp_data)
{
    int send_data_len = 1 + [apdu length];
    unsigned char send_data[512] = {0};
    memset(send_data, 0x00, 1);
    memcpy(send_data + 1, [apdu bytes], [apdu length]);
    
    unsigned char recv_data[512] = {0};
    int recv_data_len = 0;
    bool r = bt_trans_with_protocol(send_data, send_data_len, recv_data, &recv_data_len, rwatch_timeout_ms);
    
    if(!r)
        return false;
    if(recv_data_len < 4)
        return false;
    
    int resp_data_len = recv_data_len - 4;

    NSData * sw1sw2_ = [NSData dataWithBytes:recv_data + 1 length:2];
    NSData * resp_data_ = [NSData dataWithBytes:recv_data + 4 length:resp_data_len];
    
    [sw1sw2 setData:sw1sw2_];
    [resp_data setData:resp_data_];

    
    NSLog(@"[APDU] SEND%@  RECV SW1SW2%@ DATA%@",
          apdu,
          sw1sw2,
          resp_data
          );
    
    return true;
}

bool rwatch_power_on(void)
{
    int send_data_len = 2;
    unsigned char send_data[512] = {0};
    send_data[0] = 0x01;
    send_data[1] = 0x01; // power on
    
    unsigned char recv_data[512] = {0};
    int recv_data_len = 0;
    bool r = bt_trans_with_protocol(send_data, send_data_len, recv_data, &recv_data_len, rwatch_timeout_ms);
    if(!r)
        return false;
    if(recv_data_len != 4)
        return false;
    if(recv_data[1] == 0x90 && recv_data[2] == 0x00)
        return true;
    else
        return false;
}

bool rwatch_power_off(void)
{
    int send_data_len = 2;
    unsigned char send_data[512] = {0};
    send_data[0] = 0x01;
    send_data[1] = 0x02; // power off
    
    unsigned char recv_data[512] = {0};
    int recv_data_len = 0;
    bool r = bt_trans_with_protocol(send_data, send_data_len, recv_data, &recv_data_len, rwatch_timeout_ms);
    if(!r)
        return false;
    if(recv_data_len != 4)
        return false;
    if(recv_data[1] == 0x90 && recv_data[2] == 0x00)
        return true;
    else
        return false;
}





