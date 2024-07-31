//
//  RobotPanelView.swift
//  HawkControl
//
//  Created by Farhan Jamil on 6/28/24.
//

import SwiftUI
import UIKit

struct RobotPanelView: View {
    @ObservedObject var stateVars: GlobalStateVars = GlobalStateVars.shared
    let webSocketManager = WebSocketManager.shared

    var body: some View {
        VStack {
            if stateVars.connectedToRobot {
                HStack {
                    CustomButton(
                        title: "Podium Shot",
                        onPress: {
                            sendMoveCommand(key: "podiumShot", value: "true")
                        },
                        onRelease: {
                            sendMoveCommand(key: "podiumShot", value: "false")
                        }
                    )
                    .frame(width: 200, height: 200)
                    .background(.white)
                    .foregroundColor(.white)
                    .cornerRadius(10)
                    
                    CustomButton(
                        title: "Subwoofer Shot",
                        onPress: {
                            sendMoveCommand(key: "subwooferShot", value: "true")
                        },
                        onRelease: {
                            sendMoveCommand(key: "subwooferShot", value: "false")
                        }
                    )
                    .frame(width: 200, height: 200)
                    .background(Color.white)
                    .foregroundColor(.white)
                    .cornerRadius(10)
                }
                Button(action: {
                    sendMoveCommand(key: "subwooferShot", value: "false")
                    sendMoveCommand(key: "ferryShot", value: "false")
                    sendMoveCommand(key: "podiumShot", value: "false")
                }) {
                    Label("Emergency Stop", systemImage: "exclamationmark.octagon.fill")
                }.padding()
                
                Text(verbatim: "Note Status:  \(GlobalStateVars.shared.noteStatus)")
                Text(verbatim: "Robot Status:  \(GlobalStateVars.shared.robotState)")
                Text(verbatim: "Is Ready to Shoot:  \(GlobalStateVars.shared.isReadyToShoot)")
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
