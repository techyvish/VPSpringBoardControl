//
//  GridView.h
//  goMoney
//
//  Created by Vishal Patel on 16/06/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#ifndef __GRID_VIEW_H__
#define __GRID_VIEW_H__


#import <UIKit/UIKit.h>
#include <vector>
#import "VPIconLayer.h"
#import "VPBadge.h"

@interface VPGridView : UIView  {
    std::vector<VPIconLayer*> icons;
    BOOL shouldMoveIcon;
    VPBadge *uncollectedBadge;
    NSTimer*    touchTimer;
    VPIconLayer *imageLayer;
}

@property (nonatomic,retain) NSMutableArray     *iconArray;
@property (nonatomic, retain) VPIconLayer *imageLayer;

- (void) arrangeGrid;
- (id)   initWithFrame:(CGRect)frame andIcons:(NSMutableArray*)array;
- (void) exchangeNodePositions:(VPIconLayer *)selectedLayer withCollidedLayer:(VPIconLayer *)layer ;
- (void) saveButtonOrder ;
- (void) updateLayoutBasedOnUncollected:(id)obj ;
- (void) wobbleAll:(BOOL) flag ;

@end


#endif
    
