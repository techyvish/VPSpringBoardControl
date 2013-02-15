//
//  SpriteManager.m
//  goMoney
//
//  Created by Vishal Patel on 30/08/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "VPSpriteManager.h"
#import "VPVersionUtil.h"

@implementation VPSpriteManager

+(UIImage*) getImageNamed:(NSString*)imageName fromImage:(NSString*)spriteName {
    UIImage *spriteSheet = [UIImage imageNamed:[NSString stringWithFormat:@"%@.png",spriteName]];
    NSString *path = [[NSBundle mainBundle] pathForResource:spriteName ofType:@"plist"];
    NSDictionary *dict = [[[NSDictionary alloc] initWithContentsOfFile:path] autorelease];
    NSDictionary* dict1 = [dict valueForKey:@"frames"];
    NSDictionary* dict2 = [dict1 valueForKey:imageName];
    NSString* rect =  [dict2 valueForKey:@"textureRect"];
    CGRect r = CGRectFromString(rect);
    return [UIImage imageWithCGImage:CGImageCreateWithImageInRect( [spriteSheet CGImage] , r )];
}

+(UIImage*) getDonationImageNamed:(NSString*)imageName {
    if ( IS_RATINA ) {
        imageName = [imageName stringByAppendingString:@"@2x.png"];
        return [VPSpriteManager getImageNamed:imageName fromImage:@"image_collection@2x"];
    }
    else {
        imageName = [imageName stringByAppendingString:@".png"];
        return [VPSpriteManager getImageNamed:imageName fromImage:@"image_collection"];
    }
}

@end
