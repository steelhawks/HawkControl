//
//  RobotPanelView.swift
//  HawkControl
//
//  Created by Farhan Jamil on 6/28/24.
//

import SwiftUI
import UIKit
import AVKit

struct RobotPanelView: View {
    @ObservedObject var stateVars: GlobalStateVars = GlobalStateVars.shared
    let webSocketManager = WebSocketManager.shared

    @State private var flash = false
    @State private var timer: Timer?
    
    var body: some View {
        VStack {
            if stateVars.connectedToRobot {
                // Top section for live camera feeds
                HStack {
                    VStack {
                        Text("Live Camera Feed 1")
                        if let shooterStreamURL = URL(string: GlobalStateVars.shared.shooterStreamURL) {
                            LimelightStreamView(url: shooterStreamURL)
                                .frame(height: 400)
                        } else {
                            Text("Invalid URL for Shooter Stream")
                                .frame(height: 400)
                                .background(Color.gray)
                        }
                    }
                    VStack {
                        Text("Live Camera Feed 2")
                        if let ampStreamURL = URL(string: GlobalStateVars.shared.ampStreamURL) {
                            LimelightStreamView(url: ampStreamURL)
                                .frame(height: 400)
                        } else {
                            Text("Invalid URL for Amp Stream")
                                .frame(height: 400)
                                .background(Color.gray)
                        }
                    }
                }
                .padding()
                
                Spacer()
                
                // Bottom section for statuses and controls
                HStack {
                    // Left section for robot statuses
                    VStack(alignment: .leading) {
                        HStack {
                            Text(verbatim: "Note Status:  \(GlobalStateVars.shared.noteStatus)")
                            
                            Rectangle()
                                .fill(GlobalStateVars.shared.noteStatus == "INTAKEN" ? (flash ? Color.green : Color.clear) : Color.red)
                                .frame(width: 20, height: 20)
                                .animation(
                                    Animation.easeInOut(duration: 0.25)
                                        .repeatForever(autoreverses: true),
                                    value: flash
                                )
                                .onAppear {
                                    // Handle flashing when view first appears
                                    handleFlashState()
                                }
                                .onChange(of: GlobalStateVars.shared.noteStatus) { newValue in
                                    // Handle flashing state changes
                                    handleFlashState()
                                }
                        }
                        
                        Text(verbatim: "Robot Status:  \(GlobalStateVars.shared.robotState)")
                        HStack {
                            Text("Is Ready to Shoot: ")
                            Rectangle()
                                .fill(GlobalStateVars.shared.isReadyToShoot == "Yes" ? Color.green : Color.red)
                                .frame(width: 20, height: 20)
                        }
                    }
                    .padding()
                    
                    Spacer()
                    
                    // Right section for button presses
                    VStack {
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
                            .background(Color.white)
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
                            
                            CustomButton(
                                title: "Note to Amp",
                                onPress: {
                                    sendMoveCommand(key: "noteToAmp", value: "true")
                                },
                                onRelease: {
                                    sendMoveCommand(key: "noteToAmp", value: "false")
                                }
                            )
                            .frame(width: 200, height: 200)
                            .background(Color.white)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                            
                            VStack {
                                CustomButton(
                                    title: "Manual Intake",
                                    onPress: {
                                        sendMoveCommand(key: "manualIntake", value: "true")
                                    },
                                    onRelease: {
                                        sendMoveCommand(key: "manualIntake", value: "false")
                                    }
                                )
                                .frame(width: 200, height: 100)
                                .background(Color.white)
                                .foregroundColor(.white)
                                .cornerRadius(10)
                                
                                CustomButton(
                                    title: "Reverse Intake",
                                    onPress: {
                                        sendMoveCommand(key: "reverseIntake", value: "true")
                                    },
                                    onRelease: {
                                        sendMoveCommand(key: "reverseIntake", value: "false")
                                    }
                                )
                                .frame(width: 200, height: 100)
                                .background(Color.white)
                                .foregroundColor(.white)
                                .cornerRadius(10)
                            }
                        }
                        
                        // Emergency Stop Button
                        Button(action: {
                            sendMoveCommand(key: "subwooferShot", value: "false")
                            sendMoveCommand(key: "ferryShot", value: "false")
                            sendMoveCommand(key: "podiumShot", value: "false")
                            sendMoveCommand(key: "noteToAmp", value: "false")
                            sendMoveCommand(key: "manualIntake", value: "false")
                            sendMoveCommand(key: "reverseToIntake", value: "false")
                            
                        }) {
                            Label("Emergency Stop", systemImage: "exclamationmark.octagon.fill")
                        }
                        .padding()
                    }
                }
                .padding()
            } else {
                Label("Please connect to your robot", systemImage: "exclamationmark.triangle.fill")
                    .bold()
            }
        }
        .padding()
    }
    
    private func handleFlashState() {
        if GlobalStateVars.shared.noteStatus == "INTAKEN" {
            flash = true
            scheduleLocalNotification()
        } else {
            flash = false
        }
    }
    
    private func scheduleLocalNotification() {
            let content = UNMutableNotificationContent()
            content.title = "Intake Status Alert"
            content.body = "The intake note status has changed to INTAKEN!"
            content.sound = UNNotificationSound.default

            let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 1, repeats: false)
            
            let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
            UNUserNotificationCenter.current().add(request) { error in
                if let error = error {
                    print("Error scheduling local notification: \(error.localizedDescription)")
                }
            }
        }
    
    private func sendMoveCommand(key: String, value: String) {
        webSocketManager.sendData(key: key, value: value)
    }
}

struct RobotPanelView_Previews: PreviewProvider {
    static var previews: some View {
        RobotPanelView()
    }
}
