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
        camera.orthographicScale = 9;
        camera.zNear = 0;
        //camera.zFar = 200;
        //camera.focalDistance = 1000.f;
        
        cameraNode = [SCNNode node];
        //cameraNode.position = SCNVector3Make(0, 0, 0);
        
        cameraNode.camera = camera;
        cameraNode.rotation = SCNVector4Make(1, 0, 0, M_PI/3);
        [self.rootNode addChildNode:cameraNode];
        
        /*let planeNode = SCNNode(geometry: plane)
        planeNode.position = SCNVector3Make(0, 0, 100)
        [self.rootNode addChildNode:plane];*/
    }
    
    
    return self;
}


-(void) moveCamera {
    SCNAction* move = [SCNAction moveBy:SCNVector3Make(0, 10, 0) duration:10];
    [cameraNode runAction:move];
}

@end
