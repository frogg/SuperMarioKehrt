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
@property DrivingDirection drivingDirection;

@end
