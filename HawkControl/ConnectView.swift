//
//  ConnectView.swift
//  HawkControl
//
//  Created by Farhan Jamil on 6/28/24.
//

import SwiftUI
    
struct ConnectView: View {
    @ObservedObject var stateVars: GlobalStateVars = GlobalStateVars.shared
    let webSocketManager = WebSocketManager.shared
    @State private var ip: String = "192.168.1.175" // dev ip
    @State private var port: String = "8766" // WebSocket port

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
    
    func sendValue(key: String, value: String) {
        webSocketManager.sendData(key: key, value: value)
    }
    

    func connectToRobot() {
        if ip.isEmpty || port.isEmpty {
            showAlert(title: "Failed to Connect to Robot",
                      message: "Failed to connect because either IP or PORT is blank",
                      primaryButton: nil,
                      includeSecondary: false)
            return
        }

        webSocketManager.connect(ip: ip, port: port)
    }

    func disconnectFromRobot() {
        webSocketManager.disconnect()
    }

    var body: some View {
        HStack {
            VStack {
                Image(systemName: !stateVars.connectedToRobot ? "network.slash" : "network")
                    .imageScale(.large)
                    .foregroundStyle(.tint)
                Text("Robot Status: " + (stateVars.connectedToRobot ? "Connected" : "Disconnected")).bold()
                HStack(alignment: .center) {
                    TextField("IP", text: $ip)
                        .frame(width: 150.0, height: 50.0)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                    TextField("PORT", text: $port)
                        .frame(width: 100.0, height: 50.0)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .multilineTextAlignment(.center)
                }
                if !stateVars.connectedToRobot {
                    Button(action: connectToRobot) {
                        Label("Connect To Robot", systemImage: "arrow.up")
                    }.padding(5)
                } else {
                    Button(action: disconnectFromRobot) {
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
    ConnectView().environmentObject(GlobalStateVars())
}
