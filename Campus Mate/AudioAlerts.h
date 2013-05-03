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

@class AudioAlerts;

@protocol AudioAlertsDelegate <NSObject>

-(void)addAudioButton;

@end

@interface AudioAlerts : NSObject <UIAlertViewDelegate>

@property (nonatomic, strong) AVAudioPlayer *audioPlayer;
@property (nonatomic, strong) Building * usersCurrentBuilding;

@property (nonatomic) id <AudioAlertsDelegate> delegate;

-(void)showAlertFor:(Building *) currentBuilding;

@end
