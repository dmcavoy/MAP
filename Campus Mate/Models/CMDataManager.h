//
//  CMDataManager.h
//  Campus Mate
//
//  Created by Rob Visentin on 6/5/12.
//  Copyright (c) 2012 Bowdoin College. All rights reserved.
//

// manages the data used in Campus Mate, namely the list of buildings.A static default manager can be used to access data universally

#import <Foundation/Foundation.h>

@class Building;

@interface CMDataManager : NSObject

@property (copy, nonatomic, readonly) NSArray *buildings;       // the buildings stored in the data manager
@property (copy, nonatomic, readonly) NSArray *referencePoints; // the reference points stored in the data manager

+ (CMDataManager *)defaultManager;  // returns the static default manager

#pragma mark - loading data                         

// loads GPS reference points (calibrated using Andrew Currier's mapTool) from the property list specified in CMCommon.h and into an array
// Each reference point has a GPS lat/lon that is mapped to an x/y coordinate on the campus map image.
// If this image changes, the reference points will need to be re-calibrated.
// These reference points are used primarily to estimate the user's position on the map, but also to drop the pin at each building
- (void)loadReferencePoints;

// loads information about each building into an array in a two step process:
//
// 1) The data manager attempts to load building information from the property list specified in CMCommon.h. 
//      If this property list does not exist, it moves on to step 2

// 2) The data manager attempts to load building information from the MySQL database on bowdoin servers. It first checks the timestamp 
//      (stored in NSUserDefaults) of the last time the app was syncd with the database. If either the app has never been syncd or if 
//      step 1 found that the property list didn't exist, the data manager uses [NSDate distantPast] as the last sync time.
//      This timestamp is then passed to a php script on bowdoin servers using an HTTP POST message. The script returns all buildings that
//      have been updated since the given timestamp in JSON format. If the script returns data, the data manager then parses it to create new
//      or update existing buildings. It then calls saveBuildings and saves the current timestamp as the last sync time in NSUserDefaults.
//      If the script returned no data, saveBuildings is not called, but the last sync time is still updated.
- (void)loadBuildings;

#pragma mark - saving data

// saves the information currently loaded about all buildings to a property list specified in CMCommon.h. Note: this is the same property list
// used by loadBuildings, so if it exists already it will be overwritten. This property list is stored so that even if the user loses internet
// connectivity, or attempts to run the app with none at all, the app will still remember the data retrieved from the last database sync
- (void)saveBuildings;


#pragma mark - accessing data

// returns the building object containing information about the building with given name
- (Building *)buildingNamed:(NSString *)buildingName;

@end
