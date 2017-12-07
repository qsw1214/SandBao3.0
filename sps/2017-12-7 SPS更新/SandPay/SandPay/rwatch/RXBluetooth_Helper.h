//
//  RXBluetooth_Helper.h
//  ItestXC
//
//  Created by Rick Xing on 16/6/1.
//  Copyright © 2016年 SAND. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreBluetooth/CoreBluetooth.h>

@interface RXBluetooth_Helper : NSObject
{
}

@property (nonatomic, copy) CBUUID * BT_UUID_SVC;
@property (nonatomic, copy) CBUUID * BT_UUID_TX;
@property (nonatomic, copy) CBUUID * BT_UUID_RX;

@property (nonatomic, retain) CBPeripheral * Peripheral;

@property (nonatomic, retain) CBCharacteristic * Characteristic_TX;
@property (nonatomic, retain) CBCharacteristic * Characteristic_RX;

@property (nonatomic, assign) bool RecvFinished;
@property (nonatomic, copy) NSData * RecvData;

@end

extern RXBluetooth_Helper * btHelper;


