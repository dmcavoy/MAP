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


// creates alert and shows it
-(void) showAlertFor:(Building *) currentBuilding {
    
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

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
	if (buttonIndex == 1) {
		NSLog(@"User Pressed Listen");
        [self playAudio];
	}
	else {
		NSLog(@"User Pressed No Thanks");
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
	
	if (self.audioPlayer == nil){
		NSLog(@"%@",[error description]);
    }
	else {
		[self.audioPlayer play];
        [self.delegate addAudioButton];
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

// Checks if building has audio
-(BOOL)hasBuildingAudioFor:(Building *)building{
    switch (building.buildingID) {
        case 7:
        case 9:
        case 12:
        case 16:
        case 18:
        case 22:
        case 33:
        case 38:
        case 40:
        case 44:
        case 46:
        case 49:
        case 50:
        case 53:
        case 54:
        case 55:
        case 59:
        case 62:
        case 65:
        case 68:
        case 71:
        case 72:
        case 75:
        case 78:
        case 79:
        case 86:
        case 88:
        case 90:
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

// Not used: Need to find a way to alert audio ended
-(void)playEnded{
    if (self.audioPlayer.currentTime > self.audioPlayer.duration) {
        [self.delegate removeButton];
    }
}



@end
