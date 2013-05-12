//
//  CMProfessorTableViewController.h
//  Bowdoin Map
//
//  Created by Maddie Baird on 2013-05-10.
//
//

#import <UIKit/UIKit.h>

@interface CMProfessorTableViewController : UITableViewController <UISearchDisplayDelegate>

@property (nonatomic) NSString *building;                             //The name of the building that is being searched
@property (nonatomic) NSArray *professors;
@end
