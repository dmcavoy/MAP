//
//  CMReferencePoint.m
//  Campus Mate
//
//  Created by Rob Visentin on 6/25/12.
//  Copyright (c) 2012 Bowdoin College. All rights reserved.
//

#import "CMReferencePoint.h"

@implementation CMReferencePoint

@synthesize x = _x;
@synthesize y = _y;
@synthesize lat = _lat;
@synthesize lon = _lon;
@synthesize d = _d;

- (id)initWithx:(double)x y:(double)y lat:(CLLocationDegrees)lat lon:(CLLocationDegrees)lon
{
    self = [self init];
    
    if (self) 
    {
        self.x = x;
        self.y = y;
        self.lat = lat;
        self.lon = lon;
    }
    return self;
}

@end
