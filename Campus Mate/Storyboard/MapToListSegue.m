//
//  MapToListSegue.m
//  Campus Mate
//
//  Created by Rob Visentin on 6/5/12.
//  Copyright (c) 2012 Bowdoin College. All rights reserved.
//

#import "MapToListSegue.h"

@implementation MapToListSegue

/* this is the method called when the segue will take place. It specifies how the segue should look
 * 
 * This segue uses the page curl down transition
/*/
- (void)perform
{
    UIViewController *svc = (UIViewController *)self.sourceViewController;
    
    [UIView animateWithDuration:.75 animations:^(void)
     {
         [UIView setAnimationTransition:UIViewAnimationTransitionCurlUp forView:svc.navigationController.view cache:NO];
     }];
    
   [svc.navigationController pushViewController:self.destinationViewController animated:NO];
}

@end
