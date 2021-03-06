//
//  CMProfessorDetailVC.m
//  Bowdoin Map
//
//  Created by Maddie Baird on 2013-05-11.
//
//

#import "CMProfessorDetailVC.h"
#import "CMDataManager.h"
#import "Building.h"

@interface CMProfessorDetailVC ()

@end

@implementation CMProfessorDetailVC

@synthesize name = _name;
@synthesize department = _department;
@synthesize address = _address;
@synthesize email = _email;
@synthesize building = _building;
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
-(void)setBuilding:(NSString *)building
{
    NSArray *allBuildings = [[CMDataManager defaultManager] buildings];
   /*
    for (Building *loopBuilding in allBuildings)
    {
        if ([NSNotFound isEqual[loopBuilding.name rangeOfString:building]]) {
            <#statements#>
        }
        
    }*/
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
