//
//  DirectionsViewController.m
//  Bowdoin Map
//
//  Created by Danielle McAvoy on 5/4/13.
//
//

#import "DirectionsViewController.h"

@interface DirectionsViewController ()

@end

@implementation DirectionsViewController

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
    
    // PickerView1
    self.buildings=[[NSArray alloc]initWithObjects:@"USD",@"INR",@"EUR", nil];
    self.buildingPicker=[[UIPickerView alloc]initWithFrame:CGRectMake(0, 50, 320,10)];
    self.buildingPicker.delegate=self;
    //self.buildingPicker.tag=PICKER1_TAG;
    self.buildingPicker.showsSelectionIndicator=YES;
    [self.view addSubview:self.buildingPicker];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
