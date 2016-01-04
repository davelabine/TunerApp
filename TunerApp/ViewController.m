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
    // Set which frequencies to look at:
    //    - Low open B on a 5 string bass is ~30Hz (B0)
    //    - Highest note on a guitar in standard tuning is about 1400Hz (F6)
    //    - But a lot of people like to tune with upper harmonics which can get to 4500Hz (C#8)
    autoCorrelator = [[PitchDetector alloc]
                      initWithSampleRate:audioManager.audioFormat.mSampleRate
                      lowBoundFreq:30
                      hiBoundFreq:4500
                      andDelegate:self];
    
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
    freqLabel.text = [NSString stringWithFormat:@"Freq: %i", iFreq];
}


- (void) receivedAudioSamples:(SInt16 *)samples length:(int)len {
    [autoCorrelator addSamples:samples inNumberFrames:len];
}
@end
