//
//  CMBuildingDetailViewController.h
//  Campus Mate
//
//  Created by Rob Visentin on 6/5/12.
//  Copyright (c) 2012 Bowdoin College. All rights reserved.
//
// Shows more detailed information about a building, including its name, 911 address, functon, description, resources (departments, etc.), and hours

#import <MessageUI/MessageUI.h>
#import <MessageUI/MFMailComposeViewController.h>
#import <UIKit/UIKit.h>

@class Building, CMSelfAdjustingTextView;

@interface CMBuildingDetailViewController : UIViewController <UIScrollViewDelegate, MFMailComposeViewControllerDelegate>

@property (weak, nonatomic) Building *building;
@property (nonatomic, readonly) UIScrollView *scrollView; // this is in fact the root view of the controller
@property  (nonatomic) NSMutableArray *professorsInBuilding;  //list of the professors with offices in current building
@property (nonatomic) NSDictionary *professors;

@property (weak, nonatomic) IBOutlet UILabel *buildingNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *buildingAddressLabel;
@property (weak, nonatomic) IBOutlet UILabel *buildingFunctionLabel;
@property (weak, nonatomic) IBOutlet CMSelfAdjustingTextView *descriptionView;
@property (weak, nonatomic) IBOutlet CMSelfAdjustingTextView *resourcesView;
@property (weak, nonatomic) IBOutlet CMSelfAdjustingTextView *hoursView;
@property (weak, nonatomic) IBOutlet UIImageView *buildingGraphic;

// instantly toggle the zoom scale between fully zoomed in and fully zoomed out
- (IBAction)toggleZoomScale;

// displays a form to submit feedback about this building. This feedback is presumably reviewed and then used to update the database
- (IBAction)sendFeedback;

@end
