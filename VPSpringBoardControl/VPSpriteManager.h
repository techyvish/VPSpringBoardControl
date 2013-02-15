//
//  SpriteManager.h
//  goMoney
//
//  Created by Vishal Patel on 30/08/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface VPSpriteManager : NSObject { }
+(UIImage*) getImageNamed:(NSString*)imageName fromImage:(NSString*)spriteName;
+(UIImage*) getDonationImageNamed:(NSString*)imageName ;
@end
