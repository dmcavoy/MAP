//
//  CMProfessorDetailViewController.h
//  Bowdoin Map
//
//  Created by Maddie Baird on 2013-05-07.
//
//
#import <MessageUI/MessageUI.h>
#import <MessageUI/MFMailComposeViewController.h>
#import <UIKit/UIKit.h>
#import "Building.h"

@class Professor;

@interface CMProfessorDetailViewController : UIViewController <UIScrollViewDelegate, MFMailComposeViewControllerDelegate>

@property (weak, nonatomic) Building *building;
@property (weak,nonatomic) Professor *professor;
@property (nonatomic, readonly) UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UILabel *profNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *departmentLabel;
@property (weak, nonatomic) IBOutlet UILabel *addressLabel;
@property (weak, nonatomic) IBOutlet UILabel *emailLabel;
- (IBAction)toggleScrollView:(id)sender;

@end
