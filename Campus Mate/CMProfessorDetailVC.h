//
//  CMProfessorDetailVC.h
//  Bowdoin Map
//
//  Created by Maddie Baird on 2013-05-11.
//
//

#import <UIKit/UIKit.h>
#import <MessageUI/MessageUI.h>
#import <MessageUI/MFMailComposeViewController.h>

@interface CMProfessorDetailVC : UIViewController 

@property (nonatomic) NSString *name;
@property (nonatomic) NSString *department;
@property (nonatomic) NSString *address;
@property (nonatomic) NSString *email;
@property (nonatomic) NSString *building;

-(void)setDepartment:(NSString *)department;
-(void)setName:(NSString *)name;
-(void)setEmail:(NSString *)email;
-(void)setAddress:(NSString *)address;
-(void)setBuilding:(NSString *)building;
@property (weak, nonatomic) IBOutlet UILabel *professorLabel;
@property (weak, nonatomic) IBOutlet UILabel *departmentLabel;
@property (weak, nonatomic) IBOutlet UILabel *addressLabel;
@property (weak, nonatomic) IBOutlet UILabel *emailLabel;

@end
