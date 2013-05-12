//
//  DirectionsView.h
//  Bowdoin Map
//
//  Created by Danielle McAvoy on 5/7/13.
//
/* 
 A class that creates a line that indicates the general directions for a building from the users current location.
 */

#import <UIKit/UIKit.h>
@interface DirectionsView : UIView

@property (nonatomic) CGPoint start;
// user pin map location

@property (nonatomic) CGPoint destination;
// destination building map location

@property (nonatomic) UIButton * dismissButton;

@end
