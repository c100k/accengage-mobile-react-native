//
//  RNAccTracking.m
//  RNAcc
//
//  Copyright © 2017 Accengage. All rights reserved.
//

#import "RNAccTracking.h"
#import "RNAccUtils.h"

@implementation RNAccTracking

RCT_EXPORT_MODULE()

- (dispatch_queue_t)methodQueue {
    
    return dispatch_get_main_queue();
}

RCT_EXPORT_METHOD(trackCart:(NSString *)cartId
                  currency:(NSString *)currency
                  item:(NSDictionary *)cartItem) {
    
    NSString *itemId = [cartItem[@"id"] isKindOfClass:[NSString class]] ? cartItem[@"id"] : nil;
    NSString *itemName = [cartItem[@"name"] isKindOfClass:[NSString class]] ? cartItem[@"name"] : nil;
    NSString *itemBrand = [cartItem[@"brand"] isKindOfClass:[NSString class]] ? cartItem[@"brand"] : nil;
    NSString *itemCategory = [cartItem[@"category"] isKindOfClass:[NSString class]] ? cartItem[@"category"] : nil;
    
    if (itemId) {
        ACCCartItem *item = [ACCCartItem itemWithId:itemId
                                               name:itemName
                                              brand:itemBrand
                                           category:itemCategory
                                              price:[RCTConvert double:cartItem[@"price"]]
                                           quantity:[RCTConvert NSInteger:cartItem[@"quantity"]]];
        
        [Accengage trackCart:cartId currency:currency item:item];
    }
}

RCT_EXPORT_METHOD(trackPurchase:(NSString *)purchaseId
                  currency:(NSString *)currency
                  amount:(nonnull NSNumber *)purchaseAmount
                  items:(nullable NSArray *)purchasedItems) {
    
    NSMutableArray<ACCCartItem *> *result = @[].mutableCopy;
    
    for (NSDictionary *object in purchasedItems) {
        if (![object isKindOfClass:[NSDictionary class]]) {
            break;
        }
        
        NSString *itemId = [object[@"id"] isKindOfClass:[NSString class]] ? object[@"id"] : nil;
        NSString *itemName = [object[@"name"] isKindOfClass:[NSString class]] ? object[@"name"] : nil;
        NSString *itemBrand = [object[@"brand"] isKindOfClass:[NSString class]] ? object[@"brand"] : nil;
        NSString *itemCategory = [object[@"category"] isKindOfClass:[NSString class]] ? object[@"category"] : nil;
        
        if (itemId) {
            ACCCartItem *item = [ACCCartItem itemWithId:itemId
                                                   name:itemName
                                                  brand:itemBrand
                                               category:itemCategory
                                                  price:[RCTConvert double:object[@"price"]]
                                               quantity:[RCTConvert NSInteger:object[@"quantity"]]];
            [result addObject:item];
        }
    }
    
    [Accengage trackPurchase:purchaseId currency:currency items:result.copy amount:purchaseAmount];
}

RCT_EXPORT_METHOD(trackLead:(NSString *)key value:(NSString *)value) {
    
    [Accengage trackLead:key value:value];
}


RCT_EXPORT_METHOD(trackEvent:(NSUInteger)eventType parameters:(NSDictionary *) parameters) {
    
    if (![parameters isKindOfClass:[NSDictionary class]]) {
        [Accengage trackEvent:eventType];
        return;
    }
    
    NSError *error = nil;
    NSData *data = [NSJSONSerialization dataWithJSONObject:parameters options:0 error:&error];
    
    if (error || !data) {
        NSLog(@"Custom data is sent in unsuported type and ignored");
        [Accengage trackEvent:eventType];
        return;
    }
    
    NSString *jsonString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    [Accengage trackEvent:eventType withParameters:@[jsonString]];
}

RCT_EXPORT_METHOD(trackCustomEvent:(NSUInteger)eventType withCustomParameters:(NSDictionary *) customParameters) {
    
    ACCCustomEventParams *customEventParams = [[ACCCustomEventParams alloc] init];
    [customParameters enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
        if ([obj isKindOfClass:[NSString class]]) {
            NSDate *date = [RNAccUtils dateFromString:obj];
            if (date) {
                [customEventParams setDate:date forKey:key];
            } else {
                [customEventParams setString:obj forKey:key];
            }
        } else if ([obj isKindOfClass:[NSNumber class]]) {
            [customEventParams setNumber:obj forKey:key];
        } else if ([obj isKindOfClass:[NSDate class]]) {
            [customEventParams setDate:obj forKey:key];
        }
    }];
    
    [Accengage trackEvent:eventType withCustomParameters:customEventParams];
}

@end

