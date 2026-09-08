//
//  MqClient.swift
//  Location Client iOS
//
//  Created by row64 on 9/3/26.
//

/**
 MQTT library: CocoaMQTT
 https://github.com/emqx/CocoaMQTT
 */


import Foundation
import CocoaMQTT

class MqClient {
    
    // My login objects
    let login: MqLogin
    let authMethod: Int
    
    // MQTT client library objects
    let clientID: String
    let connectProperties: MqttConnectProperties
    let mqtt5: CocoaMQTT5
    let mqtt3: CocoaMQTT
    
    
    init(inputLogin: MqLogin) {
        
        login = inputLogin
        authMethod = login.getAuthMethod()
        
        clientID = "CocoaMQTT5-" + String(ProcessInfo.processInfo.processIdentifier)
        
        // Connection properties for MQTT 5
        connectProperties = MqttConnectProperties()
        connectProperties.topicAliasMaximum = 10
        connectProperties.sessionExpiryInterval = 60
        connectProperties.receiveMaximum = 100
        connectProperties.maximumPacketSize = 1024 * 1024
        
        mqtt5 = CocoaMQTT5(clientID: clientID, host: login.getHost(), port: login.getPort())
        mqtt3 = CocoaMQTT(clientID: clientID, host: login.getHost(), port: login.getPort())
        
        mqtt5.connectProperties = connectProperties
        
    }
    
    
    // ----------------------------------------------------------------------
    // CONNECT METHODS
    
    /**
     Attempt to connect to a broker based on the detected authentication method.
     
     For all authentication methods, first try to connect using MQTT v5. If the connection fails, try the connection
     with v3.1.1.
     */
    func connectToBroker() {
        
        switch authMethod {
        case 0:
            print("Attempting to connect with no authentication...")
//            connectNoAuth()
        case 1:
            print("Attempting to connect with username and no password...")
//            connectUsername()
        case 2:
            print("Attempting to connect with basic authentication...")
            connectBasic()
        default:
            print("Error: Unknown authentication method.")
        }
        
    }
    
    
    
    
    
    /**
     Connect to the broker with basic authentication.
     */
    private func connectBasic() {
        
        // MQTT 5 connect
        
        mqtt5.username = login.getUser()
        mqtt5.password = login.getPass()
        mqtt5.willMessage = CocoaMQTT5Message(topic: "/will", string: "dieout")
        mqtt5.keepAlive = 60
        mqtt5.autoReconnect = true
//        mqtt5.delegate = self
        mqtt5.connect()
        
    }
    
    
    
    
    // ----------------------------------------------------------------------
    
    
    
}
