//
//  GameViewController.h
//  KerhMan
//
//  Created by Frederik Riedel on 04/11/2016.
//  Copyright © 2016 Frogg GmbH. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <SpriteKit/SpriteKit.h>
#import <GameplayKit/GameplayKit.h>
#import "MapScene.h"
@import SceneKit;

typedef enum {
    DrivingDirectionForward,
    DrivingDirectionLeft,
    DrivingDirectionRight
} DrivingDirection;


@interface GameViewController : UIViewController
@property (strong, nonatomic) IBOutlet SKView *skview;
@property (strong, nonatomic) IBOutlet SCNView *sceneKitView;
@property (strong, nonatomic) IBOutlet UIImageView *gameCharacter;
@property MapScene* mapScene;
@property DrivingDirection drivingDirection;
@property double vehicleSteeringDirection;
@property double vehicleSpeed;
@property NSString* driverName;
@property DrivingDirection lastDrivingDirection;


@end
