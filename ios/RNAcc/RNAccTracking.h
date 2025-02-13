//
//  RNAccTracking.h
//  RNAcc
//
//  Copyright © 2017 Accengage. All rights reserved.
//

#if __has_include(<React/RCTBridgeModule.h>)
#import <React/RCTBridgeModule.h>
#import <React/RCTConvert.h>
#else
#import "RCTBridgeModule.h"
#import "RCTConvert.h"
#endif

#import <Accengage/Accengage.h>

@interface RNAccTracking : NSObject <RCTBridgeModule>

@end
