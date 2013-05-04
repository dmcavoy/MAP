//
//  Building.m
//  Campus Mate
//
//  Created by Stephanie Bond and Rob Visentin on 11/30/11.
//  Editted by Dani McAvoy Spring 2013
//  Copyright 2011 Bowdoin College All rights reserved.
//

#import "Building.h"

@implementation Building

@synthesize graphic = _graphic;
@synthesize audio = _audio;

-(id)initWithID:(int)buildingID
{
    self = [super init];
    
    if (self)
    {
        self.buildingID = buildingID;
        self.graphic = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:[NSString stringWithFormat:@"building-%i", self.buildingID] ofType:@"jpg"]];
        self.audio = [NSURL fileURLWithPath:[NSString stringWithFormat:@"%@/building-%i.mp3" , [[NSBundle mainBundle] resourcePath],self.buildingID]];
    }
    
    return self;
}

@end
