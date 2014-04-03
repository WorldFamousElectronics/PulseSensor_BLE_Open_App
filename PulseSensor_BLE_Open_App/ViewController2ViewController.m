//
//  ViewController2ViewController.m
//  PulseSensor_BLE_Open_App
//
//  Created by GrownYoda on 3/22/14.
//  Copyright (c) 2014 YuryGitman. All rights reserved.
//

#import "ViewController2ViewController.h"

@interface ViewController2ViewController ()

@end

@implementation ViewController2ViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        
        [ _buttonVisualizations setTitle:@"Visualization I" forState:UIControlStateNormal];
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    NSLog(@"second viewdidload");
   
    [_buttonVisualizations setSelected:YES];
    [_buttonVisualizations setEnabled:YES];
    [self makeFirstScene];



    
    
    
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)buttonVizPressed:(id)sender {
    
    static int counter =1;
    
    if (counter == 0) {
        [self makeFirstScene];
         }
    
    if (counter == 1) {
        
   
        [self makeMyScene];
        
        [ _buttonVisualizations setTitle:@"Visualization I" forState:UIControlStateNormal];
        
      //   counter++;
    }
    
    if (counter == 2) {
        [ _buttonVisualizations setTitle:@"Visualization II" forState:UIControlStateNormal];
        
        
        NSLog(@"second viewdidload");
        
        // Configure the view.
        SKView * skView = (SKView *)self.view;
        skView.showsFPS = YES;
        skView.showsNodeCount = YES;
        
        // Create and configure the scene.
        SKScene * scene = [MyScene2 sceneWithSize:skView.bounds.size];
        scene.scaleMode = SKSceneScaleModeAspectFill;
        
        // Present the scene.
        [skView presentScene:scene];
        
    // counter++;
    }
    
    if (counter == 3) {
        
        // Configure the view.
        SKView * skView = (SKView *)self.view;
        skView.showsFPS = YES;
        skView.showsNodeCount = YES;
        
        // Create and configure the scene.
        SKScene * scene = [MyScene3 sceneWithSize:skView.bounds.size];
        scene.scaleMode = SKSceneScaleModeAspectFill;
        
        // Present the scene.
        [skView presentScene:scene];
       
        [ _buttonVisualizations setTitle:@"Visualization III" forState:UIControlStateNormal];

        counter = -1.0;
    }

    if (counter > 3) {
        counter = -1.0;
        
    }

    
    counter++;
    
}


-(void) makeFirstScene{
    [ _buttonVisualizations setTitle:@"Visualization 0" forState:UIControlStateNormal];
    
    
    NSLog(@"second viewdidload");
    
    // Configure the view.
    SKView * skView = (SKView *)self.view;
    skView.showsFPS = YES;
    skView.showsNodeCount = YES;
    
    // Create and configure the scene.
    SKScene * scene = [InheritedMyScene sceneWithSize:skView.bounds.size];
    scene.scaleMode = SKSceneScaleModeAspectFill;
    
    // Present the scene.
    [skView presentScene:scene];

    
}

-(void) makeMyScene{
    // Configure the view.
    SKView * skView = (SKView *)self.view;
    skView.showsFPS = YES;
    skView.showsNodeCount = YES;
    
    // Create and configure the scene.
    SKScene * scene = [MyScene sceneWithSize:skView.bounds.size];
    scene.scaleMode = SKSceneScaleModeAspectFill;
    
    // Present the scene.
    [skView presentScene:scene];
    
}

@end
