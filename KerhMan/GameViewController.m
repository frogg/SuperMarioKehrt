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

@import CoreGraphics;


#define RADIANS(degrees) ((degrees * M_PI) / 180.0)



@implementation GameViewController




- (void)viewDidLoad {
    [super viewDidLoad];
    self.vehicleSpeed = 0;
    
    AMGSoundManager* soundManager = [AMGSoundManager sharedManager];
    [soundManager playAudio:[[NSBundle mainBundle] pathForResource:@"driving-theme" ofType:@"mp3"] withName:@"driving-theme" inLine:@"music" withVolume:0.8 andRepeatCount:-1 fadeDuration:0 withCompletitionHandler:nil];
    
    self.ampelmaennchen.layer.magnificationFilter = kCAFilterNearest;
    [self startAmpelmaennchen];
    
    self.motionManager = [[CMMotionManager alloc] init];
    
    
    
    [self.motionManager setDeviceMotionUpdateInterval:animationLength / 2.f];
    
    [self.motionManager startDeviceMotionUpdatesUsingReferenceFrame:CMAttitudeReferenceFrameXArbitraryZVertical
                                                            toQueue:[NSOperationQueue mainQueue]
                                                        withHandler:^(CMDeviceMotion *motion, NSError *error)
     {
         if(!useMachineInput) {
             self.vehicleSteeringAngel = motion.gravity.y;
         }
     }];
    
    [Kehrmaschine shared].delegate = self;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(wallWarning) name:@"WallWarning" object:nil];
    
}

-(void) wallWarning {
    self.wallWarningLabel.alpha = 1;
    
    [NSTimer scheduledTimerWithTimeInterval:3 repeats:NO block:^(NSTimer * _Nonnull timer) {
        
        [UIView animateWithDuration:1 animations:^{
            self.wallWarningLabel.alpha=0;
        }];
        
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
                
                if(!useMachineInput) {
                    self.vehicleSpeed = 1;
                }
            }];
        }];
    }];
}


-(void)viewWillAppear:(BOOL)animated {
    
    
    self.gameScene = [[GameScene alloc] initWithSize:self.skview.frame.size];
    
    [self.skview presentScene: self.gameScene];
    
    self.gameCharacter.layer.magnificationFilter = kCAFilterNearest;
    
    
    self.mapScene = [[MapScene alloc] init];
    
    
    
    self.sceneKitView.scene = self.mapScene;
    
    
    AMGSoundManager* _soundManager = [AMGSoundManager sharedManager];
    [_soundManager playAudio:[[NSBundle mainBundle] pathForResource:@"driving" ofType:@"mp3"] withName:@"driving" inLine:@"driving" withVolume:0.5 andRepeatCount:-1 fadeDuration:0 withCompletitionHandler:nil];
    
    
    [NSTimer scheduledTimerWithTimeInterval:animationLength repeats:YES block:^(NSTimer * _Nonnull timer) {
        
        
        if(self.mapScene.isOffroad) {
            self.gameCharacter.transform = CGAffineTransformRotate(CGAffineTransformIdentity, RADIANS(-5.0));
            
            [UIView beginAnimations:@"wobble" context:(__bridge void * _Nullable)(self.gameCharacter)];
            [UIView setAnimationRepeatAutoreverses:YES]; // important
            [UIView setAnimationRepeatCount:2];
            [UIView setAnimationDuration:animationLength/2];
            [UIView setAnimationDelegate:self];
            [UIView setAnimationDidStopSelector:@selector(wobbleEnded:finished:context:)];
            
            self.gameCharacter.transform = CGAffineTransformRotate(CGAffineTransformIdentity, RADIANS(5.0));
            
            [UIView commitAnimations];
            
        }
        
        self.colorView.backgroundColor = self.mapScene.currentFloorColor;
        
        AMGSoundManager* soundManager = [AMGSoundManager sharedManager];
        
        if([self currentDrivingDirection] == DrivingDirectionLeft) {
            
            self.gameCharacter.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@_left",self.driverName]];
            
            
            
            if(self.vehicleSpeed != 0) {
                [self.gameScene moveLeft];
                [self.mapScene steerWithSteeringAnghel:self.vehicleSteeringAngel];
                [self.mapScene moveForwardWithSpeed:self.vehicleSpeed / 1.5];
            }
            
            
            
        } else if([self currentDrivingDirection] == DrivingDirectionRight) {
            
            self.gameCharacter.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@_right",self.driverName]];
            
            
            if(self.vehicleSpeed != 0) {
                [self.gameScene moveRight];
                [self.mapScene steerWithSteeringAnghel:self.vehicleSteeringAngel];
                [self.mapScene moveForwardWithSpeed:self.vehicleSpeed / 1.5];
            }
            
            
        } else if([self currentDrivingDirection] == DrivingDirectionForward) {
            self.gameCharacter.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@_back",self.driverName]];
            
            
            [self.mapScene steerWithSteeringAnghel:self.vehicleSteeringAngel];
            [self.mapScene moveForwardWithSpeed:self.vehicleSpeed];
        }
        
        if ([self currentDrivingDirection] != DrivingDirectionForward && ![soundManager isAudioPlayingInLine:@"drifting"] && [self currentDrivingDirection] != self.lastDrivingDirection) {
            [soundManager playAudio:[[NSBundle mainBundle] pathForResource:@"drifting" ofType:@"mp3"] withName:@"right" inLine:@"drifting" withVolume:1 andRepeatCount:0 fadeDuration:0 withCompletitionHandler:nil];
            [soundManager setVolume:0.5 forLine:@"driving" withFadeDuration:1];
            [NSTimer scheduledTimerWithTimeInterval:2 repeats:NO block:^(NSTimer * _Nonnull timer) {
                [soundManager setVolume:0.5 forLine:@"driving" withFadeDuration:1];
            }];
        }
        
        
        if(self.vehicleSpeed <= 0) {
            [soundManager pauseAudiosInLine:@"driving"];
        } else if(![soundManager isAudioPlayingInLine:@"driving"]) {
            [soundManager resumeAudiosInLine:@"driving"];
        }
        
        self.lastDrivingDirection = [self currentDrivingDirection];
    }];
    
    
    
}

-(DrivingDirection) currentDrivingDirection {
    
    if(self.vehicleSteeringAngel > 0.1) {
        return DrivingDirectionLeft;
    } else if(self.vehicleSteeringAngel < -0.1) {
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

- (void) wobbleEnded:(NSString *)animationID finished:(NSNumber *)finished context:(void *)context
{
    if ([finished boolValue]) {
        UIView* item = (__bridge UIView *)context;
        item.transform = CGAffineTransformIdentity;
    }
}


-(void)speedChangeTo:(double)to of:(Kehrmaschine *)kehrmaschine {
    self.vehicleSpeed = to;
    self.statusLabel.text = [NSString stringWithFormat:@"Speed %.2f - Steerin %.2f", self.vehicleSpeed * 100, self.vehicleSteeringAngel * 100];
}

-(void)steeringAngleChangedTo:(double)to of:(Kehrmaschine *)kehrmaschine {
    self.vehicleSteeringAngel = to;
    self.statusLabel.text = [NSString stringWithFormat:@"Speed %.2f - Steerin %.2f", self.vehicleSpeed * 100, self.vehicleSteeringAngel * 100];

}


@end
