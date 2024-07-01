//
//  RobotPanelView.swift
//  HawkControl
//
//  Created by Farhan Jamil on 6/28/24.
//

import SwiftUI

struct RobotPanelView: View {
    @ObservedObject var stateVars: GlobalStateVars = GlobalStateVars.shared
    let webSocketManager = WebSocketManager.shared

    var body: some View {
        VStack {
            if stateVars.connectedToRobot {
                Button(action: {
                    sendMoveCommand(key: "dir", value: "1.0")
                }) {
                    Label("Forward", systemImage: "arrow.up")
                }.padding()
                Button(action: {
                    sendMoveCommand(key: "dir", value: "-1.0")
                }) {
                    Label("Backward", systemImage: "arrow.down")
                }.padding()
                Button(action: {
                    sendMoveCommand(key: "rot", value: "1.0")
                }) {
                    Label("Left", systemImage: "arrow.left")
                }.padding()
                Button(action: {
                    sendMoveCommand(key: "rot", value: "-1.0")
                }) {
                    Label("Right", systemImage: "arrow.right")
                }.padding()
                Button(action: {
                    sendMoveCommand(key: "dir", value: "0.0")
                    sendMoveCommand(key: "rot", value: "0.0")
                }) {
                    Label("Stop", systemImage: "exclamationmark.octagon.fill")
                }.padding()
                
            } else {
                Label("Please connect to your robot", systemImage: "exclamationmark.triangle.fill")
                    .bold()
            }
        }
    }
    
    func sendMoveCommand(key: String, value: String) {
        webSocketManager.sendData(key: key, value: value)
    }
}

struct RobotPanelView_Previews: PreviewProvider {
    static var previews: some View {
        RobotPanelView()
    }
}
