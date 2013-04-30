//
//  CMReferencePoint.h
//  Campus Mate
//
//  Created by Rob Visentin on 6/25/12.
//  Copyright (c) 2012 Bowdoin College. All rights reserved.
//
// Stores data about a GPS -> x,y coordinate mapping

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

@interface CMReferencePoint : NSObject

@property (nonatomic) double x;
@property (nonatomic) double y;
@property (nonatomic) CLLocationDegrees lat;
@property (nonatomic) CLLocationDegrees lon;
@property (nonatomic) double d;

- (id)initWithx:(double)x y:(double)y lat:(CLLocationDegrees)lat lon:(CLLocationDegrees)lon;

@end
