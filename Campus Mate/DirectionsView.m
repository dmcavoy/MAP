//
//  DirectionsView.m
//  Bowdoin Map
//
//  Created by Danielle McAvoy on 5/7/13.
//
//

#import "DirectionsView.h"

@implementation DirectionsView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}

- (void)awakeFromNib
{
    
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    CGContextRef currentContext = UIGraphicsGetCurrentContext();
	UIGraphicsPushContext(currentContext);
    CGContextSetLineWidth(currentContext, 10.0);
    [[UIColor yellowColor] setStroke];
	CGContextBeginPath(currentContext);
	CGContextMoveToPoint(currentContext, self.start.x, self.start.y);
	CGContextAddLineToPoint(currentContext, self.destination.x, self.destination.y);
	CGContextStrokePath(currentContext);
	UIGraphicsPopContext();

    
}


@end
