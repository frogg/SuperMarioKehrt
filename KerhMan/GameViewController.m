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
    
}

-(void)viewWillAppear:(BOOL)animated {
    GameScene* gameScene = [[GameScene alloc] initWithSize:self.skview.frame.size];

    [self.skview presentScene: gameScene];
    
    [NSTimer scheduledTimerWithTimeInterval:0.15f repeats:YES block:^(NSTimer * _Nonnull timer) {
        [gameScene moveRight];
        
        [NSTimer scheduledTimerWithTimeInterval:0.05f repeats:NO block:^(NSTimer * _Nonnull timer) {
            [gameScene moveRight];
            
            [NSTimer scheduledTimerWithTimeInterval:0.05f repeats:NO block:^(NSTimer * _Nonnull timer) {
               // [gameScene moveRight];
            }];
        }];
        
        
    }];
    
    
    MapScene* mapScene = [[MapScene alloc] init];
    
    
    self.sceneKitView.scene = mapScene;
    [mapScene moveCamera];
    
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
