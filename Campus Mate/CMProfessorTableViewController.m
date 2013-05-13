//
//  CMProfessorTableViewController.m
//  Bowdoin Map
//
//  Created by Maddie Baird on 2013-05-10.
//
//

#import "CMProfessorTableViewController.h"
#import "Professor.h"
#import "CMDataManager.h"
#import "CMProfessorDetailVC.h"

@interface CMProfessorTableViewController ()
{
    NSMutableDictionary *_professorNamesBySection;  //professor names stored using table view sections as keys
    NSArray *_sections;                              //sections in table view
    NSString *_selectedRowTitle;                    //name of selected professor
    NSDictionary *_searchResultsProfessorNamesBySection; //profs in search results table view
    NSArray *_searchResultsSections; //sections in the search results table view
}

@end


@implementation CMProfessorTableViewController

@synthesize professors;
- (id)init
{
    self = [super init];
    if (self) {
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
-(void)initialize
{
    /* each section is the group of buildings whose name begins with that letter of the alphabet */
    NSString *alphabet = @"ABCDEFGHIJKLMNOPQRSTUVWXYZ";
    
    _professorNamesBySection = [NSMutableDictionary dictionaryWithCapacity:[alphabet length]];
    
    for(int i = 0; i < [alphabet length]; i++)
    {
        [_professorNamesBySection setObject:[NSMutableArray array] forKey:[alphabet substringWithRange:NSMakeRange(i, 1)]];
    }
    
    NSArray *allProfessors = [[CMDataManager defaultManager] professorSort];
    /* each section becomes a key in the dictionary and the corresponding value will be the last names of the professors in that section */
    for(Professor *professor in allProfessors)
    {
        NSString *lastName = professor.name;
        NSRange whiteSpaceRange = [lastName rangeOfCharacterFromSet:[NSCharacterSet whitespaceCharacterSet]];
        
        while(whiteSpaceRange.location != NSNotFound)
        {
            
            lastName = [lastName substringFromIndex:whiteSpaceRange.location +1];
            whiteSpaceRange = [lastName rangeOfCharacterFromSet:[NSCharacterSet whitespaceCharacterSet]];
        
        }
        NSString *nameLetter = [lastName substringToIndex:1];
        [[_professorNamesBySection objectForKey:[nameLetter uppercaseString]] addObject:professor];
    }
    
    
    _sections = [[_professorNamesBySection allKeys] sortedArrayUsingSelector:@selector(compare:)];
}

-(void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    NSArray *allProfs = [[CMDataManager defaultManager] professorSort];
    NSMutableDictionary *mutableResults = [NSMutableDictionary dictionary];
    
    for(Professor *professor in allProfs)
    {
        NSRange nameRange = [[professor.name lowercaseString] rangeOfString:[searchText lowercaseString]];
        NSRange departmentRange = [[professor.department lowercaseString] rangeOfString:[searchText lowercaseString]];
        
        if(nameRange.location != NSNotFound || departmentRange.location != NSNotFound)
        {
            NSString *nameLetter = [professor.name substringToIndex:1];
            if ([nameLetter intValue])
                nameLetter = @"#";
            
            if (![mutableResults objectForKey:nameLetter])
            {
                [mutableResults setObject:[NSMutableArray array] forKey:nameLetter];
            }
            [[mutableResults objectForKey:nameLetter] addObject:professor];
        }
    }
    _searchResultsProfessorNamesBySection = [mutableResults copy];
    _searchResultsSections = [[mutableResults allKeys] sortedArrayUsingSelector:@selector(compare:)];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    NSString *title;
    
    if (tableView == self.tableView)
    {
        title = [_sections objectAtIndex:section];
    }
    else if(tableView == self.searchDisplayController.searchResultsTableView)
    {
        title = [_searchResultsSections objectAtIndex:section];
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
//helps to display cells
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSArray *profsInSection;
    
    if([tableView isEqual:self.tableView])
    {
        profsInSection = [_professorNamesBySection objectForKey:[_sections objectAtIndex:section]];
    }
    else if ([tableView isEqual:self.searchDisplayController.searchResultsTableView])
    {
        profsInSection = [_searchResultsProfessorNamesBySection objectForKey:[_searchResultsSections objectAtIndex:section]];
    }
    return [profsInSection count];
}

- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView
{
    return _sections;
}

#define CELL_LABEL 1
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UILabel *cellLabel;
    UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if(cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        
        /* this label will take the place of the default cell textLabel because we need to init it with a specific frame */
        cellLabel = [[UILabel alloc] initWithFrame:CGRectMake(tableView.rowHeight, 0, self.view.bounds.size.width - 2*tableView.rowHeight, tableView.rowHeight)];
        cellLabel.tag = CELL_LABEL;
        
        [cell.contentView addSubview:cellLabel];
    }
    
    return cell;
}


#pragma mark UITableViewDelegate methods

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    UILabel *cellLabel = (UILabel *)[cell.contentView viewWithTag:CELL_LABEL];
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
    {
        [cellLabel setFont:[UIFont fontWithName:FONT_NAME_STANDARD size:18.0f]];
    }
    else
    {
        [cellLabel setFont:[UIFont fontWithName:FONT_NAME_STANDARD size:16.0f]];
    }
    /* which professor we are looking in */
    NSString *cellSection = [tableView.dataSource tableView:tableView titleForHeaderInSection:indexPath.section];
    /* retrieve the information for the professor whose information we want to display */
    Professor *professor;
    NSString *name;
    
    if([tableView isEqual:self.tableView])
    {
        professor = [[_professorNamesBySection objectForKey:cellSection] objectAtIndex:indexPath.row];
        name = professor.name;
    }
    else if([tableView isEqual:self.searchDisplayController.searchResultsTableView])
    {
        professor = [[_searchResultsProfessorNamesBySection objectForKey:cellSection] objectAtIndex:indexPath.row];
        name = professor.name;
    }
    cellLabel.text = name;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    /* get the name of the professor */
    UILabel *rowTitleLabel = (UILabel *)[[tableView cellForRowAtIndexPath:indexPath] viewWithTag:CELL_LABEL];
    _selectedRowTitle = rowTitleLabel.text;
    
    [self performSegueWithIdentifier:@"toProfessorDetail" sender:self];
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if([segue.identifier isEqual:@"toProfessorDetail"])
    {
        Professor *professor = [[CMDataManager defaultManager] professorNamed:_selectedRowTitle];
        [segue.destinationViewController setName:professor.name];
        [segue.destinationViewController setDepartment:professor.department];
        [segue.destinationViewController setEmail:professor.email];
        [segue.destinationViewController setAddress:professor.address];
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
