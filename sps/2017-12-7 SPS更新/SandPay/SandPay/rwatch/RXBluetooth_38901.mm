//
//  RXBluetooth_38901.m
//  ItestXC
//
//  Created by Rick Xing on 16/6/1.
//  Copyright © 2016年 SAND. All rights reserved.
//

#import "RXBluetooth_38901.h"
#import "RXBluetooth_Helper.h"

/*
 STX-LEN-APP-ETF-DATA-ETX-LRC
 LEN = length(APP ~ LRC)
 LRC = lrc(APP ~ ETX)
 DATA = DATA_TYPE + DATA_CONTENT
 */

bool bt_trans_with_protocol_0(unsigned char * send_data, int send_data_len, unsigned char * recv_data, int * recv_data_len, int timeout_ms)
{
    unsigned char * send_msg = new unsigned char [6 + send_data_len];
    memset(send_msg, 0, 6 + send_data_len);
    int send_msg_len = 0;
    
    unsigned char STX = 0x02;
    unsigned char LEN = 2 + send_data_len + 2;
    unsigned char APP = 0xA2;
    unsigned char ETF = 0x00;
    unsigned char ETX = 0x03;
    unsigned char LRC = 0x00;
    
    LRC ^= APP;
    LRC ^= ETF;
    for(int i = 0; i < send_data_len; i++)
    {
        LRC ^= send_data[i];
    }
    LRC ^= ETX;
    
    memcpy(send_msg + send_msg_len, &STX, 1);                   send_msg_len += 1;
    memcpy(send_msg + send_msg_len, &LEN, 1);                   send_msg_len += 1;
    memcpy(send_msg + send_msg_len, &APP, 1);                   send_msg_len += 1;
    memcpy(send_msg + send_msg_len, &ETF, 1);                   send_msg_len += 1;
    memcpy(send_msg + send_msg_len, send_data, send_data_len);  send_msg_len += send_data_len;
    memcpy(send_msg + send_msg_len, &ETX, 1);                   send_msg_len += 1;
    memcpy(send_msg + send_msg_len, &LRC, 1);                   send_msg_len += 1;
    
    NSData * msg = [NSData dataWithBytes:send_msg length:send_msg_len];
    
    //----
    
    btHelper.RecvFinished = false;
    
    //Byte sendbytes[12] = {0x20, 0x20, 0x20, 0x20, 0xF1, 0x0d, 0x00, 0x04, 0xF1, 0x08, 0x00, 0x05};
    //NSData * msg = [NSData dataWithBytes:sendbytes length:12];
    
    [btHelper.Peripheral writeValue:msg forCharacteristic:btHelper.Characteristic_TX type:CBCharacteristicWriteWithResponse];

    NSLog(@"btHelper.Peripheral writeValue : %@", msg);
    
    delete [] send_msg;
    
    //----
    
    int count_ms = 0;
    while (!btHelper.RecvFinished) {
        // timeout
        if(count_ms > timeout_ms)
            break;
        [NSThread sleepForTimeInterval:0.1];
        count_ms += 100;
    }
    
    if(count_ms > timeout_ms)
    {
        NSLog(@"Recv Timeout:%d ms", timeout_ms);
        *recv_data_len = 0;
        return false;
    }
    else
    {
        *recv_data_len = [btHelper.RecvData length];
        memcpy(recv_data, (unsigned char *)[btHelper.RecvData bytes], *recv_data_len);
        
        //NSLog(@"{recv_data} %@", btHelper.RecvData);
        
        return true;
    }
}


bool bt_trans_with_protocol(unsigned char * send_data, int send_data_len, unsigned char * recv_data, int * recv_data_len, int timeout_ms)
{
    int trans_max_len = 20;  //bytes
    int protocol_format_len = 6;
    int data_block_len = trans_max_len - protocol_format_len;
    int have_ETF_num = send_data_len % data_block_len ? send_data_len / data_block_len : send_data_len / data_block_len - 1;
    
    btHelper.RecvFinished = false;
    
    for(int i = 0; i < have_ETF_num; i++)
    {
        unsigned char * send_msg = new unsigned char [protocol_format_len + data_block_len];
        memset(send_msg, 0, protocol_format_len + data_block_len);
        int send_msg_len = 0;
        
        unsigned char * data_block = new unsigned char [data_block_len];
        memset(data_block, 0, data_block_len);
        memcpy(data_block, send_data + i * data_block_len, data_block_len);
        
        unsigned char STX = 0x02;
        unsigned char LEN = 2 + data_block_len + 2;
        unsigned char APP = 0xA2;
        unsigned char ETF = 0x01;
        unsigned char ETX = 0x03;
        unsigned char LRC = 0x00;
        
        LRC ^= APP;
        LRC ^= ETF;
        for(int i = 0; i < data_block_len; i++)
        {
            LRC ^= data_block[i];
        }
        LRC ^= ETX;
        
        memcpy(send_msg + send_msg_len, &STX, 1);                       send_msg_len += 1;
        memcpy(send_msg + send_msg_len, &LEN, 1);                       send_msg_len += 1;
        memcpy(send_msg + send_msg_len, &APP, 1);                       send_msg_len += 1;
        memcpy(send_msg + send_msg_len, &ETF, 1);                       send_msg_len += 1;
        memcpy(send_msg + send_msg_len, data_block, data_block_len);    send_msg_len += data_block_len;
        memcpy(send_msg + send_msg_len, &ETX, 1);                       send_msg_len += 1;
        memcpy(send_msg + send_msg_len, &LRC, 1);                       send_msg_len += 1;
        
        NSData * msg = [NSData dataWithBytes:send_msg length:send_msg_len];
        
        [btHelper.Peripheral writeValue:msg forCharacteristic:btHelper.Characteristic_TX type:CBCharacteristicWriteWithResponse];
        
        NSLog(@"Send value: %@", msg);
        
        delete [] send_msg;
        delete [] data_block;
    }
    {
        unsigned char * send_msg = new unsigned char [protocol_format_len + data_block_len];
        memset(send_msg, 0, protocol_format_len + data_block_len);
        int send_msg_len = 0;
        
        int surplus_data_len = send_data_len - have_ETF_num * data_block_len;
        unsigned char * data_block = new unsigned char [surplus_data_len];
        memset(data_block, 0, surplus_data_len);
        memcpy(data_block, send_data + have_ETF_num * data_block_len, surplus_data_len);
        
        unsigned char STX = 0x02;
        unsigned char LEN = 2 + surplus_data_len + 2;
        unsigned char APP = 0xA2;
        unsigned char ETF = 0x00;
        unsigned char ETX = 0x03;
        unsigned char LRC = 0x00;
        
        LRC ^= APP;
        LRC ^= ETF;
        for(int i = 0; i < surplus_data_len; i++)
        {
            LRC ^= data_block[i];
        }
        LRC ^= ETX;
        
        memcpy(send_msg + send_msg_len, &STX, 1);                       send_msg_len += 1;
        memcpy(send_msg + send_msg_len, &LEN, 1);                       send_msg_len += 1;
        memcpy(send_msg + send_msg_len, &APP, 1);                       send_msg_len += 1;
        memcpy(send_msg + send_msg_len, &ETF, 1);                       send_msg_len += 1;
        memcpy(send_msg + send_msg_len, data_block, surplus_data_len);  send_msg_len += surplus_data_len;
        memcpy(send_msg + send_msg_len, &ETX, 1);                       send_msg_len += 1;
        memcpy(send_msg + send_msg_len, &LRC, 1);                       send_msg_len += 1;
        
        NSData * msg = [NSData dataWithBytes:send_msg length:send_msg_len];
        
        [btHelper.Peripheral writeValue:msg forCharacteristic:btHelper.Characteristic_TX type:CBCharacteristicWriteWithResponse];
        
        NSLog(@"Send value: %@", msg);
        
        delete [] send_msg;
        delete [] data_block;
    }
    
    //----
    
    int count_ms = 0;
    while (!btHelper.RecvFinished) {
        // timeout
        if(count_ms > timeout_ms)
            break;
        [NSThread sleepForTimeInterval:0.1];
        count_ms += 100;
    }
    
    if(count_ms > timeout_ms)
    {
        NSLog(@"Recv Timeout:%d ms", timeout_ms);
        *recv_data_len = 0;
        return false;
    }
    else
    {
        *recv_data_len = [btHelper.RecvData length];
        memcpy(recv_data, (unsigned char *)[btHelper.RecvData bytes], *recv_data_len);
        
        //NSLog(@"{recv_data} %@", btHelper.RecvData);
        
        return true;
    }
}






