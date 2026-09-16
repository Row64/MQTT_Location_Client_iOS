//
//  ContentView.swift
//  Location Client iOS
//
//  Created by row64 on 9/2/26.
//

import SwiftUI
import CocoaMQTT

struct ContentView: View {
    
    // Login variables
    @State private var inputHost: String = ""
    @State private var inputPort: String = ""
    @State private var inputUser: String = ""
    @State private var inputPass: String = ""
    
    // UI toggle trackers
    @State private var isPasswordVisible: Bool = false
    @State var toggleConnectBtn: Bool = true
    @State var toggleLocationBtn: Bool = true
    @State var enableConnectBtn: Bool = true
    @State var enableLocationBtn: Bool = false
    @State var enableFormFields: Bool = true
    
    // MQTT objects
    private var login = MqLogin()
    @State var client = MqClient()
    
    // Location object
    private var location = LocationManager()
//    @State private var location: LocationManager
    
    // Status message variable
    @State public var statusMsg: String = "Status messages appear here..."
    
    
    var body: some View {
        
        Form {
            
            Text("Row64 Location Client")
            
            // Text fields
            // https://developer.apple.com/documentation/swiftui/textfield
            
            
            // Host field
            TextField(
                    "Host",
                    text: $inputHost
                )
                .onSubmit { }
                .textInputAutocapitalization(.never)
                .disableAutocorrection(true)
//                .border(.secondary)
                .textFieldStyle(.roundedBorder)
                .foregroundStyle(enableFormFields ? .blue: .gray)
                .disabled(!enableFormFields)
                            
            
            // Port field
            TextField(
                    "Port",
                    text: $inputPort
                )
                .onSubmit { }
                .textInputAutocapitalization(.never)
                .disableAutocorrection(true)
//                .border(.secondary)
                .textFieldStyle(.roundedBorder)
                .foregroundStyle(enableFormFields ? .blue: .gray)
                .disabled(!enableFormFields)
                
            
            
            // User field
            TextField(
                    "Username",
                    text: $inputUser
                )
                .onSubmit { }
                .textInputAutocapitalization(.never)
                .disableAutocorrection(true)
//                .border(.secondary)
                .textFieldStyle(.roundedBorder)
                .foregroundStyle(enableFormFields ? .blue: .gray)
                .disabled(!enableFormFields)
            
            
            // Password field
            HStack {
                SecureField(
                    "Password",
                    text: $inputPass
                )
                .onSubmit { }
//                .border(.secondary)
                .textFieldStyle(.roundedBorder)
                .foregroundStyle(enableFormFields ? .blue: .gray)
                .disabled(!enableFormFields)
                
                // Password reveal button
                Button {
                    isPasswordVisible.toggle()
                } label: {
                    Image(systemName: isPasswordVisible ? "eye.slash" : "eye")
                        .foregroundColor(.gray)
                    }
                
                
                }
            
            // Password visibility
            if isPasswordVisible {
                TextField("Reveal password", text: $inputPass)
                    .foregroundStyle(.gray)
            } else {
//                SecureField("Reveal password", text: $inputPass)
            }
                
            
            // Connect button
            Button {
                
                if (toggleConnectBtn) {
                    print("Connect button clicked") // For testing
                    
                    // Clear any existing credential data before submitting
                    login.clearCredentials()
                    
                    // Disable login fields
                    enableFormFields = false
                    
                    // Attempt to set the credentials
                    // Setting the port throws an exception if invalid
                    do {
                        try login.setCredentials(
                            inputHost: inputHost,
                            inputPort: inputPort,
                            inputUser: inputUser,
                            inputPass: inputPass
                            )
                    }
                    catch MqCredentialsError.missingRequired {
                        statusMsg = "ERROR: Host and port are required. Additionally provide a username and password if your broker requires authentication."
                        return
                    }
                    catch MqCredentialsError.badPort {
                        statusMsg = "ERROR: Invalid port detected. Please input a valid port number within the range 1 to 65,535"
                        return
                    }
                    catch {
                        statusMsg = "ERROR: Unexpected credential error"
                        return

                    }
                    
                    // Assign login to MQTT client
                    client.setLogin(mqLogin: login)
                    
                    // Initialize this view in the client class
                    client.setView(v: self)
                    
                    
                    // Attempt to establish a connection
    //                statusMsg = "Attempting to connect..."
                    client.connectToBroker()

                    // toggle button?


                }
                else {
                    // For disconnect
                    
                    
                    // Disconnect from broker
                    client.disconnect()
                    
                    statusMsg = "Disconnected from the broker."
                    
                    // After successful disconnect, toggle the button
                    // (maybe put in the delegate, not here?)
//                    toggleConnectBtn.toggle()
                    
                    // ...
                }
                
                
                
                
                
            }
            label: {
//                Text("Connect")
//                    .padding(.all)
//                    .background(.blue)
//                    .foregroundColor(.white)
//                    .cornerRadius(16)
                
                
                
                // Connect
                if (toggleConnectBtn) {
                    Text("Connect")
                        .padding(.all)
                        .background(.blue)
                        .foregroundColor(.white)
                        .cornerRadius(16)
                }
                // Disconnect
                else {
                    Text("Disconnect")
                        .padding(.all)
                        .background(.red)
                        .foregroundColor(.white)
                        .cornerRadius(16)
                }
                
                
            }
//            .disabled(enableConnectBtn)
            
            
            
            
            
            
            
            // Location updates button
            Button {
                
//                location.startLocationUpdates()
                
                /**
                 Initialize this view in the location class so that it can send location updates
                 to the MQTT broker using this view's client instance.
                 
                 startLocationUpdates() gets location and returns location to its delegate, which then
                 references view.client to access the client's send method.
                 */
                location.setView(v: self)
                
                
                if (toggleLocationBtn == true) {
                    location.startLocationUpdates()
                    toggleLocationBtn.toggle()
                }
                else {
                    location.stopLocationUpdates()
                    toggleLocationBtn.toggle()
                }
                
            } label: {
//                Text("Send location updates")
//                    .padding(.all)
//                    .background(.blue)
//                    .foregroundColor(.white)
//                    .cornerRadius(16)
                
                if (toggleLocationBtn == true) {
                    Text("Send location updates")
                        .padding(.all)
                        .background(.blue)
                        .foregroundColor(.white)
                        .cornerRadius(16)
                }
                else {
                    Text("Stop location updates")
                        .padding(.all)
                        .background(.red)
                        .foregroundColor(.white)
                        .cornerRadius(16)
                }
                
                
                
                
            }
            
            
            
            
            
            
            // System message output text field
            Text(statusMsg)

            
            
        }
        .padding()
    }
    
    
}

#Preview {
    ContentView()
}
