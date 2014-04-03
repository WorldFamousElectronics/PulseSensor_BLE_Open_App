//
//  MyScene3.m
//  PulseSensor_BLE_Open_App
//
//  Created by GrownYoda on 4/1/14.
//  Copyright (c) 2014 YuryGitman. All rights reserved.
//

#import "MyScene3.h"
extern int globalBPM;
extern int globalSignal;
extern BOOL globalBeatDidHappenBOOL;


@implementation MyScene3


-(void) setupLabels{
    
    [ self setupDebugLabels];
    [self setupBPMLabel];
    
    myLabel = [SKLabelNode labelNodeWithFontNamed:@"Arial"];
    myLabel.text = [NSString stringWithFormat:@"Signal: %i    Qualified Beat Happened: %i     BPM: %i", globalSignal,globalBeatDidHappenBOOL, globalBPM];
    myLabel.fontSize = 12;
    myLabel.position = CGPointMake(20,
                                   30);
    myLabel.fontColor = [UIColor blackColor];
    myLabel.horizontalAlignmentMode= SKLabelHorizontalAlignmentModeLeft;
    [self addChild:myLabel];
    
    

}


-(id)initWithSize:(CGSize)size {
    if (self = [super initWithSize:size]) {
        /* Setup your scene here */
        
        self.physicsWorld.gravity = CGVectorMake(-4.8, 0.0);
        
        self.backgroundColor = [SKColor whiteColor];
        
        
        [self setupLabels];
            }
    return self;
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    /* Called when a touch begins */
    
    //  [self.delegate myScene:self didGenerateString:@"string from myScene"];
    
    NSLog(@"Pressed Button in Scene");
    [self addBurst];
    
    
}

-(void)update:(CFTimeInterval)currentTime {
    /* Called before each frame is rendered */
    
    if (globalBeatDidHappenBOOL) {
        NSLog(@"beating Happened");
        [self addBurst];
    }
    
    
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
  
        
//        [self addBurst];
    
    
    }
    
    

    
    
    
    
}

-(void) addBurst{
    
    emitterNode = [NSKeyedUnarchiver unarchiveObjectWithFile:[[NSBundle mainBundle]pathForResource:@"BeatParticles" ofType:@"sks"]];
  
  //  emitterNode.position = CGPointMake(self.frame.size.width/2, self.frame.size.height - 200);
    
    emitterNode.position = CGPointMake(self.frame.size.width/2+100, 40 + globalSignal/3.5);
    
    
    SKAction* dotsLeftMove = [SKAction sequence:@[[SKAction moveToX:-5 duration:1.0],
                                                  [SKAction removeFromParent]]];
    [emitterNode runAction:dotsLeftMove];

    
    [self addChild:emitterNode];
}

-(void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event{
    
    
    [self addBurst];
    
    
    for (UITouch *touch in touches) {
        CGPoint location = [touch locationInNode:self];
        emitterNode.position = location;
        emitterNode.position = location;
        
    }
    
    
}

-(void)  makeDots{
    
    
    
    dotShape = [SKSpriteNode spriteNodeWithColor:[SKColor grayColor] size:CGSizeMake(1, 70)];
    
    
//    dotShape.position = CGPointMake(self.frame.size.width/2+100, 100 + globalSignal/2.8);
    dotShape.position = CGPointMake(self.frame.size.width/2+100, 40 + globalSignal/3.5);
    
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

-(void) setupDebugLabels{
    myLabel = [SKLabelNode labelNodeWithFontNamed:@"Arial"];
    myLabel.text = [NSString stringWithFormat:@"Signal: %i    Qualified Beat Happened: %i     BPM: %i", globalSignal,globalBeatDidHappenBOOL, globalBPM];
    myLabel.fontSize = 12;
    myLabel.position = CGPointMake(20,
                                   30);
    myLabel.fontColor = [UIColor blackColor];
    myLabel.horizontalAlignmentMode= SKLabelHorizontalAlignmentModeLeft;
    [self addChild:myLabel];
}


-(void) setupBPMLabel{
    
    
    
}


@end
