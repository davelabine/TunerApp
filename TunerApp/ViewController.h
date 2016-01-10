//
//  ViewController.h
//  TunerApp
//
//  Created by David LaBine on 12/30/15.
//  Copyright © 2015 David LaBine. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AudioController.h"
#import "PitchDetector.h"


// Track about 22 frequencies in the median filter, this means we're tracking the median of the signal for the last second or so.
static const int MEDIAN_PITCH_FOLLOW_SIZE = 22;

@interface ViewController : UIViewController <AudioControllerDelegate> {
    IBOutlet UILabel *freqLabel;
    
    NSInteger iFreq;
    
    AudioController *audioManager;
    PitchDetector *autoCorrelator;
    
    NSMutableArray *medianPitchFollow;
}
- (IBAction)buttonTestMe;

@end

