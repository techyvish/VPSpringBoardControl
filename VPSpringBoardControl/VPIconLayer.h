//
//  IconLayer.h
//  goMoney
//
//  Created by Vishal Patel on 11/07/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "VPCollisionCirlce.h"

@interface VPIconLayer : VPCollisionCirlce {
}

@property (nonatomic,retain)      UIImage *imgContent;
@property (nonatomic,retain)      NSString * text ;
@property (readwrite) int nodePosition;
@property (readwrite) int type;

-(void) moveToNodePostion:(int) pos ;
-(void) wobble:(BOOL) flag ;
-(void) randerAndAddTextLayer:(UILabel*)layer ;
-(void) setAlphaBlending:(BOOL)flag ;

@end

@interface IconImage : UIView {

    
}
@property ( nonatomic, retain ) UIImage*   iconImage;
@property ( nonatomic, readwrite ) BOOL alphaBlending;

@end
