//
//  CMBuildingDetailViewController.m
//  Campus Mate
//
//  Created by Rob Visentin on 6/5/12.
//  Copyright (c) 2012 Bowdoin College. All rights reserved.
//

#import "CMBuildingDetailViewController.h"
#import "CMDataManager.h"
#import "CMMapViewController.h"
#import "CMSelfAdjustingTextView.h"
#import "Building.h"

@interface CMBuildingDetailViewController ()
{
    __weak IBOutlet UIView *_feedbackView;
    __weak IBOutlet UIButton *_feedbackButton;
}
@end

@implementation CMBuildingDetailViewController

@synthesize building = _building;
@synthesize scrollView = _scrollView;
@synthesize buildingNameLabel = _buildingNameLabel;
@synthesize buildingAddressLabel = _buildingAddressLabel;
@synthesize buildingFunctionLabel = _buildingFunctionLabel;
@synthesize resourcesView = _resourcesView;
@synthesize descriptionView = _descriptionView;
@synthesize hoursView = _hoursView;
@synthesize buildingGraphic = _buildingGraphic;

- (void)setBuilding:(Building *)building
{
    _building = building;
    
    [self updateUI];
}

/* simply returns the controller's root view casted as a UIScrollView, for convenience */
- (UIScrollView *)scrollView
{
    return (UIScrollView *)self.view;
}

- (void)updateUI
{    
    /* the spacing between lables, images, and other UI elements. This is an arbitrary value based on what I thought looked good */
    float space = self.view.frame.size.height/32.0f;
        
    /* set the description text. The view will automatically resize to fit this text */
    self.descriptionView.text = self.building.description;
    
    /* set the function text. The view will automatically resize to fit this text */
    self.buildingFunctionLabel.text = self.building.function;
        
    /* set the resources text. The view will automatically resize to fit this text. Since the description view above it may have resized to new text, we must reset the frame of the resources view */
    self.resourcesView.text = self.building.departments;
    self.resourcesView.frame = CGRectMake(self.resourcesView.frame.origin.x, self.descriptionView.frame.origin.y + self.descriptionView.frame.size.height + space, self.resourcesView.frame.size.width, self.resourcesView.frame.size.height); 
    
    /* set the hours text. The view will automatically resize to fit this text. Since the resources view above it may have resized to new text, we must reset the frame of the hours view */
    self.hoursView.text = self.building.hours;
    self.hoursView.frame = CGRectMake(self.hoursView.frame.origin.x, self.resourcesView.frame.origin.y + self.resourcesView.frame.size.height + space, self.hoursView.frame.size.width, self.hoursView.frame.size.height);
    
    /* force the delegate method to be called for resizing purposes */
    [self.scrollView.delegate scrollViewDidZoom:self.scrollView];
    
    /* resize the rootview of the scroll view to fill the content area */
    CGRect rootViewFrame = [self.scrollView.delegate viewForZoomingInScrollView:self.scrollView].frame;
    rootViewFrame.size.height = self.scrollView.contentSize.height;
    [self.scrollView.delegate viewForZoomingInScrollView:self.scrollView].frame = rootViewFrame;
    
    // HERE IS WHERE WE WOULD MAKE IT LOOK BETTER!!!
    
    /* place the feedback view at the bottom of the scrollview content */
    CGRect feedbackFrame = _feedbackView.frame;
    feedbackFrame.origin.y = MAX(self.scrollView.frame.size.height, self.scrollView.contentSize.height) - feedbackFrame.size.height;
    _feedbackView.frame = feedbackFrame;
}

/* toggles between min and max zoomscale (on a double tap) */
- (IBAction)toggleZoomScale
{
    UIScrollView *scrollView = self.scrollView;
    
    float newZoomScale = (scrollView.maximumZoomScale + scrollView.minimumZoomScale)/2.0f - scrollView.zoomScale >= 0 ? scrollView.maximumZoomScale : scrollView.minimumZoomScale;
    
    [scrollView setZoomScale:newZoomScale animated:YES];
}

/* displays a form to submit feedback about the building. This feedback is presumably reviewed and then used to update the database */
- (IBAction)sendFeedback
{
    /* check to see if device is configured to send mail */
    if ([MFMailComposeViewController canSendMail])
    {
        MFMailComposeViewController *mailComposeController = [[MFMailComposeViewController alloc] init];
        mailComposeController.mailComposeDelegate = self;
        
        /* fill in mail fields with appropriate defaults */
        [mailComposeController setToRecipients:[NSArray arrayWithObject:FEEDBACK_RECIPIENT]];
        [mailComposeController setSubject:[NSString stringWithFormat:@"[%@ Feedback] %@", [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleDisplayName"], self.building.name]];
        [mailComposeController setMessageBody:[NSString stringWithFormat:@"<b><font size='2'>Please alter the fields below, making changes to any information you believe you be incorrect or misleading. Additional comments should be made below the dotted line.</font></b></br></br><b>Name: </b><font size='2'>%@</font></br><b>Function: </b><font size='2'>%@</font></br><b>Description: </b><font size='2'>%@</font></br><b>Resources: </b><font size='2'>%@</font></br><b>Hours: </b><font size='2'>%@</font></br>---------------------------------------", self.building.name, self.building.function, self.building.description, self.building.departments, self.building.hours] isHTML:YES];
        
        if([self respondsToSelector:@selector(presentViewController:animated:completion:)])
        {
            [self presentViewController:mailComposeController animated:YES completion:^{}];
        }
        else
        {
            [self presentModalViewController:mailComposeController animated:YES];
        }        
    }
    else
    {
        [[[UIAlertView alloc] initWithTitle:@"Enable Mail" message:@"In order to send feedback your device must be able to send mail" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
    }
}

#pragma mark - UIScrollViewDelegate methods

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    return [self.view.subviews objectAtIndex:0];
}

- (void)scrollViewDidZoom:(UIScrollView *)scrollView
{
    float space = self.view.frame.size.height/32.0f;
    
    scrollView.contentSize = CGSizeMake(scrollView.frame.size.width*scrollView.zoomScale, scrollView.zoomScale * MAX(scrollView.frame.size.height, (CGRectGetMaxY(self.hoursView.frame) + _feedbackView.frame.size.height) + space));    
}

#pragma mark - MFMailComposeDelegate methods

- (void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error
{
    [self dismissViewControllerAnimated:YES completion:^(void)
    {
        if (result == MFMailComposeResultSent)
        {
            [[[UIAlertView alloc] initWithTitle:@"Feedback Sent" message:@"Your feedback has been sent and will be reviewed. Thank you!" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
        }
    }];
}

#pragma mark - view lifecycle

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    /* perform a segue to "find" a building on the map. This wil highlight and zoom to the building's location */
    if ([segue.identifier isEqualToString:@"findOnMap"]) 
    {
        CMMapViewController *mvc = (CMMapViewController *)[self.navigationController.viewControllers objectAtIndex:0];
        
        /* first, unmark all the marked buildings on the map */
        for (NSString *buildingName in mvc.markedBuildings) 
        {
            [mvc unmarkBuilding:[[CMDataManager defaultManager] buildingNamed:buildingName]];
        }
        
        /* then, mark this building and zoom to it on the map */
        [mvc markBuilding:self.building];
        [mvc zoomToBuilding:self.building];
    }
    else if ([segue.identifier isEqualToString:@"giveDirections"])
    {
        CMMapViewController *mvc = (CMMapViewController *)[self.navigationController.viewControllers objectAtIndex:0];
        
        /* first, unmark all the marked buildings on the map */
        for (NSString *buildingName in mvc.markedBuildings)
        {
            [mvc unmarkBuilding:[[CMDataManager defaultManager] buildingNamed:buildingName]];
        }
        
        /* then, mark this building and zoom to it on the map */
        [mvc markBuilding:self.building];
        // get current location and draw line between
        // current location and selected building
        [mvc zoomToBuilding:self.building];
    }
}

- (void)viewDidAppear:(BOOL)animated
{
    [self updateUI];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    self.navigationItem.title = [[self.building.name componentsSeparatedByString:@":"] objectAtIndex:0];
    [self.buildingNameLabel setText:self.building.name];
    [self.buildingAddressLabel setText:self.building.address];
    self.buildingGraphic.image = self.building.graphic;
    
    [self updateUI];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self.buildingNameLabel setFont:[UIFont fontWithName:FONT_NAME_BOLD size:self.buildingNameLabel.font.pointSize]];
    [self.buildingAddressLabel setFont:[UIFont fontWithName:FONT_NAME_STANDARD size:self.buildingNameLabel.font.pointSize]];
    
    /* title text of feedback button */
    NSString *feedbackText = @"submit feedback";
    
    /* sets the attributes of the feedback button title to look like a hyperlink */
    NSArray *normalAttributeValues = [NSArray arrayWithObjects:[UIFont fontWithName:FONT_NAME_STANDARD size:12], [UIColor blueColor], [NSNumber numberWithInt:NSUnderlineStyleSingle], nil];
    NSArray *highlightedAttributeValues = [NSArray arrayWithObjects:[UIFont fontWithName:FONT_NAME_STANDARD size:12], [UIColor darkGrayColor], [NSNumber numberWithInt:NSUnderlineStyleSingle], nil];
    
    NSArray *attributeKeys = [NSArray arrayWithObjects:NSFontAttributeName, NSForegroundColorAttributeName, NSUnderlineStyleAttributeName, nil];
    
    /* set attributed title for normal state */
    NSAttributedString *normalFeedbackString = [[NSAttributedString alloc] initWithString:feedbackText attributes:[NSDictionary dictionaryWithObjects:normalAttributeValues forKeys:attributeKeys]];
    [_feedbackButton setAttributedTitle:normalFeedbackString forState:UIControlStateNormal];
    
    /* set attributed title for highlighted state */
    NSAttributedString *highlitedFeedbackString = [[NSAttributedString alloc] initWithString:feedbackText attributes:[NSDictionary dictionaryWithObjects:highlightedAttributeValues forKeys:attributeKeys]];
    [_feedbackButton setAttributedTitle:highlitedFeedbackString forState:UIControlStateHighlighted];
}

- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
    [super willRotateToInterfaceOrientation:toInterfaceOrientation duration:duration];
        
    /* things may look weird if you rotate while zoomed in, so reset the zoom scale to 1 */
    self.scrollView.zoomScale = 1.0f;
    
    /* update the UI after a brief delay, to match the UI rotation animation speed */
    [self performSelector:@selector(updateUI) withObject:nil afterDelay:0.35*duration];
}

/* all orientations supported for iOS 6.0 or later */
-(NSUInteger)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskAll;
}

/* all orientations supported */
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return YES;
}

-(IBAction)getDirections:(id)sender{
    NSLog(@"directions");
}


@end
