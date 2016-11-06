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
    self.vehicleSpeed = 0;
    
    AMGSoundManager* soundManager = [AMGSoundManager sharedManager];
    [soundManager playAudio:[[NSBundle mainBundle] pathForResource:@"driving-theme" ofType:@"mp3"] withName:@"driving-theme" inLine:@"music" withVolume:1 andRepeatCount:0 fadeDuration:0 withCompletitionHandler:nil];
    
    self.ampelmaennchen.layer.magnificationFilter = kCAFilterNearest;
    [self startAmpelmaennchen];
    
    self.motionManager = [[CMMotionManager alloc] init];
    
    
    
    [self.motionManager setDeviceMotionUpdateInterval:animationLength / 2.f];
    
    [self.motionManager startDeviceMotionUpdatesUsingReferenceFrame:CMAttitudeReferenceFrameXArbitraryZVertical
                                                            toQueue:[NSOperationQueue mainQueue]
                                                        withHandler:^(CMDeviceMotion *motion, NSError *error)
     {
         self.vehicleSteeringAngel = motion.gravity.y;
         CGFloat x = motion.gravity.x;
         CGFloat y = motion.gravity.y;
         CGFloat z = motion.gravity.z;
     }];
    
    
}

-(void) startAmpelmaennchen {
    [NSTimer scheduledTimerWithTimeInterval:1 repeats:NO block:^(NSTimer * _Nonnull timer) {
        self.ampelmaennchen.image = [UIImage imageNamed:@"ampel_1"];
        [NSTimer scheduledTimerWithTimeInterval:1 repeats:NO block:^(NSTimer * _Nonnull timer) {
            self.ampelmaennchen.image = [UIImage imageNamed:@"ampel_2"];
            [NSTimer scheduledTimerWithTimeInterval:1 repeats:NO block:^(NSTimer * _Nonnull timer) {
                self.ampelmaennchen.image = [UIImage imageNamed:@"ampel_3"];
                
                [UIView animateWithDuration:1 animations:^{
                    self.ampelmaennchen.alpha = 0;
                }];
                
                self.vehicleSpeed = 1;
            }];
        }];
    }];
}


-(void)viewWillAppear:(BOOL)animated {
    
    
    GameScene* gameScene = [[GameScene alloc] initWithSize:self.skview.frame.size];
    
    [self.skview presentScene: gameScene];
    
    self.gameCharacter.layer.magnificationFilter = kCAFilterNearest;
    
    
    self.mapScene = [[MapScene alloc] init];
    
    
    
    self.sceneKitView.scene = self.mapScene;
    
    
    AMGSoundManager* _soundManager = [AMGSoundManager sharedManager];
    [_soundManager playAudio:[[NSBundle mainBundle] pathForResource:@"driving" ofType:@"mp3"] withName:@"driving" inLine:@"driving" withVolume:1 andRepeatCount:-1 fadeDuration:0 withCompletitionHandler:nil];
    
    
    
    [NSTimer scheduledTimerWithTimeInterval:animationLength repeats:YES block:^(NSTimer * _Nonnull timer) {
        AMGSoundManager* soundManager = [AMGSoundManager sharedManager];
        
        if([self currentDrivingDirection] == DrivingDirectionLeft) {
            [gameScene moveLeft];
            self.gameCharacter.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@_left",self.driverName]];
            [self.mapScene steerWithSteeringAnghel:self.vehicleSteeringAngel];
            [self.mapScene moveForwardWithSpeed:self.vehicleSpeed / 1.5];
            
        } else if([self currentDrivingDirection] == DrivingDirectionRight) {
            [gameScene moveRight];
            self.gameCharacter.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@_right",self.driverName]];
            [self.mapScene steerWithSteeringAnghel:self.vehicleSteeringAngel];
            [self.mapScene moveForwardWithSpeed: self.vehicleSpeed / 1.5];
            
        } else if([self currentDrivingDirection] == DrivingDirectionForward) {
            self.gameCharacter.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@_back",self.driverName]];
            [self.mapScene moveForwardWithSpeed:self.vehicleSpeed];
        }
        
        
        if ([self currentDrivingDirection] != DrivingDirectionForward && ![soundManager isAudioPlayingInLine:@"drifting"] && [self currentDrivingDirection] != self.lastDrivingDirection) {
            [soundManager playAudio:[[NSBundle mainBundle] pathForResource:@"drifting" ofType:@"mp3"] withName:@"right" inLine:@"drifting" withVolume:1 andRepeatCount:0 fadeDuration:0 withCompletitionHandler:nil];
            [soundManager setVolume:0.3 forLine:@"driving" withFadeDuration:1];
            [NSTimer scheduledTimerWithTimeInterval:2 repeats:NO block:^(NSTimer * _Nonnull timer) {
                [soundManager setVolume:1 forLine:@"driving" withFadeDuration:1];
            }];
        }
        self.lastDrivingDirection = [self currentDrivingDirection];
    }];
    
    
    
}


-(DrivingDirection) currentDrivingDirection {
    
    if(self.vehicleSteeringAngel > 0.25) {
        return DrivingDirectionLeft;
    } else if(self.vehicleSteeringAngel < -0.25) {
        return DrivingDirectionRight;
    }
    
    return DrivingDirectionForward;
    
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    UITouch* touch = [touches anyObject];
    
    CGPoint touchPoint = [touch locationInView:self.view];
    
    if(touchPoint.x < self.view.frame.size.width / 2.f) {
        self.vehicleSteeringAngel = ((self.view.frame.size.width/2)-(touchPoint.x)) / (self.view.frame.size.width/2);
    } else {
        self.vehicleSteeringAngel = -(touchPoint.x-(self.view.frame.size.width/2)) / (self.view.frame.size.width/2);
    }
    
    NSLog(@"%f",self.vehicleSteeringAngel);
}


- (BOOL)shouldAutorotate {
    return YES;
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
        return UIInterfaceOrientationMaskLandscape;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}

- (BOOL)prefersStatusBarHidden {
    return YES;
}



@end
