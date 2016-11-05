//
//  MapScene.m
//  KerhMan
//
//  Created by Frederik Riedel on 05/11/2016.
//  Copyright © 2016 Frogg GmbH. All rights reserved.
//

#import "MapScene.h"
#define MCP_DEGREES_TO_RADIANS(angle) ((angle) / 180.0 * M_PI)

@implementation MapScene

-(instancetype) init {
    self = [super init];
    
    if(self) {
    

        // Create a camera
        SCNCamera *camera = [SCNCamera camera];
        camera.xFov = 45;   // Degrees, not radians
        camera.yFov = 45;
        
        self.cameraNode = [SCNNode node];
        self.cameraNode.camera = camera;
        self.cameraNode.position = SCNVector3Make(0, 0, 0);
        [self.rootNode addChildNode:self.cameraNode];
        

        
        floor = [SCNFloor floor];
        //floor.reflectionFalloffEnd = 10;
        //floor.reflectivity = 1.f;
        floor.firstMaterial.diffuse.contents = [UIImage imageNamed:@"map_1"];
        floor.firstMaterial.diffuse.minificationFilter = SCNFilterModeNearest;
        floor.firstMaterial.diffuse.magnificationFilter = SCNFilterModeNearest;
        
        SCNNode* floorNode = [SCNNode nodeWithGeometry:floor];
        floorNode.position = SCNVector3Make(0, -1, 0);
        [self.rootNode addChildNode:floorNode];
        


    }
    
    
    return self;
}

-(void) moveLeft {
    SCNAction* move = [SCNAction rotateByAngle:animationLength*2*gameSpeed*0.25f aroundAxis:SCNVector3Make(0, 1, 0) duration:0.5];
    [self.cameraNode runAction:move];
}

-(void) moveRight {
    SCNAction* move = [SCNAction rotateByAngle:animationLength*2*gameSpeed*-0.25f aroundAxis:SCNVector3Make(0, 1, 0) duration:0.5];
    [self.cameraNode runAction:move];
}

-(void) moveForward {
    
    
    
    double yangle = self.cameraNode.rotation.y * self.cameraNode.rotation.w;
    
    
    double yMovement = -cos(yangle) * gameSpeed * animationLength*2;
    double xMovement = -sin(yangle) * gameSpeed * animationLength*2;
    
    
    SCNAction* move = [SCNAction moveByX:xMovement y:0 z:yMovement duration:0.5];
    [self.cameraNode runAction:move];
}


@end
