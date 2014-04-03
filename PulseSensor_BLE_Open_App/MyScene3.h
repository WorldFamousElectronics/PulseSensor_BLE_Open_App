//
//  MyScene3.h
//  PulseSensor_BLE_Open_App
//
//  Created by GrownYoda on 4/1/14.
//  Copyright (c) 2014 YuryGitman. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

@interface MyScene3 : SKScene{

SKLabelNode *myLabel;
SKLabelNode *bullet;
SKLabelNode *labelBPM;


///  dotShape
SKSpriteNode *dotShape;
SKSpriteNode *dotShape2;
//    SKAction * _bulletAction;

float _bulletInterval;
CFTimeInterval _lastUpdateTime;
NSTimeInterval _dt;

//  Particles
SKEmitterNode *emitterNode;
}

@end
