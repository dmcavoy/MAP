//
//  AudioAlerts.m
//  Bowdoin Map
//
//  Created by Danielle McAvoy on 4/29/13.
//
//

#import "AudioAlerts.h"
#import "Building.h"

@implementation AudioAlerts

@synthesize usersCurrentBuilding = _usersCurrentBuilding;

-(void) showAlertFor:(Building *) currentBuilding {
    UIAlertView *alert = [[UIAlertView alloc]
                      initWithTitle: @"Building Audio"
                      message: @"There is a building audio available for this building"
                      delegate: self
                      cancelButtonTitle:@"No Thanks"
                      otherButtonTitles:@"Listen",nil];
    self.usersCurrentBuilding = currentBuilding;
    NSLog(@"Alert:%@", self.usersCurrentBuilding.name);
    
    
    [alert show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
	if (buttonIndex == 1) {
		NSLog(@"User Pressed Listen");
        [self playAudio];
	}
	else {
		NSLog(@"User Pressed No Thanks");
	}
}

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


-(NSURL*)pickAudioforBuiding:(Building *)currentClosestBuilding{
    switch (currentClosestBuilding.buildingID) {
        case 7:
            return [NSURL fileURLWithPath:[NSString stringWithFormat:@"%@/Adams.mp3", [[NSBundle mainBundle] resourcePath]]];
            break;
            
        case 18:
            return [NSURL fileURLWithPath:[NSString stringWithFormat:@"%@/McKeenCenter.mp3", [[NSBundle mainBundle] resourcePath]]];
            break;
        case 33:
            return [NSURL fileURLWithPath:[NSString stringWithFormat:@"%@/GibsonHall.mp3", [[NSBundle mainBundle] resourcePath]]];
            break;
        case 38:
            return [NSURL fileURLWithPath:[NSString stringWithFormat:@"%@/HL.mp3", [[NSBundle mainBundle] resourcePath]]];
            break;
        case 49:
            return [NSURL fileURLWithPath:[NSString stringWithFormat:@"%@/Kanbar.mp3", [[NSBundle mainBundle] resourcePath]]];
            break;
        case 55:
            return [NSURL fileURLWithPath:[NSString stringWithFormat:@"%@/MassHall.mp3", [[NSBundle mainBundle] resourcePath]]];
            break;
        case 62:
            return [NSURL fileURLWithPath:[NSString stringWithFormat:@"%@/ArtMuseum.mp3", [[NSBundle mainBundle] resourcePath]]];
            break;
        case 68:
            return [NSURL fileURLWithPath:[NSString stringWithFormat:@"%@/MemorialHall.mp3", [[NSBundle mainBundle] resourcePath]]];
            break;
        case 75:
            return [NSURL fileURLWithPath:[NSString stringWithFormat:@"%@/Russwurm.mp3", [[NSBundle mainBundle] resourcePath]]];
            break;
        case 78:
            return [NSURL fileURLWithPath:[NSString stringWithFormat:@"%@/Searles.mp3", [[NSBundle mainBundle] resourcePath]]];
            break;
        case 79:
            return [NSURL fileURLWithPath:[NSString stringWithFormat:@"%@/Sills.mp3", [[NSBundle mainBundle] resourcePath]]];
            break;
        case 86:
            return [NSURL fileURLWithPath:[NSString stringWithFormat:@"%@/VAC.mp3", [[NSBundle mainBundle] resourcePath]]];
            break;
            
        case 9:
        case 22:
        case 46:
        case 54:
        case 59:
        case 65:
        case 88:
        case 90:
            return [NSURL fileURLWithPath:[NSString stringWithFormat:@"%@/FirstYearDorms.mp3", [[NSBundle mainBundle] resourcePath]]];
            break;
            
        case 12:
        case 16:
        case 40:
        case 44:
        case 50:
        case 53:
        case 71:
        case 72:
            return [NSURL fileURLWithPath:[NSString stringWithFormat:@"%@/collegeHouseSystem.mp3", [[NSBundle mainBundle] resourcePath]]];
            break;
            
        default:
            return nil;
            break;
    }
    
}

-(void)playAction:(id)sender{    
    if(self.audioPlayer.playing){
     [self.audioPlayer pause];
     [sender setTitle:@"Play" forState:UIControlStateNormal];
     [sender setTitleColor:[UIColor blackColor]  forState:UIControlStateNormal];
     }
     else{
     [self.audioPlayer play];
     [sender setTitle:@"Pause" forState:UIControlStateNormal];
     [sender setTitleColor:[UIColor blackColor]  forState:UIControlStateNormal];
     } 
}

-(void)playEnded{
    if (self.audioPlayer.currentTime > self.audioPlayer.duration) {
        [self.delegate removeButton];
    }
}



@end
