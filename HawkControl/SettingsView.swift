//
//  SettingsView.swift
//  HawkControl
//
//  Created by Farhan Jamil on 6/29/24.
//

import SwiftUI

struct SettingsView: View {
    @ObservedObject var stateVars = GlobalStateVars.shared
    @ObservedObject var logger = Logger.shared
    
    var body: some View {
        ScrollView {
            VStack(alignment: .center) {
                Toggle(isOn: $stateVars.useGyroForControl) {
                    Text("Use Gyro Control")
                }.padding(30)
            }
        }
    }
}

#Preview {
    SettingsView()
}
