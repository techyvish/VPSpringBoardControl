//
//  VersionUtil.h
//  goPay
//
//  Created by Vishal Patel on 24/11/10.
//  Copyright 2010 ANZ National Bank of New Zealand. All rights reserved.
//

#import <Foundation/Foundation.h>

#define __IPHONE_2_0 20000
#define __IPHONE_2_1 20100
#define __IPHONE_2_2 20200
#define __IPHONE_3_0 30000
#define __IPHONE_3_1 30100
#define __IPHONE_3_2 30200
#define __IPHONE_4_0 40000

#ifdef __cplusplus
extern "C" {
#endif
    BOOL isRatina() ;
#ifdef __cplusplus   
}
#endif

#define IS_RATINA isRatina()

@interface VPVersionUtil : NSObject {

}

+ (NSInteger) getSystemVersionAsAnInteger;
+ (BOOL) isRatinaDisplay ;

@end
