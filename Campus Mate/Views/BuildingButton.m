//
//  BuildingButton.m
//  Campus Mate
//
//  Created by Rob Visentin on 6/6/12.
//  Copyright (c) 2012 Bowdoin College. All rights reserved.
//

#import "BuildingButton.h"

@implementation BuildingButton

@synthesize building;
@synthesize isMarked;

- (void)mark
{
    isMarked = YES;
}

- (void)unmark
{
    isMarked = NO;
}

@end
