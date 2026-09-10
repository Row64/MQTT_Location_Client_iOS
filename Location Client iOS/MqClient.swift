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
//    var login: MqLogin
//    var authMethod: Int
    private var login: MqLogin? = nil
    private var authMethod: Int = -1
    
    // MQTT client library objects
//    let clientID: String
//    var connectProperties: MqttConnectProperties
//    var mqtt5: CocoaMQTT5
//    var mqtt: CocoaMQTT
    private var clientID: String = "CocoaMQTT5-" + String(ProcessInfo.processInfo.processIdentifier)
    private var connectProperties: MqttConnectProperties? = nil
    var mqtt5: CocoaMQTT5? = nil
    var mqtt: CocoaMQTT? = nil
    
    
    init() {
        
    }
    
    
    /**
     Consider removing this init
     
     This class will likely only be initialized without parameters.
     */
//    init(inputLogin: MqLogin) {
//        
//        login = inputLogin
//        authMethod = login.getAuthMethod()
//        
//        clientID = "CocoaMQTT5-" + String(ProcessInfo.processInfo.processIdentifier)
//        
//        // Connection properties for MQTT 5
//        connectProperties = MqttConnectProperties()
//        connectProperties.topicAliasMaximum = 10
//        connectProperties.sessionExpiryInterval = 60
//        connectProperties.receiveMaximum = 100
//        connectProperties.maximumPacketSize = 1024 * 1024
//        
//        // Assign connection variables
//        mqtt5 = CocoaMQTT5(clientID: clientID, host: login.getHost(), port: login.getPort())
//        mqtt = CocoaMQTT(clientID: clientID, host: login.getHost(), port: login.getPort())
//        
//        // Set connect properties for MQTT 5
//        mqtt5.connectProperties = connectProperties
//        
//        // MQTT v3.1.1 client configuration
//        mqtt.keepAlive = 60
//        mqtt.delegate = self
//        mqtt.username = "row64"
//        mqtt.password = "password"
//        mqtt.enableSSL = true // Important when using port 8883
//        mqtt.autoReconnect = true
//        
//        
//        // MQTT v5 client configuration
//        // ...
//        
//        
//        
//    }
    
    
    // ----------------------------------------------------------------------
    // CONNECT METHODS
    
    /**
     Attempt to connect to a broker based on the detected authentication method.
     
     For all authentication methods, first try to connect using MQTT v5. If the connection fails, try the connection
     with v3.1.1.
     */
    func connectToBroker() {
        
//        switch authMethod {
//        case 0:
//            print("Attempting to connect with no authentication...")
////            connectNoAuth()
//            
//            print("NOT IMPLEMENTED...")
//        case 1:
//            print("Attempting to connect with username and no password...")
//            
//            print("NOT IMPLEMENTED...")
////            connectUsername()
//        case 2:
//            print("Attempting to connect with basic authentication...")
//            connectBasic()
//        default:
//            print("Error: Unknown authentication method.")
//        }
        
        
        
        // Testing
        connectBasic()
        
    }
    
    
    
    
    
    /**
     Connect to the broker with basic authentication.
     */
    private func connectBasic() {
        
        // For testing
        print("Got to connectBasic()")
        
        print("Attempting to connect with v3.1.1 using basic authentication...")
        
        // MQTT 3 connect
        mqtt!.username = login!.getUser()
        mqtt!.password = login!.getPass()
        _ = mqtt!.connect()
        
    }
    
    // ----------------------------------------------------------------------
    // Initializing functions
    
    func initializeMqtt3Client(login: MqLogin) {
        mqtt = CocoaMQTT(clientID: clientID, host: login.getHost(), port: login.getPort())
        
        // MQTT v3.1.1 client configuration
        // Login object does not currently take configuration, so preset
        // values are currently used.
        mqtt!.keepAlive = 60
        mqtt!.delegate = self
        mqtt!.enableSSL = true // Important when using port 8883
        mqtt!.autoReconnect = true
    }
    
    
    func initializeMqtt5Client(login: MqLogin) {
        
        print("WARNING: initializeMqtt5Client() is not yet implemented...")
        
        //...
        
    }
    
    
    func initializeLogin(mqLogin: MqLogin) {
        login = mqLogin
    }
    
    
    
    
    
    
    
    // ----------------------------------------------------------------------
    // CocoaMQTTDelegate functions
    
    
    // For connection status
    func mqtt(_ mqtt: CocoaMQTT, didConnectAck ack: CocoaMQTTConnAck) {
        print("ack: \(ack)")
        
        if ack == .accept {
            print("Ack accepted")
            
            // FOR TESTING
            print("Attempting to send test message...")
            mqtt.publish("TEST", withString: "Test message (new)")
        }
        else {
            print("Ack rejected")
        }
    }
    
    // For when a message is published
    func mqtt(_ mqtt: CocoaMQTT, didPublishMessage message: CocoaMQTTMessage, id: UInt16) {
        print("Message published: \(message.string!.description), id: \(id)")
    }
    
    func mqtt(_ mqtt: CocoaMQTT, didPublishAck id: UInt16) {
        print("id: \(id)")
        print("Message received")
    }
    
    
    
    
    
    func mqtt(_ mqtt: CocoaMQTT, didSubscribeTopics success: NSDictionary, failed: [String]) {
        print("topic: \(success)")
    }
    
    func mqtt(_ mqtt: CocoaMQTT, didUnsubscribeTopics topics: [String]) {
        print("topic: \(topics)")
    }
    
    func mqtt(_ mqtt: CocoaMQTT, didReceiveMessage message: CocoaMQTTMessage, id: UInt16) {
//            print("message received: \(message.string.description), id: \(id)")
//            if let str = message.string { // <--- here or something like this
//                self.message = str
//            }
    }
    
//        func mqtt(_ mqtt: CocoaMQTT, didSubscribeTopics success: NSDictionary, failed: [String]) {
//            print("didSubscribeTopics")
//        }
    
    func mqtt(_ mqtt: CocoaMQTT, didUnsubscribeTopic topic: String) {
        print("didUnsubscribeTopic")
    }
    
    func mqttDidPing(_ mqtt: CocoaMQTT) {
    }
    
    func mqttDidReceivePong(_ mqtt: CocoaMQTT) {
    }
    
    func mqttDidDisconnect(_ mqtt: CocoaMQTT, withError err: Error?) {
        print("\(err!)")
        print("\tHost: \(mqtt.host)\n\tPort: \(mqtt.port)")
        
    }
    
    
    
    
    
    
    
    
    
    
    
    
    
    
//    func mqtt(_ mqtt: CocoaMQTT, didConnect host: String, port: Int) {
//        print("Got to didConnect()")
//    }
//    
//    func mqtt(_ mqtt: CocoaMQTT, didSubscribeTopics success: NSDictionary, failed: [String]) {
//    }
//        
//    func mqtt(_ mqtt: CocoaMQTT, didUnsubscribeTopics topics: [String]) {
//    }
//    
//    func mqtt(_ mqtt: CocoaMQTT, didConnectAck ack: CocoaMQTTConnAck) {
//        if ack == .accept {
//            print("Connection was successful")
//        }
//        else {
//            print("Failed to connect")
//            print(ack)
//        }
//        
//    }
//    
//    func mqtt(_ mqtt: CocoaMQTT, didPublishMessage message: CocoaMQTTMessage, id: UInt16) {
//    }
//    
//    func mqtt(_ mqtt: CocoaMQTT, didPublishAck id: UInt16) {
//    }
//    
//    func mqtt(_ mqtt: CocoaMQTT, didReceiveMessage message: CocoaMQTTMessage, id: UInt16) {
//    }
//        
//    func mqtt(_ mqtt: CocoaMQTT, didUnsubscribeTopic topic: String) {
//    }
//    
//    func mqttDidPing(_ mqtt: CocoaMQTT) {
//    }
//    
//    func mqttDidReceivePong(_ mqtt: CocoaMQTT) {
//    }
//    
//    func mqttDidDisconnect(_ mqtt: CocoaMQTT, withError err: Error?) {
//    }
    
    
    
    
    // ----------------------------------------------------------------------
    
    
    
}
