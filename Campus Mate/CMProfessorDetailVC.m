//
//  CMProfessorDetailVC.m
//  Bowdoin Map
//
//  Created by Maddie Baird on 2013-05-11.
//
//

#import "CMProfessorDetailVC.h"

@interface CMProfessorDetailVC ()

@end

@implementation CMProfessorDetailVC

@synthesize name = _name;
@synthesize department = _department;
@synthesize address = _address;
@synthesize email = _email;
@synthesize professorLabel = _professorLabel;
@synthesize emailLabel = _emailLabel;
@synthesize departmentLabel = _departmentLabel;
@synthesize addressLabel = _addressLabel;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    /* sets the attributes of the email button title to look like a hyperlink */
    NSArray *normalAttributeValues = [NSArray arrayWithObjects:[UIFont fontWithName:FONT_NAME_STANDARD size:12], [UIColor blueColor], [NSNumber numberWithInt:NSUnderlineStyleSingle], nil];
    NSArray *highlightedAttributeValues = [NSArray arrayWithObjects:[UIFont fontWithName:FONT_NAME_STANDARD size:12], [UIColor darkGrayColor], [NSNumber numberWithInt:NSUnderlineStyleSingle], nil];
    
    NSArray *attributeKeys = [NSArray arrayWithObjects:NSFontAttributeName, NSForegroundColorAttributeName, NSUnderlineStyleAttributeName, nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)setAddress:(NSString *)address
{
    _address = address;
}
-(void)setEmail:(NSString *)email
{
    _email = email;
}
-(void)setName:(NSString *)name
{
    _name = name;
}
-(void)setDepartment:(NSString *)department
{
    _department = department;
}
-(void)updateUI
{
    self.professorLabel.text = _name;
    self.departmentLabel.text = _department;
    self.addressLabel.text = _address;
    self.emailLabel.text = _email;
}

-(void)viewDidAppear:(BOOL)animated
{
    [self updateUI];
}
-(void)viewWillAppear:(BOOL)animated
{
    [self updateUI];
}
- (void)viewDidUnload {
    [self setProfessorLabel:nil];
    [self setDepartmentLabel:nil];
    [self setAddressLabel:nil];
    [self setEmailLabel:nil];
    [super viewDidUnload];
}
@end
