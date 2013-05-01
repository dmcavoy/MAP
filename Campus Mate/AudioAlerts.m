//
//  AudioAlerts.m
//  Bowdoin Map
//
//  Created by Danielle McAvoy on 4/29/13.
//
//

#import "AudioAlerts.h"

@implementation AudioAlerts


-(void) showAlert {
    UIAlertView *alert = [[UIAlertView alloc]
                      initWithTitle: @"Building Audio"
                      message: @"There is a building audio available for this building"
                      delegate: self
                      cancelButtonTitle:@"No Thanks"
                      otherButtonTitles:@"Listen",nil];
    [alert show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
	if (buttonIndex == 1) {
		NSLog(@"user pressed Listen");
        [self playAudio];
	}
	else {
		NSLog(@"user pressed No Thanks");
	}
}

- (void)playAudio {
    
	NSURL *url = [NSURL fileURLWithPath:[NSString stringWithFormat:@"%@/Adams.mp3", [[NSBundle mainBundle] resourcePath]]];
    
    
	NSError *error;
	self.audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:&error];
	self.audioPlayer.numberOfLoops = 0;
    self.audioPlayer.volume = 0.5; // 0.0 - no volume; 1.0 full volume
    NSLog(@"%f seconds played so far", self.audioPlayer.currentTime);
    //self.audioPlayer.currentTime = 10; // jump to the 10 second mark
    //[self.audioPlayer pause];
    //[self.audioPlayer stop]; // Does not reset currentTime; sending play resumes
	
	if (self.audioPlayer == nil){
		NSLog([error description]);
    }
	else {
		[self.audioPlayer play];
    }
    
}



@end
