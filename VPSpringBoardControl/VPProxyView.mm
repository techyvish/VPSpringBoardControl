//
//  ProxyView.m
//  goMoney
//
//  Created by Vishal Patel on 11/07/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "VPProxyView.h"
#import "VPGridView.h"

@implementation VPProxyView

- (void)dealloc
{
    [super dealloc];
}

-(id) initWithFrame:(CGRect)frame andIcons:(NSMutableArray*) icons {

    self = [super initWithFrame:frame];
    if ( self ) {
        
        self.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"Bg_GenericBlue.png"]];
        
        VPGridView    *grid = [[VPGridView alloc]initWithFrame:frame andIcons:icons];
        [self addSubview:grid];
        [grid release];
        
    }
    return self;
}

@end
