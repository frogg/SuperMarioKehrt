//
//  GameViewController.m
//  KerhMan
//
//  Created by Frederik Riedel on 04/11/2016.
//  Copyright © 2016 Frogg GmbH. All rights reserved.
//

#import "GameViewController.h"
#import "GameScene.h"
#import "MapScene.h"

@implementation GameViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
}

-(void)viewWillAppear:(BOOL)animated {
    self.drivingDirection = DrivingDirectionForward;
    
    GameScene* gameScene = [[GameScene alloc] initWithSize:self.skview.frame.size];

    [self.skview presentScene: gameScene];
    
    self.gameCharacter.layer.magnificationFilter = kCAFilterNearest;
    
    
    MapScene* mapScene = [[MapScene alloc] init];
    
    
    self.sceneKitView.scene = mapScene;
    
    
    self.sceneKitView.allowsCameraControl = YES;
    
    
    
    [NSTimer scheduledTimerWithTimeInterval:0.5f repeats:YES block:^(NSTimer * _Nonnull timer) {
        if(self.drivingDirection == DrivingDirectionRight) {
            self.gameCharacter.image = [UIImage imageNamed:@"mario_right"];
            [gameScene moveRight];
            [mapScene moveRight];
            [mapScene moveForward];
        } else if(self.drivingDirection == DrivingDirectionLeft) {
            self.gameCharacter.image = [UIImage imageNamed:@"mario_left"];
            [gameScene moveLeft];
            [mapScene moveLeft];
            [mapScene moveForward];
        } else {
            self.gameCharacter.image = [UIImage imageNamed:@"mario_back"];
            [mapScene moveForward];
        }
        
    }];
    
    
    
    
    [NSTimer scheduledTimerWithTimeInterval:1 repeats:YES block:^(NSTimer * _Nonnull timer) {
        [mapScene moveForward];
        NSLog(@"Camera: %f, %f, %f, %f",mapScene.cameraNode.rotation.x,mapScene.cameraNode.rotation.y,mapScene.cameraNode.rotation.z,mapScene.cameraNode.rotation.w);
    }];
    
    
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    UITouch* touch = [touches anyObject];
    
    CGPoint touchPoint = [touch locationInView:self.view];
    
    if(touchPoint.x < self.view.frame.size.width / 3.f) {
        self.drivingDirection = DrivingDirectionLeft;
    } else if(touchPoint.x < self.view.frame.size.width * (2.f/3.f)) {
        self.drivingDirection = DrivingDirectionForward;
    } else if(touchPoint.x > self.view.frame.size.width * (2.f/3.f)){
        self.drivingDirection = DrivingDirectionRight;
    }
}


- (BOOL)shouldAutorotate {
    return YES;
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        return UIInterfaceOrientationMaskAllButUpsideDown;
    } else {
        return UIInterfaceOrientationMaskAll;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}

- (BOOL)prefersStatusBarHidden {
    return YES;
}

@end
