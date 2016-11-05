//
//  MapScene.h
//  KerhMan
//
//  Created by Frederik Riedel on 05/11/2016.
//  Copyright © 2016 Frogg GmbH. All rights reserved.
//

#import <SceneKit/SceneKit.h>

@interface MapScene : SCNScene {
    
}

@property SCNNode* cameraNode;
-(void) moveForward;
-(void) moveRight;
-(void) moveLeft;

@end
