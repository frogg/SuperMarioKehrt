//
//  MapScene.h
//  KerhMan
//
//  Created by Frederik Riedel on 05/11/2016.
//  Copyright © 2016 Frogg GmbH. All rights reserved.
//

#import <SceneKit/SceneKit.h>

@interface MapScene : SCNScene {
    SCNFloor* floor;
    SCNSphere* sphere;
    UIImage* floorImage;
}

@property SCNNode* cameraNode;
@property UIColor* currentFloorColor;
@property bool isOffroad;

-(void) moveForwardWithSpeed:(double) speed;
-(void) steerWithSteeringAnghel:(double) steeringAngel;

@end
