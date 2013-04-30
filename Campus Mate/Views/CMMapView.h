//
//  CMMapView.h
//  Bowdoin Map
//
//  Created by John Visentin on 1/12/13.
//  Copyright (c) 2012 Bowdoin College. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CMMapView : UIView

@property (copy, nonatomic) NSString *tileNameBase; // base name of tile images of the form [tileNameBase]-row-col.jpg

- (UIImage *)tileForRow:(int)row col:(int)col;      // returns the right tile image to draw at given row and col

@end
