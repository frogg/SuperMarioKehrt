//
//  Kehrmaschine.m
//  KerhMan
//
//  Created by Frederik Riedel on 04/11/2016.
//  Copyright © 2016 Frogg GmbH. All rights reserved.
//

#import "Kehrmaschine.h"

@implementation Kehrmaschine



-(instancetype)initWithIpAddress:(NSString *)ipAddress withUserName:(NSString *)username withPassword:(NSString *)password {
    
    self = [super init];
    
    if(self) {
        self.session = [NMSSHSession connectToHost:ipAddress withUsername:username];
        
        if (self.session.isConnected) {
            [self.session authenticateByPassword:password];
            
            if (self.session.isAuthorized) {
                NSLog(@"Authentication succeeded");
            }
        }
        
        
        //tcuclient -c \"var read ksip.
        //tcu.networkmanager.eprsreg
        //tcu.id.pairing.status
        //tcu.adaptermanager.adaptername.adapterstate
        
        
    }
    
    
    return self;
}

-(void)startMonitoringSpeed {
    [NSTimer scheduledTimerWithTimeInterval:0.1 repeats:YES block:^(NSTimer * _Nonnull timer) {
        NSError *error = nil;
        NSString *response = [self.session.channel execute:@"tcuclient -c \"var read tcu.networkmanager.simstate\"" error:&error];
        NSLog(@"List of my sites: %@", response);
    }];
}

-(void)startMonitoringSteeringWheel {
    
}

@end
