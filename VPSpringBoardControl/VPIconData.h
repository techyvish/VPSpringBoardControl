//
//  IconData.h
//  VPSpringBoardControl
//
//  Created by vishal patel on 2/14/13.
//  Copyright (c) 2013 vishal patel. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum {
    
    PayAnyoneType = 0 ,
    BillPayType = 1 ,
    PayToMobileType = 2 ,
    DonationType = 3 ,
    TransferType = 4 ,
    UncollectedType = 5,
    
}IconType;

@interface VPIconData : NSObject { }

@property (nonatomic,retain) NSString    *iconName;
@property (readwrite)        IconType     type;
@property (nonatomic,retain) UIImage    *iconImage;

@end
