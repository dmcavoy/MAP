//
//  CMscrollViewController.m
//  Campus Mate
//
//  Created by Rob Visentin on 6/5/12.
//  Copyright (c) 2012 Bowdoin College. All rights reserved.
//

#import "UINavigationControllerCategories.h"
#import "CMMapViewController.h"
#import "CMBuildingDetailViewController.h"
#import "CMDataManager.h"
#import "CMReferencePoint.h"
#import "Building.h"
#import "BuildingButton.h"


/* private interface */
@interface CMMapViewController()
{
@private
    BuildingButton *_lastSelectedButton;    // the last pin button the user tapped 
    NSMutableArray *_markedBuildingNames;   // list of the names of marked buildings
    CLLocationManager *_locationManager;    // used to pinpoint user's location on the map
    
    __weak IBOutlet UITextView *_infoView;      // view used to display credits, etc.
}
- (void)initialize; // initialize necessary instance variables
- (void)displayDetailsOfBuildingAtPinButton:(BuildingButton *)sender; // display the details of the building corresponding to the tapped pin
@end

@implementation CMMapViewController

@synthesize scrollView = _scrollView;
@synthesize map = _map;
@synthesize searchBar = _searchBar;
@synthesize markedBuildings = _markedBuildings;
@synthesize audioAlert = _audioAlert;

#define kSearchBarFadeDuraion 0.33f

/* location of the pin tip in the pin image */
static const CGPoint PinTip = {16.0f, 69.0f};

/* size of the searchbar's frame */
static const CGSize SearchBarSize = {295.0f, 44.0f};

- (id)init
{
    self = [super init];
    
    if (self) 
    {
        [self initialize];
    }
    return self;
}

/* called when initializing from a storyboard. currently is the same as init */
- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    
    if (self) 
    {
        [self initialize];
    }
    return self;
}

- (void)initialize
{
    _markedBuildingNames = [NSMutableArray array];
    
    _audioAlert = [[AudioAlerts alloc]init];
    
    _locationManager = [[CLLocationManager alloc] init];
    _locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    _locationManager.distanceFilter = 20;
    _locationManager.delegate = self;
}

/* getter for the map */
- (CMMapView *)map
{
    if (!_map)
    {
//        _map = [[UIImageView alloc] initWithImage:[UIImage imageNamed:MAP_IMAGE]];
//        _map.userInteractionEnabled = YES;
        _map = [[CMMapView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, self.scrollView.contentSize.width, self.scrollView.contentSize.height)];
    }
    return _map;
}

- (UISearchBar *)searchBar
{
    if (!_searchBar)
    {
        /* create the search bar */
        _searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0.0f, -1.0f, SearchBarSize.width, SearchBarSize.height)]; // used -1 for y because there is an unattractive shiny line on the topmost pixel of the searchbar
        _searchBar.delegate = self;
        _searchBar.barStyle = UIBarStyleBlack;
        _searchBar.placeholder = @"Search all building fields";
        
        /* add a nice drop shadow to the bar */
        _searchBar.layer.shadowColor = [UIColor blackColor].CGColor;
        _searchBar.layer.shadowOpacity = 1.0;
        _searchBar.layer.shadowRadius = 5.0f;
        _searchBar.layer.shadowOffset = CGSizeMake(0, 4);
        _searchBar.clipsToBounds = NO;
        
        /* search bar starts off hidden */
        _searchBar.alpha = 0.0f;
    }
    
    return _searchBar;
}

/* returns a list of the names of marked buildings */
- (NSArray *)markedBuildings
{
    return [_markedBuildingNames copy];
}

/* drops a pin on the map at the location of the given building */
- (void)dropPinAtBuilding:(Building *)building
{
    UIImage *pinImage = [UIImage imageNamed:PIN_IMAGE_NORMAL]; 
    CGPoint buildingPoint = [self mapPointFromLatitude:building.latitude longitude:building.longitude];
    CGRect frame = CGRectMake(buildingPoint.x-PinTip.x, buildingPoint.y-PinTip.y, pinImage.size.width, pinImage.size.height);
    
    /* checks if a pin is already created for on this building */
    BuildingButton *button = (BuildingButton *)[self.map viewWithTag:[building hash]];
    
    /* if a pin does not exist for this building, create it and add it to the map. else simply update the existing pin's location */
    if (!button) 
    {
        BuildingButton* button = [[BuildingButton alloc] initWithFrame:frame];
        button.building = building;
        
        button.tag = [building hash];
        
        [button setBackgroundImage:pinImage forState:UIControlStateNormal];
        [button addTarget:self action:@selector(displayDetailsOfBuildingAtPinButton:) forControlEvents:UIControlEventTouchUpInside];
        [self.map addSubview:button];
    }
    else
    {
        [button setFrame:frame];
    }    
}

/* display the details of the building at given pin */
- (void)displayDetailsOfBuildingAtPinButton:(BuildingButton *)sender
{
    if (_lastSelectedButton.isMarked)
    {
        [self unmarkBuilding:_lastSelectedButton.building];
    }
    
    _lastSelectedButton = sender;
    [self markBuilding:_lastSelectedButton.building];
    
    [self performSegueWithIdentifier:@"toBuildingDetail" sender:self];
}

/* mark the given building */
- (void)markBuilding:(Building *)building
{    
    /* retrieve the pin button associated with the building */
    BuildingButton *toMark = (BuildingButton *)[self.view viewWithTag:[building hash]];
    
    /* if there exists a pin for this building and it is not already marked, mark it */
    if (toMark && !toMark.isMarked) 
    {
        /* mark the building by changing the background image of its associated pin */
        [toMark setBackgroundImage:[UIImage imageNamed:PIN_IMAGE_HIGHLIGHTED] forState:UIControlStateNormal];
        [toMark mark];
        [_markedBuildingNames addObject:building.name];
    }
}

/* unmark the given building */
- (void)unmarkBuilding:(Building *)building
{
    /* retrieve the pin button associated with the building */
    BuildingButton *toUnmark = (BuildingButton *)[self.view viewWithTag:[building hash]];
    
    /* if there exists a pin for this building and it is marked, unmark it */
    if (toUnmark && toUnmark.isMarked) 
    {
        /* unmark the building by changing the background image of its associated pin back to normal */
        [toUnmark setBackgroundImage:[UIImage imageNamed:PIN_IMAGE_NORMAL] forState:UIControlStateNormal];
        [toUnmark unmark];
        [_markedBuildingNames removeObject:building.name];
    }
}

/* zoom the map to a given building */
- (void)zoomToBuilding:(Building *)building
{       
    [self zoomToShowBuildings:[NSArray arrayWithObject:building]];  
}

/* zoom the map to dislay the smallest bounding box in which all given buildings are visible */
- (void)zoomToShowBuildings:(NSArray *)buildings
{
    /* save the max zoom scale, then set it to 1. We don't want the map zooming too far in if the bounding box is small */
    float savedMaxZoomScale = self.scrollView.maximumZoomScale;
    self.scrollView.maximumZoomScale = 1.0f;
    
    CGFloat minX = self.scrollView.contentSize.width / self.scrollView.zoomScale;
    CGFloat minY = self.scrollView.contentSize.height / self.scrollView.zoomScale;
    CGFloat maxX = 0.0f;
    CGFloat maxY = 0.0f;
    
    /* find the min and max x and y of the building locations to construct the bounding box */
    for (Building *building in buildings) 
    {
        CGPoint buildingPoint = [self mapPointFromLatitude:building.latitude longitude:building.longitude];
        minX = fminf(minX, buildingPoint.x);
        minY = fminf(minY, buildingPoint.y);
        maxX = fmaxf(maxX, buildingPoint.x);
        maxY = fmaxf(maxY, buildingPoint.y);
    }
    
    /* how much "padding" to add to the box in the x and y directions */
    CGFloat offsetX = self.view.frame.size.width / 16.0f;
    CGFloat offsetY = (self.view.frame.size.height / 16.0f) + self.navigationController.navigationBar.frame.size.height;
    
    /* create the bounding box */
    CGRect boundingBox = CGRectMake(fmaxf(0.0f, minX - offsetX), fmaxf(0.0f, minY - offsetY), fminf(self.scrollView.contentSize.width / self.scrollView.zoomScale, maxX - minX + 2*offsetX), fminf(self.scrollView.contentSize.height / self.scrollView.zoomScale, maxY - minY + 2*offsetY));
    
    /* zoom to the bounding box and reset the max zoom scale */
    [self.scrollView zoomToRect:boundingBox animated:NO];
    self.scrollView.maximumZoomScale = savedMaxZoomScale;
}

/* convert from a GPS lat/lon to a coordinate on our map image. Algorithm provided by Andrew Currier of Bowdoin IT */
- (CGPoint)mapPointFromLatitude:(CLLocationDegrees)latitude longitude:(CLLocationDegrees)longitude
{
    static const CLLocationDegrees kmPerDegreeLat = 111.132;
    static const CLLocationDegrees kmPerDegreeLon = 80.209;
    
    CGFloat x, y;
    CLLocationDegrees dNorth, dEast;
    
    NSArray *referencePoints = [[CMDataManager defaultManager] referencePoints];
    
    /* calculate distance between current point and each ref point */
    for (CMReferencePoint *ref in referencePoints) 
    {
        dNorth = (latitude - ref.lat) * kmPerDegreeLat;
        dEast = (longitude - ref.lon) * kmPerDegreeLon;
        
        ref.d = sqrt(dNorth*dNorth + dEast*dEast);
    }
    
    /* sort ref points in ascending order by distance from current point */
    referencePoints = [referencePoints sortedArrayUsingComparator:^NSComparisonResult(CMReferencePoint *a, CMReferencePoint *b)
    {
        if (a.d < b.d) 
        {
            return NSOrderedAscending;
        }
        else if (a.d > b.d) 
        {
            return NSOrderedDescending;
        }
        else 
        {
            return NSOrderedSame;
        }
    }];
    
    CMReferencePoint *closest = (CMReferencePoint *)[referencePoints objectAtIndex:0];
    CMReferencePoint *secondClosest = (CMReferencePoint *)[referencePoints objectAtIndex:1];
    
    dNorth = (secondClosest.lat - closest.lat) * kmPerDegreeLat;
    dEast = (secondClosest.lon - closest.lon) * kmPerDegreeLon;
    double distanceKm = sqrt(dNorth*dNorth + dEast*dEast);
        
    if (distanceKm < 0.01 || closest.d < 0.01) 
    {
        /* snap to nearest ref point */
        
        x = closest.x;
        y = closest.y;
    }
    else 
    {
        /* two closest points are different */
        
        double dx = secondClosest.x - closest.x;
        double dy = secondClosest.y - closest.y;
        double d = sqrt(dx*dx + dy*dy);
        
        double pixelsPerKm = d/distanceKm;
        
        double d0 = pixelsPerKm * closest.d;
        double d1 = pixelsPerKm * secondClosest.d;
        
        if (d0 + d1 <= d) 
        {
            /* point on line (interpolate */
            
            double d3 = d0 + d1;
            
            x = closest.x + dx * d0 / d3;
            y = secondClosest.y + dy * d0 / d3;
        }
        else 
        {
            /* vertex on triangle (find circle intersection points) */
            
            /* 3/26/2005 Tim Voght http://local.wasp.uwa.edu.au/~pbourke/geometry/2circle/tvoght.c */
            
            double a = ((d0*d0) - (d1*d1) + (d*d)) / (2.0 * d);
            
            double x2 = closest.x + (dx * a/d);
            double y2 = closest.y + (dy * a/d);
            
            double h = sqrt(d0*d0 - a*a);
            
            double rx = -dy * (h/d);
            double ry = dx * (h/d);
            
            double xa = x2 + rx;
            double xb = x2 - rx;
            double ya = y2 + ry;
            double yb = y2 - ry;
            
            /* there are 2 solutions, so figure out which is the right one */
            
            double b = atan2(dNorth, dEast);
            double bi = atan2((latitude-closest.lat) * kmPerDegreeLat, (longitude-closest.lon) * kmPerDegreeLon);
            
            double mb = atan2(-dy, dx);
            double mbia = atan2(-ya + closest.y, xa - closest.x);
            
            double bearing = fangleBetween(bi, b);
            double mapBearing = fangleBetween(mbia, mb);
            
            if (bearing * mapBearing > 0) 
            {
                /* bearings have the same sign, so pick point A */
                
                x = xa;
                y = ya;
            }
            else
            {
                /* bearings have opposite sign, so pick point B */
                
                x = xb;
                y = yb;
            }
        }
    }
                       
    return CGPointMake(x, y);
}

/* toggle display of the search bar from the search bar button*/
- (IBAction)toggleSearchBar
{    
    [_searchBar resignFirstResponder];
    
    [UIView animateWithDuration:kSearchBarFadeDuraion animations:^(void)
     {
         _searchBar.alpha = (int)_searchBar.alpha ^ 1;
     }];
}

/* toggle display of the view with credits, etc. */
- (IBAction)toggleInfo
{
    if (CGAffineTransformEqualToTransform(_infoView.transform, CGAffineTransformIdentity))
    {
        /* slide the info view out from the right */
        [UIView animateWithDuration:0.25 animations:^(void)
         {
             _infoView.transform = CGAffineTransformMakeTranslation(_infoView.frame.size.width, 0.0f);
         }];
    }
    else
    {
        /* slide the info view back off the screen */
        [UIView animateWithDuration:0.25 animations:^(void)
         {
             _infoView.transform = CGAffineTransformIdentity;
         }];
    }
}

#pragma mark - UISearchBarDelegate methods

/* dismiss the search bar if user presses "search" */
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    [self toggleSearchBar];
}

/* called when user changes the text in the search bar */
- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    /* if search bar was cleared, just return */
    if ([searchText isEqualToString:@""]) 
    {
        return;
    }
    
    /* unmark all marked buildings */
    NSArray *buildingNames = [_markedBuildingNames copy];
    for (NSString *buildingName in buildingNames) 
    {
        [self unmarkBuilding:[[CMDataManager defaultManager] buildingNamed:buildingName]];
    }
    
    /* get all loaded buildings from the data manager */
    NSArray *allBuildings = [[CMDataManager defaultManager] buildings];
    NSMutableArray *searchResults = [NSMutableArray array];
        
    /* search through all buildings, checking name description and departments, to determine which ones match the search */
    for (Building *building in allBuildings) 
    {
        NSRange nameRange = [[building.name lowercaseString] rangeOfString:[searchText lowercaseString]];
        NSRange functionRange = [[building.function lowercaseString] rangeOfString:[searchText lowercaseString]];
        NSRange descriptionRange = [[building.description lowercaseString] rangeOfString:[searchText lowercaseString]];
        NSRange departmentsRange = [[building.departments lowercaseString] rangeOfString:[searchText lowercaseString]];
        
        /* if the search text was found in some field of the building, mark it and add it to seach results */
        if (nameRange.location != NSNotFound || descriptionRange.location != NSNotFound || departmentsRange.location != NSNotFound || functionRange.location != NSNotFound)
        {
            [self markBuilding:building];
            [searchResults addObject:building];
        }
    }
    
    /* zoom to display all search results */
    [self zoomToShowBuildings:searchResults];
}

#pragma mark - UIScrollViewDelegate methods

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    return self.map;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{}


#pragma mark - CLLocationManagerDelegate methods

/* update the locaion of the green pin indication the user's location */
- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation
{
    // PUT CODE HERE TO CHECK IF ITS A BUILDING WITH AUDIO AND SHOW NOTIFICATION
    
    UIAlertView *alert = [[UIAlertView alloc]
                          initWithTitle: @"Building Audio"
                          message: @"There is a building audio available for this building"
                          delegate: self.audioAlert
                          cancelButtonTitle:@"No Thanks"
                          otherButtonTitles:@"Listen",nil];
    [alert show];
    
    
    /* convert lon/lat to x/y coordinates */
    CGPoint mapPoint = [self mapPointFromLatitude:newLocation.coordinate.latitude longitude:newLocation.coordinate.longitude];
    
    UIImage *userPinImage = [UIImage imageNamed:PIN_IMAGE_USER];

    UIView *userPin = [self.view viewWithTag:@"user pin".hash];
    
    /* if the user's location pin doesn't exist, create it. Otherwise, just change its frame */
    if (!userPin) 
    {
        UIImageView *newUserPin = [[UIImageView alloc] initWithImage:userPinImage];
        newUserPin.frame = CGRectMake(mapPoint.x-PinTip.x, mapPoint.y-PinTip.y, userPinImage.size.width, userPinImage.size.height);
        newUserPin.tag = @"user pin".hash;
        [self.map addSubview:newUserPin];
    }
    else 
    {
        userPin.frame = CGRectMake(mapPoint.x-PinTip.x, mapPoint.y-PinTip.y, userPinImage.size.width, userPinImage.size.height);
    }
}

#pragma mark - View lifecycle

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"toBuildingDetail"]) 
    {
        CMBuildingDetailViewController *bdvc = (CMBuildingDetailViewController *)segue.destinationViewController;
        bdvc.building = _lastSelectedButton.building;
    }
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    /* set the proper minZoomScale so that offmap regions are not displayed */
    self.scrollView.minimumZoomScale = fmaxf(self.view.bounds.size.height/(self.scrollView.contentSize.height/self.scrollView.zoomScale), self.view.bounds.size.width/(self.scrollView.contentSize.width/self.scrollView.zoomScale));
    
    self.scrollView.zoomScale = fmaxf(self.scrollView.zoomScale, self.scrollView.minimumZoomScale); 
    
    [_locationManager startUpdatingLocation];    
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    
    /* stop updating location when view disappears, to conserve resources */
    [_locationManager stopUpdatingLocation];
}

- (void)viewDidLoad
{
    [super viewDidLoad];    
    
    /* get all loaded buildings from the data manager */
    NSArray *allBuildings = [[CMDataManager defaultManager] buildings];
    
    /* drop a pin at each building's location */
    for (Building *building in allBuildings)
    {
        [self dropPinAtBuilding:building];
    }

    self.scrollView.contentSize = MAP_SIZE;
    self.map.frame = CGRectMake(0.0f, 0.0f, self.scrollView.contentSize.width, self.scrollView.contentSize.height);
    
    /* this happens to be what prefaces the row and col in the file names. Should probably be something more descriptive */
    self.map.tileNameBase = @"5";
    
    self.scrollView.decelerationRate = 0.8f;
    self.scrollView.maximumZoomScale = 1.25f;
    
    [self.scrollView addSubview:self.map];
    
    [self.view addSubview:self.searchBar];
    
    /* this path will round off the top right corner of the info the view (makes it look nicer) */
    UIBezierPath *roundedPath = [UIBezierPath bezierPathWithRoundedRect:_infoView.bounds byRoundingCorners:UIRectCornerTopRight | UIRectCornerBottomRight cornerRadii:CGSizeMake(10.0f, 10.0f)];
    
    /* mask the view according to the above path. This rounds the bottom corners of the view */
    CAShapeLayer *maskLayer = [CAShapeLayer layer];
    maskLayer.frame =_infoView.bounds;
    maskLayer.fillColor = _infoView.backgroundColor.CGColor;
    maskLayer.backgroundColor = [UIColor clearColor].CGColor;
    maskLayer.path = roundedPath.CGPath;
    
    _infoView.layer.mask = maskLayer;
        
    /* if there is meaningful info about user's location, zoom to the user's location. Otherwise, zoom to Mass Hall */
    if ([CLLocationManager locationServicesEnabled] && CLLocationManager.authorizationStatus == kCLAuthorizationStatusAuthorized && MODE == BuildModeDevice)
    {
        [_locationManager startUpdatingLocation];
        CGPoint userLoc = [self mapPointFromLatitude:_locationManager.location.coordinate.latitude longitude:_locationManager.location.coordinate.longitude];
        
        CGRect zoomRect = CGRectMake(fmaxf(0.0f, userLoc.x - self.view.frame.size.width/(2*self.scrollView.zoomScale)), fmaxf(0.0f, userLoc.y - self.view.frame.size.height/(2*self.scrollView.zoomScale)), self.view.frame.size.width/self.scrollView.zoomScale, self.view.frame.size.height/self.scrollView.zoomScale);
        [self.scrollView zoomToRect:zoomRect animated:NO];
    }
    else
    {
        /* starting view is at mass hall */
        Building *massHall = [[CMDataManager defaultManager] buildingNamed:@"Massachusetts Hall"];
        
        if (massHall)
        {
            [self zoomToBuilding:massHall];
        }
    }
    
    /* we would like to be notified of when the app moves to the background and when it moves to the foreground, mostly to manage the location manager */
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(viewWillAppear:) name:UIApplicationWillEnterForegroundNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(viewDidDisappear:) name:UIApplicationDidEnterBackgroundNotification object:nil];
}

- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation
{
    /* set the proper minZoomScale so that offmap regions are not displayed */
    self.scrollView.minimumZoomScale = fmaxf(self.view.bounds.size.height/(self.scrollView.contentSize.height/self.scrollView.zoomScale), self.view.bounds.size.width/(self.scrollView.contentSize.width/self.scrollView.zoomScale));
    
    self.scrollView.zoomScale = fmaxf(self.scrollView.zoomScale, self.scrollView.minimumZoomScale);
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

@end
