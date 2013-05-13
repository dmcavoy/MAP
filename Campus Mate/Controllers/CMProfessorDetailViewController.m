//
//  CMProfessorDetailViewController.m
//  Bowdoin Map
//
//  Created by Maddie Baird on 2013-05-07.
//
//

#import "CMProfessorDetailViewController.h"
#import "CMProfViewController.h"
#import "CMMapViewController.h"
#import "CMDataManager.h"
#import "Professor.h"

@interface CMProfessorDetailViewController ()

@end

@implementation CMProfessorDetailViewController

@synthesize building = _building;
@synthesize professor = _professor;
@synthesize profNameLabel = _profNameLabel;
@synthesize addressLabel = _addressLabel;
@synthesize departmentLabel = _departmentLabel;
@synthesize emailLabel = _emailLabel;

-(void)setProfessor:(Professor *)professor
{
      _professor = professor;
      [self updateUI];
}
-(UIScrollView *)scrollView
{
      return (UIScrollView *)self.view;
}
-(void)updateUI
{
      /* the spacing between lables, images, and other UI elements. This is an arbitrary value based on what I thought looked good */
      float space = self.view.frame.size.height/32.0f;
      
      //force delegate method to be called for resizing
      [self.scrollView.delegate scrollViewDidZoom:self.scrollView];
      
      /* resize the rootview of the scroll view to fill the content area */
      CGRect rootViewFrame = [self.scrollView.delegate viewForZoomingInScrollView:self.scrollView].frame;
      rootViewFrame.size.height = self.scrollView.contentSize.height;
      [self.scrollView.delegate viewForZoomingInScrollView:self.scrollView].frame = rootViewFrame;
}

//not finished
- (void)viewDidLoad
{
      [super viewDidLoad];
      
      [self.profNameLabel setFont:[UIFont fontWithName:FONT_NAME_BOLD size:self.profNameLabel.font.pointSize]];
      [self.addressLabel setFont:[UIFont fontWithName:FONT_NAME_STANDARD size:self.profNameLabel.font.pointSize]];
      
      NSArray *normalAttributeValues = [NSArray arrayWithObjects:[UIFont fontWithName:FONT_NAME_STANDARD size:12], [UIColor blueColor], [NSNumber numberWithInt:NSUnderlineStyleSingle], nil];
      NSArray *highlightedAttributeValues = [NSArray arrayWithObjects:[UIFont fontWithName:FONT_NAME_STANDARD size:12], [UIColor darkGrayColor], [NSNumber numberWithInt:NSUnderlineStyleSingle], nil];
}
- (void)viewDidUnload
{
    [self setProfNameLabel:nil];
    [self setDepartmentLabel:nil];
    [self setAddressLabel:nil];
    [self setEmailLabel:nil];
    [super viewDidUnload];
}
- (IBAction)toggleScrollView:(id)sender
{
      UIScrollView *scrollView = self.scrollView;
      
      double newZoom = (scrollView.maximumZoomScale + scrollView.minimumZoomScale) / 2.0f - scrollView.zoomScale >= 0 ? scrollView.maximumZoomScale : scrollView.minimumZoomScale;
      
      [scrollView setZoomScale:newZoom animated:YES];
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
      if([segue.identifier isEqualToString:@"findOnMap"])
      {
            CMMapViewController *mvc = (CMMapViewController *)[self.navigationController.viewControllers objectAtIndex:0];
            
            for(NSString *buildingName in mvc.markedBuildings)
            {
                  [mvc unmarkBuilding:[[CMDataManager defaultManager] buildingNamed:buildingName]];
            }
            /* mark building and show on map*/
            [mvc markBuilding:self.building];
            //get current location and draw line between current location and selected building
            [mvc zoomToBuilding:self.building];
      
      }
}
@end
