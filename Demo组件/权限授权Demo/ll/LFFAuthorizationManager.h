//
//  LFFAuthorizationManager.h
//  ll
//
//  Created by tianNanYiHao on 2017/12/25.
//  Copyright © 2017年 tianNanYiHao. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LFFAuthorizationManager : NSObject


/**
 单例实例化

 @return 单例对象
 */
+ (LFFAuthorizationManager *)defaultManager;

#pragma mark - Photo Library
- (void)requestPhotoLibraryAccess;

#pragma mark - AvcaptureMedia - AVMediaTypeVideo
- (void)requestCameraAccess;

#pragma mark - AvcaptureMedia - AVMediaTypeAudio
- (void)requestAudioAccess;

#pragma mark - AddressBook
- (void)requestAddressBookAccess;
@end
