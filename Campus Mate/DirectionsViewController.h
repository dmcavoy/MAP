//
//  DirectionsViewController.h
//  Bowdoin Map
//
//  Created by Danielle McAvoy on 5/4/13.
//
//

#import <UIKit/UIKit.h>

@interface DirectionsViewController : UIViewController <UIPickerViewDelegate>

@property (nonatomic) UITextField *textfield;
@property (nonatomic) UIPickerView *buildingPicker;
@property (nonatomic) NSArray *buildings;

@end
