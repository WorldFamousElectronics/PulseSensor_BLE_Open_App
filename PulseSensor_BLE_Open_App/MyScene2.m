//
//  MyScene2.m
//  PulseSensor_BLE_Open_App
//
//  Created by GrownYoda on 4/1/14.
//  Copyright (c) 2014 YuryGitman. All rights reserved.
//

#import "MyScene2.h"

extern int globalBPM;
extern int globalSignal;
extern BOOL globalBeatDidHappenBOOL;
extern int globalAlgoTrough;
extern int globalAlgoPeak;
extern int globalAlgoThreshold;
extern int globalAlgoAmplitude;



@implementation MyScene2{

SKLabelNode *myLabel;
SKLabelNode *bullet;


///  dotShape
SKSpriteNode *dotShape;
SKSpriteNode *dotShape2;
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
    }
    return self;
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    /* Called when a touch begins */
    
  //  [self.delegate myScene:self didGenerateString:@"string from myScene"];
    
    NSLog(@"Pressed Button in Scene");
    
}

-(void)update:(CFTimeInterval)currentTime {
    /* Called before each frame is rendered */
    
    
    myLabel.text = [NSString stringWithFormat:@"Signal: %i    Qualified Beat Happened: %i     BPM: %i", globalSignal,globalBeatDidHappenBOOL, globalBPM];
    
    
    if (_lastUpdateTime) {
        _dt = currentTime - _lastUpdateTime;
    } else{
        _dt = 0;
    }
    
    _lastUpdateTime = currentTime;
    _bulletInterval += _dt;
    if (_bulletInterval > 0.010) {
        _bulletInterval = 0;
        
        [self makeDots];
        
    }
    
    
    
    
    
}


-(void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event{
    
    for (UITouch *touch in touches) {
        CGPoint location = [touch locationInNode:self];
        dotShape.position = location;
        dotShape2.position = location;
        
    }
    
    
}

-(void)  makeDots{
    
    
    
    dotShape = [SKSpriteNode spriteNodeWithColor:[SKColor orangeColor] size:CGSizeMake(7, 70)];
    
    
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



@end
