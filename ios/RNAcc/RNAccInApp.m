//
//  RNAccInApp.m
//  RNAcc
//
//  Copyright © 2017 Accengage. All rights reserved.
//

#import "RNAccInApp.h"

@implementation RNAccInApp {
    bool hasListeners;
}

RCT_EXPORT_MODULE()

- (dispatch_queue_t)methodQueue {
    
    return dispatch_get_main_queue();
}

+ (BOOL)requiresMainQueueSetup {
    
    return false;
}

// Will be called when this module's first listener is added.
- (void)startObserving {
    
    hasListeners = YES;
    // Set up any upstream listeners or background tasks as necessary
}

// Will be called when this module's last listener is removed, or on dealloc.
- (void)stopObserving {
    
    hasListeners = NO;
    // Remove upstream listeners, stop unnecessary background tasks
}

- (NSArray<NSString *> *)supportedEvents {
    
    return @[@"didInAppClick", @"didInAppDisplay", @"didInAppClose"];
}

- (id)init {
    
    self = [super init];
    
    if (self) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onInAppNotifClicked:) name:BMA4SInAppNotification_Clicked object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onInAppNotifDidAppear:) name:BMA4SInAppNotification_DidAppear object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onInAppNotifClosed:) name:BMA4S_InAppNotification_Closed object:nil];
    }
    
    return self;
}

- (void) onInAppNotifClicked:(NSNotification*) notif
{
    if (hasListeners) {
        [self sendEventWithName:@"didInAppClick" body:@{@"inApp": [self createJavasriptInAppObject:notif]}];
    }
}

- (void) onInAppNotifDidAppear:(NSNotification*) notif
{
    if (hasListeners) {
        [self sendEventWithName:@"didInAppDisplay" body:@{@"inApp": [self createJavasriptInAppObject:notif]}];
    }
}

- (void) onInAppNotifClosed:(NSNotification *) notif {
    if (hasListeners) {
        [self sendEventWithName:@"didInAppClose" body:@{@"inApp": [self createJavasriptInAppObject:notif]}];
    }
}

RCT_EXPORT_METHOD(setLocked:(BOOL)enabled) {
    
    [BMA4SInAppNotification setNotificationLock:enabled];
}

RCT_REMAP_METHOD(isLocked, isLockedWithResolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject) {
    
    resolve([NSNumber numberWithInt:[BMA4SInAppNotification notificationLock]]);
}

// Create readable inApp js object
- (NSDictionary *) createJavasriptInAppObject:(NSNotification *)notif {
    
    NSDictionary *inAppObject = @{
                                  @"messageId" : @"",
                                  @"displayTemplate" : @"",
                                  @"displayParams" : @{},
                                  @"customParams" : notif.userInfo
    };
    return inAppObject;
}

@end
