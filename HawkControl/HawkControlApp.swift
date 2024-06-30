//
//  HawkControlApp.swift
//  HawkControl
//
//  Created by Farhan Jamil on 6/28/24.
//

import SwiftUI

@main
struct HawkControlApp: App {
    @StateObject private var robotConnection = GlobalStateVars()
    @StateObject private var webSocketManager = WebSocketManager()
    
    var body: some Scene {
        WindowGroup {
            TabView {
                ConnectView()
                    .environmentObject(robotConnection)
                    .tabItem {
                        Text("Connect")
                    }
                    .tag(1)

                RobotPanelView()
                    .environmentObject(robotConnection)
                    .environmentObject(webSocketManager)
                    .tabItem {
                        Text("Control")
                    }
                    .tag(2)

                Text("Test")
                    .environmentObject(robotConnection)
                    .tabItem {
                        Text("Settings")
                    }
                    .tag(3)
                }
                .tag(3)
            }
        }
    }
