//
//  HawkControlApp.swift
//  HawkControl
//
//  Created by Farhan Jamil on 6/28/24.
//

import SwiftUI

@main
struct HawkControlApp: App {
    var body: some Scene {
        WindowGroup {
            TabView {
                ConnectView()
                    .tabItem {
                        Text("Connect")
                    }
                    .tag(1)
                RobotPanelView()
                    .tabItem {
                        Text("Control")
                    }
                    .tag(2)
                LoggingView()
                    .tabItem {
                        Text("Logs")
                    }
                    .tag(3)
                SettingsView()
                    .tabItem {
                        Text("Settings")
                    }
                    .tag(4)
                }
            }
        }
    }
