//
//  GridView.m
//  goMoney
//
//  Created by Vishal Patel on 16/06/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "VPGridView.h"
#import <QuartzCore/QuartzCore.h>
#import "VPIconData.h"

#define BADGE_ICON_LOCATION @"5"

#define IMAGE_PADDING 25.0
#define IMAGE_HEIGHT  92.0 
#define IMAGE_WIDTH   72.0

#define IMAGE_PADDING_Y 30.0
#define IMAGE_PADDING_X 25.0

#define NO_OF_ROWS 2
#define NO_OF_COLS 3 

static u_int editSwitch   = 0x00000000;
static u_int collided     = 0x00000000;

@implementation VPGridView
@synthesize  iconArray,imageLayer;

- (id)initWithFrame:(CGRect)frame andIcons:(NSMutableArray*)_icons;
{
    self = [super initWithFrame:frame];
    if (self) {
        self.iconArray = _icons;
        self.backgroundColor = [UIColor clearColor];
        [self arrangeGrid];
    }
    return self;
}

CGRect rectArray[] = {
    CGRectMake(25.000000, 30.000000, 72.000000, 92.000000),
    CGRectMake(122.000000, 30.000000, 72.000000, 92.000000),
    CGRectMake(219.000000, 30.000000, 72.000000, 92.000000),
    CGRectMake(25.000000, 152.000000, 72.000000, 92.000000),
    CGRectMake(122.000000, 152.000000, 72.000000, 92.000000)
};

CGPoint pointArray[] = {
    CGPointMake( 61.000000  , 76.000000  ),
    CGPointMake( 158.000000 , 76.000000  ),
    CGPointMake( 255.000000 , 76.000000  ),
    CGPointMake( 61.000000  , 198.000000 ),
    CGPointMake( 158.000000 , 198.000000 ),
    CGPointMake( 255.000000 , 198.000000 ),
};

-(void) arrangeGrid {
    
    uncollectedBadge = [[VPBadge alloc]initWithFrame:CGRectMake(0, 0, 20, 20)];
    NSString *iconOrder = @"1,2,3,4,5,6";
    
    int row = NO_OF_ROWS;
    int col = NO_OF_COLS;
    int m = 0 ; 
    int nodepos = 0;
    for ( int i = 1 ; i <= row ; i ++ ) {
        for ( int j = 1 ; j <= col ; j++ ) {
            if ( m > ([iconOrder length] - 1) )
                break;
            /// Creating Icon Layer
            imageLayer = [[VPIconLayer alloc] init];
            CGPoint p = pointArray[m++];
            CGRect r = CGRectMake( p.x - (IMAGE_WIDTH/2.0) , p.y - (IMAGE_HEIGHT/2.0) ,IMAGE_WIDTH , IMAGE_HEIGHT );
            imageLayer.frame = r ;
            imageLayer.userInteractionEnabled = false;
            imageLayer.type = [[iconOrder substringWithRange:NSMakeRange(nodepos, 1)] intValue];
            imageLayer.userInteractionEnabled = NO;
            /// Setting Up Icon Data...
            VPIconData *iconData = [iconArray objectAtIndex:imageLayer.type];
            imageLayer.text = iconData.iconName;
            imageLayer.backgroundColor = [UIColor clearColor];
            imageLayer.nodePosition = nodepos ++ ;
            /// Adding Icon Image...
            IconImage *image = [[IconImage alloc]initWithFrame:CGRectMake(0, 0, IMAGE_WIDTH, 82.0 )];
            image.iconImage = iconData.iconImage;
            [imageLayer addSubview:image];            
            [image release];
            [imageLayer setAccessibilityLabel:iconData.iconName];
            icons.push_back(imageLayer);
            /// Adding Text Label...
            UILabel* textLabel = [[UILabel alloc] init];
            textLabel.font = [UIFont boldSystemFontOfSize:12.5];
            textLabel.textAlignment = NSTextAlignmentCenter;
            textLabel.text = iconData.iconName;
            textLabel.backgroundColor = [ UIColor clearColor];
            textLabel.textColor = [UIColor whiteColor];            
            [imageLayer randerAndAddTextLayer:textLabel];
            [textLabel release];
            [self.layer addSublayer:imageLayer.layer];
        }
    }
    [self updateLayoutBasedOnUncollected:nil];
}

- (void)dealloc
{
    [uncollectedBadge release];
    [iconArray release];
    [imageLayer release];
    typedef std::vector<VPIconLayer*>::iterator Iterator;
    Iterator it = icons.begin();
    for ( ; it != icons.end() ; it ++ ) {
        [((VPIconLayer*)(*it)) release];
    }
    [super dealloc];
}

static VPIconLayer *selectedView ;
- (UIView *)hitTest1:(CGPoint)point withEvent:(UIEvent *)event {
    typedef std::vector<VPIconLayer*>::iterator Iterator;
    Iterator it = icons.begin();
    
    for ( ; it != icons.end() ; it ++ ) {
        VPIconLayer   *layer = *it;
        CGPoint pointInB = [layer convertPoint:point fromView:self];
        if ([layer pointInside:pointInB withEvent:event]) 
            return layer;
    }
    
    return [super hitTest:point withEvent:event];
}

-(void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    collided &= 0x00000000;
    [self performSelector:@selector(longPressDetected:) withObject:
     [NSDictionary dictionaryWithObjectsAndKeys:touches, @"touches", event, @"event", nil] afterDelay:1.0];
    
    UITouch *touch1 = [[event allTouches] anyObject];
    CGPoint currentLocation = [touch1 locationInView:touch1.view];
    UIView* currentView =  [self hitTest1:currentLocation withEvent:event];
    
    if ( [currentView isKindOfClass:[VPIconLayer class]] ) {
        selectedView = (VPIconLayer*)currentView;
        if ( editSwitch ) {
            shouldMoveIcon  = YES;
        }
        [selectedView setAlphaBlending:YES];
    }
}

-(void) touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    UITouch *touch1 = [[event allTouches] anyObject];
    CGPoint currentLocation = [touch1 locationInView:touch1.view];
    if ( editSwitch ) {
        if (shouldMoveIcon) {
            selectedView.center = currentLocation;
            typedef std::vector<VPIconLayer*>::iterator Iterator;
            Iterator it = icons.begin();
            for ( ; it != icons.end() ; it ++ ) {
                VPIconLayer   *layer = *it;
                if ( (selectedView != layer ) 
                    && [selectedView detectCollisionWithLayer:layer.layer] ) {
                    shouldMoveIcon = NO;
                    collided |= 0x00001000;
                    [self exchangeNodePositions:selectedView withCollidedLayer:layer];
                    break;
                }
            }
        }
    }
    else{
        if ( selectedView  ) {
            [selectedView setAlphaBlending:NO];
        } 
    }
}

-(void) touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    if ( editSwitch ) {
        shouldMoveIcon = NO;
        //if ( !collided ) { VP: bug fix 
        VPIconLayer* layer = (VPIconLayer*)selectedView;
        [layer moveToNodePostion:layer.nodePosition];
        collided &= 0x00000000;
        //}
        [selectedView setAlphaBlending:NO];
        [super touchesEnded:touches withEvent:event];
    }
    else{
        if ( selectedView ) {
            [selectedView setAlphaBlending:NO];
            selectedView = nil;
        }
    }
}

-(void) exchangeNodePositions:(VPIconLayer *)selectedLayer withCollidedLayer:(VPIconLayer *)layer {
    
    typedef std::vector<VPIconLayer*>::iterator Iterator;    
    if ( layer.nodePosition > selectedLayer.nodePosition   ) {
        int nodeStartPosition  = selectedLayer.nodePosition + 1 ;
        int idx =  selectedLayer.nodePosition ;
        int nodeEndPosition   = layer.nodePosition ;
        
        while ( nodeStartPosition <= nodeEndPosition ) {
            VPIconLayer *layers = icons[nodeStartPosition];
            [layers moveToNodePostion:nodeStartPosition - 1];
            layers.nodePosition = nodeStartPosition - 1;
            nodeStartPosition ++;
            [layers setNeedsDisplay];
        }
        
        [selectedLayer moveToNodePostion:nodeStartPosition - 1];
        selectedLayer.nodePosition = nodeStartPosition - 1;
        [selectedLayer setNeedsDisplay];
        
        VPIconLayer *k = icons.at(  idx );
        Iterator save = icons.erase( icons.begin() + idx  );
        icons.insert( icons.begin() + nodeEndPosition  , k );
    }
    
    else if ( selectedLayer.nodePosition > layer.nodePosition ) {
        int nodeStartPosition  = selectedLayer.nodePosition - 1 ;
        int idx =  selectedLayer.nodePosition ;
        int nodeEndPosition   = layer.nodePosition ;
        
        while ( nodeStartPosition >= nodeEndPosition ) {
            VPIconLayer *layers = icons[nodeStartPosition];
            [layers moveToNodePostion:nodeStartPosition + 1];
            layers.nodePosition = nodeStartPosition + 1;
            nodeStartPosition --;
            [layers setNeedsDisplay];
        }
        
        [selectedLayer moveToNodePostion:nodeStartPosition + 1];
        selectedLayer.nodePosition = nodeStartPosition + 1;
        [selectedLayer setNeedsDisplay];
        VPIconLayer *k = icons.at(  idx );
        Iterator save = icons.erase( icons.begin() + idx  );
        icons.insert( icons.begin() + nodeEndPosition  , k );
    }
    
    /**
     * For debug purpose.
     *    it = icons.begin();
     *     for ( ; it != icons.end() ; it ++) {
     *        NSLog(@"%d",((VPIconLayer*)(*it)).nodePosition );
     *    }
     */
    
}

-(void) editmodeon {
    editSwitch |= 0x00000010;
}

-(void) editmodeoff {
    editSwitch &= 0x00000000;
    if (selectedView) {
        [selectedView setAlphaBlending:NO];
        selectedView = nil;
    }
    [self wobbleAll:NO];
    [self saveButtonOrder];
}

-(void) saveButtonOrder {
    typedef std::vector<VPIconLayer*>::iterator Iterator;
    Iterator it = icons.begin();
    
    NSMutableString *iconOrder = [NSMutableString stringWithString:@""];
    for ( ; it != icons.end() ; it++ ) {
        VPIconLayer   *layer = *it;
        [iconOrder appendString:[[NSNumber numberWithInt:layer.type] stringValue]];
    }
}

- (void) updateLayoutBasedOnUncollected:(id)obj {
	// Calculate the size of the container
	int badgeItemNumber = 99;
	NSString* badgeItemNumberString = @"99";
	if ( uncollectedBadge != nil  ) {
        NSString    *currentIconOrder = @"123456" ;
        NSRange r = [currentIconOrder rangeOfString:BADGE_ICON_LOCATION];
		VPIconLayer* uncollectedLayer = icons[r.location];
		// We show the text value and not the number value as +999 is read out as 1000.
		uncollectedBadge.hidden = (badgeItemNumber <= 0);
		uncollectedBadge.value = badgeItemNumberString;
		CGSize badgeSize = [uncollectedBadge calcBadgeSize];
		CGFloat xAxisAdjustment =  (badgeSize.width - uncollectedBadge.frame.size.width) / 2;
		xAxisAdjustment = (xAxisAdjustment > 0 ? xAxisAdjustment : 10);
		uncollectedBadge.frame = CGRectMake(uncollectedBadge.frame.origin.x - xAxisAdjustment,
                                            uncollectedBadge.frame.origin.y ,
                                            badgeSize.width,
                                            badgeSize.height);
		uncollectedBadge.layer.position = CGPointMake( uncollectedLayer.bounds.size.width - xAxisAdjustment, 5);
        [uncollectedLayer.layer addSublayer:uncollectedBadge.layer];
        [uncollectedBadge setNeedsDisplay];
        [uncollectedLayer setNeedsDisplay];
	}
}

- (void) longPressDetected:(NSDictionary*)params   {
    NSSet *touches = [params objectForKey:@"touches"];
    UIEvent *event = [params objectForKey:@"event"];
    [super touchesCancelled:touches withEvent:event];
    UITouch *touch1 = [[event allTouches] anyObject];
    CGPoint currentLocation = [touch1 locationInView:touch1.view];
    UIView* currentView =  [self hitTest1:currentLocation withEvent:event];
    if ( [currentView isKindOfClass:[VPIconLayer class]] ) {
        selectedView = (VPIconLayer*) currentView;
        shouldMoveIcon = YES;
        editSwitch |= 0x00000010;
        [self wobbleAll:YES];
    }
}

-(void) wobbleAll:(BOOL) flag {
    typedef std::vector<VPIconLayer*>::iterator Iterator;
    Iterator it = icons.begin();
    for ( ; it != icons.end() ; it ++ ) {
        VPIconLayer   *layer = *it;
        [layer wobble:flag];
        [layer setNeedsDisplay];
    }
}

@end