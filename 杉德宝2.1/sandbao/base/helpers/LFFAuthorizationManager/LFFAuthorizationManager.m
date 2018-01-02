//
//  LFFAuthorizationManager.m
//  ll
//
//  Created by tianNanYiHao on 2017/12/25.
//  Copyright © 2017年 tianNanYiHao. All rights reserved.
//

#import "LFFAuthorizationManager.h"
@import UIKit;
@import Photos;
@import AssetsLibrary;
@import CoreTelephony;
@import AVFoundation;
@import AddressBook;
@import Contacts;
@import EventKit;
@import CoreLocation;
@import MediaPlayer;
@import Speech;//Xcode 8.0 or later
@import HealthKit;
@import Intents;
@import CoreBluetooth;

#define IOS8AndLater ([[[UIDevice currentDevice] systemVersion] doubleValue] >= 8.0)
#define IOS9AndLater ([[[UIDevice currentDevice] systemVersion] doubleValue] >= 9.0)
#define IOS10AndLater ([[[UIDevice currentDevice] systemVersion] doubleValue] >= 10.0)

@implementation LFFAuthorizationManager

/**
 单例实例化
 
 @return 单例对象
 */
+ (LFFAuthorizationManager *)defaultManager{
    static LFFAuthorizationManager *authorizationManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        authorizationManager = [[LFFAuthorizationManager alloc] init];
    });
    return authorizationManager;
}

#pragma mark - Photo Library
- (void)requestPhotoLibraryAccess{
    if (IOS8AndLater) {
        PHAuthorizationStatus status = [PHPhotoLibrary authorizationStatus];
        if (status == PHAuthorizationStatusNotDetermined) {
            [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status) {
                if (status == PHAuthorizationStatusAuthorized) {
                    //ok
                }
                if (status == PHAuthorizationStatusDenied) {
                    // not ok
                }
            }];
        }
        if (status == PHAuthorizationStatusAuthorized) {
            //ok
        }
    }else{
        ALAuthorizationStatus authStatus = [ALAssetsLibrary authorizationStatus];
        if (authStatus == ALAuthorizationStatusAuthorized) {
            // ok
        }else{
            // not ok
        }
    }
}

#pragma mark - AvcaptureMedia - AVMediaTypeVideo
- (void)requestCameraAccess{
    AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    if (authStatus == AVAuthorizationStatusNotDetermined) {
        [AVCaptureDevice requestAccessForMediaType:AVMediaTypeVideo completionHandler:^(BOOL granted) {
            if (granted) {
                //ok
            }else{
                //not ok
            }
        }];
    }else if(authStatus == AVAuthorizationStatusAuthorized){
        //ok
    }else{
        // not ok
    }
}

#pragma mark - AvcaptureMedia - AVMediaTypeAudio
- (void)requestAudioAccess{
    AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeAudio];
    if (authStatus == AVAuthorizationStatusNotDetermined) {
        [AVCaptureDevice requestAccessForMediaType:AVMediaTypeAudio completionHandler:^(BOOL granted) {
            if (granted) {
                //ok
            }else{
                //not ok
            }
        }];
        
    }else if(authStatus == AVAuthorizationStatusAuthorized){
        //ok
    }else{
        // not ok
    }
}

#pragma mark - AddressBook
- (void)requestAddressBookAccess{
    
    if (@available(iOS 9.0, *)) {
        CNAuthorizationStatus authStatus = [CNContactStore authorizationStatusForEntityType:CNEntityTypeContacts];
        if (authStatus == CNAuthorizationStatusNotDetermined) {
            CNContactStore *contactStore = [[CNContactStore alloc] init];
            [contactStore requestAccessForEntityType:CNEntityTypeContacts completionHandler:^(BOOL granted, NSError * _Nullable error) {
                if (granted) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        //ok
                    });
                }else{
                    dispatch_async(dispatch_get_main_queue(), ^{
                        // not ok
                    });
                }
            }];
        }else if (authStatus == CNAuthorizationStatusAuthorized){
            // ok
        }else{
            // not ok
        }
    }else{
        ABAuthorizationStatus authStatus = ABAddressBookGetAuthorizationStatus();
        if (authStatus == kABAuthorizationStatusNotDetermined) {
            ABAddressBookRef addressBook = ABAddressBookCreate();
            ABAddressBookRequestAccessWithCompletion(addressBook, ^(bool granted, CFErrorRef error) {
                if (granted) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        // ok
                    });
                }else{
                    dispatch_async(dispatch_get_main_queue(), ^{
                        // ok not
                    });
                }
            });
            if (addressBook) {
                CFRelease(addressBook);
            }
        }else if (authStatus == kABAuthorizationStatusAuthorized){
            // ok
        }else{
            // not
        }
    }
}

@end
