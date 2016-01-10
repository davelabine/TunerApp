//
//  ViewController.m
//  TunerApp
//
//  Created by David LaBine on 12/30/15.
//  Copyright © 2015 David LaBine. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Init the audio manager and set delegate.  This will open the audio device, start recording which sends
    // buffers to receivedAudioSamples
    audioManager = [AudioController sharedAudioManager];
    audioManager.delegate = self;
    
    // Setup the signal analysis.

    autoCorrelator = [[PitchDetector alloc]
                      initWithSampleRate:audioManager.audioFormat.mSampleRate
                      lowBoundFreq:TUNER_LOW_BOUND_FREQ
                      hiBoundFreq:TUNER_HI_BOUND_FREQ
                      andDelegate:self];
    
    medianPitchFollow = [[NSMutableArray alloc] initWithCapacity:MEDIAN_PITCH_FOLLOW_SIZE];
    
    iFreq = 0;
    freqLabel.text = @"Freq: 0";
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)buttonTestMe {
    NSLog(@"buttonTestMe Pressed!");
    iFreq += 100;
    freqLabel.text = [NSString stringWithFormat:@"Freq: %i", (long)iFreq];
}


// Use a median filter to average previous pitch values received
// Should provide accuraccy < 1 cent

- (void) applyMedianFilter:(double) freq {
    NSNumber *nsNumFreq = [NSNumber numberWithDouble:freq];
    [medianPitchFollow insertObject:nsNumFreq atIndex:0];
    
    // If we don't have enough values yet, don't bother filtering.
    if (medianPitchFollow.count < 2) {
        return;
    }
    
    // This is a circular buffer of the most recent pitches.
    // If we're at our max size pop off the oldest value
    if (medianPitchFollow.count > MEDIAN_PITCH_FOLLOW_SIZE) {
        [medianPitchFollow removeObjectAtIndex:medianPitchFollow.count-1];
    }
    
    
    // NEED TO PICK APART HOW THIS ALGORITHM WORKS
    
    double median = 0;
    
    NSSortDescriptor *highestToLowest = [NSSortDescriptor sortDescriptorWithKey:@"self" ascending:NO];
    NSMutableArray *tempSort = [NSMutableArray arrayWithArray:medianPitchFollow];
    [tempSort sortUsingDescriptors:[NSArray arrayWithObject:highestToLowest]];
        
    if(tempSort.count%2==0) {
        double first = 0, second = 0;
        first = [[tempSort objectAtIndex:tempSort.count/2-1] doubleValue];
        second = [[tempSort objectAtIndex:tempSort.count/2] doubleValue];
        median = (first+second)/2;
        freq = median;
    } else {
        median = [[tempSort objectAtIndex:tempSort.count/2] doubleValue];
        freq = median;
    }
        
    [tempSort removeAllObjects];
    tempSort = nil;
    
    // freqLabel.text = [NSString stringWithFormat:@"%3.1f Hz", value];
    NSLog([NSString stringWithFormat:@"Pitch Message: %f", freq]);
    freqLabel.text = [NSString stringWithFormat:@"Freq: %f", freq];
}


- (void) receivedAudioSamples:(SInt16 *)samples length:(int)len {
    [autoCorrelator addSamples:samples inNumberFrames:len];
}

- (void) updatedPitch:(float)frequency {
    [self applyMedianFilter:frequency];
}




@end


