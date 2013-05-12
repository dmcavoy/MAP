//
//  AudioAlerts.m
//  Bowdoin Map
//
//  Created by Danielle McAvoy on 4/29/13.


#import "AudioAlerts.h"
#import "Building.h"

@interface AudioAlerts()

@property (nonatomic, strong) Building * usersCurrentBuilding;

@end    
@implementation AudioAlerts

@synthesize usersCurrentBuilding = _usersCurrentBuilding;

-(void)initWithAudioPlayer:(AVAudioPlayer *)audioPlayer andPlayButton:(UIButton*)playButton andStopButton: (UIButton*)stopButton{
    self.audioPlayer = audioPlayer;
    self.playButton = playButton;
    self.stopButton = stopButton;
}

// creates alert and shows it
-(void) showAlertFor:(Building *) currentBuilding {
    
    self.alreadyAudio = YES;
    UIAlertView *alert = [[UIAlertView alloc]
                      initWithTitle: @"Building Audio"
                      message:[NSString stringWithFormat: @"There is a building audio available for %@", currentBuilding.name]
                      delegate: self
                      cancelButtonTitle:@"No Thanks"
                      otherButtonTitles:@"Listen",nil];
    
    self.usersCurrentBuilding = currentBuilding;

    
    [alert show];
}

#pragma mark - UIAlertView methods

// For audio
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
	// User pressed listen
    if (buttonIndex == 1) {
        [self playAudio];
	}
    // User pressed No Thanks
	else {
        self.alreadyAudio = NO;
	}
}

/*
 Gets the path for the audio.  Creates the audioPlayer. Then plays the audio and puts up the play/pause button.
 */
- (void)playAudio {
    
	NSURL *url = [self pickAudioforBuiding:self.usersCurrentBuilding];
    
	NSError *error;
	self.audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:&error];
	self.audioPlayer.numberOfLoops = 0;
    self.audioPlayer.volume = 0.5; // 0.0 - no volume; 1.0 full volume
	self.audioPlayer.delegate = self;
	if (self.audioPlayer == nil){
		NSLog(@"%@",[error description]);
    }
	else {
		[self.audioPlayer play];
        [self.delegate addAudioButtons];
    }
}

/*
 Get the audio file for the building.
 
 Param:
 currentClosestBuilding - the current building near the user
 
 Return:
 NSURL-path for the audio file
 */
-(NSURL*)pickAudioforBuiding:(Building *)currentClosestBuilding{
    if ([self hasBuildingAudioFor:currentClosestBuilding]) {
        return currentClosestBuilding.audio;
    }
    else{
        return nil;
    } 
}

/*Checks if building has audio
need to update list if new buildings get audio files
This wont be needed at the point when all buildings
have audios
 
 Param:
 building -> the building to check if has an audio
 
 Return:
 BOOL -> if it has an audio
 
 */
-(BOOL)hasBuildingAudioFor:(Building *)building{
    switch (building.buildingID) {
        case 7:
        case 9:
        case 12:
        case 16:
        case 18:
        case 22:
        case 23:
        case 28:
        case 32:
        case 33:
        case 38:
        case 40:
        case 42:
        case 44:
        case 45:
        case 46:
        case 49:
        case 50:
        case 52:
        case 53:
        case 54:
        case 55:
        case 59:
        case 60:
        case 62:
        case 65:
        case 66:
        case 67:
        case 68:
        case 71:
        case 72:
        case 75:
        case 76:
        case 78:
        case 79:
        case 81:
        case 84:
        case 85:
        case 86:
        case 87:
        case 88:
        case 89:
        case 90:
        case 91:
            return YES;
            break;
        default:
            return NO;
            break;
    }
}

// Plays and pauses audio / Changes button
-(void)playAction:(id)sender{    
    if(self.audioPlayer.playing){
        [self.audioPlayer pause];
        [sender setTitle:@"Play" forState:UIControlStateNormal];
        UIImage *buttonImageNormal = [UIImage imageNamed:@"play.png"];
        [sender setImage:buttonImageNormal forState:UIControlStateNormal];
     }
     else{
         [self.audioPlayer play];
         [sender setTitle:@"Pause" forState:UIControlStateNormal];
         UIImage *buttonImageNormal = [UIImage imageNamed:@"pause.png"];
         [sender setImage:buttonImageNormal forState:UIControlStateNormal];
     } 
}

// stop audio and remove audio buttons
-(void)stopAudioPlayer{
    self.alreadyAudio = NO;
    [self.audioPlayer stop];
    [self.delegate removeAudioButtons];
}

/*
 If the audio plays all the way through then dismiss the audio player and its buttons.
 */
- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag
{
    self.alreadyAudio = NO;
    [self.delegate removeAudioButtons];
}

@end
