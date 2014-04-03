//
//  MyScene.h
//  PulseSensor_BLE_Open_App
//
//  Created by GrownYoda on 3/22/14.
//  Copyright (c) 2014 YuryGitman. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>
//#import <UIKit/UIKit.h>


@protocol MySceneDelegate;


@interface MyScene : SKScene

@property (weak) id<MySceneDelegate> delegate;

@end


@protocol MySceneDelegate <NSObject>

-(void) myScene:(MyScene*)myScene didGenerateString:(NSString*) string;



@end