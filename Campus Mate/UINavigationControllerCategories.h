//
//  UINavigationControllerCategories.h
//  Bowdoin Map
//
//  Created by John Visentin on 1/22/13.
//
//  it seems silly, but adding a category was the only way I could make the iPhone support all rotations on iOS 6

#ifndef Bowdoin_Map_UINavigationControllerCategories_h
#define Bowdoin_Map_UINavigationControllerCategories_h

// override method to support all interface rotations (normall portraitUpsideDown is disabled for iPhone)
@interface UINavigationController (allRotation)
-(NSUInteger)supportedInterfaceOrientations;
@end

@implementation UINavigationController (allRotation)
-(NSUInteger)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskAll;
}
@end

#endif
