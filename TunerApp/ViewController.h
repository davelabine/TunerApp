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

@interface ViewController : UIViewController <AudioControllerDelegate> {
    IBOutlet UILabel *freqLabel;
    
    NSInteger iFreq;
    
    AudioController *audioManager;
    PitchDetector *autoCorrelator;
    
    NSMutableArray *medianPitchFollow;
}
- (IBAction)buttonTestMe;
@end

