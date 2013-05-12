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
}

@end


@implementation CMProfessorTableViewController

@synthesize building;
@synthesize professors;
- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void)initialize
{
    _professorNamesBySection = [NSMutableDictionary dictionaryWithCapacity:[professors count]];
    _sections = [NSArray array];
    /* each section becomes a key in the dictionary and the corresponding value will be the last names of the professors in that section */
    for(Professor *professor in professors)
    {
        [_professorNamesBySection setObject:professor forKey:professor.name];
    }
    
    //IN FUTURE, WOULD LIKE TO HAVE THESE ALPHABETICAL BY LAST NAME, BUT LEAVING IT FOR NOW
    _sections = [[_professorNamesBySection allKeys] sortedArrayUsingSelector:@selector(compare:)];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    NSString *title;
    
    if (tableView == self.tableView)
    {
        title = [_sections objectAtIndex:section];
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
    
    return count;
}
//helps to display cells
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSMutableArray *profsInSection = [[NSMutableArray alloc] init];
    
    if([tableView isEqual:self.tableView])
    {
        [profsInSection addObject:[_professorNamesBySection objectForKey:[_sections objectAtIndex:section]]];
    }
    return [profsInSection count];
}

#define CELL_LABEL 1
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UILabel *cellLabel;
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if(cell == nil)
    {
        cell = [[UITableViewCell alloc] init];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
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
    cellLabel.text = cellSection;
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
        for(NSString *key in _professorNamesBySection)
        {
            if([_selectedRowTitle isEqualToString:key])
            {
                Professor *professor = [_professorNamesBySection objectForKey:key];
                [segue.destinationViewController setName:professor.name];
                [segue.destinationViewController setDepartment:professor.department];
                [segue.destinationViewController setEmail:professor.email];
                [segue.destinationViewController setAddress:professor.address];
            }
        }
        
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
