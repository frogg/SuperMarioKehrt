//
//  GameViewController.m
//  KerhMan
//
//  Created by Frederik Riedel on 04/11/2016.
//  Copyright © 2016 Frogg GmbH. All rights reserved.
//

#import "GameViewController.h"
#import "GameScene.h"

@implementation GameViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
}

-(void)viewWillAppear:(BOOL)animated {
    self.drivingDirection = DrivingDirectionForward;
    
    GameScene* gameScene = [[GameScene alloc] initWithSize:self.skview.frame.size];
    
    [self.skview presentScene: gameScene];
    
    self.gameCharacter.layer.magnificationFilter = kCAFilterNearest;
    
    
    self.mapScene = [[MapScene alloc] init];
    
    
    
    self.sceneKitView.scene = self.mapScene;
    
    
    //self.sceneKitView.allowsCameraControl = YES;
    
    
    
    [NSTimer scheduledTimerWithTimeInterval:animationLength repeats:YES block:^(NSTimer * _Nonnull timer) {
        if(self.drivingDirection == DrivingDirectionRight) {
            self.gameCharacter.image = [UIImage imageNamed:@"mario_right"];
            [gameScene moveRight];
            [self.mapScene moveRight];
            [self.mapScene moveForward];
        } else if(self.drivingDirection == DrivingDirectionLeft) {
            self.gameCharacter.image = [UIImage imageNamed:@"mario_left"];
            [gameScene moveLeft];
            [self.mapScene moveLeft];
            [self.mapScene moveForward];
        } else if(self.drivingDirection == DrivingDirectionForward) {
            self.gameCharacter.image = [UIImage imageNamed:@"mario_back"];
            [self.mapScene moveForward];
        }
    }];
    
    
    
    
    [NSTimer scheduledTimerWithTimeInterval:1 repeats:YES block:^(NSTimer * _Nonnull timer) {
        
        NSLog(@"Camera: %f, %f, %f, %f",self.mapScene.cameraNode.rotation.x,self.mapScene.cameraNode.rotation.y,self.mapScene.cameraNode.rotation.z,self.mapScene.cameraNode.rotation.w);
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
