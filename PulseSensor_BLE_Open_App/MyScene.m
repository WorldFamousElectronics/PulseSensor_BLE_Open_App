//
//  MyScene.m
//  PulseSensor_BLE_Open_App
//
//  Created by GrownYoda on 3/22/14.
//  Copyright (c) 2014 YuryGitman. All rights reserved.
//

#import "MyScene.h"

extern int globalBPM;
extern int globalSignal;
extern BOOL globalBeatDidHappenBOOL;
extern int globalAlgoTrough;
extern int globalAlgoPeak;
extern int globalAlgoThreshold;
extern int globalAlgoAmplitude;



@implementation MyScene{

    SKLabelNode *myLabel;
    SKLabelNode *bullet;
    SKLabelNode* labelBPM;
    
    
    ///  dotShape
    SKSpriteNode *dotShape;
        SKSpriteNode *dotShape2;
            SKSpriteNode *flatLine1;
            SKSpriteNode *flatLine2;
            SKSpriteNode *flatLine3;
    
//    SKAction * _bulletAction;
    
    float _bulletInterval;
    CFTimeInterval _lastUpdateTime;
    NSTimeInterval _dt;
    
    
}

-(id)initWithSize:(CGSize)size {
    if (self = [super initWithSize:size]) {
        /* Setup your scene here */
        
        self.physicsWorld.gravity = CGVectorMake(-4.8, 0.0);
        self.backgroundColor = [SKColor whiteColor];
        
        myLabel = [SKLabelNode labelNodeWithFontNamed:@"Arial"];
        myLabel.text = [NSString stringWithFormat:@"Signal: %i    Qualified Beat Happened: %i     BPM: %i", globalSignal,globalBeatDidHappenBOOL, globalBPM];
        
        myLabel.fontSize = 12;
        myLabel.position = CGPointMake(20,
                                       30);
        myLabel.fontColor = [UIColor blackColor];
        
        myLabel.horizontalAlignmentMode= SKLabelHorizontalAlignmentModeLeft;
        
        [self addChild:myLabel];
        [self setupLabelBPM];
    }
    return self;
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    /* Called when a touch begins */
    
    [self.delegate myScene:self didGenerateString:@"string from myScene"];
    
    NSLog(@"Pressed Button in Scene");
    
}

-(void)update:(CFTimeInterval)currentTime {
    /* Called before each frame is rendered */


    myLabel.text = [NSString stringWithFormat:@"Signal: %i    Qualified Beat Happened: %i     BPM: %i", globalSignal,globalBeatDidHappenBOOL, globalBPM];
    [labelBPM setText:[NSString stringWithFormat:@"%i",globalBPM]];
    
    
    if (_lastUpdateTime) {
        _dt = currentTime - _lastUpdateTime;
    } else{
        _dt = 0;
    }
    
    _lastUpdateTime = currentTime;
    _bulletInterval += _dt;
    if (_bulletInterval > 0.010) {
        _bulletInterval = 0;
        
        if (globalBeatDidHappenBOOL) {
           // [labelBPM setFontColor:[UIColor purpleColor]];
            labelBPM.fontSize = 75;
        } else{
           // [labelBPM setFontColor:[UIColor redColor]];
            labelBPM.fontSize = 70;

        }
        [self makeDots];
    
        
        
      //     [self makeAlgoGraphic1];

    }


    
    
    
}


-(void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event{
    
    for (UITouch *touch in touches) {
        CGPoint location = [touch locationInNode:self];
        dotShape.position = location;
        dotShape2.position = location;
        flatLine1.position  = CGPointMake(location.x, location.y  + 50);
        
        }

    
}

-(void)  makeDots{
    

    
    dotShape = [SKSpriteNode spriteNodeWithColor:[SKColor redColor] size:CGSizeMake(1, 70)];

  
    dotShape.position = CGPointMake(self.frame.size.width/2+100, 100 + globalSignal/2.8);

    
    SKAction* dotsLeftMove = [SKAction sequence:@[[SKAction moveToX:-5 duration:1.0],
                                         [SKAction removeFromParent]]];
    [dotShape runAction:dotsLeftMove];
    [self addChild:dotShape];

    
//    dotShape2 = [SKSpriteNode spriteNodeWithColor:[SKColor redColor] size:CGSizeMake(7, 7)];
//    dotShape2.position = CGPointMake(self.frame.size.width/2+100, 100 + globalSignal/2.8);
//    [dotShape2 runAction:dotsLeftMove];
//    
//    [self addChild:dotShape2];

    }

#pragma On-Screen BPM Code
-(void) setupLabelBPM{
    
    labelBPM = [SKLabelNode labelNodeWithFontNamed:@"Arial"];
    labelBPM.text = [NSString stringWithFormat:@"BPM: %i", globalBPM];
    labelBPM.fontSize = 70;
    labelBPM.position = CGPointMake(self.frame.size.width/2,
                                    self.frame.size.height/6 + self.frame.size.height/2);
    labelBPM.fontColor = [UIColor redColor];
    labelBPM.horizontalAlignmentMode= SKLabelHorizontalAlignmentModeCenter;
    [self addChild:labelBPM];
    
    
}


#pragma Scrolling Visualizer Code
-(void) makeAlgoGraphic1{
    
    flatLine1 = [SKSpriteNode spriteNodeWithColor:[SKColor redColor] size:CGSizeMake(7, 7)];
    flatLine1.position = CGPointMake(self.frame.size.width/2+100, 100 + globalAlgoPeak/2.8);
    SKAction* lineLeftMove = [SKAction sequence:@[[SKAction moveToX:-5 duration:1.0],
                                                  [SKAction removeFromParent]]];
    [flatLine1 runAction:lineLeftMove];
    [self addChild:flatLine1];

    
    flatLine2 = [SKSpriteNode spriteNodeWithColor:[SKColor yellowColor] size:CGSizeMake(2, 2)];
    flatLine2.position = CGPointMake(self.frame.size.width/2+100, 100 + globalAlgoThreshold/2.8);
    SKAction* lineLeftMove2 = [SKAction sequence:@[[SKAction moveToX:-5 duration:1.0],
                                                  [SKAction removeFromParent]]];
    [flatLine2 runAction:lineLeftMove2];
    [self addChild:flatLine2];

    
    flatLine3 = [SKSpriteNode spriteNodeWithColor:[SKColor blackColor] size:CGSizeMake(7, 7)];
    flatLine3.position = CGPointMake(self.frame.size.width/2+100, 100 + globalAlgoTrough/2.8);
    SKAction* lineLeftMove3 = [SKAction sequence:@[[SKAction moveToX:-5 duration:1.0],
                                                   [SKAction removeFromParent]]];
    [flatLine3 runAction:lineLeftMove3];
    [self addChild:flatLine3];

    
    
}











@end