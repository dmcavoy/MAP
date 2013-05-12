//
//  CMDataManager.m
//  Campus Mate
//
//  Created by Rob Visentin on 6/5/12.
//  Copyright (c) 2012 Bowdoin College. All rights reserved.
//

#import "CMDataManager.h"
#import "CMReferencePoint.h"
#import "Building.h"

/* private interface */
@interface CMDataManager()
{
@private
    NSMutableDictionary *_buildingsByName; // dictionary storing all loaded buildings, using their names as keys  
    NSMutableDictionary *_referencePoints; // dictionary storying loaded reference points
    NSMutableArray *_professorsByBuilding;
}
@end

@implementation CMDataManager

@synthesize buildings;
@synthesize referencePoints;

- (id)init
{
    self = [super init];
    
    if (self) 
    {
        _buildingsByName = [NSMutableDictionary dictionary];
        _professorsByBuilding = [[NSMutableArray alloc] init];
        _referencePoints = [NSMutableDictionary dictionary];
    }
    return self;
}

/* returns an array of buildings that is alphabetically sorted by name */
- (NSArray *)buildings
{
    return [_buildingsByName objectsForKeys:[[_buildingsByName allKeys] sortedArrayUsingSelector:@selector(compare:)] notFoundMarker:[[Building alloc] init]];
}

- (NSArray *)referencePoints
{
    return [_referencePoints objectsForKeys:[_referencePoints allKeys] notFoundMarker:[NSNull null]];
}

-(NSArray *)professorSort
{
    [_professorsByBuilding sortUsingDescriptors:[NSArray arrayWithObject:[NSSortDescriptor sortDescriptorWithKey:@"buildingName" ascending:YES]]];
    return _professorsByBuilding;
}
/* return the building with given name */
- (Building *)buildingNamed:(NSString *)buildingName
{
    return [_buildingsByName objectForKey:buildingName];
}
-(NSString *)professorNamed:(Professor *)professor
{
    return professor.name;
}
-(NSString *)professorsBuilding:(Professor *)professor
{
    NSString *office = professor.buildingName;
    return office;
}

static CMDataManager *defaultManager = nil;

/* returns the static default manager */
+ (CMDataManager *)defaultManager
{
    @synchronized([CMDataManager class])
    {
        if (!defaultManager) 
        {
            defaultManager = [[self alloc] init];
        }
        return defaultManager;
    }
    return nil;
}
//some building titles need to be modified so they can be found on the server
-(NSString *)modifyBuildingNameForURL:(NSString *)building
{
    if([building rangeOfString:@"Adams"].location != NSNotFound)
    {
        building = @"Adams";
        return building;
    }
    else if([building rangeOfString:@"Druckenmiller"].location != NSNotFound)
    {
        building = @"Druckenmiller";
        return building;
    }
    else if([building rangeOfString:@"Cleaveland Hall"].location != NSNotFound)
    {
        building = @"Cleaveland";
        return building;
    }
    else if([building rangeOfString:@"Boody-Johnson"].location != NSNotFound)
    {
        building = @"Boody-Johnson";
        return building;
    }
    else if([building rangeOfString:@"Hatch"].location != NSNotFound)
    {
        building = @"Hatch";
        return building;
    }
    else if([building rangeOfString:@"Visual"].location != NSNotFound)
    {
        building = @"Visual";
        return building;
    }
    else if([building rangeOfString:@"Station"].location != NSNotFound)
    {
        building = @"Station";
        return building;
    }
    else if([building rangeOfString:@"Dudley"].location != NSNotFound)
    {
        building = @"Dudley";
        return building;
    }
    else if([building rangeOfString:@"Kanbar Hall"].location != NSNotFound)
    {
        building = @"Kanbar";
        return building;
    }
    else if([building rangeOfString:@"Sills"].location != NSNotFound)
    {
        building = @"Sills";
        return building;
    }
    else if([building rangeOfString:@"Searles"].location != NSNotFound)
    {
        building = @"Searles";
        return building;
    }
    else if([building rangeOfString:@"Riley"].location != NSNotFound)
    {
        building = @"Riley";
        return building;
    }
    else if([building rangeOfString:@"Pols"].location != NSNotFound)
    {
        building = @"Pols";
        return building;
    }
    else if([building rangeOfString:@"Hubbard"].location != NSNotFound)
    {
        building = @"Hubbard";
        return building;
    }
    else if([building rangeOfString:@"Ashby"].location != NSNotFound)
    {
        building = @"Ashby";
        return building;
    }
    //Addresses for 24, 32 and 38 College st loaded here, since all data for these addresses was grouped together 
    else if([building rangeOfString:@"30 College"].location != NSNotFound)
    {
        building = @"College";
        return building;
    }
    else if([building rangeOfString:@"Memorial"].location != NSNotFound)
    {
        building = @"Memorial";
        return building;
    }
    else if([building rangeOfString:@"Massachusetts"].location != NSNotFound)
    {
        building = @"Massachusetts";
        return building;
    }
    else if([building rangeOfString:@"Gibson"].location != NSNotFound)
    {
        building = @"Gibson";
        return building;
    }
    else if([building rangeOfString:@"Federal"].location != NSNotFound)
    {
        building = @"Federal";
        return building;
    }
    else
    {
        return building;
    }
    
}
//because of how app and server are set up, offices in Cleaveland must be loaded in this way
-(NSString *)loadCleaveland
{
    return @"Cleaveland";
}

-(void)loadProfessorsInBuilding:(NSString *)pBuilding
{
    NSDate *lastSync = [[NSUserDefaults standardUserDefaults] objectForKey:@"last sync"];
    
    /* format date to MySQL format */
    NSDateFormatter* dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSString *lastSyncString = [dateFormatter stringFromDate:lastSync];

    
    NSURL *profURL = [NSURL URLWithString:[NSString stringWithFormat:@"http://mobileapps.bowdoin.edu/campusmate/get_building_profs.php?building=%@", pBuilding]];
    NSString *profPost = [NSString stringWithFormat:@"lastSync=%@", lastSyncString];
    NSData *profData = [profPost dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:NO];
    NSString *profPostLength = [NSString stringWithFormat:@"%d", [profData length]];
    
    NSMutableURLRequest *profRequest = [[NSMutableURLRequest alloc] init];
    profRequest.URL = profURL;
    profRequest.HTTPMethod = @"POST";
    profRequest.HTTPBody = profData;
    profRequest.timeoutInterval = CONNECTION_TIMEOUT;
    [profRequest setValue:profPostLength forHTTPHeaderField:@"Content-Length"];
    [profRequest setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    
    NSError *profError;
    NSData *returnProfData = [NSURLConnection sendSynchronousRequest:profRequest returningResponse:nil error:&profError];
    if(profError)
    {
        NSLog(@"failed to connect to server with error: %@", profError.localizedDescription);
    }
    NSMutableArray *JSData = !profError ? [NSJSONSerialization JSONObjectWithData:returnProfData options:NSJSONReadingMutableContainers error:nil] : nil;
    
    if(JSData.count)
    {
        for(NSArray *profInfo in JSData)
        {
            NSDictionary *information = [[NSDictionary alloc] initWithObjectsAndKeys:pBuilding, @"buildingName", profInfo[0], @"name", profInfo[1], @"address", profInfo[2], @"department", profInfo[3], @"email", nil];
            
            Professor *professor = [[Professor alloc] init];
           
            professor.buildingName = [information objectForKey:@"buildingName"];
            professor.name = [information objectForKey:@"name"];
            professor.address = [information objectForKey:@"address"];
            professor.department = [information objectForKey:@"department"];
            professor.email = [information objectForKey:@"email"];
            
            [_professorsByBuilding addObject:professor];
            
        }
        
        [[NSUserDefaults standardUserDefaults] setObject:[NSDate date] forKey:@"last sync"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    
    }
    NSLog(@"loaded %d professors for building: %@", [_professorsByBuilding count], pBuilding);
    
    _professorsByBuilding = [self professorSort];
}
/* loads buildings first from a property list, then from the database. See .h for more detail */
- (void)loadBuildings
{
    /* retrives plist contents as a dictionary */
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSLibraryDirectory,NSUserDomainMask, YES);
    NSString *pListPath = [[paths objectAtIndex:0] stringByAppendingPathComponent:[NSString stringWithFormat:@"Caches/%@.plist", BUILDINGS_PLIST]];
    NSDictionary *pListContents = [NSDictionary dictionaryWithContentsOfFile:pListPath];
    
    //will load Cleaveland Hall once
    NSString *cleav = [self loadCleaveland];
    [self loadProfessorsInBuilding:cleav];
    
    if (pListContents)
    {
        /* propety list contained building informaiton, so create and stores a new building for each building in the plist */
        for (NSString *buildingName in [pListContents allKeys]) 
        {
            NSDictionary *buildingInfo = [pListContents objectForKey:buildingName];
            
            /* note: building graphics are stored locally. Images are associated with buildings based on their unique ID */
            Building *building = [[Building alloc] initWithID:[[buildingInfo objectForKey:@"id"] intValue]];
            building.name = buildingName;
            building.function = [buildingInfo objectForKey:@"function"] ? [buildingInfo objectForKey:@"function"] : @"";
            building.description = [buildingInfo objectForKey:@"description"];
            building.departments = [buildingInfo objectForKey:@"departments"];
            building.address = [buildingInfo objectForKey:@"address"];
            building.hours = [buildingInfo objectForKey:@"hours"];
            
            building.latitude = [[buildingInfo objectForKey:@"latitude"] doubleValue];
            building.longitude = [[buildingInfo objectForKey:@"longitude"] doubleValue];
            
            [_buildingsByName setObject:building forKey:buildingName];
            
            NSString *test = [self modifyBuildingNameForURL:buildingName];
            if(![test isEqualToString:buildingName])
            {
                [self loadProfessorsInBuilding:test];
            }
        }
    }
    
    NSDate *lastSync = [[NSUserDefaults standardUserDefaults] objectForKey:@"last sync"];
    
    /* need a full sync if either the app has never been syncd, and/or the plist did not exist */
    if (!lastSync || !pListContents) 
    {
        lastSync = [NSDate dateWithTimeIntervalSince1970:0];
    }
    
    /* format date to MySQL format */
    NSDateFormatter* dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSString *lastSyncString = [dateFormatter stringFromDate:lastSync];
        
    /* create the POST HTTP request */
    NSURL *baseURL = [NSURL URLWithString:[NSString stringWithFormat:@"https://%@/get_building_updates.php", HOST]];
    NSString *post = [NSString stringWithFormat:@"lastSync=%@", lastSyncString];
    NSData *postData = [post dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:NO];
    NSString *postLength = [NSString stringWithFormat:@"%d", [postData length]];
    
    /* need to link to professor server too*/
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    request.URL = baseURL;
    request.HTTPMethod = @"POST";
    request.HTTPBody = postData;
    request.timeoutInterval = CONNECTION_TIMEOUT;
    [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    
    /* perform a synchronous load because, since this method needs only be called when the app starts up, we actually WANT the main thread to block until the load is completed (otherwise the user would see an empty map)*/
    NSError *error;
    NSData *returnData = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:&error];
            
    if (error) 
    {
        NSLog(@"failed to connect to server with error: %@", error.localizedDescription);
    }
    
    NSMutableArray *JSONData = !error ? [NSJSONSerialization JSONObjectWithData:returnData options:NSJSONReadingMutableContainers error:nil] : nil;
        
    if (JSONData.count)
    {
        /* server returned data, so update or create buildings accordingly */
        for (NSDictionary *buildingInfo in JSONData)
        {
            NSString *buildingName = [buildingInfo objectForKey:@"name"];
            Building *building = [_buildingsByName objectForKey:buildingName];
            if (!building) 
            {
                /* note: building graphics are stored locally. Images are associated with buildings based on their unique ID */
                building = [[Building alloc] initWithID:[[buildingInfo objectForKey:@"id"] intValue]];
                
                [_buildingsByName setObject:building forKey:buildingName];
            }
        
            building.name = [buildingInfo objectForKey:@"name"];
            building.address = [buildingInfo objectForKey:@"address"];
            building.function = [buildingInfo objectForKey:@"function"];
            building.description = [buildingInfo objectForKey:@"description"];
            building.departments = [buildingInfo objectForKey:@"resources"];
            building.hours = [buildingInfo objectForKey:@"hours"];
            building.latitude = [[buildingInfo objectForKey:@"latitude"] doubleValue];
            building.longitude = [[buildingInfo objectForKey:@"longitude"] doubleValue];
            
            [self loadProfessorsInBuilding:buildingName];

        }
        
        /* save a local copy of all building information */
        [self saveBuildings];
        
        /* update last sync time to current timestamp */
        [[NSUserDefaults standardUserDefaults] setObject:[NSDate date] forKey:@"last sync"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
    
    NSLog(@"loaded %d buildings",[_buildingsByName allKeys].count);
}

/* loads reference points from plist specified in CMCommon.h into an array */
- (void)loadReferencePoints
{
    /* retrives plist contents as a dictionary */
    NSString *pListPath = [[NSBundle mainBundle] pathForResource:REFERENCE_POINTS_PLIST ofType:@"plist"];
    NSDictionary *pListContents = [NSDictionary dictionaryWithContentsOfFile:pListPath];
    
    /* create a new reference point object for each one stored in the plist */
    for (NSString *referencePointName in [pListContents allKeys]) 
    {
        NSDictionary *referencePointInfo = [pListContents objectForKey:referencePointName];
                
        double x = [[referencePointInfo objectForKey:@"x"] doubleValue];
        double y = [[referencePointInfo objectForKey:@"y"] doubleValue];
        double lat = [[referencePointInfo objectForKey:@"lat"] doubleValue];
        double lon = [[referencePointInfo objectForKey:@"lng"] doubleValue];
        
        CMReferencePoint *ref = [[CMReferencePoint alloc] initWithx:x y:y lat:lat lon:lon];
        
        [_referencePoints setObject:ref forKey:referencePointName];
    }
        
    NSLog(@"loaded %d reference points", [_referencePoints count]);
}

/* save the list of loaded buildings to a plist. currently overwrites the plist in the main bundle (has no real point on simulator) */
- (void)saveBuildings
{
    /* file path of the plist that buildings were loaded from */
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSLibraryDirectory,NSUserDomainMask, YES);
    NSString *pListPath = [[paths objectAtIndex:0] stringByAppendingPathComponent:[NSString stringWithFormat:@"Caches/%@.plist", BUILDINGS_PLIST]];
    
    NSArray *keys = [_buildingsByName allKeys];
    NSMutableDictionary *output = [NSMutableDictionary dictionaryWithCapacity:[keys count]];
    
    /* create a new building in the plist for each building in the loaded dictionary of buildings */
    for (NSString *buildingName in keys) 
    {        
        Building *building = [_buildingsByName objectForKey:buildingName];
        NSMutableDictionary *buildingDictionary = [NSMutableDictionary dictionary];
        [buildingDictionary setObject:[NSNumber numberWithInt:building.buildingID] forKey:@"id"];
        [buildingDictionary setObject:building.description forKey:@"description"];
        [buildingDictionary setObject:building.function forKey:@"function"];
        [buildingDictionary setObject:building.departments forKey:@"departments"];
        [buildingDictionary setObject:building.address forKey:@"address"];
        [buildingDictionary setObject:building.hours forKey:@"hours"];
        [buildingDictionary setObject:[NSNumber numberWithDouble:building.latitude] forKey:@"latitude"];
        [buildingDictionary setObject:[NSNumber numberWithDouble:building.longitude] forKey:@"longitude"];
        
        [output setObject:buildingDictionary forKey:buildingName];
    }
    
    NSString *serializeError = nil;
    NSError *writeError = nil;
    
    /* convert dictionary to XML format */
    id pList = [NSPropertyListSerialization dataFromPropertyList:(id)output format:NSPropertyListXMLFormat_v1_0 errorDescription:&serializeError];
    if (serializeError) 
    {
        NSLog(@"failed to serialize buildings plist with error: %@", serializeError);
        return;
    }
    
    /* write the plist */
    if (![pList writeToFile:pListPath options:NSDataWritingAtomic error:&writeError])
    {
        NSLog(@"failed to write buildings plist with error: %@", [writeError localizedDescription]);
    }
    else
    {
        NSLog(@"wrote buildings plist at path %@", pListPath);
    }
}

@end
