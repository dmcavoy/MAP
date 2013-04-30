//
//  CMCommon.h
//  Campus Mate
//
//  Created by Rob Visentin on 6/5/12.
//  Copyright (c) 2012 Bowdoin College. All rights reserved.
//

#ifndef CMCommon_h
#define CMCommon_h

enum
{
    BuildModeSimulator = 0,
    BuildModeDevice
};
typedef NSInteger BuildMode;

#if TARGET_IPHONE_SIMULATOR
#define MODE BuildModeSimulator
#else
#define MODE BuildModeDevice
#endif

//constants
#define HOST @"www.bowdoin.edu/apps/campus"
#define CONNECTION_TIMEOUT 8
#define BUILDINGS_PLIST @"Buildings"
#define REFERENCE_POINTS_PLIST @"ReferencePoints"
#define PIN_IMAGE_NORMAL @"pinPurple.png"
#define PIN_IMAGE_HIGHLIGHTED @"pinOrange.png"
#define PIN_IMAGE_USER @"pinGreen.png"
#define FONT_NAME_STANDARD @"Georgia"
#define FONT_NAME_BOLD @"Georgia-Bold"
#define MAP_SIZE CGSizeMake(4372, 2915) // change this if the map image changes!
#define FEEDBACK_RECIPIENT @"mapfeedback@bowdoin.edu" // the e-mail address to which user feedback is sent

static inline double fangleBetween(double endAngle, double startAngle)
{
    float a = endAngle - startAngle;
    a += (a > M_PI) ? -(2 * M_PI) : (a < -M_PI) ? (2 * M_PI) : 0;
        
    return a;
}

#endif
