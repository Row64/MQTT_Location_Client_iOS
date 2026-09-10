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

class MqClient: CocoaMQTTDelegate {
    
    // My login objects
    var login: MqLogin
    var authMethod: Int
    
    // MQTT client library objects
    let clientID: String
    var connectProperties: MqttConnectProperties
    var mqtt5: CocoaMQTT5
    var mqtt3: CocoaMQTT!
    
    
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
            
            print("NOT IMPLEMENTED...")
        case 1:
            print("Attempting to connect with username and no password...")
            
            print("NOT IMPLEMENTED...")
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
        
        // For testing
        print("Got to connectBasic()")
        
        print("Attempting to connect with v3.1.1 using basic authentication...")
        // MQTT 3 connect
        
        mqtt3.username = login.getUser()
        mqtt3.password = login.getPass()
        mqtt3.willMessage = CocoaMQTTMessage(topic: "/will", string: "dieout")
        mqtt3.keepAlive = 60
        mqtt3.autoReconnect = true
        mqtt3.delegate = self
        mqtt3.connect()
        
    }
    
    
    
    
    
    
    // ----------------------------------------------------------------------
    // CocoaMQTTDelegate functions
    // https://stackoverflow.com/questions/76933554/swiftui-cocoamqtt-server-how-to-connect-without-using-button
    
    
    
    func mqtt(_ mqtt: CocoaMQTT, didConnect host: String, port: Int) {
        print("Got to didConnect()")
    }
    
    
    
    func mqtt(_ mqtt: CocoaMQTT, didSubscribeTopics success: NSDictionary, failed: [String]) {
    }
        
    func mqtt(_ mqtt: CocoaMQTT, didUnsubscribeTopics topics: [String]) {
    }
    
    func mqtt(_ mqtt: CocoaMQTT, didConnectAck ack: CocoaMQTTConnAck) {
        if ack == .accept {
            print("Connection was successful")
        }
        else {
            print("Failed to connect")
            print(ack)
        }
        
    }
    
    func mqtt(_ mqtt: CocoaMQTT, didPublishMessage message: CocoaMQTTMessage, id: UInt16) {
    }
    
    func mqtt(_ mqtt: CocoaMQTT, didPublishAck id: UInt16) {
    }
    
    func mqtt(_ mqtt: CocoaMQTT, didReceiveMessage message: CocoaMQTTMessage, id: UInt16) {
    }
        
    func mqtt(_ mqtt: CocoaMQTT, didUnsubscribeTopic topic: String) {
    }
    
    func mqttDidPing(_ mqtt: CocoaMQTT) {
    }
    
    func mqttDidReceivePong(_ mqtt: CocoaMQTT) {
    }
    
    func mqttDidDisconnect(_ mqtt: CocoaMQTT, withError err: Error?) {
    }
    
    
    
    
    // ----------------------------------------------------------------------
    
    
    
}
