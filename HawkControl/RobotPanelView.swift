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
    
//    @State private var elevatorLevel: CGFloat = handleElevatorLevel()
    // home 0.1
    // amp 0.5
    // climb 0.9
    
    var body: some View {
        VStack {
            if stateVars.connectedToRobot {
                // Top section for live camera feeds
                HStack {
                    VStack {
                        Text("Shooter Feed")
                        if let shooterStreamURL = URL(string: GlobalStateVars.shared.shooterStreamURL) {
                            LimelightStreamView(url: shooterStreamURL)
                                .frame(width: 400, height: 400)
                        } else {
                            Text("Invalid URL for Shooter Stream")
                                .frame(width: 400, height: 400)
                                .background(Color.gray)
                        }
                    }
                    VStack {
                        Text("AMP Feed")
                        if let ampStreamURL = URL(string: GlobalStateVars.shared.ampStreamURL) {
                            LimelightStreamView(url: ampStreamURL)
                                .frame(width: 400, height: 400)
                        } else {
                            Text("Invalid URL for Amp Stream")
                                .frame(width: 400, height: 400)
                                .background(Color.gray)
                        }
                    }
                    
                    // VStack for Elevator Level Indicator with Labels
                    VStack(alignment: .center) {
                        Text("Elevator Location")
                            .font(.headline)
                            .padding(.bottom, 10)

                        HStack {
                            VStack(alignment: .trailing) {
                                Spacer()
                                Text("Climb")
                                    .padding(.bottom, 40)
                                Spacer()
                                Text("AMP")
                                    .padding(.bottom, 40)
                                Spacer()
                                Text("Home")
                                Spacer()
                            }
                            .padding(.trailing, 5)

                            ElevatorLevelRepresentable(level: .constant(handleElevatorLevel()))
                                .frame(width: 100, height: 300)
                                .background(Color.white)
                                .cornerRadius(10)
                        }
                    }.padding(.leading, 50)
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
                                    handleFlashState()
                                }
                                .onChange(of: GlobalStateVars.shared.noteStatus) { newValue in
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
                            
                            VStack {
                                CustomButton(
                                    title: "Elevator Home",
                                    onPress: {
                                        sendMoveCommand(key: "elevatorHome", value: "true")
                                    },
                                    onRelease: {
                                        sendMoveCommand(key: "elevatorHome", value: "false")
                                    }
                                )
                                .frame(width: 200, height: 100)
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
                                .frame(width: 200, height: 100)
                                .background(Color.white)
                                .foregroundColor(.white)
                                .cornerRadius(10)
                            }
                            
                            VStack {
                                CustomButton(
                                    title: "Intake from Human",
                                    onPress: {
                                        sendMoveCommand(key: "intakeFromHuman", value: "true")
                                    },
                                    onRelease: {
                                        sendMoveCommand(key: "intakeFromHuman", value: "false")
                                    }
                                )
                                .frame(width: 200, height: 66.6666666667)
                                .background(Color.white)
                                .foregroundColor(.white)
                                .cornerRadius(10)
                                
                                CustomButton(
                                    title: "Manual Intake",
                                    onPress: {
                                        sendMoveCommand(key: "manualIntake", value: "true")
                                    },
                                    onRelease: {
                                        sendMoveCommand(key: "manualIntake", value: "false")
                                    }
                                )
                                .frame(width: 200, height: 66.6666666667)
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
                                .frame(width: 200, height: 66.6666666667)
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
                            sendMoveCommand(key: "elevatorHome", value: "false")
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
    
    private func handleElevatorLevel() -> CGFloat {
        switch GlobalStateVars.shared.elevatorLevel {
            case "Home":
                return 0.1
            case "AMP":
                return 0.5
            case "Climb":
                return 0.9
            default:
                return 0.1
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
