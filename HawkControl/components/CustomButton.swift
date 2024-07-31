//
//  CustomButton.swift
//  HawkControl
//
//  Created by Farhan Jamil on 7/28/24.
//

import SwiftUI
import UIKit

struct CustomButton: UIViewRepresentable {
    var title: String
    var onPress: () -> Void
    var onRelease: () -> Void

    func makeUIView(context: Context) -> UIButton {
        let button = UIButton(type: .system)
        button.setTitle(title, for: .normal)
        button.addTarget(context.coordinator, action: #selector(Coordinator.buttonPressed), for: [.touchDown, .touchDragInside])
        button.addTarget(context.coordinator, action: #selector(Coordinator.buttonReleased), for: [.touchUpInside, .touchUpOutside, .touchCancel, .touchDragExit])
        return button
    }

    func updateUIView(_ uiView: UIButton, context: Context) {
        // update button if needed
    }

    func makeCoordinator() -> Coordinator {
        Coordinator(onPress: onPress, onRelease: onRelease)
    }

    class Coordinator: NSObject {
        var onPress: () -> Void
        var onRelease: () -> Void

        init(onPress: @escaping () -> Void, onRelease: @escaping () -> Void) {
            self.onPress = onPress
            self.onRelease = onRelease
        }

        @objc func buttonPressed() {
            onPress()
        }

        @objc func buttonReleased() {
            onRelease()
        }
    }
}
