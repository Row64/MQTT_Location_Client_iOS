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

class MqClient {
    
    let login: MqLogin
    let authMethod: Int
    
    init(inputLogin: MqLogin) {
        login = inputLogin
        authMethod = login.getAuthMethod()
    }
    
    
    
    // ----------------------------------------------------------------------
    // CONNECT METHODS
    
    /**
     Attempt to connect to a broker based on the detected authentication method.
     
     For all authentication methods, first try to connect using MQTT v5. If the connection fails, try the connection
     with v3.1.1.
     */
    func connectToBroker() {
        
    }
    
    
    
    
    
    
    // ----------------------------------------------------------------------
    
    
    
}
