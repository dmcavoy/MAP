//
//  CMMapViewController.h
//  Campus Mate
//
//  Created by Rob Visentin on 6/5/12.
//  Copyright (c) 2012 Bowdoin College. All rights reserved.
//

/* displays an image (presumably a map) on a scroll view
 * buildings on the map may have pins associated with them that, when tapped, display more information about that building
 * marked buildings have pins of a different color than unmarked buildings
 * the user can also search for a building(s) using the search bar
 */

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import "CMMapView.h"
#import "AudioAlerts.h"
#import "DirectionsView.h"

@class Building;

@interface CMMapViewController : UIViewController <AudioAlertsDelegate, UIScrollViewDelegate, UISearchBarDelegate, CLLocationManagerDelegate>

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;  // the scroll view used to scroll around the map
@property (strong, nonatomic) CMMapView *map;                 // the view (backed by a CATiledLayer) displaying the map image
@property (strong, nonatomic) UISearchBar *searchBar;
@property (copy, nonatomic) NSArray *markedBuildings;           // names of buildings that are marked (usually because of a search)

@property(strong, nonatomic)AudioAlerts * audioAlert;

- (CGPoint)mapPointFromLatitude:(CLLocationDegrees)latitude longitude:(CLLocationDegrees)longitude;
- (void)markBuilding:(Building *)building;          // set a given building as marked
- (void)unmarkBuilding:(Building *)building;        // set a given building as unmarked
- (void)zoomToBuilding:(Building *)building;        // zoom to a given building
- (void)zoomToShowBuildings:(NSArray *)buildings;   // zoom to display the smallest bounding box in which all given buildings are visible
- (void)dropPinAtBuilding:(Building *)building;     // drop a pin button on the location of the given building on the map
- (IBAction)toggleSearchBar;                        // toggle the search bar popover
- (IBAction)toggleInfo;                             // toggle the view displaying credits, etc.
-(Building *)drawDirectionsTo:(Building*)destination;
    // draws a line between destiantion building and user location
    
@end
