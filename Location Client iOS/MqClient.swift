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

class MqClient: CocoaMQTTDelegate, CocoaMQTT5Delegate {
    
    // My login objects
//    var login: MqLogin
//    var authMethod: Int
    
    private var login: MqLogin?
    private var authMethod: Int?
    
    private var view: ContentView?
    
    // MQTT client library objects
//    let clientID: String
//    var connectProperties: MqttConnectProperties
//    var mqtt5: CocoaMQTT5
//    var mqtt: CocoaMQTT
    
//    private var clientID: String = "CocoaMQTT5-" + String(ProcessInfo.processInfo.processIdentifier)
    private var clientID3: String?
    private var clientID5: String?
    private var connectProperties: MqttConnectProperties?   // For v5 connecting (not relevant for v3)
    private var publishProperties: MqttPublishProperties?   // For v5 publishing (not relevant for v3)
    var mqtt: CocoaMQTT?
    var mqtt5: CocoaMQTT5?
    
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
        
        // Initialize the MQTT clients
        // Both clients should be able to be initialized, regardless of the MQTT version needed
        do {
            try initializeMqtt3Client()
            try initializeMqtt5Client()
        }
        catch {
            print("ERROR: Exception caught when initializing MQTT clients. Is the login initialized?")
            print("Aborting connection attempt")
            return
        }
        
        
        // Need to detect auth method
        // ...
        
        
        // Connect based on detected auth method
        
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
        
        // Set credentials for basic authentication
        mqtt!.username = login!.getUser()
        mqtt!.password = login!.getPass()
        mqtt5!.username = login!.getUser()
        mqtt5!.password = login!.getPass()
        
        view?.statusMsg = "Attempting to connect using basic authentication..."
        
        // Try first to connect with v5
        // If v5 connect fails, its delegate will call v3.1.1 connect
        _ = mqtt5!.connect()
        
        
        
        
        
//        print("Attempting to connect with v3.1.1 using basic authentication...")
//        
//        view?.statusMsg = "Attempting to connect with v3.1.1 using basic authentication..."
        
        // MQTT 3 connect
        
//        _ = mqtt!.connect()
        
        
    }
    
    // ----------------------------------------------------------------------
    // Initializing functions
    
    
    func setLogin(mqLogin: MqLogin) { login = mqLogin }
    
    func setView(v: ContentView) { view = v }
    
    private func initializeMqtt3Client() throws {
        
        clientID3 = "CocoaMQTT3-" + String(ProcessInfo.processInfo.processIdentifier)
        
        // Initialize client and properties if login and ID are present
        if (clientID3 != nil && login != nil) {
            
            mqtt = CocoaMQTT(clientID: clientID3!, host: login!.getHost(), port: login!.getPort())
            
            // MQTT v3.1.1 client configuration
            // Login object does not currently take configuration, so preset
            // values are currently used.
            mqtt!.keepAlive = 60
            mqtt!.delegate = self
            mqtt!.enableSSL = true // Important when using port 8883
            mqtt!.autoReconnect = false
            
            print("MQTT 3 client successfully initialized")
        }
        else {
            print("ERROR: Login or client ID has not been initialized")
            throw MqCredentialsError.loginNotInitialized
        }
    }
    
    
    private func initializeMqtt5Client() throws {
        
        clientID5 = "CocoaMQTT5-" + String(ProcessInfo.processInfo.processIdentifier)
        
        // Initialize client and properties if login and ID are present
        if (clientID5 != nil && login != nil) {
            
            mqtt5 = CocoaMQTT5(clientID: clientID5!, host: login!.getHost(), port: login!.getPort())
            
            // Publish properties
            // Default values found at:
            // https://www.emqx.com/en/blog/ios-mqtt5-client#tutorial-implementing-mqtt-50-in-ios-with-cocoamqtt
            publishProperties = MqttPublishProperties()
            publishProperties?.payloadFormatIndicator = .utf8
            publishProperties?.messageExpiryInterval = 60
            publishProperties?.userProperty = ["source": "ios"]
            
            // MQTT v5 client configuration
            // Login object does not currently take configuration, so preset
            // values are currently used.
            mqtt5!.keepAlive = 60
            mqtt5!.delegate = self
            mqtt5!.enableSSL = true // Important when using port 8883
            mqtt5!.autoReconnect = false
            
            print("MQTT 5 client successfully initialized")
        }
        else {
            print("ERROR: Login or client ID has not been initialized")
            throw MqCredentialsError.loginNotInitialized
        }
        
        
    }
    
    
    
    // ----------------------------------------------------------------------
    // CocoaMQTTDelegate functions
    // VERSION 3.1.1
    
    
    // For connection status
    func mqtt(_ mqtt: CocoaMQTT, didConnectAck ack: CocoaMQTTConnAck) {
        
        print("ack: \(ack)")
        
        if ack == .accept {
            print("v3 ack accepted")
            
            view?.statusMsg = "Successfully connected to the broker with v3.1.1"
            
            // FOR TESTING
            print("Attempting to send test message...")
            mqtt.publish("TEST", withString: "Test message from v3.1.1")
        }
        else {
            print("v3 ack rejected")
            view?.statusMsg = "Failed to connect to broker.\nack: \(ack)"
        }
    }
    
    // For when a message is published
    func mqtt(_ mqtt: CocoaMQTT, didPublishMessage message: CocoaMQTTMessage, id: UInt16) {
        print("Message published: \(message.string!.description), id: \(id)")
        view?.statusMsg = "Published message:\n\tMessage:\(message.string!.description)\n\tID: \(id)"
    }
    
    // For receiving messages
    func mqtt(_ mqtt: CocoaMQTT, didPublishAck id: UInt16) {
        print("id: \(id)")
        print("Message received")
    }
    
    // For errors during connection attempt
    func mqttDidDisconnect(_ mqtt: CocoaMQTT, withError err: Error?) {

//        view?.statusMsg += "Error encountered while attempting to connect."
//        
        if (err != nil) {
//            view?.statusMsg += "\n\n\(err!)"
            print("\(err!)")
        }
        
    }
    
    
    
    func mqtt(_ mqtt: CocoaMQTT, didSubscribeTopics success: NSDictionary, failed: [String]) { }
    func mqtt(_ mqtt: CocoaMQTT, didUnsubscribeTopics topics: [String]) { }
    func mqtt(_ mqtt: CocoaMQTT, didReceiveMessage message: CocoaMQTTMessage, id: UInt16) { }
    func mqtt(_ mqtt: CocoaMQTT, didUnsubscribeTopic topic: String) { }
    func mqttDidPing(_ mqtt: CocoaMQTT) { }
    func mqttDidReceivePong(_ mqtt: CocoaMQTT) { }
    
    
    
    // ----------------------------------------------------------------------
    // CocoaMQTTDelegate functions
    // VERSION 5
    
    
    func mqtt5(_ mqtt5: CocoaMQTT5, didConnectAck ack: CocoaMQTTCONNACKReasonCode, connAckData: MqttDecodeConnAck?) {
        
        if ack == .success {
            print("v5 ack accepted")
            
            view?.statusMsg = "Successfully connected to the broker with v5"
            
            // FOR TESTING
            view?.statusMsg += "Attempting to send a test message..."
            print("Attempting to send test message...")
            if (publishProperties != nil) {
                mqtt5.publish(
                    "TEST",
                    withString: "Test message from v5",
                    properties: publishProperties!
                )
            }
            else {
                print("ERROR: Could not publish message. publishProperties is nil. Has publishProperties been initialized?")
            }
            
            
            
        }
        else {
            print("v5 ack rejected")
            view?.statusMsg = "Failed to connect using v5.\nack: \(ack)"
            
            // Attempt to connect using v3.1.1
            view?.statusMsg += "\n\nAttempting to connect using v3.1.1..."
            _ = mqtt!.connect()
            
            
        }
        
    }
    
    
    // For errors
    func mqtt5DidDisconnect(_ mqtt5: CocoaMQTT5, withError err: (any Error)?) {

//        view?.statusMsg = "Error encountered while attempting to connect with v5."
//        
        if (err != nil) {
//            view?.statusMsg += "\n\n\(err!)"
            print("\(err!)")
        }
        
    }
    
    
    // For publishing messages
    func mqtt5(_ mqtt5: CocoaMQTT5, didPublishMessage message: CocoaMQTT5Message, id: UInt16) {
        print("Message published: \(message.string!.description), id: \(id)")
        view?.statusMsg = "Published message:\n\tMessage:\(message.string!.description)\n\tID: \(id)"
    }
    
    
    
    func mqtt5(_ mqtt5: CocoaMQTT5, didPublishAck id: UInt16, pubAckData: MqttDecodePubAck?) { }
    func mqtt5(_ mqtt5: CocoaMQTT5, didPublishRec id: UInt16, pubRecData: MqttDecodePubRec?) { }
    func mqtt5(_ mqtt5: CocoaMQTT5, didReceiveMessage message: CocoaMQTT5Message, id: UInt16, publishData: MqttDecodePublish?) { }
    func mqtt5(_ mqtt5: CocoaMQTT5, didSubscribeTopics success: NSDictionary, failed: [String], subAckData: MqttDecodeSubAck?) { }
    func mqtt5(_ mqtt5: CocoaMQTT5, didUnsubscribeTopics topics: [String], unsubAckData: MqttDecodeUnsubAck?) { }
    func mqtt5(_ mqtt5: CocoaMQTT5, didReceiveDisconnectReasonCode reasonCode: CocoaMQTTDISCONNECTReasonCode) { }
    func mqtt5(_ mqtt5: CocoaMQTT5, didReceiveAuthReasonCode reasonCode: CocoaMQTTAUTHReasonCode) { }
    func mqtt5DidPing(_ mqtt5: CocoaMQTT5) { }
    func mqtt5DidReceivePong(_ mqtt5: CocoaMQTT5) { }
    
    
    
    // ----------------------------------------------------------------------
    
    
    
    
}
