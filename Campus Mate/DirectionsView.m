//
//  DirectionsView.m
//  Bowdoin Map
//
//  Created by Maddie Baird on 2013-05-12.
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
