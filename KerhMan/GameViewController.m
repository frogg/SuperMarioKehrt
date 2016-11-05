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
#import "AMGSoundManager.h"
#import "AMGAudioPlayer.h"
@implementation GameViewController




- (void)viewDidLoad {
    [super viewDidLoad];
    self.vehicleSpeed = 1;
    
}

-(void)viewWillAppear:(BOOL)animated {
    self.drivingDirection = DrivingDirectionForward;
    
    GameScene* gameScene = [[GameScene alloc] initWithSize:self.skview.frame.size];
    
    [self.skview presentScene: gameScene];
    
    self.gameCharacter.layer.magnificationFilter = kCAFilterNearest;
    
    
    self.mapScene = [[MapScene alloc] init];
    
    
    
    self.sceneKitView.scene = self.mapScene;
    
    
//    AMGSoundManager* soundManager = [AMGSoundManager sharedManager];
//    [soundManager playAudio:[[NSBundle mainBundle] pathForResource:@"driving" ofType:@"mp3"] withName:@"driving" inLine:@"driving" withVolume:1 andRepeatCount:-1 fadeDuration:0.5 withCompletitionHandler:nil];
//    
//    [NSTimer scheduledTimerWithTimeInterval:7 repeats:YES block:^(NSTimer * _Nonnull timer) {
//        [soundManager setVolume:0.3 forLine:@"driving" withFadeDuration:1];
//        [soundManager playAudio: [[NSBundle mainBundle] pathForResource:@"drifting" ofType:@"mp3"] withName:@"drifting" inLine:@"drifting" withVolume:0.8 andRepeatCount:0 fadeDuration:0.2 withCompletitionHandler:^(BOOL success, BOOL stopped) {
//        }];
//        [soundManager setVolume:1 forLine:@"driving" withFadeDuration:5];
//
//    }];
    
    
    //self.sceneKitView.allowsCameraControl = YES;
    
    
    
    [NSTimer scheduledTimerWithTimeInterval:animationLength repeats:YES block:^(NSTimer * _Nonnull timer) {
        if(self.drivingDirection == DrivingDirectionRight) {
            self.gameCharacter.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@_right",self.driverName]];
            [gameScene moveRight];
            [self.mapScene moveRight];
            [self.mapScene moveForwardWithSpeed:self.vehicleSpeed / 1.5];
        } else if(self.drivingDirection == DrivingDirectionLeft) {
            self.gameCharacter.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@_left",self.driverName]];
            [gameScene moveLeft];
            [self.mapScene moveLeft];
            [self.mapScene moveForwardWithSpeed: self.vehicleSpeed / 1.5];
        } else if(self.drivingDirection == DrivingDirectionForward) {
            self.gameCharacter.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@_back",self.driverName]];
            [self.mapScene moveForwardWithSpeed:self.vehicleSpeed];
        }
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
