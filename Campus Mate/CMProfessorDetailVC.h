//
//  CMProfessorDetailVC.h
//  Bowdoin Map
//
//  Created by Maddie Baird on 2013-05-11.
//
//

#import <UIKit/UIKit.h>

@interface CMProfessorDetailVC : UIViewController <UIScrollViewDelegate>

@property (nonatomic) NSString *name;
@property (nonatomic) NSString *department;
@property (nonatomic) NSString *address;
@property (nonatomic) NSString *email;

-(void)setDepartment:(NSString *)department;
-(void)setName:(NSString *)name;
-(void)setEmail:(NSString *)email;
-(void)setAddress:(NSString *)address;
@property (weak, nonatomic) IBOutlet UILabel *professorLabel;
@property (weak, nonatomic) IBOutlet UILabel *departmentLabel;
@property (weak, nonatomic) IBOutlet UILabel *addressLabel;
@property (weak, nonatomic) IBOutlet UILabel *emailLabel;

@end
