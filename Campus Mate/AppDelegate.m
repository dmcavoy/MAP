//
//  AppDelegate.m
//  Campus Mate
//
//  Created by Rob Visentin on 6/5/12.
//  Editted by Dani McAvoy Spring of 2013
//  Copyright (c) 2012 Bowdoin College. All rights reserved.
//

#import "AppDelegate.h"
#import "CMDataManager.h" //!

@implementation AppDelegate

@synthesize window = _window;

/* performs the necessary start up functions
 *
 * CMDataManager - this app does not use core data (possible future change). Instead, it uses a singleton data manager to load, store, and save data. Reference point and building data is stored solely in the static defaultManager, and simply accessed by controllers, etc. (see CMDataManager.h comments for more details information)
 *
 * Appearance - iOS 5 introducted the ability to change the global appearance of UI elements. This removes the need to set the properties of each instance individually. Here the navigation bar is set to use navBarImage as its background. Note: navBarImage44 and -32 can be changed at any point to change the appearance of the navigation bar
/*/
- (void)setup
{
    /* fill the data mananger with data */
    [[CMDataManager defaultManager] loadReferencePoints];
    [[CMDataManager defaultManager] loadBuildings];
    
    /* customize UINavigationBar appearance */
    UIImage *navBarImage44 = [[UIImage imageNamed:@"navbar-44"] resizableImageWithCapInsets:UIEdgeInsetsMake(0.0f, 0.0f, 0.0f, 0.0f)];
    UIImage *navBarImage32 = [[UIImage imageNamed:@"navbar-32"] resizableImageWithCapInsets:UIEdgeInsetsMake(0.0f, 0.0f, 0.0f, 0.0f)];

    [[UINavigationBar appearance] setBackgroundImage:navBarImage44 forBarMetrics:UIBarMetricsDefault];
    [[UINavigationBar appearance] setBackgroundImage:navBarImage32 forBarMetrics:UIBarMetricsLandscapePhone];
    [[UINavigationBar appearance] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor], UITextAttributeTextColor, [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.8], UITextAttributeTextShadowColor, [NSValue valueWithUIOffset:UIOffsetMake(0, -1)], UITextAttributeTextShadowOffset, [UIFont fontWithName:FONT_NAME_BOLD size:0.0], UITextAttributeFont, nil]];    
    
    /* set UIBarButtonItem tint so it shows against new UINavigationBar background */
    [[UIBarButtonItem appearance] setTintColor:[UIColor grayColor]];
    
    // create a standardUserDefaults variable
    self.standardUserDefaults = [NSUserDefaults standardUserDefaults];
    
    // If first time opened set ask the user if they want tour mode
    if (![self.standardUserDefaults valueForKey:@"tourMode"]) {
        [self showAlertTourMode];
    }
   
}

/*
 Creates and shows the alerts for setting up the user default tour mode.
 */

-(void) showAlertTourMode {
    UIAlertView *alert = [[UIAlertView alloc]
                          initWithTitle: @"Tour Mode?"
                          message: @" Tour Mode will give you alerts when their are audio tours available for the building you are near. It works best when you are outside. \n \n Do you want to run the application in Tour Mode? "
                          delegate: self
                          cancelButtonTitle:@"No"
                          otherButtonTitles:@"Yes",nil];
    [alert show];
}


/*
  Method that responds to the tour mode alert view. Sets up the user default.
*/
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    //Yes
	if (buttonIndex == 1) {
        [self.standardUserDefaults setBool:YES forKey:@"tourMode"];
        [self.standardUserDefaults synchronize];
	}
    //No
	else {
        [self.standardUserDefaults setBool:NO forKey:@"tourMode"];
        [self.standardUserDefaults synchronize];
	}
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [self setup];

    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    /*
     Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
     Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
     */
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    /*
     Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
     If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
     */
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    /*
     Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
     */
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    /*
     Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
     */
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    /*
     Called when the application is about to terminate.
     Save data if appropriate.
     See also applicationDidEnterBackground:.
     */
}

@end
