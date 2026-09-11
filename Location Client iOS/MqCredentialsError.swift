//
//  MqCredentialsError.swift
//  Location Client iOS
//
//  Created by row64 on 9/4/26.
//

enum MqCredentialsError: Error {
    
    // Throw when required credentials are missing
    case missingRequired
    
    // Throw for invalid port range
    case badPort
    
    // Throw when variables are not properly initialized
    case loginNotInitialized
    
}
