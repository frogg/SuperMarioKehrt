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
        [newSocket readDataWithTimeout:10 tag:1];
    }
}


-(void)socket:(GCDAsyncSocket *)sock didReadData:(NSData *)data withTag:(long)tag {
    //received TCP message
    NSString* receivedString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    NSLog(@"%@",receivedString);
}



@end
