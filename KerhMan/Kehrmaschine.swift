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
    
    public static let shared = Kehrmaschine(host: "192.168.100.99", user: "root", password: "KyQETdMx8xTHAS{R")
    
    enum Command: String {
        case position = "tcu.lastpos2"
        case steeringWheel = "ksip.kopf.measurement.39"
        case speed = "ksip.kopf.measurement.7"
        case direction = "ksip.kopf.sensor.3"
        
    }
    
    let queue: DispatchQueue = DispatchQueue(label: "com.mariokehrt.ssh")
    private var delegates: [CommandDelegate] = []
    
    
    public weak var delegate: KehrmaschineDelegate?
    public init(host: String, user: String, password: String) {
        super.init()
        self.queue.async {
            self.delegates += [
                try! CommandDelegate(host: host, user: user, password: password, commands: [.steeringWheel, .speed, .steeringWheel], callback: self.delegateCallback),
            ]
            
        }
    }
    
    
    //tcu.lastpos2
    //ksip.kopf.ophr
    //ksip.kopf.measurement.41 >> battery charge level
    //ksip.kopf.machineoperable
    //ksip.kopf.measurement.42 >> charing cycles
    //ksip.kopf.parameter.45877 >> battery id
    private var commandsStats: [Command : Int] = [:]
    private lazy var startDate: Date = Date()
    private var numberStats: [Command : Int] = [:]
    
    private func delegateCallback(command: Command, result: String) -> Bool {
        DispatchQueue.main.async {
            if !result.contains("error") {
                print("Command \(command) with result: \(result)")
                self.commandsStats[command] = (self.commandsStats[command] ?? 0) + 1
                self.numberStats[command] = (self.numberStats[command] ?? 0) + 1
            } else {
                self.commandsStats[command] = (self.commandsStats[command] ?? 0) - 1
            }
            
            print("stat \(command): values per second: \(Double(self.numberStats[command] ?? 1) / self.startDate.timeIntervalSinceNow)")
            
            for (command, state) in self.commandsStats {
                print("stat \(command) = \(state)")
            }
            
            switch command {
            case .speed:
                if let number = Double(result) {
                    self.delegate?.speedChange(to: max(0, number - 1) / 100, of: self)
                }
            case .steeringWheel:
                if let number = Double(result) {
                    self.delegate?.steeringAngleChanged(to:  -2*((number - 100) / 90), of: self)
                }
            default: break
            }
        }
        switch command {
        case .speed:
            if let number = Double(result) {
                return true
            }
        case .steeringWheel:
            if let number = Double(result) {
                return true
            }
        default: break
        }
        return false
    }
    
    
    private class CommandDelegate: NSObject, NMSSHChannelDelegate {
        private static let regex = try! NSRegularExpression(pattern: "tcuclient\\s\\-c\\s\\'var\\sread\\s.+\\'\\s*([^@#]+?)\\s*root@kaercher_tcu\\s~\\s#", options: [])
        let session: NMSSHSession
        let commands: [Command]
        let callback: (Command, String) -> Bool
        
        
        init(host: String, user: String, password: String, commands: [Command], callback: @escaping (Command, String) -> Bool) throws {
            self.session = NMSSHSession.connect(toHost: host, withUsername: user)
            if self.session.connect() {
                print("Could connect to server")
                self.session.authenticate(byPassword: password)
            }
            self.commands = commands
            self.callback = callback
            super.init()
            if self.session.connect() && !self.session.isAuthorized {
                self.session.authenticate(byPassword: password)
            }
            guard self.session.isAuthorized else {
                print("fuck this, wronge password")
                return
            }
            self.session.channel.delegate = self
            self.session.channel.requestPty = true
            try self.session.channel.startShell()
            try! self.sendCommand()
        }
        
        private var nextCommandIndex = 0
        private func sendCommand() throws {
            if self.commands.count <= self.nextCommandIndex {
                self.nextCommandIndex = 0
            }
            try self.session.channel.write("tcuclient -c 'var read \(self.commands[self.nextCommandIndex].rawValue)'\n")
        }
        
        
        private var output: String = "" {
            didSet {
                let string = self.output.replacingOccurrences(of: "\r", with: " ").replacingOccurrences(of: "\n", with: " ")
                if let match = CommandDelegate.regex.firstMatch(in: string, options: [], range: NSMakeRange(0, (string as NSString).length)), match.numberOfRanges == 2 {
                    let result = (string as NSString).substring(with: match.rangeAt(1))
                    if self.callback(self.commands[self.nextCommandIndex], result) {
                        self.nextCommandIndex += 1
                    }
                    print("Result: \(result)")
                    self.output = ""
                    try! self.sendCommand()
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



