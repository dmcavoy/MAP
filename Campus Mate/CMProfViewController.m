//
//  CMProfViewController.m
//  Bowdoin Map
//
//  Created by Maddie Baird on 2013-05-06.
//
//

#import "CMProfViewController.h"
#import "CMProfessorDetailViewController.h" 
#import "CMProfDataManager.h"
#import "Professor.h"
#define CELL_LABEL_TAG 1
#define IMAGE_VIEW_TAG 2

@interface CMProfViewController ()
{
      @private
      NSMutableDictionary * _professors;  //professors names stored using table view sections as keys
      NSArray * _tableSections;     //sections in table view
      NSMutableDictionary * _searchResultsProfessors; //professors in the search results table view using their sections as keys
      NSArray *_searchResultsTableSections;     //sections in the search results table view
      NSString *_selectedRowTile; //name of the selected professor
}

-(void)initialize;

@end

@implementation CMProfViewController

- (id)init
{
      self = [super init];
      if (self) {
            [self initialize];
      }
      return self;
}

- (void)viewDidLoad
{
      [super viewDidLoad];

      // Uncomment the following line to preserve selection between presentations.
      // self.clearsSelectionOnViewWillAppear = NO;
 
      // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
      // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}     

-(void)initialize
{
      /* each section is the group of professors whose name begins with that letter of the alphabet */
      NSString *alphabet = @"#ABCDEFGHIJKLMNOPQRSTUVWXYZ";
      _professors = [NSMutableDictionary dictionaryWithCapacity:[alphabet length]];
      
      /* each section becomes a key in dictionary and corresponding value will be the names of the professors in that section */
      for (int i = 0; i < [alphabet length]; i++)
      {
            [_professors setObject:[NSMutableArray array] forKey:[alphabet substringWithRange:NSMakeRange(i, 1)]];
      }
      
      NSArray *allProfessors = [[CMProfDataManager defaultProfessorManager] profs];
      
      /* put each professors name in the appropriate section in the dictionary*/
      for(Professor *prof in allProfessors)
       {
             NSString *nameLetter = [prof.name substringToIndex:1];
            if([nameLetter intValue])
            {
                  [[_professors objectForKey:@"#"] addObject:prof];
            }
            else
            {
                  [[_professors objectForKey:[nameLetter uppercaseString]] addObject:prof.name];
            }
       }
      _tableSections = [[_professors allKeys] sortedArrayUsingSelector:@selector(compare:)];

}
//when text changes in the search bar, we want to update shown search results right away
-(void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
      NSArray *allProfessors = [[CMProfDataManager defaultProfessorManager] profs];
      NSMutableDictionary *mutableResults = [NSMutableDictionary dictionary];
      
      /* search all text fields in each building for the search text*/
      for(Professor *prof in allProfessors)
      {
            NSRange nameRange = [[prof.name lowercaseString] rangeOfString:[searchText lowercaseString]];
            NSRange departmentRange = [[prof.department lowercaseString] rangeOfString:[searchText lowercaseString]];
            if(nameRange.location != NSNotFound || departmentRange.location != NSNotFound)
            {
                  NSString *nameLetter = [prof.name substringToIndex:1];
                  if([nameLetter intValue])
                  {
                        nameLetter = @"#";
                  }
                  if(![mutableResults objectForKey:nameLetter])
                  {
                        [mutableResults setObject:[NSMutableArray array] forKey:nameLetter];
                  }
                  [[mutableResults objectForKey:nameLetter] addObject:prof.name];
            }
      }
}

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
      NSString *title;
      
      if(tableView == self.tableView)
      {
            title = [_tableSections objectAtIndex:section];
      }
      else if(tableView == self.searchDisplayController.searchResultsTableView)
      {
            title = [_searchResultsTableSections objectAtIndex:section];
      }
      return title;
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
      NSInteger count = 1;
      
      if(tableView == self.tableView)
      {
            count = _tableSections.count;
      }
      else if(tableView == self.searchDisplayController.searchResultsTableView)
      {
            count = _searchResultsTableSections.count;
      }
      return count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
      NSArray *profsInSection;
      
      if([tableView isEqual:self.tableView])
      {
            profsInSection = [_professors objectForKey:[_tableSections objectAtIndex:section]];
      }
      else if([tableView isEqual:self.searchDisplayController.searchResultsTableView])
      {
            profsInSection = [_searchResultsProfessors objectForKey:[_searchResultsTableSections objectAtIndex:section]];
      }
      return [profsInSection count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
      static NSString *CellIdentifier = @"Cell";
      UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:CellIdentifier];
      UILabel *cellLabel;
      
      if(cell == nil)
      {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            
            //this label will take the place of the default cell text label so it inits with a specific frame
            cellLabel = [[UILabel alloc] initWithFrame:CGRectMake(tableView.rowHeight, 0, self.view.bounds.size.width - 2 * tableView.rowHeight, tableView.rowHeight)];
            cellLabel.tag = CELL_LABEL_TAG;
            [cell.contentView addSubview:cellLabel];
      }
    
    
    return cell;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
      UIImageView *headerView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, [tableView.delegate tableView:tableView heightForHeaderInSection:section])];
      
      /* this will be the background image for the table view headers. Currently this is set to use the same image as the navigation bar */
      UIImage *backgroundImage = [UIImage imageNamed:@"navbar-44"];
      
      headerView.image = [backgroundImage stretchableImageWithLeftCapWidth:backgroundImage.size.width/2 topCapHeight:backgroundImage.size.height/2];

      
      UILabel *sectionName = [[UILabel alloc] initWithFrame:CGRectMake(10.0f, 0, tableView.frame.size.width - 10.0f, 20.0f)];
      sectionName.backgroundColor = [UIColor clearColor];
      sectionName.font = [UIFont fontWithName:FONT_NAME_BOLD size:15.0f];
      sectionName.textColor = [UIColor whiteColor];
      sectionName.text = [tableView.dataSource tableView:tableView titleForHeaderInSection:section];
      [headerView addSubview:sectionName];
      return headerView;
}

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
      UILabel *cellLabel = (UILabel *)[cell.contentView viewWithTag:CELL_LABEL_TAG];
      
      if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
      {
            [cellLabel setFont:[UIFont fontWithName:FONT_NAME_STANDARD size:18.0f]];
      }
      else
      {
            [cellLabel setFont:[UIFont fontWithName:FONT_NAME_STANDARD size:16.0f]];
      }
      /* which section of professors we are looking at*/
      NSString *cellSection = [tableView.dataSource tableView:tableView titleForHeaderInSection:indexPath.section];
      
      /* get information for the professor we want to display*/
      Professor *cellProf;
      
      if([tableView isEqual:self.tableView])
      {
            cellProf = [[CMProfDataManager defaultProfessorManager] professorNamed:[[_professors objectForKey:cellSection] objectAtIndex:indexPath.row]];
      }
      else if([tableView isEqual:self.searchDisplayController.searchResultsTableView])
      {
            cellProf = [[CMProfDataManager defaultProfessorManager] professorNamed:[[_searchResultsProfessors objectForKey:cellSection] objectAtIndex:indexPath.row]];
      }
      cellLabel.text = cellProf.name;
}

#pragma mark - Table view delegate

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
      //get professor's name
      UILabel *rowTitleLabel = (UILabel *)[[tableView cellForRowAtIndexPath:indexPath] viewWithTag:CELL_LABEL_TAG];
      _selectedRowTile = rowTitleLabel.text;
      
      //transition to the professor's information controller
      [self performSegueWithIdentifier:@"toProfessorDetail" sender:self];
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
      if([segue.identifier isEqualToString:@"toProfessorDetail"])
      {
            Professor *prof = [[CMProfDataManager defaultProfessorManager] professorNamed:_selectedRowTile];
            CMProfessorDetailViewController *pdvc = (CMProfessorDetailViewController *)segue.destinationViewController;
            pdvc.professor = prof;
      }
}

-(NSUInteger)supportedInterfaceOrientations
{
      return UIInterfaceOrientationMaskAll;
}
-(BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation
{
      return YES;
}

@end
