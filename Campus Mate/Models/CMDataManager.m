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
-(Professor *)professorNamed:(NSString *)name
{
    NSArray *allProfs = [[CMDataManager defaultManager] professorSort];
    for(Professor *professor in allProfs)
    {
        if([professor.name isEqualToString:name])
        {
            return professor;
        }
    }
    return nil;
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

-(void)addProfData
{
    NSArray *builds = [_buildingsByName allKeys];
    BOOL didCleaveland = false;
    BOOL needToSave;
    NSMutableArray *previous = [NSMutableArray array];
    
    //only way to get professors in cleaveland to load
    NSString *cleaveland = [self loadCleaveland];
    needToSave = [self loadProfessorsInBuilding:cleaveland];
    didCleaveland = true;
    [previous addObject:cleaveland];
    
    if(needToSave)
    {
        for (NSString *bNames in builds)
        {
            NSString *buildName;
            buildName = [self modifyBuildingNameForURL:bNames];
            if(![buildName isEqualToString:bNames])
            {
                BOOL continueExec = true;
                if([previous count] != 0)
                {
                    for(int i = 0; i < [previous count]; i++)
                    {
                        if([buildName isEqualToString:[previous objectAtIndex:i]])
                        {
                            continueExec = false;
                            [previous addObject:buildName];
                        }
                        
                    }
                    if(continueExec)
                    {
                        needToSave = [self loadProfessorsInBuilding:buildName];
                        [previous addObject:buildName];
                    }
                }
            }
        }
        [self saveProfessors];
    }
}

-(BOOL)loadProfessorsInBuilding:(NSString *)pBuilding
{
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES);
    NSString *pListPath = [[paths objectAtIndex:0] stringByAppendingPathComponent:[NSString stringWithFormat:@"Caches/%@.plist", PROF_PLIST]];
    NSDictionary *pListContents = [NSDictionary dictionaryWithContentsOfFile:pListPath];
    
    if(pListContents)
    {
        for(NSString *professorName in [pListContents allKeys])
        {
            NSDictionary *profInfo = [pListContents objectForKey:professorName];
            
            Professor *professor = [[Professor alloc] init];
            professor.name = professorName;
            professor.department = [profInfo objectForKey:@"department"];
            professor.address = [profInfo objectForKey:@"address"];
            professor.email = [profInfo objectForKey:@"email"];
            professor.buildingName = [self modifyBuildingNameForURL:professor.address];
            
            [_professorsByBuilding addObject:professor];
        }
        return false;
    }
    
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
            professor.buildingName = pBuilding;
            
            [_professorsByBuilding addObject:professor];
        }
        
        [[NSUserDefaults standardUserDefaults] setObject:[NSDate date] forKey:@"last sync"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
    }
    
    _professorsByBuilding = [NSMutableArray arrayWithArray:[self professorSort]];
    return true;
    
}

-(void)saveProfessors
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSLibraryDirectory,NSUserDomainMask, YES);
    NSString *pListPath = [[paths objectAtIndex:0] stringByAppendingPathComponent:[NSString stringWithFormat:@"Caches/%@.plist", PROF_PLIST]];
    
    NSMutableArray *keys = [NSMutableArray array];
    NSMutableDictionary *output = [NSMutableDictionary dictionaryWithCapacity:[_professorsByBuilding count]];
    for(int i = 0; i < [_professorsByBuilding count]; i++)
    {
        Professor *professor = [[Professor alloc] init];
        professor = [_professorsByBuilding objectAtIndex:i];
        [keys addObject:professor.name];
    }
    for(NSString *professorName in keys)
    {
        
        Professor *professor = [[CMDataManager defaultManager] professorNamed:professorName];
        NSMutableDictionary *profDictionary = [NSMutableDictionary dictionary];
        
        [profDictionary setObject:professor.name forKey:@"name"];
        if(professor.department)
        {
            [profDictionary setObject:professor.department forKey:@"department"];
        }
        if(professor.address)
        {
            [profDictionary setObject:professor.address forKey:@"address"];
        }
        if(professor.email)
        {
            [profDictionary setObject:professor.email forKey:@"email"];
        }
        if(![output objectForKey:professorName])
        {
            [output setObject:profDictionary forKey:professorName];
        }
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
/* loads buildings first from a property list, then from the database. See .h for more detail */
- (void)loadBuildings
{
    /* retrives plist contents as a dictionary */
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSLibraryDirectory,NSUserDomainMask, YES);
    NSString *pListPath = [[paths objectAtIndex:0] stringByAppendingPathComponent:[NSString stringWithFormat:@"Caches/%@.plist", BUILDINGS_PLIST]];
    NSDictionary *pListContents = [NSDictionary dictionaryWithContentsOfFile:pListPath];
    
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

