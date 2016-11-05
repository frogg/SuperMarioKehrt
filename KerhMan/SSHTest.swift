//
//  SSHTest.swift
//  KerhMan
//
//  Created by Leonard Mehlig on 05/11/16.
//  Copyright © 2016 Frogg GmbH. All rights reserved.
//

import Foundation
import NMSSH

public class SSH: NSObject, NMSSHChannelDelegate, NMSSHSessionDelegate {
    
    let queue: DispatchQueue = DispatchQueue(label: "kehrman.ssh")
    var session: NMSSHSession!
    public init(host: String, user: String, password: String) {
        super.init()
        self.queue.async {
            self.session = NMSSHSession.connect(toHost: host, withUsername: user)
            self.session.delegate = self
            self.session.authenticate(byPassword: password)
            if self.session.isAuthorized {
                self.session.channel.delegate = self
                self.session.channel.requestPty = true
                try! self.session.channel.startShell()
                try! self.session.channel.write("tcuclient -c 'var read tcu.networkmanager.simstate'\n")

            }
        }
    }
    
    public func command() {
        self.queue.async {
            try! self.session.channel.write("pwd\n")
        }
    }
    
    
    
    public func channel(_ channel: NMSSHChannel!, didReadData message: String!) {
        print("message: ", message)
    }
    public func channel(_ channel: NMSSHChannel!, didReadError error: String!) {
        
    }
  
}
