//
//  AudioAlerts.h
//  Bowdoin Map
//
//  Created by Danielle McAvoy on 4/29/13.
//
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>
#import "Building.h"

@interface AudioAlerts : NSObject <UIAlertViewDelegate>

@property (nonatomic, strong) AVAudioPlayer *audioPlayer;
@property (nonatomic, strong) Building * usersCurrentBuilding;

-(void)showAlertFor:(Building *) currentBuilding;

@end
