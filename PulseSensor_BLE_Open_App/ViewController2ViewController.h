//
//  ViewController2ViewController.h
//  PulseSensor_BLE_Open_App
//
//  Created by GrownYoda on 3/22/14.
//  Copyright (c) 2014 YuryGitman. All rights reserved.
//

#import "ViewController.h"

#import <SpriteKit/SpriteKit.h>

#import "MyScene.h"
#import "MyScene2.h"
#import "MyScene3.h"
#import "InheritedMyScene.h"


@interface ViewController2ViewController : ViewController
@property (weak, nonatomic) IBOutlet UIButton *buttonPressed;
- (IBAction)buttonAction:(id)sender;

//Button To Move through Scenes
@property (weak, nonatomic) IBOutlet UIButton *buttonVisualizations;
- (IBAction)buttonVizPressed:(id)sender;

@end
