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
        self.session.delegate = self;
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
    self.session.channel.delegate = self;
    NSError* shellError = nil;
    
    [self.session.channel startShell:&shellError];
    
    [NSTimer scheduledTimerWithTimeInterval:1 repeats:YES block:^(NSTimer * _Nonnull timer) {
        NSError *error = nil;
        
        NSLog(@"write: %i", [self.session.channel write:@"tcuclient -c \"var read tcu.networkmanager.simstate\"" error:&error timeout:@10]);
        //NSString *response = [self.session.channel execute:@"tcuclient -c \"var read tcu.networkmanager.simstate\"" error:&error];
     //   NSLog(@"List of my sites: %@", response);
    }];
}

-(void)startMonitoringSteeringWheel {
    
}


- (void)channel:(NMSSHChannel *)channel didReadData:(NSString *)message {
    NSLog(@"List of my sites: %@", message);
}

- (void)channel:(NMSSHChannel *)channel didReadError:(NSString *)error {
    NSLog(@"error: %@", error);
}

- (BOOL)session:(NMSSHSession *)session shouldConnectToHostWithFingerprint:(NSString *)fingerprint {
    return YES;
}

- (void)session:(NMSSHSession *)session didDisconnectWithError:(NSError *)error {
    NSLog(@"Error: %@", error);
}
@end
