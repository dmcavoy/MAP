//
//  AudioAlerts.h
//  Bowdoin Map
//
//  Created by Danielle McAvoy on 4/29/13.

/*
 Class that sets up the stuff for playing audios in tour mode for building with audio tours available.  Creates a play and pause button for the audios.
 */

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>
#import "Building.h"

@class AudioAlerts;

@protocol AudioAlertsDelegate <NSObject>

/*
 Should set up the button and put it up on the view for the user.  It also links it to a selector.
 */
-(void)addAudioButton;

/*
 Remove the button from the user view.
 */
-(void)removeButton;

@end

@interface AudioAlerts : NSObject <UIAlertViewDelegate>

// Audio player for building audios
@property (nonatomic, strong) AVAudioPlayer *audioPlayer;

@property (nonatomic) id <AudioAlertsDelegate> delegate;

/*
 Method which creates an alert for a building 
 audio and then shows the alert to the user.
 The alert has the options to listen or say no 
 thanks. 
 
 Params:
 currentBuilding- The building the user is closests too
 
 */
-(void)showAlertFor:(Building *) currentBuilding;

/*
 Method that pauses and plays the audio as
 well as changes the button to match if the 
 audio is pausing or playing. 
 
 Params:
 sender - the button
 
 */
-(void)playAction:(id)sender;

/*
 Method that checks if the building has
 an audio file that goes with it. 
 
 Params:
 building - the building to check
 
 Return:
 BOOL - yes if there is an audio
 
 */
-(BOOL)hasBuildingAudioFor:(Building *)building;

@end
