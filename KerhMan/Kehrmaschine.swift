//
//  SSHTest.swift
//  KerhMan
//
//  Created by Leonard Mehlig on 05/11/16.
//  Copyright © 2016 Frogg GmbH. All rights reserved.
//

import Foundation
import NMSSH

@objc public protocol KehrmaschineDelegate {
    func speedChange(to: Double, of kehrmaschine: Kehrmaschine)
    func steeringAngleChanged(to: Double, of kehrmaschine: Kehrmaschine)
}

@objc public class Kehrmaschine: NSObject {
    
    enum Command: String {
        case simStatus = "tcu.networkmanager.simstate"
        case pairingStatus = "tcu.id.pairing.status"
        case position = "tcu.lastpos2"
    }
    
    let queue: DispatchQueue = DispatchQueue(label: "kehrman.ssh")
    private var delegates: [CommandDelegate] = []
    public init(host: String, user: String, password: String) {
        super.init()
        self.queue.async {
            self.delegates += [
                try! CommandDelegate(host: host, user: user, password: password, command: .position, callback: self.delegateCallback),
                try! CommandDelegate(host: host, user: user, password: password, command: .simStatus, callback: self.delegateCallback),
                try! CommandDelegate(host: host, user: user, password: password, command: .pairingStatus, callback: self.delegateCallback)
            ]
            
        }
    }
    
    
    //tcu.lastpos2
    //ksip.kopf.ophr
    //ksip.kopf.measurement.41 >> battery charge level
    //ksip.kopf.machineoperable
    //KyQETdMx8xTHAS{R >> charing cycles
    //ksip.kopf.parameter.45877 >> battery id
    
    private func delegateCallback(command: Command, result: String) -> Bool {
        DispatchQueue.main.async {
            print("Command \(command) with result: \(result)")
        }
        return true
    }
   
    
    private class CommandDelegate: NSObject, NMSSHChannelDelegate {
        private static let regex = try! NSRegularExpression(pattern: "tcuclient\\s\\-c\\s\\'var\\sread\\s.+\\'\\s*([^@#]+?)\\s*root@kaercher_tcu\\s~\\s#", options: [])
        let session: NMSSHSession
        let command: Command
        let callback: (Command, String) -> Bool
        let queue: DispatchQueue = DispatchQueue(label: "kehrman.ssh")

        
        init(host: String, user: String, password: String, command: Command, callback: @escaping (Command, String) -> Bool) throws {
            self.session = NMSSHSession.connect(toHost: host, withUsername: user)
            self.session.authenticate(byPassword: password)
            self.command = command
            self.callback = callback
            super.init()
            self.session.channel.delegate = self
            self.session.channel.requestPty = true
            try self.session.channel.startShell()
            try! self.sendCommand()
        }
        
        private func sendCommand() throws {
            try self.session.channel.write("tcuclient -c 'var read \(self.command.rawValue)'\n")
        }
        
        
        private var output: String = "" {
            didSet {
                let string = self.output.replacingOccurrences(of: "\r", with: " ").replacingOccurrences(of: "\n", with: " ")
                if let match = CommandDelegate.regex.firstMatch(in: string, options: [], range: NSMakeRange(0, (string as NSString).length)), match.numberOfRanges == 2 {
                    let result = (string as NSString).substring(with: match.rangeAt(1))
                    if !result.replacingOccurrences(of: " ", with: "").isEmpty && self.callback(self.command, result) {
                        print("Result: \(result)")
                        self.output = ""
                        try! self.sendCommand()
                    }
                }
            }
        }
        
        func channel(_ channel: NMSSHChannel!, didReadData message: String!) {
            print(message)
            self.output.append(message)
        }
        
        func channel(_ channel: NMSSHChannel!, didReadError error: String!) {
            print("Error: ", error)
        }
        
        func channelShellDidClose(_ channel: NMSSHChannel!) {
            print("session closed")
        }
    }
    
}



