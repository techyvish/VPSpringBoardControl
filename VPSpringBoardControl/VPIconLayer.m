//
//  IconLayer.m
//  goMoney
//
//  Created by Vishal Patel on 11/07/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "VPIconLayer.h"
#define TEXT_PADDING 5


static void addRoundedRectToPath(CGContextRef context, CGRect rect, float ovalWidth, float ovalHeight)
{
    float fw, fh;
    if (ovalWidth == 0 || ovalHeight == 0) {
        CGContextAddRect(context, rect);
        return;
    }
    CGContextSaveGState(context);
    CGContextTranslateCTM (context, CGRectGetMinX(rect), CGRectGetMinY(rect));
    CGContextScaleCTM (context, ovalWidth, ovalHeight);
    fw = CGRectGetWidth (rect) / ovalWidth;
    fh = CGRectGetHeight (rect) / ovalHeight;
    CGContextMoveToPoint(context, fw, fh/2);
    CGContextAddArcToPoint(context, fw, fh, fw/2, fh, 1);
    CGContextAddArcToPoint(context, 0, fh, 0, fh/2, 1);
    CGContextAddArcToPoint(context, 0, 0, fw/2, 0, 1);
    CGContextAddArcToPoint(context, fw, 0, fw, fh/2, 1);
    CGContextClosePath(context);
    CGContextRestoreGState(context);
}

@implementation VPIconLayer

@synthesize imgContent;
@synthesize text;
@synthesize nodePosition;
@synthesize type;


static const CGFloat        kWobbleRadians = 1.4;
static const NSTimeInterval kWobbleTime = 0.2;


#define IMAGE_VIEW_TAG 99

-(void) moveToNodePostion:(int) pos {
    CGPoint pointArray[] = {
        CGPointMake( 61.000000  , 76.000000  ),
        CGPointMake( 158.000000 , 76.000000  ),
        CGPointMake( 255.000000 , 76.000000  ),
        CGPointMake( 61.000000  , 198.000000 ),
        CGPointMake( 158.000000 , 198.000000 ),
        CGPointMake( 255.000000 , 198.000000 ),
    };

    CGPoint translatePoint = pointArray[pos];
    
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    [UIView setAnimationDuration:0.3];
    self.center = translatePoint;
    [UIView commitAnimations];
    
}

-(void) wobble:(BOOL) flag {
    
    CAKeyframeAnimation *rotation = [CAKeyframeAnimation animation];
    rotation.timingFunction = [CAMediaTimingFunction  functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    if ( flag ) {
        CGFloat rotation1 = (kWobbleRadians * M_PI) / 180.0;
                CATransform3D wobbleLeft  = CATransform3DMakeRotation(rotation1,0,0,1); //  CGAffineTransformMakeRotation(rotation);
                CATransform3D wobbleRight = CATransform3DMakeRotation(-rotation1,0,0,1);

        if ( self.nodePosition % 2) 
        {
            rotation.values = [NSArray arrayWithObjects:[NSValue valueWithCATransform3D:wobbleLeft],
                                                    [NSValue valueWithCATransform3D:wobbleRight],
                                                    nil];
        }
        else
        {
            rotation.values = [NSArray arrayWithObjects:[NSValue valueWithCATransform3D:wobbleRight],
                               [NSValue valueWithCATransform3D:wobbleLeft],
                               nil];
            
        }
        
        
        rotation.duration = 0.17;
        
        rotation.repeatCount = HUGE_VALF;
    }
    else{
        
        rotation.values = [NSArray arrayWithObjects:
                           [NSValue valueWithCATransform3D:CATransform3DMakeTranslation( 0.0, 0.0f, 0.0f)],
                           [NSValue valueWithCATransform3D:CATransform3DMakeRotation( 0.0, 0.0f, 0.0f, 1.0f)],nil];
        
        rotation.repeatCount = 1;
        
        
    }
	
	[self.layer addAnimation:rotation forKey:@"transform"];
   
    if (!flag)
        [self.layer removeAllAnimations];
}

-(void) randerAndAddTextLayer:(UILabel*)layer {
    
    layer.frame = CGRectMake (self.bounds.origin.x - 5.0   , 
                              self.frame.size.height - 25.0 , 
                              self.frame.size.width + 10.0 , 
                              20.0  );
    
    [self addSubview:layer];
}


-(void) randerAndAddTextLayer1:(CALayer*)layer {
    
    layer.frame = CGRectMake (self.bounds.origin.x -10   , 
                              self.imgContent.size.height - 10.0 , 
                              self.bounds.size.width + 10 , 
                              25  );
    layer.position = CGPointMake(self.bounds.size.width / 2.0f , self.imgContent.size.height );

    [self.layer addSublayer:layer];
    
}

-(void) setAlphaBlending:(BOOL)flag {
    IconImage* image = (IconImage*)[self viewWithTag:IMAGE_VIEW_TAG];
    image.alphaBlending = flag;
}

-(void) dealloc {
    
    [imgContent release];
    [text release];
    [super dealloc];
}

@end


@implementation IconImage

@synthesize alphaBlending;
@synthesize iconImage;


-(id) initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    if ( self ) {
        self.tag = IMAGE_VIEW_TAG;
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}



/**
 * Draw new UIColor layer on image 
 * to show that icon is selected or not.
 *
 */

-(void)drawRect:(CGRect)rect {
    
    [iconImage drawInRect:rect];
    CGRect bounds = CGRectMake(7, 1, 58, 58);
    if ( self.alphaBlending ) {
        
        [[UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.3] set];
        CGContextRef context = UIGraphicsGetCurrentContext();
        
        addRoundedRectToPath(context, bounds, 10 , 10);
        CGContextClip(context);
        CGContextFillRect(context, bounds);

    }
    else{
        [[UIColor clearColor] set];
        CGContextRef context = UIGraphicsGetCurrentContext();
        CGContextFillRect(context, bounds);
    }
    
    [super drawRect:rect];
}



-(void) setAlphaBlending:(BOOL)flag {
    
    alphaBlending = flag;
    [self setNeedsDisplay];
}


-(void) dealloc {
    [iconImage release];
    [super dealloc];
}

@end