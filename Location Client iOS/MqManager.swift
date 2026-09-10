//
//  MqManager.swift
//  Location Client iOS
//
//  Created by row64 on 9/9/26.
//

import CocoaMQTT
import Foundation
internal import Combine

class MqManager: ObservableObject, CocoaMQTTDelegate {
    
    let mqtt = CocoaMQTT(
        clientID: "CocoaMQTT5-" + String(ProcessInfo.processInfo.processIdentifier),
        host: "5ab2c7f979c54060853470b0b4318d98.s1.eu.hivemq.cloud",
        port: 8883 // 8883 = MQTT over TLS/SSL
    )
    
//    var mqttClient: CocoaMQTT!
    
    
        
//        @Published var message = ""
        
        init() {
            // ...
            mqtt.keepAlive = 60
            mqtt.delegate = self
            
            mqtt.username = "row64"
            mqtt.password = "password"
            
            mqtt.enableSSL = true
            mqtt.autoReconnect = true
//            mqtt.willMessage = CocoaMQTTMessage(topic: "/will", string: "dieout")
            
            print("FOR TESTING:")
            print("\(mqtt.host)\n\(mqtt.port)\n\(mqtt.username!)\n\(mqtt.password!)")
        }
    
    
    
//    func connectMQTT() {
//        
//    }
    
    
    
    
    // .... CocoaMQTTDelegate functions ....
    
    // For connection status
    func mqtt(_ mqtt: CocoaMQTT, didConnectAck ack: CocoaMQTTConnAck) {
        print("ack: \(ack)")
        
        if ack == .accept {
            print("Ack accepted")
            
            // FOR TESTING
            print("Attempting to send test message...")
            mqtt.publish("TEST", withString: "Test message")
        }
        else {
            print("Ack rejected")
        }
    }
    
    // For when a message is published
    func mqtt(_ mqtt: CocoaMQTT, didPublishMessage message: CocoaMQTTMessage, id: UInt16) {
        print("message published: \(message.string!.description), id: \(id)")
    }
    
    func mqtt(_ mqtt: CocoaMQTT, didPublishAck id: UInt16) {
        print("id: \(id)")
        print("Message received?")
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
}
