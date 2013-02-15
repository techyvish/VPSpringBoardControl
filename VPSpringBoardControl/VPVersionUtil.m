//
//  VersionUtil.m
//  goPay
//
//  Created by Vishal Patel on 24/11/10.
//  Copyright 2010 ANZ National Bank of New Zealand. All rights reserved.
//

#import "VPVersionUtil.h"


BOOL isRatina() { return [VPVersionUtil isRatinaDisplay]; }

@implementation VPVersionUtil

+ (NSInteger) getSystemVersionAsAnInteger {
    int index = 0;
    NSInteger version = 0;
	
    NSArray* digits = [[UIDevice currentDevice].systemVersion componentsSeparatedByString:@"."];
    NSEnumerator* enumer = [digits objectEnumerator];
    NSString* number;
    while (number = [enumer nextObject]) {
        if (index>2) {
            break;
        }
        NSInteger multipler = powf(100, 2-index);
        version += [number intValue]*multipler;
        index++;
    }
	return version;
}

+ (BOOL) isRatinaDisplay {
    BOOL hasHighResScreen = NO;
    if ([UIScreen instancesRespondToSelector:@selector(scale)]) {
        CGFloat scale = [[UIScreen mainScreen] scale];
        if (scale > 1.0) {
            hasHighResScreen = YES;
        }
    }
    return hasHighResScreen;   
}

@end
