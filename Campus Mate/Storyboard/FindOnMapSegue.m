//
//  FindOnMapSegue.m
//  Campus Mate
//
//  Created by Rob Visentin on 6/7/12.
//  Copyright (c) 2012 Bowdoin College. All rights reserved.
//

#import "FindOnMapSegue.h"

@implementation FindOnMapSegue

/* this is the method called when the segue will take place. It specifies how the segue should look
 * 
 * This segue pops ne navigation controller to the root, assuming the map view controller is there. If the map view controller is ever changed to not be the root of the navigation stack, this code should change.
/*/
- (void)perform
{
    UIViewController *svc = (UIViewController *)self.sourceViewController;
    [svc.navigationController popToRootViewControllerAnimated:YES];
}

@end
