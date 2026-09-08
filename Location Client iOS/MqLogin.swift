//
//  MqLogin.swift
//  Location Client iOS
//
//  Created by row64 on 9/3/26.
//

import Foundation

class MqLogin {
    
    init() {
        host = ""
        port = -1
        user = ""
        pass = ""
    }
    
    // Login variables
    private var host: String
    private var port: Int
    private var user: String
    private var pass: String
    
    // Status messages
//    var statusMsg: String = "Status messages appear here..."
    
    
    /**
     Retrieve the login and assign to the class' variables.
     
     Perform a basic syntax check for the port number.
     */
    func setCredentials(
        inputHost: String,
        inputPort: String,
        inputUser: String,
        inputPass: String
    ) throws
    {
        // Assign inputted variables to login variables
        host = inputHost
        user = inputUser
        pass = inputPass
        
        
        // Convert port (String) to integer
        // Failed conversion does not throw an error, but is an optional Int
        // Use nil coalescing to force a value for failed conversion
        // Use an out-of-range port number to signify an error
        port = Int(inputPort) ?? -1
        
        
        // Check that port is within valid range
        if !(1...65535 ~= port) {
            print("Bad port detected")
            throw MqCredentialsError.badPort
        }
            
        
        
        
        
    }
    
    
    
    
    
    
    /**
     This function determines which authentication method to attempt, based on the username
     and password combination, if present.
     
     MQTT brokers support no authentication, username-only authentication, or basic authentication,
     which uses both a username and a password.
     
     A user cannot authenticate using a password and no username.
     
     This function returns an integer that signifies which authentication method was detected:
     0 = No authentication
     1 = Username only
     2 = Basic authentication (username & password
     */
    func getAuthMethod() -> Int {
        
        
        return 0
    }
    
    
    
    
    
    /**
     Reset the variables.
     
     The login variables should be wiped on every login attempt.
     Otherwise, old credentials will be carried over to a new login attempt.
     */
    func clearCredentials() {
        
    }
    
    
    
    /**
     Sets the value of the status message.
     
     Can also be used to log messages in the future...
     */
//    func logStatusMsg(msg: String) {
//        statusMsg = msg
//        
//        // Log message ...
//        // ...
//    }
    
    
    /**
     Retrieve the status message
     */
//    func getStatusMsg() -> String {
//        return statusMsg
//    }
    
    
    
}
