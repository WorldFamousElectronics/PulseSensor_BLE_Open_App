//
//  ViewController.m
//  PulseSensor_BLE_Open_App
//
//  Created by GrownYoda on 3/19/14.
//  Copyright (c) 2014 YuryGitman. All rights reserved.
//

#import "ViewController.h"

extern int globalBPM;
extern int globalSignal;
extern BOOL globalBeatDidHappenBOOL;
extern int globalAlgoTrough;
extern int globalAlgoPeak;
extern int globalAlgoThreshold;
extern int globalAlgoAmplitude;



@interface ViewController(){
#pragma public properties and variables
    
    // PulseSensor BPM Elements
    NSMutableArray *beatsHappenedTimeStampedArray;
    NSMutableArray *beatQualifyArray;
    int counter;
    
    
    // For HardCoding Part of Code
    NSString *myBlueSheildUUID;
    CBUUID * myUUIDA;
    CBUUID * foundUUIDA;
    
}


@end

@implementation ViewController
#pragma private intance variables

/////////////////////////////////////
//  BLE Class and Interface Elements
/////////////////////////////////////
@synthesize readBearBLEinstance,buttonBLEConnectDisconnect,labelBLEMessageAndUUID,progressViewBLEsignal,activityIndicatorBLE, labelBLEName, labelBLESignal;

/////////////////////////////////////
// Arduino Interface Elements
/////////////////////////////////////
@synthesize testLEDProperty, swAnalogPinProperty;

/////////////////////////////////////
//  PulseSensor Interface Elements
/////////////////////////////////////
@synthesize labelPulseSensorRawSignal,labelAmplitude,labelPeak,labelThreshold,labelTrough, labelBPM,labelHeart;
@synthesize progressBarPulseSensorSignal,progressBarAmp,progressBarPeak,progressBarThreshold, progressBarTrough;

/////////////////////////////////////
//  Vars for - (void)PulseSensorFullCode
/////////////////////////////////////

Boolean Pulse = false;
Boolean RealQualifiedBeat = false;
int PulseSensorValue;
int Signal;
int Trough = 512;
int Peak = 512;
int Threshold = 512;
int Amplitude = 100;

int beatsSampleCounter = 0;

/////////////////////////////////////
#pragma View Did Load
/////////////////////////////////////

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Create an Instance of BLE from Red Bear Lab's Framework
    readBearBLEinstance = [[BLE alloc]init];
    [readBearBLEinstance controlSetup:1];   // not sure ??
    readBearBLEinstance.delegate = self;    // set Instance Delegate to self this ViewController
    
    // Setup BLE Interface Elements
    [labelBLEMessageAndUUID setText:@"Not Connected to Any BLE Device"];
    [progressViewBLEsignal setProgress:0.0];
    counter = 0;
    [labelBLEName setText:@""];
    [labelBLESignal setText:@""];
    
    //  Setup Arduino Interface Elements
    [testLEDProperty setOn:NO animated:YES];
    [swAnalogPinProperty setOn:NO animated:YES];
    [_swVisualize setOn:NO animated:YES];

    [progressBarPulseSensorSignal setProgress:0.05];
    
    // Setup PS Interface Elements
    [self resetAllPulseSensorVariables];
    [self updateLabelsPulseSensorInterfaceElements];
    
    
    // Setup PS BPM Elements
    beatsHappenedTimeStampedArray = [@[@"0",@"0",@"0",@"0",@"0",@"0",@"0",@"0",@"0",@"0"]mutableCopy];
    beatQualifyArray = [@[@"0",@"0"]mutableCopy];
    beatQualifyArray[0]= [NSDate date];
    
    [self printArray];   // for debugging
    [labelHeart setAlpha:0.2];
    [labelHeart setTextColor:[UIColor redColor]];
    
    
    // Setup For New UIImageView
    _myImageView = [[UIImageView alloc] init];
    [_myImageView setFrame:CGRectMake(0, 150, self.view.frame.size.width, self.view.frame.size.height)];

    
}

-(void) resetBeatsHappenedTimeStampedArray{
    for (int i = 0; i<9; i++) {
        beatsHappenedTimeStampedArray[i]= @"0";
    }
    beatsSampleCounter = 0;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



/////////////////////////////////////
# pragma mark BLE Interface
/////////////////////////////////////

- (IBAction)BLEConnectDisconnectButtonPressed:(id)sender {
    
    //  IF ALREADY CONNECTED
    if (readBearBLEinstance.activePeripheral){
        if (readBearBLEinstance.activePeripheral.isConnected) {
            // iPhone is Connected, Tell it to Disconnect
            [[readBearBLEinstance CM] cancelPeripheralConnection:readBearBLEinstance.activePeripheral];
            
            //  Do Interface Changes on Disconnect
            [buttonBLEConnectDisconnect setTitle:@"Connect to BLE Device" forState:UIControlStateNormal];
            [labelBLEMessageAndUUID setText:@"Not Connected To BLE Peripheral"];
            [progressViewBLEsignal setProgress:0.0 animated:YES];
            [labelBPM setText:@" -- "];
            [self resetAllPulseSensorVariables];
            
            return;
        }
    }
    // Clear out any Peripherals if they exist
    if (readBearBLEinstance.peripherals) {
        readBearBLEinstance.peripherals = nil;
    }
    
    //  Go Do BLE Scanning
    [readBearBLEinstance findBLEPeripherals:2];
    [NSTimer scheduledTimerWithTimeInterval:2.0 target:self selector:@selector(connectionTimer:) userInfo:nil repeats:NO];
    [activityIndicatorBLE startAnimating];
    [buttonBLEConnectDisconnect setTitle:@"Scanning" forState:UIControlStateNormal];
    [labelBLEMessageAndUUID setText:@"Scanning..."];
}



/////////////////////////////////////
#pragma BLE Delegate Calls
/////////////////////////////////////

-(void) bleDidConnect{
    NSLog(@"bleDidConnected");
    
    //reset Pulse Sensor Display
    [self resetAllPulseSensorVariables];
    //    [self resetPulseSensorAlgoVariables];   //Yury Moved Out to fix Bug on Restart
    [self updateLabelsPulseSensorInterfaceElements];
    
    
    // BLE Interface
    //Labels
    [labelBLEMessageAndUUID setText:[NSString stringWithFormat:@"UUID: %s",[readBearBLEinstance UUIDToString:readBearBLEinstance.activePeripheral.UUID]]];
    [labelBLEName setText:[NSString stringWithFormat:@"BLE Name: %s",[readBearBLEinstance.activePeripheral.name cStringUsingEncoding:NSStringEncodingConversionAllowLossy ]]];
    [labelBLESignal setText:@"BLE Signal:"];
    
    //Connect Button
    [buttonBLEConnectDisconnect setTitle:@"Disconnect from BLE Device" forState:UIControlStateNormal];
    [activityIndicatorBLE stopAnimating];
    [activityIndicatorBLE setHidesWhenStopped:YES];
    
    //Pulse Sensor Interface
    [swAnalogPinProperty setOn:YES animated:YES ];
    [self swAnalogPinMonitor:swAnalogPinProperty];
}

-(void) bleDidDisconnect{
    NSLog(@"bleDidDisconnect");
    
    //reset Pulse Sensor Display
    [self resetAllPulseSensorVariables];
    [self updateLabelsPulseSensorInterfaceElements];
    [progressBarPulseSensorSignal setProgress:0.00 animated:YES];
    [progressViewBLEsignal setProgress:0.0 animated:YES];
    [swAnalogPinProperty setOn:NO animated:YES ];
    [testLEDProperty setOn:NO animated:YES];
    
    
    [labelBLEMessageAndUUID setText:@"Disconnected from BLE Device "];
    [labelBLEName setText:@""];
    [labelBLESignal setText:@""];
    [activityIndicatorBLE stopAnimating];
    [activityIndicatorBLE setHidesWhenStopped:YES];
    [buttonBLEConnectDisconnect setTitle:@"Connect To BLE Device" forState:UIControlStateNormal];
    
    
    
    
}

-(void) bleDidUpdateRSSI:(NSNumber *)rssi{
    
    float rssiInFloat = [rssi floatValue];
    //  formula just to display a representive progress view to rssi value
    rssiInFloat = (rssiInFloat + 135) * .01 ;
    [progressViewBLEsignal setProgress:rssiInFloat animated:YES];
    
    //   NSLog(@"RSSI float %f", rssiInFloat);
}

-(void) bleDidReceiveData:(unsigned char *)data length:(int)length{
    for (int i = 0; i<length; i+=3) {
        
        if (data[i] == 0x0B) {
            UInt16 Value;
            Value = data[i+2] | data[i+1] << 8;
            
            //Pulse Sensor Interface
            [labelPulseSensorRawSignal setText:[NSString stringWithFormat:@"Pulse Signal: %d",Value]];
            //   NSLog(@"value is %d and float is %f", Value, Value*0.001 );
            
            PulseSensorValue = Value;
            
            globalSignal = PulseSensorValue;
            
            [self PulseSensorFullCode:PulseSensorValue];
            [progressBarPulseSensorSignal setProgress:Value*0.001 animated:NO];
            
            
            
        }
    }
    
    globalAlgoTrough = Trough;
    globalAlgoPeak = Peak;
    globalAlgoThreshold = Threshold;
    globalAlgoAmplitude = Amplitude;

}



/////////////////////////////////////
#pragma Functions Called by Timers
/////////////////////////////////////

-(void) connectionTimer: (NSTimer *)timer{
    
    if (readBearBLEinstance.peripherals.count >0)
    {
        
        //  REMOVE COMMENT TO CONNECT TO FIRST AVAILABLE DEVICE
        //  [readBearBLEinstance connectPeripheral:[readBearBLEinstance.peripherals objectAtIndex:0]];
        
        // THIS HARD-CODES UUID OF ONE RED BEAR BLE DEVICE
        
        
        
        for(int i = 0; i < readBearBLEinstance.peripherals.count; i++)
        {
            //////////////////////////////////////////////////////////
            //  PUT YOUR BLE SHEILD UUID HERE, Check DeBug Log Below For Available UUID's
            // example:  @"A1834B4A-CEF2-AD8B-A13F-20616683B36E";
            //////////////////////////////////////////////////////////
            
            myBlueSheildUUID = @"A1834B4A-CEF2-AD8B-A13F-20616683B36E";
            myUUIDA = [CBUUID UUIDWithString:myBlueSheildUUID];
            
            
            CBPeripheral *p = [readBearBLEinstance.peripherals objectAtIndex:i];
            NSMutableString * pUUIDString = [[NSMutableString alloc] initWithFormat:@"%@",CFUUIDCreateString(NULL, p.UUID) ];
            // Debug Line
            // NSLog(@"\n++++++\nLooking for your perfered Device UUID of: %@\n", myBlueSheildUUID);
            
            // Debug Line
            //NSLog(@" pUUIDString is: %@\n", pUUIDString);
            
            if ([myBlueSheildUUID isEqualToString:pUUIDString]) {
                NSLog(@"\n\n++++++   Found your Perfered Device UUID of: %@\n\n", myBlueSheildUUID);
                [readBearBLEinstance connectPeripheral:[readBearBLEinstance.peripherals objectAtIndex:i]];
                [ labelBLEMessageAndUUID setText:[NSString stringWithFormat:@"%s",[readBearBLEinstance UUIDToString:readBearBLEinstance.activePeripheral.UUID]]];
                
                
            }
            if (![myBlueSheildUUID isEqualToString:pUUIDString]) {
                NSLog(@"Found a Bluetooth Device, But doesn't match your UUID \n\n");
                [ labelBLEMessageAndUUID setText:[NSString stringWithFormat:@"Found Bluetooth Device, Doesn't ur coded UUID"]];
                
                
            }
            
            
        }
        
        
        
        
        
        
        
    }
    else
    {
        [labelBLEName setText:@""];
        [labelBLESignal setText:@""];
        
        if (counter <= 1){
            [labelBLEMessageAndUUID setText:@"No BLE Device found, Try To Connect Again"];
            //  [labelBLEMessageAndUUID setTextColor:[UIColor blueColor]];
            
        }
        if (counter > 1 ) {
            [labelBLEMessageAndUUID setText:@"Still No Luck, Try Power Cycling the BLE Device"];
            //  [labelBLEMessageAndUUID setTextColor:[UIColor redColor]];
            counter = 0;
        }
        
        counter = counter + 1;
        NSLog(@"counter= %i",counter);
        
        [buttonBLEConnectDisconnect setTitle:@"Connect to BLE Device" forState:UIControlStateNormal];
        [activityIndicatorBLE stopAnimating];
    }
}

-(void) pulseSensorReadingsResetTimer: (NSTimer*) timer {
    
    NSDate* lastBeatTime = beatQualifyArray[9];
    NSDate* timeNow = [NSDate date];
    NSDate* time7secondsEarlier = [timeNow dateByAddingTimeInterval:-7 ];
    
    if ([lastBeatTime isEqualToDate:[lastBeatTime earlierDate:time7secondsEarlier]]) {
        NSLog(@"lastBeatTime happened more then 7 seconds ago, reset PS Algo Vars");
        [self resetAllPulseSensorVariables];
        
    }
}



/////////////////////////////////////
#pragma Arduino Interface Elements
/////////////////////////////////////

- (IBAction)swTestLED:(id)sender {
    
    if(testLEDProperty.on){
        [self blinkLEDPin4ON];
        
    }  else {
        [self blinkLEDPin4OFF];
        
    }
    
}



/////////////////////////////////////
#pragma Pulse Sensor Interface Elements
/////////////////////////////////////

- (IBAction)swAnalogPinMonitor:(id)sender {
    UInt8 buf[3] = {0xA0, 0x00, 0x00};
    
    if (swAnalogPinProperty.on) {
        buf[1] = 0x01;
        [self resetAllPulseSensorVariables];
        
        [self updateLabelsPulseSensorInterfaceElements];
        
    }
    else if (!swAnalogPinProperty.on){
        buf[1] = 0x00;
        [self resetBeatsHappenedTimeStampedArray];
        [self resetAllPulseSensorVariables];
        [self updateLabelsPulseSensorInterfaceElements];
        
        //    [self resetPulseSensorAlgoVariables];
    }
    
    
    NSData *data = [[NSData alloc] initWithBytes:buf length:3];
    
    [readBearBLEinstance write:data];
}



/////////////////////////////////////
#pragma Pulse Sensor Algo Code
/////////////////////////////////////

- (void)PulseSensorFullCode: (int)PSValueToCalculate
{
    
    
    /// Find, set, keep Peak and Trough of Raw Pulse Sensor Signal
    
    Signal = PSValueToCalculate;
    
    if (Signal < Trough){                        // T is the trough
        Trough = Signal;                         // keep track of lowest point in pulse wave
    }
    
    
    if((Signal > Threshold && Signal > Peak) ){       // thresh condition helps avoid noise
        Peak = Signal;                             // P is the peak
    }                                              // keep track of highest point in pulse wave
    
    
    // new edge case
    if (Signal < Peak && Signal > Threshold) {
        Amplitude = Peak - Trough;                 //  get Amp of Pulse Wave
        Threshold = Amplitude/2 + Trough;       // set the Thresholdat 50% of Amp
        Peak = Threshold;                          //reset for next time
        Trough = Threshold;
        
    }
    
    // //  NOW IT'S TIME TO LOOK FOR THE HEART BEAT
    // signal surges up in value every time there is a pulse
    
    if ((Signal > Threshold) && (Pulse == false)) {
        
        [self qualifyBeat];
        
        if (RealQualifiedBeat) {
            Pulse = true;      // Pulse Happened, set the Pulse flag
            [self beatDetectedDoInterfaceStuff];
            [self calculateBPM];
        }
        
        
    }
    
    
    if (Signal < Threshold && Pulse == true) {
        
        //   if (Pulse == true) {
        
        [self blinkLEDPin4OFF];     // when the values are going down, the beat is over, turn off pin 13 LED
        [labelHeart setAlpha:0.2];
        
        globalBeatDidHappenBOOL = false;
        
        Pulse = false;                          // reset Pulse Flag
        Amplitude = Peak - Trough;                 //  get Amp of Pulse Wave
        Threshold = Amplitude/2 + Trough;       // set the Thresholdat 50% of Amp
        Peak = Threshold;                          //reset for next time
        Trough = Threshold;
    }
    
    
    
    // new edge case
    if (Signal > Threshold && Signal > Trough  && Pulse == true) {
        
        
        //      [self blinkLEDPin4OFF];     // when the values are going down, the beat is over, turn off pin 13 LED
        //      [labelHeart setAlpha:0.2];
        
        //      Pulse = false;                          // reset Pulse Flag
        //      Amplitude = Signal - Trough;  //NEW               //  get Amp of Pulse Wave
        //      Threshold = Amplitude/2 + Trough;       // set the Thresholdat 50% of Amp
        //    Peak = Threshold;                          //reset for next time
        //    Trough = Threshold;
    }
    
    
    
    
    
    
    [self updateLabelsPulseSensorInterfaceElements];
    
    
}

-(void) beatDetectedDoInterfaceStuff{
    
    [self blinkLEDPin4ON];

    globalBeatDidHappenBOOL = true;

    
    [labelHeart setAlpha:1.0];
    [labelHeart setTextColor:[UIColor redColor]];
    //[labelHeart setText:@"❤"];
    
}

-(void) qualifyBeat{
    
    static float timeBetweenBeats = 1.0;
    static float timeSinceLastBeat;
    beatQualifyArray[1]=[NSDate date];
    
    
    timeBetweenBeats = [beatQualifyArray[1] timeIntervalSinceDate:beatQualifyArray[0]];
    NSLog(@"timeBetweenBeats is = %f",timeBetweenBeats);
    
    //    if (timeBetweenBeats > timeSinceLastBeat+0.20  || timeBetweenBeats < timeSinceLastBeat-0.20 || timeBetweenBeats < 0.5 || timeBetweenBeats > 1.3) {
    if (timeBetweenBeats < 0.5 || timeBetweenBeats > 1.3) {
        RealQualifiedBeat = FALSE;
   //     globalBeatDidHappenBool = RealQualifiedBeat;
        NSLog(@"RealQualifiedBeat is FALSE");
    } else{
        RealQualifiedBeat = TRUE;
    //    globalBeatDidHappenBool = RealQualifiedBeat;

        NSLog(@"RealQualifiedBeat is TRUE");
        
    }
    timeSinceLastBeat = timeBetweenBeats;
    
    [beatQualifyArray replaceObjectAtIndex:0 withObject:beatQualifyArray[1]];
    //beatQualifyArray[0] = beatQualifyArray[1];
}

-(void) calculateBPM{
    float timeBetweenTenBeats;
    int BPM;
    int static lastBPM = 75;
    beatsSampleCounter++;
    
    NSLog(@"---Before Array Shift---");
    [self printArray];
    
    for (int i = 0; i <9; i++) {
        [beatsHappenedTimeStampedArray replaceObjectAtIndex:i withObject:beatsHappenedTimeStampedArray [i+1]];
    }
    
    NSLog(@"---After Array Shift---");
    [self printArray];
    
    beatsHappenedTimeStampedArray[9]=[NSDate date];
    
    NSLog(@"---Element 10 updated---");
    [self printArray];
    
    if (beatsSampleCounter > 9) {
        timeBetweenTenBeats = [beatsHappenedTimeStampedArray[9] timeIntervalSinceDate:beatsHappenedTimeStampedArray[0]];
        BPM = (60/timeBetweenTenBeats)*10;    //  (60/time of Last Ten Beats) x 10 = formual for BPM
        
        if (BPM > BPM+20 || BPM < BPM-20|| BPM > 160 || BPM < 54) {   //qualifies BPM for a grown-up
            [labelBPM setText:[NSString stringWithFormat:@"%i",BPM]];
            [labelBPM setTextColor:[UIColor lightGrayColor]];
            // [labelHeart setText:@"--"];
            [labelHeart setTextColor:[UIColor lightGrayColor]];
        } else{
            
            [labelBPM setTextColor:[UIColor redColor]];
            [labelBPM setText:[NSString stringWithFormat:@"%i",BPM]];
        }
        
    
        
        //globalBPM = BPM;
        globalBPM = BPM;
        
        lastBPM = BPM;
        
    } else if (beatsSampleCounter <= 9){
        [labelBPM setText:[NSString stringWithFormat:@"%i",beatsSampleCounter]];
        
    }
    
    // send Image Change method
  //  [self displayEmotionalImageFromBPM:BPM];
    
    
}

-(void) updateLabelsPulseSensorInterfaceElements{
    
    //  DEBUG
    //   NSLog(@"  Amp = %i,    Peak = %i,  Thresh = %i,  Signal = %i,  Trough = %i,  Pulse = %i  ", Amplitude, Peak,Threshold,Signal,Trough, Pulse);
    
    [labelAmplitude setText:[NSString stringWithFormat:@"Amp: %i",Amplitude]];
    [labelPeak setText:[NSString stringWithFormat:@"Peak: %i",Peak]];
    [labelThreshold setText:[NSString stringWithFormat:@"Thresh: %i",Threshold]];
    [labelTrough setText:[NSString stringWithFormat:@"Trough: %i",Trough]];
    
    // Progress Bars Update
    [ progressBarAmp setProgress: Amplitude*0.001 ];
    [progressBarPeak setProgress: Peak*0.001];
    [progressBarThreshold setProgress:Threshold * 0.001];
    [progressBarTrough setProgress:Trough * 0.001];
}

-(void) printArray{
    NSLog(@"%@",[NSString stringWithFormat:@"%@",beatsHappenedTimeStampedArray]);
}

-(void) resetAllPulseSensorVariables{
    
    Trough = 0;
    Threshold = 0;
    Peak = 0;
    Amplitude= 0;
}

-(void) resetPulseSensorAlgoVariables{
    
    Trough = 512;
    Peak = 512;
    Threshold = 512;
    Amplitude = 100;
    
}



/////////////////////////////////////
#pragma Arduino Pin Control
/////////////////////////////////////

-(void) blinkLEDPin4ON{
    UInt8 buf[3] = {0x01, 0x00, 0x00};
    
    buf[1] = 0x01;
    
    NSData *data = [[NSData alloc] initWithBytes:buf length:3];
    [readBearBLEinstance write:data];
}

-(void) blinkLEDPin4OFF{
    
    UInt8 buf[3] = {0x01, 0x00, 0x00};
    
    buf[1] = 0x00;
    
    NSData *data = [[NSData alloc] initWithBytes:buf length:3];
    [readBearBLEinstance  write:data];
}


-(void) displayEmotionalImageFromBPM:(int) bpm{
    
    NSLog(@" ❤❤❤   BPM: %i   ❤❤❤", bpm);
    
    if (bpm < 70 && bpm > 50) {
        [self displayImageWithName:@"1.png"];
    }
    if (bpm > 70 && bpm < 80) {
        [self displayImageWithName:@"2.png"];
    }
    if (bpm > 81 && bpm < 90) {
        [self displayImageWithName:@"3.png"];
    }
    if (bpm > 91 && bpm < 150) {
        [self displayImageWithName:@"4.png"];
    }
    if (bpm < 50 || bpm > 150) {
        [self displayImageWithName:@"remove"];
    }
    
}


- (void) displayImageWithName: (NSString*)name{
    
    
    if (![name isEqualToString:@"remove"]) {
        [_myImageView setImage:[UIImage imageNamed:name]];
        [self.view addSubview:_myImageView];
        NSLog(@"Image Updated");
    }
    
    if ([name isEqualToString:@"remove"]) {
        [_myImageView removeFromSuperview];
        NSLog(@"Image Removed");
    }
    
}







- (IBAction)swVisualizePushhed:(id)sender {
    if(_swVisualize.on){

        // launch Visualization
        NSLog(@"launch Vis");
        
//        // Configure the view.
        SKView * skView = (SKView *)self.view;
        skView.showsFPS = YES;
//        skView.showsNodeCount = YES;
        
        // Create and configure the scene.
//        SKScene * scene = [MyScene sceneWithSize:skView.bounds.size];
//        scene.scaleMode = SKSceneScaleModeAspectFill;
    //    ((MyScene *)scene).delegate = self;
        
        
        
        // Present the scene.
   //     [skView presentScene:scene];
        
        
    }  else {
        
        //  remove Visualization
        
    }

    
}



-(void) myScene:(MyScene *)myScene didGenerateString:(NSString *)string{
    NSLog(@" %@ send the string: %@", myScene, string);
    
}





@end
