//
//  TCPSocketListener.h
//  KerhMan
//
//  Created by Frederik Riedel on 05/11/2016.
//  Copyright © 2016 Frogg GmbH. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GCDAsyncSocket.h"

@interface TCPSocketListener : NSObject<GCDAsyncSocketDelegate> {
    GCDAsyncSocket* tcpSocketListener;
    NSMutableArray* tcpSockets;
}

-(instancetype) initSocketListenerForPort:(int) port;

@end
