//
//  ElevatorLevelRepresentable.swift
//  HawkControl
//
//  Created by Farhan Jamil on 8/15/24.
//

import SwiftUI

struct ElevatorLevelRepresentable: UIViewRepresentable {
    @Binding var level: CGFloat

    func makeUIView(context: Context) -> ElevatorLevelView {
        let view = ElevatorLevelView()
        return view
    }

    func updateUIView(_ uiView: ElevatorLevelView, context: Context) {
        uiView.level = level
    }
}
