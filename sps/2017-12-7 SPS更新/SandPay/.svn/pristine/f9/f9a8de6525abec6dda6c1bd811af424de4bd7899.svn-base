//
//  Global.h
//  sps2-dev
//
//  Created by Rick Xing on 7/2/13.
//  Copyright (c) 2013 Rick Xing. All rights reserved.
//

#import <UIKit/UIKit.h>


//id
#define GET_AND_SET_DECLARATION_ID(var) \
+ (id)get_##var; \
+ (void)set_##var:(id)_##var; \

#define GET_AND_SET_METHOD_ID(var) \
+ (id)get_##var \
{ \
return var; \
} \
+ (void)set_##var:(id)_##var \
{ \
var = _##var; \
} \


@interface Global : NSObject
GET_AND_SET_DECLARATION_ID(BridgeDelegate)
GET_AND_SET_DECLARATION_ID(CheckoutDelegate)

@end
