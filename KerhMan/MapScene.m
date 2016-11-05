//
//  MapScene.m
//  KerhMan
//
//  Created by Frederik Riedel on 05/11/2016.
//  Copyright © 2016 Frogg GmbH. All rights reserved.
//

#import "MapScene.h"
#define MCP_DEGREES_TO_RADIANS(angle) ((angle) / 180.0 * M_PI)
#define gameSpeed 2
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
    SCNAction* move = [SCNAction rotateByAngle:gameSpeed*0.25f aroundAxis:SCNVector3Make(0, 1, 0) duration:0.5];
    [self.cameraNode runAction:move];
}

-(void) moveRight {
    SCNAction* move = [SCNAction rotateByAngle:gameSpeed*-0.25f aroundAxis:SCNVector3Make(0, 1, 0) duration:0.5];
    [self.cameraNode runAction:move];
}

-(void) moveForward {
    
    
    
    double yangle = self.cameraNode.rotation.y * self.cameraNode.rotation.w;
    
    NSLog(@"Camera Winkel: %f",yangle);
    
    double yMovement = -cos(yangle) * gameSpeed;
    double xMovement = -sin(yangle) * gameSpeed;
    
    NSLog(@"Movement: %f, %f",xMovement,yMovement);
    
    SCNAction* move = [SCNAction moveByX:xMovement y:0 z:yMovement duration:0.5];
    [self.cameraNode runAction:move];
}


@end
