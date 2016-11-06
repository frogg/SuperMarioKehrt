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
        
        //start position
        self.cameraNode.position = SCNVector3Make(-10, 0, -39);
        self.cameraNode.rotation = SCNVector4Make(0, 1, 0, 0.000977);
        [self.rootNode addChildNode:self.cameraNode];
        

        
        floor = [SCNFloor floor];
        //floor.reflectionFalloffEnd = 10;
        //floor.reflectivity = 1.f;
        floorImage = [UIImage imageNamed:@"map_1"];
        floor.firstMaterial.diffuse.contents = floorImage;
        floor.firstMaterial.diffuse.minificationFilter = SCNFilterModeNearest;
        floor.firstMaterial.diffuse.magnificationFilter = SCNFilterModeNearest;
        
        SCNNode* floorNode = [SCNNode nodeWithGeometry:floor];
        floorNode.position = SCNVector3Make(0, -1, 0);
        [self.rootNode addChildNode:floorNode];
        


    }
    
    
    return self;
}

-(void)steerWithSteeringAnghel:(double) steeringAngel {
    SCNAction* move = [SCNAction rotateByAngle:steeringAngel*animationLength*2*gameSpeed*0.25f aroundAxis:SCNVector3Make(0, 1, 0) duration:animationLength];
    [self.cameraNode runAction:move];
}

-(void) moveForwardWithSpeed:(double) speed {
    
    
    
    double yangle = self.cameraNode.rotation.y * self.cameraNode.rotation.w;
    
    NSLog(@"ry: %f, rw: %f, x: %f, z: %f",self.cameraNode.rotation.y,self.cameraNode.rotation.w,self.cameraNode.position.x,self.cameraNode.position.z);
    
    
    double yMovement = -cos(yangle) * gameSpeed * animationLength*2 *speed;
    double xMovement = -sin(yangle) * gameSpeed * animationLength*2 *speed;
    
    
    SCNAction* move = [SCNAction moveByX:xMovement y:0 z:yMovement duration:0.5];
    [self.cameraNode runAction:move];
    [self currentPositionWithYMovement:yMovement xMovement:xMovement];
    
}

- (void) currentPositionWithYMovement:(double) yMovement  xMovement: (double) xMovement {

    CGPoint currentPoint = CGPointMake(
                                       (self.cameraNode.position.x + xMovement * 6) * (floorImage.size.width / 100),
                                       (self.cameraNode.position.z + yMovement * 6 + 100) * (floorImage.size.height / 100)
                                       );
    int x = ((int) currentPoint.x % (int) floorImage.size.height + (int) floorImage.size.height) % (int) floorImage.size.height;
    int y = ((int) currentPoint.y % (int) floorImage.size.width + (int) floorImage.size.width) % (int) floorImage.size.height;
    
    
    UIGraphicsBeginImageContext(floorImage.size);
    [floorImage drawInRect:CGRectMake(0, 0, floorImage.size.width, floorImage.size.height)];
    UIBezierPath* path = [UIBezierPath bezierPathWithOvalInRect:CGRectMake(currentPoint.x, currentPoint.y, 10, 10)];
    [[UIColor redColor] setFill];
    [path fill];
    UIImage* image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    UIColor* color = [self colorInPixel:floorImage xCoordinate:x yCoordinate:y];
    self.currentFloorColor = color;
    CGFloat red, green, blue;
    [color getRed:&red green:&green blue:&blue alpha:nil];
    CGFloat minColor = MIN(MIN(red, green), blue) * 255;
    CGFloat maxColor = MAX(MAX(red, green), blue) * 255;
    
    
    
    
    
    

    if ((maxColor - minColor) < 50) {
        NSLog(@"Is street");
        self.isOffroad = false;
    } else {
        NSLog(@"Isn't street");
        self.isOffroad = true;
    }
    
}

- (UIColor* )colorInPixel:(UIImage *)image xCoordinate:(int)x yCoordinate:(int)y {
    
    CFDataRef pixelData = CGDataProviderCopyData(CGImageGetDataProvider(image.CGImage));
    const UInt8* data = CFDataGetBytePtr(pixelData);
    
    int pixelInfo = MAX(((image.size.width  * y) + x - 1) * 4,0); // The image is png
    
    
    UInt8 red = data[pixelInfo];         // If you need this info, enable it
    UInt8 green = data[(pixelInfo + 1)]; // If you need this info, enable it
    UInt8 blue = data[pixelInfo + 2];    // If you need this info, enable it
    UInt8 alpha = data[pixelInfo + 3];     // I need only this info for my maze game
    CFRelease(pixelData);
    NSLog(@"rgb %hhun %hhun %hhun", red, green, blue);

    return [UIColor colorWithRed:red/255.0f green:green/255.0f blue:blue/255.0f alpha:alpha/255.0f]; // The pixel color info
    
}

@end
