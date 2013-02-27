
#import <UIKit/UIKit.h>

@interface VPBadge : UIView {
	
@private
	UIImage* image;
}

@property(nonatomic, retain) NSString* value;

- (id) initWithFrame: (CGRect) rect;
- (CGSize) calcBadgeSize;

@end
