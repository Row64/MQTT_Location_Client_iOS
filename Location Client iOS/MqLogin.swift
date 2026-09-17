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
        port = 0
        user = ""
        pass = ""
    }
    
    // Login variables
    private var host: String
    private var port: UInt16
    private var user: String
    private var pass: String
    
    
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
        
        // Verify that requird credentials are present
        // Host and port are required. Username and password are optional
        if (inputHost.isEmpty || inputHost.isEmpty) {
            throw MqCredentialsError.missingRequired
        }
        
        
        // Assign inputted variables to login variables
        host = inputHost
        user = inputUser
        pass = inputPass
        
        
        // Convert port (String) to integer
        // Failed conversion does not throw an error, but is an optional Int
        // Use nil coalescing to assign a value for failed conversion
        // Use an out-of-range port number to signify an error
        port = UInt16(inputPort) ?? 0
        
        
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
     2 = Basic authentication (username & password)
     -1 = Error
     */
    func getAuthMethod() -> Int {
        if user.isEmpty {
            print("Detected authentication: No authentication")
            return 0
        }
        else if !user.isEmpty && pass.isEmpty {
            print("Detected authentication: Username, no password")
            return 1
        }
        else if !user.isEmpty && !pass.isEmpty {
            print("Detected authentication: Basic authentication")
            return 2
        }
        else {
            print("Detected authentication: ERROR")
            return -1
        }
    }
    
    
    /**
     Reset the variables.
     
     The login variables should be wiped on every login attempt.
     Otherwise, old credentials will be carried over to a new login attempt.
     */
    func clearCredentials() {
        host = ""
        port = 0
        user = ""
        pass = ""
    }
    
    
    func getHost() -> String { return host }
    func getPort() -> UInt16 { return port }
    func getUser() -> String { return user }
    func getPass() -> String { return pass }
    
}
