
#if __has_include("RCTBridgeModule.h")
#import "RCTBridgeModule.h"
#import "RCTConvert.h"
#else
#import <React/RCTBridgeModule.h>
#import <React/RCTConvert.h>
#endif

#import <Accengage/Accengage.h>

@interface RNAccStaticLists : NSObject <RCTBridgeModule>

@end
