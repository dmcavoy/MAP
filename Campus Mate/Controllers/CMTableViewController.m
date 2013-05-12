//
//  CMTableViewController.m
//  Campus Mate
//
//  Created by Rob Visentin on 6/5/12.
//  Copyright (c) 2012 Bowdoin College. All rights reserved.
//

#import "CMTableViewController.h"
#import "CMDataManager.h"
#import "Building.h"
#import "CMBuildingDetailViewController.h"

/* private interface */
@interface CMTableViewController()
{
@private
    NSMutableDictionary *_buildingNamesBySection;       // building names stored using their table view sections as keys
    NSArray *_sections;                                 // sections in the table view
    NSDictionary *_searchResultsBuildingNamesBySection; // buildings in the search results table view using their sections as keys
    NSArray *_searchResultsSections;                    // sections in the search results table view
    NSString *_selectedRowTitle;                        // name of the selected building
}
- (void)initialize; // do start up initialization like creating the sections

@end

@implementation CMTableViewController

- (id)init
{
    self = [super init];
    
    if (self) 
    {
        [self initialize];
    }
    return self;
}

/* called when initializing from  storyboard. currently duplicates init */
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
    /* each section is the group of buildings whose name begins with that letter of the alphabet */
    NSString *alphabet = @"#ABCDEFGHIJKLMNOPQRSTUVWXYZ";
    _buildingNamesBySection = [NSMutableDictionary dictionaryWithCapacity:[alphabet length]];
    
    /* each section becomes a key in the dictionary, and corresponding value will be the names of all buildings in that section */
    for (int i = 0; i < [alphabet length]; i++)
    {
        [_buildingNamesBySection setObject:[NSMutableArray array] forKey:[alphabet substringWithRange:NSMakeRange(i, 1)]];
    }
    
    NSArray *allBuildings = [[CMDataManager defaultManager] buildings];
    
    /* put each building name in the appropriate section in the dictionary */
    for (Building *building in allBuildings)
    {
        NSString *nameLetter = [building.name substringToIndex:1];
        if ([nameLetter intValue]) {
            [[_buildingNamesBySection objectForKey:@"#"] addObject:building.name];
        }
        else {
            [[_buildingNamesBySection objectForKey:[nameLetter uppercaseString]] addObject:building.name];
        }
    }
    
    _sections = [[_buildingNamesBySection allKeys] sortedArrayUsingSelector:@selector(compare:)];
}
#pragma mark - UISearchBarDelegate methods

/* when text changes in the search bar, we want to update the shown search results immediately (like google) */
- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    NSArray *allBuildings = [[CMDataManager defaultManager] buildings];
    NSMutableDictionary *mutableResults = [NSMutableDictionary dictionary];
    /* search all text fields in each building for the search text */
    for (Building *building in allBuildings) 
    {
        NSRange nameRange = [[building.name lowercaseString] rangeOfString:[searchText lowercaseString]];
        NSRange functionRange = [[building.function lowercaseString] rangeOfString:[searchText lowercaseString]];
        NSRange descriptionRange = [[building.description lowercaseString] rangeOfString:[searchText lowercaseString]];
        NSRange departmentsRange = [[building.departments lowercaseString] rangeOfString:[searchText lowercaseString]];
        
        if (nameRange.location != NSNotFound || descriptionRange.location != NSNotFound || departmentsRange.location != NSNotFound || functionRange.location != NSNotFound)
        {
            NSString *nameLetter = [building.name substringToIndex:1];
            if ([nameLetter intValue]) 
                nameLetter = @"#";
            
            if (![mutableResults objectForKey:nameLetter]) 
            {
                [mutableResults setObject:[NSMutableArray array] forKey:nameLetter];
            }
            [[mutableResults objectForKey:nameLetter] addObject:building.name];

        }
    }
        /* set search results information */
    _searchResultsBuildingNamesBySection = [mutableResults copy];
    _searchResultsSections = [[mutableResults allKeys] sortedArrayUsingSelector:@selector(compare:)];
}

#pragma mark UITableViewDataSource methods

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    NSString *title;
    
    if (tableView == self.tableView) 
    {
        title = [_sections objectAtIndex:section];
    }
    else if (tableView == self.searchDisplayController.searchResultsTableView)
    {
        title =  [_searchResultsSections objectAtIndex:section];
    }
    
    return title;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    NSInteger count = 1;
    
    if (tableView == self.tableView) 
    {
        count = _sections.count;
    }
    else if (tableView == self.searchDisplayController.searchResultsTableView)
    {
        count =  _searchResultsSections.count;
    }
    
    return count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSArray *buildingsInSection;
    
    if ([tableView isEqual:self.tableView])
    {
        buildingsInSection = [_buildingNamesBySection objectForKey:[_sections objectAtIndex:section]];
    }
    else if ([tableView isEqual:self.searchDisplayController.searchResultsTableView])
    {
        buildingsInSection = [_searchResultsBuildingNamesBySection objectForKey:[_searchResultsSections objectAtIndex:section]];
    }
    
    return [buildingsInSection count];
}

- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView
{
    return _sections;
}

#define CELL_LABEL_TAG 1
#define IMAGE_VIEW_TAG 2
#define ZOOMTO_BUTTON_ICON @"find_icon.png"

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UILabel *cellLabel;
    UIImageView *imageView;
    UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) 
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        
        /* this label will take the place of the default cell textLabel because we need to init it with a specific frame */
        cellLabel = [[UILabel alloc] initWithFrame:CGRectMake(tableView.rowHeight, 0, self.view.bounds.size.width - 2*tableView.rowHeight, tableView.rowHeight)];
        cellLabel.tag = CELL_LABEL_TAG;
        
        /* a small thumbnail on the cell. Contains the building's image */
        imageView = [[UIImageView alloc] initWithFrame:CGRectMake(tableView.rowHeight/8, tableView.rowHeight/8, 3*tableView.rowHeight/4, 3*tableView.rowHeight/4)];
        imageView.tag = IMAGE_VIEW_TAG;
                
        [cell.contentView addSubview:cellLabel];
        [cell.contentView addSubview:imageView];
    }
    
    return cell;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIImageView *headerView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, [tableView.delegate tableView:tableView heightForHeaderInSection:section])];
    
    /* this will be the background image for the table view headers. Currently this is set to use the same image as the navigation bar */
    UIImage *backgroundImage = [UIImage imageNamed:@"navbar-44"];
        
    headerView.image = [backgroundImage stretchableImageWithLeftCapWidth:backgroundImage.size.width/2 topCapHeight:backgroundImage.size.height/2];
    
    /* the label to hold the header's name */
    UILabel *sectionName = [[UILabel alloc] initWithFrame:CGRectMake(10.0f, 0, tableView.frame.size.width - 10.0f, 20.0f)];
    sectionName.backgroundColor = [UIColor clearColor];
    sectionName.font = [UIFont fontWithName:FONT_NAME_BOLD size:15.0f];
    sectionName.textColor = [UIColor whiteColor];
    sectionName.text = [tableView.dataSource tableView:tableView titleForHeaderInSection:section];
    [headerView addSubview:sectionName];
    
    return headerView;
}

#pragma mark UITableViewDelegate methods

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath  
{
    UILabel *cellLabel = (UILabel *)[cell.contentView viewWithTag:CELL_LABEL_TAG];
    UIImageView *imageView = (UIImageView *)[cell.contentView viewWithTag:IMAGE_VIEW_TAG];
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad){
        [cellLabel setFont:[UIFont fontWithName:FONT_NAME_STANDARD size:18.0f]];
    }else{
        [cellLabel setFont:[UIFont fontWithName:FONT_NAME_STANDARD size:16.0f]];
    }
    
    /* which section of buildings we are looking in */
    NSString *cellSection = [tableView.dataSource tableView:tableView titleForHeaderInSection:indexPath.section];
    
    /* retrieve information for the building whose information we want to display */
    Building *cellBuilding;
    if ([tableView isEqual:self.tableView])
    {
        cellBuilding = [[CMDataManager defaultManager] buildingNamed:[[_buildingNamesBySection objectForKey:cellSection] objectAtIndex:indexPath.row]];
    }
    else if ([tableView isEqual:self.searchDisplayController.searchResultsTableView])
    {
        cellBuilding = [[CMDataManager defaultManager] buildingNamed:[[_searchResultsBuildingNamesBySection objectForKey:cellSection] objectAtIndex:indexPath.row]];
    }
    
    /* set the cell's label and thumbnail image */
    cellLabel.text = cellBuilding.name;
    imageView.image = cellBuilding.graphic;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    /* get the name of the building */
    UILabel *rowTitleLabel = (UILabel *)[[tableView cellForRowAtIndexPath:indexPath] viewWithTag:CELL_LABEL_TAG];
    _selectedRowTitle = rowTitleLabel.text;
    
    /* transition to the building details controller to show more details about the selected building */
    [self performSegueWithIdentifier:@"toBuildingDetail" sender:self];
}

#pragma mark - View lifecycle

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"toBuildingDetail"]) 
    {        
        Building *building = [[CMDataManager defaultManager] buildingNamed:_selectedRowTitle];
        CMBuildingDetailViewController *bdvc = (CMBuildingDetailViewController *)segue.destinationViewController;
        bdvc.building = building;
    }
}

/* all orientations supported for iOS 6.0 or later */
-(NSUInteger)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskAll;
}

/* all orientations supported for iOS 5.0 or earlier */
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return YES;
}

@end
