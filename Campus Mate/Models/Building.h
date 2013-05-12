//
//  Building.h
//  Campus Mate
//
//  Created by Stephanie Bond and Rob Visentin on 11/30/11.
//  Copyright 2011 Bowdoin College All rights reserved.
//
// This class just holds information about a particular building

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>
#import "Professor.h"

@interface Building : NSObject 

@property (nonatomic) int buildingID;
@property (strong, nonatomic) UIImage *graphic;
@property (strong, nonatomic) NSURL * audio;
@property (copy, nonatomic) NSString *function;
@property (copy, nonatomic) NSString *departments;
@property (copy, nonatomic) NSString *name;
@property (copy, nonatomic) NSString *description;
@property (copy, nonatomic) NSString *address;
@property (copy, nonatomic) NSString *hours;
@property (nonatomic) NSMutableArray *professors;
@property (nonatomic) CLLocationDegrees latitude;
@property (nonatomic) CLLocationDegrees longitude;

- (id)initWithID:(int)buildingID;

@end
