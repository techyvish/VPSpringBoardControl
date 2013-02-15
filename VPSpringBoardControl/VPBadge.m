/*
 * ANZ PushBanking
 * Copyright (c)2008; ANZ National Bank Limited.
 */

#import "VPBadge.h"
#import "VPVersionUtil.h"

// Private methods.
@interface VPBadge()
	- (void) configure;
	- (CGFloat) getTextWidth;
@end

@implementation VPBadge

@synthesize value;

// The size of the (bold) font to display within the badge.
#define FONTSIZE 14

// The minimum width of the badge. If this is too small, the image will start cropping to meet the width and look ugly and disjointed.
CGFloat minimumBadgeWidth = 0;

// The height of the badge. The badge assumes a single line and the padding puts the text vertically centred within the badge.
CGFloat badgeHeight = 0;

// The amount of padding present on the default image. This is calculated by taking the width of a single digit from the width of the default image.
// The assumption is that the default image is the correct size to show a single digit.
CGFloat defaultPadding = 0;

// The images we have been provided do have their highest point in the centremost horizontal pixel, but the badge itself is slightly off centre.
// This offset corrects that. If the images change, this value will need to change.
static CGFloat badgeXOffset = 0;

// An offset from the top of the image where we wish to vertically place the text. Again, if the images change, this value will need to change as well.
// This could be derived by working out half the difference between the height of the image and the height of the text and offsetting from there if the
// image is not centred... If the font size changes, then this offset may need to change to compensate for the new font height.
static CGFloat badgeYOffset = 2;

- (id) initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    
	if ( self ) {
		[self configure];
	}
	return self;
	
}

- (id) initWithFrame: (CGRect) _rect {
    self = [super initWithFrame: _rect];
    
	if ( self ) {
		[self configure];
	}
	return self;
}

/**
 * Internal method used by the constructors. Modularised here to remove duplicate code.
 */
- (void) configure {
	// The image we will be stretching. We assume that the badge is centred within the image as the stretch cap is the middle of the image.
	image = [UIImage imageNamed:@"RedBadge.png"];
	image = [[image stretchableImageWithLeftCapWidth:(image.size.width / 2.0) topCapHeight:0] retain];
	
	// We need to know the minimum badge width as characters like '1' may cause the badge to shrink beyond the original width. We dont want this.
	minimumBadgeWidth = image.size.width;
	
	badgeHeight = image.size.height;
	
	// The assumption here is that the default size of the image is sized correctly to support a single digit. We use this to infer how much
	// padding should be on either side of the text should we need to display more than one digit.
	value = @"0";
	CGFloat defaultImageWidth = [self getTextWidth];
	defaultPadding = minimumBadgeWidth - defaultImageWidth;
	
	// Make sure the background is transparent.
	self.backgroundColor = [UIColor clearColor];
}

/**
 * Determine the size of the rectangle needed to display the value within the badge. This should be called by the implementor to determine the amount
 * of space required to render the badge (assuming the implementor cares).
 */
- (CGSize) calcBadgeSize {
	CGFloat textWidthWithPadding = [self getTextWidth] + defaultPadding;
	CGSize valueSize = CGSizeMake(textWidthWithPadding < minimumBadgeWidth ? minimumBadgeWidth : textWidthWithPadding, badgeHeight);
	return(valueSize);
}

/**
 * Internal method modularised to remove duplicate code. Calculate how many horizontal pixels the text will need. 
 */
-(CGFloat) getTextWidth {
	return([value sizeWithFont:[UIFont boldSystemFontOfSize:FONTSIZE]].width);
}

/**
 * Draw the background badge image and the value within the available space. If the text to display is shorter than the internally defined minimum
 * width of the control, then the text is adjusted accordingly so it is centered within the available space. 
 */
- (void) drawRect: (CGRect) rect {
	if ([value length] > 0) {
		// Assume that the rect is the correct size and draw the background image to fill it.
		[image drawInRect: rect];
		
		// The text will be centred within the image. To find the x position, determine the centre of the image, and subtract half the width of the text.
		CGFloat imageCenter = rect.origin.x + (rect.size.width / 2.0);
		CGFloat textX = imageCenter - ([self getTextWidth] / 2.0) + badgeXOffset;
		CGFloat textY = rect.origin.y + badgeYOffset;
		[[UIColor whiteColor] set];
		[value drawAtPoint:CGPointMake(textX, textY) withFont:[UIFont boldSystemFontOfSize:FONTSIZE]];
	}
}

@end
