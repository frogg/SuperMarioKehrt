//
//  MapScene.m
//  KerhMan
//
//  Created by Frederik Riedel on 05/11/2016.
//  Copyright © 2016 Frogg GmbH. All rights reserved.
//

#import "MapScene.h"

@implementation MapScene

-(instancetype) init {
    self = [super init];
    
    if(self) {
        SCNPlane* plane = [[SCNPlane alloc] init];
        plane.firstMaterial.diffuse.contents = [UIImage imageNamed:@"map_1"];
        plane.firstMaterial.diffuse.minificationFilter = SCNFilterModeNearest;
        plane.firstMaterial.diffuse.magnificationFilter = SCNFilterModeNearest;
       // plane.width = 4000;
      //  plane.height = 4000;
        
        
        SCNNode* planeNode = [SCNNode nodeWithGeometry:plane];
        //planeNode.rotation = SCNVector4Make(1, 0, 0, M_PI/3);
        planeNode.scale = SCNVector3Make(50, 50, 50);
        //planeNode.position =
        [self.rootNode addChildNode:planeNode];
        
        
        SCNCamera* camera = [SCNCamera camera];
        camera.usesOrthographicProjection = true;
        //camera.orthographicScale = 9;
        //camera.zNear = 0;
        //camera.zFar = 200;
        //camera.focalDistance = 1000.f;
        
        self.cameraNode = [SCNNode node];
        //cameraNode.position = SCNVector3Make(0, 0, 0);
        
        self.cameraNode.camera = camera;
        self.cameraNode.rotation = SCNVector4Make(1, 0, 0, 1.04);
        
        [self.rootNode addChildNode:self.cameraNode];
        
        /*let planeNode = SCNNode(geometry: plane)
        planeNode.position = SCNVector3Make(0, 0, 100)
        [self.rootNode addChildNode:plane];*/
    }
    
    
    return self;
}

-(void) moveLeft {
    SCNAction* move = [SCNAction rotateByAngle:-1 aroundAxis:SCNVector3Make(0, 0, 1) duration:0.5];
    [self.cameraNode runAction:move];
}

-(void) moveRight {
    SCNAction* move = [SCNAction rotateByAngle:1 aroundAxis:SCNVector3Make(0, 0, 1) duration:0.5];
    [self.cameraNode runAction:move];
}

-(void) moveForward {
    SCNAction* move = [SCNAction moveBy:SCNVector3Make(0, 0, -1) duration:0.5];
    [self.cameraNode runAction:move];
}


@end
