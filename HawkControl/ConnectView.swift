//
//  ConnectView.swift
//  HawkControl
//
//  Created by Farhan Jamil on 6/28/24.
//

import SwiftUI

struct ConnectView: View {
    @EnvironmentObject var robotConnection: GlobalStateVars
    @State private var ip: String = ""
    @State private var port: String = "5810" // default networktables 4 port
    
    @State private var showingAlert = false
    @State private var includeSecondary = false
    @State private var alertTitle = ""
    @State private var alertText = ""
    @State private var primaryButtonText = ""
    
    func showAlert(title: String, message: String, primaryButton: String?, includeSecondary: Bool) {
        alertTitle = title
        alertText = message
        primaryButtonText = primaryButton ?? "OK"
        self.includeSecondary = includeSecondary
        
        
        showingAlert = true
    }
    
    func connectToRobot() {
        if ip.isEmpty || port.isEmpty {
            showAlert(title: "Failed to Connect to Robot",
                      message: "Failed to connect because either IP or PORT is blank",
                      primaryButton: nil,
                      includeSecondary: false)
            return
        }
        
        // connection to networktables logic
        robotConnection.connectedToRobot.toggle()
    }

 
    var body: some View {
        HStack {
            VStack {
                Image(systemName: !robotConnection.connectedToRobot ? "network.slash" : "network")
                    .imageScale(.large)
                    .foregroundStyle(.tint)
                Text("Robot Status: " + (robotConnection.connectedToRobot ? "Connected" : "Disconnected")).bold()
                HStack(alignment: .center) {
                    TextField("IP", text: $ip)
                        .frame(width: 150.0, height: 50.0)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                    TextField("PORT", text: $port)
                        .frame(width: 100.0, height: 50.0)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .multilineTextAlignment(.center)
                }
                if !robotConnection.connectedToRobot {
                    Button(action: connectToRobot) {
                        Label("Connect To Robot", systemImage: "arrow.up")
                    }.padding(5)
                } else {
                    Button(action: connectToRobot) {
                        Label("Disconnect From Robot", systemImage: "arrow.down")
                    }.padding(5)
                }
            }.padding(.all, 20)
            Image("Logo")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 200, height: 200)
                .cornerRadius(20)
            
            
                .alert(isPresented: $showingAlert) {
                    Alert(
                        title: Text(alertTitle),
                        message: Text(alertText),
                        dismissButton: .default(Text(primaryButtonText))
                    )
                }
        }.padding()
    }
}

#Preview {
    ConnectView()
}
