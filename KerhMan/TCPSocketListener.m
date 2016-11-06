//
//  TCPSocketListener.m
//  KerhMan
//
//  Created by Frederik Riedel on 05/11/2016.
//  Copyright © 2016 Frogg GmbH. All rights reserved.
//

#import "TCPSocketListener.h"




@implementation TCPSocketListener


-(instancetype) initSocketListenerForPort:(int) port {
    
    self = [super init];
    
    if(self) {
        
        tcpSockets = [NSMutableArray new];
        
        tcpSocketListener = [[GCDAsyncSocket alloc] initWithDelegate:self delegateQueue:dispatch_get_main_queue()];
        
        NSError *error = nil;
        
        if(![tcpSocketListener acceptOnPort:port error:&error]) {
            NSLog(@"tcpSocketListenerAcceptOnPort: %@", error);
        }
    }
    
    return self;
}


-(void)socket:(GCDAsyncSocket *)sender didAcceptNewSocket:(GCDAsyncSocket *)newSocket {
    if(sender == tcpSocketListener) {
        [tcpSockets addObject:newSocket];
        newSocket.delegate = self;
        NSLog(@"New Socket Connection");
        
        [newSocket readDataWithTimeout:-1 tag:1];
        
    }
}


-(void)socket:(GCDAsyncSocket *)sock didReadData:(NSData *)data withTag:(long)tag {
    //received TCP message
    NSString* receivedString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    
    NSArray* components = [receivedString componentsSeparatedByString:@";"];
    
    if([components count] == 4) {
        
        double x_val = [[components objectAtIndex:0] doubleValue];
        double y_val = [[components objectAtIndex:1] doubleValue];
        double z_val = [[components objectAtIndex:2] doubleValue];
        double dist = [[components objectAtIndex:3] doubleValue];
        
        NSLog(@"Received Values: x: %f, y: %f, z: %f, dist: %f",x_val, y_val, z_val, dist);
        
        if(dist < 1000) {
            [[NSNotificationCenter defaultCenter] postNotificationName:@"WallWarning" object:nil];
        }
        
    } else {
        NSLog(@"Fehlerhafter Datensatz: %@", receivedString);
    }
    
    [sock writeData:[@"FAMOS" dataUsingEncoding:NSUTF8StringEncoding] withTimeout:10 tag:1];
    [sock readDataWithTimeout:-1 tag:1];
    
}

-(void)socketDidDisconnect:(GCDAsyncSocket *)sock withError:(NSError *)err {
    NSLog(@"Disconnected: %@",err.description);
}

-(void)socketDidCloseReadStream:(GCDAsyncSocket *)sock {
    NSLog(@"socketDidCloseReadStream");
}


@end
