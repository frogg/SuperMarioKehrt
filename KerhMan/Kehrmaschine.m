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
       
        self.sshWrapper = [[SSHWrapper alloc] init];
        NSError *error = nil;
        [self.sshWrapper connectToHost:@"192.168.100.99" port:22 user:@"root" password:@"KyQETdMx8xTHAS{R" error:&error];
        
        NSLog(@"Error: %@",error.description);
        
        
        //tcuclient -c \"var read ksip.
        //tcu.networkmanager.eprsreg
        //tcu.id.pairing.status
        //tcu.adaptermanager.adaptername.adapterstate
        
        
    }
    
    
    return self;
}

-(void)startMonitoringSpeed {
   
    
    [NSTimer scheduledTimerWithTimeInterval:1 repeats:YES block:^(NSTimer * _Nonnull timer) {
        NSError *error = nil;
        
        
        NSLog(@"%@",[self.sshWrapper executeCommand:@"tcuclient -c 'var read tcu.networkmanager.simstate'\n" error:&error]);
        
        NSLog(@"%@",error.description);
        //NSString *response = [self.session.channel execute:@"tcuclient -c \"var read tcu.networkmanager.simstate\"" error:&error];
     //   NSLog(@"List of my sites: %@", response);
    }];
}

@end