//
//  GameScene.m
//  KerhMan
//
//  Created by Frederik Riedel on 05/11/2016.
//  Copyright © 2016 Frogg GmbH. All rights reserved.
//

#import "GameScene.h"

@implementation GameScene

-(void)didMoveToView:(SKView *)view {
    //self.backgroundColor = [SKColor colorWithRed:135.f/255.f green:206.f/255.f blue:235.f/255.f alpha:0.0];
    self.backgroundColor = [SKColor colorWithRed:245.f/255.f green:233.f/255.f blue:155.f/255.f alpha:1.0];
    self.scaleMode = SKSceneScaleModeAspectFit;
    
    
    SKTexture* textureHills = [SKTexture textureWithImageNamed:@"bg_hills"];
    [textureHills setFilteringMode:SKTextureFilteringNearest];
    
    CGFloat scaleFactorHills = view.frame.size.height / textureHills.size.height;
    
    backgroundHills = [SKSpriteNode spriteNodeWithTexture:textureHills];
    backgroundHills.size = CGSizeMake(textureHills.size.width*scaleFactorHills, scaleFactorHills*textureHills.size.height);
    backgroundHills.anchorPoint = CGPointZero;
    
    [self addChild:backgroundHills];
    
    
    SKTexture* textureTrees = [SKTexture textureWithImageNamed:@"bg_trees"];
    [textureTrees setFilteringMode:SKTextureFilteringNearest];
    
    CGFloat scaleFactorTrees = (view.frame.size.height/2) / textureTrees.size.height;
    
    backgroundTrees = [SKSpriteNode spriteNodeWithTexture:textureTrees];
    backgroundTrees.size = CGSizeMake(scaleFactorTrees*textureTrees.size.width, scaleFactorTrees*textureTrees.size.height);
    backgroundTrees.anchorPoint = CGPointZero;
    
    [self addChild:backgroundTrees];

}

-(void) moveRight {
    if(backgroundTrees.frame.origin.x < -backgroundTrees.frame.size.width) {
        SKAction* moveTrees = [SKAction moveTo:CGPointMake(self.view.frame.size.width, 0) duration:0];
        [backgroundTrees runAction:moveTrees];
    }
    
    SKAction* moveTrees = [SKAction moveByX:-100 y:0 duration:0.5];
    [backgroundTrees runAction:moveTrees];
    
    
    
    if(backgroundHills.frame.origin.x < -backgroundHills.frame.size.width) {
        SKAction* moveHills = [SKAction moveTo:CGPointMake(self.view.frame.size.width, 0) duration:0];
        [backgroundHills runAction:moveHills];
    }
    
    SKAction* moveHills = [SKAction moveByX:-50 y:0 duration:0.5];
    [backgroundHills runAction:moveHills];
    
    
    
}

-(void) moveLeft {
    
    
    if(backgroundTrees.frame.origin.x > self.view.frame.size.width) {
        SKAction* moveHills = [SKAction moveTo:CGPointMake(-backgroundTrees.frame.size.width, 0) duration:0];
        [backgroundTrees runAction:moveHills];
    }
    
    SKAction* move = [SKAction moveByX:100 y:0 duration:0.5];
    [backgroundTrees runAction:move];
    
    
    if(backgroundHills.frame.origin.x > self.view.frame.size.width) {
        SKAction* moveHills = [SKAction moveTo:CGPointMake(-backgroundHills.frame.size.width, 0) duration:0];
        [backgroundHills runAction:moveHills];
    }
    
    SKAction* moveHills = [SKAction moveByX:50 y:0 duration:0.5];
    [backgroundHills runAction:moveHills];
}

@end
