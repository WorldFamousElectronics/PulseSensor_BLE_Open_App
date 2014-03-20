//
//  ViewController.h
//  PulseSensor_BLE_Open_App
//
//  Created by GrownYoda on 3/19/14.
//  Copyright (c) 2014 YuryGitman. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BLE.h"

@interface ViewController : UIViewController <BLEDelegate>  //Make ViewController the BLE Delegate




////////////////////////////////////////
//            readBearLab  BLE
////////////////////////////////////////

// BLE Class Instance
@property (strong, nonatomic) BLE *readBearBLEinstance;

////////////////////////////////////////
//            BLE Interface Elements
////////////////////////////////////////
@property (weak, nonatomic) IBOutlet UIProgressView *progressViewBLEsignal;
@property (weak, nonatomic) IBOutlet UILabel *labelBLEMessageAndUUID;
@property (weak, nonatomic) IBOutlet UILabel *labelBLEName;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicatorBLE;
@property (weak, nonatomic) IBOutlet UILabel *labelBLESignal;
@property (weak, nonatomic) IBOutlet UIButton *buttonBLEConnectDisconnect;
- (IBAction)BLEConnectDisconnectButtonPressed:(id)sender;

////////////////////////////////////////
//            Arduino Interface
////////////////////////////////////////

- (IBAction)swTestLED:(id)sender;
@property (weak, nonatomic) IBOutlet UISwitch *testLEDProperty;

- (IBAction)swAnalogPinMonitor:(id)sender;
@property (weak, nonatomic) IBOutlet UISwitch *swAnalogPinProperty;

////////////////////////////////////////
//            Pulse Sensor Interface
////////////////////////////////////////

// Blinking Heart & BPM
@property (weak, nonatomic) IBOutlet UILabel *labelHeart;
@property (weak, nonatomic) IBOutlet UILabel *labelBPM;

// Progress View Changing Number Labels
@property (weak, nonatomic) IBOutlet UILabel *labelPulseSensorRawSignal;
@property (weak, nonatomic) IBOutlet UILabel *labelTrough;
@property (weak, nonatomic) IBOutlet UILabel *labelThreshold;
@property (weak, nonatomic) IBOutlet UILabel *labelPeak;
@property (weak, nonatomic) IBOutlet UILabel *labelAmplitude;

// Progess Views Bars
@property (weak, nonatomic) IBOutlet UIProgressView *progressBarPulseSensorSignal;
@property (weak, nonatomic) IBOutlet UIProgressView *progressBarTrough;
@property (weak, nonatomic) IBOutlet UIProgressView *progressBarThreshold;
@property (weak, nonatomic) IBOutlet UIProgressView *progressBarPeak;
@property (weak, nonatomic) IBOutlet UIProgressView *progressBarAmp;


//  For New Image Overlay
@property (strong , nonatomic) IBOutlet UIImageView *myImageView;

@end
