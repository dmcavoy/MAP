//
//  BuildingDetailSegue.m
//  Campus Mate
//
//  Created by Rob Visentin on 6/5/12.
//  Copyright (c) 2012 Bowdoin College. All rights reserved.
//

#import "BuildingDetailSegue.h"

@implementation BuildingDetailSegue

/* this is the method called when the segue will take place. It specifies how the segue should look
 * 
 * Currently, this is just a push transition. The class is just here in case someone in the future would like this segue to do something more exciting, like a custom animation or a modal transition.
/*/
- (void)perform
{
    UIViewController *svc = (UIViewController *)self.sourceViewController;
    [svc.navigationController pushViewController:self.destinationViewController animated:YES];
}

@end
