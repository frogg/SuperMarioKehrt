//
//  Kehrmaschine.h
//  KerhMan
//
//  Created by Frederik Riedel on 04/11/2016.
//  Copyright © 2016 Frogg GmbH. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <NMSSH/NMSSH.h>

@protocol KehrmaschineDelegate <NSObject>

-(void) didChangeSpeed;
-(void) didChangeSteeringWheel;

@end

@interface Kehrmaschine : NSObject <NMSSHChannelDelegate, NMSSHSessionDelegate>


@property NMSSHSession* session;

-(instancetype) initWithIpAddress:(NSString*) ipAddress withUserName:(NSString*) username withPassword:(NSString*) password;
-(void) startMonitoringSpeed;
-(void) startMonitoringSteeringWheel;

@end
