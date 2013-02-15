//
//  CollisionCirlce.h
//  goMoney
//
//  Created by Vishal Patel on 11/07/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <QuartzCore/QuartzCore.h>

@interface VPCollisionCirlce : UIView {
    int collisionRedius ;
}

-(BOOL) detectCollisionWithLayer:(CALayer*)layer;

@end
