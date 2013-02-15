//
//  CollisionCirlce.m
//  goMoney
//
//  Created by Vishal Patel on 11/07/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "VPCollisionCirlce.h"

@implementation VPCollisionCirlce

-(id) init {
    self = [super init]; 
    if ( self ) {
        collisionRedius = 25;
        [self setIsAccessibilityElement:YES];
        
    }
    return self;
}

-(void) drawRect:(CGRect)rect{
    [super drawRect:rect];
}

-(BOOL) detectCollisionWithLayer:(CALayer*)layer {
    CGPoint h = self.layer.position ;
    CGPoint k = layer.position;
    
    double distance =sqrt( pow ((h.x - k.x) ,2 ) + pow( (h.y - k.y  ) ,2 ) );
    if ( distance <= (collisionRedius + collisionRedius) ) {
        return YES;
    }
    return NO;
}

@end
