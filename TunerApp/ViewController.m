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
    
    // Init the audio manager and set delegate.  This will open the audio device and start recording.
    audioManager = [AudioController sharedAudioManager];
    audioManager.delegate = self;
    
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
