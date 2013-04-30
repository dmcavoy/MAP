//
//  BuildingButton.h
//  Campus Mate
//
//  Created by Rob Visentin on 6/6/12.
//  Copyright (c) 2012 Bowdoin College. All rights reserved.
//

// a button that also has a pointer to the building it is meant to represent

#import <UIKit/UIKit.h>

@class Building;

@interface BuildingButton : UIButton

@property (weak, nonatomic) Building *building; // the buildin associated with this button
@property (nonatomic, readonly) BOOL isMarked;  // whether the button is marked

- (void)mark;   // mark the button
- (void)unmark; // unmark the button

@end
