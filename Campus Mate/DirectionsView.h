//
//  DirectionsView.h
//  Bowdoin Map
//
//  Created by Maddie Baird on 2013-05-12.
//
//

#import <UIKit/UIKit.h>

@interface DirectionsView : UIView

@property (nonatomic) CGPoint start; // user pin location

@property (nonatomic) CGPoint destination; // destination building location

@property (nonatomic) UIButton * dismissButton;

@end
